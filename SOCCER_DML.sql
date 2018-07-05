--���� 001
SELECT COUNT(*) AS ���̺��Ǽ�
FROM tab;

--���� 002
SELECT team_name "��ü �౸�� ���"
FROM team
ORDER BY team_name;

--���� 003
--������ ���� (�ߺ�����, ������ �������� ����) > nvl2()
SELECT DISTINCT NVL2(position,position,'����') "������"
FROM player;

--���� 004
-- ������(ID: K02)��Ű��
SELECT player_name
FROM player
WHERE team_id = 'K02'
    AND position = 'GK'
ORDER BY player_name
;

--���� 005
--SQL_TEST_005 : ������(ID: K02)
--&& Ű�� 170 �̻� ���� && ���� ��
SELECT position, player_name
FROM player
WHERE team_id = 'K02'
    AND height >= 170
    AND player_name LIKE '��%'
;

--���� 006
-- ������(ID: K02) ������ �̸�,
-- Ű�� ������ ����Ʈ (���� cm �� kg ����)
-- Ű�� �����԰� ������ "0" ǥ��
-- Ű ��������
SELECT player_name || '����' "�̸�",
    NVL2(height,height,0) || 'cm' "Ű",
    NVL2(weight,weight,0) || 'kg' "������"
FROM player
WHERE team_id LIKE 'K02'
ORDER BY height DESC
;

--���� 007
-- ������(ID: K02) ������ �̸�,
-- Ű�� ������ ����Ʈ (���� cm �� kg ����)
-- Ű�� �����԰� ������ "0" ǥ��
-- Ű ��������
-- BMI = ������ / Ű�� �μ�, ���⼭ �����Դ� kg, Ű�� m �����̴�.
-- EX.������ 55kg�� Ű 1.68m�� ����� BMI�� 55kg/(1.68m)^2 = 19.4�̴�
SELECT player_name || '����' "�̸�",
    NVL2(height,height,0) || 'cm' "Ű",
    NVL2(weight,weight,0) || 'kg' "������",
    ROUND(weight/((height*0.01)*(height*0.01)),2) "BMI������"
FROM player
WHERE team_id LIKE 'K02'
ORDER BY height DESC
;

--���� 008
--������(ID: K02) �� ������(ID: K10)������ �� GK �������� ����
--���� ��������
SELECT t.team_name, p.position, p.player_name
FROM player p
    JOIN team t
    ON p.team_id LIKE t.team_id
WHERE p.position LIKE 'GK'
    AND t.team_id IN ('K02','K10')
ORDER BY t.team_name, p.player_name
;

--JOIN ����


--SELECT Orders.OrderID, Customers.CustomerName, Orders.OrderDate
--FROM Orders
--INNER JOIN Customers ON Orders.CustomerID=Customers.CustomerID;


--���� 009
-- ������(ID: K02) �� ������(ID: K10)������ �� ��
-- Ű�� 180 �̻� 183 ������ ������
-- Ű, ����, ����� ��������
SELECT p.height || 'cm' "Ű",
    t.team_name "����",
    p.player_name "�̸�"
FROM player p
    JOIN team t
    ON p.team_id LIKE t.team_id
WHERE t.team_id IN ('K02','K10')
    AND p.height BETWEEN 180 AND 183
ORDER BY p.height, t.team_name, p.player_name
;

--JOIN ����
SELECT
     HEIGHT,
    (SELECT T.TEAM_NAME
     FROM TEAM T
     WHERE
        T.TEAM_ID LIKE P.TEAM_ID
        AND T.TEAM_ID IN ('K02','K10')) TEAM_NAME,
    PLAYER_NAME
FROM PLAYER P, TEAM T
WHERE P.HEIGHT BETWEEN 180 AND 183
ORDER BY HEIGHT, TEAM_NAME, PLAYER_NAME
;


--���� 010
-- ��� ������ ��
-- �������� �������� ���� �������� ���� �̸�
-- ����, ����� ��������
SELECT t.team_name, p.player_name
FROM player p
    INNER JOIN team t
    ON p.team_id LIKE t.team_id
