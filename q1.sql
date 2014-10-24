select s.address.streetname AS StreetName, count(*) As NumberOfStudents
from Students S
group by S.address.streetname
having count(*) >= all (select count(*)
       		        from Students S 
			group by S.address.streetname);