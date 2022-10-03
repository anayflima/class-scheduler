%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Predicados passíveis de atribuição: 
%	discipline(mac0).
%	classQuantity(mac3,1).
%	compulsory(mac3).	
%	graduation(mac3).
%	year(mac3,1).
%	constant(mac0,ter,8).
%	double(mac1).
%	professor(jef).
%	teaches(jef,mac2).
%	profAvaliable(jef,seg,16).
%	day(sex).
%	time(16).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% World general rules %%%%

% Disciplina pode ter 1,2 ou 3 aulas semanais (As aulas devem ser dadas nos horários disponíveis dos professores)

{happens(Discipline,Day1,Time1,Professor)} :- classQuantity(Discipline,1),discipline(Discipline),day(Day1),time(Time1),professor(Professor),teaches(Professor,Discipline),profAvaliable(Professor,Day1,Time1).
{happens(Discipline,Day1,Time1,Day2,Time2,Professor)} :- classQuantity(Discipline,2),discipline(Discipline),day(Day1),day(Day2),time(Time1),time(Time2),professor(Professor),teaches(Professor,Discipline),profAvaliable(Professor,Day1,Time1),profAvaliable(Professor,Day2,Time2),differentDate(Day1,Time1,Day2,Time2).
{happens(Discipline,Day1,Time1,Day2,Time2,Day3,Time3,Professor)} :- classQuantity(Discipline,3),discipline(Discipline),day(Day1),day(Day2),day(Day3),time(Time1),time(Time2),time(Time3),professor(Professor),teaches(Professor,Discipline),profAvaliable(Professor,Day1,Time1),profAvaliable(Professor,Day2,Time2),profAvaliable(Professor,Day3,Time3),differentDate(Day1,Time1,Day2,Time2),differentDate(Day1,Time1,Day3,Time3),differentDate(Day3,Time3,Day2,Time2).

% Registra a ocorrência das disciplinas e registra horário de aula dos professores

happened(Discipline) :- happens(Discipline,Day1,Time1,Professor).
profBusy(Professor,Discipline,Day1,Time1) :- happens(Discipline,Day1,Time1,Professor).

happened(Discipline) :- happens(Discipline,Day1,Time1,Day2,Time2,Professor).
profBusy(Professor,Discipline,Day1,Time1) :- happens(Discipline,Day1,Time1,Day2,Time2,Professor).
profBusy(Professor,Discipline,Day2,Time2) :- happens(Discipline,Day1,Time1,Day2,Time2,Professor).


happened(Discipline) :- happens(Discipline,Day1,Time1,Day2,Time2,Day3,Time3,Professor).
profBusy(Professor,Discipline,Day1,Time1) :- happens(Discipline,Day1,Time1,Day2,Time2,Day3,Time3,Professor).
profBusy(Professor,Discipline,Day2,Time2) :- happens(Discipline,Day1,Time1,Day2,Time2,Day3,Time3,Professor).
profBusy(Professor,Discipline,Day3,Time3) :- happens(Discipline,Day1,Time1,Day2,Time2,Day3,Time3,Professor).

% Definição de horários iguais

equalDate(Day1,Time1,Day2,Time2) :- day(Day1),day(Day2),time(Time1),time(Time2),Day1 == Day2,Time1 == Time2.

% Definição de horários diferentes

differentDate(Day1,Time1,Day2,Time2) :- day(Day1),day(Day2),time(Time1),time(Time2),Day1 != Day2.
differentDate(Day1,Time1,Day2,Time2) :- day(Day1),day(Day2),time(Time1),time(Time2),Time1 != Time2.

% Definindo uma sexta a tarde

isFridayAfternoon(Day,Time) :- day(Day), time(Time), Day = sex, Time = 14.
isFridayAfternoon(Day,Time) :- day(Day), time(Time), Day = sex, Time = 16. 

% Definição de conflito.

conflict(Discipline1,Discipline2,Day1,Time1) :- profBusy(Professor,Discipline1,Day1,Time1), profBusy(Professor2,Discipline2,Day2,Time2), equalDate(Day1,Time1,Day2,Time2), Discipline1 != Discipline2, Discipline1 < Discipline2.

%%% Hard constraints %%%

%Um professor não pode dar duas matérias ao mesmo tempo

:- profBusy(Professor,Discipline,Day,Time), profBusy(Professor,Discipline2,Day,Time), Discipline != Discipline2.

