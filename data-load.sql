-- ============================================================
-- CARGA DE DADOS COMPLETA
-- Ordem de inserção respeita dependências de FK:
--   TUTOR → VETERINARIAN → CLINIC → PET → MEDICAL_RECORD
--   → VACCINATION → CONSULTATION
-- ============================================================


-- ============================================================
-- 1. PROC_INSERT_TUTOR  (sem FK — 3 registros bem-sucedidos)
-- ============================================================

-- Registro 1
BEGIN
    PROC_INSERT_TUTOR(
        p_name     => 'Maria Oliveira',
        p_cpf      => '123.456.789-00',
        p_phone    => '(11) 91234-5678',
        p_email    => 'maria.oliveira@email.com',
        p_password => 'hash_maria_2024',
        p_address  => 'Rua das Flores, 100, Sao Paulo - SP'
    );
END;
/

-- Registro 2
BEGIN
    PROC_INSERT_TUTOR(
        p_name     => 'Carlos Souza',
        p_cpf      => '234.567.890-11',
        p_phone    => '(21) 92345-6789',
        p_email    => 'carlos.souza@email.com',
        p_password => 'hash_carlos_2024',
        p_address  => 'Av. Atlantica, 500, Rio de Janeiro - RJ'
    );
END;
/

-- Registro 3
BEGIN
    PROC_INSERT_TUTOR(
        p_name     => 'Ana Lima',
        p_cpf      => '345.678.901-22',
        p_phone    => '(31) 93456-7890',
        p_email    => 'ana.lima@email.com',
        p_password => 'hash_ana_2024',
        p_address  => 'Rua da Liberdade, 200, Belo Horizonte - MG'
    );
END;
/

-- Registro 4
BEGIN
    PROC_INSERT_TUTOR(
        p_name     => 'Anthony',
        p_cpf      => '342.868.985-20',
        p_phone    => '(11) 98167-4985',
        p_email    => 'anthony@email.com',
        p_password => 'hash_anthony_2026',
        p_address  => 'Rua da juta, 200, São Paulo - SP'
    );
END;
/

-- --------------------------------------------------------
-- Erros esperados — PROC_INSERT_TUTOR
-- --------------------------------------------------------

-- ERRO 1: CPF duplicado → DUP_VAL_ON_INDEX
BEGIN
    PROC_INSERT_TUTOR(
        p_name     => 'Joao Duplicado',
        p_cpf      => '123.456.789-00',   -- CPF já cadastrado (Tutor 1)
        p_phone    => '(11) 99999-0001',
        p_email    => 'joao.dup@email.com',
        p_password => 'hash_joao',
        p_address  => 'Rua X, 1'
    );
END;
/

-- ERRO 2: E-mail duplicado → DUP_VAL_ON_INDEX
BEGIN
    PROC_INSERT_TUTOR(
        p_name     => 'Paula Duplicada',
        p_cpf      => '999.000.111-33',
        p_phone    => '(11) 97777-0002',
        p_email    => 'carlos.souza@email.com',  -- E-mail já cadastrado (Tutor 2)
        p_password => 'hash_paula',
        p_address  => 'Rua Y, 2'
    );
END;
/

-- ERRO 3: Nome nulo → VALUE_ERROR
BEGIN
    PROC_INSERT_TUTOR(
        p_name     => NULL,               -- Campo obrigatório
        p_cpf      => '987.654.321-00',
        p_phone    => '(11) 98888-0002',
        p_email    => 'sem.nome@email.com',
        p_password => 'hash_sem_nome',
        p_address  => 'Rua Sem Nome, 0'
    );
END;
/

-- ERRO 4: Endereço nulo → VALUE_ERROR
BEGIN
    PROC_INSERT_TUTOR(
        p_name     => 'Sem Endereco',
        p_cpf      => '111.222.333-44',
        p_phone    => '(11) 96666-0003',
        p_email    => 'sem.endereco@email.com',
        p_password => 'hash_end',
        p_address  => NULL              -- Campo obrigatório
    );
