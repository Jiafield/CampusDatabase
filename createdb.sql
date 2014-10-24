-- Create Database CampusInfos;

/* Define all the types */
Create type vehicle_type AS Object (
       PlateNumber  VARCHAR2(8),
       MaxSpeed     NUMBER,
       Year	    NUMBER,
       Maker	    VARCHAR2(15)
       )
       NOT FINAL;
/

Create type car_type Under vehicle_type (
       CarType	     VARCHAR2(10),
       Capacity	     NUMBER
       )
/

Create type bicycle_type under vehicle_type (
)
/

create type address_type AS Object (
       StreetNumber	 Number,
       StreetName	 VARCHAR2(20),
       City		 VARCHAR2(10),
       StateName	 VARCHAR2(5),
       Zip		 Number
)
/

create type phone_type As varray(5) of VARCHAR2(20)
/

Create type student_type As Object (
       SSN  		VARCHAR2(15),
       Name		VARCHAR2(15),
       DOB		Date,
       Gender		VARCHAR2(6),
       DriveVehicle	VARCHAR2(8),
       Address		address_type,
       Phones		phone_type,
       DriveSchedule	Date,
       Member Function get_age Return Number
)
Not Final;
/

Create or Replace type body student_type AS
       Member Function get_age Return Number is
       Begin
        return floor((SysDate - DOB) / 365);
       END get_age;
END;
/

Create type phD_student Under student_type(
       Program	VARCHAR2(5),
       Advisor	VARCHAR2(15)
)
/

Create type master_student Under student_type(
)
/

Create type coordinate_type As Object (
       Latitude	Number,
       Longitue	Number
)
/

Create type coordinate_list As Varray(2) of coordinate_type
/

Create type station_type AS Object (
       StationCode	 VARCHAR2(5),
       ColorCode	 VARCHAR2(10),
       Coordiante	 coordinate_type
)
/

Create type building_type AS Object(
       BuildingCode	  VARCHAR2(5),
       BuildingName	  VARCHAR2(30),
       SurfaceArea	  Number,
       Height		  Number,
       Coordinates	  coordinate_list
)
/

Create type station_list As Varray(10) of VARCHAR2(5)
/

Create type path_type As Object (
       PathName	      VARCHAR2(8),
       PathStations   Station_list,
       Member Function has_station(s Varchar2) return Integer
)
/

Create Or Replace type body path_type AS
       Member Function has_station(s Varchar2) return Integer IS
       	      i Integer;
       Begin
	    For i in 1..pathstations.count LOOP
	    	IF (pathstations(i) = s) Then
		   return 1;
	    	END IF;
	    END LOOP;
	    return 0;
       END;
END;
/

Create type Schedule_type As Object(
       StartStation	  VARCHAR2(5),
       EndStation	  VARCHAR2(5),
       StartTime	  date,
       EndTime		  date,
       DayOfWeek	  VARCHAR2(10)
)
/

Create type task_type As Object (
       TaskId	      VARCHAR2(5),       
       PathName	      VARCHAR2(8),
       PathDirection  Number,
       Member Function get_hops(s schedule_type, p station_list) return Integer
)
NOT FINAL;
/

Create Or Replace type body task_type AS
       Member Function get_hops(s schedule_type, p station_list) return Integer IS
       	     counter Integer := 0;
	     i Integer;
	     flag Integer := 0;
       BEGIN
	     IF (Pathdirection = 0) Then
	         For i in 1..p.count LOOP
		     IF (p(i) = s.startStation) Then
		     	flag := 1;
		     END IF;
		     IF (flag = 1) Then
		     	counter := counter + 1;
		     END IF;
		     IF (p(i) = s.endStation) Then
                        flag := 0;
                     END IF;
       	         END LOOP;
	     else
	         For i in 1..p.count LOOP
		     IF (p(p.count - i + 1) = s.startStation) Then
                        flag := 1;
                     END IF;
                     IF (flag = 1) Then
                        counter := counter + 1;
                     END IF;
                     IF (p(p.count - i + 1) = s.endStation) Then
                        flag := 0;
                     END IF;
		 END LOOP;
	     END IF;
	     return counter;
       END;
