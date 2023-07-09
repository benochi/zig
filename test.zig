const expect = @import("std").testing.expect;
const std = @import("std");

test "If statement" {
  const a = true;
  var x: u16 = 0;
  if(a){
    x += 1;
  } else {
    x += 2;
  }
  try expect(x == 1);
}

//test "if statement expression" {
//    const a = true;
//    var x: u16 = 0;
//    x += if (a) 1 else 2;
//    try expect(x == 1);
//}

test "While" {
  var i: u8 = 2;
  while (i < 100) {
    i *= 2;
  }
  try expect(i == 128);
}

test "While with continue expression" {
  var sum: u8 = 0;
  var i: u8 = 1;
  while (i <= 10) : (i += 1) { 
    sum += i;
  }
  try expect(sum == 55);
}

test "while with continue" {
    var sum: u8 = 0;
    var i: u8 = 0;
    while (i <= 3) : (i += 1) {
        if (i == 2) continue;
        sum += i;
    }
    try expect(sum == 4);
}

test "while with break" {
    var sum: u8 = 0;
    var i: u8 = 0;
    while (i <= 3) : (i += 1) {
        if (i == 2) break;
        sum += i;
    }
    try expect(sum == 1);
}

test "while" {
  var i: u8 = 2;
  while (i < 100) {
    i *= 2;
  }
  try expect(i == 128);
}

test "while with continue expression"{
  var sum: u8 = 0;
  var i: u8 = 1;
  while (i <= 10) : (i += 1) { 
    sum +=i;
  }
  try expect(sum == 55);
}

//test "while with continue expression" {
//    var sum: u8 = 0;
//    var i: u8 = 1;
//    while (i <= 10) {
//        i += 1;
//        sum += i;
//    }
//    try expect(sum == 55);
//}

test "while with continue" {
  var sum: u8 = 0;
  var i: u8 = 0;
  while (i <= 3) : (i += 1) {
    if (i == 2) continue;
    sum += i;
  }
  try expect(sum == 4);
}

test "while with break" {
  var sum: u8 = 0;
  var i: u8 = 0;
  while (i <= 3) : (i += 1) {
    if (i == 2) break;
    sum += i;
  }
  try expect(sum == 1);
}

//FOR

test "for" {
    //character literals are equivalent to integer literals
    const string = [_]u8{ 'a', 'b', 'c' };

    //for (string, 0..) |character, index| {
    //    _ = character;
    //    _ = index;
    //}

    for (string) |character| {
        _ = character;
    }

    //for (string, 0..) |_, index| {
    //    _ = index;
    //}

    for (string) |_| {}
}

fn addFive(x: u32) u32 {
  return x + 5;
}

test "function" {
  const y = addFive(0);
  try expect(@TypeOf(y) == u32);
  try expect(y == 5);
}

fn fibonacci(n: u16) u16 {
  if (n == 0 or n == 1) return n;
  return fibonacci(n - 1) + fibonacci(n - 2);
}

test "function recursion" {
  const x = fibonacci(10);
  try expect(x == 55);
}

test "defer" {
    var x: i16 = 5;
    {
        defer x += 2;
        try expect(x == 5);
    }
    try expect(x == 7);
}

test "multi defer" {
    var x: f32 = 5;
    {
        defer x += 2;
        defer x /= 2;
    }
    try expect(x == 4.5);
}

const FileOpenError = error{
    AccessDenied,
    OutOfMemory,
    FileNotFound,
};

const AllocationError = error{OutOfMemory};

test "coerce error from a subset to a superset" {
    const err: FileOpenError = AllocationError.OutOfMemory;
    try expect(err == FileOpenError.OutOfMemory);
}

test "error union" {
    const maybe_error: AllocationError!u16 = 10;
    const no_error = maybe_error catch 0;

    try expect(@TypeOf(no_error) == u16);
    try expect(no_error == 10);
}

fn failingFunction() error{Oops}!void {
    return error.Oops;
}

test "returning an error" {
    failingFunction() catch |err| {
        try expect(err == error.Oops);
        return;
    };
}

fn failFn() error{Oops}!i32 {
  try failingFunction();
  return 12;
}

test "try" {
    var v = failFn() catch |err| {
        try expect(err == error.Oops);
        return;
    };
    try expect(v == 12); // is never reached
}

var problems: u32 = 98;

fn failFnCounter() error{Oops}!void {
    errdefer problems += 1;
    try failingFunction();
}

test "errdefer" {
    failFnCounter() catch |err| {
        try expect(err == error.Oops);
        try expect(problems == 99);
        return;
    };
}

fn createFile() !void {
    return error.AccessDenied;
}

test "inferred error set" {
    //type coercion successfully takes place
    const x: error{AccessDenied}!void = createFile();

    //Zig does not let us ignore error unions via _ = x;
    //we must unwrap it with "try", "catch", or "if" by any means
    _ = x catch {};
}

const A = error{ NotDir, PathNotFound };
const B = error{ OutOfMemory, PathNotFound };
const C = A || B;

test "switch statement" {
    var x: i8 = 10;
    switch (x) {
        -1...1 => {
            x = -x;
        },
        10, 100 => {
            //special considerations must be made
            //when dividing signed integers
            x = @divExact(x, 10);
        },
        else => {},
    }
    try expect(x == 1);
}

test "switch expression" {
    var x: i8 = 10;
    x = switch (x) {
        -1...1 => -x,
        10, 100 => @divExact(x, 10),
        else => x,
    };
    try expect(x == 1);
}

//Runtime Safety

test "out of bounds, no safety" {
    @setRuntimeSafety(false);
    const a = [3]u8{ 1, 2, 3 };
    var index: u8 = 5;
    const b = a[index];
    _ = b;
}

fn asciiToUpper(x: u8) u8 {
    return switch (x) {
        'a'...'z' => x + 'A' - 'a',
        'A'...'Z' => x,
        else => unreachable,
    };
}

test "unreachable switch" {
    try expect(asciiToUpper('a') == 'A');
    try expect(asciiToUpper('A') == 'A');
}

fn increment(num: *u8) void {
    num.* += 1;
}

test "pointers" {
    var x: u8 = 1;
    increment(&x);
    try expect(x == 2);
}

test "const pointers" {
    const x: u8 = 1;
    var y = &x;
    y.* += 1;
}