END;
/


-- ============================================================
-- 2. PROC_INSERT_VETERINARIAN  (sem FK — 3 registros bem-sucedidos)
-- ============================================================

-- Registro 1
BEGIN
    PROC_INSERT_VETERINARIAN(
        p_name      => 'Dr. Ricardo Alves',
        p_crmv      => 'SP-12345',
        p_specialty => 'Clinico Geral'
    );
END;
/

-- Registro 2
BEGIN
    PROC_INSERT_VETERINARIAN(
        p_name      => 'Dra. Fernanda Costa',
        p_crmv      => 'RJ-67890',
        p_specialty => 'Dermatologia'
    );
END;
/

-- Registro 3
BEGIN
    PROC_INSERT_VETERINARIAN(
        p_name      => 'Dr. Marcos Pinto',
        p_crmv      => 'MG-11223',
        p_specialty => 'Ortopedia'
    );
END;
/

-- --------------------------------------------------------
-- Erros esperados — PROC_INSERT_VETERINARIAN
-- --------------------------------------------------------

-- ERRO 1: CRMV duplicado → DUP_VAL_ON_INDEX
BEGIN
    PROC_INSERT_VETERINARIAN(
        p_name      => 'Dr. Falso',
        p_crmv      => 'SP-12345',        -- CRMV já cadastrado (Vet 1)
        p_specialty => 'Cardiologia'
    );
END;
/

-- ERRO 2: Especialidade nula → VALUE_ERROR
BEGIN
    PROC_INSERT_VETERINARIAN(
        p_name      => 'Dr. Sem Especialidade',
        p_crmv      => 'RS-99999',
        p_specialty => NULL               -- Campo obrigatório
    );
END;
/

-- ERRO 3: Nome nulo → VALUE_ERROR
BEGIN
    PROC_INSERT_VETERINARIAN(
        p_name      => NULL,              -- Campo obrigatório
        p_crmv      => 'BA-55555',
        p_specialty => 'Neurologia'
    );
END;
/


-- ============================================================
-- 3. PROC_INSERT_CLINIC  (sem FK — 3 registros bem-sucedidos)
-- ============================================================

-- Registro 1
BEGIN
    PROC_INSERT_CLINIC(
        p_name    => 'VetCenter Sao Paulo',
        p_cnpj    => '11.222.333/0001-44',
        p_address => 'Av. Paulista, 1000, Sao Paulo - SP'
    );
END;
/

-- Registro 2
BEGIN
    PROC_INSERT_CLINIC(
        p_name    => 'Clinica Animal Rio',
        p_cnpj    => '22.333.444/0001-55',
        p_address => 'Rua Barata Ribeiro, 300, Rio de Janeiro - RJ'
    );
END;
/

-- Registro 3
BEGIN
    PROC_INSERT_CLINIC(
        p_name    => 'PetSaude BH',
        p_cnpj    => '33.444.555/0001-66',
        p_address => 'Av. do Contorno, 700, Belo Horizonte - MG'
    );
END;
/

-- --------------------------------------------------------
-- Erros esperados — PROC_INSERT_CLINIC
-- --------------------------------------------------------

-- ERRO 1: CNPJ duplicado → DUP_VAL_ON_INDEX
BEGIN
    PROC_INSERT_CLINIC(
        p_name    => 'Clinica Fantasma',
        p_cnpj    => '11.222.333/0001-44',  -- CNPJ já cadastrado (Clinica 1)
        p_address => 'Rua Falsa, 0'
    );
END;
/

-- ERRO 2: Nome nulo → VALUE_ERROR
BEGIN
    PROC_INSERT_CLINIC(
        p_name    => NULL,                  -- Campo obrigatório
        p_cnpj    => '99.888.777/0001-00',
        p_address => 'Rua Qualquer, 99'
    );
END;
/

