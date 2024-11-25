let $col := collection("db/shakespeare")

(: zad 20 :)
(: let $plays := $col//PLAY
return
  <wynik>{
    for $play in $plays
    return $play/TITLE
  }</wynik> :)

(: zad 21 :)
(: for $plays in $col//PLAY[.//LINE[contains(., "or not to be")]]
  return $plays/TITLE :) 

(: zad 22 :)
return 
  <wynik>{
    for $plays in $col//PLAY
      for $play in $plays
        return 
          <sztuka tytul='{$play/TITLE}'>
            <postaci>{count($play//PERSONA)}</postaci>
            <aktow>{count($play//ACT)}</aktow>    
            <scen>{count($play//SCENE)}</scen>    
          </sztuka>
  }</wynik>