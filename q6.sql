-- Find the largest surface-area building which owns at least 3 stations. List all the paths which include alt least one station of this building. (Your answer should include Building_Code, Surface_Area, Path_Name, Station)

select B2.BuildingCode, B2.surfacearea, O.stationcode, P.pathname
from Paths P, BuildingOwnStations O, (select *
     	       	      	       	     from (select B.buildingCode As BuildingCode, max(B.surfacearea) As SurfaceArea
				            from Buildings B, BuildingOwnStations O
					    where B.buildingCode = O.buildingCode
					    group by B.buildingCode
					    having count(*) >= 3
					    order by surfaceArea desc)
		  	  	     where Rownum <= 1) B2
where O.buildingCode = B2.buildingCode
      and P.has_station(O.stationcode) = 1;