-- ERRO 3: CNPJ nulo → VALUE_ERROR
BEGIN
    PROC_INSERT_CLINIC(
        p_name    => 'Clinica Sem CNPJ',
        p_cnpj    => NULL,                  -- Campo obrigatório
        p_address => 'Rua Sem Registro, 10'
    );
END;
/


-- ============================================================
-- 4. PROC_INSERT_PET  (FK → DB_TUTOR)
-- Tutor 1 (ID=1) → 2 pets | Tutor 2 (ID=2) → 2 pets | Tutor 3 (ID=3) → 1 pet
-- ============================================================

-- Pets do Tutor 1 — Maria Oliveira
BEGIN
    PROC_INSERT_PET(
        p_id_tutor   => 1,
        p_name       => 'Bolt',
        p_species    => 'Cachorro',
        p_breed      => 'Labrador',
        p_birth_date => TO_TIMESTAMP('2020-03-15', 'YYYY-MM-DD'),
        p_weight     => 28.5,
        p_sex        => 'Macho'
    );
END;
/

BEGIN
    PROC_INSERT_PET(
        p_id_tutor   => 1,
        p_name       => 'Mia',
        p_species    => 'Gato',
        p_breed      => 'Siames',
        p_birth_date => TO_TIMESTAMP('2021-07-22', 'YYYY-MM-DD'),
        p_weight     => 4.2,
        p_sex        => 'Femea'
    );
END;
/

-- Pets do Tutor 2 — Carlos Souza
BEGIN
    PROC_INSERT_PET(
        p_id_tutor   => 2,
        p_name       => 'Rex',
        p_species    => 'Cachorro',
        p_breed      => 'Pastor Alemao',
        p_birth_date => TO_TIMESTAMP('2019-11-05', 'YYYY-MM-DD'),
        p_weight     => 35.0,
        p_sex        => 'Macho'
    );
END;
/

BEGIN
    PROC_INSERT_PET(
        p_id_tutor   => 2,
        p_name       => 'Nina',
        p_species    => 'Gato',
        p_breed      => 'Persa',
        p_birth_date => TO_TIMESTAMP('2022-01-10', 'YYYY-MM-DD'),
        p_weight     => 3.8,
        p_sex        => 'Femea'
    );
END;
/

-- Pet do Tutor 3 — Ana Lima
BEGIN
    PROC_INSERT_PET(
        p_id_tutor   => 3,
        p_name       => 'Totó',
        p_species    => 'Cachorro',
        p_breed      => 'Poodle',
        p_birth_date => TO_TIMESTAMP('2023-05-30', 'YYYY-MM-DD'),
        p_weight     => 6.1,
        p_sex        => 'Macho'
    );
END;
/

-- Pet do Tutor 4 - Anthony
BEGIN
    PROC_INSERT_PET(
        p_id_tutor   => 4,
        p_name       => 'Master',
        p_species    => 'Cachorro',
        p_breed      =>  null,
        p_birth_date => TO_TIMESTAMP('2024-05-20', 'YYYY-MM-DD'),
        p_weight     => 5.1,
        p_sex        => 'Macho'
    );
END;
/


-- --------------------------------------------------------
-- Erros esperados — PROC_INSERT_PET
-- --------------------------------------------------------

-- ERRO 1: ID_TUTOR inexistente → e_fk_invalid
BEGIN
    PROC_INSERT_PET(
        p_id_tutor   => 9999,             -- Tutor não existe
        p_name       => 'Fantasy Pet',
        p_species    => 'Cachorro',
        p_breed      => 'Vira-lata',
        p_birth_date => TO_TIMESTAMP('2022-06-01', 'YYYY-MM-DD'),
        p_weight     => 10.0,
        p_sex        => 'Macho'
    );
END;
/

