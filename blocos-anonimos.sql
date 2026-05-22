-- ============================================================
-- BLOCOS ANÔNIMOS
-- ============================================================

SET SERVEROUTPUT ON SIZE UNLIMITED;


-- ============================================================
-- BLOCO 1: RELATÓRIOS COM JOINS, GROUP BY E ORDER BY
--          Foco: Tutores, Pets e Clínicas
-- ============================================================
DECLARE

    -- ----------------------------------------------------------
    -- CURSOR 1: Tutores e seus Pets
    -- ----------------------------------------------------------
    CURSOR c_tutor_pet IS
    SELECT
        t.NAME                                               AS tutor_nome,
        t.PHONE                                              AS telefone,
        COUNT(p.ID)                                          AS qtd_pets,
        LISTAGG(p.NAME, ', ') WITHIN GROUP (ORDER BY p.NAME) AS pets_nomes
    FROM DB_TUTOR t
    JOIN DB_PET p ON p.ID_TUTOR = t.ID
    GROUP BY t.NAME, t.PHONE
    ORDER BY t.NAME;

    -- ----------------------------------------------------------
    -- CURSOR 2: Consultas realizadas por clínica e espécie de pet
    -- ----------------------------------------------------------
    CURSOR c_clinica_especie IS
        SELECT
            cl.NAME                     AS clinica_nome,
            p.SPECIES                   AS especie,
            COUNT(c.ID)                 AS qtd_consultas,
            MIN(c.CONSULTATION_DATE)    AS primeira_consulta,
            MAX(c.CONSULTATION_DATE)    AS ultima_consulta
        FROM DB_CONSULTATION c
        JOIN DB_CLINIC cl           ON cl.ID  = c.ID_CLINIC
        JOIN DB_MEDICAL_RECORD mr   ON mr.ID  = c.ID_MEDICAL_RECORD
        JOIN DB_PET p               ON p.ID   = mr.ID_PET
        GROUP BY cl.NAME, p.SPECIES
        ORDER BY cl.NAME, qtd_consultas DESC;

    -- ----------------------------------------------------------
    -- CURSOR 3: Vacinas aplicadas por tutor (via pet)
    -- ----------------------------------------------------------
    CURSOR c_vacinas_tutor IS
        SELECT
            t.NAME                          AS tutor_nome,
            COUNT(va.ID)                    AS qtd_vacinas,
            COUNT(DISTINCT va.VACCINE_NAME) AS tipos_distintos,
            MIN(va.APPLICATION_DATE)        AS primeira_vacina,
            MAX(va.APPLICATION_DATE)        AS ultima_vacina
        FROM DB_TUTOR t
        JOIN DB_PET p       ON p.ID_TUTOR = t.ID
        JOIN DB_VACCINATION va ON va.ID_PET = p.ID
        GROUP BY t.NAME
        ORDER BY qtd_vacinas DESC, t.NAME;

    -- Acumuladores
    v_tot_pets      NUMBER := 0;
    v_tot_peso      NUMBER := 0;
    v_tot_consul    NUMBER := 0;
    v_tot_vacinas   NUMBER := 0;

    r_tp    c_tutor_pet%ROWTYPE;
    r_ce    c_clinica_especie%ROWTYPE;
    r_vt    c_vacinas_tutor%ROWTYPE;

