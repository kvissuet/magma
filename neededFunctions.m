
RTI:= function(x)
    for a in [1..100000] do
        if a eq x then
            return a;
        end if;
    end for;
end function;


countDet:=function(G,A)
    Det_Attendence:=[];
    Det_Count:=0;
    Euler_Phi:=EulerPhi(A);

    for i in [1..A] do Append(~Det_Attendence,0); end for;

    for x in G do
        Det:=x[1][1]*x[2][2]-x[1][2]*x[2][1];
        if Det_Attendence[RTI(Det)] eq 0 then
            Det_Count:=Det_Count+1;
            Det_Attendence[RTI(Det)] := 1;
            if Det_Count eq Euler_Phi then
                return Det_Count;
            end if;
        end if;
    end for;
    return Det_Count;
end function;


Valid_subgroup:=function(G,A)
	divs:=Divisors(A);
	gen:=Generators(G);

	if #G eq #SL(2,Integers(A)) then return 0; end if;

	Result:=1;
	for n in divs do
		if n eq A or n eq 1 then continue; end if;

		temp_gens:=[];
		for g in gen do
			Append(~temp_gens,elt<GL(2,Integers(n)) | RTI(g[1][1]), RTI(g[1][2]), RTI(g[2][1]),RTI(g[2][2])>);
		end for;

		temp_G:=sub<GL(2,Integers(n))|temp_gens>;
		if #G/#temp_G eq #SL(2,Integers(A))/#SL(2,Integers(n)) then Result:=0; end if;

	end for;
	return Result;
end function;

GenusCalculator:=function(G1,A)
        S1:=sub<GL(2,Integers(A))|[elt<GL(2,Integers(A)) | 1,1,0,1>,elt<GL(2,Integers(A)) | 1,0,1,1>]>;
        f1, S1Perm := PermutationRepresentation(S1);
        gi1 := f1([0,-1,1,0]);
        gp1 := f1([1,1,-1,0]);
        Si1 := Set(Class(S1Perm,gi1));
        Sp1 := Set(Class(S1Perm,gp1));
        Gamma1:= sub<GL(2,Integers(A)) |elt<GL(2,Integers(A)) | 1,1,0,1>>;
        negI1:= elt<GL(2,Integers(A)) | -1,0,0,-1>;
        G2:=G1;
        if not negI1 in G2 then
            ListGenG1:=[negI1];
                        for x123 in Generators(G2) do
                            Append(~ListGenG1,x123);
                        end for;

	        G2:=sub<GL(2,Integers(A))| ListGenG1>;
        end if;
        XS1 := G2 meet S1;
        Ni1 := Si1 meet Set(f1(XS1));
        Np1 := Sp1 meet Set(f1(XS1));
        ri1 := #Ni1 / #Si1;
        rp1 := #Np1 / #Sp1;
        rinf1 := #DoubleCosetRepresentatives(S1Perm,f1(Gamma1),f1(XS1))*#XS1/#S1;
        genus1 := 1 + #S1/12/#XS1*(1 - 3*ri1 - 4*rp1 - 6*rinf1);
        return [genus1,ri1,rp1,rinf1];
end function;

Number_of_Traces:=function(G,A)
    Trace_Attendence:=[];
    Trace_Count:=0;


    for i in [1..A] do Append(~Trace_Attendence,0); end for;

    for x in G do
        Trace:=x[1][1]+x[2][2];
        if Trace_Attendence[RTI(Trace)] eq 0 then
            Trace_Count:=Trace_Count+1;
            Trace_Attendence[RTI(Trace)] := 1;
            if Trace_Count eq A then
                return Trace_Count;
            end if;
        end if;
    end for;

    result:=1;
    if Trace_Count eq A then result:=0; end if;

    return result;
end function;

isFullTraceAndNew:=function(G,A)
    Trace_Count:=0;
   	divs:=Divisors(A);
   	dict:=AssociativeArray();
   	for x in divs do dict[x]:={}; end for;


    for x in G do
        Trace:=x[1][1]+x[2][2];
        for y in divs do
        	Include(~dict[y],RTI(Trace) mod y);
       	end for;

       	if #dict[A] eq A then break; end if;

    end for;

    Result:=1;
    for x in divs do
    	if x eq 1 or x eq A then continue; end if;

    	if #dict[x] lt x then Result:=0; end if;
    end for;

    if #dict[A] eq A then Result:=0; end if;

 	  return Result;
end function;


Add_neg_id:=function(G,A)
    G12:=G;
    negI1:= elt<GL(2,Integers(A)) | -1,0,0,-1>;
	if not negI1 in G12 then
        ListGenG1:=[negI1];
        for x123 in Generators(G12) do
            Append(~ListGenG1,x123);
        end for;
    	G12:=sub<GL(2,Integers(A))| ListGenG1>;
    end if;
    return G12;
end function;
