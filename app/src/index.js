// // Cargar las variables de entorno desde el archivo .env
// require('dotenv').config();

// const express = require('express');
// const promClient = require('prom-client');
// const app = express();

// // Crear un registro de métricas
// const register = new promClient.Registry();
// promClient.collectDefaultMetrics({ register });

// // Definir métricas personalizadas
// const httpRequestDurationMicroseconds = new promClient.Histogram({
//     name: 'http_request_duration_microseconds',
//     help: 'Duration of HTTP requests in ms',
//     labelNames: ['method', 'route', 'status_code'],
//     buckets: [0.1, 5, 15, 50, 100, 500, 1000, 3000, 5000] // Buckets for response time from 0.1ms to 5s
// });
// register.registerMetric(httpRequestDurationMicroseconds);
  
// // Middleware para medir la duración de las solicitudes HTTP
// app.use((req, res, next) => {
// const end = httpRequestDurationMicroseconds.startTimer();
// res.on('finish', () => {
//     end({ method: req.method, route: req.route ? req.route.path : 'unknown', status_code: res.statusCode });
// });
// next();
// });

// const db = require('./persistence');
// const getItems = require('./routes/getItems');
// const addItem = require('./routes/addItem');
// const updateItem = require('./routes/updateItem');
// const deleteItem = require('./routes/deleteItem');

// app.use(express.json());
// app.use(express.static(__dirname + '/static'));

// app.get('/items', getItems);
// app.post('/items', addItem);
// app.put('/items/:id', updateItem);
// app.delete('/items/:id', deleteItem);

// // Ruta para las métricas de Prometheus
// app.get('/metrics', async (req, res) => {
//     res.set('Content-Type', register.contentType);
//     res.end(await register.metrics());
// });

// db.init().then(() => {
//     app.listen(3000, () => console.log('Listening on port 3000'));
// }).catch((err) => {
//     console.error(err);
//     process.exit(1);
// });

// const gracefulShutdown = () => {
//     db.teardown()
//         .catch(() => {})
//         .then(() => process.exit());
// };

// process.on('SIGINT', gracefulShutdown);
// process.on('SIGTERM', gracefulShutdown);
// process.on('SIGUSR2', gracefulShutdown); // Sent by nodemon