BEGIN
    -- ==========================================================
    -- RELATÓRIO 1-A: TUTORES E SEUS PETS
    -- ==========================================================
    DBMS_OUTPUT.PUT_LINE('=============================================================');
    DBMS_OUTPUT.PUT_LINE('  BLOCO 1 – REL. 1: TUTORES E SEUS PETS                      ');
    DBMS_OUTPUT.PUT_LINE('=============================================================');
    DBMS_OUTPUT.PUT_LINE(
        RPAD('TUTOR', 20)         ||
        RPAD('TELEFONE', 18)      ||
        LPAD('QTD PETS', 10)      ||
        LPAD('PETS', 20)
    );
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 74, '-'));

    OPEN c_tutor_pet;
    LOOP
        FETCH c_tutor_pet INTO r_tp;
        EXIT WHEN c_tutor_pet%NOTFOUND;

        v_tot_pets := v_tot_pets + r_tp.qtd_pets;

        DBMS_OUTPUT.PUT_LINE(
            RPAD(r_tp.tutor_nome, 20)  ||
            RPAD(r_tp.telefone, 18)    ||
            LPAD(r_tp.qtd_pets, 10)    ||
            LPAD(r_tp.pets_nomes, 13)  
    );
    END LOOP;
    CLOSE c_tutor_pet;

    DBMS_OUTPUT.PUT_LINE(RPAD('-', 74, '-'));
    DBMS_OUTPUT.PUT_LINE(
        RPAD('TOTAL GERAL', 38)            ||
        LPAD(v_tot_pets, 10)               ||
        LPAD(' ', 13)                      
    );
    DBMS_OUTPUT.PUT_LINE('');

    -- ==========================================================
    -- RELATÓRIO 1-B: CONSULTAS POR CLÍNICA E ESPÉCIE
    -- ==========================================================
    DBMS_OUTPUT.PUT_LINE('=============================================================');
    DBMS_OUTPUT.PUT_LINE('  BLOCO 1 – REL. 2: CONSULTAS POR CLÍNICA E ESPÉCIE          ');
    DBMS_OUTPUT.PUT_LINE('=============================================================');
    DBMS_OUTPUT.PUT_LINE(
        RPAD('CLÍNICA', 24)           ||
        RPAD('ESPÉCIE', 14)           ||
        LPAD('CONSULTAS', 11)         ||
        RPAD('  PRIMEIRA', 14)        ||
        RPAD('  ÚLTIMA', 14)
    );
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 77, '-'));

    OPEN c_clinica_especie;
    LOOP
        FETCH c_clinica_especie INTO r_ce;
        EXIT WHEN c_clinica_especie%NOTFOUND;

        v_tot_consul := v_tot_consul + r_ce.qtd_consultas;

        DBMS_OUTPUT.PUT_LINE(
            RPAD(r_ce.clinica_nome, 24)                                     ||
            RPAD(r_ce.especie, 14)                                          ||
            LPAD(r_ce.qtd_consultas, 11)                                    ||
            RPAD('  ' || TO_CHAR(r_ce.primeira_consulta, 'DD/MM/YYYY'), 14) ||
            RPAD('  ' || TO_CHAR(r_ce.ultima_consulta,   'DD/MM/YYYY'), 14)
        );
    END LOOP;
    CLOSE c_clinica_especie;

    DBMS_OUTPUT.PUT_LINE(RPAD('-', 77, '-'));
    DBMS_OUTPUT.PUT_LINE(RPAD('TOTAL DE CONSULTAS:', 38) || LPAD(v_tot_consul, 11));
    DBMS_OUTPUT.PUT_LINE('');

    -- ==========================================================
    -- RELATÓRIO 1-C: VACINAÇÕES POR TUTOR
    -- ==========================================================
    DBMS_OUTPUT.PUT_LINE('=============================================================');
    DBMS_OUTPUT.PUT_LINE('  BLOCO 1 – REL. 3: VACINAÇÕES POR TUTOR                     ');
    DBMS_OUTPUT.PUT_LINE('=============================================================');
    DBMS_OUTPUT.PUT_LINE(
        RPAD('TUTOR', 20)             ||
        LPAD('QTD VAC.', 10)          ||
        LPAD('TIPOS', 8)              ||
        RPAD('  PRIMEIRA', 14)        ||
        RPAD('  ÚLTIMA', 14)
    );
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 66, '-'));

    OPEN c_vacinas_tutor;
    LOOP
        FETCH c_vacinas_tutor INTO r_vt;
        EXIT WHEN c_vacinas_tutor%NOTFOUND;

        v_tot_vacinas := v_tot_vacinas + r_vt.qtd_vacinas;

        DBMS_OUTPUT.PUT_LINE(
            RPAD(r_vt.tutor_nome, 20)                                       ||
            LPAD(r_vt.qtd_vacinas, 10)                                      ||
            LPAD(r_vt.tipos_distintos, 8)                                   ||
            RPAD('  ' || TO_CHAR(r_vt.primeira_vacina, 'DD/MM/YYYY'), 14)   ||
            RPAD('  ' || TO_CHAR(r_vt.ultima_vacina,   'DD/MM/YYYY'), 14)
        );
    END LOOP;
    CLOSE c_vacinas_tutor;

    DBMS_OUTPUT.PUT_LINE(RPAD('-', 66, '-'));
    DBMS_OUTPUT.PUT_LINE(RPAD('TOTAL DE VACINAÇÕES:', 30) || LPAD(v_tot_vacinas, 10));

EXCEPTION
    WHEN OTHERS THEN
        IF c_tutor_pet%ISOPEN      THEN CLOSE c_tutor_pet;      END IF;
        IF c_clinica_especie%ISOPEN THEN CLOSE c_clinica_especie; END IF;
        IF c_vacinas_tutor%ISOPEN  THEN CLOSE c_vacinas_tutor;  END IF;
        DBMS_OUTPUT.PUT_LINE('ERRO NO BLOCO 1: ' || SQLERRM);
END;
/


