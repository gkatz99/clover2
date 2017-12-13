a := 125;

print("when test...");
when(a) {
    case 1: {
        println("FALSE");
    }
    case 123,125: {
        println("TRUE");
    }
    else {
        println("FALSE");
    }
}

b := "ABC";

print("when test2...");
when(b) {
    case "A": {
        println("FALSE");
    }
    case "ABC": {
        println("TRUE");
    }
    else {
        println("FALSE");
    }
}

c := when(123) {
    case 123: {
        "ABC";
    }

    case 234: {
        "DEF";
    }

    else {
        "GHI";
    }
}

Clover.test("when test3", c.equals("ABC"));

d := when(234) {
    case 123: {
        "ABC";
    }

    case 234: {
        123;
    }

    else {
        "GHI";
    }
}

Clover.test("when test4", d.cast("int").equals(123));
