select id,
       sname,
       dealid,
       givdate,
       sum(givdate) over(partition by id order by row_n) sum_day
  from (
  select id,
               sname,
               dealid,
               givdate,
               --rank() over(partition by id order by givdate  ) rnk,
               ROW_NUMBER() over(partition by id order by givdate desc) ROW_N
          from (select cc.id,
                       cc.sname,
                       dt.dealid,
                       min(ed.documentdate) -
                       to_date('01.01.2014', 'dd.mm.yyyy') givdate
                  from dealcommercialloan    dl,
                       dealcommercialtranche dt,
                       deal                  dd,
                       contragent            cc,
                       expecteddocument      ed
                 where dl.dealid = dt.loandealid
                   and dl.dealid = dd.id
                   and dd.contragentid = cc.id
                   and dt.dealid = ed.dealid
                      --and cc.id = 121
                   and cc.id > 50
                   and ed.documentdate >= to_date('01.01.2014', 'dd.mm.yyyy')
                 group by cc.id, cc.sname, dt.dealid)
        
        )
