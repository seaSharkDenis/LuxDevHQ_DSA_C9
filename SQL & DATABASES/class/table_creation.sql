-- Active: 1789505983775@@127.0.0.1@5432@defaultdb@evening
CREATE DATABASE defaultdb;

CREATE SCHEMA evening;

SET search_path TO evening;

-- CREATING DEPARTMENTS TABLE
CREATE TABLE IF NOT EXISTS departments(
    department_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    department_name VARCHAR(20) NOT NULL
);

-- CREATING DOCTORS TABLES
CREATE TABLE IF NOT EXISTS doctors(
    doctor_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    doctor_name VARCHAR(100) NOT NULL,
    doctor_gender VARCHAR(10),
    doctor_specialty VARCHAR(50),
    doctor_experience_years INTEGER
);

CREATE TABLE IF NOT EXISTS patients(
    patient_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    patient_name VARCHAR(60) NOT NULL,
    patient_gender VARCHAR(20),
    patient_age INTEGER,
    county VARCHAR(50),
    sub_county VARCHAR(60)
);

CREATE TABLE IF NOT EXISTS diagnosis(
    diagnosis_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    diagnosis_name VARCHAR(100) NOT NULL,
    diagnosis_category VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS procedures(
    procedure_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    procedure_name VARCHAR(60) NOT NULL,
    procedure_category VARCHAR(60)
);

CREATE TABLE IF NOT EXISTS wards(
    ward_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ward_name VARCHAR(40) NOT NULL
);