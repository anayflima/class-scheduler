% 
weak/2 (weight priority)
-----------------------
Specifies the rule of a weak constraint
%

% Required courses should not conflict
weak(1, 1) :- obligatory(C1, _), obligatory(C2, _),
              not conflict(C1, _, C2, _, _), C1 != C2.
              

% Classes of the same course should be given on different days
weak(2, 1) :- class(C1, G1, _, P1), class(C2, G2, _, P2),
              C1 == C2, G1 == G2, 
              P1/100 != P2/100.
              

{ softs(W, P) : weak(W, P) }.

#maximize { W@P : softs(W, P) }.



