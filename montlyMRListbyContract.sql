with liste
         as (select distinct t.id,
                             (case
                                  when c.tarihi > '01.06.2021' and t.tetkik_grup_id in (100, 101)
                                      then t.yeni_fatura_kodu
                                  else t.fatura_kodu end)           fatura_kodu,
                             t.adi,
                             --b.adi                                  birim_id,
                             --b.id                                   birim_idd,
                             --o.adi                                  oda,
                             coalesce(lo.kabul_oda_id, lk.birim_id) kabul_oda_id,
                             min(lo.muracaat_id)                    muracaat_id,
                             count(*)                               sayi,
                             count(distinct lk.hasta_id)            hasta_sayi
             from lab_ornek lo
                      left outer join lab_kayit lk on lo.lab_kayit_id = lk.id
                      left outer join cari c on C.LAB_ORNEK_ID = LO.ID
                      left outer join tetkik t on C.TETKIK_ID = T.ID
                      left outer join muracaat m on LO.MURACAAT_ID = M.ID
                      left outer join hasta h on LO.HASTA_ID = H.ID
             --left outer join birim b on lk.birim_id = b.id
             --left outer join oda o on o.id = lo.kabul_oda_id
             where trunc(c.ONAY_KTS) >= '01.02.2024'
               and trunc(c.ONAY_KTS) < '01.03.2024'
               and c.ONAY_KTS is not null
               and t.TETKIK_GRUP_ID in (100)
             group by t.id,
                      (case
                           when c.tarihi > '01.06.2021' and t.tetkik_grup_id in (100, 101) then t.yeni_fatura_kodu
                           else t.fatura_kodu end),
                      t.adi,
                      --b.adi,
                      --b.id, o.adi,
                      coalesce(lo.kabul_oda_id, lk.birim_id)
             order by fatura_kodu)
select distinct l.fatura_kodu,
                l.adi,
                l.sayi,
                l.hasta_sayi,
                TO_NUMBER(
                        (select to_number(u1)
                         from HIZMET_FIYAT tf
                         where tf.fiyat_kodu = l.fatura_kodu
                           and tf.id = (select max(tf1.id)
                                        from HIZMET_FIYAT tf1
                                        where tf1.fiyat_kodu = tf.fiyat_kodu
                                          and tf1.fiyat_turu = 1)
                           and tf.fiyat_turu = 1))                                       fiyati,
                (select to_number(fiyati)
                 from table (p_fiyat.TETKIK_FIYAT(l.id, trunc(sysdate), 0, 0, 0, 1, 0))) nt_fiyat
from liste l;
