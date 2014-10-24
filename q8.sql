select S.ssn, sum(T.get_hops(A.timeschedule, P.pathStations)) As Hops
from Tasks T, Paths P, AssignTask A, Students S
where T.taskID = A.taskID
      and P.pathname = T.pathName
      and S.ssn = A.ssn
group by S.ssn
order by sum(T.get_hops(A.timeschedule, P.pathStations));