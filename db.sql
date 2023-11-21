--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1
-- Dumped by pg_dump version 16.1

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
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


--
-- Name: care_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.care_type AS ENUM (
    'babysitter',
    'caregiver_for_elderly',
    'playmate_for_children'
);


ALTER TYPE public.care_type OWNER TO postgres;

--
-- Name: status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.status AS ENUM (
    'confirmed',
    'declined',
    'in_progress'
);


ALTER TYPE public.status OWNER TO postgres;

--
-- Name: type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.type AS ENUM (
    'babysitter',
    'caregiver_for_elderly',
    'playmate_for_children'
);


ALTER TYPE public.type OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: address; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.address (
    member_user_id integer NOT NULL,
    house_number integer,
    street character varying,
    town character varying
);


ALTER TABLE public.address OWNER TO postgres;

--
-- Name: appointments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.appointments (
    appointment_id integer NOT NULL,
    caregiver_user_id integer,
    member_user_id integer,
    appointment_date date,
    appointment_time time without time zone,
    work_hours integer,
    status public.status
);


ALTER TABLE public.appointments OWNER TO postgres;

--
-- Name: appointments_appointment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.appointments_appointment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.appointments_appointment_id_seq OWNER TO postgres;

--
-- Name: appointments_appointment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.appointments_appointment_id_seq OWNED BY public.appointments.appointment_id;


--
-- Name: caregivers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.caregivers (
    caregiver_user_id integer NOT NULL,
    photo character varying,
    gender character(1),
    caregiving_type public.care_type,
    hourly_rate double precision
);


ALTER TABLE public.caregivers OWNER TO postgres;

--
-- Name: job_applications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.job_applications (
    caregiver_user_id integer NOT NULL,
    job_id integer NOT NULL,
    date_applied date
);


ALTER TABLE public.job_applications OWNER TO postgres;

--
-- Name: jobs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.jobs (
    job_id integer NOT NULL,
    member_user_id integer,
    required_caregiving_type public.type,
    other_requirements text,
    date_posted date
);


ALTER TABLE public.jobs OWNER TO postgres;

--
-- Name: jobs_job_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.jobs_job_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.jobs_job_id_seq OWNER TO postgres;

--
-- Name: jobs_job_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.jobs_job_id_seq OWNED BY public.jobs.job_id;


--
-- Name: members; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.members (
    member_user_id integer NOT NULL,
    house_rate character varying
);


ALTER TABLE public.members OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    email character varying,
    given_name character varying,
    surname character varying,
    city character varying,
    phone_number character varying,
    profile_description character varying,
    password character varying
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_user_id_seq OWNER TO postgres;

--
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- Name: appointments appointment_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments ALTER COLUMN appointment_id SET DEFAULT nextval('public.appointments_appointment_id_seq'::regclass);


--
-- Name: jobs job_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jobs ALTER COLUMN job_id SET DEFAULT nextval('public.jobs_job_id_seq'::regclass);


--
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- Data for Name: address; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.address (member_user_id, house_number, street, town) FROM stdin;
1	26	P.O. Box 403, 8170 A Street	Hof
2	7	703-5800 Sed Ave	San Rafael
3	18	Turan street	Astana
4	89	Syganak street	Astana
5	96	Ap #172-2059 Ornare Av.	Isabela City
6	13	Ap #530-8848 Est. Avenue	Pozo Almonte
7	89	Turan Street	Liévin
8	35	639-2128 Elementum St.	Cartagena
9	94	1712 Nec, Rd.	Hamburg
10	81	Ap #488-649 Lacus. Ave	Moncton
\.


--
-- Data for Name: appointments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.appointments (appointment_id, caregiver_user_id, member_user_id, appointment_date, appointment_time, work_hours, status) FROM stdin;
91	11	1	2023-01-11	21:20:00	5	confirmed
92	12	2	2023-07-27	16:22:00	5	in_progress
93	13	3	2023-03-02	18:56:00	1	declined
94	14	4	2023-09-21	11:28:00	1	confirmed
95	15	5	2023-03-18	21:19:00	1	confirmed
96	16	6	2022-11-19	11:22:00	6	in_progress
97	17	7	2023-06-18	20:35:00	9	confirmed
98	18	8	2023-07-28	23:29:00	7	confirmed
99	19	9	2023-01-24	23:32:00	7	declined
100	20	10	2023-05-09	16:32:00	2	declined
\.


