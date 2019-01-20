"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : new P(function (resolve) { resolve(result.value); }).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const os = require("os");
const express = require("express");
const db_1 = __importDefault(require("./db"));
const PORT = 8080;
const app = express();
const hostname = os.hostname();
app.use((req, res, next) => {
    res.setHeader('X-Powered-By', hostname);
    next();
});
// use json format for API
app.use(express.json());
// send message to user
app.post('/api/chats/direct/:toUserId', (req, res) => __awaiter(this, void 0, void 0, function* () {
    const fromUserId = req.query.access_token;
    const { toUserId } = req.params;
    const { message } = req.body;
    try {
        const msgs = yield db_1.default.sendMessage(fromUserId, toUserId, [fromUserId, new Date(), message]);
        res.send(msgs);
    }
    catch (err) {
        res.status(500).send(err);
    }
}));
// get all messages in chat
app.get('/api/chats/direct/:toUserId', (req, res) => __awaiter(this, void 0, void 0, function* () {
    const fromUserId = req.query.access_token;
    const { toUserId } = req.params;
    try {
        const msgs = yield db_1.default.getMessages(fromUserId, toUserId);
        res.send(msgs);
    }
    catch (err) {
        res.status(500).send(err);
    }
}));
app.listen(PORT);
