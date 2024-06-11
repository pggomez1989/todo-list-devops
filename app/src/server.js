const app = require('./app');
const itemsRouter = require('./routes/items');
const db = require('./persistence');
const logger = require('./logger');

const host = process.env.HOSTNAME;

// Rutas
app.use('/items', itemsRouter);

db.init().then(() => {
    const port = process.env.PORT || 3000;
    app.listen(port, () => {
        logger.info(`Server is running on port ${port}. Host: ${host}`);
        console.log(`Listening on port ${port}. Host: ${host}`);
    });
}).catch((err) => {
    logger.error('An error has ocurred', { err });
    console.error(err);
    process.exit(1);
});

const gracefulShutdown = () => {
    db.teardown()
        .catch(() => {})
        .then(() => process.exit());
};

process.on('SIGINT', gracefulShutdown);
process.on('SIGTERM', gracefulShutdown);
process.on('SIGUSR2', gracefulShutdown); // Sent by nodemon
