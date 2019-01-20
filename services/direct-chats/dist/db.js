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
// tslint:disable:max-line-length
const { Pool } = require('pg');
const db_utils_1 = __importDefault(require("./db-utils"));
const DB_SHARDS = 2;
const pools = db_utils_1.default(DB_SHARDS).map((config) => new Pool(config));
const sendMessage = (fromUserId, toUserId, message) => __awaiter(this, void 0, void 0, function* () {
    const fromClient = yield pools[fromUserId % DB_SHARDS].connect();
    const toClient = yield pools[toUserId % DB_SHARDS].connect();
    try {
        const pendingRes = yield fromClient.query('INSERT INTO public.messages (owner_id, collocutor_id, author_id, send_at, body, status) VALUES($1, $2, $3, $4, $5, $6) RETURNING message_id', [fromUserId, toUserId, ...message, 1]);
        const { message_id } = pendingRes.rows[0];
        const deliveredRes = yield toClient.query('INSERT INTO public.messages (owner_id, collocutor_id, author_id, send_at, body, status) VALUES($1, $2, $3, $4, $5, $6) RETURNING *', [toUserId, fromUserId, ...message, 2]);
        const delivered = deliveredRes.rows[0];
        const confirmedRes = yield fromClient.query('UPDATE public.messages SET status=2 WHERE owner_id=$1 AND collocutor_id=$2 AND message_id=$3 RETURNING *', [fromUserId, toUserId, message_id]);
        const confirmed = confirmedRes.rows[0];
        return ({ delivered, confirmed });
    }
    finally {
        fromClient.release();
        toClient.release();
    }
});
const getMessages = (ownerId, collocutorId, fromMessageId) => __awaiter(this, void 0, void 0, function* () {
    const client = yield pools[ownerId % DB_SHARDS].connect();
    try {
        if (fromMessageId) {
            const res = yield client.query('SELECT * FROM public.messages WHERE owner_id = $1 AND collocutor_id = $2 AND message_id < $3 ORDER BY send_at DESC LIMIT 100', [ownerId, collocutorId, fromMessageId]);
            return res.rows;
        }
        else {
            const res = yield client.query('SELECT * FROM public.messages WHERE owner_id = $1 AND collocutor_id = $2 ORDER BY send_at DESC LIMIT 100', [ownerId, collocutorId]);
            return res.rows;
        }
    }
    finally {
        client.release();
    }
});
exports.default = { sendMessage, getMessages };
