'- Tìm số tiền đầu tư vào mỗi tỉnh trong năm? Tỉnh nào được đầu tư nhiều nhất?'
SELECT  TỈNH, SUM(ĐẦU_TƯ) AS TỔNG_ĐẦU_TƯ
FROM  DAUTU
GROUP BY  TỈNH

UPDATE DAUTU
SET TỈNH = 'Bà Rịa - Vũng Tàu'
WHERE TỈNH = 'BRVT';


SELECT  TỈNH,  TỔNG_ĐẦU_TƯ
FROM 
    (SELECT TỈNH,  SUM(ĐẦU_TƯ) AS TỔNG_ĐẦU_TƯ
     FROM  DAUTU
     GROUP BY  TỈNH
     ORDER BY TỔNG_ĐẦU_TƯ DESC)
WHERE 
    ROWNUM = 1;
'- Tìm Doanh thu sinh ra từ mỗi tỉnh này trong năm?'

SELECT TỈNH, SUM(DOANH_THU) AS TỔNG_DOANH_THU
FROM DOANHTHU
GROUP BY TỈNH;

UPDATE DOANHTHU
SET TỈNH = 'Bà Rịa - Vũng Tàu'
WHERE TỈNH = 'BR-VT';

'- Theo công thức  ROI= (Doanh Thu - Tiền đầu tư) / Tiền đầu tư; tìm số ROI của mỗi tỉnh theo từng tháng, năm'
SELECT 
    D.TỈNH,
    D.THÁNG,
    D.NĂM,
    SUM(D.DOANH_THU) AS TỔNG_DOANH_THU,
    SUM(DT.ĐẦU_TƯ) AS TỔNG_ĐẦU_TƯ,
    (SUM(D.DOANH_THU) - SUM(DT.ĐẦU_TƯ)) / SUM(DT.ĐẦU_TƯ) AS ROI
FROM 
    DOANHTHU D
JOIN 
    DAUTU DT
ON 
    D.TỈNH = DT.TỈNH AND 
    D.THÁNG = DT.THÁNG AND 
    D.NĂM = DT.NĂM
GROUP BY 
    D.TỈNH, D.THÁNG, D.NĂM;
    
    '- Tìm: Số tiền đầu tư vào mỗi Khách hàng cấp 1 và doanh thu được tạo ra trong năm? '
SELECT 
    D.KHÁCH_HÀNG_C1, D.NĂM,
    SUM(DT.ĐẦU_TƯ) AS TỔNG_ĐẦU_TƯ,
    SUM(D.DOANH_THU) AS TỔNG_DOANH_THU
FROM 
    DOANHTHU D
JOIN 
    DAUTU DT
ON 
    D.KHÁCH_HÀNG_C1 = DT.KHÁCH_HÀNG_C1 AND
     D.NĂM = DT.NĂM
GROUP BY 
    D.KHÁCH_HÀNG_C1,     D.NĂM
ORDER BY
    D.KHÁCH_HÀNG_C1,    D.NĂM ;
    
'- Tìm Số lượng nông dân trong hệ thống của mỗi Khách hàng cấp 2, khách hàng nào có số nông dân cao nhất?'
SELECT  KHÁCH_HÀNG_C2,
SUM(SL_NÔNG_DÂN) AS TỔNG_SL_NÔNG_DÂN
FROM DAUTU
GROUP BY KHÁCH_HÀNG_C2

SELECT  KHÁCH_HÀNG_C2,  TỔNG_SL_NÔNG_DÂN
FROM 
    (SELECT KHÁCH_HÀNG_C2,  SUM(ĐẦU_TƯ) AS TỔNG_SL_NÔNG_DÂN
     FROM  DAUTU
     GROUP BY  KHÁCH_HÀNG_C2
     ORDER BY TỔNG_SL_NÔNG_DÂN DESC)
WHERE 
    ROWNUM = 1;
'- Có bao nhiêu khách hàng mà công ty đầu tư nhưng không tạo ra doanh thu trong năm?'
SELECT 
    COUNT(DISTINCT DT.KHÁCH_HÀNG_C1) AS SỐ_KHÁCH_HÀNG_C1,
    COUNT(DISTINCT DT.KHÁCH_HÀNG_C2) AS SỐ_KHÁCH_HÀNG_C2
FROM 
    DAUTU DT
LEFT JOIN 
    DOANHTHU DH
ON 
    DT.KHÁCH_HÀNG_C1 = DH.KHÁCH_HÀNG_C1 
    AND DT.NĂM = DH.NĂM 
    AND DT.KHÁCH_HÀNG_C2 = DH.KHÁCH_HÀNG_C2
WHERE  
     DH.KHÁCH_HÀNG_C1 IS NULL 
    AND DH.KHÁCH_HÀNG_C2 IS NULL;