WHERE p.position IS NULL
ORDER BY t.team_name, p.player_name
;

--���� 011
-- ���� ��Ÿ����� �����Ͽ�
-- ���̸�, ��Ÿ��� �̸� ���
SELECT t.team_name ����, s.stadium_name ��Ÿ���
FROM team t
    INNER JOIN stadium s
    ON t.stadium_id LIKE s.stadium_id
ORDER BY t.team_name
;

-- ���� 012
-- ���� ��Ÿ���, �������� �����Ͽ�
-- 2012�� 3�� 17�Ͽ� ���� �� ����� 
-- ���̸�, ��Ÿ���, ������� �̸� ���
-- �������̺� join �� ã�Ƽ� �ذ��Ͻÿ�.
SELECT t.team_name ����,
    s.stadium_name ��Ÿ���,
    sche.awayteam_id ������ID,
    sche.sche_date �����ٳ�¥
FROM ((stadium s
    INNER JOIN team t
        ON s.stadium_id LIKE t.stadium_id)
    INNER JOIN schedule sche
        ON s.stadium_id LIKE sche.stadium_id)
WHERE sche.sche_date LIKE '20120317'
ORDER BY t.team_name
;

--Ǯ�� 012
SELECT
    T.TEAM_NAME ���̸�,
    S.STADIUM_NAME ��Ÿ���,
    SCHE.AWAYTEAM_ID ������ID,
    SCHE.SCHE_DATE �����ٳ�¥
FROM
    TEAM T
    JOIN STADIUM S
        ON T.STADIUM_ID LIKE S.STADIUM_ID
    --T �� S�� STADIUM_ID ���տ� SCHE�� STADIUM_ID�� ���ϴ� ����
    JOIN SCHEDULE SCHE
        ON S.STADIUM_ID LIKE SCHE.STADIUM_ID
WHERE
    SCHE.SCHE_DATE LIKE '20120317'
ORDER BY T.TEAM_NAME
;

-- ���� 013
-- 2012�� 3�� 17�� ��⿡ 
-- ���� ��ƿ���� �Ҽ� ��Ű��(GK)
-- ����, ������,���� (����������), 
-- ��Ÿ���, ��⳯¥�� ���Ͻÿ�
-- �������� ���̸��� ������ ���ÿ�
SELECT p.player_name ������,
    p.position ������,
    t.region_name || ' ' || t.team_name ����,
    s.stadium_name ��Ÿ���,
    sche.sche_date �����ٳ�¥
FROM ((team t
        JOIN player p
            ON t.team_id LIKE p.team_id)
    JOIN (stadium s 
                JOIN schedule sche 
                    ON s.stadium_id LIKE sche.stadium_id)
        ON t.stadium_id LIKE s.stadium_id)
WHERE t.team_name LIKE '��ƿ����'
    AND p.position LIKE 'GK'
    AND sche.sche_date LIKE '20120317'
ORDER BY p.player_name
;

--Ǯ�� 013




-- ���� 014
-- Ȩ���� 3���̻� ���̷� �¸��� ����� 
-- ����� �̸�, ��� ����
-- Ȩ�� �̸��� ������ �̸���
-- ���Ͻÿ�
SELECT s.stadium_name ��Ÿ���,
    sche.sche_date ��⳯¥,
    t1.region_name || ' ' ||t1.team_name Ȩ��,
    t2.region_name || ' ' ||t2.team_name ������,
    sche.home_score "Ȩ�� ����",
    sche.away_score "������ ����"
FROM ((stadium s
            JOIN schedule sche
                ON s.stadium_id LIKE sche.stadium_id)
    JOIN team t1
        ON s.stadium_id LIKE t1.stadium_id),
    team t2
WHERE sche.home_score - sche.away_score >= 3
    AND t2.team_id LIKE sche.awayteam_id
ORDER BY sche.sche_date
;

--Ǯ�� 014
SELECT S.STADIUM_NAME ��Ÿ���,
    K.SCHE_DATE ��⳯¥,
    HT.REGION_NAME || ' ' || HT.TEAM_NAME Ȩ��,
    AT.REGION_NAME || ' ' || AT.TEAM_NAME ������,
    K.HOME_SCORE "Ȩ�� ����",
    K.AWAY_SCORE "������ ����"
