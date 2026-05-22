-- ============================================================
-- PROCEDURE: PROC_INSERT_TUTOR
-- ============================================================
 
CREATE OR REPLACE PROCEDURE PROC_INSERT_TUTOR (
    p_name      IN DB_TUTOR.NAME%TYPE,
    p_cpf       IN DB_TUTOR.CPF%TYPE,
    p_phone     IN DB_TUTOR.PHONE%TYPE,
    p_email     IN DB_TUTOR.EMAIL%TYPE,
    p_password  IN DB_TUTOR.PASSWORD%TYPE,
    p_address   IN DB_TUTOR.ADDRESS%TYPE
)
IS
    -- Constante com o nome da procedure para uso no log
    c_proc_name CONSTANT VARCHAR2(100) := 'PROC_INSERT_TUTOR';
 
    -- Variáveis auxiliares de captura de erro
    v_error_code DB_LOG_ERRORS.ERROR_CODE%TYPE;
    v_error_msg  DB_LOG_ERRORS.ERROR_MSG%TYPE;
 
BEGIN
 
    -- --------------------------------------------------------
    -- Validação manual: campos obrigatórios não podem ser nulos
    -- (complementa as constraints NOT NULL da tabela)
    -- --------------------------------------------------------
    IF p_name IS NULL OR p_cpf IS NULL OR p_phone IS NULL
       OR p_email IS NULL OR p_password IS NULL OR p_address IS NULL
    THEN
        RAISE VALUE_ERROR;
    END IF;
 
    -- --------------------------------------------------------
    -- Inserção do registro na tabela DB_TUTOR.
    -- --------------------------------------------------------
    INSERT INTO DB_TUTOR (
        NAME,
        CPF,
        PHONE,
        EMAIL,
        PASSWORD,
        ADDRESS
    ) VALUES (
        p_name,
        p_cpf,
        p_phone,
        p_email,
        p_password,
        p_address
    );
 
    COMMIT;
	
-- --------------------------------------------------------
-- BLOCO DE EXCEÇÕES
-- --------------------------------------------------------
EXCEPTION
 
    -- --------------------------------------------------------
    -- Exceção 1: Violação de constraint UNIQUE
    -- Ocorre quando CPF, telefone ou e-mail já existem na tabela
    -- --------------------------------------------------------
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        v_error_code := SQLCODE;
        v_error_msg  := 'Registro duplicado: CPF, telefone ou e-mail ja cadastrado. ' 
                        || SUBSTR(SQLERRM, 1, 200);
 
        INSERT INTO DB_LOG_ERRORS (PROC_NAME, USER_NAME, ERROR_DATE, ERROR_CODE, ERROR_MSG)
        VALUES (c_proc_name, USER, SYSTIMESTAMP, v_error_code, v_error_msg);
        COMMIT;
 
    -- --------------------------------------------------------
    -- Exceção 2: Valor inválido ou incompatível com o tipo da coluna
    -- Ocorre quando um parâmetro nulo obrigatório é passado ou
    -- quando o tamanho do valor excede o definido na coluna
    -- --------------------------------------------------------
    WHEN VALUE_ERROR THEN
        ROLLBACK;
        v_error_code := SQLCODE;
        v_error_msg  := 'Valor invalido ou nulo em campo obrigatorio: verifique os parametros informados. '
                        || SUBSTR(SQLERRM, 1, 200);
 
        INSERT INTO DB_LOG_ERRORS (PROC_NAME, USER_NAME, ERROR_DATE, ERROR_CODE, ERROR_MSG)
        VALUES (c_proc_name, USER, SYSTIMESTAMP, v_error_code, v_error_msg);
        COMMIT;
 
    -- --------------------------------------------------------
    -- Exceção 3: Qualquer outro erro não previsto
    -- --------------------------------------------------------
    WHEN OTHERS THEN
        ROLLBACK;
        v_error_code := SQLCODE;
        v_error_msg  := 'Erro inesperado: ' || SUBSTR(SQLERRM, 1, 200);
 
        INSERT INTO DB_LOG_ERRORS (PROC_NAME, USER_NAME, ERROR_DATE, ERROR_CODE, ERROR_MSG)
        VALUES (c_proc_name, USER, SYSTIMESTAMP, v_error_code, v_error_msg);
        COMMIT;
 