-- ERRO 2: Espécie nula → VALUE_ERROR
BEGIN
    PROC_INSERT_PET(
        p_id_tutor   => 1,
        p_name       => 'Sem Especie',
        p_species    => NULL,             -- Campo obrigatório
        p_breed      => 'Indefinido',
        p_birth_date => TO_TIMESTAMP('2021-01-01', 'YYYY-MM-DD'),
        p_weight     => 5.0,
        p_sex        => 'Macho'
    );
END;
/

-- ERRO 3: Sexo nulo → VALUE_ERROR
BEGIN
    PROC_INSERT_PET(
        p_id_tutor   => 2,
        p_name       => 'Sem Sexo',
        p_species    => 'Gato',
        p_breed      => 'Angorá',
        p_birth_date => TO_TIMESTAMP('2020-09-15', 'YYYY-MM-DD'),
        p_weight     => 3.5,
        p_sex        => NULL              -- Campo obrigatório
    );
END;
/

-- ERRO 4: ID_TUTOR nulo → VALUE_ERROR
BEGIN
    PROC_INSERT_PET(
        p_id_tutor   => NULL,             -- Campo obrigatório
        p_name       => 'Sem Tutor',
        p_species    => 'Cachorro',
        p_breed      => 'Bulldog',
        p_birth_date => TO_TIMESTAMP('2021-04-20', 'YYYY-MM-DD'),
        p_weight     => 12.0,
        p_sex        => 'Femea'
    );
END;
/


-- ============================================================
-- 5. PROC_INSERT_MEDICAL_RECORD  (FK → DB_PET — 1:1)
-- Um prontuário por pet (IDs de pet: 1 a 5)
-- ============================================================

-- Prontuário do Pet 1 — Bolt
BEGIN
    PROC_INSERT_MEDICAL_RECORD(
        p_id_pet           => 1,
        p_blood_type       => 'DEA 1+',
        p_allergies        => 'Dipirona',
        p_chronic_diseases => NULL,
        p_is_castrated     => 'S',
        p_microchip_code   => 'MC-0001-BR',
        p_last_update      => SYSTIMESTAMP
    );
END;
/

-- Prontuário do Pet 2 — Mia
BEGIN
    PROC_INSERT_MEDICAL_RECORD(
        p_id_pet           => 2,
        p_blood_type       => 'A+',
        p_allergies        => NULL,
        p_chronic_diseases => 'Insuficiencia renal cronica',
        p_is_castrated     => 'N',
        p_microchip_code   => 'MC-0002-BR',
        p_last_update      => SYSTIMESTAMP
    );
END;
/

-- Prontuário do Pet 3 — Rex
BEGIN
    PROC_INSERT_MEDICAL_RECORD(
        p_id_pet           => 3,
        p_blood_type       => 'DEA 1-',
        p_allergies        => 'Amoxicilina, Polen',
        p_chronic_diseases => 'Displasia coxofemoral',
        p_is_castrated     => 'S',
        p_microchip_code   => 'MC-0003-BR',
        p_last_update      => SYSTIMESTAMP
    );
END;
/

-- Prontuário do Pet 4 — Nina
BEGIN
    PROC_INSERT_MEDICAL_RECORD(
        p_id_pet           => 4,
        p_blood_type       => 'B+',
        p_allergies        => NULL,
        p_chronic_diseases => NULL,
        p_is_castrated     => 'S',
        p_microchip_code   => 'MC-0004-BR',
        p_last_update      => SYSTIMESTAMP
    );
END;
/

-- Prontuário do Pet 5 — Totó
BEGIN
    PROC_INSERT_MEDICAL_RECORD(
        p_id_pet           => 5,
        p_blood_type       => 'DEA 1+',
        p_allergies        => 'Picada de abelha',
        p_chronic_diseases => NULL,
        p_is_castrated     => 'N',
        p_microchip_code   => 'MC-0005-BR',
        p_last_update      => SYSTIMESTAMP
    );
END;
/

-- --------------------------------------------------------
-- Erros esperados — PROC_INSERT_MEDICAL_RECORD
-- --------------------------------------------------------

