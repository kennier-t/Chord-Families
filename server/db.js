const sql = require('mssql/msnodesqlv8');

const config = {
    connectionString: 'Driver={ODBC Driver 17 for SQL Server};Server=DESKTOP-09RH2IA\\SQLEXPRESS;Database=ChordSmith;Trusted_Connection=yes;CharSet=UTF8;',
    options: {
        trustedConnection: true,
        useUTC: false
    },
    connectionTimeout: 30000,
    requestTimeout: 30000,
    pool: {
        max: 10,
        min: 0,
        idleTimeoutMillis: 30000
    }
};

let pool;

async function connect() {
    try {
        if (pool) {
            return pool;
        }
        pool = await sql.connect(config);
        console.log('✓ Connected to SQL Server');
        return pool;
    } catch (err) {
        console.error('✗ Database connection error:', err);
        process.exit(1);
    }
}

async function query(queryString, params) {
    const pool = await connect();
    const request = pool.request();
    if (params) {
        for (const key in params) {
            request.input(key, params[key]);
        }
    }
    return await request.query(queryString);
}

module.exports = {
    query,
    connect
};