END PROC_INSERT_TUTOR;
/

-- ============================================================
-- PROCEDURE: PROC_INSERT_VETERINARIAN
-- ============================================================
CREATE OR REPLACE PROCEDURE PROC_INSERT_VETERINARIAN (
    p_name      IN DB_VETERINARIAN.NAME%TYPE,
    p_crmv      IN DB_VETERINARIAN.CRMV%TYPE,
    p_specialty IN DB_VETERINARIAN.SPECIALTY%TYPE
)
IS
    -- Constante com o nome da procedure para uso no log
    c_proc_name CONSTANT VARCHAR2(100) := 'PROC_INSERT_VETERINARIAN';
	
	-- Variáveis auxiliares de captura de erro
    v_error_code DB_LOG_ERRORS.ERROR_CODE%TYPE;
    v_error_msg  DB_LOG_ERRORS.ERROR_MSG%TYPE;
	
BEGIN
	-- --------------------------------------------------------
    -- Validação manual: campos obrigatórios não podem ser nulos
    -- (complementa as constraints NOT NULL da tabela)
    -- --------------------------------------------------------
    IF p_name IS NULL OR p_crmv IS NULL OR p_specialty IS NULL THEN
        RAISE VALUE_ERROR;
    END IF;
	
    -- --------------------------------------------------------
    -- Inserção do registro na tabela DB_VETERINARIAN.
    -- --------------------------------------------------------
    INSERT INTO DB_VETERINARIAN (NAME, CRMV, SPECIALTY) 
    VALUES (p_name, p_crmv, p_specialty);

    COMMIT;
	
-- --------------------------------------------------------
-- BLOCO DE EXCEÇÕES
-- --------------------------------------------------------
EXCEPTION

    -- --------------------------------------------------------
    -- Exceção 1: Violação de constraint UNIQUE
    -- Ocorre quando CPF, telefone ou e-mail já existem na tabela
    -- --------------------------------------------------------
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        v_error_code := SQLCODE;
        v_error_msg  := 'Registro duplicado: CRMV ja cadastrado. ' || SUBSTR(SQLERRM, 1, 200);
        INSERT INTO DB_LOG_ERRORS (PROC_NAME, USER_NAME, ERROR_DATE, ERROR_CODE, ERROR_MSG)
        VALUES (c_proc_name, USER, SYSTIMESTAMP, v_error_code, v_error_msg);
        COMMIT;
		
	-- --------------------------------------------------------
    -- Exceção 2: Valor inválido ou incompatível com o tipo da coluna
    -- Ocorre quando um parâmetro nulo obrigatório é passado ou
    -- quando o tamanho do valor excede o definido na coluna
    -- --------------------------------------------------------
    WHEN VALUE_ERROR THEN
        ROLLBACK;
        v_error_code := SQLCODE;
        v_error_msg  := 'Valor invalido ou nulo em campo obrigatorio. ' || SUBSTR(SQLERRM, 1, 200);
        INSERT INTO DB_LOG_ERRORS (PROC_NAME, USER_NAME, ERROR_DATE, ERROR_CODE, ERROR_MSG)
        VALUES (c_proc_name, USER, SYSTIMESTAMP, v_error_code, v_error_msg);
        COMMIT;

    -- --------------------------------------------------------
    -- Exceção 3: Qualquer outro erro não previsto
    -- --------------------------------------------------------
    WHEN OTHERS THEN
        ROLLBACK;
        v_error_code := SQLCODE;
        v_error_msg  := 'Erro inesperado: ' || SUBSTR(SQLERRM, 1, 200);
        INSERT INTO DB_LOG_ERRORS (PROC_NAME, USER_NAME, ERROR_DATE, ERROR_CODE, ERROR_MSG)
        VALUES (c_proc_name, USER, SYSTIMESTAMP, v_error_code, v_error_msg);
		
        COMMIT;
