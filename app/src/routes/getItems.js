const db = require('../persistence');
const logger = require('../logger');

module.exports = async (req, res) => {
    try {
        const items = await db.getItems(); 
        logger.info('Get all items');
        res.send(items); 
    } catch (error) {
        logger.error('Error getting all items', { error });
        res.status(500).send(error); 
    } 
};
