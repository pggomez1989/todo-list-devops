const db = require('../persistence');
const { httpRequestDurationMicroseconds } = require('../metrics');

module.exports = async (req, res) => {
    const end = httpRequestDurationMicroseconds.startTimer();
    try {
        const items = await db.getItems();
        res.send(items);
    } catch (error) {
        res.status(500).send(error);
    } finally {
        end({ method: req.method, route: req.route.path, status_code: res.statusCode });
    }
};