END PROC_INSERT_VETERINARIAN;
/

-- ============================================================
-- PROCEDURE: PROC_INSERT_CLINIC
-- ============================================================
CREATE OR REPLACE PROCEDURE PROC_INSERT_CLINIC (
    p_name    IN DB_CLINIC.NAME%TYPE,
    p_cnpj    IN DB_CLINIC.CNPJ%TYPE,
    p_address IN DB_CLINIC.ADDRESS%TYPE
)
IS
    -- Constante com o nome da procedure para uso no log
    c_proc_name CONSTANT VARCHAR2(100) := 'PROC_INSERT_CLINIC';

    -- Variáveis auxiliares de captura de erro
    v_error_code DB_LOG_ERRORS.ERROR_CODE%TYPE;
    v_error_msg  DB_LOG_ERRORS.ERROR_MSG%TYPE;

BEGIN
    -- --------------------------------------------------------
    -- Validação manual: campos obrigatórios não podem ser nulos
    -- (complementa as constraints NOT NULL da tabela)
    -- --------------------------------------------------------
    IF p_name IS NULL OR p_cnpj IS NULL OR p_address IS NULL THEN
        RAISE VALUE_ERROR;
    END IF;

    -- --------------------------------------------------------
    -- Inserção do registro na tabela DB_CLINIC.
    -- --------------------------------------------------------
    INSERT INTO DB_CLINIC (NAME, CNPJ, ADDRESS) 
    VALUES (p_name, p_cnpj, p_address);

    COMMIT;

-- --------------------------------------------------------
-- BLOCO DE EXCEÇÕES
-- --------------------------------------------------------
EXCEPTION
    -- --------------------------------------------------------
    -- Exceção 1: Violação de constraint UNIQUE
    -- Ocorre quando CNPJ já existe na tabela
    -- --------------------------------------------------------
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        v_error_code := SQLCODE;
        v_error_msg  := 'Registro duplicado: CNPJ ja cadastrado. ' || SUBSTR(SQLERRM, 1, 200);
        INSERT INTO DB_LOG_ERRORS (PROC_NAME, USER_NAME, ERROR_DATE, ERROR_CODE, ERROR_MSG)
        VALUES (c_proc_name, USER, SYSTIMESTAMP, v_error_code, v_error_msg);
        COMMIT;

    -- --------------------------------------------------------
    -- Exceção 2: Valor inválido ou incompatível com o tipo da coluna
    -- Ocorre quando um parâmetro nulo obrigatório é passado ou
    -- quando o tamanho do valor excede o definido na coluna
    -- --------------------------------------------------------
    WHEN VALUE_ERROR THEN
        ROLLBACK;
        v_error_code := SQLCODE;
        v_error_msg  := 'Valor invalido ou nulo em campo obrigatorio. ' || SUBSTR(SQLERRM, 1, 200);
        INSERT INTO DB_LOG_ERRORS (PROC_NAME, USER_NAME, ERROR_DATE, ERROR_CODE, ERROR_MSG)
        VALUES (c_proc_name, USER, SYSTIMESTAMP, v_error_code, v_error_msg);
        COMMIT;

    -- --------------------------------------------------------
    -- Exceção 3: Qualquer outro erro não previsto
    -- --------------------------------------------------------
    WHEN OTHERS THEN
        ROLLBACK;
        v_error_code := SQLCODE;
        v_error_msg  := 'Erro inesperado: ' || SUBSTR(SQLERRM, 1, 200);
        INSERT INTO DB_LOG_ERRORS (PROC_NAME, USER_NAME, ERROR_DATE, ERROR_CODE, ERROR_MSG)
        VALUES (c_proc_name, USER, SYSTIMESTAMP, v_error_code, v_error_msg);
        COMMIT;
END PROC_INSERT_CLINIC;
/