END;
/

Create type video_type Under task_type (
)
/

Create type picture_type Under task_type (
)
/


/* Create all the tables */
Create Table Vehicles of vehicle_type (Primary Key (PlateNumber));

Create table Students of student_type(
       Primary Key (SSN),
       Foreign Key (DriveVehicle)
               References Vehicles(PlateNumber)
               on delete Set NULL
);

Create Table Stations of station_type(
       Primary Key (StationCode)
);

Create table Buildings of building_type (
       Primary Key(BuildingCode)
);

Create table BuildingOwnStations (
       BuildingCode VARCHAR2(5),
       StationCode  VARCHAR2(5),
       Foreign key (BuildingCode) references Buildings(BuildingCode) on delete set null,
       Foreign key (StationCode) references Stations(StationCode) on delete set null
);

Create Table Paths of path_type(
       Primary Key(PathName)
);

Create Table Tasks of task_type(
       Primary Key(TaskID),
       Foreign key(PathName) references paths(Pathname) on delete cascade
);

Create Table AssignTask(
       TaskId		VARCHAR2(5),
       SSN		VARCHAR2(15),
       TimeSchedule	Schedule_type,
       Foreign Key (TaskId) references Tasks(TaskId) on delete cascade,
       Foreign Key (SSN) references Students(SSN) on delete cascade
);

Insert all
       into Vehicles Values (car_type('WEC471', 90, 1999, 'Porsche', 'Sport', 2))
       into Vehicles Values (car_type('WEC810', 80, 1999, 'Aerolite', 'Sedan', 4))
       into Vehicles Values (car_type('WEC806', 90, 2007, 'Jaguar', 'Sport', 2))
       into Vehicles Values (bicycle_type('WEC714', 1, 2004, 'Schwinn'))
       into Vehicles Values (car_type('WEC993', 80, 1999, 'Jaguar', 'Sport', 2))
       into Vehicles Values (bicycle_type('WEC542', 1, 2004, 'Schwinn'))
       into Vehicles Values (car_type('QEB665', 80, 2006, 'Ethos', 'Sedan', 4))
       into Vehicles Values (bicycle_type('QEB880', 1, 2004, 'Schwinn'))
       into Vehicles Values (car_type('QEB229', 90, 2000, 'Porsche', 'Sport', 2))
       into Vehicles Values (bicycle_type('QEB077', 1, 2006, 'Schwinn'))
       into Vehicles Values (car_type('QEB307', 80, 1999, 'Ethos', 'Sedan', 4))
       into Vehicles Values (car_type('QDB609', 100, 2004, 'Ferrari', 'Sport', 2))
       into Vehicles Values (car_type('QDA759', 100, 2000, 'Ferrari', 'Sport', 2))
       into Vehicles Values (car_type('QDA591', 60, 2000, 'Hawk', 'Sedan', 4))
       into Vehicles Values (car_type('QDA488', 70, 2001, 'Ethos', 'Sedan', 4))
       into Vehicles Values (car_type('ZDA906', 70, 2000, 'Hawk', 'Sedan', 4))
       into Vehicles Values (car_type('ZDA517', 90, 2004, 'Porsche', 'Sport', 2))
       into Vehicles Values (car_type('ZDA091', 60, 2001, 'Volvo', 'Sedan', 4))
       into Vehicles Values (bicycle_type('ZDA174', 1, 2004, 'Schwinn'))
       into Vehicles Values (car_type('ZDA429', 70, 1999, 'Aerolite', 'Sedan', 4))
select 1 from dual;
/*
select plateNumber, maxspeed, year, maker, treat(value(v) as car_type).cartype as cartype,  treat(value(v) as car_type).capacity as capacity
from Vehicles v where value(v) is of (car_type)
union
select plateNumber, maxspeed, year, maker, 'Bicycle', NULL from vehicles v where value(v) is of (bicycle_type);
*/

