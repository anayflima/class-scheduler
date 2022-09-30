%*
course/2(course id, number of weekly coursees)
----------------------------------------------
Identifies a course by name and number of weekly classes.
*%
course(macAAA, 2).
course(macBBB, 3).

%*
course/1(course id)
-------------------
Alias to course/2.
*%
course(X) :- course(X, _).

%*
Restriction #(restriction identifier)
-------------------------------------
A class cannot be defined with two different number of weekly classes.
NOTE: we maybe could expand this to contemplate all cases were two courses have
the same course id.
*%
:- course(C, H1), course(C, H2), H1 != H2.

%*
teacher/1(teacher name)
-----------------------
Identifies a teacher by name.
*%
teacher(profAAA).
teacher(profBBB).

%*
lectures(teacher name, course id)
--------------------------------
Assign a teacher as the instructor of a class.
*%
lectures(profAAA, macAAA).
lectures(profBBB, macBBB).

%*
Restriction #(restriction identifier)
-------------------------------------
A course always should have an instructor.
*%
:- course(D), not lectures(_, D).

%*
day_of_week/1(day id)
---------------------
Identifies all week days that can have classes scheduled.
*%
day_of_week(thu).
day_of_week(fri).

%*
period/2(period id, part of the day)
------------------------------------
Identifies the time periods that are available to classes every day of the week,
and the related part of the day.

Example:
mor1("morning 1") -> 8 to 10
aft1("afternoon 1") -> 14 to 16
*%
period(mor1, morning).
period(aft1, afternoon).

%*
period/1(period id)
-------------------
Alias to period/2.
*%
period(P) :- period(P, _).

%*
Restriction #(restriction identifier)
-------------------------------------
Two periods cannot be from diferent parts of the day.
*%
:- period(P, PD1), period(P, PD2), PD1 != PD2.

%*
class/3(course id, day of week, period)
---------------------------------------
Schedule N classes of a given course.
*%
{ class(C, D, P) : day_of_week(D), period(P) } == N :- course(C, N).

%*
conflict(course id 1, course id 2, day of week, period)
-------------------------------------------------------
Indicates a conflict between 2 classes of diferent courses.
*%
conflict(C1, C2, D, P) :- class(C1, D, P), class(C2, D, P), C1 != C2.

%*
Restriction #(restriction identifier)
-------------------------------------
No classes can be scheduled on friday in the afternoon.
*%
:- class(_, fri, P), period(P, afternoon).

%*
Restriction #(restriction identifier)
-------------------------------------
Two classes lectured by the same teacher cannot conflict.
*%
:- lectures(T, C1), lectures(T, C2), conflict(C1, C2, _, _).

#show class/3.
