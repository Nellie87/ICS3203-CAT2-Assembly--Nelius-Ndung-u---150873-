# ICS3203-CAT2-Assembly--Nelius-Ndung-u---150873-
Assembly Programming work

**Task 1 Documentation:** - **Control Flow and Conditional Logic**
To run the code :- cd into Task 1 in wsl then run **./Task1**
The jumps that were included are : 
1.**je (Jump if Equal)**
**Why**: Used to check if the number is zero by testing the Zero Flag (ZF).
**Impact**: Directs flow to handle the "ZERO" case when eax == 0.

2.**jl (Jump if Less)**
**Why**: Checks if the number is negative by testing the Sign Flag (SF).
**Impact**: Ensures the program handles the "NEGATIVE" case when eax < 0.

3.**jmp (Unconditional Jump)**
**Why**: Skips unnecessary checks and directs flow to specific labels.
**Impact**: Consolidates logic (e.g., display message) and improves efficiency.

4.**jmp convert_loop**
**Why:** Loops back to process each character in the input.
**Impact:** Ensures complete input conversion for multi-digit numbers.

5.**jmp classify_number**
**Why:** Proceeds to classify the number after handling a negative sign.
**Impact:** Prevents unnecessary operations and maintains clarity.
