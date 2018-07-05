--예제 001
SELECT COUNT(*) AS 테이블의수
FROM tab;

--예제 002
SELECT team_name "전체 축구팀 목록"
FROM team
ORDER BY team_name;

--예제 003
--포지션 종류 (중복제거, 없으면 신입으로 기재) > nvl2()
SELECT DISTINCT NVL2(position,position,'신입') "포지션"
FROM player;

--예제 004
-- 수원팀(ID: K02)골키퍼
SELECT player_name
FROM player
WHERE team_id = 'K02'
    AND position = 'GK'
ORDER BY player_name
;

--예제 005
--SQL_TEST_005 : 수원팀(ID: K02)
--&& 키가 170 이상 선수 && 성이 고씨
SELECT position, player_name
FROM player
WHERE team_id = 'K02'
    AND height >= 170
    AND player_name LIKE '고%'
;

--예제 006
-- 수원팀(ID: K02) 선수들 이름,
-- 키와 몸무게 리스트 (단위 cm 와 kg 삽입)
-- 키와 몸무게가 없으면 "0" 표시
-- 키 내림차순
SELECT player_name || '선수' "이름",
    NVL2(height,height,0) || 'cm' "키",
    NVL2(weight,weight,0) || 'kg' "몸무게"
FROM player
WHERE team_id LIKE 'K02'
ORDER BY height DESC
;

--예제 007
-- 수원팀(ID: K02) 선수들 이름,
-- 키와 몸무게 리스트 (단위 cm 와 kg 삽입)
-- 키와 몸무게가 없으면 "0" 표시
-- 키 내림차순
-- BMI = 몸무게 / 키² 로서, 여기서 몸무게는 kg, 키는 m 단위이다.
-- EX.몸무게 55kg에 키 1.68m인 사람의 BMI는 55kg/(1.68m)^2 = 19.4이다
SELECT player_name || '선수' "이름",
    NVL2(height,height,0) || 'cm' "키",
    NVL2(weight,weight,0) || 'kg' "몸무게",
    ROUND(weight/((height*0.01)*(height*0.01)),2) "BMI비만지수"
FROM player
WHERE team_id LIKE 'K02'
ORDER BY height DESC
;

--예제 008
--수원팀(ID: K02) 과 대전팀(ID: K10)선수들 중 GK 포지션인 선수
--팀명 오름차순
SELECT t.team_name, p.position, p.player_name
FROM player p
    JOIN team t
    ON p.team_id LIKE t.team_id
WHERE p.position LIKE 'GK'
    AND t.team_id IN ('K02','K10')
ORDER BY t.team_name, p.player_name
;

--JOIN 없이


--SELECT Orders.OrderID, Customers.CustomerName, Orders.OrderDate
--FROM Orders
--INNER JOIN Customers ON Orders.CustomerID=Customers.CustomerID;


--예제 009
-- 수원팀(ID: K02) 과 대전팀(ID: K10)선수들 중 이
-- 키가 180 이상 183 이하인 선수들
-- 키, 팀명, 사람명 오름차순
SELECT p.height || 'cm' "키",
    t.team_name "팀명",
    p.player_name "이름"
FROM player p
    JOIN team t
    ON p.team_id LIKE t.team_id
WHERE t.team_id IN ('K02','K10')
    AND p.height BETWEEN 180 AND 183
ORDER BY p.height, t.team_name, p.player_name
;

--JOIN 없이
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


--예제 010
-- 모든 선수들 중
-- 포지션을 배정받지 못한 선수들의 팀과 이름
-- 팀명, 사람명 오름차순
SELECT t.team_name, p.player_name
FROM player p
    INNER JOIN team t
    ON p.team_id LIKE t.team_id
WHERE p.position IS NULL
ORDER BY t.team_name, p.player_name
;

--예제 011
-- 팀과 스타디움을 조인하여
-- 팀이름, 스타디움 이름 출력
SELECT t.team_name 팀명, s.stadium_name 스타디움
FROM team t
    INNER JOIN stadium s
    ON t.stadium_id LIKE s.stadium_id
ORDER BY t.team_name
;