Insert all
       into Students Values (phD_student('111-00-1111', 'Rylan', To_Date('01-Apr-68'), 'M', 'ZDA429', address_type(1276, 'Grand Ave', 'LA', 'CA', 90089), phone_type('213-740-1111', '213-740-1112'), TO_DATE('15-Feb-2006 12:00:00', 'DD-MON-YYYY HH:MI:SS'), 'CS', 'Aksoy'))
       into Students Values (phD_student('111-00-2222', 'Joshua', To_Date('01-Apr-70'), 'M', 'ZDA174', address_type(675, 'S Figueroa', 'LA', 'CA', 90017), phone_type('213-740-2222'), TO_DATE('15-Feb-2006 12:00:00','DD-MON-YYYY HH:MI:SS'), 'CS', 'Shahabi'))
       into Students Values (phD_student('111-00-3333', 'Allen', To_Date('01-Apr-69'), 'F', 'ZDA091', address_type(200, '7th Street', 'LA', 'CA', 90210), phone_type('7th Street'), To_Date('15-Feb-2006 12:00:00', 'DD-MON-YYYY HH:MI:SS'), 'EE', 'Demir'))
       into Students Values (phD_student('111-00-4444', 'Aidan', To_Date('01-Apr-85'), 'M', 'ZDA517', address_type(345, 'MG Road', 'LA', 'CA', 90210), phone_type('213-740-4444', '213-740-4445'), To_Date('15-Feb-2006 12:00:00', 'DD-MON-YYYY HH:MI:SS'), 'EE', 'Marin'))
       into Students Values (phD_student('111-00-5555', 'Aiden', To_Date('01-Apr-82'), 'M', 'ZDA906', address_type(375, 'S Figueroa', 'LA', 'CA', 90017), phone_type('213-740-5555'), To_Date('15-Feb-2006 12:00:00', 'DD-MON-YYYY HH:MI:SS'), 'CS', 'Shahabi'))
       into Students Values (master_student('111-00-6666', 'Barak', To_Date('01-Apr-79'), 'F', 'QDA488', address_type(675, 'S Figueroa', 'LA', 'CA', 90017), phone_type('213-740-6666'), TO_DATE('15-Feb-2006 12:00:00', 'DD-MON-YYYY HH:MI:SS')))
       into Students Values (master_student('111-00-7777', 'Basil', To_Date('01-Apr-78'), 'M', 'QDA591', address_type(341, 'MG Road', 'LA', 'CA', 90210), phone_type('213-740-7777'), To_Date('15-Feb-2006 12:00:00', 'DD-MON-YYYY HH:MI:SS')))
       into Students Values (master_student('111-00-8888', 'Cayden', To_Date('01-Apr-75'), 'F', 'QDA759', address_type(675, 'S Figueroa', 'LA', 'CA', 90017), phone_type('213-740-8888', '213-740-8889'), To_Date('15-Feb-2006 12:00:00', 'DD-MON-YYYY HH:MI:SS')))
       into Students Values (master_student('111-00-9999', 'Brendon', To_Date('01-Apr-72'), 'M', 'QDB609', address_type(235, '6th Street', 'LA', 'CA', 90007), phone_type('213-740-9999'), To_Date('15-Feb-2006 12:00:00', 'DD-MON-YYYY HH:MI:SS')))
       into Students Values (master_student('111-00-0000', 'Nate', To_Date('01-Apr-73'), 'M', 'QEB307', address_type(127, 'Grand Ave', 'LA', 'CA', 90089), phone_type('213-740-0000'), To_Date('15-Feb-2006 12:00:00', 'DD-MON-YYYY HH:MI:SS')))
       into Students Values (master_student('111-11-1111', 'Hannah', To_Date('01-Apr-65'), 'F', 'QEB077', address_type(200, 'Irving Blvd', 'LA', 'CA', 90210), phone_type('213-741-1111'), To_Date('15-Feb-2006 12:00:00', 'DD-MON-YYYY HH:MI:SS')))
       into Students Values (master_student('111-11-2222', 'Zoe', To_Date('01-Apr-62'), 'F', 'QEB229', address_type(235, '7th Street', 'LA', 'CA', 90007), phone_type('213-741-2222'), To_Date('15-Feb-2006 12:00:00', 'DD-MON-YYYY HH:MI:SS')))
       into Students Values (phD_student('111-11-3333', 'Alexis', To_Date('01-Apr-63'), 'M', 'QEB880', address_type(675, 'S Figueroa', 'LA', 'CA', 90017), phone_type('213-741-3333'), To_Date('15-Feb-2006 12:00:00', 'DD-MON-YYYY HH:MI:SS'), 'CS', 'Metzker'))
       into Students Values (phD_student('111-11-4444', 'Madison', To_Date('01-Apr-75'), 'F', 'QEB665', address_type(345, 'MG Road', 'LA', 'CA', 90210), phone_type('213-741-4444'), To_Date('15-Feb-2006 12:00:00', 'DD-MON-YYYY HH:MI:SS'), 'CS', 'Fujihara'))
       into Students Values (phD_student('111-11-5555', 'Adalgisa', To_Date('01-Apr-76'), 'M', 'WEC542', address_type(310, 'S Figueroa', 'LA', 'CA', 90017), phone_type('213-741-5555'), To_Date('15-Feb-2006 12:00:00', 'DD-MON-YYYY HH:MI:SS'), 'EE', 'Kuehn'))
       into Students Values (phD_student('111-11-6666', 'Cora', To_Date('01-Apr-77'), 'M', 'WEC993', address_type(235, '6th Street', 'LA', 'CA', 90007), phone_type('213-741-6666', '213-741-6667'), To_Date('15-Feb-2006 12:00:00', 'DD-MON-YYYY HH:MI:SS'), 'CS', 'Carter'))
       into Students Values (phD_student('111-11-7777', 'Adalia', To_Date('01-Apr-82'), 'F', 'WEC714', address_type(127, 'Grand Ave', 'LA', 'CA', 90089), phone_type('213-741-7777'), To_Date('15-Feb-2006 12:00:00', 'DD-MON-YYYY HH:MI:SS'), 'EE', 'Demir'))
       into Students Values (phD_student('111-11-8888', 'Ava', To_Date('01-Apr-83'), 'F', 'WEC806', address_type(200, '5th Street', 'LA', 'CA', 90210), phone_type('213-741-8888', '213-741-8889'), To_Date('15-Feb-2006 12:00:00', 'DD-MON-YYYY HH:MI:SS'), 'EE', 'Benson'))
       into Students Values (phD_student('111-11-9999', 'Celia', To_Date('01-Apr-86'), 'M', 'WEC810', address_type(675, 'S Figueroa', 'LA', 'CA', 90017), phone_type('213-741-9999'), To_Date('15-Feb-2006 12:00:00', 'DD-MON-YYYY HH:MI:SS'), 'EE', 'Demir'))
       into Students Values (phD_student('111-11-0000', 'Zaida', To_Date('01-Apr-83'), 'F', 'WEC471', address_type(127, 'Grand Ave', 'LA', 'CA', 90089), phone_type('213-741-0000'), To_Date('15-Feb-2006 12:00:00', 'DD-MON-YYYY HH:MI:SS'), 'CS', 'Joy'))
