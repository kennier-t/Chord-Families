const express = require('express');
const router = express.Router();
const songService = require('../services/songService');
const chordService = require('../services/chordService');
const { authMiddleware } = require('./users');

router.post('/song', authMiddleware, async (req, res) => {
    try {
        const { song_id, recipient_username } = req.body;
        await songService.shareSong(song_id, req.user.id, recipient_username);
        res.status(200).json({ message: 'Song shared successfully' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
    }
});

router.post('/chord', authMiddleware, async (req, res) => {
    try {
        const { chord_id, recipient_username } = req.body;
        await chordService.shareChord(chord_id, req.user.id, recipient_username);
        res.status(200).json({ message: 'Chord shared successfully' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
    }
});

router.get('/incoming', authMiddleware, async (req, res) => {
    try {
        const songShares = await songService.getIncomingShares(req.user.id);
        const chordShares = await chordService.getIncomingShares(req.user.id);
        res.json({ songShares, chordShares });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
    }
});

router.post('/:shareId/accept', authMiddleware, async (req, res) => {
    try {
        const { shareId } = req.params;
        const { type } = req.body;
        if (type === 'song') {
            await songService.acceptShare(shareId, req.user.id);
        } else if (type === 'chord') {
            await chordService.acceptShare(shareId, req.user.id);
        } else {
            return res.status(400).json({ message: 'Invalid share type' });
        }
        res.json({ message: 'Share accepted' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
    }
});

router.post('/:shareId/reject', authMiddleware, async (req, res) => {
    try {
        const { shareId } = req.params;
        const { type } = req.body;
        if (type === 'song') {
            await songService.rejectShare(shareId, req.user.id);
        } else if (type === 'chord') {
            await chordService.rejectShare(shareId, req.user.id);
        } else {
            return res.status(400).json({ message: 'Invalid share type' });
        }
        res.json({ message: 'Share rejected' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
    }
});


module.exports = router;