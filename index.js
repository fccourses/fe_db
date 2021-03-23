const path = require('path');
const fs = require('fs').promises;
const _ = require('lodash');
const { User, client, Phone } = require('./models');
const { loadUsers } = require('./api');
const { generatePhones } = require('./utils');

start();

async function start () {
  await client.connect();

  const resetDbQueryString = await fs.readFile(
    path.join(__dirname, '/sql/reset-db-query.sql'),
    'utf8'
  );

  await client.query(resetDbQueryString);

  const users = await User.bulkCreate(await loadUsers());
  const phones = await Phone.bulkCreate(generatePhones());

  /* smell code >>> */
  /* СОЗДАЕМ ЗАКАЗ */
  const ordersValuesString = users
    .map(u => new Array(_.random(1, 5, false)).map(() => `(${u.id})`).join(','))
    .join(',');

  const { rows: orders } = await client.query(`
    INSERT INTO orders ("userId")
    VALUES ${ordersValuesString}
    RETURNING id;
  `);

  /* НАПОЛНЯЕМ ЗАКАЗ ТЕЛЕФОНАМИ */
  const phonesToOrdersValuesString = orders
    .map(o => {
      const arr = new Array(_.random(1, phones.length)).map(
        () => phones[_.random(1, phones.length - 1)]
      );

      return [...new Set(arr)]
        .map(p => `(${o.id}, ${p.id}, ${_.random(1, 4)})`)
        .join(',');
    })
    .join(',');

  await client.query(`
  INSERT INTO phones_to_orders ("orderId", "phoneId", "quantity")
  VALUES ${phonesToOrdersValuesString};
`);

  await client.end();
}
