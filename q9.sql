select S.SSN, S.name, S2.Hops As Hops, V.plateNumber As PlateNum, S.address As Address --S.address.streetnumber As StNum, S.address.streetName As StName, S.address.city As City, S.address.stateName As State, S.address.zip As Zip
from Students S, Vehicles V, (select * 
     	      	 	     from (select S.ssn As SSN, sum(T.get_hops(A.timeschedule, P.pathStations)) As Hops
			     from Students S, Tasks T, Paths P, AssignTask A
			     where T.taskID = A.taskID
			           and P.pathname = T.pathName
				   and S.ssn = A.ssn
			     group by S.ssn
			     order by sum(T.get_hops(A.timeschedule, P.pathStations)) desc)
			     where rownum <= 1) S2
where S.ssn = S2.ssn and S.driveVehicle = V.platenumber;