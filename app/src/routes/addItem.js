const db = require('../persistence');
const {v4 : uuid} = require('uuid');
const { httpRequestDurationMicroseconds } = require('../metrics');

module.exports = async (req, res) => {
    const end = httpRequestDurationMicroseconds.startTimer();
    try {
        const item = {
            id: uuid(),
            name: req.body.name,
            completed: false,
        };

        await db.storeItem(item);
        res.send(item);
    } catch (error) {
        res.status(500).send(error);
    } finally {
        end({ method: req.method, route: req.route.path, status_code: res.statusCode });
    }
};