-- ============================================================
-- BLOCO 2: RELATÓRIOS COM JOINS, GROUP BY E ORDER BY
--          Foco: Veterinários, Prontuários e Vacinações por espécie
-- ============================================================
DECLARE

    -- ----------------------------------------------------------
    -- CURSOR 1: Consultas por veterinário e clínica
    -- ----------------------------------------------------------
    CURSOR c_vet_clinica IS
        SELECT
            v.NAME                      AS vet_nome,
            v.SPECIALTY                 AS especialidade,
            cl.NAME                     AS clinica_nome,
            COUNT(c.ID)                 AS qtd_consultas,
            MIN(c.CONSULTATION_DATE)    AS primeira_data,
            MAX(c.CONSULTATION_DATE)    AS ultima_data
        FROM DB_CONSULTATION c
        JOIN DB_VETERINARIAN v  ON v.ID  = c.ID_VETERINARIAN
        JOIN DB_CLINIC cl       ON cl.ID = c.ID_CLINIC
        GROUP BY v.NAME, v.SPECIALTY, cl.NAME
        ORDER BY qtd_consultas DESC, v.NAME;

    -- ----------------------------------------------------------
    -- CURSOR 2: Prontuários com tutor do pet (visão clínica geral)
    -- ----------------------------------------------------------
    CURSOR c_prontuario_tutor IS
        SELECT
            t.NAME                      AS tutor_nome,
            p.SPECIES                   AS especie,
            COUNT(mr.ID)                AS qtd_prontuarios,
            SUM(CASE WHEN mr.IS_CASTRATED = 'S' THEN 1 ELSE 0 END) AS castrados,
            SUM(CASE WHEN mr.ALLERGIES IS NOT NULL THEN 1 ELSE 0 END) AS com_alergia
        FROM DB_MEDICAL_RECORD mr
        JOIN DB_PET p    ON p.ID  = mr.ID_PET
        JOIN DB_TUTOR t  ON t.ID  = p.ID_TUTOR
        GROUP BY t.NAME, p.SPECIES
        ORDER BY t.NAME, p.SPECIES;

    -- ----------------------------------------------------------
    -- CURSOR 3: Vacinações agrupadas por espécie de pet
    -- ----------------------------------------------------------
    CURSOR c_vacina_especie IS
        SELECT
            p.SPECIES                       AS especie,
            COUNT(va.ID)                    AS qtd_vacinas,
            COUNT(DISTINCT va.VACCINE_NAME) AS tipos_vacinas,
            ROUND(AVG(va.EXPIRATION_DATE - va.APPLICATION_DATE), 0) AS media_duracao_dias,
            MIN(va.APPLICATION_DATE)        AS primeira_aplicacao,
            MAX(va.APPLICATION_DATE)        AS ultima_aplicacao
        FROM DB_VACCINATION va
        JOIN DB_PET p ON p.ID = va.ID_PET
        GROUP BY p.SPECIES
        ORDER BY qtd_vacinas DESC;

    -- Acumuladores
    v_tot_consultas     NUMBER := 0;
    v_tot_prontuarios   NUMBER := 0;
    v_tot_vacinas       NUMBER := 0;

    r_vc    c_vet_clinica%ROWTYPE;
    r_pt    c_prontuario_tutor%ROWTYPE;
    r_ve    c_vacina_especie%ROWTYPE;

BEGIN
    -- ==========================================================
    -- RELATÓRIO 2-A: CONSULTAS POR VETERINÁRIO E CLÍNICA
    -- ==========================================================
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=============================================================');
    DBMS_OUTPUT.PUT_LINE('  BLOCO 2 – REL. 1: CONSULTAS POR VETERINÁRIO E CLÍNICA      ');
    DBMS_OUTPUT.PUT_LINE('=============================================================');
    DBMS_OUTPUT.PUT_LINE(
        RPAD('VETERINÁRIO', 22)    ||
        RPAD('ESPECIALIDADE', 16) ||
        RPAD('CLÍNICA', 22)       ||
        LPAD('QTDE', 7)           ||
        RPAD('  PRIMEIRA', 14)    ||
        RPAD('  ÚLTIMA', 14)
    );
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 95, '-'));

    OPEN c_vet_clinica;
    LOOP
        FETCH c_vet_clinica INTO r_vc;
        EXIT WHEN c_vet_clinica%NOTFOUND;

        v_tot_consultas := v_tot_consultas + r_vc.qtd_consultas;

        DBMS_OUTPUT.PUT_LINE(
            RPAD(r_vc.vet_nome, 22)                                         ||
            RPAD(r_vc.especialidade, 16)                                    ||
            RPAD(r_vc.clinica_nome, 22)                                     ||
            LPAD(r_vc.qtd_consultas, 7)                                     ||
            RPAD('  ' || TO_CHAR(r_vc.primeira_data, 'DD/MM/YYYY'), 14)    ||
            RPAD('  ' || TO_CHAR(r_vc.ultima_data,   'DD/MM/YYYY'), 14)
        );
    END LOOP;
    CLOSE c_vet_clinica;

    DBMS_OUTPUT.PUT_LINE(RPAD('-', 95, '-'));
    DBMS_OUTPUT.PUT_LINE(RPAD('TOTAL DE CONSULTAS:', 61) || LPAD(v_tot_consultas, 7));
    DBMS_OUTPUT.PUT_LINE('');

    -- ==========================================================
    -- RELATÓRIO 2-B: PRONTUÁRIOS AGRUPADOS POR TUTOR E ESPÉCIE
    -- ==========================================================
    DBMS_OUTPUT.PUT_LINE('=============================================================');
    DBMS_OUTPUT.PUT_LINE('  BLOCO 2 – REL. 2: PRONTUÁRIOS POR TUTOR E ESPÉCIE          ');
    DBMS_OUTPUT.PUT_LINE('=============================================================');
    DBMS_OUTPUT.PUT_LINE(
        RPAD('TUTOR', 20)          ||
        RPAD('ESPÉCIE', 14)        ||
        LPAD('PRONTUÁRIOS', 13)    ||
        LPAD('CASTRADOS', 11)      ||
        LPAD('C/ALERGIA', 11)
    );
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 69, '-'));

    OPEN c_prontuario_tutor;
    LOOP
        FETCH c_prontuario_tutor INTO r_pt;
        EXIT WHEN c_prontuario_tutor%NOTFOUND;

        v_tot_prontuarios := v_tot_prontuarios + r_pt.qtd_prontuarios;

        DBMS_OUTPUT.PUT_LINE(
            RPAD(r_pt.tutor_nome, 20)       ||
            RPAD(r_pt.especie, 14)          ||
            LPAD(r_pt.qtd_prontuarios, 13)  ||
            LPAD(r_pt.castrados, 11)        ||
            LPAD(r_pt.com_alergia, 11)
        );
    END LOOP;
    CLOSE c_prontuario_tutor;

    DBMS_OUTPUT.PUT_LINE(RPAD('-', 69, '-'));
    DBMS_OUTPUT.PUT_LINE(RPAD('TOTAL DE PRONTUÁRIOS:', 34) || LPAD(v_tot_prontuarios, 13));
    DBMS_OUTPUT.PUT_LINE('');

    -- ==========================================================
    -- RELATÓRIO 2-C: VACINAÇÕES AGRUPADAS POR ESPÉCIE
    -- ==========================================================
    DBMS_OUTPUT.PUT_LINE('=============================================================');
    DBMS_OUTPUT.PUT_LINE('  BLOCO 2 – REL. 3: VACINAÇÕES AGRUPADAS POR ESPÉCIE         ');
    DBMS_OUTPUT.PUT_LINE('=============================================================');
    DBMS_OUTPUT.PUT_LINE(
        RPAD('ESPÉCIE', 14)         ||
        LPAD('VACINAS', 9)          ||
        LPAD('TIPOS', 7)            ||
        LPAD('MÉD.DIAS', 10)        ||
        RPAD('  PRIMEIRA', 14)      ||
        RPAD('  ÚLTIMA', 14)
    );
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 68, '-'));

    OPEN c_vacina_especie;
    LOOP
        FETCH c_vacina_especie INTO r_ve;
        EXIT WHEN c_vacina_especie%NOTFOUND;

        v_tot_vacinas := v_tot_vacinas + r_ve.qtd_vacinas;

        DBMS_OUTPUT.PUT_LINE(
            RPAD(r_ve.especie, 14)                                              ||
            LPAD(r_ve.qtd_vacinas, 9)                                           ||
            LPAD(r_ve.tipos_vacinas, 7)                                         ||
            LPAD(r_ve.media_duracao_dias, 10)                                   ||
            RPAD('  ' || TO_CHAR(r_ve.primeira_aplicacao, 'DD/MM/YYYY'), 14)   ||
            RPAD('  ' || TO_CHAR(r_ve.ultima_aplicacao,   'DD/MM/YYYY'), 14)
        );
    END LOOP;
    CLOSE c_vacina_especie;

    DBMS_OUTPUT.PUT_LINE(RPAD('-', 68, '-'));
    DBMS_OUTPUT.PUT_LINE(RPAD('TOTAL DE VACINAÇÕES:', 23) || LPAD(v_tot_vacinas, 9));

