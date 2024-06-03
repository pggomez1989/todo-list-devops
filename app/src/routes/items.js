const express = require('express');
const router = express.Router();
const getItems = require('./getItems');
const addItem = require('./addItem');
const updateItem = require('./updateItem');
const deleteItem = require('./deleteItem');

router.get('/', getItems);

router.post('/', addItem);

router.put('/:id', updateItem);

router.delete('/:id', deleteItem);

module.exports = router;
