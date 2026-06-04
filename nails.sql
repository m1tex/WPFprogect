--
-- PostgreSQL database dump
--

\restrict kbAz5om6ot5VImEegkhZQbByJkTb7ci5bG11YBflznKTYATRlQKE2bAJl0D7pWg

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

-- Started on 2026-06-03 23:52:26

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 6 (class 2615 OID 16455)
-- Name: nails; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA nails;


ALTER SCHEMA nails OWNER TO postgres;

--
-- TOC entry 252 (class 1255 OID 16456)
-- Name: application_get(integer); Type: FUNCTION; Schema: nails; Owner: postgres
--

CREATE FUNCTION nails.application_get(in_user integer) RETURNS TABLE(pk_application integer, master_name character varying, date timestamp without time zone, "time" time without time zone, pk_user integer, pk_status smallint)
    LANGUAGE plpgsql
    AS $$

BEGIN

RETURN QUERY SELECT

nails.application.pk_application,
nails.application.master_name,
nails.application.date,
nails.application."time",
nails.application.fk_user,
nails.application.fk_status

FROM nails.application

WHERE nails.application.fk_user = in_user;

END;

$$;


ALTER FUNCTION nails.application_get(in_user integer) OWNER TO postgres;

--
-- TOC entry 264 (class 1255 OID 24780)
-- Name: application_get_admin(); Type: FUNCTION; Schema: nails; Owner: postgres
--

CREATE FUNCTION nails.application_get_admin() RETURNS TABLE(pk_application integer, master_name character varying, date timestamp without time zone, "time" time without time zone, lastname character varying, firstname character varying, middlename character varying, phone_number character varying, title character varying)
    LANGUAGE plpgsql
    AS $$

BEGIN
    RETURN QUERY SELECT 
        nails.application.pk_application,
        nails.application.master_name,
        nails.application.date,
		nails.application."time",
        nails.user.lastname,  
		nails.user.firstname, 
		nails.user.middlename,
        nails.user.phone_number,
		nails.status.title
        
    FROM nails.application 
    LEFT JOIN nails.user  ON nails.application.fk_user = nails.user.pk_user
	LEFT JOIN nails.status  ON nails.application.fk_status = nails.status.pk_status;
END;
$$;


ALTER FUNCTION nails.application_get_admin() OWNER TO postgres;

--
-- TOC entry 247 (class 1255 OID 16457)
-- Name: application_path(integer, smallint); Type: FUNCTION; Schema: nails; Owner: postgres
--

CREATE FUNCTION nails.application_path(in_pk_application integer, in_fk_status smallint) RETURNS TABLE(confirm boolean)
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE nails.application
    SET fk_status = in_fk_status
    WHERE pk_application = in_pk_application;
    RETURN QUERY SELECT (
    CASE WHEN 
	      (SELECT fk_status FROM nails.application WHERE pk_application = in_pk_application LIMIT 1) =
		  in_fk_status
		  THEN TRUE
		  ELSE FALSE
		  END);
END;
$$;


ALTER FUNCTION nails.application_path(in_pk_application integer, in_fk_status smallint) OWNER TO postgres;

--
-- TOC entry 248 (class 1255 OID 16458)
-- Name: application_post(character varying, timestamp without time zone, time without time zone, integer, smallint); Type: FUNCTION; Schema: nails; Owner: postgres
--

CREATE FUNCTION nails.application_post(in_master_name character varying, in_date timestamp without time zone, in_time time without time zone, in_user integer, in_status smallint) RETURNS TABLE(id_application integer)
    LANGUAGE plpgsql
    AS $$

BEGIN

INSERT INTO nails.application(master_name, date, "time", fk_user, fk_status)

VALUES(in_master_name, in_date, in_time, in_user, in_status);

RETURN QUERY SELECT MAX(pk_application) 

FROM nails.application;

END;

$$;


ALTER FUNCTION nails.application_post(in_master_name character varying, in_date timestamp without time zone, in_time time without time zone, in_user integer, in_status smallint) OWNER TO postgres;

