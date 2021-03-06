declare ProjectLib in
[ProjectLib] = {Link ['Documents/Etudes/Q3/Info2/projet/ProjectLib.ozf']}
local
   ListOfPersons = {ProjectLib.loadDatabase file "Documents/Etudes/Q3/Info2/projet/database.txt"}
   fun {BuildDecisionTree DB}
      ListOfQuestions = ['A-t-il des cheveux longs ?'
			'A-t-il des cheveux noirs ?'
			'A-t-il une barbe ?'
			'A-t-il une moustache ?'
			'Voit-on ses dents ?'
			'Est-il blanc de peau ?']
      fun {BuildDecisionTreeAcc DB Question}
	 case Question of nil then
	    local Name={NewCell nil} in
	       for Person in DB do
		  Name:=Person.1|@Name
	       end
	       leaf(@Name)
	    end
	 [] H|T then
	    local ListTrue={NewCell nil} ListFalse={NewCell nil} ActualQuestion=H in
	       for Person in DB do
		  if Person.ActualQuestion == true then
		     ListTrue:=Person|@ListTrue
		  else
		     ListFalse:=Person|@ListFalse
		  end
	       end
	       question(H true:{BuildDecisionTreeAcc @ListTrue T} false:{BuildDecisionTreeAcc @ListFalse T})
	    end
	 end
      end
   in
      {BuildDecisionTreeAcc DB ListOfQuestions}
   end
   fun {GameDriver Tree}
      Result
      fun {GameDriverAcc Tree ListOfQuestions}
	 {Browse ListOfQuestions}
	 case Tree of leaf(ListOfNames) then
	    {ProjectLib.found ListOfNames}
	 [] question(H true:T false:F) then
	    if {ProjectLib.askQuestion ListOfQuestions.1} then {GameDriverAcc T ListOfQuestions.2}
	    else {GameDriverAcc F ListOfQuestions.2}
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
      Result = {GameDriverAcc Tree ListOfQuestions}
      unit
   end
in
   {ProjectLib.play opts(builder:BuildDecisionTree
			 persons:ListOfPersons
			 driver:GameDriver)}
end