EXCEPTION
    WHEN OTHERS THEN
        IF c_vet_clinica%ISOPEN       THEN CLOSE c_vet_clinica;       END IF;
        IF c_prontuario_tutor%ISOPEN  THEN CLOSE c_prontuario_tutor;  END IF;
        IF c_vacina_especie%ISOPEN    THEN CLOSE c_vacina_especie;    END IF;
        DBMS_OUTPUT.PUT_LINE('ERRO NO BLOCO 2: ' || SQLERRM);
END;
/


-- ============================================================
-- BLOCO 3: LINHA ANTERIOR / ATUAL / PRÓXIMA (LAG / LEAD)
-- Tabela: DB_VACCINATION — coluna analisada: ID_PET
-- Mostra o ID_PET da vacinação anterior, atual e próxima.
-- ============================================================
DECLARE
    CURSOR c_janela IS
        SELECT
            ID                                          AS id_vac,
            VACCINE_NAME                                AS vacina,
            ID_PET                                      AS atual,
            LAG(ID_PET)  OVER (ORDER BY ID)             AS anterior,
            LEAD(ID_PET) OVER (ORDER BY ID)             AS proximo
        FROM DB_VACCINATION
        ORDER BY ID;

    r_j     c_janela%ROWTYPE;
    v_ant   VARCHAR2(10);
    v_prox  VARCHAR2(10);

BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=============================================================');
    DBMS_OUTPUT.PUT_LINE('  BLOCO 3 – VACINAÇÕES: ID_PET ANTERIOR / ATUAL / PRÓXIMO    ');
    DBMS_OUTPUT.PUT_LINE('=============================================================');
    DBMS_OUTPUT.PUT_LINE(
        LPAD('ID_VAC', 8) || '  ' ||
        RPAD('VACINA', 20)        ||
        LPAD('ANTERIOR', 10)      ||
        LPAD('ATUAL', 8)          ||
        LPAD('PRÓXIMO', 10)
    );
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 60, '-'));

    OPEN c_janela;
    LOOP
        FETCH c_janela INTO r_j;
        EXIT WHEN c_janela%NOTFOUND;

        IF r_j.anterior IS NULL THEN
            v_ant := 'Vazio';
        ELSE
            v_ant := TO_CHAR(r_j.anterior);
        END IF;

        IF r_j.proximo IS NULL THEN
            v_prox := 'Vazio';
        ELSE
            v_prox := TO_CHAR(r_j.proximo);
        END IF;

        DBMS_OUTPUT.PUT_LINE(
            LPAD(r_j.id_vac, 8)   || '  ' ||
            RPAD(r_j.vacina, 20)  ||
            LPAD(v_ant, 10)       ||
            LPAD(r_j.atual, 8)    ||
            LPAD(v_prox, 10)
        );
    END LOOP;
    CLOSE c_janela;

