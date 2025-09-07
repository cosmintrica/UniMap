-- =============================================
-- ACTUALIZARE DATE EDUCAȚIONALE - UNIVERSITATEA DIN CRAIOVA
-- =============================================

-- 1. Șterge datele existente (cele 3 universități cu specializări identice)
-- =============================================
-- Șterge în ordinea corectă pentru a respecta constrângerile de chei străine
DELETE FROM announcements WHERE target_university_id IN (SELECT id FROM universities);
DELETE FROM announcements WHERE target_faculty_id IN (SELECT id FROM faculties);
DELETE FROM masters WHERE faculty_id IN (SELECT id FROM faculties);
DELETE FROM specializations WHERE faculty_id IN (SELECT id FROM faculties);
DELETE FROM faculties WHERE university_id IN (SELECT id FROM universities);
DELETE FROM universities;

-- 2. Inserează Universitatea din Craiova cu datele corecte
-- =============================================
INSERT INTO universities (id, name, code, city, country, website, description, is_active) VALUES
(gen_random_uuid(), 'Universitatea din Craiova', 'UCV', 'Craiova', 'România', 'https://www.ucv.ro', 'Universitatea din Craiova este o instituție de învățământ superior de stat din România, fondată în 1965.', true);

-- 3. Inserează facultățile Universității din Craiova
-- =============================================
INSERT INTO faculties (id, university_id, name, code, description, dean_name, is_active) VALUES
(gen_random_uuid(), (SELECT id FROM universities WHERE code = 'UCV'), 'Facultatea de Matematică și Informatică', 'FMI', 'Facultatea de Matematică și Informatică oferă programe de studii în domeniile matematicii, informaticii și științelor exacte.', 'Prof. Dr. Ing. Ion Pătrașcu', true),
(gen_random_uuid(), (SELECT id FROM universities WHERE code = 'UCV'), 'Facultatea de Inginerie Electrică', 'FIE', 'Facultatea de Inginerie Electrică formează specialiști în domeniul ingineriei electrice și energetice.', 'Prof. Dr. Ing. Gheorghe Scutaru', true),
(gen_random_uuid(), (SELECT id FROM universities WHERE code = 'UCV'), 'Facultatea de Inginerie Mecanică', 'FIM', 'Facultatea de Inginerie Mecanică oferă programe de studii în domeniul ingineriei mecanice și tehnologiei.', 'Prof. Dr. Ing. Nicolae Băran', true),
(gen_random_uuid(), (SELECT id FROM universities WHERE code = 'UCV'), 'Facultatea de Inginerie Chimică', 'FIC', 'Facultatea de Inginerie Chimică formează specialiști în domeniul ingineriei chimice și tehnologiei.', 'Prof. Dr. Ing. Maria Popescu', true),
(gen_random_uuid(), (SELECT id FROM universities WHERE code = 'UCV'), 'Facultatea de Inginerie Industrială', 'FII', 'Facultatea de Inginerie Industrială oferă programe de studii în domeniul ingineriei industriale și managementului.', 'Prof. Dr. Ing. Alexandru Ionescu', true),
(gen_random_uuid(), (SELECT id FROM universities WHERE code = 'UCV'), 'Facultatea de Inginerie Agronomică', 'FIA', 'Facultatea de Inginerie Agronomică formează specialiști în domeniul ingineriei agronomice și tehnologiei.', 'Prof. Dr. Ing. Elena Dumitrescu', true),
(gen_random_uuid(), (SELECT id FROM universities WHERE code = 'UCV'), 'Facultatea de Inginerie Geodezică', 'FIG', 'Facultatea de Inginerie Geodezică oferă programe de studii în domeniul ingineriei geodezice și topografiei.', 'Prof. Dr. Ing. Mihai Constantinescu', true),
(gen_random_uuid(), (SELECT id FROM universities WHERE code = 'UCV'), 'Facultatea de Inginerie și Management', 'FIMGT', 'Facultatea de Inginerie și Management formează specialiști în domeniul ingineriei și managementului industrial.', 'Prof. Dr. Ing. Carmen Popescu', true);

