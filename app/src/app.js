const express = require('express');
const app = express();
const { register, httpRequestDurationMicroseconds, requestCounter, cpuUsageGauge, memoryUsageGauge, getCPUUsage } = require('./metrics');

// Middleware para medir la duración de las solicitudes HTTP
app.use((req, res, next) => {
    const end = httpRequestDurationMicroseconds.startTimer();
    res.on('finish', () => {
        end({ 
            method: req.method, 
            route: req.route ? req.route.path : req.originalUrl, 
            status_code: res.statusCode 
        });
    });
    next();
});

// Middleware para contar las solicitudes por método HTTP
app.use((req, res, next) => {
    requestCounter.labels(req.method).inc();
    next();
});

// Middleware para recolectar métricas de CPU y memoria cada 5 segundos
setInterval(async () => {
const cpuUsage = await getCPUUsage();
const memoryUsage = process.memoryUsage().heapUsed;

cpuUsageGauge.set(cpuUsage);
memoryUsageGauge.set(memoryUsage);
}, 5000);

// Ruta para las métricas de Prometheus
app.get('/metrics', async (req, res) => {
    res.set('Content-Type', register.contentType);
    res.end(await register.metrics());
});

app.use(express.json());
app.use(express.static(__dirname + '/static'));

module.exports = app;