-- 예제 012
-- 팀과 스타디움, 스케줄을 조인하여
-- 2012년 3월 17일에 열린 각 경기의 
-- 팀이름, 스타디움, 어웨이팀 이름 출력
-- 다중테이블 join 을 찾아서 해결하시오.
SELECT t.team_name 팀명,
    s.stadium_name 스타디움,
    sche.awayteam_id 원정팀ID,
    sche.sche_date 스케줄날짜
FROM ((stadium s
    INNER JOIN team t
        ON s.stadium_id LIKE t.stadium_id)
    INNER JOIN schedule sche
        ON s.stadium_id LIKE sche.stadium_id)
WHERE sche.sche_date LIKE '20120317'
ORDER BY t.team_name
;

--풀이 012
SELECT
    T.TEAM_NAME 팀이름,
    S.STADIUM_NAME 스타디움,
    SCHE.AWAYTEAM_ID 원정팀ID,
    SCHE.SCHE_DATE 스케줄날짜
FROM
    TEAM T
    JOIN STADIUM S
        ON T.STADIUM_ID LIKE S.STADIUM_ID
    --T 와 S의 STADIUM_ID 집합에 SCHE의 STADIUM_ID를 합하는 느낌
    JOIN SCHEDULE SCHE
        ON S.STADIUM_ID LIKE SCHE.STADIUM_ID
WHERE
    SCHE.SCHE_DATE LIKE '20120317'
ORDER BY T.TEAM_NAME
;

-- 예제 013
-- 2012년 3월 17일 경기에 
-- 포항 스틸러스 소속 골키퍼(GK)
-- 선수, 포지션,팀명 (연고지포함), 
-- 스타디움, 경기날짜를 구하시오
-- 연고지와 팀이름은 간격을 띄우시오
SELECT p.player_name 선수명,
    p.position 포지션,
    t.region_name || ' ' || t.team_name 팀명,
    s.stadium_name 스타디움,
    sche.sche_date 스케줄날짜
FROM ((team t
        JOIN player p
            ON t.team_id LIKE p.team_id)
    JOIN (stadium s 
                JOIN schedule sche 
                    ON s.stadium_id LIKE sche.stadium_id)
        ON t.stadium_id LIKE s.stadium_id)
WHERE t.team_name LIKE '스틸러스'
    AND p.position LIKE 'GK'
    AND sche.sche_date LIKE '20120317'
ORDER BY p.player_name
;

--풀이 013




-- 예제 014
-- 홈팀이 3점이상 차이로 승리한 경기의 
-- 경기장 이름, 경기 일정
-- 홈팀 이름과 원정팀 이름을
-- 구하시오
SELECT s.stadium_name 스타디움,
    sche.sche_date 경기날짜,
    t1.region_name || ' ' ||t1.team_name 홈팀,
    t2.region_name || ' ' ||t2.team_name 원정팀,
    sche.home_score "홈팀 점수",
    sche.away_score "원정팀 점수"
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

--풀이 014
SELECT S.STADIUM_NAME 스타디움,
    K.SCHE_DATE 경기날짜,
    HT.REGION_NAME || ' ' || HT.TEAM_NAME 홈팀,
    AT.REGION_NAME || ' ' || AT.TEAM_NAME 원정팀,
    K.HOME_SCORE "홈팀 점수",
    K.AWAY_SCORE "원정팀 점수"
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


-- 예제 015
-- STADIUM 에 등록된 운동장 중에서
-- 홈팀이 없는 경기장까지 전부 나오도록
-- 카운트 값은 20 , 일산 밑에 마산, 안양도 있음
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


--예제 016
--소속이 삼성 블루윙즈 팀인 선수들과
--전남 드래곤즈 팀인 선수들의 정보
SELECT 
    T.TEAM_NAME 팀명,
    P.PLAYER_NAME 선수명,
    P.POSITION 포지션,
    P.BACK_NO 백넘버,
    P.HEIGHT 키
FROM PLAYER P
    JOIN TEAM T
        ON P.TEAM_ID LIKE T.TEAM_ID
WHERE 
    T.TEAM_ID IN ('K02','K07')
;

--예제017
--소속이 삼성블루윙즈 팀인 선수들과
--드래곤즈 팀인 선수들의 정보 (ID를 모르는 상태)
SELECT 
    T.TEAM_NAME 팀명,
    P.PLAYER_NAME 선수명,
    P.POSITION 포지션,
    P.BACK_NO 백넘버,
    P.HEIGHT 키