-- 4. Inserează specializările pentru FMI
-- =============================================
INSERT INTO specializations (id, faculty_id, name, code, duration_years, description, is_active) VALUES
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FMI' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Informatică', 'INF', 3, 'Specializarea în Informatică oferă pregătire în programare, algoritmi, structuri de date și tehnologii software.', true),
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FMI' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Matematică', 'MAT', 3, 'Specializarea în Matematică oferă pregătire în analiză matematică, algebră, geometrie și statistică.', true),
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FMI' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Matematică-Informatică', 'MI', 3, 'Specializarea în Matematică-Informatică combină cunoștințele din ambele domenii pentru aplicații practice.', true),
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FMI' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Informatică Aplicată', 'IA', 3, 'Specializarea în Informatică Aplicată se concentrează pe aplicații practice ale informaticii în diverse domenii.', true);

-- 5. Inserează specializările pentru FIE
-- =============================================
INSERT INTO specializations (id, faculty_id, name, code, duration_years, description, is_active) VALUES
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FIE' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Ingineria Sistemelor', 'IS', 4, 'Specializarea în Ingineria Sistemelor formează specialiști în proiectarea și implementarea sistemelor complexe.', true),
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FIE' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Automatică și Informatică Aplicată', 'AIA', 4, 'Specializarea în Automatică și Informatică Aplicată combină controlul automat cu tehnologiile informatice.', true),
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FIE' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Energetică', 'ENG', 4, 'Specializarea în Energetică formează specialiști în domeniul energiei electrice și regenerabile.', true),
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FIE' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Electronica Aplicată', 'EA', 4, 'Specializarea în Electronica Aplicată oferă pregătire în proiectarea și implementarea sistemelor electronice.', true);

-- 6. Inserează specializările pentru FIM
-- =============================================
INSERT INTO specializations (id, faculty_id, name, code, duration_years, description, is_active) VALUES
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FIM' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Ingineria Mecanică', 'IM', 4, 'Specializarea în Ingineria Mecanică oferă pregătire în proiectarea și fabricarea sistemelor mecanice.', true),
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FIM' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Tehnologia Construcțiilor de Mașini', 'TCM', 4, 'Specializarea în Tehnologia Construcțiilor de Mașini se concentrează pe tehnologiile de fabricație.', true),
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FIM' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Autovehicule Rutiere', 'AR', 4, 'Specializarea în Autovehicule Rutiere formează specialiști în domeniul automotive.', true),
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FIM' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Ingineria Materialelor', 'IMAT', 4, 'Specializarea în Ingineria Materialelor oferă pregătire în caracterizarea și aplicarea materialelor.', true);

-- 7. Inserează specializările pentru FIC
-- =============================================
INSERT INTO specializations (id, faculty_id, name, code, duration_years, description, is_active) VALUES
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FIC' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Ingineria Chimică', 'IC', 4, 'Specializarea în Ingineria Chimică oferă pregătire în procesele chimice și tehnologia chimică.', true),
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FIC' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Tehnologia Alimentelor', 'TA', 4, 'Specializarea în Tehnologia Alimentelor formează specialiști în procesarea și conservarea alimentelor.', true),
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FIC' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Ingineria Mediului', 'IM', 4, 'Specializarea în Ingineria Mediului se concentrează pe protecția și conservarea mediului.', true),
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FIC' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Tehnologia Polimerilor', 'TP', 4, 'Specializarea în Tehnologia Polimerilor oferă pregătire în domeniul materialelor polimerice.', true);

