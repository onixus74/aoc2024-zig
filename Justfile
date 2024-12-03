# List available commands
default:
    @just --list

# Start tilt
dev:
    tilt up


# Run specific day's solution
run DAY:
    zig run src/day_{{DAY}}/main.zig

# Test specific day's solution
test DAY:
    zig test src/day_{{DAY}}/main.zig

# Create new day solution from template
new DAY:
    mkdir -p src/day_{{DAY}}
    cp src/template/main.zig src/day_{{DAY}}/main.zig
    touch src/day_{{DAY}}/input.txt

# Build specific day in debug mode
build DAY:
    zig build-exe src/day_{{DAY}}/main.zig -femit-bin=bin/day_{{DAY}}

# Run all tests
test-all:
    find src -name "main.zig" -exec zig test {} \;

# Format all code
fmt:
    find src -name "*.zig" -exec zig fmt {} \;

