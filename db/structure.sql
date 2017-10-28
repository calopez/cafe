--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.1
-- Dumped by pg_dump version 9.6.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: citext; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;


--
-- Name: EXTENSION citext; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';


SET search_path = public, pg_catalog;

--
-- Name: rodauth_get_previous_salt(bigint); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION rodauth_get_previous_salt(acct_id bigint) RETURNS text
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO public, pg_temp
    AS $$
DECLARE salt text;
BEGIN
SELECT substr(password_hash, 0, 30) INTO salt 
FROM account_previous_password_hashes
WHERE acct_id = id;
RETURN salt;
END;
$$;


--
-- Name: rodauth_get_salt(bigint); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION rodauth_get_salt(acct_id bigint) RETURNS text
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO public, pg_temp
    AS $$
DECLARE salt text;
BEGIN
SELECT substr(password_hash, 0, 30) INTO salt 
FROM account_password_hashes
WHERE acct_id = id;
RETURN salt;
END;
$$;


--
-- Name: rodauth_previous_password_hash_match(bigint, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION rodauth_previous_password_hash_match(acct_id bigint, hash text) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO public, pg_temp
    AS $$
DECLARE valid boolean;
BEGIN
SELECT password_hash = hash INTO valid 
FROM account_previous_password_hashes
WHERE acct_id = id;
RETURN valid;
END;
$$;


--
-- Name: rodauth_valid_password_hash(bigint, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION rodauth_valid_password_hash(acct_id bigint, hash text) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO public, pg_temp
    AS $$
DECLARE valid boolean;
BEGIN
SELECT password_hash = hash INTO valid 
FROM account_password_hashes
WHERE acct_id = id;
RETURN valid;
END;
$$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: account_activity_times; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE account_activity_times (
    id bigint NOT NULL,
    last_activity_at timestamp without time zone NOT NULL,
    last_login_at timestamp without time zone NOT NULL,
    expired_at timestamp without time zone
);


--
-- Name: account_lockouts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE account_lockouts (
    id bigint NOT NULL,
    key text NOT NULL,
    deadline timestamp without time zone DEFAULT ((now())::timestamp without time zone + '1 day'::interval) NOT NULL
);


--
-- Name: account_login_change_keys; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE account_login_change_keys (
    id bigint NOT NULL,
    key text NOT NULL,
    login text NOT NULL,
    deadline timestamp without time zone DEFAULT ((now())::timestamp without time zone + '1 day'::interval) NOT NULL
);


--
-- Name: account_login_failures; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE account_login_failures (
    id bigint NOT NULL,
    number integer DEFAULT 1 NOT NULL
);


--
-- Name: account_otp_keys; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE account_otp_keys (
    id bigint NOT NULL,
    key text NOT NULL,
    num_failures integer DEFAULT 0 NOT NULL,
    last_use timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: account_password_change_times; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE account_password_change_times (
    id bigint NOT NULL,
    changed_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: account_password_hashes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE account_password_hashes (
    id bigint NOT NULL,
    password_hash text NOT NULL
);


--
-- Name: account_password_reset_keys; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE account_password_reset_keys (
    id bigint NOT NULL,
    key text NOT NULL,
    deadline timestamp without time zone DEFAULT ((now())::timestamp without time zone + '1 day'::interval) NOT NULL
);


--
-- Name: account_previous_password_hashes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE account_previous_password_hashes (
    id bigint NOT NULL,
    account_id bigint,
    password_hash text NOT NULL
);


--
-- Name: account_previous_password_hashes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE account_previous_password_hashes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: account_previous_password_hashes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE account_previous_password_hashes_id_seq OWNED BY account_previous_password_hashes.id;


--
-- Name: account_recovery_codes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE account_recovery_codes (
    id bigint NOT NULL,
    code text NOT NULL
);


--
-- Name: account_remember_keys; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE account_remember_keys (
    id bigint NOT NULL,
    key text NOT NULL,
    deadline timestamp without time zone DEFAULT ((now())::timestamp without time zone + '14 days'::interval) NOT NULL
);


--
-- Name: account_session_keys; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE account_session_keys (
    id bigint NOT NULL,
    key text NOT NULL
);


--
-- Name: account_sms_codes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE account_sms_codes (
    id bigint NOT NULL,
    phone_number text NOT NULL,
    num_failures integer,
    code text,
    code_issued_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: account_statuses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE account_statuses (
    id integer NOT NULL,
    name text NOT NULL
);


--
-- Name: account_verification_keys; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE account_verification_keys (
    id bigint NOT NULL,
    key text NOT NULL,
    requested_at timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE accounts (
    id bigint NOT NULL,
    status_id integer DEFAULT 1 NOT NULL,
    email citext NOT NULL,
    CONSTRAINT valid_email CHECK ((email ~ '^[^,;@ \r\n]+@[^,@; \r\n]+\.[^,@; \r\n]+$'::citext))
);


--
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE accounts_id_seq OWNED BY accounts.id;


--
-- Name: schema_info; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_info (
    version integer DEFAULT 0 NOT NULL
);


--
-- Name: account_previous_password_hashes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY account_previous_password_hashes ALTER COLUMN id SET DEFAULT nextval('account_previous_password_hashes_id_seq'::regclass);


--
-- Name: accounts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY accounts ALTER COLUMN id SET DEFAULT nextval('accounts_id_seq'::regclass);


--
-- Name: account_activity_times account_activity_times_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY account_activity_times
    ADD CONSTRAINT account_activity_times_pkey PRIMARY KEY (id);


--
-- Name: account_lockouts account_lockouts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY account_lockouts
    ADD CONSTRAINT account_lockouts_pkey PRIMARY KEY (id);


--
-- Name: account_login_change_keys account_login_change_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY account_login_change_keys
    ADD CONSTRAINT account_login_change_keys_pkey PRIMARY KEY (id);


--
-- Name: account_login_failures account_login_failures_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY account_login_failures
    ADD CONSTRAINT account_login_failures_pkey PRIMARY KEY (id);


--
-- Name: account_otp_keys account_otp_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY account_otp_keys
    ADD CONSTRAINT account_otp_keys_pkey PRIMARY KEY (id);


--
-- Name: account_password_change_times account_password_change_times_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY account_password_change_times
    ADD CONSTRAINT account_password_change_times_pkey PRIMARY KEY (id);


--
-- Name: account_password_hashes account_password_hashes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY account_password_hashes
    ADD CONSTRAINT account_password_hashes_pkey PRIMARY KEY (id);


--
-- Name: account_password_reset_keys account_password_reset_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY account_password_reset_keys
    ADD CONSTRAINT account_password_reset_keys_pkey PRIMARY KEY (id);


--
-- Name: account_previous_password_hashes account_previous_password_hashes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY account_previous_password_hashes
    ADD CONSTRAINT account_previous_password_hashes_pkey PRIMARY KEY (id);


--
-- Name: account_recovery_codes account_recovery_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY account_recovery_codes
    ADD CONSTRAINT account_recovery_codes_pkey PRIMARY KEY (id, code);


--
-- Name: account_remember_keys account_remember_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY account_remember_keys
    ADD CONSTRAINT account_remember_keys_pkey PRIMARY KEY (id);


--
-- Name: account_session_keys account_session_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY account_session_keys
    ADD CONSTRAINT account_session_keys_pkey PRIMARY KEY (id);


--
-- Name: account_sms_codes account_sms_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY account_sms_codes
    ADD CONSTRAINT account_sms_codes_pkey PRIMARY KEY (id);


--
-- Name: account_statuses account_statuses_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY account_statuses
    ADD CONSTRAINT account_statuses_name_key UNIQUE (name);


--
-- Name: account_statuses account_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY account_statuses
    ADD CONSTRAINT account_statuses_pkey PRIMARY KEY (id);


--
-- Name: account_verification_keys account_verification_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY account_verification_keys
    ADD CONSTRAINT account_verification_keys_pkey PRIMARY KEY (id);


--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: accounts_email_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX accounts_email_index ON accounts USING btree (email) WHERE (status_id = ANY (ARRAY[1, 2]));


--
-- Name: account_activity_times account_activity_times_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY account_activity_times
    ADD CONSTRAINT account_activity_times_id_fkey FOREIGN KEY (id) REFERENCES accounts(id);


--
-- Name: account_lockouts account_lockouts_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY account_lockouts
    ADD CONSTRAINT account_lockouts_id_fkey FOREIGN KEY (id) REFERENCES accounts(id);


--
-- Name: account_login_change_keys account_login_change_keys_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY account_login_change_keys
    ADD CONSTRAINT account_login_change_keys_id_fkey FOREIGN KEY (id) REFERENCES accounts(id);


--
-- Name: account_login_failures account_login_failures_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY account_login_failures
    ADD CONSTRAINT account_login_failures_id_fkey FOREIGN KEY (id) REFERENCES accounts(id);


--
-- Name: account_otp_keys account_otp_keys_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY account_otp_keys
    ADD CONSTRAINT account_otp_keys_id_fkey FOREIGN KEY (id) REFERENCES accounts(id);


--
-- Name: account_password_change_times account_password_change_times_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY account_password_change_times
    ADD CONSTRAINT account_password_change_times_id_fkey FOREIGN KEY (id) REFERENCES accounts(id);


--
-- Name: account_password_hashes account_password_hashes_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY account_password_hashes
    ADD CONSTRAINT account_password_hashes_id_fkey FOREIGN KEY (id) REFERENCES accounts(id);


--
-- Name: account_password_reset_keys account_password_reset_keys_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY account_password_reset_keys
    ADD CONSTRAINT account_password_reset_keys_id_fkey FOREIGN KEY (id) REFERENCES accounts(id);


--
-- Name: account_previous_password_hashes account_previous_password_hashes_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY account_previous_password_hashes
    ADD CONSTRAINT account_previous_password_hashes_account_id_fkey FOREIGN KEY (account_id) REFERENCES accounts(id);


--
-- Name: account_recovery_codes account_recovery_codes_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY account_recovery_codes
    ADD CONSTRAINT account_recovery_codes_id_fkey FOREIGN KEY (id) REFERENCES accounts(id);


--
-- Name: account_remember_keys account_remember_keys_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY account_remember_keys
    ADD CONSTRAINT account_remember_keys_id_fkey FOREIGN KEY (id) REFERENCES accounts(id);


--
-- Name: account_session_keys account_session_keys_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY account_session_keys
    ADD CONSTRAINT account_session_keys_id_fkey FOREIGN KEY (id) REFERENCES accounts(id);


--
-- Name: account_sms_codes account_sms_codes_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY account_sms_codes
    ADD CONSTRAINT account_sms_codes_id_fkey FOREIGN KEY (id) REFERENCES accounts(id);


--
-- Name: account_verification_keys account_verification_keys_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY account_verification_keys
    ADD CONSTRAINT account_verification_keys_id_fkey FOREIGN KEY (id) REFERENCES accounts(id);


--
-- Name: accounts accounts_status_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY accounts
    ADD CONSTRAINT accounts_status_id_fkey FOREIGN KEY (status_id) REFERENCES account_statuses(id);


--
-- PostgreSQL database dump complete
--

