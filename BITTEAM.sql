CREATE TABLE TEAMZ(
    TEAM_ID VARCHAR2(20) PRIMARY KEY,
    TEAM_NAME VARCHAR2(20)
);

CREATE TABLE MEMBERS(
    MEMBER_ID VARCHAR2(20) PRIMARY KEY,
    TEAM_ID VARCHAR2(20),
    MEMBER_NAME VARCHAR2(20),
    MEMBER_AGE DECIMAL,
    ROLL VARCHAR2(20) -- ����, ����
    --ȸ�����, �����۴��, �Խ��Ǵ��, �����ڴ��
);

ALTER TABLE MEMBERS ADD CONSTRAINT MEMBERS_FK_TEAM_ID FOREIGN KEY (TEAM_ID)
REFERENCES TEAMZ (TEAM_ID);

ALTER TABLE MEMBERS ADD (ROLL VARCHAR2(20));

INSERT INTO TEAMZ VALUES('AT','����Ƽ��');
INSERT INTO TEAMZ VALUES('HT','��ī��');
INSERT INTO TEAMZ VALUES('CT','������');
INSERT INTO TEAMZ VALUES('ST','�����');

INSERT INTO MEMBERS VALUES('01','AT','����',34);
INSERT INTO MEMBERS VALUES('02','AT','����',35);
INSERT INTO MEMBERS VALUES('03','AT','����',21);
INSERT INTO MEMBERS VALUES('04','AT','����',29);
INSERT INTO MEMBERS VALUES('05','AT','����',25);
INSERT INTO MEMBERS VALUES('06','HT','����',26);
INSERT INTO MEMBERS VALUES('07','HT','����',26);
INSERT INTO MEMBERS VALUES('08','HT','��',27);
INSERT INTO MEMBERS VALUES('09','HT','���',30);
INSERT INTO MEMBERS VALUES('10','HT','�ܾ�',26);
INSERT INTO MEMBERS VALUES('11','CT','������',32);
INSERT INTO MEMBERS VALUES('12','CT','��ȣ',31);
INSERT INTO MEMBERS VALUES('13','CT','����',29);
INSERT INTO MEMBERS VALUES('14','CT','����',23);
INSERT INTO MEMBERS VALUES('15','CT','����',30);
INSERT INTO MEMBERS VALUES('16','ST','��ȣ',27);
INSERT INTO MEMBERS VALUES('17','ST','����',26);
INSERT INTO MEMBERS VALUES('18','ST','�̽�',29);
INSERT INTO MEMBERS VALUES('19','ST','����',26);
INSERT INTO MEMBERS VALUES('20','ST','����',30);

SELECT * FROM TAB;

--DROP TABLE TEAMZ;
--DROP TABLE MEMBERS;

--������
SELECT
    TEAM_ID �����̵�,
    COUNT(MEMBER_ID) ������
FROM
    MEMBERS
GROUP BY
    TEAM_ID
;

--���� ������
SELECT
    TEAM_ID �����̵�,
    SUM(MEMBER_AGE) ������
FROM
    MEMBERS
GROUP BY
    TEAM_ID
;

--���� �ִ볪��
SELECT
    TEAM_ID �����̵�,
    MAX(MEMBER_AGE) �ִ볪��
FROM
    MEMBERS
GROUP BY
    TEAM_ID
;

--���� �ּҳ���
SELECT
    TEAM_ID �����̵�,
    MIN(MEMBER_AGE) �ּҳ���
FROM
    MEMBERS
GROUP BY
    TEAM_ID
;

--���� ��ճ���
SELECT
    TEAM_ID �����̵�,
    AVG(MEMBER_AGE) ��ճ���
FROM
    MEMBERS
GROUP BY
    TEAM_ID
;
--���� 5���� ����
SELECT
    M.TEAM_ID �����̵�,
    (SELECT TEAM_NAME
     FROM TEAMZ
     WHERE
        TEAM_ID LIKE M.TEAM_ID
    ) ����,
    COUNT(MEMBER_ID) ����,
    SUM(MEMBER_AGE) ������,
    MAX(MEMBER_AGE) �ִ볪��,
    MIN(MEMBER_AGE) �ּҳ���,
    AVG(MEMBER_AGE) ��ճ���
FROM
    MEMBERS M
GROUP BY
    M.TEAM_ID
HAVING
    AVG(MEMBER_AGE) >= 28
ORDER BY
    M.TEAM_ID
;

--�ο찪����
--UPDATE MEMBERS SET MEMBER_NAME = '����'
--WHERE MEMBER_NAME LIKE '�¿�';
ALTER TABLE MEMBERS ADD (ROLL VARCHAR2(20));

UPDATE MEMBERS SET ROLL = '����'
WHERE MEMBER_NAME IN ('����','������','����','��ȣ');

UPDATE MEMBERS SET ROLL = '����'
WHERE ROLL IS NULL;

UPDATE MEMBERS SET ROLL = NULL
WHERE ROLL LIKE '����';

UPDATE MEMBERS SET ROLL =
    CASE
        WHEN M.MEMBER_NAME IN ('����','������','����','��ȣ') THEN '����'
        ELSE '����'
    END
WHERE ROLL IS NULL
;

SELECT MEMBER_NAME, ROLL FROM MEMBERS;

SELECT
    (SELECT TEAM_NAME
     FROM TEAMZ
     WHERE
        TEAM_ID LIKE M.TEAM_ID)�����̵�,
    M.MEMBER_NAME �̸�,
    CASE
        WHEN M.MEMBER_NAME IN ('����','������','����','��ȣ') THEN '����'
        WHEN M.MEMBER_NAME IS NOT NULL THEN'����'
    END ��å
FROM
    MEMBERS M
ORDER BY TEAM_ID, ��å DESC
;

SELECT
    (SELECT TEAM_NAME
     FROM TEAMZ
     WHERE
        TEAM_ID LIKE M.TEAM_ID) ����,
    COUNT(M.MEMBER_ID) �ο���,
    SUM(M.MEMBER_ID) ������,
    MAX(M.MEMBER_AGE) �ִ볪��,
    MIN(M.MEMBER_AGE) �ּҳ���,
    AVG(M.MEMBER_AGE) ��ճ���,
    (SELECT MEMBER_NAME
     FROM MEMBERS
     WHERE
        ROLL LIKE '����'
        AND TEAM_ID LIKE M.TEAM_ID) ����
FROM
    MEMBERS M
GROUP BY
    M.TEAM_ID
ORDER BY M.TEAM_ID
;
