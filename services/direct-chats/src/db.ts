// tslint:disable:max-line-length
const { Pool } = require('pg');

import configs from './db-utils';

const DB_SHARDS = 2;

const pools = configs(DB_SHARDS).map((config) => new Pool(config));

const sendMessage = async (fromUserId: number, toUserId: number, message: any[]) => {
  const fromClient = await pools[fromUserId % DB_SHARDS].connect();
  const toClient = await pools[toUserId % DB_SHARDS].connect();
  try {
    const pendingRes = await fromClient.query('INSERT INTO public.messages (owner_id, collocutor_id, author_id, send_at, body, status) VALUES($1, $2, $3, $4, $5, $6) RETURNING message_id', [fromUserId, toUserId, ...message, 1]);
    const { message_id } = pendingRes.rows[0];

    const deliveredRes = await toClient.query('INSERT INTO public.messages (owner_id, collocutor_id, author_id, send_at, body, status) VALUES($1, $2, $3, $4, $5, $6) RETURNING *', [toUserId, fromUserId, ...message, 2]);
    const delivered = deliveredRes.rows[0];

    const confirmedRes = await fromClient.query('UPDATE public.messages SET status=2 WHERE owner_id=$1 AND collocutor_id=$2 AND message_id=$3 RETURNING *', [fromUserId, toUserId, message_id]);
    const confirmed = confirmedRes.rows[0];

    return ({ delivered, confirmed });
  } finally {
    fromClient.release();
    toClient.release();
  }
};

const getMessages = async (ownerId: number, collocutorId: number, fromMessageId?: number) => {
  const client = await pools[ownerId % DB_SHARDS].connect();
  try {
    if (fromMessageId) {
      const res = await client.query('SELECT * FROM public.messages WHERE owner_id = $1 AND collocutor_id = $2 AND message_id < $3 ORDER BY send_at DESC LIMIT 100', [ownerId, collocutorId, fromMessageId]);
      return res.rows;
    } else {
      const res = await client.query('SELECT * FROM public.messages WHERE owner_id = $1 AND collocutor_id = $2 ORDER BY send_at DESC LIMIT 100', [ownerId, collocutorId]);
      return res.rows;
    }
  } finally {
    client.release();
  }
};

export default { sendMessage, getMessages };
