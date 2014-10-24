select S.SSN, S.name, S.get_age() As Age, S.address.streetname
from students s
where S.DOB >= all (select S2.DOB from students S2 where S2.address.streetName = S.address.streetName);