EXCEPTION
    WHEN OTHERS THEN
        IF c_janela%ISOPEN THEN CLOSE c_janela; END IF;
        DBMS_OUTPUT.PUT_LINE('ERRO NO BLOCO 3: ' || SQLERRM);
END;
/


-- ============================================================
-- BLOCO 4: RELATÓRIO COMPLETO DE DB_VACCINATION
-- Estrutura do relatório (espelho da imagem de referência):
--   • Lista todos os registros da tabela
--   • Exibe os dados numéricos (ID_PET) de cada linha
--   • Ao trocar de ID_PET, imprime "Sub-Total" com soma/contagem
--   • Ao final imprime "Total Geral"
--
-- Critério de agrupamento: ID_PET
-- Tomada de decisão: classifica validade da vacina
-- ============================================================
DECLARE
    -- Cursor principal: todos os registros de DB_VACCINATION
    -- ordenados por ID_PET (critério de agrupamento) e depois por ID
    CURSOR c_vac IS
        SELECT
            ID,
            ID_PET,
            VACCINE_NAME,
            APPLICATION_DATE,
            EXPIRATION_DATE,
            LOT
        FROM DB_VACCINATION
        ORDER BY ID_PET, ID;

    r_vac           c_vac%ROWTYPE;

    -- Controle de grupo (agrupamento por ID_PET)
    v_pet_atual     DB_VACCINATION.ID_PET%TYPE := NULL;

    -- Acumuladores de sub-total (por ID_PET)
    v_sub_qtd       NUMBER := 0;
    v_sub_soma_id   NUMBER := 0;   -- soma numérica dos IDs das vacinas do grupo

    -- Acumuladores de total geral
    v_tot_qtd       NUMBER := 0;
    v_tot_soma_id   NUMBER := 0;

    -- Tomada de decisão: situação da vacina
    v_situacao      VARCHAR2(12);

    -- Separador de coluna (largura total = 70)
    c_sep           CONSTANT VARCHAR2(2) := '  ';
    c_linha         CONSTANT VARCHAR2(72) := RPAD('-', 70, '-');

    -- Procedure local para imprimir linha de sub-total
    PROCEDURE print_subtotal(p_id_pet IN NUMBER,
                             p_qtd    IN NUMBER,
                             p_soma   IN NUMBER) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE(
            RPAD('Sub-Total  (ID_PET=' || p_id_pet || ')', 38) ||
            LPAD(p_qtd,  8)  || c_sep ||
            LPAD(p_soma, 10)
        );
        DBMS_OUTPUT.PUT_LINE(c_linha);
    END;

BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('======================================================================');
    DBMS_OUTPUT.PUT_LINE('   BLOCO 4 – RELATÓRIO COMPLETO: TABELA DB_VACCINATION               ');
    DBMS_OUTPUT.PUT_LINE('   Agrupamento: ID_PET  |  Dados numéricos: ID e ID_PET              ');
    DBMS_OUTPUT.PUT_LINE('======================================================================');
    DBMS_OUTPUT.PUT_LINE(
        LPAD('ID', 5)                 || c_sep ||
        LPAD('ID_PET', 7)            || c_sep ||
        RPAD('VACINA', 16)           || c_sep ||
        RPAD('APLICAÇÃO', 12)        || c_sep ||
        RPAD('VALIDADE', 12)         || c_sep ||
        RPAD('SITUAÇÃO', 12)
    );
    DBMS_OUTPUT.PUT_LINE(c_linha);

    OPEN c_vac;
    LOOP
        FETCH c_vac INTO r_vac;
        EXIT WHEN c_vac%NOTFOUND;

        -- ── Quebra de grupo: imprime sub-total do grupo anterior ──
        IF v_pet_atual IS NOT NULL AND v_pet_atual <> r_vac.ID_PET THEN
            print_subtotal(v_pet_atual, v_sub_qtd, v_sub_soma_id);
            v_sub_qtd     := 0;
            v_sub_soma_id := 0;
        END IF;

        v_pet_atual   := r_vac.ID_PET;

        -- Acumula sub-total e total geral
        v_sub_qtd     := v_sub_qtd     + 1;
        v_sub_soma_id := v_sub_soma_id + r_vac.ID;   -- dado numérico: ID da vacina
        v_tot_qtd     := v_tot_qtd     + 1;
        v_tot_soma_id := v_tot_soma_id + r_vac.ID;

        -- Tomada de decisão: classifica situação da vacina
        IF r_vac.EXPIRATION_DATE < TRUNC(SYSDATE) THEN
            v_situacao := 'VENCIDA';
        ELSIF r_vac.EXPIRATION_DATE <= TRUNC(SYSDATE) + 30 THEN
            v_situacao := 'A VENCER';
        ELSE
            v_situacao := 'Válida';
        END IF;

        DBMS_OUTPUT.PUT_LINE(
            LPAD(r_vac.ID, 5)                                           || c_sep ||
            LPAD(r_vac.ID_PET, 7)                                       || c_sep ||
            RPAD(r_vac.VACCINE_NAME, 16)                                || c_sep ||
            RPAD(TO_CHAR(r_vac.APPLICATION_DATE, 'DD/MM/YYYY'), 12)    || c_sep ||
            RPAD(TO_CHAR(r_vac.EXPIRATION_DATE,  'DD/MM/YYYY'), 12)    || c_sep ||
            RPAD(v_situacao, 12)
        );
    END LOOP;

    -- Sub-total do último grupo
    IF v_pet_atual IS NOT NULL THEN
        print_subtotal(v_pet_atual, v_sub_qtd, v_sub_soma_id);
    END IF;

    CLOSE c_vac;

    -- ── Total Geral ──
    DBMS_OUTPUT.PUT_LINE(
        RPAD('Total Geral', 38)   ||
        LPAD(v_tot_qtd,   8)      || c_sep ||
        LPAD(v_tot_soma_id, 10)
    );
    DBMS_OUTPUT.PUT_LINE(RPAD('=', 70, '='));
    DBMS_OUTPUT.PUT_LINE('  Colunas numéricas: QTD = quantidade de vacinas no grupo');
    DBMS_OUTPUT.PUT_LINE('                     SOMA ID = soma dos IDs das vacinas do grupo');