--
-- TOC entry 249 (class 1255 OID 16459)
-- Name: user_activate(integer); Type: FUNCTION; Schema: nails; Owner: postgres
--

CREATE FUNCTION nails.user_activate(in_pk_user integer) RETURNS TABLE(confirm boolean)
    LANGUAGE plpgsql
    AS $$
BEGIN
   UPDATE nails.user
       SET is_active = True
   WHERE pk_user = in_pk_user;
   RETURN QUERY SELECT
        is_active = True
   FROM nails.user
   WHERE  nails.user.pk_user = in_pk_user;
END;
$$;


ALTER FUNCTION nails.user_activate(in_pk_user integer) OWNER TO postgres;

--
-- TOC entry 251 (class 1255 OID 24771)
-- Name: user_get(character varying); Type: FUNCTION; Schema: nails; Owner: postgres
--

CREATE FUNCTION nails.user_get(in_value character varying) RETURNS TABLE(pk_user integer, lastname character varying, firstname character varying, middlename character varying, phone_number character varying, email character varying, login character varying, password character varying, is_admin boolean)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT nails.user.pk_user, nails.user.lastname, nails.user.firstname, nails.user.middlename, 
	nails.user.phone_number, nails.user.email, nails.user.login, nails.user.password, nails.user.is_admin
    FROM nails.user
    WHERE nails.user.login ILIKE in_value OR nails.user.email ILIKE in_value;
END;
$$;


ALTER FUNCTION nails.user_get(in_value character varying) OWNER TO postgres;

--
-- TOC entry 250 (class 1255 OID 16461)
-- Name: user_post(character varying, character varying, character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: nails; Owner: postgres
--

CREATE FUNCTION nails.user_post(in_lastname character varying, in_firstname character varying, in_middlename character varying, in_phone_number character varying, in_email character varying, in_login character varying, in_password character varying) RETURNS TABLE(id_user integer)
    LANGUAGE plpgsql
    AS $$

BEGIN

INSERT INTO nails.user(lastname, firstname, middlename, phone_number, email, login, password)

VALUES(in_lastname, in_firstname, in_middlename, in_phone_number, in_email, in_login, in_password);

RETURN QUERY SELECT MAX(pk_user) 

FROM nails.user;

END;

$$;


ALTER FUNCTION nails.user_post(in_lastname character varying, in_firstname character varying, in_middlename character varying, in_phone_number character varying, in_email character varying, in_login character varying, in_password character varying) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 220 (class 1259 OID 16462)
-- Name: application; Type: TABLE; Schema: nails; Owner: postgres
--

CREATE TABLE nails.application (
    pk_application integer NOT NULL,
    master_name character varying(255) NOT NULL,
    date timestamp without time zone NOT NULL,
    "time" time without time zone NOT NULL,
    fk_user integer NOT NULL,
    fk_status smallint NOT NULL
);


ALTER TABLE nails.application OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16471)
-- Name: application_fk_status_seq; Type: SEQUENCE; Schema: nails; Owner: postgres
--

CREATE SEQUENCE nails.application_fk_status_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE nails.application_fk_status_seq OWNER TO postgres;

--
-- TOC entry 5176 (class 0 OID 0)
-- Dependencies: 221
-- Name: application_fk_status_seq; Type: SEQUENCE OWNED BY; Schema: nails; Owner: postgres
--

ALTER SEQUENCE nails.application_fk_status_seq OWNED BY nails.application.fk_status;


--
-- TOC entry 222 (class 1259 OID 16472)
-- Name: application_fk_user_seq; Type: SEQUENCE; Schema: nails; Owner: postgres
--

CREATE SEQUENCE nails.application_fk_user_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE nails.application_fk_user_seq OWNER TO postgres;

--
-- TOC entry 5177 (class 0 OID 0)
-- Dependencies: 222
-- Name: application_fk_user_seq; Type: SEQUENCE OWNED BY; Schema: nails; Owner: postgres
--

ALTER SEQUENCE nails.application_fk_user_seq OWNED BY nails.application.fk_user;


