load "neededFunctions.m";

computeLevelGl2 := function(G,level)
  divs:=Divisors(level);
	gen:=Generators(G);

	if #G eq #GL(2,Integers(level)) then return 1; end if;

	Result:=level;
	for n in divs do
		if n eq level or n eq 1 then continue; end if;

		temp_gens:=[];
		for g in gen do
			Append(~temp_gens,elt<GL(2,Integers(n)) | RTI(g[1][1]), RTI(g[1][2]), RTI(g[2][1]),RTI(g[2][2])>);
		end for;

		temp_G:=sub<GL(2,Integers(n))|temp_gens>;
		if #G/#temp_G eq #GL(2,Integers(level))/#GL(2,Integers(n)) then Result:=Min(Result,n); end if;

	end for;
	return Result;
end function;

computeLevelSl2 := function(G,level)
  divs:=Divisors(level);
	gen:=Generators(G);

	if #G eq #SL(2,Integers(level)) then return 1; end if;

	Result:=level;
	for n in divs do
		if n eq level or n eq 1 then continue; end if;

		temp_gens:=[];
		for g in gen do
			Append(~temp_gens,elt<SL(2,Integers(n)) | RTI(g[1][1]), RTI(g[1][2]), RTI(g[2][1]),RTI(g[2][2])>);
		end for;

		temp_G:=sub<SL(2,Integers(n))|temp_gens>;
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

hasFullTrace := function(group,level)
  Trace_Attendence := [];
  for i in [0..(level-1)] do Append(~Trace_Attendence,0); end for;

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
findAllGroups := function(level)
  saveFile:= "mt-sd-g0/mt-sf-g0-Results.txt";
  GL2:=GL(2,Integers(level));
  SL2:=SL(2,Integers(level));
  divisors := Divisors(#GL2);
  count := 0;
  for divisor in divisors do
    subgroups := Subgroups(GL2:IndexEqual:=divisor);
    for grp_ in subgroups do
      grp := grp_`subgroup;

      //weed out groups

      if GenusCalculator(grp,level)[1] ne 0 then continue grp_; end if;

      if countDet(grp,level) ne EulerPhi(level) then continue grp_; end if;

      if hasFullTrace(grp,level) then continue grp_; end if;
      //print Det_Count, Trace_Count;

      grpSl2AtLevel := grp meet SL2;
      Write(saveFile,"Example Found");
      Write(saveFile,"*************************");
      Write(saveFile,grp);
      Write(saveFile,"SL2 level ");
      Write(saveFile,computeLevelSl2(grp meet SL(2, Integers(level)),level));
      Write(saveFile,"GL2 level");
      Write(saveFile,computeLevelGl2(grp,level));
      Write(saveFile,"*************************");
      count := count + 1;
    end for;
  end for;
  print "Done";
  Write(saveFile,"function done");
  return count;

end function;

print "loaded function findAllGroups(level)";
