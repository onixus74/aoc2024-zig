const std = @import("std");

pub fn main() !void {
    // Get allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Read input file
    const input = try std.fs.cwd().readFileAlloc(allocator, "src/day_2/input.txt", 1024 * 1024);
    defer allocator.free(input);

    var reports = try parseInput(allocator, input);
    defer {
        for (reports.items) |report| {
            report.deinit();
        }
        reports.deinit();
    }

    const safe_count = try countSafe(allocator, &reports);
    std.debug.print("Safe count: {d}\n", .{safe_count});
}

fn parseInput(allocator: std.mem.Allocator, input: []const u8) !std.ArrayList(std.ArrayList(i32)) {
    var lines = std.ArrayList(std.ArrayList(i32)).init(allocator);
    errdefer {
        for (lines.items) |line| {
            line.deinit();
        }
        lines.deinit();
    }

    var line_it = std.mem.tokenizeScalar(u8, input, '\n');
    while (line_it.next()) |line| {
        var numbers = std.ArrayList(i32).init(allocator);
        var num_it = std.mem.tokenizeScalar(u8, line, ' ');
        while (num_it.next()) |num_str| {
            const num = try std.fmt.parseInt(i32, num_str, 10);
            try numbers.append(num);
        }
        try lines.append(numbers);
    }
    return lines;
}

fn countSafe(allocator: std.mem.Allocator, lines: *std.ArrayList(std.ArrayList(i32))) !u64 {
    var safe_count: u64 = 0;

    for (lines.items) |line| {
        var diffs = std.ArrayList(i32).init(allocator);
        defer diffs.deinit();

        var item_index: usize = 1;

        while (item_index < line.items.len) : (item_index += 1) {
            const item = line.items[item_index];
            const prev_item = line.items[item_index - 1];

            const diff = item - prev_item;

            if (@abs(diff) > 3) break;
            try diffs.append(diff);

            if (item_index == line.items.len - 1) {
                if (allSameSign(diffs.items)) {
                    safe_count += 1;
                }
            }
        }
    }

    return safe_count;
}

fn allSameSign(slice: []const i32) bool {
    if (slice.len == 0) return true;

    const first_sign = std.math.sign(slice[0]);
    var i: usize = 1;

    while (i < slice.len) : (i += 1) {
        if (std.math.sign(slice[i]) != first_sign) {
            return false;
        }
    }

    return true;
}

test "parseInput" {
    const input =
        \\7 6 4 2 1
        \\1 2 7 8 9
        \\9 7 6 2 1
        \\1 3 2 4 5
        \\8 6 4 4 1
        \\1 3 6 7 9
    ;

    const allocator = std.testing.allocator;

    var lines = try parseInput(allocator, input);
    defer {
        for (lines.items) |line| {
            line.deinit();
        }
        lines.deinit();
    }

    try std.testing.expectEqual(@as(usize, 6), lines.items.len);

    const expected = [_][5]i32{
        [_]i32{ 7, 6, 4, 2, 1 },
        [_]i32{ 1, 2, 7, 8, 9 },
        [_]i32{ 9, 7, 6, 2, 1 },
        [_]i32{ 1, 3, 2, 4, 5 },
        [_]i32{ 8, 6, 4, 4, 1 },
        [_]i32{ 1, 3, 6, 7, 9 },
    };

    for (lines.items, 0..) |line, i| {
        try std.testing.expectEqual(@as(usize, 5), line.items.len);
        for (line.items, 0..) |num, j| {
            try std.testing.expectEqual(expected[i][j], num);
        }
    }
}

test "countSafe" {
    const allocator = std.testing.allocator;

    var reports = std.ArrayList(std.ArrayList(i32)).init(allocator);
    defer {
        for (reports.items) |line| {
            line.deinit();
        }
        reports.deinit();
    }

    const input = [_][5]i32{
        [_]i32{ 7, 6, 4, 2, 1 },
        [_]i32{ 1, 2, 7, 8, 9 },
        [_]i32{ 9, 7, 6, 2, 1 },
        [_]i32{ 1, 3, 2, 4, 5 },
        [_]i32{ 8, 6, 4, 4, 1 },
        [_]i32{ 1, 3, 6, 7, 9 },
    };

    for (input) |row| {
        var line = std.ArrayList(i32).init(allocator);
        try line.appendSlice(&row);
        try reports.append(line);
    }

    const count = try countSafe(allocator, &reports);

    try std.testing.expectEqual(@as(u64, 2), count);
}

test "allSameSign" {
    // Test positive numbers
    try std.testing.expect(allSameSign(&[_]i32{ 1, 2, 3, 4, 5 }));
    try std.testing.expect(allSameSign(&[_]i32{ 1, 1, 2, 3, 3 }));

    // Test negative numbers
    try std.testing.expect(allSameSign(&[_]i32{ -5, -4, -3, -2, -1 }));
    try std.testing.expect(allSameSign(&[_]i32{ -5, -5, -4, -3, -3 }));

    // Test single element and empty slices
    try std.testing.expect(allSameSign(&[_]i32{1}));
    try std.testing.expect(allSameSign(&[_]i32{}));

    // Test mixed signs
    try std.testing.expect(!allSameSign(&[_]i32{ 1, -3, 2, 4, 5 }));
    try std.testing.expect(!allSameSign(&[_]i32{ -5, 4, -6, 2, -1 }));
    try std.testing.expect(!allSameSign(&[_]i32{ 1, 2, -3, 2, 1 }));

    // Test edge cases
    try std.testing.expect(allSameSign(&[_]i32{ 1, 1, 1, 1, 1 }));
    try std.testing.expect(allSameSign(&[_]i32{ 0, 0, 0, 0, 0 }));
    try std.testing.expect(!allSameSign(&[_]i32{ 0, 1, 2, 3, 4 }));
    try std.testing.expect(!allSameSign(&[_]i32{ -1, 0, 1, 2, 3 }));
}
