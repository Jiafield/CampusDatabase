select distinct(T.taskId), T.get_hops(A.timeschedule, P.pathStations) As Hops
from Tasks T, Paths P, AssignTask A
where T.taskID = A.taskID
      and P.pathname = T.pathName
order by T.get_hops(A.timeschedule, P.pathStations) desc;