const db = require('../persistence');
const logger = require('../logger');

module.exports = async (req, res) => {
    try {
        const itemId = req.params.id;
        await db.removeItem(itemId);
        logger.info('Item deleted', { itemId });
        res.sendStatus(200);
    } catch (error) {
        logger.error('Error deleting item', { error });
        res.status(500).send(error);
    } 
};