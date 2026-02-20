# Shell Scripting Cheat Sheet for my reference

## Quick Reference Table

| Topic | Key Syntax | Example |
|-------|------------|---------|
| Variable | `VAR="value"` | `NAME="DevOps"` |
| Argument | `$1, $2` | `./script.sh arg1` |
| If | `if [ condition ]; then` | `if [ -f file ]; then` |
| For loop | `for i in list; do` | `for i in 1 2 3; do` |
| Function | `name() { ... }` | `greet() { echo "Hi"; }` |
| Grep | `grep pattern file` | `grep -i "error" log.txt` |
| Awk | `awk '{print $1}' file` | `awk -F: '{print $1}' /etc/passwd` |
| Sed | `sed 's/old/new/g' file` | `sed -i 's/foo/bar/g' config.txt` |

---

## Shell Scripting Cheat Sheet

### 1. Shebang (`#!bash #!/bin/bash`)
- The Shebang is the first line of your script. It tells the operating system which interpreter to use to execute the code. Without it, the system may not know whether to use Bash, Python, or Sh. 
- Why it matters: Ensures consistency across different environments.

### 2. Running a Script
- To run a script, the file must have execute permissions.
Make it executable: chmod +x script.sh
- Execute directly: ./script.sh (requires shebang and path)
- Execute via interpreter: bash script.sh (overrides shebang) 

### 3. Comments (`#`)
- Use comments to explain "why" you wrote a line of code.
- Single line: # This is a comment
- Inline: ls -l # List files in long format

### 4. Variables (`$VAR`, `"$VAR"`, `'$VAR'`)
- Variables store data for reuse. No spaces around the = during declaration. 

```bash
NAME="DevOps"
echo $NAME
echo "$NAME"   # Preserves spaces
echo '$NAME'   # Literal
```
- "$VAR": Weak Quoting. Interprets special characters (like $). Always use this for paths or variables with spaces.
- '$VAR': Strong Quoting. Treats everything as literal text (prints $VAR). 

### 5. User Input (`read`)
- Use the read command to make scripts interactive. 
- Basic: read NAME
- With Prompt: 

```bash
read -p "Enter your name: " NAME
echo "Hello $NAME"
```
  
### 6. Command-line arguments — `$0`, `$1`, `$#`, `$@`, `$?`
- These variables are automatically populated when you pass data to a script (e.g., ./script.sh arg1 arg2). 

```bash
- echo $0: Name of the script itself.
- echo $1 - $9: The first through ninth arguments passed.
- echo $#: Total number of arguments passed.
- echo $@: All arguments passed as a list.
- echo $?: Exit status of the last executed command (0 is success, non-zero is failure). 
```
---

# Task 2: Operators & Conditionals

### 1. String Comparisons: `=`, `!=`, `-z`, `-n`
*Note: Always use double quotes around variables (e.g., `"$var"`) to handle spaces.*

| Operator | Description | Example |
| :--- | :--- | :--- |
| `=` / `==` | True if strings are **equal** | `[ "$a" == "$b" ]` |
| `!=` | True if strings are **not equal** | `[ "$a" != "$b" ]` |
| `-z` | True if string is **empty** (length 0) | `[ -z "$a" ]` |
| `-n` | True if string is **not empty** (length > 0) | `[ -n "$a" ]` |

### 2. Integer Comparisons: `-eq`, `-ne`, `-lt`, `-gt`, `-le`, `-ge`

| Operator | Description | Example |
| :--- | :--- | :--- |
| `-eq` | **Equal** to | `[ "$n" -eq 5 ]` |
| `-ne` | **Not equal** to | `[ "$n" -ne 5 ]` |
| `-lt` | **Less than** | `[ "$n" -lt 5 ]` |
| `-gt` | **Greater than** | `[ "$n" -gt 5 ]` |
| `-le` | **Less than or equal** to | `[ "$n" -le 5 ]` |
| `-ge` | **Greater than or equal** to | `[ "$n" -ge 5 ]` |