FROM
    SCHEDULE K
    JOIN STADIUM S
        ON K.STADIUM_ID LIKE S.STADIUM_ID
    JOIN TEAM HT
        ON K.HOMETEAM_ID LIKE HT.TEAM_ID
    JOIN TEAM AT
        ON K.AWAYTEAM_ID LIKE AT.TEAM_ID
WHERE
    K.HOME_SCORE - K.AWAY_SCORE >= 3
ORDER BY K.SCHE_DATE
;


-- ���� 015
-- STADIUM �� ��ϵ� ��� �߿���
-- Ȩ���� ���� �������� ���� ��������
-- ī��Ʈ ���� 20 , �ϻ� �ؿ� ����, �Ⱦ絵 ����
SELECT s.stadium_name,
    s.stadium_id,
    s.seat_count,
    s.hometeam_id,
    t.e_team_name
FROM stadium s
    LEFT JOIN team t
        ON s.stadium_id LIKE t.stadium_id
ORDER BY hometeam_id
;


--���� 016
--�Ҽ��� �Ｚ ������� ���� �������
--���� �巡���� ���� �������� ����
SELECT 
    T.TEAM_NAME ����,
    P.PLAYER_NAME ������,
    P.POSITION ������,
    P.BACK_NO ��ѹ�,
    P.HEIGHT Ű
FROM PLAYER P
    JOIN TEAM T
        ON P.TEAM_ID LIKE T.TEAM_ID
WHERE 
    T.TEAM_ID IN ('K02','K07')
;

--����017
--�Ҽ��� �Ｚ������� ���� �������
--�巡���� ���� �������� ���� (ID�� �𸣴� ����)
SELECT 
    T.TEAM_NAME ����,
    P.PLAYER_NAME ������,
    P.POSITION ������,
    P.BACK_NO ��ѹ�,
    P.HEIGHT Ű
FROM PLAYER P
    JOIN TEAM T
        ON P.TEAM_ID LIKE T.TEAM_ID
WHERE 
    T.TEAM_ID IN (
        SELECT TEAM_ID
        FROM TEAM
        WHERE
            TEAM_NAME 
                IN ('�Ｚ�������','�巡����') )
;

--����018
--��ȣ�� ������ �Ҽ����� ������, ��ѹ�
SELECT
   P.PLAYER_NAME,
   T.TEAM_NAME,
   P.POSITION,
   P.BACK_NO
FROM PLAYER P
    JOIN TEAM T
    ON P.TEAM_ID LIKE T.TEAM_ID
WHERE
    P.PLAYER_NAME LIKE '��ȣ��'
;
-----
SELECT
   P.PLAYER_NAME ������,
   (SELECT TEAM_NAME
    FROM TEAM
    WHERE
        TEAM_ID LIKE P.TEAM_ID) ����,
   P.POSITION ������,
   P.BACK_NO ��ѹ�
FROM (SELECT * 
      FROM PLAYER
      WHERE
        PLAYER_NAME LIKE '��ȣ��') P
;
--Ǯ��018
SELECT
    T.TEAM_NAME ����,
    P.POSITION ������,
    P.BACK_NO ��ѹ�
FROM PLAYER P
    JOIN TEAM T
    ON P.TEAM_ID LIKE T.TEAM_ID
WHERE
    P.PLAYER_NAME LIKE '��ȣ��'
;

-- 019
-- ������Ƽ���� MF ���Ű�� ���Դϱ�? 174.87
SELECT
    REGION_NAME || ' ' || TEAM_NAME ����,
    (SELECT ROUND(AVG(P.HEIGHT),2)
     FROM PLAYER P, TEAM T
     WHERE
        T.TEAM_ID LIKE P.TEAM_ID
        AND T.TEAM_NAME LIKE '��Ƽ��'
        AND P.POSITION LIKE 'MF') MF���Ű