--
-- Data for Name: caregivers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.caregivers (caregiver_user_id, photo, gender, caregiving_type, hourly_rate) FROM stdin;
11	https=//www.freepik.com/photos/people	m	babysitter	16
12	https=//www.freepik.com/photos/people	m	babysitter	23
13	https=//www.freepik.com/photos/people	f	caregiver_for_elderly	24
14	https=//www.freepik.com/photos/people	f	caregiver_for_elderly	27
15	https=//www.freepik.com/photos/people	m	playmate_for_children	29
16	https=//www.freepik.com/photos/people	m	playmate_for_children	26
17	https=//www.freepik.com/photos/people	f	babysitter	28
18	https=//www.freepik.com/photos/people	f	babysitter	26
19	https=//www.freepik.com/photos/people	m	caregiver_for_elderly	28
20	https=//www.freepik.com/photos/people	m	caregiver_for_elderly	28
\.


--
-- Data for Name: job_applications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.job_applications (caregiver_user_id, job_id, date_applied) FROM stdin;
11	51	2023-04-16
12	52	2024-11-14
13	53	2024-10-30
14	54	2024-05-28
15	55	2023-09-25
16	56	2022-11-23
17	57	2024-02-06
18	58	2024-10-15
19	59	2024-07-11
20	60	2023-01-06
\.


--
-- Data for Name: jobs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.jobs (job_id, member_user_id, required_caregiving_type, other_requirements, date_posted) FROM stdin;
51	1	babysitter	ut odio	2023-07-09
52	2	babysitter	neque venenatis lacus. Etiam	2023-04-15
54	4	caregiver_for_elderly	aliquet. Proin velit. No pets	2023-09-15
55	5	playmate_for_children	Sed congue, elit sed consequat auctor, nunc	2023-06-16
56	6	playmate_for_children	at risus. Nunc	2023-05-23
57	7	babysitter	malesuada fames ac turpis egestas. Aliquam fringilla	2022-11-25
58	8	babysitter	sed dolor. Fusce	2022-12-03
59	9	caregiver_for_elderly	a tortor. Nunc commodo auctor velit. Gentle	2023-11-16
60	10	caregiver_for_elderly	Sed malesuada augue ut lacus. Gentle	2023-08-29
53	3	caregiver_for_elderly	sed dui. No pets	2023-10-09
\.


--
-- Data for Name: members; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.members (member_user_id, house_rate) FROM stdin;
1	id sapien. Cras dolor dolor,
2	sagittis. Duis
3	quis diam luctus lobortis. Class aptent
4	vel nisl. Quisque fringilla euismod enim. Etiam gravida
5	Integer aliquam
6	accumsan sed, facilisis
7	Duis volutpat nunc sit amet metus. Aliquam erat volutpat.
8	magna. Duis dignissim tempor arcu. Vestibulum ut eros
9	quis diam. Pellentesque habitant morbi tristique senectus et netus et
10	eleifend non, dapibus rutrum, justo. Praesent luctus. Curabitur egestas nunc
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, email, given_name, surname, city, phone_number, profile_description, password) FROM stdin;
1	nibh@icloud.ca	Askar	Askarov	Astana	+7027887526	vitae odio	CVL13VMH6RX
2	adipiscing.elit@outlook.org	Bolat	Bolatov	Astana	+7645048255	neque. Nullam nisl. Maecenas malesuada fringilla est. Mauris	QFY61YNJ1LM
3	mauris@google.edu	Simon	Weeks	Polatl	+7276335272	commodo ipsum. Suspendisse non leo.	WFC72QDZ5BF
4	sagittis@aol.com	Hyatt	Acosta	Chờ	+7751851778	cursus et, magna. Praesent	PZF48HVJ6PB
5	nulla.tincidunt@protonmail.net	Ruby	Ball	Gisborne	+7695909839	montes,	OCS76DDA5JI
6	ligula.elit@icloud.com	Cadman	Sparks	San Donato di Ninea	+7764012735	aliquam, enim nec tempus scelerisque, lorem	DGO28RYB4PJ
7	non.cursus.non@yahoo.edu	Judah	Thompson	Gmunden	+7320639882	Pellentesque	JAG64XXE5LE
8	nascetur.ridiculus.mus@google.ca	Sarah	Bennett	Baguio	+7170852331	tempus, lorem fringilla ornare placerat, orci lacus vestibulum	ITF34MPH3WH
9	neque@google.edu	Desirae	Forbes	San Andrés	+7951883918	sit amet, consectetuer adipiscing elit. Etiam laoreet, libero et	HJM43MPL3KT
10	at.egestas.a@aol.net	Dennis	Phillips	Assen	+7824223564	pede, ultrices a, auctor non, feugiat nec,	THZ71VNI3DL
11	pulvinar.arcu@hotmail.couk	Keaton	Ferguson	Girardot	+7412432248	lobortis. Class aptent taciti sociosqu ad litora	GOS64ESC4JY
12	sapien@aol.org	Alvin	Carson	Picton	+7853364232	Duis sit amet diam eu dolor egestas rhoncus.	ELT34XFL3TX
13	in.tincidunt@outlook.couk	Madison	Benjamin	Kremenchuk	+7232648114	quam quis diam. Pellentesque	FOK50YVK5BU
14	tincidunt@hotmail.edu	Charde	Pittman	Sokoto	+7571689245	ut aliquam iaculis, lacus	CGV34QBV6TC
15	nec.mollis.vitae@google.com	Karyn	Woodward	Niterói	+7487397061	gravida. Praesent eu	LXO18TBD7RG
16	nec.euismod@icloud.net	Price	Glenn	Gansu	+7589906375	ultrices. Duis volutpat nunc sit amet metus. Aliquam	MDT39LNY3LA
17	sodales.elit@icloud.com	Desirae	Rhodes	Ulundi	+7267323301	felis orci, adipiscing	ILD32KVL2VJ
18	ornare@icloud.org	Steven	Gallegos	Canberra	+7246459676	lorem ut aliquam iaculis, lacus pede sagittis augue,	MCH04TQJ8IS
19	ipsum@protonmail.org	Ella	Rocha	Utrecht	+7125842836	amet diam eu dolor egestas rhoncus. Proin	EOP85ZOQ5NX
20	ultrices.iaculis.odio@yahoo.org	Dennis	Dominguez	Meißen	+7230941948	consectetuer, cursus et, magna. Praesent interdum	FSU48ZUO1EZ
\.