Select 1 from dual;

-- Select * from Students;

Insert all
       into Stations Values (station_type('s1', 'green', coordinate_type(NULL, NULL)))
       into Stations Values (station_type('s2', 'yellow', coordinate_type(NULL, NULL)))
       into Stations Values (station_type('s3', 'red', coordinate_type(NULL, NULL)))
       into Stations Values (station_type('s4', 'black', coordinate_type(NULL, NULL)))
       into Stations Values (station_type('s5', 'purple', coordinate_type(NULL, NULL)))
       into Stations Values (station_type('s6', 'green', coordinate_type(NULL, NULL)))
       into Stations Values (station_type('s7', 'red', coordinate_type(NULL, NULL)))
       into Stations Values (station_type('s8', 'yellow', coordinate_type(NULL, NULL)))
       into Stations Values (station_type('s9', 'white', coordinate_type(NULL, NULL)))
       into Stations Values (station_type('s10', 'cyan', coordinate_type(NULL, NULL)))
       into Stations Values (station_type('s11', 'green', coordinate_type(NULL, NULL)))
       into Stations Values (station_type('s12', 'yellow', coordinate_type(NULL, NULL)))
       into Stations Values (station_type('s13', 'purple', coordinate_type(NULL, NULL)))
       into Stations Values (station_type('s14', 'black', coordinate_type(NULL, NULL)))
       into Stations Values (station_type('s15', 'white', coordinate_type(NULL, NULL)))
       into Stations Values (station_type('s16', 'blue', coordinate_type(NULL, NULL)))
       into Stations Values (station_type('s17', 'green', coordinate_type(NULL, NULL)))
       into Stations Values (station_type('s18', 'blue', coordinate_type(NULL, NULL)))
       into Stations Values (station_type('s19', 'red', coordinate_type(NULL, NULL)))
       into Stations Values (station_type('s20', 'black', coordinate_type(NULL, NULL)))
       into Stations Values (station_type('s21', 'green', coordinate_type(NULL, NULL)))
       into Stations Values (station_type('s22', 'yellow', coordinate_type(NULL, NULL)))
       into Stations Values (station_type('s23', 'white', coordinate_type(NULL, NULL)))
       into Stations Values (station_type('s24', 'purple', coordinate_type(NULL, NULL)))
       into Stations Values (station_type('s25', 'black', coordinate_type(NULL, NULL)))
       into Stations Values (station_type('s26', 'red', coordinate_type(NULL, NULL)))
