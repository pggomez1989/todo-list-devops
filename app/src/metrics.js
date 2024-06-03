const promClient = require('prom-client');

// Crear un registro de métricas
const register = new promClient.Registry();
// promClient.collectDefaultMetrics({ register });

const httpRequestDurationMicroseconds = new promClient.Histogram({
    name: 'http_request_duration_microseconds',
    help: 'Duration of HTTP requests in ms',
    labelNames: ['method', 'route', 'status_code'],
    buckets: [0.1, 5, 15, 50, 100, 500, 1000, 3000, 5000] // Buckets for response time from 0.1ms to 5s
});
register.registerMetric(httpRequestDurationMicroseconds);

const requestCounter = new promClient.Counter({
  name: 'requests_total',
  help: 'Total number of requests received',
  labelNames: ['method'],
});
register.registerMetric(requestCounter);

const cpuUsageGauge = new promClient.Gauge({
  name: 'cpu_usage_percentage',
  help: 'CPU usage percentage',
});
register.registerMetric(cpuUsageGauge);

const memoryUsageGauge = new promClient.Gauge({
  name: 'memory_usage_bytes',
  help: 'Memory usage in bytes',
});
register.registerMetric(memoryUsageGauge);

module.exports = {
  register,
  httpRequestDurationMicroseconds,
  requestCounter,
  cpuUsageGauge,
  memoryUsageGauge,
  getCPUUsage: async () => {
    return new Promise((resolve) => {
      const startUsage = process.cpuUsage();
      const startTime = Date.now();

      setTimeout(() => {
        const elapUsage = process.cpuUsage(startUsage);
        const elapTime = Date.now() - startTime;

        const elapTimeMS = elapTime / 1000;
        const elapUserMS = elapUsage.user / 1000;
        const elapSystMS = elapUsage.system / 1000;
        const cpuPercent = ((elapUserMS + elapSystMS) / elapTimeMS) * 100;

        resolve(cpuPercent);
      }, 100);
    });
  }
};