EXCEPTION
    WHEN OTHERS THEN
        IF c_vac%ISOPEN THEN CLOSE c_vac; END IF;
        DBMS_OUTPUT.PUT_LINE('ERRO NO BLOCO 4: ' || SQLERRM);
END;
/


-- ============================================================
-- BLOCO 5: RELATÓRIO DE PRONTUÁRIOS E CONSULTAS
-- Lista todos os prontuários com status de castração,
-- quantidade de consultas e classificação de risco clínico.
-- Cursor explícito + tomada de decisão
-- ============================================================
DECLARE
    CURSOR c_prontuarios IS
        SELECT
            mr.ID                                       AS id_mr,
            p.NAME                                      AS pet_nome,
            p.SPECIES                                   AS especie,
            mr.BLOOD_TYPE                               AS tipo_sang,
            mr.IS_CASTRATED                             AS castrado,
            NVL(mr.ALLERGIES, 'Nenhuma')               AS alergias,
            NVL(mr.CHRONIC_DISEASES, 'Nenhuma')        AS doencas,
            COUNT(c.ID)                                 AS qtd_consultas,
            MAX(c.CONSULTATION_DATE)                    AS ultima_consulta
        FROM DB_MEDICAL_RECORD mr
        JOIN DB_PET p ON p.ID = mr.ID_PET
        LEFT JOIN DB_CONSULTATION c ON c.ID_MEDICAL_RECORD = mr.ID
        GROUP BY
            mr.ID, p.NAME, p.SPECIES,
            mr.BLOOD_TYPE, mr.IS_CASTRATED,
            mr.ALLERGIES, mr.CHRONIC_DISEASES
        ORDER BY p.SPECIES, p.NAME;

    r_mr            c_prontuarios%ROWTYPE;
    v_status_cast   VARCHAR2(5);
    v_risco         VARCHAR2(8);
    v_tot_consul    NUMBER := 0;
    v_tot_pronts    NUMBER := 0;
    v_castrados     NUMBER := 0;
    v_risco_medio   NUMBER := 0;
    v_risco_alto    NUMBER := 0;

BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=============================================================');
    DBMS_OUTPUT.PUT_LINE('       BLOCO 5 – PRONTUÁRIOS E HISTÓRICO DE CONSULTAS        ');
    DBMS_OUTPUT.PUT_LINE('=============================================================');
    DBMS_OUTPUT.PUT_LINE(
        RPAD('PET', 10)                   ||
        RPAD('ESPÉCIE', 12)               ||
        RPAD('SANGUE', 8)                 ||
        RPAD('CAST.', 7)                  ||
        LPAD('CONSUL.', 9)                ||
        RPAD('  ÚLTIMA CONSULTA', 20)     ||
        RPAD('RISCO', 8)
    );
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 74, '-'));

    OPEN c_prontuarios;
    LOOP
        FETCH c_prontuarios INTO r_mr;
        EXIT WHEN c_prontuarios%NOTFOUND;

        -- Tomada de decisão 1: castração
        IF r_mr.castrado = 'S' THEN
            v_status_cast := 'Sim';
            v_castrados   := v_castrados + 1;
        ELSE
            v_status_cast := 'Não';
        END IF;

        -- Tomada de decisão 2: nível de risco clínico
        IF r_mr.alergias <> 'Nenhuma' AND r_mr.doencas <> 'Nenhuma' THEN
            v_risco      := 'ALTO';
            v_risco_alto := v_risco_alto + 1;
        ELSIF r_mr.alergias <> 'Nenhuma' OR r_mr.doencas <> 'Nenhuma' THEN
            v_risco       := 'MÉDIO';
            v_risco_medio := v_risco_medio + 1;
        ELSE
            v_risco := 'BAIXO';
        END IF;

        v_tot_pronts := v_tot_pronts + 1;
        v_tot_consul := v_tot_consul + r_mr.qtd_consultas;

        DBMS_OUTPUT.PUT_LINE(
            RPAD(r_mr.pet_nome, 10)     ||
            RPAD(r_mr.especie, 12)      ||
            RPAD(r_mr.tipo_sang, 8)     ||
            RPAD(v_status_cast, 7)      ||
            LPAD(r_mr.qtd_consultas, 9) ||
            RPAD('  ' || NVL(TO_CHAR(r_mr.ultima_consulta, 'DD/MM/YYYY'), 'Nenhuma'), 20) ||
            RPAD(v_risco, 8)
        );
    END LOOP;
    CLOSE c_prontuarios;

    DBMS_OUTPUT.PUT_LINE(RPAD('=', 74, '='));
    DBMS_OUTPUT.PUT_LINE('TOTAL DE PRONTUÁRIOS : ' || v_tot_pronts);
    DBMS_OUTPUT.PUT_LINE('TOTAL DE CONSULTAS   : ' || v_tot_consul);
    DBMS_OUTPUT.PUT_LINE('PETS CASTRADOS       : ' || v_castrados);
    DBMS_OUTPUT.PUT_LINE('RISCO MÉDIO          : ' || v_risco_medio);
    DBMS_OUTPUT.PUT_LINE('RISCO ALTO           : ' || v_risco_alto);

