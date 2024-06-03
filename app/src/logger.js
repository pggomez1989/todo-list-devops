const { createLogger, transports, format } = require("winston");
const LokiTransport = require("winston-loki");


const logger = createLogger({
    level: 'info',
    format: format.json(),
    transports: [new LokiTransport({
        host: 'http://loki:3100',
        labels: { app: 'Todo-List'},
        replaceTimestamp: true,
        onConnectionError: (err) => console.error(err)
      }),
      new transports.Console({
        format: format.combine(format.simple(), format.colorize())
      })]
  })

module.exports = logger;
