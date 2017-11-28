def ef(e:E):int {
    if (e.is("EInt")) {
        return e.i;
    } elif (e.is("EAdd")) {
        return ef(e.l)+ef(e.r);
    } elif (e.is("EMul")) {
        return ef(e.l)*ef(e.r);
    } else {
        return 0;
    }
}

Clover.test("recuresive function call test", new EMul(new EInt(10),new EAdd(new EInt(1),new EInt(2))).eval() == 30);
Clover.test("recuresive function call test2",ef(new EMul(new EInt(10),new EAdd(new EInt(1),new EInt(2)))) == 30);