% Todas as matérias propostas para o semestre devem ser dadas

:- discipline(Discipline), not happened(Discipline).


%Cada matéria tem uma quantidade definida de aulas semanais (de 1 até 3)

:- discipline(Discipline), not classQuantity(Discipline,_).
:- discipline(Discipline), classQuantity(Discipline,X), X < 1,X > 3.

% Toda disciplina com uma ocorrência deve ser ministrada em um único horário.

:- discipline(Discipline),classQuantity(Discipline,1), happens(Discipline,Day1,Time1,Professor), happens(Discipline,DayA,TimeA,Professor), differentDate(Day1,Time1,DayA,TimeA).

% Toda disciplina com duas ocorrências deve ser ministrada em um único par de horários.

:- discipline(Discipline),classQuantity(Discipline,2),  happens(Discipline,Day1,Time1,Day2,Time2,Professor),  happens(Discipline,DayA,TimeA,DayB,TimeB,Professor), differentDate(Day1,Time1,DayA,TimeA).
:- discipline(Discipline),classQuantity(Discipline,2),  happens(Discipline,Day1,Time1,Day2,Time2,Professor),  happens(Discipline,DayA,TimeA,DayB,TimeB,Professor), differentDate(Day2,Time2,DayB,TimeB).

% Toda disciplina com três ocorrências deve ser ministrada em um único trio de horários.

:- discipline(Discipline),classQuantity(Discipline,3),  happens(Discipline,Day1,Time1,Day2,Time2,Day3,Time3,Professor),  happens(Discipline,DayA,TimeA,DayB,TimeB,DayC,TimeC,Professor), differentDate(Day1,Time1,DayA,TimeA).
:- discipline(Discipline),classQuantity(Discipline,3),  happens(Discipline,Day1,Time1,Day2,Time2,Day3,Time3,Professor),  happens(Discipline,DayA,TimeA,DayB,TimeB,DayC,TimeC,Professor), differentDate(Day2,Time2,DayB,TimeB).
:- discipline(Discipline),classQuantity(Discipline,3),  happens(Discipline,Day1,Time1,Day2,Time2,Day3,Time3,Professor),  happens(Discipline,DayA,TimeA,DayB,TimeB,DayC,TimeC,Professor), differentDate(Day3,Time3,DayC,TimeC).

%Não pode ter aulas de sexta-feira a tarde na graduação

:- graduation(Discipline), happens(Discipline,Day1,Time1,Professor), isFridayAfternoon(Day1,Time1).
:- graduation(Discipline), happens(Discipline,Day1,Time1,Day2,Time2,Professor), isFridayAfternoon(Day1,Time1).
:- graduation(Discipline), happens(Discipline,Day1,Time1,Day2,Time2,Professor), isFridayAfternoon(Day2,Time2).
:- graduation(Discipline), happens(Discipline,Day1,Time1,Day2,Time2,Day3,Time3,Professor), isFridayAfternoon(Day1,Time1).
:- graduation(Discipline), happens(Discipline,Day1,Time1,Day2,Time2,Day3,Time3,Professor), isFridayAfternoon(Day2,Time3).
:- graduation(Discipline), happens(Discipline,Day1,Time1,Day2,Time2,Day3,Time3,Professor), isFridayAfternoon(Day3,Time3).

%Obrigatórias não podem conflitar com outras obrigatórias do mesmo ano

:- conflict(Discipline,Discipline2,Day,Time), compulsory(Discipline), compulsory(Discipline2), graduation(Discipline), graduation(Discipline2), year(Discipline,Year), year(Discipline,Year), Discipline != Discipline2.
:- conflict(Discipline,Discipline2,Day,Time), compulsory(Discipline), compulsory(Discipline2), not graduation(Discipline), not graduation(Discipline2), year(Discipline,Year), year(Discipline,Year), Discipline != Discipline2.


%Existem horários constantes para disciplinas do primeiro ano e segundo

happens(Discipline,Day,Time,Professor) :- constant(Discipline,Day,Time),classQuantity(Discipline,1),teaches(Professor,Discipline).
happens(Discipline,Day1,Time1,Day2,Time2,Professor) :- constant(Discipline,Day1,Time1,Day2,Time2), classQuantity(Discipline,2),teaches(Professor,Discipline).
happens(Discipline,Day1,Time1,Day2,Time2,Day3,Time3,Professor) :- constant(Discipline,Day1,Time1,Day2,Time2,Day3,Time3), classQuantity(Discipline,3), teaches(Professor,Discipline).
 