### 3. File Test Operators: `-f`, `-d`, `-e`, `-r`, `-w`, `-x`, `-s`

| Operator | Description | Example |
| :--- | :--- | :--- |
| `-e` | File or directory **exists** | `[ -e "$path" ]` |
| `-f` | Exists and is a **regular file** | `[ -f "file.txt" ]` |
| `-d` | Exists and is a **directory** | `[ -d "/etc" ]` |
| `-s` | File is **not empty** (size > 0) | `[ -s "logs.txt" ]` |
| `-r` | File is **readable** | `[ -r "config" ]` |
| `-w` | File is **writable** | `[ -w "config" ]` |
| `-x` | File is **executable** | `[ -x "run.sh" ]` |

### 4. Control Flow Syntax

#### **If Statement**
```bash
if [ "$status" == "OK" ]; then # if [ condition ]; then
    echo "Success"
elif [ "$status" == "PENDING" ]; then # elif [ another_condition ]; then
    echo "Wait..."
else
    echo "Error"
fi
```

### 5. Logical Operators

| Operator | Description | Example |
| :--- | :--- | :--- |
| `&&` | **AND**: Both conditions true | `[ cond1 ] && [ cond2 ]` |
| `\|\|` | **OR**: One condition true | `[ cond1 ] \|\| [ cond2 ]` |
| `!` | **NOT**: Negates condition | `[ ! -f "file" ]` |

### 6. Case statements — `case ... esac`
```bash
case "$input" in
    "start")
        start_service
        ;;
    "stop" | "halt")
        stop_service
        ;;
    *)
        echo "Usage: start|stop"
        ;;
esac
```
---

# Task3: Loops

##  For Loop (List)
Best for iterating over strings, arrays, or specific values.

```bash
for item in apple orange banana; do
    echo "Fruit: $item"
done
```

## For Loop (C-style)
Best for numerical counters where you need precise control over the start, stop, and increment

```bash
for ((i=1; i<=5; i++)); do
  echo ""Iteration: $i"
done
```

## While Loop
Runs as long as the condition is true.

```bash
count=1
while [ $count -le 5 ]; do
  echo $count
  ((count++))
done
```

## Until Loop
Runs until the condition becomes true (executes while the condition is false).

```bash
count=1
until [ $count -gt 5 ]; do
  echo "Count is $count"
  ((count++))
done
```

## Loop Control -  Break / Continue
- break: Exits the loop entirely.

- continue: Skips the rest of the current iteration and moves to the next.

```bash
for i in {1..10}; do
    if [ $i -eq 3 ]; then
        continue  # Skip the number 3
    fi
    if [ $i -eq 6 ]; then
        break     # Stop the loop at 6
    fi
    echo "Number: $i"
done
```

## Loop Over Files (*.log) 
Using wildcards (globbing) handles filenames safely, even those containing spaces.

```bash
for file in *.log; do
    echo "Processing $file..."
    cp "$file" "${file}.bak"
done
```

## Loop Over Command Output (while read)
The standard way to process a file line-by-line or handle the output of another command.

```bash
# Reading from a command pipe
df -h | while read -r line; do
    echo "Disk info: $line"
done

# Reading from a file
while read -r line; do
    echo "Line content: $line"
done < input.txt
```
---

# ask 4: Functions

You can define a function using two syntaxes. The most common is the standard parentheses style. To call it, simply type the function name (no parentheses needed when calling).

```bash
greet() {
  echo "Hello $1"
}
```

## Call Function
```bash
greet "Sabir"
```

## Return vs Echo
```bash
add() {
  echo $(($1 + $2))
}

result=$(add 5 3)
```

```bash
check() {
  return 1
}
```

## Local Variables
```bash
my_func() {
  local VAR="inside"
  echo $VAR
}
```

---

# 5. Text Processing Commands

