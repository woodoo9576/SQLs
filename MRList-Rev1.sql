
SELECT --A.*,
       A.fatura_kodu,
       A.ADI,
       A.sayi,
       A.hasta_sayi,
       (select replace(fiyati, '.', ',')
        from table (p_fiyat.TETKIK_FIYAT(A.ID, A.CARI_TARIHI, A.muracaat_id, 0, 0, 1, 0))) as fiyati,
       (select REPLACE(ISLEM_PUANI, '.', ',')
        from table (p_fiyat.TETKIK_FIYAT(A.ID, A.CARI_TARIHI, A.muracaat_id, 0, 0, 1, 0))) AS BIRIM_PUANI,
       (select REPLACE(ISLEM_pUANI, '.', ',')
        FROM table (p_fiyat.TETKIK_FIYAT(A.ID, '10.05.2024', a.muracaat_id, 0, 0, 1, 0)))  as ihale_zamani_puani
FROM (select distinct t.id,
                      (case
                           when c.tarihi > '01.06.2021' and t.tetkik_grup_id in (100, 101)
                               then t.yeni_fatura_kodu
                           else t.fatura_kodu end)                                                          fatura_kodu,
                      t.adi,
                      --b.adi                                  birim_id,
                      --b.id                                   birim_idd,
                      --o.adi                                  oda,
                      coalesce(lo.kabul_oda_id, lk.birim_id)                                                kabul_oda_id,
                      min(lo.muracaat_id)                                                                   muracaat_id,
                      count(*)                                                                              sayi,
                      count(distinct lk.hasta_id)                                                           hasta_sayi,
                      CASE WHEN TRUNC(C.ONAY_KTS) > '10.05.2024' THEN '11.05.2024' ELSE '10.05.2024' END AS CARI_TARIHI
      from lab_ornek lo
               left outer join lab_kayit lk on lo.lab_kayit_id = lk.id
               left outer join cari c on C.LAB_ORNEK_ID = LO.ID
               left outer join tetkik t on C.TETKIK_ID = T.ID
               left outer join muracaat m on LO.MURACAAT_ID = M.ID
               left outer join hasta h on LO.HASTA_ID = H.ID
      --left outer join birim b on lk.birim_id = b.id
--left outer join oda o on o.id = lo.kabul_oda_id
      where trunc(c.ONAY_KTS) >= '01.07.2024'
        and trunc(c.ONAY_KTS) < '01.08.2024'
        and c.ONAY_KTS is not null
        and t.TETKIK_GRUP_ID in (100)
      group by t.id,
               (case
                    when c.tarihi > '01.06.2021' and t.tetkik_grup_id in (100, 101) then t.yeni_fatura_kodu
                    else t.fatura_kodu end),
               t.adi,
               --b.adi,
               --b.id, o.adi,
               coalesce(lo.kabul_oda_id, lk.birim_id),
               (CASE WHEN TRUNC(C.ONAY_KTS) > '10.05.2024' THEN '11.05.2024' ELSE '10.05.2024' END)

      order by fatura_kodu) A;