FROM PLAYER P
    JOIN TEAM T
        ON P.TEAM_ID LIKE T.TEAM_ID
WHERE 
    T.TEAM_ID IN (
        SELECT TEAM_ID
        FROM TEAM
        WHERE
            TEAM_NAME 
                IN ('삼성블루윙즈','드래곤즈') )
;

--예제018
--최호진 선수의 소속팀과 포지션, 백넘버
SELECT
   P.PLAYER_NAME,
   T.TEAM_NAME,
   P.POSITION,
   P.BACK_NO
FROM PLAYER P
    JOIN TEAM T
    ON P.TEAM_ID LIKE T.TEAM_ID
WHERE
    P.PLAYER_NAME LIKE '최호진'
;
-----
SELECT
   P.PLAYER_NAME 선수명,
   (SELECT TEAM_NAME
    FROM TEAM
    WHERE
        TEAM_ID LIKE P.TEAM_ID) 팀명,
   P.POSITION 포지션,
   P.BACK_NO 백넘버
FROM (SELECT * 
      FROM PLAYER
      WHERE
        PLAYER_NAME LIKE '최호진') P
;
--풀이018
SELECT
    T.TEAM_NAME 팀명,
    P.POSITION 포지션,
    P.BACK_NO 백넘버
FROM PLAYER P
    JOIN TEAM T
    ON P.TEAM_ID LIKE T.TEAM_ID
WHERE
    P.PLAYER_NAME LIKE '최호진'
;

-- 019
-- 대전시티즌의 MF 평균키는 얼마입니까? 174.87
SELECT
    REGION_NAME || ' ' || TEAM_NAME 팀명,
    (SELECT ROUND(AVG(P.HEIGHT),2)
     FROM PLAYER P, TEAM T
     WHERE
        T.TEAM_ID LIKE P.TEAM_ID
        AND T.TEAM_NAME LIKE '시티즌'
        AND P.POSITION LIKE 'MF') MF평균키
FROM (SELECT *
      FROM TEAM
      WHERE
        TEAM_NAME LIKE '시티즌')
;

--풀이 019
SELECT
    ROUND(AVG(P.HEIGHT),2) 평균키
FROM
    TEAM T
        JOIN PLAYER P
        ON T.TEAM_ID LIKE P.TEAM_ID
WHERE
    T.TEAM_NAME LIKE '시티즌'
    AND P.POSITION LIKE 'MF'
;

-- 020
-- 2012년 월별 경기수를 구하시오
SELECT
    (SELECT COUNT(*) FROM SCHEDULE WHERE SCHE_DATE LIKE '201201__') "1월",
    (SELECT COUNT(*) FROM SCHEDULE WHERE SCHE_DATE LIKE '201202__') "2월",
    (SELECT COUNT(*) FROM SCHEDULE WHERE SCHE_DATE LIKE '201203__') "3월",
    (SELECT COUNT(*) FROM SCHEDULE WHERE SCHE_DATE LIKE '201204__') "4월",
    (SELECT COUNT(*) FROM SCHEDULE WHERE SCHE_DATE LIKE '201205__') "5월",
    (SELECT COUNT(*) FROM SCHEDULE WHERE SCHE_DATE LIKE '201206__') "6월",
    (SELECT COUNT(*) FROM SCHEDULE WHERE SCHE_DATE LIKE '201207__') "7월",
    (SELECT COUNT(*) FROM SCHEDULE WHERE SCHE_DATE LIKE '201208__') "8월",
    (SELECT COUNT(*) FROM SCHEDULE WHERE SCHE_DATE LIKE '201209__') "9월",
    (SELECT COUNT(*) FROM SCHEDULE WHERE SCHE_DATE LIKE '201210__') "10월",
    (SELECT COUNT(*) FROM SCHEDULE WHERE SCHE_DATE LIKE '201211__') "11월",
    (SELECT COUNT(*) FROM SCHEDULE WHERE SCHE_DATE LIKE '201212__') "12월"
FROM
    DUAL
;
--
SELECT
    SUBSTR(SCHE_DATE,5,2) 월별,
    COUNT(SCHE_DATE) 경기수
FROM
    SCHEDULE
WHERE
    SCHE_DATE LIKE '2012%'
GROUP BY
    SUBSTR(SCHE_DATE,5,2)