-- ERRO 1: ID_PET inexistente → e_fk_invalid
BEGIN
    PROC_INSERT_MEDICAL_RECORD(
        p_id_pet           => 9999,       -- Pet não existe
        p_blood_type       => 'DEA 1+',
        p_allergies        => NULL,
        p_chronic_diseases => NULL,
        p_is_castrated     => 'N',
        p_microchip_code   => 'MC-FAKE-01',
        p_last_update      => SYSTIMESTAMP
    );
END;
/

-- ERRO 2: ID_PET duplicado (prontuário já existe para o Pet 1) → DUP_VAL_ON_INDEX
BEGIN
    PROC_INSERT_MEDICAL_RECORD(
        p_id_pet           => 1,          -- Já possui prontuário cadastrado
        p_blood_type       => 'DEA 1-',
        p_allergies        => NULL,
        p_chronic_diseases => NULL,
        p_is_castrated     => 'S',
        p_microchip_code   => 'MC-0099-BR',
        p_last_update      => SYSTIMESTAMP
    );
END;
/

-- ERRO 3: Microchip duplicado (MC-0002-BR já existe) → DUP_VAL_ON_INDEX
BEGIN
    PROC_INSERT_MEDICAL_RECORD(
        p_id_pet           => 5,          -- Tentativa de reutilizar microchip
        p_blood_type       => 'A+',
        p_allergies        => NULL,
        p_chronic_diseases => NULL,
        p_is_castrated     => 'N',
        p_microchip_code   => 'MC-0002-BR', -- Código já cadastrado (Pet 2)
        p_last_update      => SYSTIMESTAMP
    );
END;
/

-- ERRO 4: IS_CASTRATED com valor inválido → OTHERS (CHECK constraint)
BEGIN
    PROC_INSERT_MEDICAL_RECORD(
        p_id_pet           => 6,          -- Pet hipotético — mas o CHECK dispara antes
        p_blood_type       => 'DEA 1+',
        p_allergies        => NULL,
        p_chronic_diseases => NULL,
        p_is_castrated     => 'X',        -- Valor inválido: apenas 'S' ou 'N' são aceitos
        p_microchip_code   => 'MC-0099-BR',
        p_last_update      => SYSTIMESTAMP
    );
END;
/

-- ERRO 5: Blood type nulo → VALUE_ERROR
BEGIN
    PROC_INSERT_MEDICAL_RECORD(
        p_id_pet           => 3,
        p_blood_type       => NULL,       -- Campo obrigatório
        p_allergies        => NULL,
        p_chronic_diseases => NULL,
        p_is_castrated     => 'N',
        p_microchip_code   => 'MC-0088-BR',
        p_last_update      => SYSTIMESTAMP
    );
END;
/


-- ============================================================
-- 6. PROC_INSERT_VACCINATION  (FK → DB_PET)
-- Pet 1 → 2 vacinas | Pet 2 → 1 vacina | Pet 3 → 2 vacinas
-- Pet 4 → 1 vacina  | Pet 5 → 1 vacina
-- ============================================================

-- Vacinas do Pet 1 — Bolt
BEGIN
    PROC_INSERT_VACCINATION(
        p_id_pet           => 1,
        p_vaccine_name     => 'V10',
        p_application_date => TO_DATE('2024-01-10', 'YYYY-MM-DD'),
        p_expiration_date  => TO_DATE('2025-01-10', 'YYYY-MM-DD'),
        p_lot              => 'LOT-A001'
    );
END;
/

BEGIN
    PROC_INSERT_VACCINATION(
        p_id_pet           => 1,
        p_vaccine_name     => 'Antirrábica',
        p_application_date => TO_DATE('2024-01-10', 'YYYY-MM-DD'),
        p_expiration_date  => TO_DATE('2025-01-10', 'YYYY-MM-DD'),
        p_lot              => 'LOT-R010'
    );
END;
/