-- ============================================================
-- PROCEDURE: PROC_INSERT_PET
-- ============================================================
CREATE OR REPLACE PROCEDURE PROC_INSERT_PET (
    p_id_tutor   IN DB_PET.ID_TUTOR%TYPE,
    p_name       IN DB_PET.NAME%TYPE,
    p_species    IN DB_PET.SPECIES%TYPE,
    p_breed      IN DB_PET.BREED%TYPE,
    p_birth_date IN DB_PET.BIRTH_DATE%TYPE,
    p_weight     IN DB_PET.WEIGHT%TYPE,
    p_sex        IN DB_PET.SEX%TYPE
)
IS
    -- Constante com o nome da procedure para uso no log
    c_proc_name CONSTANT VARCHAR2(100) := 'PROC_INSERT_PET';

    -- Variáveis auxiliares de captura de erro
    v_error_code DB_LOG_ERRORS.ERROR_CODE%TYPE;
    v_error_msg  DB_LOG_ERRORS.ERROR_MSG%TYPE;
    v_fk_count   NUMBER;
    e_fk_invalid EXCEPTION;

BEGIN
    -- --------------------------------------------------------
    -- Validação manual: campos obrigatórios não podem ser nulos
    -- (complementa as constraints NOT NULL da tabela)
    -- --------------------------------------------------------
    IF p_id_tutor IS NULL OR p_species IS NULL OR p_sex IS NULL THEN
        RAISE VALUE_ERROR;
    END IF;

    -- --------------------------------------------------------
    -- Validação de Foreign Key
    -- --------------------------------------------------------
    SELECT COUNT(1) INTO v_fk_count FROM DB_TUTOR WHERE ID = p_id_tutor;
    IF v_fk_count = 0 THEN
        RAISE e_fk_invalid;
    END IF;

    -- --------------------------------------------------------
    -- Inserção do registro na tabela DB_PET.
    -- --------------------------------------------------------
    INSERT INTO DB_PET (ID_TUTOR, NAME, SPECIES, BREED, BIRTH_DATE, WEIGHT, SEX) 
    VALUES (p_id_tutor, p_name, p_species, p_breed, p_birth_date, p_weight, p_sex);

    COMMIT;

-- --------------------------------------------------------
-- BLOCO DE EXCEÇÕES
-- --------------------------------------------------------
EXCEPTION
    -- --------------------------------------------------------
    -- Exceção de Chave Estrangeira Inválida
    -- Ocorre quando o ID_TUTOR informado não existe na tabela pai
    -- --------------------------------------------------------
    WHEN e_fk_invalid THEN
        ROLLBACK;
        v_error_code := -20001;
        v_error_msg  := 'Erro de Integridade: ID_TUTOR nao encontrado na tabela DB_TUTOR.';
        INSERT INTO DB_LOG_ERRORS (PROC_NAME, USER_NAME, ERROR_DATE, ERROR_CODE, ERROR_MSG)
        VALUES (c_proc_name, USER, SYSTIMESTAMP, v_error_code, v_error_msg);
        COMMIT;

    -- --------------------------------------------------------
    -- Exceção 2: Valor inválido ou incompatível com o tipo da coluna
    -- Ocorre quando um parâmetro nulo obrigatório é passado ou
    -- quando o tamanho do valor excede o definido na coluna
    -- --------------------------------------------------------
    WHEN VALUE_ERROR THEN
        ROLLBACK;
        v_error_code := SQLCODE;
        v_error_msg  := 'Valor invalido ou nulo em campo obrigatorio. ' || SUBSTR(SQLERRM, 1, 200);
        INSERT INTO DB_LOG_ERRORS (PROC_NAME, USER_NAME, ERROR_DATE, ERROR_CODE, ERROR_MSG)
        VALUES (c_proc_name, USER, SYSTIMESTAMP, v_error_code, v_error_msg);
        COMMIT;

    -- --------------------------------------------------------
    -- Exceção 3: Qualquer outro erro não previsto
    -- --------------------------------------------------------
    WHEN OTHERS THEN
        ROLLBACK;
        v_error_code := SQLCODE;
        v_error_msg  := 'Erro inesperado: ' || SUBSTR(SQLERRM, 1, 200);
        INSERT INTO DB_LOG_ERRORS (PROC_NAME, USER_NAME, ERROR_DATE, ERROR_CODE, ERROR_MSG)
        VALUES (c_proc_name, USER, SYSTIMESTAMP, v_error_code, v_error_msg);
        COMMIT;
