declare
    j    int := 1;
    done int;
    --count int;
begin
    for i in (select ID, MALZEME_ID, SON_KULLANMA_TARIHI, URUN_BARKODU from STOK_HAREKET where FIS_ID = 500789783)
        loop
            sys.DBMS_OUTPUT.PUT_LINE('counter :' || j || ' malzeme id :' || i.MALZEME_ID);

            update STOK_HAREKET
            set HARDUPDATE=1,
                LOT_NO    = (select LOT_NO
                             from (select a.LOT_NO,
                                          a.SON_KULLANMA_TARIHI,
                                          to_char(a.KDVLI_FIYATI, '99999.99') as fiyat,
                                          a.URUN_BARKODU
                                   from STOK_HAREKET a,
                                        stok_fis b
                                   where a.FIS_ID = b.ID
                                     and a.MALZEME_ID = i.MALZEME_ID
                                     and a.FIS_ID != 500789783
                                     and b.G_C = 'G'
                                     and nvl(LOT_NO, '0') != '0'
                                     and b.TARIHI >= '01.01.2023'
                                     and a.SON_KULLANMA_TARIHI = nvl(i.SON_KULLANMA_TARIHI, a.SON_KULLANMA_TARIHI)
                                     and a.URUN_BARKODU = i.URUN_BARKODU
                                     and ROWNUM = 1
                                   group by a.LOT_NO, a.SON_KULLANMA_TARIHI, to_char(a.KDVLI_FIYATI, '99999.99'),
                                            a.URUN_BARKODU))
--
            where ID = i.ID;
            j := j + 1;
        end loop;
end;
