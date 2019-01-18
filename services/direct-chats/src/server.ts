import express = require('express');
import db from './db';

const PORT = 8080;

const app = express();

// send message to user
app.post('/chats/direct/:toUserId', async (req, res) => {
  const fromUserId = req.query.access_token;
  const { toUserId } = req.params;
  const message = req.body;
  try {
    const msgs = await db.sendMessage(fromUserId, toUserId, message);
    res.send(msgs);
  } catch (err) {
    res.status(500).send(err);
  }
});

// get all messages in chat
app.get('/chats/direct/:toUserId', async (req, res) => {
  const fromUserId = req.query.access_token;
  const { toUserId } = req.params;
  try {
    const msgs = await db.getMessages(fromUserId, toUserId);
    res.send(msgs);
  } catch (err) {
    res.status(500).send(err);
  }
});

app.listen(PORT);