FROM (SELECT *
      FROM TEAM
      WHERE
        TEAM_NAME LIKE '��Ƽ��')
;

--Ǯ�� 019
SELECT
    ROUND(AVG(P.HEIGHT),2) ���Ű
FROM
    TEAM T
        JOIN PLAYER P
        ON T.TEAM_ID LIKE P.TEAM_ID
WHERE
    T.TEAM_NAME LIKE '��Ƽ��'
    AND P.POSITION LIKE 'MF'
;

-- 020
-- 2012�� ���� ������ ���Ͻÿ�
SELECT
    (SELECT COUNT(*) FROM SCHEDULE WHERE SCHE_DATE LIKE '201201__') "1��",
    (SELECT COUNT(*) FROM SCHEDULE WHERE SCHE_DATE LIKE '201202__') "2��",
    (SELECT COUNT(*) FROM SCHEDULE WHERE SCHE_DATE LIKE '201203__') "3��",
    (SELECT COUNT(*) FROM SCHEDULE WHERE SCHE_DATE LIKE '201204__') "4��",
    (SELECT COUNT(*) FROM SCHEDULE WHERE SCHE_DATE LIKE '201205__') "5��",
    (SELECT COUNT(*) FROM SCHEDULE WHERE SCHE_DATE LIKE '201206__') "6��",
    (SELECT COUNT(*) FROM SCHEDULE WHERE SCHE_DATE LIKE '201207__') "7��",
    (SELECT COUNT(*) FROM SCHEDULE WHERE SCHE_DATE LIKE '201208__') "8��",
    (SELECT COUNT(*) FROM SCHEDULE WHERE SCHE_DATE LIKE '201209__') "9��",
    (SELECT COUNT(*) FROM SCHEDULE WHERE SCHE_DATE LIKE '201210__') "10��",
    (SELECT COUNT(*) FROM SCHEDULE WHERE SCHE_DATE LIKE '201211__') "11��",
    (SELECT COUNT(*) FROM SCHEDULE WHERE SCHE_DATE LIKE '201212__') "12��"
FROM
    DUAL
;
--
SELECT
    SUBSTR(SCHE_DATE,5,2) ����,
    COUNT(SCHE_DATE) ����
FROM
    SCHEDULE
WHERE
    SCHE_DATE LIKE '2012%'
GROUP BY
    SUBSTR(SCHE_DATE,5,2)
ORDER BY ����
;

-- 021
-- 2012�� ���� ����� ����(GUBUN IS YES)�� ���Ͻÿ�
-- ����� 1��:20��� �̷�������...
SELECT
    '1�� : ' || (SELECT COUNT(*) FROM SCHEDULE WHERE SCHE_DATE LIKE '201201__' AND GUBUN LIKE 'Y') || '���' "1��",
    '2�� : ' || (SELECT COUNT(*) FROM SCHEDULE WHERE SCHE_DATE LIKE '201202__' AND GUBUN LIKE 'Y') || '���' "2��",
    '3�� : ' || (SELECT COUNT(*) FROM SCHEDULE WHERE SCHE_DATE LIKE '201203__' AND GUBUN LIKE 'Y') || '���' "3��",
    '4�� : ' || (SELECT COUNT(*) FROM SCHEDULE WHERE SCHE_DATE LIKE '201204__' AND GUBUN LIKE 'Y') || '���' "4��",
    '5�� : ' || (SELECT COUNT(*) FROM SCHEDULE WHERE SCHE_DATE LIKE '201205__' AND GUBUN LIKE 'Y') || '���' "5��",
    '6�� : ' || (SELECT COUNT(*) FROM SCHEDULE WHERE SCHE_DATE LIKE '201206__' AND GUBUN LIKE 'Y') || '���' "6��",
    '7�� : ' || (SELECT COUNT(*) FROM SCHEDULE WHERE SCHE_DATE LIKE '201207__' AND GUBUN LIKE 'Y') || '���' "7��",
    '8�� : ' || (SELECT COUNT(*) FROM SCHEDULE WHERE SCHE_DATE LIKE '201208__' AND GUBUN LIKE 'Y') || '���' "8��",
    '9�� : ' || (SELECT COUNT(*) FROM SCHEDULE WHERE SCHE_DATE LIKE '201209__' AND GUBUN LIKE 'Y') || '���' "9��",
    '10�� : ' || (SELECT COUNT(*) FROM SCHEDULE WHERE SCHE_DATE LIKE '201210__' AND GUBUN LIKE 'Y') || '���' "10��",
    '11�� : ' || (SELECT COUNT(*) FROM SCHEDULE WHERE SCHE_DATE LIKE '201211__' AND GUBUN LIKE 'Y') || '���' "11��",
    '12�� : ' || (SELECT COUNT(*) FROM SCHEDULE WHERE SCHE_DATE LIKE '201212__' AND GUBUN LIKE 'Y') || '���' "12��"