-- Vacina do Pet 2 — Mia
BEGIN
    PROC_INSERT_VACCINATION(
        p_id_pet           => 2,
        p_vaccine_name     => 'Quádrupla Felina',
        p_application_date => TO_DATE('2023-11-05', 'YYYY-MM-DD'),
        p_expiration_date  => TO_DATE('2024-11-05', 'YYYY-MM-DD'),
        p_lot              => 'LOT-F004'
    );
END;
/

-- Vacinas do Pet 3 — Rex
BEGIN
    PROC_INSERT_VACCINATION(
        p_id_pet           => 3,
        p_vaccine_name     => 'V8',
        p_application_date => TO_DATE('2024-02-20', 'YYYY-MM-DD'),
        p_expiration_date  => TO_DATE('2025-02-20', 'YYYY-MM-DD'),
        p_lot              => 'LOT-B002'
    );
END;
/

BEGIN
    PROC_INSERT_VACCINATION(
        p_id_pet           => 3,
        p_vaccine_name     => 'Antirrábica',
        p_application_date => TO_DATE('2024-02-20', 'YYYY-MM-DD'),
        p_expiration_date  => TO_DATE('2025-02-20', 'YYYY-MM-DD'),
        p_lot              => 'LOT-R011'
    );
END;
/

-- Vacina do Pet 4 — Nina
BEGIN
    PROC_INSERT_VACCINATION(
        p_id_pet           => 4,
        p_vaccine_name     => 'Tríplice Felina',
        p_application_date => TO_DATE('2024-03-15', 'YYYY-MM-DD'),
        p_expiration_date  => TO_DATE('2025-03-15', 'YYYY-MM-DD'),
        p_lot              => 'LOT-F005'
    );
END;
/

-- Vacina do Pet 5 — Totó
BEGIN
    PROC_INSERT_VACCINATION(
        p_id_pet           => 5,
        p_vaccine_name     => 'V10',
        p_application_date => TO_DATE('2024-04-01', 'YYYY-MM-DD'),
        p_expiration_date  => TO_DATE('2025-04-01', 'YYYY-MM-DD'),
        p_lot              => 'LOT-A002'
    );
END;
/

-- --------------------------------------------------------
-- Erros esperados — PROC_INSERT_VACCINATION
-- --------------------------------------------------------

-- ERRO 1: ID_PET inexistente → e_fk_invalid
BEGIN
    PROC_INSERT_VACCINATION(
        p_id_pet           => 9999,       -- Pet não existe
        p_vaccine_name     => 'V10',
        p_application_date => TO_DATE('2024-05-01', 'YYYY-MM-DD'),
        p_expiration_date  => TO_DATE('2025-05-01', 'YYYY-MM-DD'),
        p_lot              => 'LOT-FAKE'
    );
END;
/

-- ERRO 2: Nome da vacina nulo → VALUE_ERROR
BEGIN
    PROC_INSERT_VACCINATION(
        p_id_pet           => 1,
        p_vaccine_name     => NULL,       -- Campo obrigatório
        p_application_date => TO_DATE('2024-06-01', 'YYYY-MM-DD'),
        p_expiration_date  => TO_DATE('2025-06-01', 'YYYY-MM-DD'),
        p_lot              => 'LOT-X000'
    );
END;
/

-- ERRO 3: Data de aplicação nula → VALUE_ERROR
BEGIN
    PROC_INSERT_VACCINATION(
        p_id_pet           => 2,
        p_vaccine_name     => 'Antirrábica',
        p_application_date => NULL,       -- Campo obrigatório
        p_expiration_date  => TO_DATE('2025-07-01', 'YYYY-MM-DD'),
        p_lot              => 'LOT-X001'
    );
END;
/

-- ERRO 4: Data de validade nula → VALUE_ERROR
BEGIN
    PROC_INSERT_VACCINATION(
        p_id_pet           => 3,
        p_vaccine_name     => 'Giárdia',
        p_application_date => TO_DATE('2024-08-01', 'YYYY-MM-DD'),
        p_expiration_date  => NULL,       -- Campo obrigatório
        p_lot              => 'LOT-X002'
    );
