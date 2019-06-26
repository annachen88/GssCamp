SELECT * FROM MEMBER_M mm;
SELECT * FROM BOOK_DATA bd;
SELECT * FROM BOOK_LEND_RECORD blr ;
SELECT * FROM BOOK_CLASS bc;

/*1*/
SELECT
	blr.KEEPER_Id AS KeeperId,
	mm.USER_CNAME AS CName, 
	mm.USER_ENAME AS EName, 
	YEAR(blr.LEND_DATE) AS BorrowYear,
	COUNT(blr.BOOK_ID) AS BorrowCnt
FROM 
	BOOK_LEND_RECORD blr INNER JOIN MEMBER_M mm ON blr.CRE_USR = mm.USER_ID
GROUP BY blr.KEEPER_ID,mm.USER_CNAME, mm.USER_ENAME,YEAR(blr.LEND_DATE)
ORDER BY blr.KEEPER_ID;

/*2*/
SELECT 
	TOP 5 bd.BOOK_ID,
	bd.BOOK_NAME , 
	COUNT(bd.BOOK_ID) AS QTY 
FROM 
	BOOK_LEND_RECORD blr INNER JOIN BOOK_DATA bd ON blr.BOOK_ID = bd.BOOK_ID 
GROUP BY bd.BOOK_ID,bd.BOOK_NAME
ORDER BY QTY DESC ;

/*3*/
SELECT 
	CASE ((MONTH(blr.lend_date))-1)/3 
	WHEN 0 THEN '2019/01~2019/03' 
	WHEN 1 THEN '2019/04~2019/06'
	WHEN 2 THEN '2019/07~2019/09'
	WHEN 3 THEN '2019/10~2019/12' END AS Quarter,
	COUNT(blr.BOOK_ID) AS Cnt
FROM
	BOOK_LEND_RECORD blr
WHERE YEAR(blr.LEND_DATE)=2019
GROUP BY ((MONTH(blr.lend_date))-1)/3;

/*4*/
SELECT 
	book.Seq,
	book.BookClass,
	book.BookName,
	book.Cnt
FROM 
	(SELECT
		ROW_NUMBER()OVER(PARTITION BY bc.BOOK_CLASS_NAME ORDER BY COUNT(bd.BOOK_ID) DESC) AS [Seq],
		bc.BOOK_CLASS_NAME AS BookClass,
		bd.BOOK_ID AS BookId,
		bd.BOOK_NAME AS BookName,
		COUNT(*) AS Cnt
	FROM 
		BOOK_CLASS bc INNER JOIN BOOK_DATA bd 
	ON bc.BOOK_CLASS_ID = bd.BOOK_CLASS_ID INNER JOIN BOOK_LEND_RECORD blr 
	ON bd.BOOK_ID = blr.BOOK_ID
	GROUP BY bc.BOOK_CLASS_NAME,bd.BOOK_ID,bd.BOOK_NAME) book
WHERE book.Seq<=3;

/*5*/
SELECT
	book.BOOK_CLASS_ID AS ClassId,
	book.BOOK_CLASS_NAME AS ClassName,
	MAX(CASE book.yyyy WHEN 2016 THEN book.CNT ELSE 0 END ) AS CNT2016,
	MAX(CASE book.yyyy WHEN 2017 THEN book.CNT ELSE 0 END ) AS CNT2017,
	MAX(CASE book.yyyy WHEN 2018 THEN book.CNT ELSE 0 END ) AS CNT2018,
	MAX(CASE book.yyyy WHEN 2019 THEN book.CNT ELSE 0 END ) AS CNT2019
FROM 
	(SELECT 
		bc.BOOK_CLASS_ID,
		bc.BOOK_CLASS_NAME,
		YEAR(blr.LEND_DATE) AS yyyy,
		COUNT(blr.LEND_DATE) AS CNT
	FROM 
		BOOK_LEND_RECORD blr
		INNER JOIN BOOK_DATA bd ON blr.BOOK_ID = bd.BOOK_ID
		INNER JOIN BOOK_CLASS bc ON bd.BOOK_CLASS_ID = bc.BOOK_CLASS_ID
	GROUP BY 
		bc.BOOK_CLASS_ID,
		bc.BOOK_CLASS_NAME,
		YEAR(blr.LEND_DATE)
		HAVING YEAR(blr.LEND_DATE)>=2016
	)AS book
