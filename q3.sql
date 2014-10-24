select min(S.get_age()) AS MinAge, max(S.get_age()) AS MaxAge, avg(S.get_age()) AS AvgAge
from Students S
where S.SSN in (select distinct(A.SSN) from AssignTask A group by A.SSN having count(*) >= 2)
      and value(S) is of (phD_student);
