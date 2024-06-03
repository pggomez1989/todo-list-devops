const db = require('../persistence');
const { httpRequestDurationMicroseconds } = require('../metrics');

module.exports = async (req, res) => {
    const end = httpRequestDurationMicroseconds.startTimer();
    try {
        await db.updateItem(req.params.id, {
            name: req.body.name,
            completed: req.body.completed,
        });
        const item = await db.getItem(req.params.id);
        res.send(item);
    } catch (error) {
        res.status(500).send(error);
    } finally {
        end({ method: req.method, route: req.route.path, status_code: res.statusCode });
    }
};