FROM
    DUAL
;
--
SELECT
    SUBSTR(SCHE_DATE,5,2) ����,
    COUNT(SCHE_DATE) ����
FROM
    SCHEDULE
WHERE
    SCHE_DATE LIKE '2012%'
    AND GUBUN LIKE 'Y'
GROUP BY
    SUBSTR(SCHE_DATE,5,2)
ORDER BY ����
;

--����022
-- 2012�� 9�� 14�Ͽ� ������ ���� ���� ����Դϱ�
-- Ȩ��: ?   ������: ? �� ���
SELECT
    'Ȩ��: ' || HT.TEAM_NAME || '  ������: ' || AT.TEAM_NAME ���
FROM SCHEDULE S
    JOIN TEAM HT
        ON S.HOMETEAM_ID LIKE HT.TEAM_ID
    JOIN TEAM AT
        ON S.AWAYTEAM_ID LIKE AT.TEAM_ID
WHERE
    SCHE_DATE LIKE '20120914'
;

--����023
--GROUP BY
--���� ������ ��
--�巡���� 15��
SELECT
    COUNT(P.PLAYER_ID) �ο���,
    T.TEAM_ID
FROM
    TEAM T
    JOIN PLAYER P
        ON T.TEAM_ID LIKE P.TEAM_ID
GROUP BY
    T.TEAM_ID
ORDER BY
    T.TEAM_ID
;
--
SELECT
    
    (SELECT A.TEAM_NAME
     FROM TEAM A
     WHERE
        A.TEAM_ID LIKE T.TEAM_ID) ����,
    --T.TEAM_NAME ����,
    COUNT(P.PLAYER_ID) �ο���
FROM
    TEAM T
    JOIN PLAYER P
        ON T.TEAM_ID LIKE P.TEAM_ID
GROUP BY
    T.TEAM_ID
;

--����024
--���� ��Ű���� ��� Ű
--������ũ 180CM
SELECT
    T.TEAM_NAME ����,
    P.POSITION ������,
    ROUND(AVG(P.HEIGHT),2) ���Ű,
    COUNT(P.POSITION) �ο���,
    MAX(P.HEIGHT) �ִ�Ű,
    MIN(P.HEIGHT) �ּ�Ű
FROM
    PLAYER P
    JOIN TEAM T
        ON P.TEAM_ID LIKE T.TEAM_ID
WHERE
    P.POSITION LIKE 'GK'
GROUP BY
    T.TEAM_NAME,
    P.POSITION
ORDER BY
    T.TEAM_NAME
;

--����024
SELECT
    PLAYER_NAME,
    CASE
        WHEN POSITION IS NULL THEN '����'
        WHEN POSITION LIKE 'GK' THEN '��Ű��'
        WHEN POSITION LIKE 'DF' THEN '�����'
        WHEN POSITION LIKE 'MF' THEN '�̵��ʴ�'
        WHEN POSITION LIKE 'FW' THEN '���ݼ�'
        ELSE POSITION
    END POSITION
FROM
    PLAYER
WHERE
    TEAM_ID = 'K08'
ORDER BY PLAYER_NAME
;

--���� 025
--�Ｚ�������� Ű�� 
--11������ 20�����
SELECT
    B.*
