var total number
begin
select count(*) into :total from Students S where value(s) is of (master_student);
end;
/

select count(*) / :total * 100 As Percentage
from Students S, Vehicles V, Tasks T, AssignTask A
where S.driveVehicle = V.PlateNumber
      and S.SSN = A.SSN
      and A.TaskID = T.TaskID
      and value(S) is of (master_student)
      and value(V) is of (car_type)
      and value(T) is of (picture_type)
      and treat(value(V) as car_type).carType = 'Sport';