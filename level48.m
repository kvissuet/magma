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

	Result:=true;
	for n in divs do
		if n eq level or n eq 1 then continue; end if;

		temp_gens:=[];
		for g in gen do
			Append(~temp_gens,elt<GL(2,Integers(n)) | RTI(g[1][1]), RTI(g[1][2]), RTI(g[2][1]),RTI(g[2][2])>);
		end for;

		temp_G:=sub<GL(2,Integers(n))|temp_gens>;
		if #G/#temp_G eq #SL(2,Integers(level))/#SL(2,Integers(n)) then Result:=false; print n; end if;

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

level48 := function()
  level := 48;
  divisors := Divisors(level);
  GL2:=GL(2,Integers(level));
  SL2:=SL(2,Integers(level));

  for divisor in divisors do
    if divisor eq level or divisor eq 1 then continue; end if;
    subgroups := Subgroups(GL2:IndexEqual:=divisor);
    for grp_ in subgroups do
      grp := grp_`subgroup;
      Det_Count:=Number_of_Det(grp,level);
      Trace_Count:=Number_of_Traces_Mod(grp,level);
      grpSl2AtLevel := grp meet SL2;
      grpSl2AtLowerLevel := projectToLevel(grpSl2AtLevel, 24);
      print isLevelSl2(grpSl2AtLowerLevel, 24);
      bool1 := isLevelGl2(grp, level);
      bool2 := isLevelSl2(grpSl2AtLevel, level);

      print bool1,bool2,Det_Count,Trace_Count;
      if  bool1 and (not bool2) and Det_Count eq EulerPhi(level) and Trace_Count eq 1 then
        grpSl2AtLowerLevel := projectToLevel(grpSl2AtLevel, 24);
        if isLevelSl2(grpSl2AtLowerLevel, 24) then
          print "Counterexample found";
        end if;
      end if;
    end for;
  end for;
  print "Done";
  return 1;
end function;
