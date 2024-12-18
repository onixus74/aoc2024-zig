const std = @import("std");

pub fn parseInput(allocator: std.mem.Allocator, input: []const u8) ![2]std.ArrayList(i32) {
    var v1 = std.ArrayList(i32).init(allocator);
    var v2 = std.ArrayList(i32).init(allocator);

    var lines = std.mem.splitScalar(u8, input, '\n');
    while (lines.next()) |line| {
        if (line.len == 0) continue; // Skip empty lines
        var numbers = std.mem.split(u8, line, "   ");
        const n1 = try std.fmt.parseInt(i32, numbers.next() orelse return error.InvalidInput, 10);
        const n2 = try std.fmt.parseInt(i32, numbers.next() orelse return error.InvalidInput, 10);

        try v1.append(n1);
        try v2.append(n2);
    }

    return [2]std.ArrayList(i32){ v1, v2 };
}

pub fn calculateDistance(v1: *const std.ArrayList(i32), v2: *const std.ArrayList(i32)) !i32 {
    if (v1.items.len != v2.items.len) return error.UnequalVectorLengths;

    var sorted_v1 = try std.ArrayList(i32).initCapacity(v1.allocator, v1.items.len);
    defer sorted_v1.deinit();
    try sorted_v1.appendSlice(v1.items);

    var sorted_v2 = try std.ArrayList(i32).initCapacity(v2.allocator, v2.items.len);
    defer sorted_v2.deinit();
    try sorted_v2.appendSlice(v2.items);

    std.mem.sort(i32, sorted_v1.items, {}, std.sort.asc(i32));
    std.mem.sort(i32, sorted_v2.items, {}, std.sort.asc(i32));

    var sum: u32 = 0;
    for (sorted_v1.items, sorted_v2.items) |a, b| {
        const diff = @abs(a - b);
        sum += diff;
    }
    return @intCast(sum);
}

pub fn main() !void {
    // Get allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Read input file
    const input = try std.fs.cwd().readFileAlloc(allocator, "src/day_1/input.txt", 1024 * 1024);
    defer allocator.free(input);

    const vectors = try parseInput(allocator, input);
    defer vectors[0].deinit();
    defer vectors[1].deinit();

    const dist = try calculateDistance(&vectors[0], &vectors[1]);

    // Print the contents of input
    std.debug.print("Distance: {d}\n", .{dist});
}

test "calculateDistance" {
    const allocator = std.testing.allocator;
    var v1 = try std.ArrayList(i32).initCapacity(allocator, 6);
    defer v1.deinit();
    try v1.appendSlice(&[_]i32{ 3, 4, 2, 1, 3, 3 });

    var v2 = try std.ArrayList(i32).initCapacity(allocator, 6);
    defer v2.deinit();
    try v2.appendSlice(&[_]i32{ 4, 3, 5, 3, 9, 3 });

    const dist = try calculateDistance(&v1, &v2);

    try std.testing.expectEqual(dist, 11);
}

test "parseInput" {
    const input =
        \\3   4
        \\4   3
        \\2   5
        \\1   3
        \\3   9
        \\3   3
    ;

    const allocator = std.testing.allocator;
    const vectors = try parseInput(allocator, input);
    defer vectors[0].deinit();
    defer vectors[1].deinit();

    try std.testing.expectEqualSlices(i32, vectors[0].items, &[_]i32{ 3, 4, 2, 1, 3, 3 });
    try std.testing.expectEqualSlices(i32, vectors[1].items, &[_]i32{ 4, 3, 5, 3, 9, 3 });
}