END PROC_INSERT_PET;
/

-- ============================================================
-- PROCEDURE: PROC_INSERT_MEDICAL_RECORD
-- ============================================================
CREATE OR REPLACE PROCEDURE PROC_INSERT_MEDICAL_RECORD (
    p_id_pet           IN DB_MEDICAL_RECORD.ID_PET%TYPE,
    p_blood_type       IN DB_MEDICAL_RECORD.BLOOD_TYPE%TYPE,
    p_allergies        IN DB_MEDICAL_RECORD.ALLERGIES%TYPE,
    p_chronic_diseases IN DB_MEDICAL_RECORD.CHRONIC_DISEASES%TYPE,
    p_is_castrated     IN DB_MEDICAL_RECORD.IS_CASTRATED%TYPE,
    p_microchip_code   IN DB_MEDICAL_RECORD.MICROCHIP_CODE%TYPE,
    p_last_update      IN DB_MEDICAL_RECORD.LAST_UPDATE%TYPE
)
IS
    -- Constante com o nome da procedure para uso no log
    c_proc_name CONSTANT VARCHAR2(100) := 'PROC_INSERT_MEDICAL_RECORD';

    -- Variáveis auxiliares de captura de erro
    v_error_code DB_LOG_ERRORS.ERROR_CODE%TYPE;
    v_error_msg  DB_LOG_ERRORS.ERROR_MSG%TYPE;
    v_fk_count   NUMBER;
    e_fk_invalid EXCEPTION;

BEGIN
    -- --------------------------------------------------------
    -- Validação manual: campos obrigatórios não podem ser nulos
    -- (complementa as constraints NOT NULL da tabela)
    -- --------------------------------------------------------
    IF p_id_pet IS NULL OR p_blood_type IS NULL OR p_last_update IS NULL THEN
        RAISE VALUE_ERROR;
    END IF;

    -- --------------------------------------------------------
    -- Validação de Foreign Key
    -- --------------------------------------------------------
    SELECT COUNT(1) INTO v_fk_count FROM DB_PET WHERE ID = p_id_pet;
    IF v_fk_count = 0 THEN
        RAISE e_fk_invalid;
    END IF;

    -- --------------------------------------------------------
    -- Inserção do registro na tabela DB_MEDICAL_RECORD.
    -- --------------------------------------------------------
    INSERT INTO DB_MEDICAL_RECORD (ID_PET, BLOOD_TYPE, ALLERGIES, CHRONIC_DISEASES, IS_CASTRATED, MICROCHIP_CODE, LAST_UPDATE) 
    VALUES (p_id_pet, p_blood_type, p_allergies, p_chronic_diseases, NVL(p_is_castrated, 'N'), p_microchip_code, p_last_update);

    COMMIT;

