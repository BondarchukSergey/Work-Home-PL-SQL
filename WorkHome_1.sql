select *
  from (select arcdate,
               dealid,
               --balance,
               (balance /
               nvl(lag(balance) over(order by arcdate, dealid), balance)) as balsum
          from (select arcdate,
                       dealid,
                       sum(usesumma) OVER(ORDER BY arcdate, dealid) as balance
                
                  from (select trunc(dd.arcdate, 'MONTH') arcdate,
                               dl.dealid,
                               sum(case
                                     when dd.dealdocumenttypeid in
                                          (1, 11, 58, 21, 80) and dd.isreversal = 0 then
                                      dd.usesumma
                                     when dd.dealdocumenttypeid in (2, 12, 20) and
                                          dd.isreversal = 0 then
                                      -dd.usesumma
                                     when dd.dealdocumenttypeid in
                                          (1, 11, 58, 21, 80) and dd.isreversal = 1 then
                                      -dd.usesumma
                                     when dd.dealdocumenttypeid in (2, 12, 20) and
                                          dd.isreversal = 1 then
                                      dd.usesumma
                                   end) usesumma
                          from dealdoctransaction dd, dealcommercialtranche dl
                         where dl.dealid = dd.dealid
                              --and dl.dealid = 11770
                           and dd.dealdocumenttypeid in
                               (1, 2, 11, 12, 20, 58, 21, 80)
                         group by trunc(dd.arcdate, 'MONTH'), dl.dealid)
                 order by arcdate)) aa pivot(avg(balsum) for arcdate in(to_date('01.07.2008',
                                                                                'dd.mm.yyyy'),
                                                                        to_date('01.12.2008',
                                                                                'dd.mm.yyyy'),
                                                                        to_date('01.06.2009',
                                                                                'dd.mm.yyyy'),
                                                                        to_date('01.11.2009',
                                                                                'dd.mm.yyyy'),
                                                                        to_date('01.12.2009',
                                                                                'dd.mm.yyyy'),
                                                                        to_date('01.10.2010',
                                                                                'dd.mm.yyyy'),
                                                                        to_date('01.02.2011',
                                                                                'dd.mm.yyyy'),
                                                                        to_date('01.03.2012',
                                                                                'dd.mm.yyyy'))) 
 
