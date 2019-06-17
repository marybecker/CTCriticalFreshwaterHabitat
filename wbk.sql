/*Identify stream segments with high density wbk and calculate CT specific IWI index */
drop table if exists
	wbkprj.wbk;

create table
	wbkprj.wbk
as
select
	wbkprj.ctstreamflow.id,
	wbkprj.ctstreamflow.geom,
	wbkprj.ctstreamflow.hydroid,
	wbkprj.ctstreamflow.icmetric,
	wbkprj.ctstreamflow.divmetric,
	wbkprj.ctstreamflow.dammetric,
	wbkprj.ctstreamflow.stpmetric,
	((wbkprj.ctstreamflow.icmetric+wbkprj.ctstreamflow.divmetric+wbkprj.ctstreamflow.dammetric+wbkprj.ctstreamflow.stpmetric)-4)/12as iwi
from
	wbkprj.ctstreamflow
where
	wbkprj.ctstreamflow.wbk = 'Yes';

drop table if exists
	wbkprj.wbkcatchment;

/* Join wbk streams to stream catchment areas */
create table
	wbkprj.wbkcatchment
as
select
	wbkprj.wbk.hydroid,
	wbkprj.wbk.iwi,
	wbkprj.hsidata.geom,
	wbkprj.hsidata.strmi,
	wbkprj.hsidata.sqmi,
	wbkprj.hsidata.strahler
from
	wbkprj.hsidata
join
	wbkprj.wbk
on
	wbkprj.hsidata.drainid = wbkprj.wbk.hydroid;

/* spatial join to get iwi at sample point */

create table
	wbkprj.fishsites_iwi
as
select
	wbkprj.fishsites.sta_seq,
	wbkprj.fishsites.geom,
	wbkprj.fishsites.station_na as name,
	wbkprj.wbkcatchment.iwi
from
	wbkprj.fishsites
join
	wbkprj.wbkcatchment
on
	st_intersects(wbkprj.fishsites.geom,wbkprj.wbkcatchment.geom);

/* Sum WBK Stream Length */

select
	sum(st_length(wbkprj.wbk.geom))/5280
from
	wbkprj.wbk;

select
	sum(st_length(wbkprj.wbk.geom))/5280
from
	wbkprj.wbk
where
	wbkprj.wbk.iwi > 0;