FROM (SELECT
        ROWNUM ANUM,
        A.*
      FROM (SELECT 
                T.TEAM_NAME ����,
                P.PLAYER_NAME ������,
                P.POSITION ������,
                P.BACK_NO ��ѹ�,
                P.HEIGHT Ű
            FROM PLAYER P
                JOIN TEAM T
                    ON P.TEAM_ID LIKE T.TEAM_ID
            WHERE 
                T.TEAM_ID LIKE (SELECT TEAM_ID
                                FROM TEAM
                                WHERE
                                    TEAM_NAME LIKE '�Ｚ�������')
                AND P.HEIGHT IS NOT NULL
      ORDER BY
            P.HEIGHT DESC) A ) B
WHERE
    ANUM BETWEEN 11 AND 20
;

-- 026
-- ���� ��Ű���� ��� Ű����
-- ���� ���Ű�� ū ������ "�������"
SELECT
    A.����
FROM(SELECT
        (SELECT TEAM_NAME
         FROM TEAM
         WHERE
            TEAM_ID LIKE T.TEAM_ID) ����,
        P.POSITION ������,
        AVG(P.HEIGHT) ���Ű
     FROM
        TEAM T
        JOIN PLAYER P
            ON T.TEAM_ID LIKE P.TEAM_ID
     WHERE
        P.POSITION LIKE 'GK'
     GROUP BY
        T.TEAM_ID
        --,P.POSITION
     ORDER BY
        ���Ű DESC) A
WHERE
    ROWNUM LIKE 1
;

-- 027
-- �� ���ܺ� ������ ���Ű�� �Ｚ �����������
-- ���Ű���� ���� ���� �̸��� �ش� ���� ���Ű�� 
-- ���Ͻÿ�
SELECT
    B.*
FROM(SELECT A.*
     FROM(SELECT
            (SELECT TEAM_NAME
             FROM TEAM
             WHERE TEAM_ID LIKE T.TEAM_ID) ����,
            ROUND(AVG(P.HEIGHT),2) ���Ű
          FROM TEAM T
                JOIN PLAYER P
                    ON T.TEAM_ID LIKE P.TEAM_ID
          GROUP BY T.TEAM_ID
          ORDER BY ���Ű)A)B
WHERE
    ROWNUM < (SELECT B.NO
                    FROM (SELECT ROWNUM "NO",
                                 A.*
                          FROM(SELECT
                                  (SELECT TEAM_NAME
                                   FROM TEAM
                                   WHERE TEAM_ID LIKE T.TEAM_ID) ����,
                                   ROUND(AVG(P.HEIGHT),2) ���Ű
                               FROM TEAM T
                                    JOIN PLAYER P
                                        ON T.TEAM_ID LIKE P.TEAM_ID
                               GROUP BY T.TEAM_ID
                               ORDER BY ���Ű)A)B
                    WHERE B.���� LIKE '�Ｚ�������')
;


-- 028
-- 2012�� ��� �߿��� �������� ���� ū ��� ����
-- 20120317, ��ȭõ�� VS ������Ƽ��, ������
SELECT A.*
FROM(SELECT
        K.SCHE_DATE ��⳯¥,
        HT.TEAM_NAME || ' VS ' || AT.TEAM_NAME ���,
        CASE
            WHEN K.HOME_SCORE >= K.AWAY_SCORE THEN (K.HOME_SCORE - K.AWAY_SCORE)
            ELSE K.AWAY_SCORE - K.HOME_SCORE
        END ������
     FROM
        SCHEDULE K
        JOIN TEAM HT
            ON K.HOMETEAM_ID LIKE HT.TEAM_ID
        JOIN TEAM AT
            ON K.AWAYTEAM_ID LIKE AT.TEAM_ID
     WHERE
        K.SCHE_DATE LIKE '2012%'
        AND K.GUBUN LIKE 'Y'
    
     ORDER BY ������ DESC) A