-- --------------------------------------------------------
-- BLOCO DE EXCEÇÕES
-- --------------------------------------------------------
EXCEPTION
    -- --------------------------------------------------------
    -- Exceção de Chave Estrangeira Inválida
    -- Ocorre quando o ID_PET informado não existe na tabela pai
    -- --------------------------------------------------------
    WHEN e_fk_invalid THEN
        ROLLBACK;
        v_error_code := -20001;
        v_error_msg  := 'Erro de Integridade: ID_PET nao encontrado na tabela DB_PET.';
        INSERT INTO DB_LOG_ERRORS (PROC_NAME, USER_NAME, ERROR_DATE, ERROR_CODE, ERROR_MSG)
        VALUES (c_proc_name, USER, SYSTIMESTAMP, v_error_code, v_error_msg);
        COMMIT;

    -- --------------------------------------------------------
    -- Exceção 2: Violação de constraint UNIQUE
    -- Ocorre quando ID_PET ou MICROCHIP_CODE já existem na tabela
    -- --------------------------------------------------------
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        v_error_code := SQLCODE;
        v_error_msg  := 'Registro duplicado: ID_PET ou MICROCHIP_CODE ja existente. ' || SUBSTR(SQLERRM, 1, 200);
        INSERT INTO DB_LOG_ERRORS (PROC_NAME, USER_NAME, ERROR_DATE, ERROR_CODE, ERROR_MSG)
        VALUES (c_proc_name, USER, SYSTIMESTAMP, v_error_code, v_error_msg);
        COMMIT;

    -- --------------------------------------------------------
    -- Exceção 3: Qualquer outro erro não previsto
    -- --------------------------------------------------------
    WHEN OTHERS THEN
        ROLLBACK;
        v_error_code := SQLCODE;
        v_error_msg  := 'Erro inesperado (ex. valor fora da constraint CHECK de IS_CASTRATED): ' || SUBSTR(SQLERRM, 1, 200);
        INSERT INTO DB_LOG_ERRORS (PROC_NAME, USER_NAME, ERROR_DATE, ERROR_CODE, ERROR_MSG)
        VALUES (c_proc_name, USER, SYSTIMESTAMP, v_error_code, v_error_msg);
        COMMIT;
END PROC_INSERT_MEDICAL_RECORD;
/

-- ============================================================
-- PROCEDURE: PROC_INSERT_VACCINATION
-- ============================================================
CREATE OR REPLACE PROCEDURE PROC_INSERT_VACCINATION (
    p_id_pet           IN DB_VACCINATION.ID_PET%TYPE,
    p_vaccine_name     IN DB_VACCINATION.VACCINE_NAME%TYPE,
    p_application_date IN DB_VACCINATION.APPLICATION_DATE%TYPE,
    p_expiration_date  IN DB_VACCINATION.EXPIRATION_DATE%TYPE,
    p_lot              IN DB_VACCINATION.LOT%TYPE
)
IS
    -- Constante com o nome da procedure para uso no log
    c_proc_name CONSTANT VARCHAR2(100) := 'PROC_INSERT_VACCINATION';

    -- Variáveis auxiliares de captura de erro
    v_error_code DB_LOG_ERRORS.ERROR_CODE%TYPE;
    v_error_msg  DB_LOG_ERRORS.ERROR_MSG%TYPE;
    v_fk_count   NUMBER;
    e_fk_invalid EXCEPTION;

BEGIN
    -- --------------------------------------------------------
    -- Validação manual: campos obrigatórios não podem ser nulos
    -- (complementa as constraints NOT NULL da tabela)
    -- --------------------------------------------------------
    IF p_id_pet IS NULL OR p_vaccine_name IS NULL OR p_application_date IS NULL OR p_expiration_date IS NULL THEN
        RAISE VALUE_ERROR;
    END IF;

    -- --------------------------------------------------------
    -- Validação de Foreign Key
    -- --------------------------------------------------------
    SELECT COUNT(1) INTO v_fk_count FROM DB_PET WHERE ID = p_id_pet;
    IF v_fk_count = 0 THEN
        RAISE e_fk_invalid;
    END IF;

    -- --------------------------------------------------------
    -- Inserção do registro na tabela DB_VACCINATION.
    -- --------------------------------------------------------
    INSERT INTO DB_VACCINATION (ID_PET, VACCINE_NAME, APPLICATION_DATE, EXPIRATION_DATE, LOT) 
    VALUES (p_id_pet, p_vaccine_name, p_application_date, p_expiration_date, p_lot);

    COMMIT;

