const { Pool } = require("pg");

const pool = new Pool({
  host: "db",
  user: "asset",
  password: "asset",
  database: "assetdb",
  port: 5432,
});

module.exports = pool;