ORDER BY 월별
;

-- 021
-- 2012년 월별 진행된 경기수(GUBUN IS YES)를 구하시오
-- 출력은 1월:20경기 이런식으로...
SELECT
    '1월 : ' || (SELECT COUNT(*) FROM SCHEDULE WHERE SCHE_DATE LIKE '201201__' AND GUBUN LIKE 'Y') || '경기' "1월",
    '2월 : ' || (SELECT COUNT(*) FROM SCHEDULE WHERE SCHE_DATE LIKE '201202__' AND GUBUN LIKE 'Y') || '경기' "2월",
    '3월 : ' || (SELECT COUNT(*) FROM SCHEDULE WHERE SCHE_DATE LIKE '201203__' AND GUBUN LIKE 'Y') || '경기' "3월",
    '4월 : ' || (SELECT COUNT(*) FROM SCHEDULE WHERE SCHE_DATE LIKE '201204__' AND GUBUN LIKE 'Y') || '경기' "4월",
    '5월 : ' || (SELECT COUNT(*) FROM SCHEDULE WHERE SCHE_DATE LIKE '201205__' AND GUBUN LIKE 'Y') || '경기' "5월",
    '6월 : ' || (SELECT COUNT(*) FROM SCHEDULE WHERE SCHE_DATE LIKE '201206__' AND GUBUN LIKE 'Y') || '경기' "6월",
    '7월 : ' || (SELECT COUNT(*) FROM SCHEDULE WHERE SCHE_DATE LIKE '201207__' AND GUBUN LIKE 'Y') || '경기' "7월",
    '8월 : ' || (SELECT COUNT(*) FROM SCHEDULE WHERE SCHE_DATE LIKE '201208__' AND GUBUN LIKE 'Y') || '경기' "8월",
    '9월 : ' || (SELECT COUNT(*) FROM SCHEDULE WHERE SCHE_DATE LIKE '201209__' AND GUBUN LIKE 'Y') || '경기' "9월",
    '10월 : ' || (SELECT COUNT(*) FROM SCHEDULE WHERE SCHE_DATE LIKE '201210__' AND GUBUN LIKE 'Y') || '경기' "10월",
    '11월 : ' || (SELECT COUNT(*) FROM SCHEDULE WHERE SCHE_DATE LIKE '201211__' AND GUBUN LIKE 'Y') || '경기' "11월",
    '12월 : ' || (SELECT COUNT(*) FROM SCHEDULE WHERE SCHE_DATE LIKE '201212__' AND GUBUN LIKE 'Y') || '경기' "12월"
FROM
    DUAL
;
--
SELECT
    SUBSTR(SCHE_DATE,5,2) 월별,
    COUNT(SCHE_DATE) 경기수
FROM
    SCHEDULE
WHERE
    SCHE_DATE LIKE '2012%'
    AND GUBUN LIKE 'Y'
GROUP BY
    SUBSTR(SCHE_DATE,5,2)
ORDER BY 월별
;

--예제022
-- 2012년 9월 14일에 벌어질 경기는 어디와 어디입니까
-- 홈팀: ?   원정팀: ? 로 출력
SELECT
    '홈팀: ' || HT.TEAM_NAME || '  원정팀: ' || AT.TEAM_NAME 출력
FROM SCHEDULE S
    JOIN TEAM HT
        ON S.HOMETEAM_ID LIKE HT.TEAM_ID
    JOIN TEAM AT
        ON S.AWAYTEAM_ID LIKE AT.TEAM_ID
WHERE
    SCHE_DATE LIKE '20120914'
;

--예제023
--GROUP BY
--팀별 선수의 수
--드래곤즈 15명
SELECT
    COUNT(P.PLAYER_ID) 인원수,
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
        A.TEAM_ID LIKE T.TEAM_ID) 팀명,
    --T.TEAM_NAME 팀명,
    COUNT(P.PLAYER_ID) 인원수
FROM
    TEAM T
    JOIN PLAYER P
        ON T.TEAM_ID LIKE P.TEAM_ID
GROUP BY
    T.TEAM_ID
;

--예제024
--팀별 골키퍼의 평균 키
--아이파크 180CM
SELECT
    T.TEAM_NAME 팀명,
    P.POSITION 포지션,
    ROUND(AVG(P.HEIGHT),2) 평균키,
    COUNT(P.POSITION) 인원수,
    MAX(P.HEIGHT) 최대키,
    MIN(P.HEIGHT) 최소키
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