EXCEPTION
    WHEN OTHERS THEN
        IF c_prontuarios%ISOPEN THEN CLOSE c_prontuarios; END IF;
        DBMS_OUTPUT.PUT_LINE('ERRO NO BLOCO 5: ' || SQLERRM);
END;
/


-- ============================================================
-- BLOCO 6: RELATÓRIO DO LOG DE ERROS
-- Lista todos os erros, classifica por severidade e exibe
-- resumo agrupado por procedure.
-- Cursor explícito + tomada de decisão
-- ============================================================
DECLARE
    CURSOR c_logs IS
        SELECT
            ID,
            PROC_NAME,
            ERROR_DATE,
            ERROR_CODE,
            SUBSTR(ERROR_MSG, 1, 55) AS MSG_RESUMIDA
        FROM DB_LOG_ERRORS
        ORDER BY ERROR_DATE DESC;

    CURSOR c_resumo_log IS
        SELECT
            PROC_NAME,
            COUNT(*)        AS qtd_erros,
            MIN(ERROR_DATE) AS primeiro_erro,
            MAX(ERROR_DATE) AS ultimo_erro
        FROM DB_LOG_ERRORS
        GROUP BY PROC_NAME
        ORDER BY qtd_erros DESC;

    r_log       c_logs%ROWTYPE;
    r_res       c_resumo_log%ROWTYPE;
    v_total     NUMBER := 0;
    v_criticos  NUMBER := 0;
    v_rotulo    VARCHAR2(15);

BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=============================================================');
    DBMS_OUTPUT.PUT_LINE('         BLOCO 6 – RELATÓRIO DO LOG DE ERROS                 ');
    DBMS_OUTPUT.PUT_LINE('=============================================================');
    DBMS_OUTPUT.PUT_LINE(
        LPAD('ID', 5)            || '  ' ||
        RPAD('PROCEDURE', 28)    ||
        LPAD('COD', 8)           || '  ' ||
        RPAD('SEVERIDADE', 13)   ||
        RPAD('MENSAGEM (resumo)', 40)
    );
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 96, '-'));

    OPEN c_logs;
    LOOP
        FETCH c_logs INTO r_log;
        EXIT WHEN c_logs%NOTFOUND;

        -- Tomada de decisão: classifica severidade pelo código de erro
        IF r_log.ERROR_CODE = -1 THEN
            v_rotulo := 'DUPLICIDADE';
        ELSIF r_log.ERROR_CODE = -20001 THEN
            v_rotulo    := 'FK INVÁLIDA';
            v_criticos  := v_criticos + 1;
        ELSIF r_log.ERROR_CODE = -6502 THEN
            v_rotulo := 'VALOR NULO';
        ELSE
            v_rotulo := 'OUTRO';
        END IF;

        v_total := v_total + 1;

        DBMS_OUTPUT.PUT_LINE(
            LPAD(r_log.ID, 5)           || '  ' ||
            RPAD(r_log.PROC_NAME, 28)   ||
            LPAD(r_log.ERROR_CODE, 8)   || '  ' ||
            RPAD(v_rotulo, 13)          ||
            RPAD(r_log.MSG_RESUMIDA, 40)
        );
    END LOOP;
    CLOSE c_logs;

    DBMS_OUTPUT.PUT_LINE(RPAD('=', 96, '='));
    DBMS_OUTPUT.PUT_LINE('TOTAL DE ERROS REGISTRADOS : ' || v_total);
    DBMS_OUTPUT.PUT_LINE('ERROS DE FK INVÁLIDA       : ' || v_criticos);
    DBMS_OUTPUT.PUT_LINE('');

    -- Resumo agrupado por procedure
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('  ERROS AGRUPADOS POR PROCEDURE');
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE(
        RPAD('PROCEDURE', 30)         ||
        LPAD('QTD ERROS', 11)         ||
        RPAD('  PRIMEIRO ERRO', 24)   ||
        RPAD('  ÚLTIMO ERRO', 24)
    );
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 89, '-'));

    OPEN c_resumo_log;
    LOOP
        FETCH c_resumo_log INTO r_res;
        EXIT WHEN c_resumo_log%NOTFOUND;

        -- Tomada de decisão: alerta para procedures com 3+ erros
        IF r_res.qtd_erros >= 3 THEN
            DBMS_OUTPUT.PUT_LINE('! ' ||
                RPAD(r_res.PROC_NAME, 28)                                               ||
                LPAD(r_res.qtd_erros, 11)                                               ||
                RPAD('  ' || TO_CHAR(r_res.primeiro_erro, 'DD/MM/YYYY HH24:MI'), 24)   ||
                RPAD('  ' || TO_CHAR(r_res.ultimo_erro,   'DD/MM/YYYY HH24:MI'), 24)
            );
        ELSE
            DBMS_OUTPUT.PUT_LINE('  ' ||
                RPAD(r_res.PROC_NAME, 28)                                               ||
                LPAD(r_res.qtd_erros, 11)                                               ||
                RPAD('  ' || TO_CHAR(r_res.primeiro_erro, 'DD/MM/YYYY HH24:MI'), 24)   ||
                RPAD('  ' || TO_CHAR(r_res.ultimo_erro,   'DD/MM/YYYY HH24:MI'), 24)
            );
        END IF;
    END LOOP;
    CLOSE c_resumo_log;

    DBMS_OUTPUT.PUT_LINE('  (! = procedure com 3 ou mais erros registrados)');