--
-- TOC entry 223 (class 1259 OID 16473)
-- Name: application_pk_application_seq; Type: SEQUENCE; Schema: nails; Owner: postgres
--

CREATE SEQUENCE nails.application_pk_application_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE nails.application_pk_application_seq OWNER TO postgres;

--
-- TOC entry 5178 (class 0 OID 0)
-- Dependencies: 223
-- Name: application_pk_application_seq; Type: SEQUENCE OWNED BY; Schema: nails; Owner: postgres
--

ALTER SEQUENCE nails.application_pk_application_seq OWNED BY nails.application.pk_application;


--
-- TOC entry 224 (class 1259 OID 16474)
-- Name: status; Type: TABLE; Schema: nails; Owner: postgres
--

CREATE TABLE nails.status (
    pk_status smallint NOT NULL,
    title character varying(50) NOT NULL
);


ALTER TABLE nails.status OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16479)
-- Name: status_pk_status_seq; Type: SEQUENCE; Schema: nails; Owner: postgres
--

CREATE SEQUENCE nails.status_pk_status_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE nails.status_pk_status_seq OWNER TO postgres;

--
-- TOC entry 5179 (class 0 OID 0)
-- Dependencies: 225
-- Name: status_pk_status_seq; Type: SEQUENCE OWNED BY; Schema: nails; Owner: postgres
--

ALTER SEQUENCE nails.status_pk_status_seq OWNED BY nails.status.pk_status;


--
-- TOC entry 226 (class 1259 OID 16480)
-- Name: user; Type: TABLE; Schema: nails; Owner: postgres
--

CREATE TABLE nails."user" (
    pk_user integer NOT NULL,
    lastname character varying(255) NOT NULL,
    firstname character varying(255) NOT NULL,
    middlename character varying(255),
    phone_number character varying(12) NOT NULL,
    email character varying(100) NOT NULL,
    login character varying(40) NOT NULL,
    password character varying(255) NOT NULL,
    is_admin boolean DEFAULT false NOT NULL,
    is_active boolean DEFAULT false NOT NULL
);


ALTER TABLE nails."user" OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16496)
-- Name: user_pk_user_seq; Type: SEQUENCE; Schema: nails; Owner: postgres
--

CREATE SEQUENCE nails.user_pk_user_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE nails.user_pk_user_seq OWNER TO postgres;

--
-- TOC entry 5180 (class 0 OID 0)
-- Dependencies: 227
-- Name: user_pk_user_seq; Type: SEQUENCE OWNED BY; Schema: nails; Owner: postgres
--

ALTER SEQUENCE nails.user_pk_user_seq OWNED BY nails."user".pk_user;


--
-- TOC entry 235 (class 1259 OID 24611)
-- Name: auth_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(150) NOT NULL
);


ALTER TABLE public.auth_group OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 24610)
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_group ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 237 (class 1259 OID 24621)
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_group_permissions (
    id bigint NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_group_permissions OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 24620)
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_group_permissions ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 233 (class 1259 OID 24601)
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE public.auth_permission OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 24600)
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_permission ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 239 (class 1259 OID 24630)
-- Name: auth_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    username character varying(150) NOT NULL,
    first_name character varying(150) NOT NULL,
    last_name character varying(150) NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL
);


ALTER TABLE public.auth_user OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 24649)
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_user_groups (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.auth_user_groups OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 24648)
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_user_groups ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 238 (class 1259 OID 24629)
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_user ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 243 (class 1259 OID 24658)
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_user_user_permissions (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_user_user_permissions OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 24657)
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_user_user_permissions ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_user_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 245 (class 1259 OID 24719)
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id integer NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


ALTER TABLE public.django_admin_log OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 24718)
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.django_admin_log ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_admin_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 231 (class 1259 OID 24589)
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE public.django_content_type OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 24588)
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.django_content_type ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_content_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 229 (class 1259 OID 24577)
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_migrations (
    id bigint NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE public.django_migrations OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 24576)
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.django_migrations ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 246 (class 1259 OID 24759)
-- Name: django_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE public.django_session OWNER TO postgres;

