const app = require('./app');
const itemsRouter = require('./routes/items');
const metrics = require('./metrics');
const db = require('./persistence');

// Rutas
app.use('/items', itemsRouter);

// Ruta para las métricas de Prometheus
app.get('/metrics', async (req, res) => {
    res.set('Content-Type', metrics.contentType);
    res.end(await metrics.register.metrics());
});

db.init().then(() => {
    const port = process.env.PORT || 3000;
    app.listen(port, () => console.log(`Listening on port ${port}`));
}).catch((err) => {
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
