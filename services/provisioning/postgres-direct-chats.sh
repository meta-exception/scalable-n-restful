#!/bin/sh -e

# Add password to default user !WARNING: USE ONLY IN ISOLATED TEST ENVIRONMENT!
psql -U postgres -c "ALTER USER postgres PASSWORD 'ALLBADTHINGS';"

psql -U postgres -c 'CREATE TABLE public.messages (
	owner_id integer NOT NULL,
	collocutor_id integer NOT NULL,
	message_id serial NOT NULL,
	author_id integer NOT NULL,
	send_at timestamptz NOT NULL,
	body varchar(100000) NOT NULL,
	status smallint NOT NULL,
	CONSTRAINT users_id_check CHECK ((owner_id > 0) AND (collocutor_id > 0) AND ((author_id = owner_id) OR (author_id = collocutor_id)))
);'
psql -U postgres -c 'CREATE INDEX dialogue_idx ON public.messages USING btree (owner_id, collocutor_id);'
psql -U postgres -c 'CREATE INDEX message_idx ON public.messages USING btree (message_id);'

# psql -U postgres -c 'SELECT * FROM public.messages WHERE owner_id = $1 AND collocutor_id = $2 AND message_id < $3 ORDER BY send_at DESC LIMIT 100'

# psql -U postgres -c 'SELECT * FROM public.incoming_messages UNION ALL SELECT * FROM public.outcoming_messages WHERE owner_id = $1 AND collocutor_id = $2 ORDER BY send_at DESC LIMIT 100'
