# Day 17 – Shell Scripting: Loops, Arguments & Error Handling

## Task

Level up shell scripting skills by:

- Writing `for` and `while` loops
- Using command-line arguments (`$1`, `$#`, `$@`, `$0`)
- Installing packages via script
- Adding basic error handling
- Checking for root privileges inside scripts

---

## Task 1: For Loop

### 1.1: `for_loop.sh`:
#### Loop through a list of 5 fruits and print each one.

```bash
#!/bin/bash

# Define a list of 5 fruits
fruits=("Apple Banana Mango Orange Grapes"

# Loop through the list & print fruit name
for fruit in $fruits
do
    echo "Fruit: $fruit"
done
```

### Run

```bash
./for_loop.sh
```
![fruits](https://github.com/sabir360d/90DaysOfDevOps/blob/df86264c78b0323de51e0661cfa43f5c8554b8ef/2026/day-17/screenshots/T1.1.JPG)

---

### 1.2: `count.sh`
#### Print numbers 1 to 10 using a for loop.

```bash
#!/bin/bash

# Loop through numbers 1 - 10
for i in {1..10}
do
    echo "Number: $i"
done
```

![Running count.sh](https://github.com/sabir360d/90DaysOfDevOps/blob/df86264c78b0323de51e0661cfa43f5c8554b8ef/2026/day-17/screenshots/T1.2.JPG)

---

## Task 2: While Loop

### `countdown.sh`

* Take a number from the user
* Count down to 0 using a while loop
* Print "Done!" at the end

```bash
#!/bin/bash

echo "Enter a number:"
read number

while [ "$number" -ge 0 ]
do
    echo "Countdown: $number"
    number=$((number - 1))
done

echo "Done!"
```

### Run

```bash
./countdown.sh
```

![Running count.sh](https://github.com/sabir360d/90DaysOfDevOps/blob/07e12aa91d6c447ffebb712d43d26d96ebd6157f/2026/day-17/screenshots/T2.JPG)
---

## Task 3: Command-Line Arguments

### 3.1: greet.sh

* Accept a name as `$1`
* Print greeting
* Show usage if no argument is passed

### Script: greet.sh

```bash
#!/bin/bash

if [ $# -eq 0 ]
then
    echo "Usage: ./greet.sh <name>"
    exit 1
fi

echo "Hello, $1!"
```

### Run Without Argument

```bash
./greet.sh
```

### Output

```bash
Usage: ./greet.sh <name>
```

### Run With Argument

```bash
./greet.sh Sabir
```

### Output

```bash
Hello, Sabir!
```

![greet.sh with and without argument](https://github.com/sabir360d/90DaysOfDevOps/blob/07e12aa91d6c447ffebb712d43d26d96ebd6157f/2026/day-17/screenshots/T3.1.JPG)

---

### 3.2: args_demo.sh

### Requirement
- Print total number of arguments (`$#`)
- Print all arguments (`$@`)
- Print script name (`$0`)

### Script: args_demo.sh

```bash
#!/bin/bash

echo "Script Name: $0"
echo "Total Arguments: $#"
echo "All Arguments: $@"
```

### Run

```bash
./args_demo.sh one two three
```

![greet.sh with and without argument](https://github.com/sabir360d/90DaysOfDevOps/blob/07e12aa91d6c447ffebb712d43d26d96ebd6157f/2026/day-17/screenshots/T3.2.JPG)
---

## Task 4: Install Packages via Script

### install_packages.sh

### Requirement
- Define packages: nginx, curl, wget
- Check if installed
- Install if missing
- Skip if already installed
- Must run as root

### Script: install_packages.sh

```bash
#!/bin/bash

# Exit if not run as root
if [ "$EUID" -ne 0 ]
then
    echo "Please run this script as root."
    exit 1
fi

packages="nginx curl wget"

for pkg in $packages
do
    if dpkg -s "$pkg" &> /dev/null
    then
        echo "$pkg is already installed. Skipping."
    else
        echo "$pkg is not installed. Installing..."
        apt update -y
        apt install -y "$pkg"
        echo "$pkg installation complete."
    fi
done
```

### Run as Root

```bash
sudo ./install_packages.sh
```

![Running install_packages.sh with sudo](https://github.com/sabir360d/90DaysOfDevOps/blob/07e12aa91d6c447ffebb712d43d26d96ebd6157f/2026/day-17/screenshots/T4.JPG)

---

## Task 5: Error Handling

### safe_script.sh

### Requirement
- Use `set -e`
- Create directory
- Navigate into it
- Create a file
- Use `||` to handle errors

### Script: safe_script.sh

```bash
#!/bin/bash

set -e

mkdir /tmp/devops-test || echo "Directory already exists"

cd /tmp/devops-test || { echo "Failed to enter directory"; exit 1; }

touch test-file.txt || echo "Failed to create file"

echo "Script completed successfully."
```

### Run

```bash
./safe_script.sh
```
### Example Output (If Directory Exists)

```bash
Directory already exists
Script completed successfully.
```

![safe_script.sh execution](https://github.com/sabir360d/90DaysOfDevOps/blob/07e12aa91d6c447ffebb712d43d26d96ebd6157f/2026/day-17/screenshots/T5.JPG)

---

## What I Learned

1. Loops (`for`, `while`) allow automation of repetitive tasks such as iteration, counting, and processing lists.
2. Command-line arguments (`$1`, `$#`, `$@`, `$0`) make scripts dynamic and reusable in real-world scenarios.
3. Error handling (`set -e`, `||`, root checks with `$EUID`) makes scripts production-safe and prevents silent failures.

---
``
