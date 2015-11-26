local ProjectLib in
[ProjectLib] = {Link ['Documents/Etudes/Q3/Info2/projetInfo/ProjectLib.ozf']}
local
   ListOfPersons = {ProjectLib.loadDatabase file "Documents/Etudes/Q3/Info2/projetInfo/database2.txt"}
   fun {BuildDecisionTree DB}
      fun {RemoveDouble List} % retire tous les doublet de la liste List
	 fun {RemoveDoubleAcc L Acc}
	    case L of nil then Acc
	    [] H|T andthen {IsIn H T} then {RemoveDoubleAcc T Acc}
	    else {RemoveDoubleAcc L.2 L.1|Acc}
	    end
	 end % RemoveDoubleAcc
	 fun {IsIn X L} % renvoie true si X appartient a la liste L, false sinon
	    case L of nil then false
	    [] H|T andthen H==X then true
	    else {IsIn X L.2}
	    end
	 end % IsIn
      in % RemoveDouble
	 {RemoveDoubleAcc List nil}
      end %% RemoveDouble
      fun {MakeListOfQuestions DB}
	 fun {MakeListOfQuestionsAcc DB Acc}
	    case DB of nil then Acc
	    [] H|T then
	       local ListOfQ={Arity H}.2 TempList={Append ListOfQ Acc} in
		  {MakeListOfQuestionsAcc T {RemoveDouble TempList}}
	       end
	    end
	 end %% MakeListOfQuestionsAcc
      in % MakeListOfQuestions
	 {MakeListOfQuestionsAcc DB nil}
      end %% MakeListOfQuestions
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
		  fun {DiffTrueFalseAcc DB Question Acc NbreOfReponses}
		     local Reponse in
			case DB of nil then {Abs Acc}-NbreOfReponses
			else
			   try
			      Reponse = (DB.1).Question
			   catch X then
			      Reponse = unknown
			   end
			   if Reponse==true then {DiffTrueFalseAcc DB.2 Question Acc+1 NbreOfReponses+1} % true
			   elseif Reponse==false then {DiffTrueFalseAcc DB.2 Question Acc-1 NbreOfReponses+1} % false
			   else {DiffTrueFalseAcc DB.2 Question Acc NbreOfReponses} % unknown
			   end
			end
		     end
		  end
	       in % DiffTrueFalse
		  {DiffTrueFalseAcc DB Question 0 0}
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
		  elseif {And {Length ListT}==1 {And {Length ListF}==1 ListT==ListF}} then leaf({MakeListOfNames ListT})
		  else
		     local NextLOfQuestionsT NextQuestionT={BestQuestion ListT ListOfQuestions NextLOfQuestionsT} NextLOfQuestionsF NextQuestionF={BestQuestion ListF ListOfQuestions NextLOfQuestionsF} in
		     question(ActualQuestion
			      true:{Gardener ListT nil nil NextQuestionT NextLOfQuestionsT}
			      false:{Gardener ListF nil nil NextQuestionF NextLOfQuestionsF})
		     end
		  end
	       [] Person|P2 then
		  local Reponse in
		     try
			Reponse=Person.ActualQuestion
		     if Reponse==true then {Gardener P2 Person|ListT ListF ActualQuestion ListOfQuestions} % True
		     else {Gardener P2 ListT Person|ListF ActualQuestion ListOfQuestions} % False
		     end
		     catch X
		     then
			Reponse=unknown {Gardener P2 Person|ListT Person|ListF ActualQuestion ListOfQuestions} % Unknown
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
      local ListOfQuestions={MakeListOfQuestions DB} Tree={BuildDecisionTreeAcc DB ListOfQuestions} in
	 {Browse ListOfQuestions}
	 {Browse Tree}
	 Tree
      end
   end %%% BUILDECISIONTREE
   fun {GameDriver Tree}
      Result
      fun {NewDB Tree DB} % retire toutes les personnes de la DB qui ne sont pas dans l'arbre
	 notimplemented
      end
      fun {GameDriverAcc Tree HistoricTree HistoricQuestion HistoricReponses}
	 case Tree of leaf(ListOfNames) then
	    if ListOfNames==nil then {Browse 'Personne non trouvee'} {ProjectLib.found ['Pas donne : Replay']}
	    else {ProjectLib.found ListOfNames}
	    end
	 [] question(H true:T false:F) then
	    local Reponse={ProjectLib.askQuestion H} in
	       %if Reponse==unknown then {GameDriverAcc {AttaTree T F} Tree|HistoricTree} % UNKNOWN
	       if Reponse==true then {GameDriverAcc T Tree|HistoricTree H|HistoricQuestion true|HistoricReponses} % VRAI
	       elseif Reponse==false then {GameDriverAcc F Tree|HistoricTree H|HistoricQuestion false|HistoricReponses} % FAUX
	       else
		  case HistoricTree of nil then {GameDriverAcc Tree HistoricTree HistoricQuestion HistoricReponses}
		  else {GameDriverAcc HistoricTree.1 HistoricTree.2 HistoricQuestion.2 HistoricReponses.2} % OOPS
		  end
	       end
	    end
	 end
      end
   in
      Result = {GameDriverAcc Tree nil nil nil}
      unit
   end
in
   {ProjectLib.play opts(builder:BuildDecisionTree
			 persons:ListOfPersons
			 driver:GameDriver
			 %allowUnknown:true
			 oopsButton:true
			 %missingPlayer:true
			)}
end
end
