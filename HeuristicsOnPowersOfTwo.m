// Heuristics on GL2 level vs SL2 level where n = 2^i
load "neededFunctions.m";

isLevelGl2 := function(G,level)
  divs:=Divisors(level);
  gen:=Generators(G);

  if #G eq #GL(2,Integers(level)) then return false; end if;

  Result:=true;
  for n in divs do
    if n eq level or n eq 1 then continue; end if;

    temp_gens:=[];
    for g in gen do
      Append(~temp_gens,elt<GL(2,Integers(n)) | RTI(g[1][1]), RTI(g[1][2]), RTI(g[2][1]),RTI(g[2][2])>);
    end for;

    temp_G:=sub<GL(2,Integers(n))|temp_gens>;
    if #G/#temp_G eq #GL(2,Integers(level))/#GL(2,Integers(level)) then Result:=false; end if;

  end for;
  return Result;
end function;

isLevelSl2 := function(G,level)
  divs:=Divisors(level);
	gen:=Generators(G);

	if #G eq #SL(2,Integers(level)) then return false; end if;

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

projectToLevel:=function(G,level)
		gen:=Generators(G);
		temp_gens:=[];
		for g in gen do
			Append(~temp_gens,elt<GL(2,Integers(level)) | RTI(g[1][1]), RTI(g[1][2]), RTI(g[2][1]),RTI(g[2][2])>);
		end for;

		temp_G:=sub<GL(2,Integers(level))|temp_gens>;
		return temp_G;
end function;

heuristicsOnPowerOfTwo := function(exponent)
  level := 2^exponent;

  GL2:=GL(2,Integers(level));
  SL2:=SL(2,Integers(level));
  divisors := Divisors(#GL2);
  count := 0;
  for divisor in divisors do
    if divisor eq 1 or divisor eq 1 then continue; end if;
    subgroups := Subgroups(GL2:IndexEqual:=divisor);
    for grp_ in subgroups do
      grp := grp_`subgroup;
      Det_Count:=countDet(grp,level);
      FullTraceAndNew:=isFullTraceAndNew(grp,level);
      //print Det_Count, Trace_Count;

      if Det_Count eq EulerPhi(level) and FullTraceAndNew eq 1 then

        grpSl2AtLevel := grp meet SL2;
        grpSl2AtLowerLevel := projectToLevel(grpSl2AtLevel, 2^(exponent-1));
        SL2Level := isLevelSl2(grpSl2AtLevel, level);
        if isLevelGl2(grp, level) then
          print "Counterexample found";

          print "level ", SL2Level, grp;

          count := count + 1;
        end if;
      end if;
    end for;
  end for;
  print "Done";
  return count;
end function;
