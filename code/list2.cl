
Clover.test("List2 test1", equalable_list {1,2,3}.indexOf(2) == 1);
Clover.test("List2 test2", equalable_list {1,2,3}.sample().include(equalable_list {1,2,3}));
Clover.test("List2 test3", equalable_list {1,2,3}.equals(equalable_list { 1,2,3 }));
Clover.test("List2 test4", equalable_list {1,2,3}.clear().equals(new EqualableList<Integer>()));
Clover.test("List2 test5", equalable_list {1,2,3}.map(lambda(n:Integer):Anonymous { return n.toString(); }).equals(equalable_list { "1", "2", "3"}));
Clover.test("List2 test6", equalable_list {1,2,3}.map(lambda(n:Integer):Anonymous { return n * 2; }).equals(equalable_list { 2,4,6 }));
Clover.test("List2 test7", equalable_list {1,2,3}.append(equalable_list {4,5,6}).equals(equalable_list {1,2,3,4,5,6}));
Clover.test("List2 test8", equalable_list {1,2}.multiply(3).equals(equalable_list {1,2,1,2,1,2}));
Clover.test("List2 test9", equalable_list {1,2,3,4,5,1,2,3,4,5}.count(1) == 2);
Clover.test("List2 test10", equalable_list {1,2,3,4,5}.deleteAt(1).equals(equalable_list {1,3,4,5}));
Clover.test("List2 test11", equalable_list {1,2,3,1,2,3}.select(lambda(n:Integer):bool { return n != 1 }).equals(equalable_list {2,3,2,3}));
Clover.test("List2 test12", equalable_list {1,2,3,1,2,3}.deleteWithRange(2,4).equals(equalable_list {1,2,2,3}));
Clover.test("List2 test13", equalable_list {1,2,3,4,5,6}.fill(2,4, 100).equals(equalable_list {1,2,100,100,5,6}));
Clover.test("List2 test14", equalable_list {1,2,3,4,5,6}.fill(2,4, 100).equals(equalable_list {1,2,100,100,5,6}));
Clover.test("List2 test15", equalable_list {1,2,3,4,5,6}.subList(2,4).equals(equalable_list { 3,4 }));
Clover.test("List2 test16", equalable_list {1,2,3,4,5,6}.subList(-2,-1).equals(equalable_list { 5,6 }));
Clover.test("List2 test17", equalable_list {1,2,3,4,5,6}.subList(-1,-1).equals(equalable_list { 6 }));
Clover.test("List2 test18", equalable_list {1,2,3,4,5,6}.subList(2,-1).equals(equalable_list { 3,4,5,6 }));
Clover.test("List2 test19", equalable_list {1,2,3,4,5,6}.subList(2,-2).equals(equalable_list { 3,4,5 }));
Clover.test("List2 test20", equalable_list {1,2,3,4,5,6}.fill(100).equals(equalable_list {100,100,100,100,100,100}));
Clover.test("List2 test21", equalable_list {1,2,3,4,5,6}.indexOf(3) == 2);
Clover.test("List2 test22", equalable_list {"AAA", "BBB", "CCC"}.join("+").equals("AAA+BBB+CCC"));
Clover.test("List2 test23", equalable_list {111, 222, 333}.join("+").equals("111+222+333"));

a:EqualableList<Integer> = equalable_list { 1,2,3 };
Clover.test("List2 test24", a.pop() == 3 && a.pop() == 2 && a.pop() == 1 && a.pop().identifyWith(null));

b:= equalable_list { 1,2,3 };

Clover.test("List2 test25", b.shift() == 1 && b.shift() == 2 && b.shift() == 3 && b.shift().identifyWith(null));

println("List test26");
c := equalable_list { 1,2,3 };

c.shuffle().toString().printf("%s\n");
c.shuffle().toString().printf("%s\n");
c.shuffle().toString().printf("%s\n");
c.shuffle().toString().printf("%s\n");
c.shuffle().toString().printf("%s\n");

Clover.test("List test26", sortable_list { "BBB", "CCC", "AAA"}.sort().equals(sortable_list { "AAA", "BBB", "CCC" }));
Clover.test("List test27", sortable_list { "B", "D", "E", "A", "Z", "C", "Y", "X"}.sort().equals(sortable_list { "A", "B", "C", "D", "E", "X", "Y", "Z" }));

