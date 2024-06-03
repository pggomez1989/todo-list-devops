const express = require('express');
const app = express();
const { httpRequestDurationMicroseconds } = require('./metrics');

app.use((req, res, next) => {
    const end = httpRequestDurationMicroseconds.startTimer();
    res.on('finish', () => {
        end({ method: req.method, route: req.route ? req.route.path : 'unknown', status_code: res.statusCode });
    });
    next();
});

app.use(express.json());
app.use(express.static(__dirname + '/static'));

module.exports = app;
