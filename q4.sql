var total number
begin
select count(*) into :total from Students S where value(s) is of (phD_student);
end;
/

select count(*) / :total * 100 As Percentage
from Students S, Vehicles V, Tasks T, AssignTask A
where S.driveVehicle = V.PlateNumber 
      and S.SSN = A.SSN
      and A.TaskID = T.TaskID
      and value(S) is of (phD_student)
      and value(V) is of (bicycle_type)
      and value(T) is of (video_type);
