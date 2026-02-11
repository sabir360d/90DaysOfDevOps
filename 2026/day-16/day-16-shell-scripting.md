`
# Day 16 – Shell Scripting Basics

## Task
Fundamentals of Shell Scripting.

* Understand shebang (#!/bin/bash) and why it matters
* Work with variables, echo, and read
* Write basic if-else conditions

## Environment 
Scripts written and executed in Ubuntu Linux using Bash.

---

## Task 1: Your First Script

### Script: `hello.sh`

```bash
#!/bin/bash

echo "Hello, DevOps!"
````

### Steps Performed

```bash
chmod +x hello.sh
./hello.sh
```

### Output

```text
Hello, DevOps!
```
![task1](https://github.com/sabir360d/90DaysOfDevOps/blob/4126ae7ca89678a930fea99290f243c8a2fb30d2/2026/day-16/screenshots/T1.JPG)

Terminal showing file permissions before and after `chmod +x` and successful execution of `./hello.sh`.

### What Happens If the Shebang Is Removed?

* The operating system no longer knows which interpreter should run the script.
* Executing `./hello.sh` may result in an error or may run using a default shell. 
* Explicitly defining the interpreter improves portability and predictability.

### Why it worked in this specific case

* Linux-Unix Compatibility: `Bash` inherits `sh` behavior. If a file has executable permissions but lacks a shebang, the system is designed to "fall back" and assume it is a script for the default Bourne shell (sh).
* Bash Behavior on Linux: Since Bash is typically the default shell, it automatically re-invokes the script using /bin/bash, which is why the script still runs even without a shebang.
---

##  Task 2: Variables
### Script: `variables.sh`

```bash
#!/bin/bash

NAME="Sabir"
ROLE="DevOps Engineer"

echo "Hello, I am $NAME and I am a $ROLE"
```
### Output

```text
Hello, I am Sabir and I am a DevOps Engineer
```
### Single Quotes vs Double Quotes

```bash
echo 'Hello, I am $NAME'
echo "Hello, I am $NAME"
```
![task2](https://github.com/sabir360d/90DaysOfDevOps/blob/4126ae7ca89678a930fea99290f243c8a2fb30d2/2026/day-16/screenshots/T2.JPG)

Terminal output showing variable expansion during script execution.

### Observed Behavior

* Single quotes treat variables as literal strings.
* Double quotes allow variable interpolation.
* Double quotes should be used when variables are expected to expand.

---

## Task 3: User Input with `read`

### Script: `greet.sh`

```bash
#!/bin/bash

read -p "Enter your name: " NAME
read -p "Enter your favourite tool: " TOOL

echo "Hello $NAME, your favourite tool is $TOOL"
```

![task3](https://github.com/sabir360d/90DaysOfDevOps/blob/4126ae7ca89678a930fea99290f243c8a2fb30d2/2026/day-16/screenshots/T3.JPG)

Interactive terminal session showing prompts and user input.

---

## Task 4: If-Else Conditions

### Script 1: `check_number.sh`

```bash
#!/bin/bash

read -p "Enter a number: " NUM

if [ "$NUM" -gt 0 ]; then
  echo "The number is positive"
elif [ "$NUM" -lt 0 ]; then
  echo "The number is negative"
else
  echo "The number is zero"
fi
```
![task4-1](https://github.com/sabir360d/90DaysOfDevOps/blob/4126ae7ca89678a930fea99290f243c8a2fb30d2/2026/day-16/screenshots/T4-1.JPG)


Terminal outputs showing all three conditional branches.

---

### Script 2: `file_check.sh`

```bash
#!/bin/bash

read -p "Enter filename: " FILE

if [ -f "$FILE" ]; then
  echo "File exists"
else
  echo "File does not exist"
fi
```
![task4-2](https://github.com/sabir360d/90DaysOfDevOps/blob/4126ae7ca89678a930fea99290f243c8a2fb30d2/2026/day-16/screenshots/T4-2.JPG)

Terminal verifying both existing and non-existing files.

---

## Task 5: Combine It All

### Script: `server_check.sh`

```bash
#!/bin/bash

SERVICE="nginx"

read -p "Do you want to check the status of $SERVICE? (y/n): " ANSWER

if [ "$ANSWER" = "y" ]; then
  systemctl is-active --quiet $SERVICE

  if [ $? -eq 0 ]; then
    echo "$SERVICE is running"
  else
    echo "$SERVICE is not running"
  fi
else
  echo "Skipped."
fi
```

![task5](https://github.com/sabir360d/90DaysOfDevOps/blob/4126ae7ca89678a930fea99290f243c8a2fb30d2/2026/day-16/screenshots/T5.JPG)

Terminal showing service status checks and conditional branching.

---

## Highlights

1. The shebang line defines how and where a script is executed.
2. Variables and quoting rules directly affect how data is interpreted.
3. Combining user input with conditional logic enables real-world automation.

---