--
-- Name: appointments_appointment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.appointments_appointment_id_seq', 1, false);


--
-- Name: jobs_job_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.jobs_job_id_seq', 1, false);


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_id_seq', 1, false);


--
-- Name: address address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.address
    ADD CONSTRAINT address_pkey PRIMARY KEY (member_user_id);


--
-- Name: appointments appointments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_pkey PRIMARY KEY (appointment_id);


--
-- Name: caregivers caregivers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caregivers
    ADD CONSTRAINT caregivers_pkey PRIMARY KEY (caregiver_user_id);


--
-- Name: job_applications job_applications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_applications
    ADD CONSTRAINT job_applications_pkey PRIMARY KEY (caregiver_user_id, job_id);


--
-- Name: jobs jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (job_id);


--
-- Name: members members_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.members
    ADD CONSTRAINT members_pkey PRIMARY KEY (member_user_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: address address_member_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.address
    ADD CONSTRAINT address_member_user_id_fkey FOREIGN KEY (member_user_id) REFERENCES public.members(member_user_id) ON DELETE CASCADE;


--
-- Name: appointments appointments_caregiver_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_caregiver_user_id_fkey FOREIGN KEY (caregiver_user_id) REFERENCES public.caregivers(caregiver_user_id) ON DELETE CASCADE;


--
-- Name: appointments appointments_member_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_member_user_id_fkey FOREIGN KEY (member_user_id) REFERENCES public.members(member_user_id) ON DELETE CASCADE;


--
-- Name: caregivers caregivers_caregiver_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.caregivers
    ADD CONSTRAINT caregivers_caregiver_user_id_fkey FOREIGN KEY (caregiver_user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: job_applications job_applications_caregiver_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_applications
    ADD CONSTRAINT job_applications_caregiver_user_id_fkey FOREIGN KEY (caregiver_user_id) REFERENCES public.caregivers(caregiver_user_id) ON DELETE CASCADE;


--
-- Name: job_applications job_applications_job_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_applications
    ADD CONSTRAINT job_applications_job_id_fkey FOREIGN KEY (job_id) REFERENCES public.jobs(job_id) ON DELETE CASCADE;


--
-- Name: jobs jobs_member_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_member_user_id_fkey FOREIGN KEY (member_user_id) REFERENCES public.members(member_user_id) ON DELETE CASCADE;


--
-- Name: members members_member_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.members
    ADD CONSTRAINT members_member_user_id_fkey FOREIGN KEY (member_user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

