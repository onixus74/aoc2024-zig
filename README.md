# Advent of Code 2024 - Zig Solutions

This repository contains my solutions for [Advent of Code 2024](https://adventofcode.com/2024) implemented in Zig.

## Prerequisites
- [Nix](https://nixos.org/download.html) for development environment

## Project Structure

```
.
├── src/
│   ├── template/     # Template for daily solutions
│   ├── day1/        # Solution for day 1
│   ├── day2/        # Solution for day 2
│   └── ...
├── bin/             # Compiled binaries
├── shell.nix        # Nix development environment
├── Justfile         # Command runner configuration
├── Tiltfile        # Development workflow configuration
└── .tool-versions   # asdf version configuration
```

## Getting Started

1. Clone the repository:
```bash
git clone <repository-url>
cd aoc2024-zig
```

2. Enter the development environment:
```bash
just dev
```

3. Create a new day's solution:
```bash
just new 1  # Creates day 1 solution
```

4. Start the development environment:
```bash
just dev    # Starts Tilt
```

## Available Commands

- `just dev` - Start Tilt
- `just run DAY` - Run a specific day's solution
- `just test DAY` - Run tests for a specific day
- `just new DAY` - Create a new day's solution from template
- `just build DAY` - Build a specific day's solution
- `just test-all` - Run all tests
- `just fmt` - Format all code

## Development Workflow

1. Create a new day's solution:
```bash
just new 1
```

2. Edit the solution in `src/day1/main.zig`

3. Run:

Run in watch mode
```bash
just dev
```

OR 


Run test
```bash
just test 1
```
