--
-- PostgreSQL database dump
--

-- Dumped from database version 14.18 (Homebrew)
-- Dumped by pg_dump version 14.18 (Homebrew)

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
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: answers; Type: TABLE; Schema: public; Owner: gerin
--

CREATE TABLE public.answers (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    student_id uuid NOT NULL,
    question_id uuid NOT NULL,
    package_id uuid NOT NULL,
    selected_answer character varying(1) NOT NULL,
    is_correct boolean,
    school_id uuid
);


ALTER TABLE public.answers OWNER TO gerin;

--
-- Name: chatbot_logs; Type: TABLE; Schema: public; Owner: gerin
--

CREATE TABLE public.chatbot_logs (
    id uuid NOT NULL,
    student_id uuid NOT NULL,
    message_from character varying(50) NOT NULL,
    message text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    school_id uuid
);


ALTER TABLE public.chatbot_logs OWNER TO gerin;

--
-- Name: feedbacks; Type: TABLE; Schema: public; Owner: gerin
--

CREATE TABLE public.feedbacks (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    teacher_id uuid NOT NULL,
    student_id uuid NOT NULL,
    content text,
    created_at timestamp with time zone,
    school_id uuid
);


ALTER TABLE public.feedbacks OWNER TO gerin;

--
-- Name: invitation_codes; Type: TABLE; Schema: public; Owner: gerin
--

CREATE TABLE public.invitation_codes (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    school_id uuid,
    code text NOT NULL,
    max_usage bigint DEFAULT '-1'::integer,
    used_count bigint DEFAULT 0,
    valid_until timestamp with time zone,
    created_at timestamp with time zone
);


ALTER TABLE public.invitation_codes OWNER TO gerin;

--
-- Name: learning_insights; Type: TABLE; Schema: public; Owner: gerin
--

CREATE TABLE public.learning_insights (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    student_id uuid NOT NULL,
    strength text,
    weakness text,
    last_updated timestamp with time zone,
    school_id uuid
);


ALTER TABLE public.learning_insights OWNER TO gerin;

--
-- Name: learning_profiles; Type: TABLE; Schema: public; Owner: gerin
--

CREATE TABLE public.learning_profiles (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    student_id uuid NOT NULL,
    preferred_learning_style text,
    learning_pace text,
    focus_area text,
    updated_at timestamp with time zone,
    school_id uuid
);


ALTER TABLE public.learning_profiles OWNER TO gerin;

--
-- Name: learning_tips; Type: TABLE; Schema: public; Owner: gerin
--

CREATE TABLE public.learning_tips (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    student_id uuid NOT NULL,
    teacher_id uuid NOT NULL,
    subject_id uuid,
    tip text NOT NULL,
    school_id uuid,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    package_id uuid
);


ALTER TABLE public.learning_tips OWNER TO gerin;

--
-- Name: question_packages; Type: TABLE; Schema: public; Owner: gerin
--