END;
/


-- ============================================================
-- 7. PROC_INSERT_CONSULTATION (FK → DB_MEDICAL_RECORD, DB_VETERINARIAN, DB_CLINIC)
--
-- IDs de referência esperados após as inserções acima:
--   Medical Record: 1=Bolt, 2=Mia, 3=Rex, 4=Nina, 5=Totó
--   Veterinarian:   1=Dr. Ricardo, 2=Dra. Fernanda, 3=Dr. Marcos
--   Clinic:         1=VetCenter SP, 2=Clinica Animal Rio, 3=PetSaude BH
--
-- MR 1 → 2 consultas | MR 2 → 1 consulta | MR 3 → 2 consultas
-- MR 4 → 1 consulta  | MR 5 → 1 consulta
-- ============================================================

-- Consultas do Medical Record 1 (Bolt)
BEGIN
    PROC_INSERT_CONSULTATION(
        p_id_medical_record => 1,
        p_id_veterinarian   => 1,
        p_id_clinic         => 1,
        p_consultation_date => TO_DATE('2024-02-10', 'YYYY-MM-DD'),
        p_symptoms          => 'Tosse persistente, apatia',
        p_diagnosis         => 'Bronquite leve',
        p_observations      => 'Prescrito antibiotico por 7 dias. Retorno em 2 semanas.',
        p_attachmet         => NULL
    );
END;
/

BEGIN
    PROC_INSERT_CONSULTATION(
        p_id_medical_record => 1,
        p_id_veterinarian   => 3,
        p_id_clinic         => 1,
        p_consultation_date => TO_DATE('2024-03-05', 'YYYY-MM-DD'),
        p_symptoms          => 'Coxeando membro traseiro direito',
        p_diagnosis         => 'Displasia incipiente',
        p_observations      => 'Indicado fisioterapia e suplemento de glucosamina.',
        p_attachmet         => NULL
    );
END;
/

-- Consulta do Medical Record 2 (Mia)
BEGIN
    PROC_INSERT_CONSULTATION(
        p_id_medical_record => 2,
        p_id_veterinarian   => 2,
        p_id_clinic         => 2,
        p_consultation_date => TO_DATE('2024-01-20', 'YYYY-MM-DD'),
        p_symptoms          => 'Perda de apetite, emagrecimento',
        p_diagnosis         => 'Agravamento da insuficiencia renal',
        p_observations      => 'Ajuste na dieta e medicacao. Exames de sangue mensais.',
        p_attachmet         => NULL
    );
END;
/

-- Consultas do Medical Record 3 (Rex)
BEGIN
    PROC_INSERT_CONSULTATION(
        p_id_medical_record => 3,
        p_id_veterinarian   => 1,
        p_id_clinic         => 3,
        p_consultation_date => TO_DATE('2024-03-18', 'YYYY-MM-DD'),
        p_symptoms          => 'Coceira intensa no abdomen',
        p_diagnosis         => 'Dermatite alergica',
        p_observations      => 'Evitar contato com gramineas. Antihistaminico prescrito.',
        p_attachmet         => NULL
    );
END;
/

BEGIN
    PROC_INSERT_CONSULTATION(
        p_id_medical_record => 3,
        p_id_veterinarian   => 3,
        p_id_clinic         => 3,
        p_consultation_date => TO_DATE('2024-04-22', 'YYYY-MM-DD'),
        p_symptoms          => 'Dificuldade para se levantar',
        p_diagnosis         => 'Progressao da displasia coxofemoral',
        p_observations      => 'Avaliacao cirurgica recomendada. Anti-inflamatorio prescrito.',
        p_attachmet         => NULL
    );
END;
/