-- 8. Inserează specializările pentru FII
-- =============================================
INSERT INTO specializations (id, faculty_id, name, code, duration_years, description, is_active) VALUES
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FII' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Ingineria Industrială', 'II', 4, 'Specializarea în Ingineria Industrială oferă pregătire în managementul industrial și optimizarea proceselor.', true),
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FII' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Managementul Calității', 'MC', 4, 'Specializarea în Managementul Calității formează specialiști în asigurarea calității produselor și serviciilor.', true),
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FII' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Ingineria Proceselor', 'IP', 4, 'Specializarea în Ingineria Proceselor se concentrează pe optimizarea și controlul proceselor industriale.', true),
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FII' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Logistica Industrială', 'LI', 4, 'Specializarea în Logistica Industrială oferă pregătire în managementul lanțului de aprovizionare.', true);

-- 9. Inserează specializările pentru FIA
-- =============================================
INSERT INTO specializations (id, faculty_id, name, code, duration_years, description, is_active) VALUES
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FIA' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Ingineria Agronomică', 'IA', 4, 'Specializarea în Ingineria Agronomică oferă pregătire în tehnologiile agricole moderne.', true),
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FIA' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Tehnologia Alimentelor', 'TA', 4, 'Specializarea în Tehnologia Alimentelor formează specialiști în procesarea produselor agricole.', true),
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FIA' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Protecția Plantelor', 'PP', 4, 'Specializarea în Protecția Plantelor se concentrează pe combaterea dăunătorilor și bolilor plantelor.', true),
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FIA' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Horticultura', 'HORT', 4, 'Specializarea în Horticultura oferă pregătire în cultivarea plantelor ornamentale și fructifere.', true);

-- 10. Inserează specializările pentru FIG
-- =============================================
INSERT INTO specializations (id, faculty_id, name, code, duration_years, description, is_active) VALUES
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FIG' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Ingineria Geodezică', 'IG', 4, 'Specializarea în Ingineria Geodezică oferă pregătire în măsurători topografice și cartografice.', true),
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FIG' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Topografia', 'TOP', 4, 'Specializarea în Topografia formează specialiști în măsurători și reprezentări cartografice.', true),
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FIG' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Cadastrul și Amenajarea Teritoriului', 'CAT', 4, 'Specializarea în Cadastrul și Amenajarea Teritoriului se concentrează pe planificarea teritoriului.', true),
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FIG' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Geoinformatica', 'GEO', 4, 'Specializarea în Geoinformatica combină geodezia cu tehnologiile informatice.', true);

-- 11. Inserează specializările pentru FIMGT (Ingineria și Management)
-- =============================================
INSERT INTO specializations (id, faculty_id, name, code, duration_years, description, is_active) VALUES
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FIMGT' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Ingineria și Managementul Industrial', 'IMI', 4, 'Specializarea în Ingineria și Managementul Industrial combină cunoștințele tehnice cu managementul.', true),
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FIMGT' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Managementul Proiectelor', 'MP', 4, 'Specializarea în Managementul Proiectelor formează specialiști în planificarea și coordonarea proiectelor.', true),
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FIMGT' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Ingineria Calității', 'IC', 4, 'Specializarea în Ingineria Calității oferă pregătire în asigurarea calității și managementul calității.', true),
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FIMGT' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Managementul Inovației', 'MI', 4, 'Specializarea în Managementul Inovației se concentrează pe managementul proceselor de inovație.', true);

-- 12. Inserează masterele pentru FMI
-- =============================================
INSERT INTO masters (id, faculty_id, name, code, duration_years, description, is_active) VALUES
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FMI' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Master în Informatică Aplicată', 'MIA', 2, 'Programul de master în Informatică Aplicată oferă pregătire avansată în tehnologii software și aplicații practice.', true),
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FMI' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Master în Matematică Aplicată', 'MMA', 2, 'Programul de master în Matematică Aplicată oferă pregătire avansată în aplicațiile matematice în diverse domenii.', true),
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FMI' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Master în Securitatea Informației', 'MSI', 2, 'Programul de master în Securitatea Informației formează specialiști în protecția sistemelor informatice.', true);