GROUP BY book.BOOK_CLASS_ID,
		 book.BOOK_CLASS_NAME 
ORDER BY ClassId;

/*6*/
SELECT
	pvt.ClassId ,
	pvt.ClassName,
	[2016] AS CNT2016,
	[2017] AS CNT2017,
	[2018] AS CNT2018,
	[2019] AS CNT2019
FROM(
	SELECT 
		bc.BOOK_CLASS_ID AS ClassId,
		bc.BOOK_CLASS_NAME AS ClassName,
		YEAR(blr.LEND_DATE) AS yyyy
	FROM
		BOOK_LEND_RECORD blr 
		INNER JOIN BOOK_DATA bd ON blr.BOOK_ID = bd.BOOK_ID
	    INNER JOIN BOOK_CLASS bc ON bd.BOOK_CLASS_ID = bc.BOOK_CLASS_ID) AS  D
PIVOT(COUNT(D.yyyy) FOR D.yyyy
IN([2016],[2017],[2018],[2019])) AS pvt
ORDER BY ClassId;

/*7*/
SELECT * FROM BOOK_DATA bd;
SELECT * FROM BOOK_LEND_RECORD blr;
SELECT * FROM BOOK_CLASS bc;
SELECT * FROM BOOK_CODE bc;
SELECT * FROM MEMBER_M mm;

SELECT
	bd.BOOK_ID AS 書本ID,
	FORMAT(bd.BOOK_BOUGHT_DATE,'yyyy/MM/dd') AS 購書日期,
	FORMAT(blr.LEND_DATE,'yyy/MM/dd') AS 借閱日期,
	CONCAT(bc.BOOK_CLASS_ID,'-',bc.BOOK_CLASS_NAME) AS 書籍類別,
	CONCAT(mm.USER_ID,'-',mm.USER_CNAME,'(',mm.USER_ENAME,')') AS 借閱人,
	CONCAT(bc1.CODE_ID,'-',bc1.CODE_NAME) AS 狀態,
	CONCAT(REPLACE(CONVERT(NVARCHAR(20),CAST(bd.BOOK_AMOUNT AS MONEY),1),'.00',''),'元') AS 購書金額 
FROM BOOK_DATA bd 
INNER JOIN BOOK_LEND_RECORD blr ON bd.BOOK_ID = blr.BOOK_ID
INNER JOIN MEMBER_M mm ON blr.KEEPER_ID= mm.USER_ID
INNER JOIN BOOK_CLASS bc ON bd.BOOK_CLASS_ID = bc.BOOK_CLASS_ID
INNER JOIN BOOK_CODE bc1 ON bc1.CODE_ID = bd.BOOK_STATUS
WHERE mm.USER_CNAME='李四'
ORDER BY bd.BOOK_AMOUNT DESC;

/*8*/

INSERT INTO BOOK_LEND_RECORD (BOOK_ID,KEEPER_ID,LEND_DATE) VALUES ('2004','0002',CONVERT(DATETIME,'2019/01/02'));
/*INSERT INTO BOOK_LEND_RECORD(BOOK_ID,KEEPER_ID,LEND_DATE,CRE_DATE,CRE_USR,MOD_DATE,MOD_USR) VALUES('2004','0021',CONVERT(DATETIME,'2018/07/09'),CONVERT(DATETIME,'2018/07/09'),'0021',CONVERT(DATETIME,'2018/07/09'),'0021');*/
SELECT * FROM BOOK_LEND_RECORD blr;

UPDATE BOOK_LEND_RECORD 
SET BOOK_LEND_RECORD.LEND_DATE= CONVERT(DATETIME,'2019/01/02');

/*9*/
DELETE FROM BOOK_LEND_RECORD WHERE BOOK_ID=2004 AND KEEPER_ID=0002;
SELECT * FROM BOOK_LEND_RECORD blr WHERE  blr.BOOK_ID=2004;