-- Consulta do Medical Record 4 (Nina)
BEGIN
    PROC_INSERT_CONSULTATION(
        p_id_medical_record => 4,
        p_id_veterinarian   => 2,
        p_id_clinic         => 1,
        p_consultation_date => TO_DATE('2024-04-10', 'YYYY-MM-DD'),
        p_symptoms          => 'Queda de pelo excessiva',
        p_diagnosis         => 'Hipotireoidismo felino',
        p_observations      => 'Exames hormonais solicitados. Revisao em 30 dias.',
        p_attachmet         => NULL
    );
END;
/

-- Consulta do Medical Record 5 (Totó)
BEGIN
    PROC_INSERT_CONSULTATION(
        p_id_medical_record => 5,
        p_id_veterinarian   => 1,
        p_id_clinic         => 2,
        p_consultation_date => TO_DATE('2024-05-03', 'YYYY-MM-DD'),
        p_symptoms          => 'Vomito apos alimentacao',
        p_diagnosis         => 'Sensibilidade alimentar',
        p_observations      => 'Troca de racao para versao hipoalergenica.',
        p_attachmet         => NULL
    );
END;
/

-- --------------------------------------------------------
-- Erros esperados — PROC_INSERT_CONSULTATION
-- --------------------------------------------------------

-- ERRO 1: ID_MEDICAL_RECORD inexistente → e_fk_invalid
BEGIN
    PROC_INSERT_CONSULTATION(
        p_id_medical_record => 9999,      -- Prontuário não existe
        p_id_veterinarian   => 1,
        p_id_clinic         => 1,
        p_consultation_date => TO_DATE('2024-06-01', 'YYYY-MM-DD'),
        p_symptoms          => 'Febre',
        p_diagnosis         => NULL,
        p_observations      => NULL,
        p_attachmet         => NULL
    );
END;
/

-- ERRO 2: ID_VETERINARIAN inexistente → e_fk_invalid
BEGIN
    PROC_INSERT_CONSULTATION(
        p_id_medical_record => 1,
        p_id_veterinarian   => 9999,      -- Veterinário não existe
        p_id_clinic         => 1,
        p_consultation_date => TO_DATE('2024-06-05', 'YYYY-MM-DD'),
        p_symptoms          => 'Dor abdominal',
        p_diagnosis         => NULL,
        p_observations      => NULL,
        p_attachmet         => NULL
    );
END;
/

-- ERRO 3: ID_CLINIC inexistente → e_fk_invalid
BEGIN
    PROC_INSERT_CONSULTATION(
        p_id_medical_record => 2,
        p_id_veterinarian   => 1,
        p_id_clinic         => 9999,      -- Clínica não existe
        p_consultation_date => TO_DATE('2024-06-10', 'YYYY-MM-DD'),
        p_symptoms          => 'Tremores',
        p_diagnosis         => NULL,
        p_observations      => NULL,
        p_attachmet         => NULL
    );
END;
/

-- ERRO 4: Data de consulta nula → VALUE_ERROR
BEGIN
    PROC_INSERT_CONSULTATION(
        p_id_medical_record => 3,
        p_id_veterinarian   => 2,
        p_id_clinic         => 2,
        p_consultation_date => NULL,      -- Campo obrigatório
        p_symptoms          => 'Letargia',
        p_diagnosis         => NULL,
        p_observations      => NULL,
        p_attachmet         => NULL
    );
END;
/

-- ERRO 5: Todos os campos FK nulos → VALUE_ERROR
BEGIN
    PROC_INSERT_CONSULTATION(
        p_id_medical_record => NULL,      -- Campo obrigatório
        p_id_veterinarian   => NULL,      -- Campo obrigatório
        p_id_clinic         => NULL,      -- Campo obrigatório
        p_consultation_date => NULL,      -- Campo obrigatório
        p_symptoms          => NULL,
        p_diagnosis         => NULL,
        p_observations      => NULL,
        p_attachmet         => NULL
    );
END;
/