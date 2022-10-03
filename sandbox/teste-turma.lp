%*

Ideia de horario: dia + periodo + hora

segunda = 100
terca = 200
quarta = 300
quinta = 400
sexta = 500

manha 10
8:00 = 1
10:00 = 2

tarde 20
14:00 = 1
16:00 = 2

motivos: fácil de entender, fácil manipulacao (clingo trabalha com inteiros)

problema: dificil fazer horario flexivel

*%

% populando

% disponibilidade do professor
disp(joao, 111).
disp(joao, 112).
disp(joao, 211).
disp(joao, 212).
disp(joao, 421).

disp(hugo, 111).
disp(hugo, 112).
disp(hugo, 121).
disp(hugo, 211).

% quem da a materia
leciona(joao, mac1).
leciona(joao, mac2).
leciona(hugo, mac3).

% materia da graduacao
graduacao(mac1).

%materia com aula dupla
dupla(mac3).

% componentes
materia(M) :-  leciona(_, M).
prof(P) :-  leciona(P, _).
prof(P) :-  disp(P, _).
horario(H) :-  disp(_, H).

% horarios fixos podem ser hard codados
% obs: essa mesma solução pode ser dada para materias com horarios seguidos
turma(joao, mac1, 212).

% turmas possiveis
{turma(P, M, H)} :- disp(P, H), leciona(P, M).

% restricoes
% professor nao pode dar duas aulas ao mesmo tempo
:- turma(P, M1, H), turma(P, M2, H), M1 != M2.

% a materia deve ser dada pelo menos uma vez
% :- not turma(_, X, _), materia(X).

% a materia deve ser dada 2 vezes por semana
:- {turma(P, M, H)} != 2, materia(M).

% graduacao nao tem aula sexta de tarde
:- turma(_, M, 421;422), graduacao(M).

% Ter aulas duplas
% espacamento(M, D):- turma(P,M,H1), turma(P,M,H2), H1 != H2, H1 > H2, D = H1 - H2.
% :- dupla(M), espacamento(M, D), D != 1.
% Sem um novo predicado
:- dupla(M), turma(P,M,H1), turma(P,M,H2), H1 != H2, H1 > H2, H1 - H2 != 1.

#show turma/3.
