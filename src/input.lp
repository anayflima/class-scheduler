%*
	Input from 1st semester of 2022
	Note: the avaliability from all teachers is artificial,
	only considering periods that effective teached each course.
*%

%%% Teachers %%%

teacher(yoshiharu).
teacher(leliane).
teacher(flavio).
teacher(posdoc). % ?- who is posdoc
teacher(denis).
teacher(coelho).
teacher(nina).
teacher(renata).
teacher(marcilio).
teacher(hirata).
teacher(sinai).
teacher(guilherme).
teacher(carlinhos).
teacher(kelly).
teacher(rafael_will).
teacher(paulo_miranda).
teacher(finger).
teacher(alair).
teacher(leonidas).
teacher(marcondes).
teacher(ernesto).
teacher(fabio).
teacher(junior).
teacher(jef).
teacher(alan).
teacher(walter).
teacher(nina).
teacher(alfredo).
teacher(yoshiko).
teacher(cris).
teacher(routo).
teacher(marcelinho).
teacher(daniel).
teacher(hitoshi).
teacher(marcel_k).
teacher(ronaldo).

%%% Courses %%%

course(ccm0128,1,yoshiharu).
num_classes(ccm0128,2).

course(mac0101,45,leliane).
course(mac0101,45,flavio).
num_classes(mac0101,1).
:- not class(mac0101,45,leliane,513).
:- not class(mac0101,45,flavio,513).

course(mac0105,45,posdoc).
num_classes(mac0105,2).

course(mac0110,41,denis).
num_classes(mac0110,2).

course(mac0110,42,coelho).

course(mac0110,45,nina).

course(mac0110,51,renata).

course(mac0110,54,marcilio). % ?- will not appear in the table (night time classes)

course(mac0113,1,flavio).
num_classes(mac0113,2).

course(mac0113,2,flavio).

course(mac0113,21,hirata). % ?- ?- will not appear in the table at all (night time classes)

course(mac0113,22,hirata). % ?- ?- will not appear in the table at all (night time classes)

course(mac0115,15,sinai).
num_classes(mac0115,2).


% ?- poli courses will be considered constant to prevent a large amount of answers

course(mac2166,1,guilherme). % ?- maybe group (1,POLI) is not equal group 1 and so on to all next groups
num_classes(mac2166,2).
:- not class(mac2166,1,guilherme,212).
:- not class(mac2166,1,guilherme,413).

course(mac2166,2,carlinhos).
:- not class(mac2166,2,carlinhos,211).
:- not class(mac2166,2,carlinhos,411).

course(mac2166,3,yoshiharu).
:- not class(mac2166,3,yoshiharu,212).
:- not class(mac2166,3,yoshiharu,412).

course(mac2166,4,kelly).
:- not class(mac2166,4,kelly,113).
:- not class(mac2166,4,kelly,313).

course(mac2166,5,kelly).
:- not class(mac2166,5,kelly,121).
:- not class(mac2166,5,kelly,321).

course(mac2166,6,rafael_will).
:- not class(mac2166,6,rafael_will,312).
:- not class(mac2166,6,rafael_will,511).

course(mac2166,7,paulo_miranda).
:- not class(mac2166,7,paulo_miranda,411).
:- not class(mac2166,7,paulo_miranda,514).

course(mac2166,8,paulo_miranda).
:- not class(mac2166,8,paulo_miranda,412).
:- not class(mac2166,8,paulo_miranda,513).

course(mac2166,9,finger).
:- not class(mac2166,9,finger,211).
:- not class(mac2166,9,finger,511).

course(mac2166,10,finger).
:- not class(mac2166,10,finger,212).
:- not class(mac2166,10,finger,512).

course(mac2166,11,alair).
:- not class(mac2166,11,alair,321).
:- not class(mac2166,11,alair,512).

course(mac2166,12,alair).
:- not class(mac2166,12,alair,313).
:- not class(mac2166,12,alair,511).

% missing leonidas mac2166 13,POLI dates.


%%% Avaliability %%%

available(yoshiharu,221).
available(yoshiharu,322).

available(leliane,513).
available(flavio,513).

available(posdoc,321).
available(posdoc,511).

available(denis,211).
available(denis,412).

available(coelho,212).
available(coelho,513). % ?- should be 13:20 (if considered 521 turns to be UNSAT due to hc5)

available(nina,111).
available(nina,312).

available(renata,211).
available(renata,412).

available(marcilio,324). % ?- should be 21:10
available(marcilio,523). % ?- should be 19:20 (if considered 522 turns to be UNSAT due to hc5)

available(flavio,311). % ?- should be 7:30
available(flavio,512). % ?- should be 9:20

available(flavio,511). % ?- should be 9:20
available(flavio,312). % ?- should be 7:30

available(hirata,223). % ?- should be 19:30
available(hirata,424). % ?- should be 21:20

available(hirata,224). % ?- should be 21:20
available(hirata,423). % ?- should be 19:30

available(sinai,222).
available(sinai,421).

available(guilherme,212). % ?- should be 9:20
available(guilherme,413). % ?- should be 13:10

available(carlinhos,211). % ?- should be 7:30
available(carlinhos,411). % ?- should be 7:30

available(yoshiharu,212). % ?- should be 9:20
available(yoshiharu,412). % ?- should be 9:20

available(kelly,113). % ?- should be 13:10
available(kelly,313). % ?- should be 13:10

available(kelly,121). % ?- should be 15:00
available(kelly,321). % ?- should be 15:00

available(rafael_will,312). % ?- should be 9:20
available(rafael_will,511). % ?- should be 7:30

available(paulo_miranda,411). % ?- should be 7:30
available(paulo_miranda,514). % ?- should be 15:00 (if considered 521 turns to be UNSAT due to hc5)

available(paulo_miranda,412). % ?- should be 9:20
available(paulo_miranda,513). % ?- should be 13:10 (if considered 521 turns to be UNSAT due to hc5)

available(finger,211). % ?- should be 7:30
available(finger,511). % ?- should be 7:30

available(finger,212). % ?- should be 9:20
available(finger,512). % ?- should be 9:20

available(alair,321). % ?- should be 15:00
available(alair,512). % ?- should be 9:20

available(alair,313). % ?- should be 13:10
available(alair,511). % ?- should be 7:30