# Program to test and understand set of sets comparision, which probably could be used to test if SAT answers are valid 


clingo_out = {frozenset({"a","b","c"}),frozenset({"a"}),frozenset({"b","c"})}

expected_out1 = {frozenset({"a"}),frozenset({"b","a","c"}),frozenset({"b","c"})}

print(clingo_out == expected_out1)


# MUST BE TRUE

###########################################################


out0 = [["class(A,11:00)",
		"class(B,12:00)"]]

exp0 = [["class(A,11:00)",
		"class(B,12:00)"]] # nothing has changed


out1 = [["class(A,11:00)",
		"class(B,12:00)"]]

exp1 = [["class(B,12:00)",
		"class(A,11:00)"]] # order of predicates has been changed 


out2 = [["class(A,11:00)"],

		["class(B,12:00)"],

		["class(C,11:00)"]]


exp2 = [["class(C,11:00)"],

		["class(B,12:00)"],

		["class(A,11:00)"]] # order of answer has been changed

out3 = [["class(A,11:00)",
		"class(B,12:00)",
		"class(C,13:00)"],

		["class(D,11:00)",
		"class(E,12:00)"],


		["class(F,11:00)",
		"class(G,13:00)"]]


exp3 = [["class(G,13:00)",
		"class(F,11:00)"],

		["class(B,12:00)",
		"class(A,11:00)",
		"class(C,13:00)"],

		["class(E,12:00)",
		"class(D,11:00)"]] # order of answers and predicates have been changed

########################################################



# MUST BE FALSE (comparing with out3)

########################################################

exp4 = [["class(G,13:00)",
		"class(F,11:00)"],

		["class(B,12:00)",
		"class(ZZZZZZZ,11:00)", # 1 different answer
		"class(C,13:00)"],

		["class(E,12:00)",
		"class(D,11:00)"]]

exp5 = [["class(G,13:00)",
		"class(F,11:00)"],

		["class(B,12:00)",
		"class(A,11:00)",
		"class(C,13:00)"],

		["class(E,12:00)",
		"class(D,11:00)"],

		["class(A,11:00)"]] # extra answer

exp6 = [["class(G,13:00)",
		"class(F,11:00)"],

		["class(B,12:00)",
		"class(A,11:00)",
		"class(C,13:00)"],

		["class(E,12:00)",]] # without predicate class(D,11:00)


exp7 = [["class(G,13:00)",
		"class(F,11:00)"],

		["class(B,12:00)",
		"class(A,11:00)",
		"class(C,13:00)"],] # missing answer

##############################################################

def compare(out1,out2):
	a1 = set()
	a2 = set()

	if len(out1) != len(out2):
		return False

	for i in range(0,len(out1)):
		a1.add(frozenset(set(out1[i])))
		a2.add(frozenset(set(out2[i])))

	return a1 == a2


print("0:",compare(out0,exp0))

print("1:",compare(out1,exp1))

print("2:",compare(out2,exp2))

print("3:",compare(out3,exp3))

print("4:",compare(out3,exp4))

print("5:",compare(out3,exp5))

print("6:",compare(out3,exp6))

print("7:",compare(out3,exp7))
