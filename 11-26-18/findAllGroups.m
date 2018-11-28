load "neededFunctions.m";


// finds all groups that satisfy the following
// 1) Group has full trace
// 2) Group has full Det
// 3) SL2 Level is even
// 4) Genus 0
// 5) there exists t in Z/mZ such that for all g in G(m) with tr(g) =t then g = I mod2

// 6) Is SL2 new of level n
hasConditonFive := function(group, level)
  Trace_Attendence := [];
  for i in [0..level] do Append(~Trace_Attendence,0); end for;

  for element in group do
    trace := element[1][1] +  element[2][2];
    trace := RTI(trace) + 1;
    if Trace_Attendence[trace] eq 0 then
      if (RTI(element[1][1]) mod 2) ne 1 or
         (RTI(element[2][2]) mod 2) ne 1 or
         (RTI(element[1][2]) mod 2) ne 0 or
         (RTI(element[2][1]) mod 2) ne 0
         then
        Trace_Attendence[trace] :=1;
      end if;
    end if;
  end for;
  return 0 in Trace_Attendence;
end function;

hasFullTrace := function(group,level)
  Trace_Attendence := [];
  for i in [0..level] do Append(~Trace_Attendence,0); end for;

  trace_count := 0;
  for element in group do
    trace := element[1][1] + element[2][2];
    trace := RTI(trace) + 1;
    if Trace_Attendence[trace] eq 0 then
      trace_count := trace_count + 1;
      if trace_count eq level then return true; end if;
      Trace_Attendence[trace] :=1;
    end if;
  end for;
  return false;
end function;

isLevelSl2 := function(G,level)
  divs:=Divisors(level);
	gen:=Generators(G);

	if #G eq #SL(2,Integers(level)) then return 1; end if;

	Result:=level;
	for n in divs do
		if n eq level or n eq 1 then continue; end if;

		temp_gens:=[];
		for g in gen do
			Append(~temp_gens,elt<GL(2,Integers(n)) | RTI(g[1][1]), RTI(g[1][2]), RTI(g[2][1]),RTI(g[2][2])>);
		end for;

		temp_G:=sub<GL(2,Integers(n))|temp_gens>;
		if #G/#temp_G eq #SL(2,Integers(level))/#SL(2,Integers(n)) then Result:=Min(Result,n); end if;

	end for;
	return Result;
end function;

can:=function(n)
  Write("11-26-18/results.txt", "********************************");
  Write("11-26-18/results.txt", "Result for level:");
  Write("11-26-18/results.txt", n);
	GL2:=GL(2,Integers(n));
  divisors := Divisors(n);
  for divisor in divisors do
    if divisor eq n then continue; end if;
    subgroupsOfGl2 := Subgroups(GL2: IndexEqual:=divisor);

    for subgroup_ in subgroupsOfGl2 do
      subgroup := subgroup_`subgroup ;

      //Next 4 condtionals weeds out groups that do not satisfy what is needed
      //Check Condition 6
      grpSl2AtLevel := subgroup meet SL(2, Integers(n));
      if isLevelSl2(grpSl2AtLevel, n) eq n then continue subgroup_; end if;


      //Checks condition 4
      if GenusCalculator(subgroup,n)[1] gt 0 then continue subgroup_; end if;

      //CheckCondition 2
      if countDet(subgroup,n) lt EulerPhi(n) then continue subgroup_; end if;

      //Check condition 1
      if not hasFullTrace(subgroup,n) then continue subgroup_; end if;

      //Check conditoin 5
      if not hasConditonFive(subgroup,n) then continue subgroup_; end if;


      Write("11-26-18/results.txt", subgroup);
    end for;
  end for;
  return "function ran successfully";
end function;

all_even_levels:=function()
  Write("11-26-18/results.txt", "Results:");
  for level in [2..48] do
    if level mod 2 eq 1 then continue; end if;
    can(level);
  end for;
  return 0;
end function;