-- --------------------------------------------------------
-- BLOCO DE EXCEÇÕES
-- --------------------------------------------------------
EXCEPTION
    -- --------------------------------------------------------
    -- Exceção de Chave Estrangeira Inválida
    -- Ocorre quando o ID_PET informado não existe na tabela pai
    -- --------------------------------------------------------
    WHEN e_fk_invalid THEN
        ROLLBACK;
        v_error_code := -20001;
        v_error_msg  := 'Erro de Integridade: ID_PET nao encontrado na tabela DB_PET.';
        INSERT INTO DB_LOG_ERRORS (PROC_NAME, USER_NAME, ERROR_DATE, ERROR_CODE, ERROR_MSG)
        VALUES (c_proc_name, USER, SYSTIMESTAMP, v_error_code, v_error_msg);
        COMMIT;

    -- --------------------------------------------------------
    -- Exceção 2: Valor inválido ou incompatível com o tipo da coluna
    -- Ocorre quando um parâmetro nulo obrigatório é passado ou
    -- quando o tamanho do valor excede o definido na coluna
    -- --------------------------------------------------------
    WHEN VALUE_ERROR THEN
        ROLLBACK;
        v_error_code := SQLCODE;
        v_error_msg  := 'Valor invalido ou nulo em campo obrigatorio. ' || SUBSTR(SQLERRM, 1, 200);
        INSERT INTO DB_LOG_ERRORS (PROC_NAME, USER_NAME, ERROR_DATE, ERROR_CODE, ERROR_MSG)
        VALUES (c_proc_name, USER, SYSTIMESTAMP, v_error_code, v_error_msg);
        COMMIT;

    -- --------------------------------------------------------
    -- Exceção 3: Qualquer outro erro não previsto
    -- --------------------------------------------------------
    WHEN OTHERS THEN
        ROLLBACK;
        v_error_code := SQLCODE;
        v_error_msg  := 'Erro inesperado: ' || SUBSTR(SQLERRM, 1, 200);
        INSERT INTO DB_LOG_ERRORS (PROC_NAME, USER_NAME, ERROR_DATE, ERROR_CODE, ERROR_MSG)
        VALUES (c_proc_name, USER, SYSTIMESTAMP, v_error_code, v_error_msg);
        COMMIT;
END PROC_INSERT_VACCINATION;
/

-- ============================================================
-- PROCEDURE: PROC_INSERT_CONSULTATION
-- ============================================================
CREATE OR REPLACE PROCEDURE PROC_INSERT_CONSULTATION (
    p_id_medical_record IN DB_CONSULTATION.ID_MEDICAL_RECORD%TYPE,
    p_id_veterinarian   IN DB_CONSULTATION.ID_VETERINARIAN%TYPE,
    p_id_clinic         IN DB_CONSULTATION.ID_CLINIC%TYPE,
    p_consultation_date IN DB_CONSULTATION.CONSULTATION_DATE%TYPE,
    p_symptoms          IN DB_CONSULTATION.SYMPTOMS%TYPE,
    p_diagnosis         IN DB_CONSULTATION.DIAGNOSIS%TYPE,
    p_observations      IN DB_CONSULTATION.OBSERVATIONS%TYPE,
    p_attachmet         IN DB_CONSULTATION.ATTACHMET%TYPE
)
IS
    -- Constante com o nome da procedure para uso no log
    c_proc_name CONSTANT VARCHAR2(100) := 'PROC_INSERT_CONSULTATION';

    -- Variáveis auxiliares de captura de erro
    v_error_code DB_LOG_ERRORS.ERROR_CODE%TYPE;
    v_error_msg  DB_LOG_ERRORS.ERROR_MSG%TYPE;
    v_fk_count   NUMBER;
    e_fk_invalid EXCEPTION;

