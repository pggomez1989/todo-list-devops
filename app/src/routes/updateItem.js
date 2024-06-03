const db = require('../persistence');
const logger = require('../logger');

module.exports = async (req, res) => {
    try {
        await db.updateItem(req.params.id, {
            name: req.body.name,
            completed: req.body.completed,
        });
        const item = await db.getItem(req.params.id);
        logger.info('Item updated', { item });
        res.send(item);
    } catch (error) {
        logger.error('Error updating item', { error });
        res.status(500).send(error);
    } 
};