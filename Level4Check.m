
RTI:= function(x)
    for a in [1..100000] do
        if a eq x then
            return a;
        end if;
    end for;
end function;


containsIdentityMod2 := function(group,element)
    for g in group`subgroup do
        product := g*element;
        if (RTI(product[2][2]) mod 2) eq 1 and (RTI(product[1][2]) mod 2) eq 0
          and (RTI(product[2][1]) mod 2) eq 0 and (RTI(product[1][1]) mod 2) eq 1 then
          continue g;
        end if;
        return false;
    end for;
    return true;
end function;

Level4Check := function()
    G := GL(2,Integers(4));
    subgroups := Subgroups(G);
    for subgroup_ in subgroups do
        subgroup := subgroup_`subgroup;
        if #subgroup eq #G then continue; end if;
        normal_subgroups := NormalSubgroups(subgroup);
        for normal_subgroup in normal_subgroups do
            for element_of_subgroup in subgroup do
                if not containsIdentityMod2(normal_subgroup,element_of_subgroup) then
                  continue normal_subgroup;
                end if;
            end for;
            print "Example found",normal_subgroup`subgroup,subgroup;
        end for;
    end for;
    return 0;
end function;