select 1 from dual;

-- select * from stations;

Insert all
       into Buildings Values(building_type('KOH', 'King Olympic Hall', 400, 25, coordinate_list(coordinate_type(Null, Null), coordinate_type(Null, Null))))
       into Buildings Values(building_type('CFX', 'Cromwell Field', 800, 30, coordinate_list(coordinate_type(Null, Null), coordinate_type(Null, Null))))
       into Buildings Values(building_type('JEP', 'JEP House', 400, 30, coordinate_list(coordinate_type(Null, Null), coordinate_type(Null, Null))))
       into Buildings Values(building_type('SHC', 'Student Health Center', 1000, 25, coordinate_list(coordinate_type(Null, Null), coordinate_type(Null, Null))))
       into Buildings Values(building_type('LVY', 'Leavey Library', 800, 30, coordinate_list(coordinate_type(Null, Null), coordinate_type(Null, Null))))
       into Buildings Values(building_type('VKC', 'Von KleinSmid Center', 400, 30, coordinate_list(coordinate_type(Null, Null), coordinate_type(Null, Null))))
       into Buildings Values(building_type('WPH', 'Waite Phillips Hall', 1500, 30, coordinate_list(coordinate_type(Null, Null), coordinate_type(Null, Null))))
       into Buildings Values(building_type('JHH', 'John Hubbard Hall', 1000, 25, coordinate_list(coordinate_type(Null, Null), coordinate_type(Null, Null))))
       into Buildings Values(building_type('REG', 'Registration Builing', 400, 30, coordinate_list(coordinate_type(Null, Null), coordinate_type(Null, Null))))
       into Buildings Values(building_type('STU', 'Student Union', 80, 50, coordinate_list(coordinate_type(Null, Null), coordinate_type(Null, Null))))
       into Buildings Values(building_type('BKS', 'Bookstore', 800, 20, coordinate_list(coordinate_type(Null, Null), coordinate_type(Null, Null))))
       into Buildings Values(building_type('RTH', 'Ronald Tutor Hall', 400, 20, coordinate_list(coordinate_type(Null, Null), coordinate_type(Null, Null))))
       into Buildings Values(building_type('SAL', 'Salvatori Com. Center', 400, 20, coordinate_list(coordinate_type(Null, Null), coordinate_type(Null, Null))))
       into Buildings Values(building_type('EEB', 'Electrical Engr Center', 800, 30, coordinate_list(coordinate_type(Null, Null), coordinate_type(Null, Null))))
       into Buildings Values(building_type('OHE', 'Olin Hall Engineering', 1000, 20, coordinate_list(coordinate_type(Null, Null), coordinate_type(Null, Null))))
