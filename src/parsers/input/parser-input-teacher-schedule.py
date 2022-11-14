'''
Clingo Input Teachers Schedule Parser (Semestral)
----------------------
This program can parse a given csv files containing the restrictions and preferences for each teacher.
Input: path to csv file containing the information.
Output: files containing asp clausules for the availability and preferable times of the teachers  
The names of each file will be the predicate name and semester/year.
(Ex: input file = 2s22.csv, output file = available2s22.txt and preferable2s22.txt)
If the file already exists, it will append the new information.

Running: 

Create a directory named clingo_input_files 

$ python3 parser-input-teacher-schedule.py

'''

import sys
import csv

'''
This list represents all periods codes that a class can be given
'''
ALLPERIODS = [11, 12, 21, 22]

'''
Function that transforms a day in its code
'''
def transformDay(d):
    if (d == 'Segunda'): return 100
    if (d == 'Terça'): return 200
    if (d == 'Quarta'): return 300
    if (d == 'Quinta'): return 400
    if (d == 'Sexta'): return 500
    return 0

'''
Function that transforms a period in its code
'''
def transformPeriod(p):
    if (p.startswith("08")): return 11
    if (p.startswith("10")): return 12
    if (p.startswith("14")): return 21
    if (p.startswith("16")): return 22
    return 0

def getTeacherName(email):
    return email.split('@')[0].lower().replace('.', '')

def getDayHeader(header):
    return header.split('[')[1][:-1]

'''
This function receives a csv file that contains the columns:
0-time_stamp | 1-teacher_email | 2-6 preferable_periods [day of the week] | 7-11 restricted_periods [day of the week]

And returns a list of dictionaries
The dictionaries keys are: teacher, preference, restriction, available.
The values for preference, restriction, available are another list of dictionaries 
that contains the time codes for each category
'''
def getTeacherSched(file_name):
    with open(file_name) as csv_file:
        infos = list()
        csv_reader = csv.reader(csv_file, delimiter=',')
        # get header
        for row in csv_reader:
            headers = row
            break
        for row in csv_reader:
            atom = dict()
            atom['teacher'] = getTeacherName(row[1])
            atom['preference'] = dict()
            atom['restriction'] = dict()
            # get teachers preferences
            for i in range(2,7):
                day = transformDay(getDayHeader(headers[i]))
                periods = list()
                for p in row[i].split(';'):
                    if (transformPeriod(p) == 0): continue
                    periods.append(transformPeriod(p))
                atom['preference'][day] = periods
            # get teachers restrictions
            for i in range(7,12):
                day = transformDay(getDayHeader(headers[i]))
                periods = list()
                for p in row[i].split(';'):
                    if (transformPeriod(p) == 0): continue
                    periods.append(transformPeriod(p))
                atom['restriction'][day] = periods
            # get teachers availability
            atom['available'] = availablePeriod(atom['restriction'])
            infos.append(atom)
    return infos

'''
Given the restriction times dictionary
Returns a dictonary with the times not restricted
'''
def availablePeriod(restriction):
    available = dict()
    for key in restriction.keys():
        periods = list()
        for p in ALLPERIODS: periods.append(p)   
        for p in restriction[key]: periods.remove(p)
        available[key] = periods
    return available

'''
Assembles asp clausules given the predicate, first argument(teacher) and 
a list of the second arguments
'''
def assembleDayPredicate(predicate, teacher, periods):
    assembled = ""
    for day in periods.keys():
        for hour in periods[day]:
            # get time code with day and period
            p = day + hour
            assembled = assembled + (f'{predicate}({teacher},{p}).') + '\n'
    return assembled

def main():
    file_name = sys.argv[1]
    info = getTeacherSched(file_name)
    available = ""
    preferable = ""
    for i in info:
        available = available + assembleDayPredicate("available", i['teacher'], i['available'])
        preferable = preferable + assembleDayPredicate("preference", i['teacher'], i['preference'])
    with open(f"clingo_input_files/available{file_name[-8:-4]}.txt", 'a') as clingo_input_file:
        clingo_input_file.write(available[:-1])
    with open(f"clingo_input_files/preferable{file_name[-8:-4]}.txt", 'a') as clingo_input_file:
        clingo_input_file.write(preferable[:-1])

main()