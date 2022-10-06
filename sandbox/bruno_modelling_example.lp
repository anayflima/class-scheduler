% X courses
% courses(4).
% 5 days
%days(2).
% 4 periods per day
%periods_per_day(4).

%*
Defining courses
    course(C, T, N)
        Course C, Taught by a teacher T has N lectures
*%
course("Automatos", "Alair", 2).
course("LabXP", "Gold", 2).
course("Paralelo", "Gold", 2).
course("Agrupamento", "Hruschka", 2).

%*
Defining curricula
    curricula(Cu, C)
        Curricula Cu, Course C
*%
curricula("Obligatory", "Automatos").
curricula("Obligatory", "Paralelo").
curricula("Optional", "LabXP").
curricula("Optional", "Agrupamento").

days(1).
periods_per_day(4).

% Auxiliary Rules
c(C) :- course(C,_,_).
t(T) :- course(_,T,_).
cu(Cu) :- curricula(Cu,_).
d(0..D-1) :- days(D). % Expressing that days are integers in the range 0 to D-1
ppd(0..P-1) :- periods_per_day(P). % Expressing that periods per day are integers in the range 0 to P-1

%*
Protection rules
Not directly constraints, but used to safeguard against wrong inputs
P1: A class cannot be difined with two different number of lectures
*%
:- course(C,_,N1), course(C,_,N2), N1 != N2.

%*
HC1: All the semester's classes must be allocated
For every course C having N lectures, generates a solution candidate at first
and then constrains that there are exactly N lectures sucha that assigned(C,D,P)
holds.
*%
N { assigned(C,D,P) : d(D), ppd(P) } N :- course(C,_,N).

%*
HC2: A teacher cannot give multiple classes at the same time
For every teacher T, day D, and periods P, there is at most one course C
taught by T such that assigned(C,D,P) holds.
*%
:- not { assigned(C,D,P) : course(C,T,_) } 1, t(T), d(D), ppd(P).

%*
HC3: Obligatory classes cannot conflict with other obligatory classes
For every (obligatory) curriculum Cu, day D, and periods P, there is at most
one course C that belongs to Cu such that assigned(C,D,P) holds.
*%
:- not { assigned(C,D,P) : curricula(Cu,C) } 1, cu(Cu), d(D), ppd(P).