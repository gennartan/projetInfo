declare ProjectLib in
[ProjectLib] = {Link ['Documents/Etudes/Q3/Info2/projet/ProjectLib.ozf']}
local
   ListOfPersons = {ProjectLib.loadDatabase file "Documents/Etudes/Q3/Info2/projet/database.txt"}
   {Browse ListOfPersons}
   fun {BuildDecisionTree DB}
     notimplemented
   end
   fun {GameDriver Tree}
      Result
   in
      Result={ProjectLib.found ['Romelu Lukaku']}
   end
in
   {ProjectLib.play opts(builder:BuildDecisionTree
			 persons:ListOfPersons
			 driver:GameDriver)}
end

 declare ListOfQuestion = ['A-t-il des cheveux longs ?'
			   'A-t-il des cheveux noirs ?'
			   'A-t-il une barbe ?'
			   'A-t-il une moustache ?'
			   'Voit-on ses dents ?'
			   'Est-il blanc de peau ?']

 {Browse {Nth DB 3} {Nth ListOfQuestion 5}}

 declare L=[
person('Thibaut Courtois'
  'A-t-il des cheveux longs ?':false
  'A-t-il des cheveux noirs ?':true
  'A-t-il une barbe ?':false
  'A-t-il une moustache ?':false
  'Voit-on ses dents ?':false
  'Est-il blanc de peau ?':true
)
person('Eden Hazard'
  'A-t-il des cheveux longs ?':false
  'A-t-il des cheveux noirs ?':false
  'A-t-il une barbe ?':false
  'A-t-il une moustache ?':false
  'Voit-on ses dents ?':false
  'Est-il blanc de peau ?':true
)
person('Dries Mertens'
  'A-t-il des cheveux longs ?':false
  'A-t-il des cheveux noirs ?':true
  'A-t-il une barbe ?':true
  'A-t-il une moustache ?':true
  'Voit-on ses dents ?':true
  'Est-il blanc de peau ?':true
)
person('Vincent Kompany'
  'A-t-il des cheveux longs ?':false
  'A-t-il des cheveux noirs ?':false
  'A-t-il une barbe ?':true
  'A-t-il une moustache ?':false
  'Voit-on ses dents ?':false
  'Est-il blanc de peau ?':false
)
person('Toby Alderweireld'
  'A-t-il des cheveux longs ?':false
  'A-t-il des cheveux noirs ?':false
  'A-t-il une barbe ?':true
  'A-t-il une moustache ?':false
  'Voit-on ses dents ?':true
  'Est-il blanc de peau ?':true
)
person('Romelu Lukaku'
  'A-t-il des cheveux longs ?':true
  'A-t-il des cheveux noirs ?':true
  'A-t-il une barbe ?':false
  'A-t-il une moustache ?':false
  'Voit-on ses dents ?':true
  'Est-il blanc de peau ?':false
)
person('Daniel Van Buyten'
  'A-t-il des cheveux longs ?':true
  'A-t-il des cheveux noirs ?':false
  'A-t-il une barbe ?':false
  'A-t-il une moustache ?':false
  'Voit-on ses dents ?':false
  'Est-il blanc de peau ?':true
)
person('Axel Witsel'
  'A-t-il des cheveux longs ?':true
  'A-t-il des cheveux noirs ?':true
  'A-t-il une barbe ?':false
  'A-t-il une moustache ?':false
  'Voit-on ses dents ?':true
  'Est-il blanc de peau ?':true
)
person('Jan Vertonghen'
  'A-t-il des cheveux longs ?':false
  'A-t-il des cheveux noirs ?':false
  'A-t-il une barbe ?':false
  'A-t-il une moustache ?':false
  'Voit-on ses dents ?':false
  'Est-il blanc de peau ?':true
)
person('Steven Defour'
  'A-t-il des cheveux longs ?':false
  'A-t-il des cheveux noirs ?':true
  'A-t-il une barbe ?':true
  'A-t-il une moustache ?':true
  'Voit-on ses dents ?':true
  'Est-il blanc de peau ?':true
)
person('Nacer Chadli'
  'A-t-il des cheveux longs ?':false
  'A-t-il des cheveux noirs ?':true
  'A-t-il une barbe ?':true
  'A-t-il une moustache ?':false
  'Voit-on ses dents ?':true
  'Est-il blanc de peau ?':false
)
person('Kevin De Bruyne'
  'A-t-il des cheveux longs ?':false
  'A-t-il des cheveux noirs ?':false
  'A-t-il une barbe ?':false
  'A-t-il une moustache ?':false
  'Voit-on ses dents ?':false
  'Est-il blanc de peau ?':true
)
person('Timmy Simons'
  'A-t-il des cheveux longs ?':false
  'A-t-il des cheveux noirs ?':false
  'A-t-il une barbe ?':false
  'A-t-il une moustache ?':false
  'Voit-on ses dents ?':true
  'Est-il blanc de peau ?':true
)
person('Moussa Dembele'
  'A-t-il des cheveux longs ?':false
  'A-t-il des cheveux noirs ?':true
  'A-t-il une barbe ?':true
  'A-t-il une moustache ?':true
  'Voit-on ses dents ?':false
  'Est-il blanc de peau ?':false
)
person('Marouane Fellaini'
  'A-t-il des cheveux longs ?':true
  'A-t-il des cheveux noirs ?':true
  'A-t-il une barbe ?':false
  'A-t-il une moustache ?':false
  'Voit-on ses dents ?':true
  'Est-il blanc de peau ?':true
)
person('Nicolas Lombaerts'
  'A-t-il des cheveux longs ?':true
  'A-t-il des cheveux noirs ?':false
  'A-t-il une barbe ?':true
  'A-t-il une moustache ?':true
  'Voit-on ses dents ?':true
  'Est-il blanc de peau ?':true
)
person('Kevin Mirallas'
  'A-t-il des cheveux longs ?':false
  'A-t-il des cheveux noirs ?':true
  'A-t-il une barbe ?':true
  'A-t-il une moustache ?':true
  'Voit-on ses dents ?':true
  'Est-il blanc de peau ?':true
)
person('Zakaria Bakkali'
  'A-t-il des cheveux longs ?':false
  'A-t-il des cheveux noirs ?':true
  'A-t-il une barbe ?':false
  'A-t-il une moustache ?':false
  'Voit-on ses dents ?':true
  'Est-il blanc de peau ?':false
)
person('Christian Benteke'
  'A-t-il des cheveux longs ?':false
  'A-t-il des cheveux noirs ?':true
  'A-t-il une barbe ?':true
  'A-t-il une moustache ?':false
  'Voit-on ses dents ?':true
  'Est-il blanc de peau ?':false
)
person('Guillaume Gillet'
  'A-t-il des cheveux longs ?':true
  'A-t-il des cheveux noirs ?':false
  'A-t-il une barbe ?':true
  'A-t-il une moustache ?':true
  'Voit-on ses dents ?':false
  'Est-il blanc de peau ?':true
)
person('Thomas Vermaelen'
  'A-t-il des cheveux longs ?':false
  'A-t-il des cheveux noirs ?':false
  'A-t-il une barbe ?':true
  'A-t-il une moustache ?':false
  'Voit-on ses dents ?':true
  'Est-il blanc de peau ?':true
)
person('Sébastien Pocognoli'
  'A-t-il des cheveux longs ?':false
  'A-t-il des cheveux noirs ?':false
  'A-t-il une barbe ?':true
  'A-t-il une moustache ?':false
  'Voit-on ses dents ?':true
  'Est-il blanc de peau ?':true
)
person('Laurent Ciman'
  'A-t-il des cheveux longs ?':false
  'A-t-il des cheveux noirs ?':false
  'A-t-il une barbe ?':true
  'A-t-il une moustache ?':true
  'Voit-on ses dents ?':false
  'Est-il blanc de peau ?':true
)
person('Simon Mignolet'
  'A-t-il des cheveux longs ?':false
  'A-t-il des cheveux noirs ?':false
  'A-t-il une barbe ?':false
  'A-t-il une moustache ?':false
  'Voit-on ses dents ?':true
  'Est-il blanc de peau ?':true
      )]

 {Browse L.2.2.2.2.2.1.(ListOfQuestion.1)}
 {Browse ListOfQuestion}

 for Person in L do
    {Browse Person.'A-t-il des cheveux longs ?'}
    {Delay 1000}
 end
 