%Existem matérias que devem ter seus dois horários juntos (teoria + prática)

:- double(Discipline), classQuantity(Discipline,1).
:- double(Discipline), classQuantity(Discipline,3).

:- double(Discipline), classQuantity(Discipline,2), happens(Discipline,Day1,Time1,Day2,Time2,Professor), Day1 != Time1, not isNextTime(Time1,Time2).

% Definição horarios seguidos

isNextTime(Time1,Time2) :- Time1 = 8, Time2 = 10.
isNextTime(Time1,Time2) :- Time1 = 14, Time2 = 16.


% Definição dias seguidos

isNextDay(Day1,Day2) :- Day1 = seg, Day2 = ter.
isNextDay(Day1,Day2) :- Day1 = ter, Day2 = qua.
isNextDay(Day1,Day2) :- Day1 = qua, Day2 = qui.
isNextDay(Day1,Day2) :- Day1 = qui, Day2 = sex.
isNextDay(Day1,Day2) :- Day1 = sex, Day2 = seg. % Não sei se conta


%%% Soft constraints %%%

% Não conflitar matérias de estatísticas com obrigatórias a partir do segundo ano

	% Pseudo codigo: quero evitar os conflitos que a Discipline1 ou a Discipline2 é matéria de estatistica e a outra é obrigatoria com ano >= 2

% Horários que os professores preferem

	% Pseudo codigo: priorizar ocorrências de aulas em horários bons para cada professor

% Não ter horários de uma mesma disciplina em dias seguidos

	% Pseudo codigo: para disciplinas com 2 ocorrências, evitar ocorrências em dias seguidos.



%%%% Literals %%%

% Enumeração das disciplinas

discipline(mac0).
discipline(mac1).
discipline(mac2).
discipline(mac3).


% Quantidade de aulas por semana

classQuantity(mac0,1).
classQuantity(mac1,2).
classQuantity(mac2,1).
classQuantity(mac3,1).

% É obrigatória?

compulsory(mac0).
compulsory(mac1).
compulsory(mac2).
compulsory(mac3).	


% É de graduação?

graduation(mac0).
graduation(mac1).
graduation(mac2).
graduation(mac3).

% Correspondẽncia disciplina - ano ideal

year(mac0,1).
year(mac1,2).
year(mac2,2).
year(mac3,1).

% Enumeração dos professores

professor(gold).
professor(alan).
professor(jef).

% Enumeração dos dias

day(seg).
day(ter).
day(qua).
day(qui).
day(sex).

% Enumeração dos horários

time(8).
time(10).
time(14).
time(16).

% Relação professor - matéria

teaches(gold,mac3).
teaches(alan,mac0).
teaches(gold,mac1).
teaches(jef,mac2).

% Disponibilidade dos professores

profAvaliable(alan,seg,8).
profAvaliable(alan,seg,10).
profAvaliable(alan,seg,14).
profAvaliable(alan,seg,16).
profAvaliable(alan,ter,8).
profAvaliable(alan,ter,10).
profAvaliable(alan,ter,14).
profAvaliable(alan,ter,16).
profAvaliable(alan,qua,8).
profAvaliable(alan,qua,10).
profAvaliable(alan,qua,14).
profAvaliable(alan,qua,16).
profAvaliable(alan,qui,8).
profAvaliable(alan,qui,10).
profAvaliable(alan,qui,14).
profAvaliable(alan,qui,16).
profAvaliable(alan,sex,8).
profAvaliable(alan,sex,10).
profAvaliable(alan,sex,14).
profAvaliable(alan,sex,16).

profAvaliable(gold,seg,8).
profAvaliable(gold,seg,10).
profAvaliable(gold,seg,14).
profAvaliable(gold,seg,16).


profAvaliable(jef,seg,8).
profAvaliable(jef,seg,10).
profAvaliable(jef,seg,14).
profAvaliable(jef,seg,16).

% Disciplinas constantes

constant(mac0,ter,8).

% Disciplinas dobradinhas

double(mac1).


%%% Preferences %%%

#show happens/8.
#show happens/6.
#show happens/4.