--예제024
SELECT
    PLAYER_NAME,
    CASE
        WHEN POSITION IS NULL THEN '없음'
        WHEN POSITION LIKE 'GK' THEN '골키퍼'
        WHEN POSITION LIKE 'DF' THEN '수비수'
        WHEN POSITION LIKE 'MF' THEN '미드필더'
        WHEN POSITION LIKE 'FW' THEN '공격수'
        ELSE POSITION
    END POSITION
FROM
    PLAYER
WHERE
    TEAM_ID = 'K08'
ORDER BY PLAYER_NAME
;

--예제 025
--삼성블루윙즈에서 키순 
--11위부터 20위출력
SELECT
    B.*
FROM (SELECT
        ROWNUM ANUM,
        A.*
      FROM (SELECT 
                T.TEAM_NAME 팀명,
                P.PLAYER_NAME 선수명,
                P.POSITION 포지션,
                P.BACK_NO 백넘버,
                P.HEIGHT 키
            FROM PLAYER P
                JOIN TEAM T
                    ON P.TEAM_ID LIKE T.TEAM_ID
            WHERE 
                T.TEAM_ID LIKE (SELECT TEAM_ID
                                FROM TEAM
                                WHERE
                                    TEAM_NAME LIKE '삼성블루윙즈')
                AND P.HEIGHT IS NOT NULL
      ORDER BY
            P.HEIGHT DESC) A ) B
WHERE
    ANUM BETWEEN 11 AND 20
;

-- 026
-- 팀별 골키퍼의 평균 키에서
-- 가장 평균키가 큰 팀명은 "울산현대"
SELECT
    A.팀명
FROM(SELECT
        (SELECT TEAM_NAME
         FROM TEAM
         WHERE
            TEAM_ID LIKE T.TEAM_ID) 팀명,
        P.POSITION 포지션,
        AVG(P.HEIGHT) 평균키
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
        평균키 DESC) A
WHERE
    ROWNUM LIKE 1
;

-- 027
-- 각 구단별 선수들 평균키가 삼성 블루윙즈팀의
-- 평균키보다 작은 팀의 이름과 해당 팀의 평균키를 
-- 구하시오
SELECT
    B.*
FROM(SELECT A.*
     FROM(SELECT
            (SELECT TEAM_NAME
             FROM TEAM
             WHERE TEAM_ID LIKE T.TEAM_ID) 팀명,
            ROUND(AVG(P.HEIGHT),2) 평균키
          FROM TEAM T
                JOIN PLAYER P
                    ON T.TEAM_ID LIKE P.TEAM_ID
          GROUP BY T.TEAM_ID
          ORDER BY 평균키)A)B
WHERE
    ROWNUM < (SELECT B.NO
                    FROM (SELECT ROWNUM "NO",
                                 A.*
                          FROM(SELECT
                                  (SELECT TEAM_NAME
                                   FROM TEAM
                                   WHERE TEAM_ID LIKE T.TEAM_ID) 팀명,
                                   ROUND(AVG(P.HEIGHT),2) 평균키
                               FROM TEAM T
                                    JOIN PLAYER P
                                        ON T.TEAM_ID LIKE P.TEAM_ID
                               GROUP BY T.TEAM_ID
                               ORDER BY 평균키)A)B
                    WHERE B.팀명 LIKE '삼성블루윙즈')
;


-- 028
-- 2012년 경기 중에서 점수차가 가장 큰 경기 전부
-- 20120317, 일화천마 VS 유나이티드, 점수차
SELECT A.*
FROM(SELECT
        K.SCHE_DATE 경기날짜,
        HT.TEAM_NAME || ' VS ' || AT.TEAM_NAME 경기,
        CASE
            WHEN K.HOME_SCORE >= K.AWAY_SCORE THEN (K.HOME_SCORE - K.AWAY_SCORE)
            ELSE K.AWAY_SCORE - K.HOME_SCORE
        END 점수차
     FROM
        SCHEDULE K
        JOIN TEAM HT
            ON K.HOMETEAM_ID LIKE HT.TEAM_ID
        JOIN TEAM AT
            ON K.AWAYTEAM_ID LIKE AT.TEAM_ID
     WHERE
        K.SCHE_DATE LIKE '2012%'
        AND K.GUBUN LIKE 'Y'
    
     ORDER BY 점수차 DESC) A
