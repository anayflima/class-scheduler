
% monday = 1.
% tuesday = 2.
% wednesday = 3.
% thursday = 4.
% friday = 5.
% saturday = 6.

% morning1 = 1.
% morning2 = 2.
% afternoon1 = 3.
% afternoon2 = 4.


% window = day + period
% Ex: a class on Monday at afternoon1 period is represented by 13.


window(11; 12; 13; 14). 

window(21; 22; 23; 24). 

window(31; 32; 33; 34). 

window(41; 42; 43; 44). 

window(51; 52; 53; 54). 


% A course is schedulable if it can be offered and the professor is avaliable
{ scheduled(P, C, W) } :- professor(P), course(C), window(W), 
                          teaches(P, C),
                          avaliable(P, W).

% Can't have a conflict between two courses.
:- scheduled(P, C1, W),
   scheduled(P, C2, W),
   C1 != C2.
  
% All courses must be oferred
:- not scheduled(_, C, _), course(C).

% The course must be oferred T times a week
:- times_a_week(C, T), { scheduled(_, C, _) : course(C) } != T. 

% Some windows should be always free 

% Friday afternoon
:- scheduled(_, _, W), 
   window(W), W == 53.

:- scheduled(_, _, W), 
   window(W), W == 54.

% Some courses' scheduling are permanent 
:- scheduled(_, C, W),
   permanent_time_course(C, T1, T2),
   W != T1, W != T2.
   
% Required courses offered in the same year and semester must not conflict
:- scheduled(_, C1, W1), scheduled(_, C2, W2),
   required(C1), required(C2),
   idealPeriod(C1, Y, S), idealPeriod(C2, Y, S),
   C1 != C2, W1 == W2.

% Some courses have practical class right after the theoretical class
% Problem: this code does not cover breaks for lunch!
:- scheduled(P, C, W1), scheduled(P, C, W2),
   joint(C),
   W1 != W2, W2 > W1, W2 - W1 != 1.