const express = require('express');
const router = express.Router();
const songService = require('../services/songService');
const { authMiddleware } = require('./users');

router.post('/', authMiddleware, async (req, res) => {
    try {
        const song = await songService.createSong(req.body, req.user.id);
        res.status(201).json(song);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
    }
});

router.get('/', authMiddleware, async (req, res) => {
    try {
        const songs = await songService.getSongsByUserId(req.user.id);
        res.json(songs);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
    }
});

router.get('/:id', authMiddleware, async (req, res) => {
    try {
        const song = await songService.getSongById(req.params.id, req.user.id);
        res.json(song);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
    }
});

router.put('/:id', authMiddleware, async (req, res) => {
    try {
        const song = await songService.updateSong(req.params.id, req.body, req.user.id);
        res.json(song);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
    }
});

router.delete('/:id', authMiddleware, async (req, res) => {
    try {
        await songService.deleteSong(req.params.id, req.user.id);
        res.status(204).send();
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
    }
});

module.exports = router;