select 1 from dual;

-- select * from buildings;

Insert all
       into BuildingOwnStations Values('KOH', 's1')
       into BuildingOwnStations Values('KOH', 's2')
       into BuildingOwnStations Values('CFX', 's3')
       into BuildingOwnStations Values('CFX', 's4')
       into BuildingOwnStations Values('CFX', 's5')
       into BuildingOwnStations Values('JEP', 's6')
       into BuildingOwnStations Values('SHC', 's7')
       into BuildingOwnStations Values('LVY', 's8')
       into BuildingOwnStations Values('LVY', 's9')
       into BuildingOwnStations Values('VKC', 's10')
       into BuildingOwnStations Values('WPH', 's11')
       into BuildingOwnStations Values('JHH', 's12')
       into BuildingOwnStations Values('REG', 's13')
       into BuildingOwnStations Values('STU', 's14')
       into BuildingOwnStations Values('STU', 's15')
       into BuildingOwnStations Values('BKS', 's16')
       into BuildingOwnStations Values('BKS', 's17')
       into BuildingOwnStations Values('RTH', 's18')
       into BuildingOwnStations Values('RTH', 's19')
       into BuildingOwnStations Values('SAL', 's20')
       into BuildingOwnStations Values('SAL', 's21')
       into BuildingOwnStations Values('EEB', 's22')
       into BuildingOwnStations Values('EEB', 's23')
       into BuildingOwnStations Values('OHE', 's24')
       into BuildingOwnStations Values('OHE', 's25')
       into BuildingOwnStations Values('OHE', 's26')
select 1 from dual;

-- select * from buildingOwnStations;

Insert all 
       into Paths Values ('PathA', station_list('s8', 's6', 's7', 's1'))
       into Paths Values ('PathB', station_list('s2', 's3', 's24', 's18', 's22'))
       into Paths Values ('PathC', station_list('s9', 's11', 's10', 's14', 's16', 's4', 's25', 's20'))
       into Paths Values ('PathD', station_list('s13', 's12', 's15', 's17', 's5'))
       into Paths Values ('PathE', station_list('s26', 's19', 's23', 's21'))
select 1 from dual;

--select * from Paths;

Insert all
      into Tasks Values (picture_type('t1', 'PathA', 0))
      into Tasks Values (video_type('t2', 'PathB', 1))
      into Tasks Values (picture_type('t3', 'PathC', 1))
      into Tasks Values (video_type('t4', 'PathD', 0))
      into Tasks Values (picture_type('t5', 'PathE', 0))
      into Tasks Values (picture_type('t6', 'PathC', 0))
      into Tasks Values (video_type('t7', 'PathB', 0))
      into Tasks Values (picture_type('t8', 'PathD', 0))
      into Tasks Values (video_type('t9', 'PathB', 0))
      into Tasks Values (picture_type('t10', 'PathE', 1))
select 1 from dual;

-- select * from tasks;