WHERE ROWNUM < (SELECT
                    COUNT(C."가장 큰 점수차") "큰 점수차 경기수"
                FROM(SELECT
                        MAX(B.점수차) "가장 큰 점수차"
                     FROM(SELECT A.점수차 "점수차"
                          FROM(SELECT
                                    K.SCHE_DATE 경기날짜,
                                    HT.TEAM_NAME || ' VS ' || AT.TEAM_NAME 경기,
                                    CASE
                                        WHEN K.HOME_SCORE >= K.AWAY_SCORE THEN (K.HOME_SCORE - K.AWAY_SCORE)
                                        ELSE K.AWAY_SCORE - K.HOME_SCORE
                                    END 점수차
                                FROM
                                    SCHEDULE K
                                    JOIN TEAM HT
                                        ON K.HOMETEAM_ID LIKE HT.TEAM_ID
                                    JOIN TEAM AT
                                        ON K.AWAYTEAM_ID LIKE AT.TEAM_ID
                          WHERE
                                K.SCHE_DATE LIKE '2012%'
                                AND K.GUBUN LIKE 'Y'
        
                          ORDER BY 점수차 DESC) A
                          GROUP BY A.점수차)B)C)+1
;
--다른방법
SELECT A.*
FROM(SELECT
        K.SCHE_DATE 경기날짜,
        HT.TEAM_NAME || ' VS ' || AT.TEAM_NAME 경기,
        CASE
            WHEN K.HOME_SCORE >= K.AWAY_SCORE THEN (K.HOME_SCORE - K.AWAY_SCORE)
            ELSE K.AWAY_SCORE - K.HOME_SCORE
        END 점수차
     FROM
        SCHEDULE K
        JOIN TEAM HT
            ON K.HOMETEAM_ID LIKE HT.TEAM_ID
        JOIN TEAM AT
            ON K.AWAYTEAM_ID LIKE AT.TEAM_ID
     WHERE
        K.SCHE_DATE LIKE '2012%'
        AND K.GUBUN LIKE 'Y'
    
     ORDER BY 점수차 DESC) A
WHERE A.점수차 LIKE (SELECT B.점수차
                     FROM(SELECT
                            K.SCHE_DATE 경기날짜,
                            HT.TEAM_NAME || ' VS ' || AT.TEAM_NAME 경기,
                            CASE
                                WHEN K.HOME_SCORE >= K.AWAY_SCORE THEN (K.HOME_SCORE - K.AWAY_SCORE)
                                ELSE K.AWAY_SCORE - K.HOME_SCORE
                            END 점수차
                          FROM
                              SCHEDULE K
                                JOIN TEAM HT
                                    ON K.HOMETEAM_ID LIKE HT.TEAM_ID
                                JOIN TEAM AT
                                    ON K.AWAYTEAM_ID LIKE AT.TEAM_ID
                          WHERE
                            K.SCHE_DATE LIKE '2012%'
                            AND K.GUBUN LIKE 'Y'
                          ORDER BY 점수차 DESC)B
                     WHERE ROWNUM LIKE 1) --가장높은 점수차와 같은 점수차를 출력
;

-- 029
-- 좌석수대로 스타디움 순서 매기기
SELECT
    ROWNUM "순서",
    A.*
FROM(SELECT
        STADIUM_NAME 스타디움,
        SEAT_COUNT 좌석수
     FROM
        STADIUM
     ORDER BY SEAT_COUNT DESC) A
;

-- 030
-- 2012년 구단 승리 순으로 순위매기기
SELECT 
    A.WINNER 팀명,
    COUNT(A.WINNER) 승리
FROM(SELECT
        K.SCHE_DATE 경기날짜,
        CASE
            WHEN K.HOME_SCORE > K.AWAY_SCORE THEN HT.TEAM_NAME
            WHEN K.AWAY_SCORE > K.HOME_SCORE THEN AT.TEAM_NAME
            ELSE '무승부'
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
WHERE A.WINNER NOT LIKE '무승부'
GROUP BY A.WINNER
ORDER BY 승리 DESC
;