--
-- TOC entry 4925 (class 2604 OID 16497)
-- Name: application pk_application; Type: DEFAULT; Schema: nails; Owner: postgres
--

ALTER TABLE ONLY nails.application ALTER COLUMN pk_application SET DEFAULT nextval('nails.application_pk_application_seq'::regclass);


--
-- TOC entry 4926 (class 2604 OID 16498)
-- Name: application fk_user; Type: DEFAULT; Schema: nails; Owner: postgres
--

ALTER TABLE ONLY nails.application ALTER COLUMN fk_user SET DEFAULT nextval('nails.application_fk_user_seq'::regclass);


--
-- TOC entry 4927 (class 2604 OID 16499)
-- Name: application fk_status; Type: DEFAULT; Schema: nails; Owner: postgres
--

ALTER TABLE ONLY nails.application ALTER COLUMN fk_status SET DEFAULT nextval('nails.application_fk_status_seq'::regclass);


--
-- TOC entry 4928 (class 2604 OID 16500)
-- Name: status pk_status; Type: DEFAULT; Schema: nails; Owner: postgres
--

ALTER TABLE ONLY nails.status ALTER COLUMN pk_status SET DEFAULT nextval('nails.status_pk_status_seq'::regclass);


--
-- TOC entry 4929 (class 2604 OID 16501)
-- Name: user pk_user; Type: DEFAULT; Schema: nails; Owner: postgres
--

ALTER TABLE ONLY nails."user" ALTER COLUMN pk_user SET DEFAULT nextval('nails.user_pk_user_seq'::regclass);


--
-- TOC entry 5144 (class 0 OID 16462)
-- Dependencies: 220
-- Data for Name: application; Type: TABLE DATA; Schema: nails; Owner: postgres
--

COPY nails.application (pk_application, master_name, date, "time", fk_user, fk_status) FROM stdin;
1	hgf	2020-10-10 00:00:00	10:00:00	1	3
2	1	2020-10-10 00:00:00	10:00:00	1	1
6	dsfsf	2020-10-10 00:00:00	11:00:10	1	1
7	fdsf	2020-12-10 00:00:00	11:11:11	16	1
\.


--
-- TOC entry 5148 (class 0 OID 16474)
-- Dependencies: 224
-- Data for Name: status; Type: TABLE DATA; Schema: nails; Owner: postgres
--

COPY nails.status (pk_status, title) FROM stdin;
1	Новое
2	Подтверждено
3	Отклонено
\.


--
-- TOC entry 5150 (class 0 OID 16480)
-- Dependencies: 226
-- Data for Name: user; Type: TABLE DATA; Schema: nails; Owner: postgres
--

COPY nails."user" (pk_user, lastname, firstname, middlename, phone_number, email, login, password, is_admin, is_active) FROM stdin;
1	s	a	fd	21	fe	dds	sdf	f	t
14	123	123	123	123	123	123	pbkdf2_sha256$1200000$extra$Qlv069oIOx5IhA87F489iPk19YnUE8C3EYBzFuz2Z7c=	f	f
15	123	123	123	123	1231	1231	pbkdf2_sha256$1200000$extra$Qlv069oIOx5IhA87F489iPk19YnUE8C3EYBzFuz2Z7c=	f	f
16	123вы	123	123	12322	1231fd	1231ss	pbkdf2_sha256$1200000$extra$Qlv069oIOx5IhA87F489iPk19YnUE8C3EYBzFuz2Z7c=	t	t
\.


--
-- TOC entry 5159 (class 0 OID 24611)
-- Dependencies: 235
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_group (id, name) FROM stdin;
\.


