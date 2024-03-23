SELECT
--extract(month from GIRIS_TARIHI),
TO_CHAR(GIRIS_TARIHI, 'DD.MM.YYYY'),
count(distinct (MURACAAT_ID)),
MIN(BEKLEME_ZAMANI),
floor(AVG(BEKLEME_ZAMANI)),
MAX(BEKLEME_ZAMANI),
sum(BEKLEME_ZAMANI)
FROM (select FLOOR(P_UTIL.DATEDIFF('MI', BK.KTS, coalesce(bk.DEFTER_NO_KTS, bk.BASLAMA_ZAMANI))) AS BEKLEME_ZAMANI,
             PR.ADI_SOYADI,
             bk.*
      from BIRIM_KAYIT bk,
           personel pr,
           muracaat mr
      where bk.DOKTOR_ID = pr.ID
        and mr.ID = bk.MURACAAT_ID
        --and bk.BIRIM_ID = 54035
        and bk.GIRIS_TARIHI >= '01.01.2024'
        and bk.GIRIS_TARIHI < '01.02.2024'
        and nvl(bk.IPTAL, 0) = 0
        and bk.DEFTER_NO is not null)
GROUP BY
    --extract(month from GIRIS_TARIHI),
    TO_CHAR(GIRIS_TARIHI, 'DD.MM.YYYY')
order by 1;