-- 13. Inserează masterele pentru FIE
-- =============================================
INSERT INTO masters (id, faculty_id, name, code, duration_years, description, is_active) VALUES
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FIE' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Master în Ingineria Sistemelor', 'MIS', 2, 'Programul de master în Ingineria Sistemelor oferă pregătire avansată în proiectarea sistemelor complexe.', true),
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FIE' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Master în Energetică Regenerabilă', 'MER', 2, 'Programul de master în Energetică Regenerabilă formează specialiști în tehnologiile energetice durabile.', true),
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FIE' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Master în Automatică și Control', 'MAC', 2, 'Programul de master în Automatică și Control oferă pregătire avansată în sistemele de control automat.', true);

-- 14. Inserează masterele pentru FIM
-- =============================================
INSERT INTO masters (id, faculty_id, name, code, duration_years, description, is_active) VALUES
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FIM' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Master în Ingineria Mecanică', 'MIM', 2, 'Programul de master în Ingineria Mecanică oferă pregătire avansată în proiectarea și fabricarea sistemelor mecanice.', true),
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FIM' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Master în Tehnologia Construcțiilor de Mașini', 'MTCM', 2, 'Programul de master în Tehnologia Construcțiilor de Mașini oferă pregătire avansată în tehnologiile de fabricație.', true),
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FIM' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Master în Autovehicule Rutiere', 'MAR', 2, 'Programul de master în Autovehicule Rutiere formează specialiști avansați în domeniul automotive.', true);

-- 15. Inserează masterele pentru FIC
-- =============================================
INSERT INTO masters (id, faculty_id, name, code, duration_years, description, is_active) VALUES
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FIC' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Master în Ingineria Chimică', 'MIC', 2, 'Programul de master în Ingineria Chimică oferă pregătire avansată în procesele chimice și tehnologia chimică.', true),
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FIC' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Master în Tehnologia Alimentelor', 'MTA', 2, 'Programul de master în Tehnologia Alimentelor formează specialiști avansați în procesarea alimentelor.', true),
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FIC' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Master în Ingineria Mediului', 'MIM', 2, 'Programul de master în Ingineria Mediului oferă pregătire avansată în protecția mediului.', true);

-- 16. Inserează masterele pentru FII
-- =============================================
INSERT INTO masters (id, faculty_id, name, code, duration_years, description, is_active) VALUES
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FII' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Master în Ingineria Industrială', 'MII', 2, 'Programul de master în Ingineria Industrială oferă pregătire avansată în managementul industrial.', true),
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FII' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Master în Managementul Calității', 'MMC', 2, 'Programul de master în Managementul Calității formează specialiști avansați în asigurarea calității.', true),
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FII' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Master în Logistica Industrială', 'MLI', 2, 'Programul de master în Logistica Industrială oferă pregătire avansată în managementul lanțului de aprovizionare.', true);

-- 17. Inserează masterele pentru FIA
-- =============================================
INSERT INTO masters (id, faculty_id, name, code, duration_years, description, is_active) VALUES
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FIA' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Master în Ingineria Agronomică', 'MIA', 2, 'Programul de master în Ingineria Agronomică oferă pregătire avansată în tehnologiile agricole moderne.', true),
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FIA' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Master în Protecția Plantelor', 'MPP', 2, 'Programul de master în Protecția Plantelor formează specialiști avansați în combaterea dăunătorilor.', true),
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FIA' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Master în Horticultura', 'MHORT', 2, 'Programul de master în Horticultura oferă pregătire avansată în cultivarea plantelor.', true);

-- 18. Inserează masterele pentru FIG
-- =============================================
INSERT INTO masters (id, faculty_id, name, code, duration_years, description, is_active) VALUES
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FIG' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Master în Ingineria Geodezică', 'MIG', 2, 'Programul de master în Ingineria Geodezică oferă pregătire avansată în măsurători topografice.', true),
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FIG' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Master în Geoinformatica', 'MGEO', 2, 'Programul de master în Geoinformatica combină geodezia cu tehnologiile informatice avansate.', true),
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FIG' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Master în Cadastrul și Amenajarea Teritoriului', 'MCAT', 2, 'Programul de master în Cadastrul și Amenajarea Teritoriului oferă pregătire avansată în planificarea teritoriului.', true);

