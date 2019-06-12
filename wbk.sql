drop table if exists
	wbkprj.ctcatch_ici_iwi;

create table
	wbkprj.ctcatch_ici_iwi
as
select
	wbkprj.nhdcatchment.featureid,
	wbkprj.nhdcatchment.geom,
	wbkprj.nhdflowline.gnis_name,
	wbkprj.ici_iwi.catareasqkm,
	wbkprj.ici_iwi.wsareasqkm,
	wbkprj.ici_iwi.ici::numeric,
	wbkprj.ici_iwi.iwi::numeric,
	(wbkprj.ici_iwi.ici::numeric+wbkprj.ici_iwi.iwi::numeric)/2 as wqindex
from
	((wbkprj.nhdcatchment
inner join
	wbkprj.ici_iwi on wbkprj.nhdcatchment.featureid = wbkprj.ici_iwi.comid::numeric)
inner join
	wbkprj.nhdflowline on wbkprj.nhdcatchment.featureid = wbkprj.nhdflowline.comid);

drop table if exists
	wbkprj.wbk;

create table
	wbkprj.wbk
as
select
	wbkprj.ctstreamflow.hydroid,
	wbkprj.ctstreamflow.geom,
	wbkprj.ctstreamflow.strahler
from
	wbkprj.ctstreamflow
where
	wbkprj.ctstreamflow.wbk = 'Yes';

select
	wbkprj.ctcatch_ici_iwi.featureid,
	wbkprj.ctcatch_ici_iwi.geom,
	wbkprj.ctcatch_ici_iwi.gnis_name,
	wbkprj.ctcatch_ici_iwi.catareasqkm,
	wbkprj.ctcatch_ici_iwi.wsareasqkm,
	wbkprj.ctcatch_ici_iwi.ici,
	wbkprj.ctcatch_ici_iwi.iwi,
	wbkprj.ctcatch_ici_iwi.wqindex,
	wbkprj.wbk.hydroid
from
	wbkprj.ctcatch_ici_iwi
join
	wbkprj.wbk
on
	st_contains(wbkprj.ctcatch_ici_iwi.geom,st_centroid(wbkprj.wbk.geom));