const promClient = require('prom-client');

const register = new promClient.Registry();
promClient.collectDefaultMetrics({ register });

const httpRequestDurationMicroseconds = new promClient.Histogram({
    name: 'http_request_duration_microseconds',
    help: 'Duration of HTTP requests in ms',
    labelNames: ['method', 'route', 'status_code'],
    buckets: [0.1, 5, 15, 50, 100, 500, 1000, 3000, 5000] // Buckets for response time from 0.1ms to 5s
});
register.registerMetric(httpRequestDurationMicroseconds);

module.exports = {
    register,
    httpRequestDurationMicroseconds
};