--
-- TOC entry 5161 (class 0 OID 24621)
-- Dependencies: 237
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- TOC entry 5157 (class 0 OID 24601)
-- Dependencies: 233
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add log entry	1	add_logentry
2	Can change log entry	1	change_logentry
3	Can delete log entry	1	delete_logentry
4	Can view log entry	1	view_logentry
5	Can add permission	3	add_permission
6	Can change permission	3	change_permission
7	Can delete permission	3	delete_permission
8	Can view permission	3	view_permission
9	Can add group	2	add_group
10	Can change group	2	change_group
11	Can delete group	2	delete_group
12	Can view group	2	view_group
13	Can add user	4	add_user
14	Can change user	4	change_user
15	Can delete user	4	delete_user
16	Can view user	4	view_user
17	Can add content type	5	add_contenttype
18	Can change content type	5	change_contenttype
19	Can delete content type	5	delete_contenttype
20	Can view content type	5	view_contenttype
21	Can add session	6	add_session
22	Can change session	6	change_session
23	Can delete session	6	delete_session
24	Can view session	6	view_session
\.


--
-- TOC entry 5163 (class 0 OID 24630)
-- Dependencies: 239
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) FROM stdin;
\.


--
-- TOC entry 5165 (class 0 OID 24649)
-- Dependencies: 241
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_user_groups (id, user_id, group_id) FROM stdin;
\.


--
-- TOC entry 5167 (class 0 OID 24658)
-- Dependencies: 243
-- Data for Name: auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- TOC entry 5169 (class 0 OID 24719)
-- Dependencies: 245
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
\.


--
-- TOC entry 5155 (class 0 OID 24589)
-- Dependencies: 231
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_content_type (id, app_label, model) FROM stdin;
1	admin	logentry
2	auth	group
3	auth	permission
4	auth	user
5	contenttypes	contenttype
6	sessions	session
\.


--
-- TOC entry 5153 (class 0 OID 24577)
-- Dependencies: 229
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2026-06-01 23:11:58.191324+03
2	auth	0001_initial	2026-06-01 23:11:58.224239+03
3	admin	0001_initial	2026-06-01 23:11:58.234876+03
4	admin	0002_logentry_remove_auto_add	2026-06-01 23:11:58.238223+03
5	admin	0003_logentry_add_action_flag_choices	2026-06-01 23:11:58.241323+03
6	contenttypes	0002_remove_content_type_name	2026-06-01 23:11:58.25048+03
7	auth	0002_alter_permission_name_max_length	2026-06-01 23:11:58.254261+03
8	auth	0003_alter_user_email_max_length	2026-06-01 23:11:58.257695+03
9	auth	0004_alter_user_username_opts	2026-06-01 23:11:58.261305+03
10	auth	0005_alter_user_last_login_null	2026-06-01 23:11:58.264836+03
11	auth	0006_require_contenttypes_0002	2026-06-01 23:11:58.265437+03
12	auth	0007_alter_validators_add_error_messages	2026-06-01 23:11:58.268757+03
13	auth	0008_alter_user_username_max_length	2026-06-01 23:11:58.274812+03
14	auth	0009_alter_user_last_name_max_length	2026-06-01 23:11:58.278588+03
15	auth	0010_alter_group_name_max_length	2026-06-01 23:11:58.282257+03
16	auth	0011_update_proxy_permissions	2026-06-01 23:11:58.284858+03
17	auth	0012_alter_user_first_name_max_length	2026-06-01 23:11:58.288124+03
18	sessions	0001_initial	2026-06-01 23:11:58.293644+03
\.


--
-- TOC entry 5170 (class 0 OID 24759)
-- Dependencies: 246
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_session (session_key, session_data, expire_date) FROM stdin;
\.


--
-- TOC entry 5181 (class 0 OID 0)
-- Dependencies: 221
-- Name: application_fk_status_seq; Type: SEQUENCE SET; Schema: nails; Owner: postgres
--

SELECT pg_catalog.setval('nails.application_fk_status_seq', 1, true);


--
-- TOC entry 5182 (class 0 OID 0)
-- Dependencies: 222
-- Name: application_fk_user_seq; Type: SEQUENCE SET; Schema: nails; Owner: postgres
--

SELECT pg_catalog.setval('nails.application_fk_user_seq', 1, true);


--
-- TOC entry 5183 (class 0 OID 0)
-- Dependencies: 223
-- Name: application_pk_application_seq; Type: SEQUENCE SET; Schema: nails; Owner: postgres
--

