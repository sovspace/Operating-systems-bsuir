BEGIN {
    FS=",";
    OFS="";
    ORS="";
}

{
    print "(";
    for (i = 1; i < NF; i++) {
        print $i, ", ";
    }
    print $NF, "), ";
}
