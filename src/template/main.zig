const std = @import("std");

pub fn part1(input: []const u8) !u64 {
    _ = input;
    return 0;
}

pub fn part2(input: []const u8) !u64 {
    _ = input;
    return 0;
}

pub fn main() !void {
    // Get allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Read input file
    const input = try std.fs.cwd().readFileAlloc(allocator, "src/day{DAY}/input.txt", 1024 * 1024);
    defer allocator.free(input);

    // Solve
    const p1 = try part1(input);
    const p2 = try part2(input);

    // Print results
    std.debug.print("Part 1: {}\n", .{p1});
    std.debug.print("Part 2: {}\n", .{p2});
}

test "part 1 example" {
    const input =
        \\example input here
    ;
    try std.testing.expectEqual(@as(u64, 0), try part1(input));
}

test "part 2 example" {
    const input =
        \\example input here
    ;
    try std.testing.expectEqual(@as(u64, 0), try part2(input));
}