SELECT pg_catalog.setval('nails.application_pk_application_seq', 7, true);


--
-- TOC entry 5184 (class 0 OID 0)
-- Dependencies: 225
-- Name: status_pk_status_seq; Type: SEQUENCE SET; Schema: nails; Owner: postgres
--

SELECT pg_catalog.setval('nails.status_pk_status_seq', 3, true);


--
-- TOC entry 5185 (class 0 OID 0)
-- Dependencies: 227
-- Name: user_pk_user_seq; Type: SEQUENCE SET; Schema: nails; Owner: postgres
--

SELECT pg_catalog.setval('nails.user_pk_user_seq', 16, true);


--
-- TOC entry 5186 (class 0 OID 0)
-- Dependencies: 234
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 1, false);


--
-- TOC entry 5187 (class 0 OID 0)
-- Dependencies: 236
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 1, false);


--
-- TOC entry 5188 (class 0 OID 0)
-- Dependencies: 232
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 24, true);


--
-- TOC entry 5189 (class 0 OID 0)
-- Dependencies: 240
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_user_groups_id_seq', 1, false);


--
-- TOC entry 5190 (class 0 OID 0)
-- Dependencies: 238
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_user_id_seq', 1, false);


--
-- TOC entry 5191 (class 0 OID 0)
-- Dependencies: 242
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_user_user_permissions_id_seq', 1, false);


--
-- TOC entry 5192 (class 0 OID 0)
-- Dependencies: 244
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 1, false);


--
-- TOC entry 5193 (class 0 OID 0)
-- Dependencies: 230
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 6, true);


--
-- TOC entry 5194 (class 0 OID 0)
-- Dependencies: 228
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 18, true);


--
-- TOC entry 4934 (class 2606 OID 16503)
-- Name: application application_pkey; Type: CONSTRAINT; Schema: nails; Owner: postgres
--

ALTER TABLE ONLY nails.application
    ADD CONSTRAINT application_pkey PRIMARY KEY (pk_application);


--
-- TOC entry 4936 (class 2606 OID 16505)
-- Name: status status_pkey; Type: CONSTRAINT; Schema: nails; Owner: postgres
--

ALTER TABLE ONLY nails.status
    ADD CONSTRAINT status_pkey PRIMARY KEY (pk_status);


--
-- TOC entry 4938 (class 2606 OID 16507)
-- Name: user user_pkey; Type: CONSTRAINT; Schema: nails; Owner: postgres
--

ALTER TABLE ONLY nails."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (pk_user);


--
-- TOC entry 4952 (class 2606 OID 24755)
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- TOC entry 4957 (class 2606 OID 24676)
-- Name: auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- TOC entry 4960 (class 2606 OID 24628)
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 4954 (class 2606 OID 24617)
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- TOC entry 4947 (class 2606 OID 24667)
-- Name: auth_permission auth_permission_content_type_id_codename_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- TOC entry 4949 (class 2606 OID 24609)
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- TOC entry 4968 (class 2606 OID 24656)
-- Name: auth_user_groups auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- TOC entry 4971 (class 2606 OID 24691)
-- Name: auth_user_groups auth_user_groups_user_id_group_id_94350c0c_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_group_id_94350c0c_uniq UNIQUE (user_id, group_id);


--
-- TOC entry 4962 (class 2606 OID 24645)
-- Name: auth_user auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- TOC entry 4974 (class 2606 OID 24665)
-- Name: auth_user_user_permissions auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 4977 (class 2606 OID 24705)
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_permission_id_14a6b632_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_permission_id_14a6b632_uniq UNIQUE (user_id, permission_id);


--
-- TOC entry 4965 (class 2606 OID 24748)
-- Name: auth_user auth_user_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- TOC entry 4980 (class 2606 OID 24732)
-- Name: django_admin_log django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- TOC entry 4942 (class 2606 OID 24599)
-- Name: django_content_type django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- TOC entry 4944 (class 2606 OID 24597)
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- TOC entry 4940 (class 2606 OID 24587)
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 4984 (class 2606 OID 24768)
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- TOC entry 4950 (class 1259 OID 24756)
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);


