# Class Scheduler

## Introduction

This project aims to facilitate the process of scheduling classes. Given the classes that must be taught that semester, their frequency, the professors who lectures each class and the professors' availability the program generates timetables that follow the restrictions. In addition, we seek to improve the program by giving weak restrictions that can be used to decide which are the best schedules generated. The program uses [Potassco Clingo ASP language](https://potassco.org/) to resolve the problem by satisfiability. We also provide parsers (between csv tables and clingo language) to facilitate the use of our program.

### Table of Content:
- [Running the code](#how-run) <!--- to do -->
- [How the program works](#how-works) <!--- to do -->
- [Logic](#logic)
- [Constrains Indexes](#index) <!--- to do -->
    - [Hard Constraints](#index-hard) <!--- to do -->
    - [Soft Constraints](#index-soft) <!--- to do -->
- [Parsers](#parser)
    - [Fixed Input](#parser-input-fixed)
    - [Semestral Input](#parser-input-semestral)
    - [Output](#parser-output)
- [Tests](#tests)
    - [Hard Constraints](#tests-hard)
    - [Soft Constraints](#tests-soft)
- [Model](#model)
    - [Input Hard Constraints](#model-input-hard)
    - [Input Soft Constraints](#model-input-soft)
    - [Output](#model-output)
    - [Supporting](#model-supporting)
- [About Us](#about-us) 


<a name="how-run"/>

## Running the code

<a name="how-works"/>

## How the program works

<!--
Make UML

csv input files > clingo input files > satisfies hard constraints (restrictions) > weights soft constraints (weak restrictions) > models with scores > csv schedule table

Once finished, explain the commands to run

Direct to the contributing file
-->

<a name="logic"/>

## Logic

The project was divided in two main parts:
1. writing restriction rules

The restriction rules, or "hard constraints " of out model, are the clauses that define if a model is Satisfiable or not. If one rule is not true, than the model is unsatisfiable, if all rules are true, then we have a satisfiable solution.

These constraints can be divided into: 
- basic contrais: general rules used for the logic environment preparation
- specific hard constraints: rules that need to be true for the Computer Science program (ex: two obligatory classes for the same year can't be given at the same time). 

2. writing decisions rules

The decision rules, or "soft constraints", are used to score the satisfiable responses. A soft constraint will never discard a model, but if not true, will give a negative score for the schedule generated. This rules aims to facilitate the decision of which schedule should be chosen. 

These rules and their weights were discussed between the students and represents what would make an ideal schedule for a semester in the CS course.

<a name="index"/>

## Constraints Indexes

<a name="index-hard"/>

### Hard Constraints

<a name="index-soft"/>

<!---
make table
--->

### Soft Constraints

<!---
make table
--->

<a name="parser"/>

## Parsers

To facilitate the usage of our program, we provided three parsers:
<!-- 
It is still in production
-->

<a name="parser-input-fixed"/>

### Fixed Input Parser
For the names, classes per week, curriculum, obligatoriness and other fixed characteristics of a course we created a table containing these informations. We then used a parser to transform the table in ASP clausules. These clausules only need to be generated once, and are specific for the Computer Science program. For using this parser, consult the parser documentation in the parser directory.

<a name="parser-input-semestral"/>

### Semestral Input Parser
The information regarding the teacher availability, preferable time, workload and the courses that will be given that semester is given as a table by the Computer Science’s Commission, the semestral parser aims to transform the table given in ASP clausules. This parser will be used every semester and supposes that the tables are patronized. 
For using this parser, consult the parser documentation in the parser directory.

<a name="parser-output"/>

### Output Parser
After running clingo, the output will be given in ASP clausules. To help read and transport the results, we created a parser that can transform these clausules into csv tables. The user can choose to print this table in the terminal (uses python [tabule](https://pypi.org/project/tabulate/) ) or save in a csv file.

<a name="tests"/>

## Tests

<a name="tests-hard"/>

### Hard Constraints
For each constraint we wrote an individual test set that can identify if the satisfiability and unsatisfiability are being corrected recognized. All tests can be run in the development environment with the command:

```
docker compose up test
```
<a name="tests-soft"/>

### Soft Constraints
For each soft constraint we wrote an example of a schedule that would be chosen by that decision rule. This test aims to manually verify if the constraint written will give more weight for the desired schedule.

<a name="model"/>

## Model
- The *Input*'s predicates are used to populate the model.

- The *Output*'s predicate reveals the time table schedule.

- The *Supporting*'s predicates are used to describe some restrictions or as alias to other predicates.

<a name="model-input-hard"/>

### Input - Hard Constrains Input Predicates

####  **course/3(course id, group id, teacher id)**: 

Identifies a course offering by a discipline id and a group id that should be tought by a especific teacher.

Example:
```
course(macAAA, 1, profAAA).
course(macAAA, 2, profAAA).
course(macBBB, 1, profBBB).
```

####  **num_classes/2(class_id, number_of_weelky classes)**: 

Assign the frenquency for a given class (or how many time it should be tought in a week).

A class cannot be defined with two different frequencies.

Example:
```
num_classes(macAAA, 2).
num_classes(macBBB, 2).

% restriction
:- num_classes(C, H1), num_classes(C, H2), H1 != H2.
```

####  **available/2(teacher name, period)** 

Indicates a teacher's available lecturing periods.

A period is represented by a three digits number in which:
- The most significant bit represents the day of the week (1 to 5, monday to friday)
- The middle bit represents the period of the day (1 = morning, 2 = afternoon)
- The last bit represents the hour in the period

Example:
```
available(profAAA, 121). % profAAA is available on monday's first period of the afternoon

available(profAAA, 212). % profAAA is available on tuesday's second period of the morning
```

####  **postgrad/1(course id)**: 

Identifies a course as part of the postgraduate curriculum. If it is not part of the postgraduate curriculum than the course is automatically part of the graduate curriculum.

Example:
```
postgrad(macBBB).
```

####  **obligatory/2(course id, ideal period)**: 

Identifies a course as obligatory, each obligatory course has its own ideal period.

Example:
```
obligatory(macAAA, 1).
```

####  **double/1(course id)**: 

Identifies that the course's classes should be consecutives.

Example:
```
double(macAAA).
```

####  **joint/1(teacher_id)**:

Indicates courses that are lectured together, normally one from graduation and other from postgraduation.
Example:

```
joint(macAAA, macBBB).
```

<a name="model-input-soft"/>

### Input - Soft Constrains Input Predicates
####  **curriculum/2(course id, curriculum, required)**: 

Identifies a course as part of a curriculum. If the course is required for the conclusion of the curriculum, the last parameter is 1, else 0.

Example:
```
curriculum(macCCC, systems, 1).
curriculum(macCCC, ai, 0).
```
####  **preferable/2(teacher name, period)** 

Indicates a teacher's available preferable period.

Example:
```
preferable(profAAA, 121). % profAAA prefers to lecture classes on monday's first period of the afternoon

preferable(profAAA, 212). % profAAA prefers to lecture classes on tuesday's second period of the morning
```
<a name="model-output"/>

### Output
####  **class/4(course id, group id, teacher, period)**: 

A class represents a cell in the schedule timetable.

It assigns a course and group to a teacher who will lecture it in a period.

It is genarated so N classes of a given course are scheduled, considering the teachers available periods. 
```
{ class(C, G, T, P) : available(T, P) } == N :- course(C, G, T, N).
```
<a name="model-supporting"/>

### Supporting

####  **course/4(course id, group id, teacher id, number of weekly classes)**: 

Identifies a course offering by its discipline id, a group id, a number of weekly classes and the responsible teacher. 

This predicate is generated as following:
```
course(C, G, T, N) :- course(C, G, T), num_classes(C, N).
```

####  **conflict/5(first course id, first course group, second course id, second course grouyp, period)**: 

Indicates a conflict between 2 classes of diferent courses or groups.

```
% class conflict
conflict(C1, G1, C2, G2, P) :-
    class(C1, G1, _, P),
    class(C2, G2, _, P),
    C1 != C2.

% group conflict
conflict(C1, G1, C2, G2, P) :-
    class(C1, G1, _, P),
    class(C2, G2, _, P),
    C1 == C2, G1 != G2.
```

####  **course/1(course id)**: 

Alias to course/4. Identifies a course.

This predicate is generated as following:
```
course(X) :- course(X, _, _, _).
```

####  **teacher/1(teacher_id)**: 

Identifies a teacher by id.

Example:
```
teacher(profAAA).
teacher(profBBB).
```

<a name="about-us"/>

## About Us
We are a group of undergraduate and postgraduate Computer Science students from the Institute of Mathematics and Statistics - University of São Paulo. This project was developed during the MAC0472 course in the second semester of 2022.