-- 19. Inserează masterele pentru FIMGT (Ingineria și Management)
-- =============================================
INSERT INTO masters (id, faculty_id, name, code, duration_years, description, is_active) VALUES
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FIMGT' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Master în Managementul Proiectelor', 'MMP', 2, 'Programul de master în Managementul Proiectelor formează specialiști avansați în coordonarea proiectelor.', true),
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FIMGT' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Master în Ingineria Calității', 'MIC', 2, 'Programul de master în Ingineria Calității oferă pregătire avansată în asigurarea calității.', true),
(gen_random_uuid(), (SELECT id FROM faculties WHERE code = 'FIMGT' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 'Master în Managementul Inovației', 'MMI', 2, 'Programul de master în Managementul Inovației se concentrează pe managementul proceselor de inovație.', true);

-- 20. Inserează anunțurile pentru Universitatea din Craiova
-- =============================================
INSERT INTO announcements (id, title, content, target_university_id, target_faculty_id, target_study_year, priority, is_active, created_at, updated_at) VALUES
(gen_random_uuid(), 'Bun venit la Universitatea din Craiova!', 'Bine ai venit în comunitatea Universității din Craiova! Descoperă toate facilitățile și serviciile pe care le oferim.', (SELECT id FROM universities WHERE code = 'UCV'), NULL, NULL, 'high', true, NOW(), NOW()),
(gen_random_uuid(), 'Începutul anului universitar 2024-2025', 'Anul universitar 2024-2025 începe pe 1 octombrie. Toate cursurile vor avea loc conform programului stabilit.', (SELECT id FROM universities WHERE code = 'UCV'), NULL, NULL, 'high', true, NOW(), NOW()),
(gen_random_uuid(), 'Programul de burse pentru studenți', 'Aplicațiile pentru bursele de studiu sunt deschise până la 15 noiembrie. Verificați criteriile de eligibilitate.', (SELECT id FROM universities WHERE code = 'UCV'), NULL, NULL, 'medium', true, NOW(), NOW()),
(gen_random_uuid(), 'Laboratoarele de informatică sunt disponibile', 'Toate laboratoarele de informatică sunt disponibile pentru studenții din FMI. Programul de funcționare: 8:00-20:00.', (SELECT id FROM universities WHERE code = 'UCV'), (SELECT id FROM faculties WHERE code = 'FMI' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), NULL, 'medium', true, NOW(), NOW()),
(gen_random_uuid(), 'Workshop de programare pentru studenții din anul I', 'Workshop-ul de programare pentru studenții din anul I va avea loc pe 15 octombrie. Înscrierile sunt deschise.', (SELECT id FROM universities WHERE code = 'UCV'), (SELECT id FROM faculties WHERE code = 'FMI' AND university_id = (SELECT id FROM universities WHERE code = 'UCV')), 1, 'low', true, NOW(), NOW());

-- 21. Actualizează timestamp-urile
-- =============================================
UPDATE universities SET updated_at = NOW() WHERE code = 'UCV';
UPDATE faculties SET updated_at = NOW() WHERE university_id = (SELECT id FROM universities WHERE code = 'UCV');
UPDATE specializations SET updated_at = NOW() WHERE faculty_id IN (SELECT id FROM faculties WHERE university_id = (SELECT id FROM universities WHERE code = 'UCV'));
UPDATE masters SET updated_at = NOW() WHERE faculty_id IN (SELECT id FROM faculties WHERE university_id = (SELECT id FROM universities WHERE code = 'UCV'));
UPDATE announcements SET updated_at = NOW() WHERE target_university_id = (SELECT id FROM universities WHERE code = 'UCV');