--
-- TOC entry 4955 (class 1259 OID 24687)
-- Name: auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);


--
-- TOC entry 4958 (class 1259 OID 24688)
-- Name: auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);


--
-- TOC entry 4945 (class 1259 OID 24673)
-- Name: auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);


--
-- TOC entry 4966 (class 1259 OID 24703)
-- Name: auth_user_groups_group_id_97559544; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_groups_group_id_97559544 ON public.auth_user_groups USING btree (group_id);


--
-- TOC entry 4969 (class 1259 OID 24702)
-- Name: auth_user_groups_user_id_6a12ed8b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_groups_user_id_6a12ed8b ON public.auth_user_groups USING btree (user_id);


--
-- TOC entry 4972 (class 1259 OID 24717)
-- Name: auth_user_user_permissions_permission_id_1fbb5f2c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_user_permissions_permission_id_1fbb5f2c ON public.auth_user_user_permissions USING btree (permission_id);


--
-- TOC entry 4975 (class 1259 OID 24716)
-- Name: auth_user_user_permissions_user_id_a95ead1b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_user_permissions_user_id_a95ead1b ON public.auth_user_user_permissions USING btree (user_id);


--
-- TOC entry 4963 (class 1259 OID 24749)
-- Name: auth_user_username_6821ab7c_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_username_6821ab7c_like ON public.auth_user USING btree (username varchar_pattern_ops);


--
-- TOC entry 4978 (class 1259 OID 24743)
-- Name: django_admin_log_content_type_id_c4bce8eb; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON public.django_admin_log USING btree (content_type_id);


--
-- TOC entry 4981 (class 1259 OID 24744)
-- Name: django_admin_log_user_id_c564eba6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_admin_log_user_id_c564eba6 ON public.django_admin_log USING btree (user_id);


--
-- TOC entry 4982 (class 1259 OID 24770)
-- Name: django_session_expire_date_a5c62663; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);


--
-- TOC entry 4985 (class 1259 OID 24769)
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);


--
-- TOC entry 4986 (class 2606 OID 16508)
-- Name: application application_fk_status_fkey; Type: FK CONSTRAINT; Schema: nails; Owner: postgres
--

ALTER TABLE ONLY nails.application
    ADD CONSTRAINT application_fk_status_fkey FOREIGN KEY (fk_status) REFERENCES nails.status(pk_status) NOT VALID;


--
-- TOC entry 4987 (class 2606 OID 16513)
-- Name: application application_fk_user_fkey; Type: FK CONSTRAINT; Schema: nails; Owner: postgres
--

ALTER TABLE ONLY nails.application
    ADD CONSTRAINT application_fk_user_fkey FOREIGN KEY (fk_user) REFERENCES nails."user"(pk_user) NOT VALID;


--
-- TOC entry 4989 (class 2606 OID 24682)
-- Name: auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4990 (class 2606 OID 24677)
-- Name: auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4988 (class 2606 OID 24668)
-- Name: auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4991 (class 2606 OID 24697)
-- Name: auth_user_groups auth_user_groups_group_id_97559544_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_97559544_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4992 (class 2606 OID 24692)
-- Name: auth_user_groups auth_user_groups_user_id_6a12ed8b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_6a12ed8b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4993 (class 2606 OID 24711)
-- Name: auth_user_user_permissions auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4994 (class 2606 OID 24706)
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4995 (class 2606 OID 24733)
-- Name: django_admin_log django_admin_log_content_type_id_c4bce8eb_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- TOC entry 4996 (class 2606 OID 24738)
-- Name: django_admin_log django_admin_log_user_id_c564eba6_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


-- Completed on 2026-06-03 23:52:26

--
-- PostgreSQL database dump complete
--

\unrestrict kbAz5om6ot5VImEegkhZQbByJkTb7ci5bG11YBflznKTYATRlQKE2bAJl0D7pWg

