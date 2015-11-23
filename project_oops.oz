declare ProjectLib in
[ProjectLib] = {Link ['Etudes/Q3/Info2/projetInfo/ProjectLib.ozf']}
local
   ListOfPersons = {ProjectLib.loadDatabase file "Etudes/Q3/Info2/projetInfo/database.txt"}
   fun {BuildDecisionTree DB}
      ListOfQuestions = ['A-t-il des cheveux longs ?'
			'A-t-il des cheveux noirs ?'
			'A-t-il une barbe ?'
			'A-t-il une moustache ?'
			'Voit-on ses dents ?'
			'Est-il blanc de peau ?']
      fun {BuildDecisionTreeAcc DB Question}
	 case Question of nil then
	    local fun{NilAux DB Names}
		     case DB of nil then leaf(Names)
		     []H|T then {NilAux T H.1|Names}
		     end
		  end
	    in
	       {NilAux DB nil}
	    end
	 [] H|T then
	    local
	       fun{Aux DB ListTrue ListFalse ListUnknown ActualQuestion}
		  case DB of nil then question(H true:{BuildDecisionTreeAcc {Append ListTrue ListUnknown} T} false:{BuildDecisionTreeAcc {Append ListFalse ListUnknown} T})
		  []P1|P2 then
		     local Reponse = P1.ActualQuestion in
			if Reponse == true then
			   {Aux P2 P1|ListTrue ListFalse ListUnknown ActualQuestion}
			elseif Reponse == false then
			   {Aux P2 ListTrue P1|ListFalse ListUnknown ActualQuestion}
			else
			   {Aux P2  ListTrue ListFalse P1|ListUnknown ActualQuestion}
			end
		     end
		  end
	       end
	    in
	       {Aux DB nil nil nil H}
	    end
	 end
      end
   in
      {BuildDecisionTreeAcc DB ListOfQuestions}
   end
   fun {GameDriver Tree}
      Result
      fun {GameDriverAcc Tree OldTree ListOfQuestions OldListOfQuestions}
	 case Tree of leaf(ListOfNames) then
	    {ProjectLib.found ListOfNames}
	 [] question(H true:T false:F) then
	    local Reponse={ProjectLib.askQuestion ListOfQuestions.1} in
	       if Reponse==unknown then {GameDriverAcc {AttaTree T F} Tree ListOfQuestions.2 ListOfQuestions} % UNKNOWN
	       elseif Reponse==true then {GameDriverAcc T Tree ListOfQuestions.2 ListOfQuestions} % VRAI
	       elseif Reponse==false then {GameDriverAcc F Tree ListOfQuestions.2 ListOfQuestions} % FAUX
	       else {GameDriverAcc OldTree Tree OldListOfQuestions ListOfQuestions} % OOPS
	       end
	    end
	 end
      end
      fun {AttaTree Tree1 Tree2}
	 case Tree1 of leaf(ListOfNames1) then
	    case Tree2 of leaf(ListOfNames2) then
	       leaf({Append ListOfNames1 ListOfNames2})
	    [] question(H3 true:T3 false:T4) then
	       {Browse 'il y a une putain d''erreur'}
	    end
	 [] question(H1 true:T1 false:F1) then
	    case Tree2 of leaf(ListOfNames) then
	       {Browse 'il y a aussi une erreur bordel de merde'}
	    [] question(H2 true:T2 false:F2) then
	       if H1==H2 then question(H1 true:{AttaTree T1 T2} false:{AttaTree F1 F2})
	       else
		  {Browse 'il y a une erreur, les questions ne sont pas les mêmes'}
	       end
	    end
	 end
      end
      ListOfQuestions = ['A-t-il des cheveux longs ?'
			'A-t-il des cheveux noirs ?'
			'A-t-il une barbe ?'
			'A-t-il une moustache ?'
			'Voit-on ses dents ?'
			'Est-il blanc de peau ?']
   in
      Result = {GameDriverAcc Tree Tree ListOfQuestions ListOfQuestions}
      unit
   end
in
   {ProjectLib.play opts(builder:BuildDecisionTree
			 persons:ListOfPersons
			 driver:GameDriver
			 allowUnknown:true
			 oopsButton:true)}
end