## 1. Pattern Searching: grep
Used to find lines that match a specific pattern.
-i: Case-insensitive search.
-r: Recursive search (look through all files in a directory).
-c: Count the number of matching lines instead of showing them.
-n: Show line numbers with output.
-v: Invert match (show lines that do not match).
-E: Use Extended Regular Expressions (ERE).

```bash
grep -ri "error" /var/log/  # Find "error" in all logs, ignoring case
grep -v "^#" config.conf    # Show file contents excluding commented lines
```

## 2. Data Extraction: awk
A powerful language for processing columns/fields.
$1, $2, $NF: Represent the first, second, and last columns.
-F: Define a custom Field Separator (default is space).
BEGIN / END: Blocks that run before or after the main processing.

```bash
awk -F':' '{print $1}' /etc/passwd             # Print usernames from passwd file
awk 'END {print NR}' file.txt                  # Print the total number of lines
```

## 3. Stream Editing: sed
Best for find-and-replace or line deletion.
s/old/new/g: Substitute "old" with "new" globally.
-i: In-place edit (saves changes to the original file).
d: Delete a specific line (e.g., 3d deletes line 3).

```bash
sed -i 's/localhost/127.0.0.1/g' settings.txt  # Replace globally in-place
sed '1,5d' file.txt                            # Delete lines 1 through 5
```

## 4. Slicing & Dicing: cut, sort, uniq
cut: Extracts sections from lines.
-d ':': Set delimiter.
-f 1,3: Select fields 1 and 3.
sort: Reorders lines.
-n: Numerical sort.
-r: Reverse order.
-k 2: Sort by the second column.
uniq: Handles repeated lines (input must be sorted first).
-c: Count occurrences.
-u: Show only unique lines. cut

```bash
cut -d',' -f1 data.csv | sort | uniq -c  # Count unique values in first column
```

## 5. Quick Utilities: tr, wc, head, tail
- `tr`: Translate or delete characters.
    - `tr 'a-z' 'A-Z'`: Convert to uppercase.
    - `tr -d ' '`: Delete all spaces.
- `wc`: Word count.
    - `l`: Lines, `-w`: Words, `-c`: Characters.
- `head` / `tail`: View ends of files.
    - `n 20`: Show 20 lines.
    - `f`: (Tail only) Follow mode—displays data as it's added to a file.

---

# 6.  Useful One-Liners

## Delete Files Older Than 7 Days
```bash
find /path -type f -mtime +7 -delete
```

## Count Lines in All .log Files
```bash
wc -l *.log
```

## Replace String Across Multiple Files
```bash
sed -i 's/old/new/g' *.conf
```

## Check if Service is Running
```bash
systemctl is-active nginx
```

## Disk Usage Alert
```bash
df -h | awk '$5 > 80 {print "Warning: " $0}'
```

## Tail and Filter Errors
```bash
tail -f app.log | grep --line-buffered "ERROR"
```

---

# 7. Error Handling & Debugging

## Exit Codes
```bash
echo $?
exit 0   # Success
exit 1   # Failure
```
Always return meaningful exit codes in automation scripts.

## Strict Mode
```bash
set -e      # Exit on error
set -u      # Unset variables as error
set -o pipefail
set -x      # Debug mode
```
Best practice (production-safe default):

```bash
#!/bin/bash
set -euo pipefail
```

This prevents silent failures.

---

## Trap Cleanup (Cleanup on Exit)

```bash
cleanup() {
  echo "Cleaning up resources..."
}
trap cleanup EXIT
```

Essential for temp files and rollback logic.

---

# Pro Tip

Shell scripting is not about memorizing syntax.  
It’s about:
- Automating repeatable tasks
- Reducing human error
- Making systems predictable
- Thinking like an engineer

*** Start scripts with: ***
```bash
#!/bin/bash
set -euo pipefail
```

This makes production scripts safer and more predictable.

---
