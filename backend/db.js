// Central MySQL connection pool. Every controller pulls its
// connection from here instead of opening one per request.
require('dotenv').config();
const mysql = require('mysql2/promise');

const pool = mysql.createPool({
  host: process.env.DB_HOST || 'localhost',
  port: process.env.DB_PORT || 3306,
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'wfc353_1',
  waitForConnections: true,
  connectionLimit: 10,
  dateStrings: true, // keep DATE/DATETIME as plain 'YYYY-MM-DD[ HH:MM:SS]' strings
});

module.exports = pool;