EXCEPTION
    WHEN OTHERS THEN
        IF c_logs%ISOPEN       THEN CLOSE c_logs;       END IF;
        IF c_resumo_log%ISOPEN THEN CLOSE c_resumo_log; END IF;
        DBMS_OUTPUT.PUT_LINE('ERRO NO BLOCO 6: ' || SQLERRM);
END;
/


-- ============================================================
-- BLOCO 7: CARTEIRA DE VACINAÇÃO E SITUAÇÃO DA VALIDADE
-- Lista todas as vacinações classificando cada uma como
-- Válida, A Vencer (<=30 dias) ou Vencida com base em SYSDATE.
-- Cursor explícito + tomada de decisão
-- ============================================================
DECLARE
    CURSOR c_vacinas IS
        SELECT
            va.ID                                               AS id_vac,
            p.NAME                                              AS pet_nome,
            p.SPECIES                                           AS especie,
            va.VACCINE_NAME                                     AS vacina,
            va.APPLICATION_DATE                                 AS dt_aplicacao,
            va.EXPIRATION_DATE                                  AS dt_validade,
            va.LOT                                              AS lote,
            (va.EXPIRATION_DATE - TRUNC(SYSDATE))               AS dias_restantes
        FROM DB_VACCINATION va
        JOIN DB_PET p ON p.ID = va.ID_PET
        ORDER BY va.EXPIRATION_DATE;

    r_vac       c_vacinas%ROWTYPE;
    v_status    VARCHAR2(18);
    v_total     NUMBER := 0;
    v_validas   NUMBER := 0;
    v_vencer    NUMBER := 0;
    v_vencidas  NUMBER := 0;

BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=============================================================');
    DBMS_OUTPUT.PUT_LINE('      BLOCO 7 – CARTEIRA DE VACINAÇÃO E SITUAÇÃO             ');
    DBMS_OUTPUT.PUT_LINE('=============================================================');
    DBMS_OUTPUT.PUT_LINE(
        RPAD('PET', 10)           ||
        RPAD('ESPÉCIE', 12)       ||
        RPAD('VACINA', 16)        ||
        RPAD('APLICAÇÃO', 12)     ||
        RPAD('VALIDADE', 12)      ||
        RPAD('SITUAÇÃO', 16)      ||
        LPAD('DIAS', 6)
    );
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 84, '-'));

    OPEN c_vacinas;
    LOOP
        FETCH c_vacinas INTO r_vac;
        EXIT WHEN c_vacinas%NOTFOUND;

        -- Tomada de decisão: situação da vacina em relação à data atual
        IF r_vac.dias_restantes < 0 THEN
            v_status   := '*** VENCIDA ***';
            v_vencidas := v_vencidas + 1;
        ELSIF r_vac.dias_restantes <= 30 THEN
            v_status := '! A VENCER';
            v_vencer := v_vencer + 1;
        ELSE
            v_status  := 'Válida';
            v_validas := v_validas + 1;
        END IF;

        v_total := v_total + 1;

        DBMS_OUTPUT.PUT_LINE(
            RPAD(NVL(r_vac.pet_nome, '?'), 10)                      ||
            RPAD(r_vac.especie, 12)                                 ||
            RPAD(r_vac.vacina, 16)                                  ||
            RPAD(TO_CHAR(r_vac.dt_aplicacao, 'DD/MM/YYYY'), 12)    ||
            RPAD(TO_CHAR(r_vac.dt_validade,  'DD/MM/YYYY'), 12)    ||
            RPAD(v_status, 16)                                      ||
            LPAD(r_vac.dias_restantes, 6)
        );
    END LOOP;
    CLOSE c_vacinas;

    DBMS_OUTPUT.PUT_LINE(RPAD('=', 84, '='));
    DBMS_OUTPUT.PUT_LINE('TOTAL DE VACINAS    : ' || v_total);
    DBMS_OUTPUT.PUT_LINE('VÁLIDAS             : ' || v_validas);
    DBMS_OUTPUT.PUT_LINE('A VENCER (<=30 dias): ' || v_vencer);
    DBMS_OUTPUT.PUT_LINE('VENCIDAS            : ' || v_vencidas);

EXCEPTION
    WHEN OTHERS THEN
        IF c_vacinas%ISOPEN THEN CLOSE c_vacinas; END IF;
        DBMS_OUTPUT.PUT_LINE('ERRO NO BLOCO 7: ' || SQLERRM);
END;
/

--select * from db_tutor
--select * from db_pet