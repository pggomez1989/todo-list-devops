const db = require('../persistence');
const {v4 : uuid} = require('uuid');
const logger = require('../logger');

module.exports = async (req, res) => {
    try {
        const item = {
            id: uuid(),
            name: req.body.name,
            completed: false,
        };

        await db.storeItem(item);
        logger.info('Item added', { item });
        res.send(item);
    } catch (error) {
        logger.error('Error adding item', { error });
        res.status(500).send(error);
    }
};