declare ProjectLib in
[ProjectLib] = {Link ['Documents/Etudes/Q3/Info2/projetInfo/ProjectLib.ozf']}
local
   ListOfPersons = {ProjectLib.loadDatabase file "Documents/Etudes/Q3/Info2/projetInfo/database.txt"}
   fun {BuildDecisionTree DB}
      ListOfQuestions = ['A-t-il des cheveux longs ?'
			'A-t-il des cheveux noirs ?'
			'A-t-il une barbe ?'
			'A-t-il une moustache ?'
			'Voit-on ses dents ?'
			 'Est-il blanc de peau ?']
      fun {BestQuestion DB ListOfQuestions NewListOfQuestions} % Renvoie la meilleure question de la liste
	 % ListOfQuestions est la liste des questions qui n'ont pas encore ete posees
	 % DB est la liste des personnes restantes qui repondent aux criteres des questions/reponses precedentes
	 % NewQuestions est le reste de la liste des questions a laquelle on a retire la question que la fonction renvoie
	 fun {RemoveList L Nth} % retire le Nieme element de la liste N et renvoie la liste
	    fun {RemoveListAcc L Nth N Acc}
	       case L of nil then {Reverse Acc}
	       [] H|T andthen N<Nth then {RemoveListAcc T Nth N+1 H|Acc}
	       [] H|T andthen N==Nth then {RemoveListAcc T Nth N+1 Acc}
	       [] H|T andthen N>Nth then {RemoveListAcc T Nth N+1 H|Acc}
	       end	       
	    end %% RemoveListAcc
	 in % RemoveList
	    {RemoveListAcc L Nth 1 nil}
	 end %% RemoveList
	 fun {MinList L} % Renvoie l'emplacement de la plus petite valeur de la liste
	    fun {MinListAcc L N Place Nth}
	       case L of nil then Place
	       [] H|T andthen H<N then {MinListAcc T H Nth Nth+1}
	       [] H|T andthen H>=N then {MinListAcc T N Place Nth+1}
	       end
	    end
	 in
	    {MinListAcc L L.1 1 1}
	 end %% MinList
	 fun {DiffTrueFalseList DB ListOfQuestions} % Renvoie une liste de nombre. Le premier correspond a la valeur absolue de la difference des reponses true et des reponses false par les personnes de la DB
	    % DB contiens les personnes ainsi que les reponses a toutes les questions posees dans ListOfQuestions
	    % ListOfQuestions possede toutes les questions auquelle les personnes savent repondre
	    fun {DiffTrueFalseListAcc DB ListOfQuestions Acc}
	       fun {DiffTrueFalse DB Question} % Renvoie la valeur absolue de la difference de reponses true et false a la questions Question par les personnes de la DB
		  fun {DiffTrueFalseAcc DB Question Acc}
		     case DB of nil then {Abs Acc}
		     [] Person|T andthen Person.Question==true then {DiffTrueFalseAcc T Question Acc+1}
		     [] Person|T andthen Person.Question==false then {DiffTrueFalseAcc T Question Acc-1}
		     end
		  end
	       in % DiffTrueFalse
		  {DiffTrueFalseAcc DB Question 0}
	       end %% DiffTrueFalse
	    in % DiffTrueFalseListAcc
	       case ListOfQuestions of nil then {Reverse Acc}
	       [] Question|RestListOfQuestions then
		  local Diff={DiffTrueFalse DB Question} in
		     {DiffTrueFalseListAcc DB RestListOfQuestions Diff|Acc}
		  end
	       end
	    end %% DiffTrueFalseListAcc
	 in % DiffTrueFalseList
	    {DiffTrueFalseListAcc DB ListOfQuestions nil}
	 end %% DiffTrueFalseList
      in % BestQuestion
	 % {RemoveList L Nth}                     ==> retire le Nth ieme element de la liste L et revoie la liste modifiee
	 % {MinList L}                            ==> retourne l'emplacement du plus petit element de la liste
	 % {DiffTrueFasleList DB ListOfQuestions} ==> Retourne une liste contenant les differences des reponses true et false ...
	 local Diff N Question in
	    Diff = {DiffTrueFalseList DB ListOfQuestions}
	    N = {MinList Diff}
	    Question = {Nth ListOfQuestions N}
	    NewListOfQuestions = {RemoveList ListOfQuestions N}
	    Question
	 end
      end %%% BestQuestion
      fun {BuildDecisionTreeAcc DB ListOfQuestions}
	 NextListOfQuestions
	 Question = {BestQuestion DB ListOfQuestions NextListOfQuestions}
	 fun {Aux DB ListTrue ListFalse ListUnknown Question}
	    case DB of nil then
	       local NewListTrue={Append ListTrue ListUnknown} NewListFalse={Append ListFalse ListUnknown} True False in
		  if {Length NewListTrue}==1 then True=leaf([NewListTrue.1.1])
		  else True = {BuildDecisionTreeAcc NewListTrue NextListOfQuestions}
		  end
		  if {Length NewListFalse}==1 then False=leaf([NewListFalse.1.1])
		     else False={BuildDecisionTree NewListFalse
		  question(Question
			   true:{BuildDecisionTreeAcc {Append ListTrue ListUnknown} NextListOfQuestions}
			   false:{BuildDecisionTreeAcc {Append ListFalse ListUnknown} NextListOfQuestions})
	       end
	    [] P1|P2 then
	       local Reponse = P1.Question in
		  if Reponse==true then {Aux P2 P1|ListTrue ListFalse ListUnknown Question}
		  elseif Reponse==false then {Aux P2 ListTrue P1|ListFalse ListUnknown Question}
		  else {Aux P2 ListTrue ListFalse P1|ListUnknown Question}
		  end
	       end
	    end
	 end %%Aux
      in % BuildDecisionTreeAcc
	 {Aux DB
      end %% BuildDecisionTreeAcc
   in
      {BuildDecisionTreeAcc DB ListOfQuestions}
   end
   fun {GameDriver Tree}
      Result
      fun {GameDriverAcc Tree OldTree ListOfQuestions OldListOfQuestions}
	 case Tree of leaf(ListOfNames) then
	    if ListOfNames==nil then {Browse 'Personne non trouvee'} {ProjectLib.found ['Pas donne : Replay']}
	    else {ProjectLib.found ListOfNames}
	    end
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
	       {Browse 'il y a une putaierreur'}
	       leaf()
	    end
	 [] question(H1 true:T1 false:F1) then
	    case Tree2 of leaf(ListOfNames) then
	       {Browse 'il y a aussi une erreur bordel de merde'}
	       leaf()
	    [] question(H2 true:T2 false:F2) then
	       if H1==H2 then question(H1 true:{AttaTree T1 T2} false:{AttaTree F1 F2})
	       else
		  {Browse 'il y a une erreur, les questions ne sont pas les mêmes'}
		  leaf()
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

{Browse 4}