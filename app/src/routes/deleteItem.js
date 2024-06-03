const db = require('../persistence');
const { httpRequestDurationMicroseconds } = require('../metrics');

module.exports = async (req, res) => {
    const end = httpRequestDurationMicroseconds.startTimer();
    try {
        await db.removeItem(req.params.id);
        res.sendStatus(200);
    } catch (error) {
        res.status(500).send(error);
    } finally {
        end({ method: req.method, route: req.route.path, status_code: res.statusCode });
    }
};