CREATE TABLE public.question_packages (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    title text NOT NULL,
    description text,
    subject_id uuid NOT NULL,
    created_by uuid NOT NULL,
    grade text,
    school_id uuid,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE public.question_packages OWNER TO gerin;

--
-- Name: questions; Type: TABLE; Schema: public; Owner: gerin
--

CREATE TABLE public.questions (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    package_id uuid NOT NULL,
    question_text text NOT NULL,
    option_a text NOT NULL,
    option_b text NOT NULL,
    option_c text NOT NULL,
    option_d text NOT NULL,
    correct_answer text,
    school_id uuid,
    time_limit bigint,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    is_active boolean DEFAULT true,
    start_date timestamp with time zone,
    end_date timestamp with time zone
);


ALTER TABLE public.questions OWNER TO gerin;

--
-- Name: quiz_histories; Type: TABLE; Schema: public; Owner: gerin
--

CREATE TABLE public.quiz_histories (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    student_id uuid NOT NULL,
    package_id uuid NOT NULL,
    question_id uuid NOT NULL,
    selected_answer character varying(1),
    is_correct boolean,
    score numeric,
    answered_at timestamp with time zone,
    school_id uuid,
    start_time timestamp with time zone,
    end_time timestamp with time zone,
    attempt_id uuid
);


ALTER TABLE public.quiz_histories OWNER TO gerin;

--
-- Name: quiz_results; Type: TABLE; Schema: public; Owner: gerin
--

CREATE TABLE public.quiz_results (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    student_id uuid NOT NULL,
    package_id uuid NOT NULL,
    total_questions bigint,
    correct_answers bigint,
    score numeric,
    submitted_at timestamp with time zone,
    grade text,
    school_id uuid,
    start_time timestamp with time zone,
    end_time timestamp with time zone,
    attempt_count bigint DEFAULT 1
);


ALTER TABLE public.quiz_results OWNER TO gerin;

--
-- Name: schools; Type: TABLE; Schema: public; Owner: gerin
--

CREATE TABLE public.schools (
    id uuid NOT NULL,
    name text NOT NULL,
    address text,
    created_at timestamp without time zone,
    npsn text NOT NULL,
    email text NOT NULL
);


ALTER TABLE public.schools OWNER TO gerin;

--
-- Name: student_teachers; Type: TABLE; Schema: public; Owner: gerin
--

CREATE TABLE public.student_teachers (
    student_id uuid NOT NULL,
    teacher_id uuid NOT NULL,
    school_id uuid
);


ALTER TABLE public.student_teachers OWNER TO gerin;

--
-- Name: subjects; Type: TABLE; Schema: public; Owner: gerin
--

CREATE TABLE public.subjects (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name text NOT NULL,
    school_id uuid
);


ALTER TABLE public.subjects OWNER TO gerin;

--
-- Name: users; Type: TABLE; Schema: public; Owner: gerin
--

CREATE TABLE public.users (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name text NOT NULL,
    email text NOT NULL,
    password text NOT NULL,
    phone_number text,
    role text NOT NULL,
    parent_id uuid,
    grade text,
    photo text,
    school_id uuid,
    invitation_code text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE public.users OWNER TO gerin;

--
-- Data for Name: answers; Type: TABLE DATA; Schema: public; Owner: gerin
--

COPY public.answers (id, student_id, question_id, package_id, selected_answer, is_correct, school_id) FROM stdin;
11111111-1111-1111-1111-111111111101	77777777-7777-7777-7777-777777777777	11111111-1111-1111-1111-111111111110	78901234-7890-7890-7890-789012345678	a	f	\N
22222222-2222-2222-2222-222222222201	77777777-7777-7777-7777-777777777777	22222222-2222-2222-2222-222222222220	78901234-7890-7890-7890-789012345678	b	t	\N
33333333-3333-3333-3333-333333333301	88888888-8888-8888-8888-888888888888	11111111-1111-1111-1111-111111111110	78901234-7890-7890-7890-789012345678	c	t	\N
44444444-4444-4444-4444-444444444401	88888888-8888-8888-8888-888888888888	22222222-2222-2222-2222-222222222220	78901234-7890-7890-7890-789012345678	b	t	\N
\.


--
-- Data for Name: chatbot_logs; Type: TABLE DATA; Schema: public; Owner: gerin
--

COPY public.chatbot_logs (id, student_id, message_from, message, created_at, school_id) FROM stdin;
5f7c6da9-7e40-4481-acb5-06696cfaf586	77777777-7777-7777-7777-777777777777	parent	Bagaimana perkembangan belajar anak saya?	2025-07-09 12:44:42.44017+07	\N
9cdc4ba6-6234-4a1f-9045-f7dd14ab22fc	77777777-7777-7777-7777-777777777777	ai	Halo Bapak/Ibu, terima kasih sudah menghubungi saya untuk mengetahui perkembangan belajar Andi dan Lina. Mari kita bahas satu per satu:\n\n**Andi Kurniawan (Kelas 7):**\n\nAndi menunjukkan potensi yang baik dalam matematika, terutama dalam perkalian dasar. Ini adalah fondasi yang bagus! Namun, terlihat Andi masih perlu berlatih lebih banyak dalam operasi penjumlahan yang lebih kompleks.\n\n*   **Saran:** Untuk membantu Andi, coba latih penjumlahan dengan soal-soal yang bervariasi, mulai dari yang sederhana hingga yang lebih rumit. Bapak/Ibu bisa menggunakan media belajar yang menarik seperti permainan atau aplikasi belajar matematika. Ajak Andi untuk mengerjakan soal bersama, sehingga Bapak/Ibu bisa langsung memberikan penjelasan jika Andi mengalami kesulitan. Jangan ragu untuk memecah soal yang kompleks menjadi langkah-langkah yang lebih kecil dan mudah dipahami.\n\n**Lina Handayani (Kelas 8):**\n\nLina memiliki bakat yang luar biasa dalam menulis kreatif. Ini adalah modal yang sangat berharga! Hanya saja, Lina perlu meningkatkan pemahamannya tentang struktur teks dalam Bahasa Indonesia.\n\n*   **Saran:** Untuk Lina, coba ajak dia untuk membaca berbagai jenis teks, seperti cerpen, berita, artikel, dan esai. Setelah membaca, diskusikan bersama tentang struktur teks tersebut, misalnya: apa ide pokoknya, bagaimana gagasan utama dikembangkan, dan bagaimana penulis menyusun argumennya. Bapak/Ibu juga bisa mengajak Lina untuk membuat kerangka karangan sebelum menulis, sehingga dia lebih terstruktur dalam menuangkan ide-idenya.\n\n**Motivasi & Strategi Perbaikan:**\n\nPenting untuk diingat bahwa setiap anak belajar dengan kecepatan yang berbeda. Jangan berkecil hati jika ada area yang perlu ditingkatkan. Berikan dukungan dan motivasi kepada Andi dan Lina, serta fokus pada kekuatan yang mereka miliki. Dengan latihan yang konsisten dan pendekatan belajar yang tepat, saya yakin mereka akan terus berkembang dan meraih prestasi yang lebih baik.\n\nSemoga informasi ini bermanfaat! Jangan ragu untuk bertanya jika ada hal lain yang ingin didiskusikan.	2025-07-09 12:44:42.454635+07	\N
f346afa2-3c8c-47da-8204-1346bbc0fcf4	aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa	parent	Bagaimana perkembangan belajar anak saya?	2025-07-09 12:44:42.456623+07	\N
bb2dd092-5259-4320-a991-2293407f20a7	aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa	ai	Halo Bapak/Ibu, terima kasih sudah menghubungi saya untuk mengetahui perkembangan belajar Andi dan Lina. Mari kita bahas satu per satu:\n\n**Andi Kurniawan (Kelas 7):**\n\nAndi menunjukkan potensi yang baik dalam matematika, terutama dalam perkalian dasar. Ini adalah fondasi yang bagus! Namun, terlihat Andi masih perlu berlatih lebih banyak dalam operasi penjumlahan yang lebih kompleks.\n\n*   **Saran:** Untuk membantu Andi, coba latih penjumlahan dengan soal-soal yang bervariasi, mulai dari yang sederhana hingga yang lebih rumit. Bapak/Ibu bisa menggunakan media belajar yang menarik seperti permainan atau aplikasi belajar matematika. Ajak Andi untuk mengerjakan soal bersama, sehingga Bapak/Ibu bisa langsung memberikan penjelasan jika Andi mengalami kesulitan. Jangan ragu untuk memecah soal yang kompleks menjadi langkah-langkah yang lebih kecil dan mudah dipahami.\n\n**Lina Handayani (Kelas 8):**\n\nLina memiliki bakat yang luar biasa dalam menulis kreatif. Ini adalah modal yang sangat berharga! Hanya saja, Lina perlu meningkatkan pemahamannya tentang struktur teks dalam Bahasa Indonesia.\n\n*   **Saran:** Untuk Lina, coba ajak dia untuk membaca berbagai jenis teks, seperti cerpen, berita, artikel, dan esai. Setelah membaca, diskusikan bersama tentang struktur teks tersebut, misalnya: apa ide pokoknya, bagaimana gagasan utama dikembangkan, dan bagaimana penulis menyusun argumennya. Bapak/Ibu juga bisa mengajak Lina untuk membuat kerangka karangan sebelum menulis, sehingga dia lebih terstruktur dalam menuangkan ide-idenya.\n\n**Motivasi & Strategi Perbaikan:**\n\nPenting untuk diingat bahwa setiap anak belajar dengan kecepatan yang berbeda. Jangan berkecil hati jika ada area yang perlu ditingkatkan. Berikan dukungan dan motivasi kepada Andi dan Lina, serta fokus pada kekuatan yang mereka miliki. Dengan latihan yang konsisten dan pendekatan belajar yang tepat, saya yakin mereka akan terus berkembang dan meraih prestasi yang lebih baik.\n\nSemoga informasi ini bermanfaat! Jangan ragu untuk bertanya jika ada hal lain yang ingin didiskusikan.	2025-07-09 12:44:42.458148+07	\N
1bf809ee-9372-47f1-99cb-1f07847fe70b	77777777-7777-7777-7777-777777777777	parent	Bagaimana performa siswa di kelas saya?	2025-07-09 12:46:17.385675+07	\N
cb90f2ae-296d-4a0e-80f3-bdade59fe014	77777777-7777-7777-7777-777777777777	ai	Halo! Sebagai asisten pendidikan, saya senang bisa membantu Anda memahami performa kedua buah hati Anda di sekolah.\n\n**Andi Kurniawan (Kelas 7):**\n\nAndi menunjukkan potensi yang baik dalam matematika, terutama dalam perkalian dasar. Ini adalah fondasi yang bagus! Namun, terlihat ada sedikit tantangan dalam operasi penjumlahan yang lebih kompleks.\n\n*   **Saran:** Mungkin Andi bisa mencoba latihan penjumlahan dengan soal-soal yang bervariasi, mulai dari yang sederhana hingga yang lebih rumit. Visualisasi dengan menggunakan benda-benda konkret (seperti kancing atau balok) juga bisa membantu memahami konsep penjumlahan dengan lebih baik.\n*   **Tips Belajar:** Karena Andi sudah mahir dalam perkalian, coba kaitkan penjumlahan dengan perkalian. Misalnya, "5 + 5 + 5 sama dengan 3 kelompok 5, yang sama dengan 3 x 5."\n\n**Lina Handayani (Kelas 8):**\n\nLina memiliki bakat yang luar biasa dalam menulis kreatif! Ini adalah modal yang sangat berharga. Namun, saat ini Lina masih perlu meningkatkan pemahaman tentang struktur teks dalam Bahasa Indonesia.\n\n*   **Saran:** Ajak Lina untuk membaca berbagai jenis teks, seperti berita, cerpen, artikel, dan esai. Setelah membaca, diskusikan bersama tentang struktur teks tersebut: apa ide pokoknya, bagaimana argumennya disusun, dan bagaimana kesimpulannya ditarik.\n*   **Tips Belajar:** Karena Lina kreatif dalam menulis, coba minta dia untuk membuat ringkasan atau *mind map* dari teks yang dibaca. Ini akan membantunya memahami struktur teks dengan lebih baik sambil tetap memanfaatkan kreativitasnya.\n\n**Motivasi:**\n\nMeskipun ada beberapa area yang perlu ditingkatkan, penting untuk diingat bahwa setiap anak memiliki kekuatan dan potensi yang unik. Dengan dukungan dan strategi belajar yang tepat, Andi dan Lina pasti bisa meraih hasil yang lebih baik lagi. Terus berikan semangat dan pujian atas usaha mereka, ya!	2025-07-09 12:46:17.398296+07	\N
b248bb99-e15c-49aa-be10-1ab8884dae3b	aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa	parent	Bagaimana performa siswa di kelas saya?	2025-07-09 12:46:17.399523+07	\N
31677960-1a45-4e04-95c6-dda8d658bef2	aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa	ai	Halo! Sebagai asisten pendidikan, saya senang bisa membantu Anda memahami performa kedua buah hati Anda di sekolah.\n\n**Andi Kurniawan (Kelas 7):**\n\nAndi menunjukkan potensi yang baik dalam matematika, terutama dalam perkalian dasar. Ini adalah fondasi yang bagus! Namun, terlihat ada sedikit tantangan dalam operasi penjumlahan yang lebih kompleks.\n\n*   **Saran:** Mungkin Andi bisa mencoba latihan penjumlahan dengan soal-soal yang bervariasi, mulai dari yang sederhana hingga yang lebih rumit. Visualisasi dengan menggunakan benda-benda konkret (seperti kancing atau balok) juga bisa membantu memahami konsep penjumlahan dengan lebih baik.\n*   **Tips Belajar:** Karena Andi sudah mahir dalam perkalian, coba kaitkan penjumlahan dengan perkalian. Misalnya, "5 + 5 + 5 sama dengan 3 kelompok 5, yang sama dengan 3 x 5."\n\n**Lina Handayani (Kelas 8):**\n\nLina memiliki bakat yang luar biasa dalam menulis kreatif! Ini adalah modal yang sangat berharga. Namun, saat ini Lina masih perlu meningkatkan pemahaman tentang struktur teks dalam Bahasa Indonesia.\n\n*   **Saran:** Ajak Lina untuk membaca berbagai jenis teks, seperti berita, cerpen, artikel, dan esai. Setelah membaca, diskusikan bersama tentang struktur teks tersebut: apa ide pokoknya, bagaimana argumennya disusun, dan bagaimana kesimpulannya ditarik.\n*   **Tips Belajar:** Karena Lina kreatif dalam menulis, coba minta dia untuk membuat ringkasan atau *mind map* dari teks yang dibaca. Ini akan membantunya memahami struktur teks dengan lebih baik sambil tetap memanfaatkan kreativitasnya.\n\n**Motivasi:**\n\nMeskipun ada beberapa area yang perlu ditingkatkan, penting untuk diingat bahwa setiap anak memiliki kekuatan dan potensi yang unik. Dengan dukungan dan strategi belajar yang tepat, Andi dan Lina pasti bisa meraih hasil yang lebih baik lagi. Terus berikan semangat dan pujian atas usaha mereka, ya!	2025-07-09 12:46:17.401528+07	\N
c4b1dda6-a27c-4034-ab10-a152eafe854d	77777777-7777-7777-7777-777777777777	teacher	Bagaimana performa siswa di kelas saya?	2025-07-09 12:48:27.444605+07	\N
5357951c-0ace-4718-8aba-d0f13656b555	77777777-7777-7777-7777-777777777777	ai	Halo Bapak/Ibu Guru,\n\nBerikut adalah gambaran performa siswa di kelas Bapak/Ibu:\n\n**Kelas 7:**\n\n*   **Andi Kurniawan:** Andi menunjukkan potensi, namun perlu fokus pada pemahaman operasi penjumlahan kompleks. Rata-rata nilainya 50%, yang menunjukkan ruang untuk perbaikan. Bapak/Ibu bisa memberikan latihan soal penjumlahan yang bertahap, dimulai dari yang sederhana hingga kompleks. Pendekatan visual mungkin membantu Andi memahami konsepnya. Berikan pujian atas setiap kemajuan yang dicapai untuk meningkatkan motivasinya.\n\n*   **Sari Melati:** Sari memiliki pemahaman materi yang sangat baik dengan rata-rata nilai 100%. Namun, perlu ditingkatkan fokusnya dalam membaca soal. Bapak/Ibu bisa melatih Sari dengan teknik membaca aktif, seperti menggarisbawahi kata kunci atau mencatat poin-poin penting dari soal.\n\n**Kelas 8:**\n\n*   **Roni Pratama:** Roni memiliki pemahaman materi yang sangat baik dengan rata-rata nilai 100%. Namun, perlu ditingkatkan ketelitiannya dalam perhitungan. Bapak/Ibu bisa menyarankan Roni untuk memeriksa ulang pekerjaannya setelah selesai dan menggunakan kalkulator untuk perhitungan yang rumit.\n\nSecara keseluruhan, kelas Bapak/Ibu memiliki siswa dengan potensi yang baik. Dengan memberikan perhatian khusus pada area-area yang perlu ditingkatkan, saya yakin para siswa dapat mencapai hasil yang lebih optimal. Jangan ragu untuk memberikan dukungan dan motivasi kepada mereka. Semangat!	2025-07-09 12:48:27.452605+07	\N
dc2dc687-16a0-49eb-85a5-205d963a1e33	88888888-8888-8888-8888-888888888888	teacher	Bagaimana performa siswa di kelas saya?	2025-07-09 12:48:27.455681+07	\N
9cc3a3fc-8cb7-4356-8184-7da1d303b013	88888888-8888-8888-8888-888888888888	ai	Halo Bapak/Ibu Guru,\n\nBerikut adalah gambaran performa siswa di kelas Bapak/Ibu:\n\n**Kelas 7:**\n\n*   **Andi Kurniawan:** Andi menunjukkan potensi, namun perlu fokus pada pemahaman operasi penjumlahan kompleks. Rata-rata nilainya 50%, yang menunjukkan ruang untuk perbaikan. Bapak/Ibu bisa memberikan latihan soal penjumlahan yang bertahap, dimulai dari yang sederhana hingga kompleks. Pendekatan visual mungkin membantu Andi memahami konsepnya. Berikan pujian atas setiap kemajuan yang dicapai untuk meningkatkan motivasinya.\n\n*   **Sari Melati:** Sari memiliki pemahaman materi yang sangat baik dengan rata-rata nilai 100%. Namun, perlu ditingkatkan fokusnya dalam membaca soal. Bapak/Ibu bisa melatih Sari dengan teknik membaca aktif, seperti menggarisbawahi kata kunci atau mencatat poin-poin penting dari soal.\n\n**Kelas 8:**\n\n*   **Roni Pratama:** Roni memiliki pemahaman materi yang sangat baik dengan rata-rata nilai 100%. Namun, perlu ditingkatkan ketelitiannya dalam perhitungan. Bapak/Ibu bisa menyarankan Roni untuk memeriksa ulang pekerjaannya setelah selesai dan menggunakan kalkulator untuk perhitungan yang rumit.\n\nSecara keseluruhan, kelas Bapak/Ibu memiliki siswa dengan potensi yang baik. Dengan memberikan perhatian khusus pada area-area yang perlu ditingkatkan, saya yakin para siswa dapat mencapai hasil yang lebih optimal. Jangan ragu untuk memberikan dukungan dan motivasi kepada mereka. Semangat!	2025-07-09 12:48:27.456778+07	\N
6152137e-2a7b-4ccc-a676-8c4466e344a5	99999999-9999-9999-9999-999999999999	teacher	Bagaimana performa siswa di kelas saya?	2025-07-09 12:48:27.457775+07	\N
2bc761e6-8536-4067-885a-78ea87307640	99999999-9999-9999-9999-999999999999	ai	Halo Bapak/Ibu Guru,\n\nBerikut adalah gambaran performa siswa di kelas Bapak/Ibu:\n\n**Kelas 7:**\n\n*   **Andi Kurniawan:** Andi menunjukkan potensi, namun perlu fokus pada pemahaman operasi penjumlahan kompleks. Rata-rata nilainya 50%, yang menunjukkan ruang untuk perbaikan. Bapak/Ibu bisa memberikan latihan soal penjumlahan yang bertahap, dimulai dari yang sederhana hingga kompleks. Pendekatan visual mungkin membantu Andi memahami konsepnya. Berikan pujian atas setiap kemajuan yang dicapai untuk meningkatkan motivasinya.\n\n*   **Sari Melati:** Sari memiliki pemahaman materi yang sangat baik dengan rata-rata nilai 100%. Namun, perlu ditingkatkan fokusnya dalam membaca soal. Bapak/Ibu bisa melatih Sari dengan teknik membaca aktif, seperti menggarisbawahi kata kunci atau mencatat poin-poin penting dari soal.\n\n**Kelas 8:**\n\n*   **Roni Pratama:** Roni memiliki pemahaman materi yang sangat baik dengan rata-rata nilai 100%. Namun, perlu ditingkatkan ketelitiannya dalam perhitungan. Bapak/Ibu bisa menyarankan Roni untuk memeriksa ulang pekerjaannya setelah selesai dan menggunakan kalkulator untuk perhitungan yang rumit.\n\nSecara keseluruhan, kelas Bapak/Ibu memiliki siswa dengan potensi yang baik. Dengan memberikan perhatian khusus pada area-area yang perlu ditingkatkan, saya yakin para siswa dapat mencapai hasil yang lebih optimal. Jangan ragu untuk memberikan dukungan dan motivasi kepada mereka. Semangat!	2025-07-09 12:48:27.458984+07	\N
4f25b7d0-7b15-413a-a62d-2e87908442ca	77777777-7777-7777-7777-777777777777	user	Bisa jelaskan materi aljabar untuk kelas 8?	2025-07-09 12:50:44.179703+07	\N
c88bbcb5-d198-42f7-8045-99fe872e81f9	77777777-7777-7777-7777-777777777777	ai	Hai! Semangat belajar ya untuk siswa dengan ID 77777777-7777-7777-7777-777777777777!\n\nKamu bertanya tentang materi aljabar untuk kelas 8, ya? Oke, mari kita bahas! Aljabar di kelas 8 itu seperti jembatan yang menghubungkan aritmatika (hitungan biasa) dengan matematika yang lebih kompleks.\n\nSecara garis besar, aljabar kelas 8 akan membahas tentang:\n\n*   **Persamaan Linear Satu Variabel (PLSV):** Ini tentang mencari nilai 'x' dalam persamaan seperti 2x + 3 = 7. Kamu akan belajar cara memindahkan angka, menggabungkan suku sejenis, dan akhirnya menemukan nilai x.\n*   **Pertidaksamaan Linear Satu Variabel (PtLSV):** Mirip dengan PLSV, tapi bukan tanda sama dengan (=), melainkan tanda lebih besar (>), lebih kecil (<), lebih besar sama dengan (≥), atau lebih kecil sama dengan (≤). Misalnya, 3x - 1 < 8.\n*   **Sistem Persamaan Linear Dua Variabel (SPLDV):** Nah, ini lebih seru! Kamu akan belajar mencari nilai 'x' dan 'y' yang memenuhi dua persamaan sekaligus. Contohnya, x + y = 5 dan x - y = 1. Ada beberapa metode penyelesaiannya, seperti substitusi, eliminasi, dan grafik.\n\n**Mengingat kamu mahir dalam perkalian dasar, ini akan sangat membantu dalam aljabar, terutama saat menyelesaikan persamaan.**\n\n**Tips Belajar Aljabar untukmu (karena kamu visual learner):**\n\n*   **Visualisasikan Persamaan:** Coba bayangkan persamaan itu seperti timbangan. Apa yang kamu lakukan di satu sisi, harus kamu lakukan juga di sisi lainnya agar tetap seimbang.\n*   **Gunakan Diagram atau Mind Map:** Buat diagram untuk memetakan hubungan antara konsep-konsep aljabar.\n*   **Tonton Video Pembelajaran:** Banyak video keren di YouTube yang menjelaskan aljabar dengan animasi dan visualisasi yang menarik.\n\n**Karena kamu perlu meningkatkan kemampuan penjumlahan kompleks, fokuslah pada latihan soal-soal aljabar yang melibatkan penjumlahan. Ingat pesan dari guru, Andi, untuk mengerjakan 10 soal setiap hari. Jangan khawatir jika awalnya sulit, lama-lama pasti terbiasa!**\n\nSemangat terus belajarnya! Kamu pasti bisa!	2025-07-09 12:50:44.182992+07	\N
199bfc5a-4a30-4497-a28a-79ea29a6d137	77777777-7777-7777-7777-777777777777	user	Bisa jelaskan materi aljabar untuk kelas 8?	2025-07-09 12:54:20.262518+07	\N
0f93ab72-d803-4d54-8a57-a9c23a8f3656	77777777-7777-7777-7777-777777777777	ai	Halo! Semangat belajarnya ya! 👋\n\nKarena kamu siswa dengan ID 77777777-7777-7777-7777-777777777777, mari kita bahas aljabar untuk kelas 8!\n\nAljabar itu seperti bahasa rahasia matematika, yang menggunakan huruf (disebut variabel) untuk mewakili angka yang belum kita ketahui. Di kelas 8, kamu akan belajar tentang:\n\n*   **Persamaan Linear:** Mencari nilai 'x' dalam persamaan seperti 2x + 3 = 7.\n*   **Sistem Persamaan Linear:** Menyelesaikan dua persamaan sekaligus untuk mencari nilai 'x' dan 'y'.\n*   **Faktorisasi:** Mengubah ekspresi aljabar menjadi perkalian bentuk yang lebih sederhana.\n*   **Grafik Persamaan Linear:** Menggambar garis lurus berdasarkan persamaan.\n\n**Tips Belajar Aljabar, khususnya untuk kamu:**\n\n1.  **Visualisasikan:** Karena kamu tipe visual, coba gunakan gambar atau diagram untuk memahami konsep aljabar. Misalnya, gambarkan persamaan linear sebagai garis di grafik.\n2.  **Fokus pada Dasar:** Ingat, kamu perlu memperkuat penjumlahan kompleks. Aljabar seringkali membutuhkan penjumlahan dan pengurangan, jadi pastikan kamu lancar di sana dulu.\n3.  **Latihan Soal Penjumlahan:** Guru kamu menyarankan 10 soal penjumlahan setiap hari. Ini ide bagus! Konsisten ya.\n4.  **Manfaatkan Sumber Belajar:** Gunakan video pembelajaran, aplikasi, atau website interaktif yang menyediakan visualisasi aljabar.\n5.  **Perkalian Dasar Kuat, Pertahankan!** Kamu hebat dalam perkalian dasar. Ini modal bagus untuk belajar aljabar, karena banyak konsep aljabar melibatkan perkalian.\n\n**Jangan Khawatir!**\n\nMeskipun kamu merasa kesulitan dengan penjumlahan kompleks, jangan putus asa! Dengan latihan yang tepat dan strategi belajar yang sesuai dengan gaya belajarmu, kamu pasti bisa menguasai aljabar. Semangat! 😊	2025-07-09 12:54:20.267859+07	\N
9e093fcb-8730-4829-b7fd-defce711373a	77777777-7777-7777-7777-777777777777	parent	Bagaimana perkembangan belajar anak saya?	2025-07-09 12:54:42.025484+07	\N
d7a090c7-726f-4371-bae5-73ba9dc306e4	77777777-7777-7777-7777-777777777777	ai	Halo Bapak/Ibu, terima kasih sudah menghubungi saya untuk menanyakan perkembangan belajar Andi dan Lina.\n\n**Andi Kurniawan (Kelas 7)**\n\nAndi menunjukkan potensi yang baik dalam matematika, terutama dalam perkalian dasar. Ini adalah fondasi yang kuat! Namun, Andi perlu lebih banyak berlatih dalam operasi penjumlahan yang lebih kompleks.\n\n*   **Saran:** Ajak Andi untuk berlatih soal-soal penjumlahan yang bervariasi, mulai dari yang sederhana hingga yang lebih rumit. Bapak/Ibu bisa menggunakan aplikasi belajar matematika atau mencari latihan soal online. Penting untuk memastikan Andi memahami konsep dasar penjumlahan sebelum melangkah ke soal yang lebih sulit.\n*   **Tips:** Coba gunakan benda-benda konkret seperti kancing atau mainan untuk membantu Andi memvisualisasikan penjumlahan. Ini bisa membuat proses belajar lebih menyenangkan dan mudah dipahami.\n\n**Lina Handayani (Kelas 8)**\n\nLina memiliki bakat yang luar biasa dalam menulis kreatif! Ini adalah modal yang sangat berharga. Namun, Lina perlu meningkatkan pemahamannya tentang struktur teks Bahasa Indonesia.\n\n*   **Saran:** Ajak Lina untuk lebih sering membaca berbagai jenis teks, seperti cerpen, artikel, dan berita. Setelah membaca, diskusikan struktur teks tersebut, seperti ide pokok, kalimat utama, dan hubungan antar paragraf.\n*   **Tips:** Coba ajak Lina untuk membuat mind map atau diagram alur untuk memetakan struktur teks. Ini bisa membantu Lina memvisualisasikan dan memahami bagaimana teks disusun.\n\n**Motivasi dan Strategi Perbaikan**\n\nSaya memahami bahwa melihat hasil belajar anak yang kurang memuaskan bisa membuat khawatir. Namun, penting untuk diingat bahwa setiap anak memiliki kecepatan belajar yang berbeda. Tetap berikan dukungan dan motivasi kepada Andi dan Lina. Fokus pada kekuatan mereka dan berikan bantuan yang mereka butuhkan untuk mengatasi kesulitan.\n\nIngatlah bahwa belajar adalah sebuah proses. Dengan dukungan dan strategi yang tepat, Andi dan Lina pasti bisa meraih hasil yang lebih baik. Jangan ragu untuk menghubungi saya lagi jika Bapak/Ibu memiliki pertanyaan lebih lanjut.	2025-07-09 12:54:42.030506+07	\N
37c51dae-2fe4-46a0-9a4b-3171b09e34f0	aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa	parent	Bagaimana perkembangan belajar anak saya?	2025-07-09 12:54:42.032511+07	\N
b7a7a715-8ed1-445f-92d5-015d96b3c144	aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa	ai	Halo Bapak/Ibu, terima kasih sudah menghubungi saya untuk menanyakan perkembangan belajar Andi dan Lina.\n\n**Andi Kurniawan (Kelas 7)**\n\nAndi menunjukkan potensi yang baik dalam matematika, terutama dalam perkalian dasar. Ini adalah fondasi yang kuat! Namun, Andi perlu lebih banyak berlatih dalam operasi penjumlahan yang lebih kompleks.\n\n*   **Saran:** Ajak Andi untuk berlatih soal-soal penjumlahan yang bervariasi, mulai dari yang sederhana hingga yang lebih rumit. Bapak/Ibu bisa menggunakan aplikasi belajar matematika atau mencari latihan soal online. Penting untuk memastikan Andi memahami konsep dasar penjumlahan sebelum melangkah ke soal yang lebih sulit.\n*   **Tips:** Coba gunakan benda-benda konkret seperti kancing atau mainan untuk membantu Andi memvisualisasikan penjumlahan. Ini bisa membuat proses belajar lebih menyenangkan dan mudah dipahami.\n\n**Lina Handayani (Kelas 8)**\n\nLina memiliki bakat yang luar biasa dalam menulis kreatif! Ini adalah modal yang sangat berharga. Namun, Lina perlu meningkatkan pemahamannya tentang struktur teks Bahasa Indonesia.\n\n*   **Saran:** Ajak Lina untuk lebih sering membaca berbagai jenis teks, seperti cerpen, artikel, dan berita. Setelah membaca, diskusikan struktur teks tersebut, seperti ide pokok, kalimat utama, dan hubungan antar paragraf.\n*   **Tips:** Coba ajak Lina untuk membuat mind map atau diagram alur untuk memetakan struktur teks. Ini bisa membantu Lina memvisualisasikan dan memahami bagaimana teks disusun.\n\n**Motivasi dan Strategi Perbaikan**\n\nSaya memahami bahwa melihat hasil belajar anak yang kurang memuaskan bisa membuat khawatir. Namun, penting untuk diingat bahwa setiap anak memiliki kecepatan belajar yang berbeda. Tetap berikan dukungan dan motivasi kepada Andi dan Lina. Fokus pada kekuatan mereka dan berikan bantuan yang mereka butuhkan untuk mengatasi kesulitan.\n\nIngatlah bahwa belajar adalah sebuah proses. Dengan dukungan dan strategi yang tepat, Andi dan Lina pasti bisa meraih hasil yang lebih baik. Jangan ragu untuk menghubungi saya lagi jika Bapak/Ibu memiliki pertanyaan lebih lanjut.	2025-07-09 12:54:42.033596+07	\N
40d2587d-4c43-40e0-968f-fdf6d9be8a53	77777777-7777-7777-7777-777777777777	teacher	Bagaimana performa siswa di kelas saya?	2025-07-09 12:55:11.293915+07	\N
0c40c2a9-4ccb-4b7f-9e4b-2f624e51774c	77777777-7777-7777-7777-777777777777	ai	Halo Bapak/Ibu Guru!\n\nBerikut adalah ringkasan performa siswa di kelas Bapak/Ibu:\n\n*   **Andi Kurniawan (Kelas 7):** Nilai rata-rata Andi masih perlu ditingkatkan, yaitu 50%. Terlihat bahwa Andi mengalami kesulitan dalam operasi penjumlahan yang kompleks. Saya sarankan untuk memberikan latihan tambahan yang lebih terstruktur, dimulai dari soal-soal penjumlahan dasar, kemudian secara bertahap meningkat ke soal yang lebih kompleks. Bapak/Ibu juga bisa menggunakan media visual seperti garis bilangan atau benda konkret untuk membantu Andi memahami konsep penjumlahan dengan lebih baik. Jangan lupa untuk memberikan pujian dan dukungan positif setiap kali Andi berhasil menyelesaikan soal, ini akan meningkatkan kepercayaan dirinya.\n\n*   **Sari Melati (Kelas 7):** Sari memiliki performa yang sangat baik dengan nilai rata-rata 100%! Namun, perlu diperhatikan bahwa Sari perlu lebih fokus saat membaca soal. Bapak/Ibu bisa melatih Sari dengan teknik membaca aktif, seperti menandai kata kunci atau menuliskan informasi penting dari soal. Minta Sari untuk menjelaskan kembali soal dengan kata-katanya sendiri sebelum mulai mengerjakan. Ini akan membantu Sari untuk lebih memahami apa yang diminta dalam soal.\n\n*   **Roni Pratama (Kelas 8):** Roni juga memiliki performa yang sangat baik dengan nilai rata-rata 100%! Hanya saja, Roni perlu lebih teliti dalam perhitungan. Bapak/Ibu bisa mendorong Roni untuk selalu memeriksa kembali pekerjaannya setelah selesai. Ajarkan Roni untuk menggunakan kalkulator sebagai alat bantu untuk memeriksa perhitungan yang rumit. Selain itu, pastikan Roni memiliki cukup waktu untuk mengerjakan soal agar tidak terburu-buru dan melakukan kesalahan yang tidak perlu.\n\nSecara keseluruhan, kelas Bapak/Ibu memiliki potensi yang besar. Dengan perhatian dan strategi yang tepat, Andi, Sari, dan Roni dapat terus meningkatkan kemampuan mereka. Semangat terus, Bapak/Ibu Guru!	2025-07-09 12:55:11.296128+07	\N
41ec06b8-2855-4116-a16b-2600d7c91e6c	88888888-8888-8888-8888-888888888888	teacher	Bagaimana performa siswa di kelas saya?	2025-07-09 12:55:11.297475+07	\N
faaf95a3-647e-47a9-aa7a-0442f4e0e923	88888888-8888-8888-8888-888888888888	ai	Halo Bapak/Ibu Guru!\n\nBerikut adalah ringkasan performa siswa di kelas Bapak/Ibu:\n\n*   **Andi Kurniawan (Kelas 7):** Nilai rata-rata Andi masih perlu ditingkatkan, yaitu 50%. Terlihat bahwa Andi mengalami kesulitan dalam operasi penjumlahan yang kompleks. Saya sarankan untuk memberikan latihan tambahan yang lebih terstruktur, dimulai dari soal-soal penjumlahan dasar, kemudian secara bertahap meningkat ke soal yang lebih kompleks. Bapak/Ibu juga bisa menggunakan media visual seperti garis bilangan atau benda konkret untuk membantu Andi memahami konsep penjumlahan dengan lebih baik. Jangan lupa untuk memberikan pujian dan dukungan positif setiap kali Andi berhasil menyelesaikan soal, ini akan meningkatkan kepercayaan dirinya.\n\n*   **Sari Melati (Kelas 7):** Sari memiliki performa yang sangat baik dengan nilai rata-rata 100%! Namun, perlu diperhatikan bahwa Sari perlu lebih fokus saat membaca soal. Bapak/Ibu bisa melatih Sari dengan teknik membaca aktif, seperti menandai kata kunci atau menuliskan informasi penting dari soal. Minta Sari untuk menjelaskan kembali soal dengan kata-katanya sendiri sebelum mulai mengerjakan. Ini akan membantu Sari untuk lebih memahami apa yang diminta dalam soal.\n\n*   **Roni Pratama (Kelas 8):** Roni juga memiliki performa yang sangat baik dengan nilai rata-rata 100%! Hanya saja, Roni perlu lebih teliti dalam perhitungan. Bapak/Ibu bisa mendorong Roni untuk selalu memeriksa kembali pekerjaannya setelah selesai. Ajarkan Roni untuk menggunakan kalkulator sebagai alat bantu untuk memeriksa perhitungan yang rumit. Selain itu, pastikan Roni memiliki cukup waktu untuk mengerjakan soal agar tidak terburu-buru dan melakukan kesalahan yang tidak perlu.\n\nSecara keseluruhan, kelas Bapak/Ibu memiliki potensi yang besar. Dengan perhatian dan strategi yang tepat, Andi, Sari, dan Roni dapat terus meningkatkan kemampuan mereka. Semangat terus, Bapak/Ibu Guru!	2025-07-09 12:55:11.298189+07	\N
bca82133-53ed-4fa8-935a-55974a262332	99999999-9999-9999-9999-999999999999	teacher	Bagaimana performa siswa di kelas saya?	2025-07-09 12:55:11.299529+07	\N
45cd83e4-58c6-4977-8f21-087acd07c7b9	99999999-9999-9999-9999-999999999999	ai	Halo Bapak/Ibu Guru!\n\nBerikut adalah ringkasan performa siswa di kelas Bapak/Ibu:\n\n*   **Andi Kurniawan (Kelas 7):** Nilai rata-rata Andi masih perlu ditingkatkan, yaitu 50%. Terlihat bahwa Andi mengalami kesulitan dalam operasi penjumlahan yang kompleks. Saya sarankan untuk memberikan latihan tambahan yang lebih terstruktur, dimulai dari soal-soal penjumlahan dasar, kemudian secara bertahap meningkat ke soal yang lebih kompleks. Bapak/Ibu juga bisa menggunakan media visual seperti garis bilangan atau benda konkret untuk membantu Andi memahami konsep penjumlahan dengan lebih baik. Jangan lupa untuk memberikan pujian dan dukungan positif setiap kali Andi berhasil menyelesaikan soal, ini akan meningkatkan kepercayaan dirinya.\n\n*   **Sari Melati (Kelas 7):** Sari memiliki performa yang sangat baik dengan nilai rata-rata 100%! Namun, perlu diperhatikan bahwa Sari perlu lebih fokus saat membaca soal. Bapak/Ibu bisa melatih Sari dengan teknik membaca aktif, seperti menandai kata kunci atau menuliskan informasi penting dari soal. Minta Sari untuk menjelaskan kembali soal dengan kata-katanya sendiri sebelum mulai mengerjakan. Ini akan membantu Sari untuk lebih memahami apa yang diminta dalam soal.\n\n*   **Roni Pratama (Kelas 8):** Roni juga memiliki performa yang sangat baik dengan nilai rata-rata 100%! Hanya saja, Roni perlu lebih teliti dalam perhitungan. Bapak/Ibu bisa mendorong Roni untuk selalu memeriksa kembali pekerjaannya setelah selesai. Ajarkan Roni untuk menggunakan kalkulator sebagai alat bantu untuk memeriksa perhitungan yang rumit. Selain itu, pastikan Roni memiliki cukup waktu untuk mengerjakan soal agar tidak terburu-buru dan melakukan kesalahan yang tidak perlu.\n\nSecara keseluruhan, kelas Bapak/Ibu memiliki potensi yang besar. Dengan perhatian dan strategi yang tepat, Andi, Sari, dan Roni dapat terus meningkatkan kemampuan mereka. Semangat terus, Bapak/Ibu Guru!	2025-07-09 12:55:11.300596+07	\N
\.


--
-- Data for Name: feedbacks; Type: TABLE DATA; Schema: public; Owner: gerin
--

COPY public.feedbacks (id, teacher_id, student_id, content, created_at, school_id) FROM stdin;
11111111-1111-1111-1111-111111111105	44444444-4444-4444-4444-444444444444	77777777-7777-7777-7777-777777777777	Andi perlu lebih berlatih soal penjumlahan. Coba kerjakan 10 soal setiap hari.	2024-01-16 00:00:00+07	\N
22222222-2222-2222-2222-222222222205	44444444-4444-4444-4444-444444444444	88888888-8888-8888-8888-888888888888	Sari sudah sangat baik dalam matematika. Teruskan semangat belajarnya!	2024-01-16 00:15:00+07	\N
33333333-3333-3333-3333-333333333305	55555555-5555-5555-5555-555555555555	aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa	Lina perlu lebih banyak membaca untuk meningkatkan pemahaman teks	2024-01-16 00:30:00+07	\N
44444444-4444-4444-4444-444444444405	66666666-6666-6666-6666-666666666666	bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb	Doni sudah menguasai konsep IPA dengan baik. Tingkatkan latihan soal.	2024-01-16 00:45:00+07	\N
55555555-5555-5555-5555-555555555505	66666666-6666-6666-6666-666666666666	cccccccc-cccc-cccc-cccc-cccccccccccc	Maya perlu lebih fokus saat mengerjakan soal. Jangan terburu-buru.	2024-01-16 01:00:00+07	\N
\.


--
-- Data for Name: invitation_codes; Type: TABLE DATA; Schema: public; Owner: gerin
--

COPY public.invitation_codes (id, school_id, code, max_usage, used_count, valid_until, created_at) FROM stdin;
\.


--
-- Data for Name: learning_insights; Type: TABLE DATA; Schema: public; Owner: gerin
--

COPY public.learning_insights (id, student_id, strength, weakness, last_updated, school_id) FROM stdin;
11111111-1111-1111-1111-111111111102	77777777-7777-7777-7777-777777777777	Mahir dalam perkalian dasar	Kesulitan dalam operasi penjumlahan kompleks	2024-01-15 19:00:00+07	\N
22222222-2222-2222-2222-222222222202	88888888-8888-8888-8888-888888888888	Sangat baik dalam matematika dasar	Perlu lebih fokus dalam membaca soal	2024-01-15 19:15:00+07	\N
33333333-3333-3333-3333-333333333302	99999999-9999-9999-9999-999999999999	Memahami konsep aljabar dengan baik	Kurang teliti dalam perhitungan	2024-01-15 19:30:00+07	\N
44444444-4444-4444-4444-444444444402	aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa	Kreatif dalam menulis	Kesulitan memahami struktur teks	2024-01-15 19:45:00+07	\N
55555555-5555-5555-5555-555555555502	bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb	Memahami konsep IPA dengan baik	Perlu lebih banyak latihan soal	2024-01-15 20:00:00+07	\N
66666666-6666-6666-6666-666666666602	cccccccc-cccc-cccc-cccc-cccccccccccc	Antusias dalam belajar	Kurang fokus saat mengerjakan soal	2024-01-15 20:15:00+07	\N
\.


--
-- Data for Name: learning_profiles; Type: TABLE DATA; Schema: public; Owner: gerin
--

COPY public.learning_profiles (id, student_id, preferred_learning_style, learning_pace, focus_area, updated_at, school_id) FROM stdin;
11111111-1111-1111-1111-111111111104	77777777-7777-7777-7777-777777777777	visual	moderate	Operasi matematika dasar	2024-01-15 22:30:00+07	\N
22222222-2222-2222-2222-222222222204	88888888-8888-8888-8888-888888888888	auditory	fast	Pemahaman konsep matematika	2024-01-15 22:45:00+07	\N
33333333-3333-3333-3333-333333333304	99999999-9999-9999-9999-999999999999	kinesthetic	moderate	Aljabar dan problem solving	2024-01-15 23:00:00+07	\N
44444444-4444-4444-4444-444444444404	aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa	visual	slow	Pemahaman teks dan menulis	2024-01-15 23:15:00+07	\N
55555555-5555-5555-5555-555555555504	bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb	auditory	fast	Sains dan eksperimen	2024-01-15 23:30:00+07	\N
66666666-6666-6666-6666-666666666604	cccccccc-cccc-cccc-cccc-cccccccccccc	kinesthetic	slow	Fokus dan konsentrasi	2024-01-15 23:45:00+07	\N
\.


--
-- Data for Name: learning_tips; Type: TABLE DATA; Schema: public; Owner: gerin
--

COPY public.learning_tips (id, student_id, teacher_id, subject_id, tip, school_id, created_at, package_id) FROM stdin;
11111111-1111-1111-1111-111111111103	77777777-7777-7777-7777-777777777777	44444444-4444-4444-4444-444444444444	12345678-1234-1234-1234-123456789012	Coba latihan soal penjumlahan setiap hari selama 15 menit	\N	2024-01-15 14:00:00	78901234-7890-7890-7890-789012345678
22222222-2222-2222-2222-222222222203	88888888-8888-8888-8888-888888888888	44444444-4444-4444-4444-444444444444	12345678-1234-1234-1234-123456789012	Bacalah soal dengan teliti sebelum menjawab	\N	2024-01-15 14:15:00	78901234-7890-7890-7890-789012345678
33333333-3333-3333-3333-333333333303	99999999-9999-9999-9999-999999999999	44444444-4444-4444-4444-444444444444	12345678-1234-1234-1234-123456789012	Periksa kembali jawaban sebelum submit	\N	2024-01-15 14:30:00	90123456-9012-9012-9012-901234567890
44444444-4444-4444-4444-444444444403	aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa	55555555-5555-5555-5555-555555555555	23456789-2345-2345-2345-234567890123	Perbanyak membaca berbagai jenis teks	\N	2024-01-15 14:45:00	89012345-8901-8901-8901-890123456789
55555555-5555-5555-5555-555555555503	bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb	55555555-5555-5555-5555-555555555555	45678901-4567-4567-4567-456789012345	Gunakan metode mnemonik untuk mengingat konsep	\N	2024-01-15 15:00:00	01234567-0123-0123-0123-012345678901
\.


--
-- Data for Name: question_packages; Type: TABLE DATA; Schema: public; Owner: gerin
--

COPY public.question_packages (id, title, description, subject_id, created_by, grade, school_id, is_active, created_at, updated_at) FROM stdin;
78901234-7890-7890-7890-789012345678	Matematika Dasar Kelas 7	Paket soal matematika untuk siswa kelas 7 tentang operasi bilangan	12345678-1234-1234-1234-123456789012	44444444-4444-4444-4444-444444444444	7	\N	t	\N	\N
89012345-8901-8901-8901-890123456789	Bahasa Indonesia Kelas 7	Paket soal bahasa Indonesia untuk siswa kelas 7 tentang teks narasi	23456789-2345-2345-2345-234567890123	55555555-5555-5555-5555-555555555555	7	\N	t	\N	\N
90123456-9012-9012-9012-901234567890	Matematika Aljabar Kelas 8	Paket soal matematika untuk siswa kelas 8 tentang aljabar	12345678-1234-1234-1234-123456789012	44444444-4444-4444-4444-444444444444	8	\N	t	\N	\N
01234567-0123-0123-0123-012345678901	IPA Kelas 9	Paket soal IPA untuk siswa kelas 9 tentang sistem reproduksi	45678901-4567-4567-4567-456789012345	66666666-6666-6666-6666-666666666666	9	\N	t	\N	\N
\.


--
-- Data for Name: questions; Type: TABLE DATA; Schema: public; Owner: gerin
--

COPY public.questions (id, package_id, question_text, option_a, option_b, option_c, option_d, correct_answer, school_id, time_limit, created_at, updated_at, is_active, start_date, end_date) FROM stdin;
11111111-1111-1111-1111-111111111110	78901234-7890-7890-7890-789012345678	Berapa hasil dari 15 + 25?	30	35	40	45	c	\N	\N	\N	\N	t	\N	\N
22222222-2222-2222-2222-222222222220	78901234-7890-7890-7890-789012345678	Berapa hasil dari 8 × 7?	54	56	58	60	b	\N	\N	\N	\N	t	\N	\N
33333333-3333-3333-3333-333333333330	89012345-8901-8901-8901-890123456789	Apa yang dimaksud dengan teks narasi?	Teks yang menjelaskan cara melakukan sesuatu	Teks yang menceritakan suatu peristiwa	Teks yang menggambarkan suatu objek	Teks yang berisi argumentasi	b	\N	\N	\N	\N	t	\N	\N
44444444-4444-4444-4444-444444444440	90123456-9012-9012-9012-901234567890	Jika x + 5 = 12, maka nilai x adalah?	5	6	7	8	c	\N	\N	\N	\N	t	\N	\N
55555555-5555-5555-5555-555555555550	01234567-0123-0123-0123-012345678901	Hormon yang mengatur siklus menstruasi adalah?	Insulin	Estrogen	Adrenalin	Tiroksin	b	\N	\N	\N	\N	t	\N	\N
\.


--
-- Data for Name: quiz_histories; Type: TABLE DATA; Schema: public; Owner: gerin
--

COPY public.quiz_histories (id, student_id, package_id, question_id, selected_answer, is_correct, score, answered_at, school_id, start_time, end_time, attempt_id) FROM stdin;
\.


--
-- Data for Name: quiz_results; Type: TABLE DATA; Schema: public; Owner: gerin
--

COPY public.quiz_results (id, student_id, package_id, total_questions, correct_answers, score, submitted_at, grade, school_id, start_time, end_time, attempt_count) FROM stdin;
11111111-1111-1111-1111-111111111100	77777777-7777-7777-7777-777777777777	78901234-7890-7890-7890-789012345678	2	1	50.0	2024-01-15 17:30:00+07	7	\N	\N	\N	1
22222222-2222-2222-2222-222222222200	88888888-8888-8888-8888-888888888888	78901234-7890-7890-7890-789012345678	2	2	100.0	2024-01-15 17:45:00+07	7	\N	\N	\N	1
33333333-3333-3333-3333-333333333300	99999999-9999-9999-9999-999999999999	90123456-9012-9012-9012-901234567890	1	1	100.0	2024-01-15 18:00:00+07	8	\N	\N	\N	1
44444444-4444-4444-4444-444444444400	aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa	89012345-8901-8901-8901-890123456789	1	0	0.0	2024-01-15 18:15:00+07	8	\N	\N	\N	1
55555555-5555-5555-5555-555555555500	bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb	01234567-0123-0123-0123-012345678901	1	1	100.0	2024-01-15 18:30:00+07	9	\N	\N	\N	1
66666666-6666-6666-6666-666666666600	cccccccc-cccc-cccc-cccc-cccccccccccc	01234567-0123-0123-0123-012345678901	1	0	0.0	2024-01-15 18:45:00+07	9	\N	\N	\N	1
\.


--
-- Data for Name: schools; Type: TABLE DATA; Schema: public; Owner: gerin
--

COPY public.schools (id, name, address, created_at, npsn, email) FROM stdin;
\.


--
-- Data for Name: student_teachers; Type: TABLE DATA; Schema: public; Owner: gerin
--

COPY public.student_teachers (student_id, teacher_id, school_id) FROM stdin;
77777777-7777-7777-7777-777777777777	44444444-4444-4444-4444-444444444444	\N
88888888-8888-8888-8888-888888888888	44444444-4444-4444-4444-444444444444	\N
99999999-9999-9999-9999-999999999999	44444444-4444-4444-4444-444444444444	\N
aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa	55555555-5555-5555-5555-555555555555	\N
bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb	55555555-5555-5555-5555-555555555555	\N
cccccccc-cccc-cccc-cccc-cccccccccccc	66666666-6666-6666-6666-666666666666	\N
\.


--
-- Data for Name: subjects; Type: TABLE DATA; Schema: public; Owner: gerin
--

COPY public.subjects (id, name, school_id) FROM stdin;
12345678-1234-1234-1234-123456789012	Matematika	\N
23456789-2345-2345-2345-234567890123	Bahasa Indonesia	\N
34567890-3456-3456-3456-345678901234	Bahasa Inggris	\N
45678901-4567-4567-4567-456789012345	IPA	\N
56789012-5678-5678-5678-567890123456	IPS	\N
67890123-6789-6789-6789-678901234567	Pendidikan Agama	\N
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: gerin
--

COPY public.users (id, name, email, password, phone_number, role, parent_id, grade, photo, school_id, invitation_code, created_at, updated_at) FROM stdin;
11111111-1111-1111-1111-111111111111	Siti Nurhaliza	siti.nurhaliza@email.com	$2b$12$hashed_password	08123456789	parent	\N	\N	\N	\N	\N	\N	\N
22222222-2222-2222-2222-222222222222	Budi Santoso	budi.santoso@email.com	$2b$12$hashed_password	08123456790	parent	\N	\N	\N	\N	\N	\N	\N
33333333-3333-3333-3333-333333333333	Dewi Sartika	dewi.sartika@email.com	$2b$12$hashed_password	08123456791	parent	\N	\N	\N	\N	\N	\N	\N
44444444-4444-4444-4444-444444444444	Pak Ahmad Rahman	ahmad.rahman@school.edu	$2b$12$hashed_password	08123456792	teacher	\N	\N	\N	\N	\N	\N	\N
55555555-5555-5555-5555-555555555555	Bu Fatimah Zahra	fatimah.zahra@school.edu	$2b$12$hashed_password	08123456793	teacher	\N	\N	\N	\N	\N	\N	\N
66666666-6666-6666-6666-666666666666	Pak Joko Widodo	joko.widodo@school.edu	$2b$12$hashed_password	08123456794	teacher	\N	\N	\N	\N	\N	\N	\N
77777777-7777-7777-7777-777777777777	Andi Kurniawan	andi.kurniawan@student.edu	$2b$12$hashed_password	08123456795	student	11111111-1111-1111-1111-111111111111	7	\N	\N	\N	\N	\N
88888888-8888-8888-8888-888888888888	Sari Melati	sari.melati@student.edu	$2b$12$hashed_password	08123456796	student	22222222-2222-2222-2222-222222222222	7	\N	\N	\N	\N	\N
99999999-9999-9999-9999-999999999999	Roni Pratama	roni.pratama@student.edu	$2b$12$hashed_password	08123456797	student	33333333-3333-3333-3333-333333333333	8	\N	\N	\N	\N	\N
aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa	Lina Handayani	lina.handayani@student.edu	$2b$12$hashed_password	08123456798	student	11111111-1111-1111-1111-111111111111	8	\N	\N	\N	\N	\N
bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb	Doni Setiawan	doni.setiawan@student.edu	$2b$12$hashed_password	08123456799	student	22222222-2222-2222-2222-222222222222	9	\N	\N	\N	\N	\N
cccccccc-cccc-cccc-cccc-cccccccccccc	Maya Sari	maya.sari@student.edu	$2b$12$hashed_password	08123456800	student	33333333-3333-3333-3333-333333333333	9	\N	\N	\N	\N	\N
\.


--
-- Name: answers answers_pkey; Type: CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.answers
    ADD CONSTRAINT answers_pkey PRIMARY KEY (id);


--
-- Name: chatbot_logs chatbot_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.chatbot_logs
    ADD CONSTRAINT chatbot_logs_pkey PRIMARY KEY (id);


--
-- Name: feedbacks feedbacks_pkey; Type: CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.feedbacks
    ADD CONSTRAINT feedbacks_pkey PRIMARY KEY (id);


--
-- Name: invitation_codes invitation_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.invitation_codes
    ADD CONSTRAINT invitation_codes_pkey PRIMARY KEY (id);


--
-- Name: learning_insights learning_insights_pkey; Type: CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.learning_insights
    ADD CONSTRAINT learning_insights_pkey PRIMARY KEY (id);


--
-- Name: learning_profiles learning_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.learning_profiles
    ADD CONSTRAINT learning_profiles_pkey PRIMARY KEY (id);


--
-- Name: learning_tips learning_tips_pkey; Type: CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.learning_tips
    ADD CONSTRAINT learning_tips_pkey PRIMARY KEY (id);


--
-- Name: question_packages question_packages_pkey; Type: CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.question_packages
    ADD CONSTRAINT question_packages_pkey PRIMARY KEY (id);


--
-- Name: questions questions_pkey; Type: CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);


--
-- Name: quiz_histories quiz_histories_pkey; Type: CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.quiz_histories
    ADD CONSTRAINT quiz_histories_pkey PRIMARY KEY (id);


--
-- Name: quiz_results quiz_results_pkey; Type: CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.quiz_results
    ADD CONSTRAINT quiz_results_pkey PRIMARY KEY (id);


--
-- Name: schools schools_pkey; Type: CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.schools
    ADD CONSTRAINT schools_pkey PRIMARY KEY (id);


--
-- Name: student_teachers student_teachers_pkey; Type: CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.student_teachers
    ADD CONSTRAINT student_teachers_pkey PRIMARY KEY (student_id, teacher_id);


--
-- Name: subjects subjects_pkey; Type: CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.subjects
    ADD CONSTRAINT subjects_pkey PRIMARY KEY (id);


--
-- Name: invitation_codes uni_invitation_codes_code; Type: CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.invitation_codes
    ADD CONSTRAINT uni_invitation_codes_code UNIQUE (code);


--
-- Name: schools uni_schools_email; Type: CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.schools
    ADD CONSTRAINT uni_schools_email UNIQUE (email);


--
-- Name: schools uni_schools_npsn; Type: CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.schools
    ADD CONSTRAINT uni_schools_npsn UNIQUE (npsn);


--
-- Name: users uni_users_email; Type: CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT uni_users_email UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: idx_learning_tips_created_at; Type: INDEX; Schema: public; Owner: gerin
--

CREATE INDEX idx_learning_tips_created_at ON public.learning_tips USING btree (created_at);


--
-- Name: idx_learning_tips_package_id; Type: INDEX; Schema: public; Owner: gerin
--

CREATE INDEX idx_learning_tips_package_id ON public.learning_tips USING btree (package_id);


--
-- Name: idx_learning_tips_student_id; Type: INDEX; Schema: public; Owner: gerin
--

CREATE INDEX idx_learning_tips_student_id ON public.learning_tips USING btree (student_id);


--
-- Name: idx_learning_tips_subject_id; Type: INDEX; Schema: public; Owner: gerin
--

CREATE INDEX idx_learning_tips_subject_id ON public.learning_tips USING btree (subject_id);


--
-- Name: idx_learning_tips_teacher_id; Type: INDEX; Schema: public; Owner: gerin
--

CREATE INDEX idx_learning_tips_teacher_id ON public.learning_tips USING btree (teacher_id);


--
-- Name: idx_questions_package_id; Type: INDEX; Schema: public; Owner: gerin
--

CREATE INDEX idx_questions_package_id ON public.questions USING btree (package_id);


--
-- Name: idx_questions_school_id; Type: INDEX; Schema: public; Owner: gerin
--

CREATE INDEX idx_questions_school_id ON public.questions USING btree (school_id);


--
-- Name: idx_subjects_school_id; Type: INDEX; Schema: public; Owner: gerin
--

CREATE INDEX idx_subjects_school_id ON public.subjects USING btree (school_id);


--
-- Name: answers fk_answers_question; Type: FK CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.answers
    ADD CONSTRAINT fk_answers_question FOREIGN KEY (question_id) REFERENCES public.questions(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: answers fk_answers_school; Type: FK CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.answers
    ADD CONSTRAINT fk_answers_school FOREIGN KEY (school_id) REFERENCES public.schools(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: answers fk_answers_student; Type: FK CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.answers
    ADD CONSTRAINT fk_answers_student FOREIGN KEY (student_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: chatbot_logs fk_chatbot_logs_school; Type: FK CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.chatbot_logs
    ADD CONSTRAINT fk_chatbot_logs_school FOREIGN KEY (school_id) REFERENCES public.schools(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: feedbacks fk_feedbacks_school; Type: FK CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.feedbacks
    ADD CONSTRAINT fk_feedbacks_school FOREIGN KEY (school_id) REFERENCES public.schools(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: feedbacks fk_feedbacks_student; Type: FK CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.feedbacks
    ADD CONSTRAINT fk_feedbacks_student FOREIGN KEY (student_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: feedbacks fk_feedbacks_teacher; Type: FK CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.feedbacks
    ADD CONSTRAINT fk_feedbacks_teacher FOREIGN KEY (teacher_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: invitation_codes fk_invitation_codes_school; Type: FK CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.invitation_codes
    ADD CONSTRAINT fk_invitation_codes_school FOREIGN KEY (school_id) REFERENCES public.schools(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: learning_insights fk_learning_insights_school; Type: FK CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.learning_insights
    ADD CONSTRAINT fk_learning_insights_school FOREIGN KEY (school_id) REFERENCES public.schools(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: learning_insights fk_learning_insights_student; Type: FK CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.learning_insights
    ADD CONSTRAINT fk_learning_insights_student FOREIGN KEY (student_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: learning_profiles fk_learning_profiles_school; Type: FK CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.learning_profiles
    ADD CONSTRAINT fk_learning_profiles_school FOREIGN KEY (school_id) REFERENCES public.schools(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: learning_profiles fk_learning_profiles_student; Type: FK CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.learning_profiles
    ADD CONSTRAINT fk_learning_profiles_student FOREIGN KEY (student_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: learning_tips fk_learning_tips_package; Type: FK CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.learning_tips
    ADD CONSTRAINT fk_learning_tips_package FOREIGN KEY (package_id) REFERENCES public.question_packages(id);


--
-- Name: learning_tips fk_learning_tips_school; Type: FK CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.learning_tips
    ADD CONSTRAINT fk_learning_tips_school FOREIGN KEY (school_id) REFERENCES public.schools(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: learning_tips fk_learning_tips_student; Type: FK CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.learning_tips
    ADD CONSTRAINT fk_learning_tips_student FOREIGN KEY (student_id) REFERENCES public.users(id);


--
-- Name: learning_tips fk_learning_tips_subject; Type: FK CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.learning_tips
    ADD CONSTRAINT fk_learning_tips_subject FOREIGN KEY (subject_id) REFERENCES public.subjects(id);


--
-- Name: learning_tips fk_learning_tips_teacher; Type: FK CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.learning_tips
    ADD CONSTRAINT fk_learning_tips_teacher FOREIGN KEY (teacher_id) REFERENCES public.users(id);


--
-- Name: question_packages fk_question_packages_school; Type: FK CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.question_packages
    ADD CONSTRAINT fk_question_packages_school FOREIGN KEY (school_id) REFERENCES public.schools(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: question_packages fk_question_packages_subject; Type: FK CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.question_packages
    ADD CONSTRAINT fk_question_packages_subject FOREIGN KEY (subject_id) REFERENCES public.subjects(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: question_packages fk_question_packages_teacher; Type: FK CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.question_packages
    ADD CONSTRAINT fk_question_packages_teacher FOREIGN KEY (created_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: questions fk_questions_package; Type: FK CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT fk_questions_package FOREIGN KEY (package_id) REFERENCES public.question_packages(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: questions fk_questions_school; Type: FK CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT fk_questions_school FOREIGN KEY (school_id) REFERENCES public.schools(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: quiz_histories fk_quiz_histories_package; Type: FK CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.quiz_histories
    ADD CONSTRAINT fk_quiz_histories_package FOREIGN KEY (package_id) REFERENCES public.question_packages(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: quiz_histories fk_quiz_histories_question; Type: FK CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.quiz_histories
    ADD CONSTRAINT fk_quiz_histories_question FOREIGN KEY (question_id) REFERENCES public.questions(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: quiz_histories fk_quiz_histories_school; Type: FK CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.quiz_histories
    ADD CONSTRAINT fk_quiz_histories_school FOREIGN KEY (school_id) REFERENCES public.schools(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: quiz_histories fk_quiz_histories_student; Type: FK CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.quiz_histories
    ADD CONSTRAINT fk_quiz_histories_student FOREIGN KEY (student_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: quiz_results fk_quiz_results_package; Type: FK CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.quiz_results
    ADD CONSTRAINT fk_quiz_results_package FOREIGN KEY (package_id) REFERENCES public.question_packages(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: quiz_results fk_quiz_results_school; Type: FK CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.quiz_results
    ADD CONSTRAINT fk_quiz_results_school FOREIGN KEY (school_id) REFERENCES public.schools(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: quiz_results fk_quiz_results_student; Type: FK CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.quiz_results
    ADD CONSTRAINT fk_quiz_results_student FOREIGN KEY (student_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: student_teachers fk_student_teachers_school; Type: FK CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.student_teachers
    ADD CONSTRAINT fk_student_teachers_school FOREIGN KEY (school_id) REFERENCES public.schools(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: student_teachers fk_student_teachers_student; Type: FK CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.student_teachers
    ADD CONSTRAINT fk_student_teachers_student FOREIGN KEY (student_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: student_teachers fk_student_teachers_teacher; Type: FK CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.student_teachers
    ADD CONSTRAINT fk_student_teachers_teacher FOREIGN KEY (teacher_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: subjects fk_subjects_school; Type: FK CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.subjects
    ADD CONSTRAINT fk_subjects_school FOREIGN KEY (school_id) REFERENCES public.schools(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: users fk_users_invitation; Type: FK CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_users_invitation FOREIGN KEY (invitation_code) REFERENCES public.invitation_codes(code) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: users fk_users_parent; Type: FK CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_users_parent FOREIGN KEY (parent_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: users fk_users_school; Type: FK CONSTRAINT; Schema: public; Owner: gerin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_users_school FOREIGN KEY (school_id) REFERENCES public.schools(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