BEGIN
    -- --------------------------------------------------------
    -- Validação manual: campos obrigatórios não podem ser nulos
    -- (complementa as constraints NOT NULL da tabela)
    -- --------------------------------------------------------
    IF p_id_medical_record IS NULL OR p_id_veterinarian IS NULL OR p_id_clinic IS NULL OR p_consultation_date IS NULL THEN
        RAISE VALUE_ERROR;
    END IF;

    -- --------------------------------------------------------
    -- Validação de Foreign Keys
    -- --------------------------------------------------------
    SELECT COUNT(1) INTO v_fk_count FROM DB_MEDICAL_RECORD WHERE ID = p_id_medical_record;
    IF v_fk_count = 0 THEN
        v_error_msg := 'Erro: ID_MEDICAL_RECORD nao encontrado.';
        RAISE e_fk_invalid;
    END IF;

    SELECT COUNT(1) INTO v_fk_count FROM DB_VETERINARIAN WHERE ID = p_id_veterinarian;
    IF v_fk_count = 0 THEN
        v_error_msg := 'Erro: ID_VETERINARIAN nao encontrado.';
        RAISE e_fk_invalid;
    END IF;

    SELECT COUNT(1) INTO v_fk_count FROM DB_CLINIC WHERE ID = p_id_clinic;
    IF v_fk_count = 0 THEN
        v_error_msg := 'Erro: ID_CLINIC nao encontrado.';
        RAISE e_fk_invalid;
    END IF;

    -- --------------------------------------------------------
    -- Inserção mantendo a ortografia do seu arquivo para a coluna ATTACHMET
    -- --------------------------------------------------------
    INSERT INTO DB_CONSULTATION (ID_MEDICAL_RECORD, ID_VETERINARIAN, ID_CLINIC, CONSULTATION_DATE, SYMPTOMS, DIAGNOSIS, OBSERVATIONS, ATTACHMET) 
    VALUES (p_id_medical_record, p_id_veterinarian, p_id_clinic, p_consultation_date, p_symptoms, p_diagnosis, p_observations, p_attachmet);

    COMMIT;

-- --------------------------------------------------------
-- BLOCO DE EXCEÇÕES
-- --------------------------------------------------------
EXCEPTION
    -- --------------------------------------------------------
    -- Exceção de Chave Estrangeira Inválida
    -- Ocorre quando algum dos IDs informados não existe na tabela pai correspondente
    -- --------------------------------------------------------
    WHEN e_fk_invalid THEN
        ROLLBACK;
        v_error_code := -20001;
        INSERT INTO DB_LOG_ERRORS (PROC_NAME, USER_NAME, ERROR_DATE, ERROR_CODE, ERROR_MSG)
        VALUES (c_proc_name, USER, SYSTIMESTAMP, v_error_code, v_error_msg);
        COMMIT;

    -- --------------------------------------------------------
    -- Exceção 2: Valor inválido ou incompatível com o tipo da coluna
    -- Ocorre quando um parâmetro nulo obrigatório é passado ou
    -- quando o tamanho do valor excede o definido na coluna
    -- --------------------------------------------------------
    WHEN VALUE_ERROR THEN
        ROLLBACK;
        v_error_code := SQLCODE;
        v_error_msg  := 'Valor invalido ou nulo em campo obrigatorio. ' || SUBSTR(SQLERRM, 1, 200);
        INSERT INTO DB_LOG_ERRORS (PROC_NAME, USER_NAME, ERROR_DATE, ERROR_CODE, ERROR_MSG)
        VALUES (c_proc_name, USER, SYSTIMESTAMP, v_error_code, v_error_msg);
        COMMIT;

    -- --------------------------------------------------------
    -- Exceção 3: Qualquer outro erro não previsto
    -- --------------------------------------------------------
    WHEN OTHERS THEN
        ROLLBACK;
        v_error_code := SQLCODE;
        v_error_msg  := 'Erro inesperado: ' || SUBSTR(SQLERRM, 1, 200);
        INSERT INTO DB_LOG_ERRORS (PROC_NAME, USER_NAME, ERROR_DATE, ERROR_CODE, ERROR_MSG)
        VALUES (c_proc_name, USER, SYSTIMESTAMP, v_error_code, v_error_msg);
        COMMIT;
END PROC_INSERT_CONSULTATION;
/