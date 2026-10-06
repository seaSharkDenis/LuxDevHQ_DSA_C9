-- Active: 1789505983775@@127.0.0.1@5432@defaultdb@evening
-- Insertion in departments table
INSERT INTO
    departments (department_name)
VALUES ('Cardiology'),
    ('General Medicine'),
    ('Orthopaedics'),
    ('Pediatrics');

INSERT INTO doctors(doctor_name, doctor_gender, doctor_specialty, doctor_experience_years) VALUES
('Dr. Brian Mwangi', 'Male', 'Cardiologist', 12),
('Dr. Sarah Wanjiku', 'Female', 'General Physician', 9),
('Dr. Peter Atieno', 'Male', 'Orthopedic Surgeon', 15),
('Dr. Faith Chebet', 'Female', 'Pediatrician', 8);

INSERT INTO patients(patient_name, patient_gender, patient_age, county, sub_county) VALUES
('Amina Atieno', 'Female', 34, 'Nairobi', 'Westlands'),
('John Kariuki', 'Male', 42, 'Kiambu', 'Thika'),
('Grace Naliaka', 'Female', 28, 'Kakamega', 'Lurambi'),
('David Mutua', 'Male', 55, 'Machakos', 'Athi River'),
('Esther Achieng', 'Female', 63, 'Kisumu', 'Kisumu Central'),
('Mohamed Ali', 'Male', 19, 'Mombasa', 'Nyali'),
('Lucy Wambui', 'Female', 7, 'Nakuru', 'Naivasha'),
('Samuel Kiptoo', 'Male', 39, 'Uasin Gishu', 'Eldoret East'),
('Mary Wairimu', 'Female', 31, 'Muranga', 'Kiharu'),
('Peter Ouma', 'Male', 46, 'Siaya', 'Bondo'),
('Brian Omondi', 'Male', 24, 'Kisumu', 'Kisumu East'),
('Catherine Musyoka', 'Female', 52, 'Kitui', 'Kitui Central'),
('Daniel Maina', 'Male', 16, 'Nyeri', 'Othaya'),
('Eunice Moraa', 'Female', 44, 'Kisii', 'Bonchari'),
('Francis Njuguna', 'Male', 60, 'Laikipia', 'Nanyuki'),
('Hellen Jepchirchir', 'Female', 37, 'Bomet', 'Sotik'),
('Isaac Kamau', 'Male', 29, 'Nairobi', 'Kasarani'),
('Jane Muthoni', 'Female', 22, 'Meru', 'Imenti North'),
('Kevin Barasa', 'Male', 48, 'Bungoma', 'Webuye'),
('Lilian Adhiambo', 'Female', 26, 'Homa Bay', 'Rangwe'),
('Moses Cheruiyot', 'Male', 33, 'Kericho', 'Ainamoi'),
('Nadia Hussein', 'Female', 5, 'Garissa', 'Dadaab'),
('Patric Muli', 'Male', 51, 'Makueni', 'Wote'),
('Ruth Nekesa', 'Female', 41, 'Kericho', 'Ainamoi'),
('Josephine Wekesa', 'Female', 30, 'Makueni', 'Wote');


UPDATE patients
SET county = 'Murang''a'
WHERE county = 'Muranga';

INSERT INTO diagnosis(diagnosis_name, diagnosis_category) VALUES
('Hypertension', 'Chronic Disease'),
('Malaria', 'Infectious Disease'),
('Fracture', 'Injury'),
('Pneumonia', 'Respiratory Disease'),
('Diabetes', 'Chronic Disease'),
('Typhoid', 'Infectious Disease'),
('Asthma', 'Respiratory Disease'),
('Back Pain', 'Musculoskeletal'),
('Gastritis', 'Digestive Disease'),
('Heart Failure', 'Chronic Disease'),
('Flu', 'Respiratory Disease'),
('Kidney Infection', 'Infectious Disease'),
('Urinary Tract Infection', 'Infectious Disease'),
('Knee Spain', 'Injury'),
('Dehydration', 'Digestive Disease'),
('Dislocated Shoulder', 'Injury'),
('Migraine', 'Neurological'),
('Chest Pain', 'Cardiovascular');

INSERT INTO procedures(procedure_name, procedure_category) VALUES
('Blood Pressure Monitoring', 'Diagnostic'),
('Malaria Test', 'Laboratory'),
('X-Ray', 'Imaging'),
('Chest X-Ray', 'Imaging'),
('Blood Sugar Test', 'Laboratory'),
('Full Blood Count', 'Laboratory'),
('Nebulization', 'Treatment'),
('Physiotherapy', 'Treatment'),
('Endoscopy', 'Diagnostic'),
('ECG', 'Diagnostic'),
('Consultation', 'Consultation'),
('Join Support Bandage', 'Treatment'),
('IV Fluids', 'Treatment'),
('Closed Reduction', 'Treatment'),
('Pain Management', 'Treatment');

INSERT INTO wards(ward_name) VALUES
('Cardiac Care Unit'),
('General Ward'),
('Surgical Ward'),
('Children'' Ward');