WHERE ROWNUM < (SELECT
                    COUNT(C."���� ū ������") "ū ������ ����"
                FROM(SELECT
                        MAX(B.������) "���� ū ������"
                     FROM(SELECT A.������ "������"
                          FROM(SELECT
                                    K.SCHE_DATE ��⳯¥,
                                    HT.TEAM_NAME || ' VS ' || AT.TEAM_NAME ���,
                                    CASE
                                        WHEN K.HOME_SCORE >= K.AWAY_SCORE THEN (K.HOME_SCORE - K.AWAY_SCORE)
                                        ELSE K.AWAY_SCORE - K.HOME_SCORE
                                    END ������
                                FROM
                                    SCHEDULE K
                                    JOIN TEAM HT
                                        ON K.HOMETEAM_ID LIKE HT.TEAM_ID
                                    JOIN TEAM AT
                                        ON K.AWAYTEAM_ID LIKE AT.TEAM_ID
                          WHERE
                                K.SCHE_DATE LIKE '2012%'
                                AND K.GUBUN LIKE 'Y'
        
                          ORDER BY ������ DESC) A
                          GROUP BY A.������)B)C)+1
;
--�ٸ����
SELECT A.*
FROM(SELECT
        K.SCHE_DATE ��⳯¥,
        HT.TEAM_NAME || ' VS ' || AT.TEAM_NAME ���,
        CASE
            WHEN K.HOME_SCORE >= K.AWAY_SCORE THEN (K.HOME_SCORE - K.AWAY_SCORE)
            ELSE K.AWAY_SCORE - K.HOME_SCORE
        END ������
     FROM
        SCHEDULE K
        JOIN TEAM HT
            ON K.HOMETEAM_ID LIKE HT.TEAM_ID
        JOIN TEAM AT
            ON K.AWAYTEAM_ID LIKE AT.TEAM_ID
     WHERE
        K.SCHE_DATE LIKE '2012%'
        AND K.GUBUN LIKE 'Y'
    
     ORDER BY ������ DESC) A
WHERE A.������ LIKE (SELECT B.������
                     FROM(SELECT
                            K.SCHE_DATE ��⳯¥,
                            HT.TEAM_NAME || ' VS ' || AT.TEAM_NAME ���,
                            CASE
                                WHEN K.HOME_SCORE >= K.AWAY_SCORE THEN (K.HOME_SCORE - K.AWAY_SCORE)
                                ELSE K.AWAY_SCORE - K.HOME_SCORE
                            END ������
                          FROM
                              SCHEDULE K
                                JOIN TEAM HT
                                    ON K.HOMETEAM_ID LIKE HT.TEAM_ID
                                JOIN TEAM AT
                                    ON K.AWAYTEAM_ID LIKE AT.TEAM_ID
                          WHERE
                            K.SCHE_DATE LIKE '2012%'
                            AND K.GUBUN LIKE 'Y'
                          ORDER BY ������ DESC)B
                     WHERE ROWNUM LIKE 1) --������� �������� ���� �������� ���
;

-- 029
-- �¼������ ��Ÿ��� ���� �ű��
SELECT
    ROWNUM "����",
    A.*
FROM(SELECT
        STADIUM_NAME ��Ÿ���,
        SEAT_COUNT �¼���
     FROM
        STADIUM
     ORDER BY SEAT_COUNT DESC) A
;

-- 030
-- 2012�� ���� �¸� ������ �����ű��
SELECT 
    A.WINNER ����,
    COUNT(A.WINNER) �¸�
FROM(SELECT
        K.SCHE_DATE ��⳯¥,
        CASE
            WHEN K.HOME_SCORE > K.AWAY_SCORE THEN HT.TEAM_NAME
            WHEN K.AWAY_SCORE > K.HOME_SCORE THEN AT.TEAM_NAME
            ELSE '���º�'
        END WINNER
     FROM SCHEDULE K
            JOIN TEAM HT
                ON K.HOMETEAM_ID LIKE HT.TEAM_ID
            JOIN TEAM AT
                ON K.AWAYTEAM_ID LIKE AT.TEAM_ID
     WHERE
        K.GUBUN LIKE 'Y'
        AND K.SCHE_DATE LIKE '2012%'
    )A
WHERE A.WINNER NOT LIKE '���º�'
GROUP BY A.WINNER
ORDER BY �¸� DESC
;
