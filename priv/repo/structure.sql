--
-- PostgreSQL database dump
--

-- Dumped from database version 13.7 (Debian 13.7-1.pgdg110+1)
-- Dumped by pg_dump version 15.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- *not* creating schema, since initdb creates it


--
-- Name: citext; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;


--
-- Name: EXTENSION citext; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: entries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE IF NOT EXISTS public.entries (
    id integer NOT NULL,
    ledger_id integer NOT NULL,
    description character varying(255),
    inserted_at timestamp without time zone,
    updated_at timestamp without time zone,
    amount integer,
    transaction_date date
);


--
-- Name: ledgers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE IF NOT EXISTS public.ledgers (
    id integer NOT NULL,
    tenancy_id integer NOT NULL,
    name character varying(255),
    acct_type character varying(255),
    balance integer
);


--
-- Name: migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE IF NOT EXISTS public.migrations (
    id integer NOT NULL,
    name character varying(50)
);


--
-- Name: migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE IF NOT EXISTS public.migrations_id_seq
    START WITH 3
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

DROP TABLE IF EXISTS public.schema_migrations CASCADE;
CREATE TABLE public.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


--
-- Name: sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE IF NOT EXISTS public.sessions (
    id integer NOT NULL,
    hashid character varying(32),
    created_at timestamp without time zone,
    ivars text
);


--
-- Name: sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE IF NOT EXISTS public.sessions_id_seq
    START WITH 85
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sessions_id_seq OWNED BY public.sessions.id;


--
-- Name: slummer_account_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE IF NOT EXISTS public.slummer_account_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: slummer_account_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.slummer_account_entries_id_seq OWNED BY public.entries.id;


--
-- Name: slummer_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE IF NOT EXISTS public.slummer_accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: slummer_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.slummer_accounts_id_seq OWNED BY public.ledgers.id;


--
-- Name: tenancies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE IF NOT EXISTS public.tenancies (
    id integer NOT NULL,
    name character varying(255),
    property character varying(255),
    notes text,
    inserted_at timestamp without time zone,
    updated_at timestamp without time zone,
    last_paid_at timestamp without time zone,
    active boolean DEFAULT true,
    rent_day_of_month integer DEFAULT 1 NOT NULL,
    rent integer,
    late_fee integer,
    balance integer
);


--
-- Name: slummer_tenants_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE IF NOT EXISTS public.slummer_tenants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: slummer_tenants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.slummer_tenants_id_seq OWNED BY public.tenancies.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE IF NOT EXISTS public.users (
    id bigint NOT NULL,
    email public.citext NOT NULL,
    hashed_password character varying(255) NOT NULL,
    confirmed_at timestamp(0) without time zone,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE IF NOT EXISTS public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: users_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE IF NOT EXISTS public.users_tokens (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    token bytea NOT NULL,
    context character varying(255) NOT NULL,
    sent_to character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL
);


--
-- Name: users_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE IF NOT EXISTS public.users_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_tokens_id_seq OWNED BY public.users_tokens.id;


--
-- Name: entries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entries ALTER COLUMN id SET DEFAULT nextval('public.slummer_account_entries_id_seq'::regclass);


--
-- Name: ledgers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ledgers ALTER COLUMN id SET DEFAULT nextval('public.slummer_accounts_id_seq'::regclass);


--
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);


--
-- Name: sessions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions ALTER COLUMN id SET DEFAULT nextval('public.sessions_id_seq'::regclass);


--
-- Name: tenancies id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tenancies ALTER COLUMN id SET DEFAULT nextval('public.slummer_tenants_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: users_tokens id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_tokens ALTER COLUMN id SET DEFAULT nextval('public.users_tokens_id_seq'::regclass);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.migrations
    DROP CONSTRAINT IF EXISTS migrations_pkey;
ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--
ALTER TABLE ONLY public.schema_migrations
    DROP CONSTRAINT IF EXISTS schema_migrations_pkey;
ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions
    DROP CONSTRAINT IF EXISTS sessions_pkey;
ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: entries slummer_account_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entries
    DROP CONSTRAINT IF EXISTS slummer_account_entries_pkey;
ALTER TABLE ONLY public.entries
    ADD CONSTRAINT slummer_account_entries_pkey PRIMARY KEY (id);


--
-- Name: ledgers slummer_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ledgers
    DROP CONSTRAINT IF EXISTS slummer_accounts_pkey ;
ALTER TABLE ONLY public.ledgers
    ADD CONSTRAINT slummer_accounts_pkey PRIMARY KEY (id);


--
-- Name: tenancies slummer_tenants_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tenancies
    DROP CONSTRAINT IF EXISTS slummer_tenants_pkey;
ALTER TABLE ONLY public.tenancies
    ADD CONSTRAINT slummer_tenants_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    DROP CONSTRAINT IF EXISTS users_pkey CASCADE;
ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users_tokens users_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_tokens
    DROP CONSTRAINT IF EXISTS users_tokens_pkey CASCADE;
ALTER TABLE ONLY public.users_tokens
    ADD CONSTRAINT users_tokens_pkey PRIMARY KEY (id);


--
-- Name: entries_transaction_date_ledger_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX IF NOT EXISTS entries_transaction_date_ledger_id_index ON public.entries USING btree (transaction_date, ledger_id);


--
-- Name: users_email_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX IF NOT EXISTS users_email_index ON public.users USING btree (email);


--
-- Name: users_tokens_context_token_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX IF NOT EXISTS users_tokens_context_token_index ON public.users_tokens USING btree (context, token);


--
-- Name: users_tokens_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX IF NOT EXISTS users_tokens_user_id_index ON public.users_tokens USING btree (user_id);

--
-- Name: users_tokens users_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_tokens
    ADD CONSTRAINT users_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

INSERT INTO public."schema_migrations" (version) VALUES (20220716030013);
INSERT INTO public."schema_migrations" (version) VALUES (20220723215538);
INSERT INTO public."schema_migrations" (version) VALUES (20220723225258);
INSERT INTO public."schema_migrations" (version) VALUES (20220723225918);
INSERT INTO public."schema_migrations" (version) VALUES (20220724195956);
INSERT INTO public."schema_migrations" (version) VALUES (20220724200436);
INSERT INTO public."schema_migrations" (version) VALUES (20220724200729);
INSERT INTO public."schema_migrations" (version) VALUES (20220724203130);
INSERT INTO public."schema_migrations" (version) VALUES (20220724203452);
INSERT INTO public."schema_migrations" (version) VALUES (20220724203634);
INSERT INTO public."schema_migrations" (version) VALUES (20220724204603);
INSERT INTO public."schema_migrations" (version) VALUES (20220830014027);
INSERT INTO public."schema_migrations" (version) VALUES (20230303035501);
INSERT INTO public."schema_migrations" (version) VALUES (20230520055422);
