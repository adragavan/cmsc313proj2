# double.s — Assembly Doubling Program

## Purpose
Reads an integer from stdin, doubles it, and prints:
```
The double is: <doubled number>
```

## Files
- `double.s` — x86-64 GAS (AT&T syntax) assembly source code

## How to Assemble and Run

### Step 1 — Assemble and link
```bash
gcc -o double double.s -no-pie
```

### Step 2 — Run (interactive: type a number and press Enter)
```bash
./double
```

### Step 3 — Run 
```bash
echo "7" | ./double
```

### Example output
```
$ echo "12" | ./double
The double is: 24

$ echo "0" | ./double
The double is: 0

$ echo "100" | ./double
The double is: 200
```
