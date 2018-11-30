load "neededFunctions.m";

projectToLevel:=function(G,level)
		gen:=Generators(G);
		temp_gens:=[];
		for g in gen do
			Append(~temp_gens,elt<GL(2,Integers(level)) | RTI(g[1][1]), RTI(g[1][2]), RTI(g[2][1]),RTI(g[2][2])>);
		end for;

		temp_G:=sub<GL(2,Integers(level))|temp_gens>;
		return temp_G;
end function;

findAllGroups := function(level,candidate, subgrpLevel)
  saveFile:= "11-29-18/mtgMapsDownResults.txt";
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

      grpAtLowerLevel := projectToLevel(grp,subgrpLevel);
      if #grpAtLowerLevel ne #candidate then continue grp_; end if;

      GL2LowerLevel :=GL(2,Integers(subgrpLevel));
      if not IsConjugate(GL2LowerLevel,candidate,grpAtLowerLevel)
          then continue grp_; end if;

      if countDet(grp,level) ne EulerPhi(level) then continue grp_; end if;

      if hasFullTrace(grp,level) then continue grp_; end if;




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
