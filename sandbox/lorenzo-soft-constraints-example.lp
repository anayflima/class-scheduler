#script(python)
import math
import clingo

def get_digit(n,d):
    ans = clingo.Number(n.number // 10 **(d.number-1) % 10) 
    return ans

def concat(a,b):
    return (str(a) + str(b))


#end.

%* 
weak/2 (weight priority)
-----------------------
Specifies the rule of a weak constraint
*%

% % % % % Classes of the same course should not be given on the same day

weak(-5, 1,Id) :- class(C1, G1, _, P1), class(C1, G1, _, P2),
              P1 != P2,
              P1/100 == P2/100, Id = @concat(C1,G1).
                        
% :~ class(C1, G1, _, P1), class(C1, G1, _, P2),
              % P1 != P2,   
              % P1/100 == P2/100. [5@1]


% % % % Classes of the same course should not be given on consecutive days

weak(-4, 1,Id) :- class(C1, G1, _, P1), class(C1, G1, _, P2),
               P1 != P2,
               P1/100 == P2/100 + 1, Id = @concat(C1,G1).

% % :~ class(C1, G1, _, P1), class(C1, G1, _, P2),
%                % P1 != P2,
%                % P1/100 == P2/100 + 1. [4@1]

% % % The shorter the distance between classes the better it is

weak(-(@absolute(P1/100 - P2/100)), 1,Id) :- class(C1, G1, _, P1), class(C1, G1, _, P2),
               P1 != P2, Id = @concat(C1,G1).

% % :~ class(C1, G1, _, P1), class(C1, G1, _, P2),
%                % P1 != P2. [(@absolute(P1/100 - P2/100)*2) @ 1]


% % % Classes of the same course should be given on the same time of the day (morning/afternoon)

weak(3, 1,Id) :- class(C1, G1, _, P1), class(C1, G1, _, P2),
               P1 != P2,
               @get_digit(P1,2) == @get_digit(P2,2),Id = @concat(C1,G1).

% :~ class(C1, G1, _, P1), class(C1, G1, _, P2),
%                P1 != P2,
%                @get_digit(P1,2) == @get_digit(P2,2). [-3 @ 1]


% Count each occurence of a "weak" predicate, grouped by weight
% Eg: weak(-4,1,Id1).
%     weak(-4,1,Id2).
% ------------------------ 
%     count(-4,1,2)
%

count(W,P,S) :- S = #count{ C : weak(W,P,C)}, weak(W,P,_).

% Multiply each weight by its own quantity of occurences

w(Wnew,P) :- count(W,P,S), Wnew = W*S.


#maximize { W@P : w(W,P) }.
