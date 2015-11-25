local ProjectLib in
[ProjectLib] = {Link ['Documents/Etudes/Q3/Info2/projetInfo/ProjectLib.ozf']}
local
   ListOfPersons = {ProjectLib.loadDatabase file "Documents/Etudes/Q3/Info2/projetInfo/database.txt"}
   fun {BuildDecisionTree DB}
      ListOfQuestions = [
			 'Est-il blanc de peau ?'
			 'A-t-il des cheveux longs ?'
			 'A-t-il une barbe ?'
			 'A-t-il des cheveux noirs ?'
			 'A-t-il une moustache ?'
			 'Voit-on ses dents ?'
			 ]
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
		     else {DiffTrueFalseAcc DB.2 Question Acc}
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
	    local Var={DiffTrueFalseListAcc DB ListOfQuestions nil} in
	       %{Browse Var}
	       Var
	    end
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
	 fun {MakeListOfNames L}
	    fun {MakeListAcc L Acc}
	       case L of nil then Acc
	       [] H|T then {MakeListAcc T H.1|Acc}
	       end
	    end
	 in
	    {MakeListAcc L nil}
	 end
	 fun {Gardener DB ListT ListF ActualQuestion ListOfQuestions} % Le gardener plante l'arbre de decision
	    if ListOfQuestions==nil then leaf({MakeListOfNames DB})
	    else
	       case DB of nil then
		  if ListT==nil then leaf({MakeListOfNames ListF})
		  elseif ListF==nil then leaf({MakeListOfNames ListT})
		  else
		     local NextLOfQuestionsT NextQuestionT={BestQuestion ListT ListOfQuestions NextLOfQuestionsT} NextLOfQuestionsF NextQuestionF={BestQuestion ListF ListOfQuestions NextLOfQuestionsF} in
		     question(ActualQuestion
				true:{Gardener ListT nil nil NextQuestionT NextLOfQuestionsT}
			      false:{Gardener ListF nil nil NextQuestionF NextLOfQuestionsF})
		     end
		  end
	       [] Person|P2 then
		  local Reponse=Person.ActualQuestion in
		     if Reponse==true then {Gardener P2 Person|ListT ListF ActualQuestion ListOfQuestions} % True
		     elseif Reponse==false then {Gardener P2 ListT Person|ListF ActualQuestion ListOfQuestions} % False
		     else {Gardener P2 Person|ListT Person|ListF ActualQuestion ListOfQuestions} % Unknown
		     end
		  end
	       end
	    end
	 end % Gardener
      in % BuildDecisionTreeAcc
	 local  RestOfListOfQuestions Question={BestQuestion DB ListOfQuestions RestOfListOfQuestions} in
	    {Gardener DB nil nil Question RestOfListOfQuestions}
	 end
      end % BuildDecisionTreeAcc
   in % BuildDecisionTree
      local Tree={BuildDecisionTreeAcc DB ListOfQuestions} in
	 %{Browse Tree}
	 Tree
      end
   end %%% BUILDECISIONTREE
   fun {GameDriver Tree}
      Result
      fun {GameDriverAcc Tree HistoricTree}
	 case Tree of leaf(ListOfNames) then
	    if ListOfNames==nil then {Browse 'Personne non trouvee'} {ProjectLib.found ['Pas donne : Replay']}
	    else {ProjectLib.found ListOfNames}
	    end
	 [] question(H true:T false:F) then
	    local Reponse={ProjectLib.askQuestion H} in
	       if Reponse==unknown then {GameDriverAcc {AttaTree T F} Tree|HistoricTree} % UNKNOWN
	       elseif Reponse==true then {GameDriverAcc T Tree|HistoricTree} % VRAI
	       elseif Reponse==false then {GameDriverAcc F Tree|HistoricTree} % FAUX
	       else
		  case HistoricTree of nil then {GameDriverAcc Tree HistoricTree}
		  [] H|T then {GameDriverAcc H T} % OOPS
		  end
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
		  leaf(['Bonjour'])
	       end
	    end
	 end
      end
   in
      Result = {GameDriverAcc Tree nil}
      unit
   end
in
   {ProjectLib.play opts(builder:BuildDecisionTree
			 persons:ListOfPersons
			 driver:GameDriver
			 %allowUnknown:true
			 oopsButton:true
			)}
end
end
