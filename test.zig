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

