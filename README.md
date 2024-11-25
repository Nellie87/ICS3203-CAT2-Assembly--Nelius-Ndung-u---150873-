# ICS3203-CAT2-Assembly--Nelius-Ndung-u---150873-
Assembly Programming work

**Task 1 Documentation:** - **Control Flow and Conditional Logic**

To run the code :- cd into Task 1 in wsl then run :
**nasm -f elf64 Task2.asm -o Task2.o
ld Task2.o -o Task2
./Task1**


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

**Task 2 Documentation - Array Manipulation with Looping and Reversal**
Challenges in Handling Memory Directly
1.	Pointer Management: I need to carefully manage where data is stored. If I make a mistake, I might accidentally access memory that shouldn’t be accessed, causing a crash.
2.	Bounds Checking: I have to make sure I stay within the limits of the reserved memory. There aren’t automatic checks to prevent me from accessing invalid memory.
3.	Alignment Issues: The data must be stored in a specific format (like integers on 4-byte boundaries). If the data isn’t aligned correctly, it could cause problems.
4.	Data Corruption: If I update pointers incorrectly, I might overwrite other data in memory, which can lead to errors or crashes.
5.	Debugging Complexity: Without built-in checks, it’s harder to find and fix mistakes compared to higher-level languages

**Task 3: Modular Program with Subroutines for Factorial Calculation**
The program uses registers as follows:

1. RAX: Primary register for computations and storing return values (e.g., factorial result, system call results).
2. RBX: Holds the cumulative factorial result during computation.
3. RCX: Used as a counter in loops (e.g., for digit counting in itoa).
4. RDX: Stores intermediate values (remainders in division, ASCII characters).
5. RSI: Points to input/output buffers for data manipulation.
Values are preserved across subroutine calls by storing temporary values on the stack (e.g., pushing RAX before recursion) and restoring them after the computation to ensure no data is lost.


**Task 4: Data Monitoring and Control Using Port-Based Simulation**

The program determines the appropriate action based on the value of the simulated sensor input. Here's how it works:

1. Reading Sensor Value:

The program prompts the user to enter a sensor value and stores this input in the input_buffer.
It converts the input from ASCII to an integer using the atoi subroutine and stores it in the sensor_value memory location.

2. Action Determination:

The sensor value in sensor_value is compared with predefined thresholds:
- Above HIGH_LEVEL (80): Both motor and alarm are turned ON by setting motor_status = 1 and alarm_status = 1.
- Above MODERATE_LEVEL (50) but not HIGH_LEVEL: Both motor and alarm remain OFF (motor_status = 0, alarm_status = 0).
- Below MODERATE_LEVEL: Motor is turned ON and alarm remains OFF (motor_status = 1, alarm_status = 0).

3.Updating Status:

The values of motor_status and alarm_status memory locations are updated accordingly based on the action determined.

4.Displaying Results:

The program retrieves the motor_status and alarm_status values to decide whether to display "ON" or "OFF" messages for both the motor and alarm.
These statuses are printed using appropriate system calls (int 0x80 for sys_write).

5.Memory Manipulation
- motor_status: Controls the motor; updated to 1 (ON) or 0 (OFF) depending on the sensor input.
- alarm_status: Controls the alarm; updated to 1 (ON) or 0 (OFF) based on the thresholds.
The memory locations are manipulated directly via mov instructions, ensuring the correct statuses are stored and used for decision-making and output.