Insert all
       into AssignTask Values('t1', '111-00-1111', schedule_type('s6', 's1', To_date('10:00', 'HH24:MI'), To_date('11:00', 'HH24:MI'), 'Tuesday'))
       into AssignTask Values('t1', '111-00-5555', schedule_type('s6', 's1', To_date('10:00', 'HH24:MI'), To_date('11:00', 'HH24:MI'), 'Thursday'))
       into AssignTask Values('t2', '111-00-2222', schedule_type('s22', 's24', To_date('11:00', 'HH24:MI'), To_date('13:00', 'HH24:MI'), 'Tuesday'))
       into AssignTask Values('t2', '111-00-3333', schedule_type('s22', 's24', To_date('11:00', 'HH24:MI'), To_date('13:00', 'HH24:MI'), 'Thursday'))
       into AssignTask Values('t3', '111-00-5555', schedule_type('s14', 's9', To_date('10:00', 'HH24:MI'), To_date('12:00', 'HH24:MI'), 'Monday'))
       into AssignTask Values('t3', '111-00-6666', schedule_type('s14', 's9', To_date('10:00', 'HH24:MI'), To_date('12:00', 'HH24:MI'), 'Wednesday'))
       into AssignTask Values('t3', '111-00-7777', schedule_type('s14', 's9', To_date('10:00', 'HH24:MI'), To_date('12:00', 'HH24:MI'), 'Friday'))
       into AssignTask Values('t4', '111-00-4444', schedule_type('s13', 's17', To_date('10:00', 'HH24:MI'), To_date('12:00', 'HH24:MI'), 'Monday'))
       into AssignTask Values('t5', '111-00-8888', schedule_type('s26', 's21', To_date('12:00', 'HH24:MI'), To_date('14:00', 'HH24:MI'), 'Monday'))
       into AssignTask Values('t5', '111-00-9999', schedule_type('s26', 's21', To_date('12:00', 'HH24:MI'), To_date('14:00', 'HH24:MI'), 'Wednesday'))
       into AssignTask Values('t5', '111-11-1111', schedule_type('s26', 's21', To_date('12:00', 'HH24:MI'), To_date('14:00', 'HH24:MI'), 'Friday'))
       into AssignTask Values('t6', '111-00-0000', schedule_type('s14', 's25', To_date('13:00', 'HH24:MI'), To_date('14:00', 'HH24:MI'), 'Tuesday'))
       into AssignTask Values('t6', '111-11-2222', schedule_type('s14', 's25', To_date('13:00', 'HH24:MI'), To_date('14:00', 'HH24:MI'), 'Thursday'))
       into AssignTask Values('t7', '111-11-3333', schedule_type('s2', 's3', To_date('14:00', 'HH24:MI'), To_date('16:00', 'HH24:MI'), 'Tuesday'))
       into AssignTask Values('t7', '111-11-4444', schedule_type('s2', 's3', To_date('14:00', 'HH24:MI'), To_date('16:00', 'HH24:MI'), 'Thursday'))
       into AssignTask Values('t8', '111-11-5555', schedule_type('s15', 's5', To_date('14:00', 'HH24:MI'), To_date('15:00', 'HH24:MI'), 'Monday'))
       into AssignTask Values('t8', '111-11-6666', schedule_type('s15', 's5', To_date('14:00', 'HH24:MI'), To_date('15:00', 'HH24:MI'), 'Wednesday'))
       into AssignTask Values('t8', '111-11-7777', schedule_type('s15', 's5', To_date('14:00', 'HH24:MI'), To_date('15:00', 'HH24:MI'), 'Friday'))
       into AssignTask Values('t9', '111-11-8888', schedule_type('s24', 's18', To_date('16:00', 'HH24:MI'), To_date('18:00', 'HH24:MI'), 'Tuesday'))
       into AssignTask Values('t9', '111-11-9999', schedule_type('s24', 's18', To_date('16:00', 'HH24:MI'), To_date('18:00', 'HH24:MI'), 'Thursday'))
       into AssignTask Values('t10', '111-11-0000', schedule_type('s21', 's23', To_date('9:00', 'HH24:MI'), To_date('10:00', 'HH24:MI'), 'Tuesday'))
       into AssignTask Values('t10', '111-11-4444', schedule_type('s21', 's23', To_date('9:00', 'HH24:MI'), To_date('10:00', 'HH24:MI'), 'Thursday'))
Select 1 from dual;

-- select * from AssignTask;