data project.ttest_recode_ifelse;
    set project.ttest;
    if Class_test_taken = 'New Test - Class a' then Class_test_taken = 1;
    else if Class_test_taken = 'New Test - Class b' then Class_test_taken = 2;