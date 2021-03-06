%Legyőzött és legyőző versenyző, 4/4
% Aszalós László

A feladatban egy számsorozat elemeit megelőző első nagyobb és első későbbi 
kisebb számot kell megadni, illetve _-1_-et, ha ilyen nem létezik.

# Egyszerű megoldás
## Python változat

`<victor1.py>=`

~~~ {#victor1_py}
  from array import *
  <<Beolvasás>>
  <<Egyszerű feldolgozás>>

~~~
 Mivel minden sor csak egy-egy adatot tartalmaz, egyszerűen egésszé kell
alakítani a beolvasott sort.


`<Beolvasás>=`

~~~ {#Beolvasás}
  N = int(input())
  t = array('i')
  for i in range(N):
      t.append(int(input()))

~~~
 Végigmegyünk az összes elemen, és megfelelő személyeket keresünk.
Végül amit találunk, kiírunk. 
A Python nullával kezdődő indexelése miatt a talált indexeknél eggyel 
 nagyobb számot kell kiírni mindkét esetben.


`<Egyszerű feldolgozás>=`

~~~ {#Egyszerű_feldolgozás}
  for i in range(N):
      <<Legyőzött keresése Python>>
      <<Legyőző keresése Python>>
      print(a+1, b+1)

~~~
 Az ```a``` változó fogja tartalmazni a keresett indexet.
Ha rátalálunk a keresett elemre, akkor annak megfelelően beállítjuk,
 egyébként marad a kért kezdőérték.
Figyelnünk kell arra, hogy ne lépjünk ki a tömbből!

`<Legyőzött keresése Python>=`

~~~ {#Legyőzött_keresése_Python}
  a = -2
  j = i-1
  while j>=0 and t[i]<=t[j]:
      j -= 1
  if j>=0 and t[i] > t[j]:
      a = j;

~~~
 Itt hasonló a helyzet, csak a másik irányba haladunk, 
 és a relációk megfordulnak.

`<Legyőző keresése Python>=`

~~~ {#Legyőző_keresése_Python}
  b = -2
  j = i+1
  while j<N and t[i]>=t[j]:
      j += 1
  if j<N and t[i] < t[j]:
      b = j;

~~~

## C++ megoldás
Muiután a Python verzió az előbbi piszkos trükkök ellenére is kifut a 
rendelkezésre álló időből, lássuk a C++ megvalósítást!
Az adatok beolvasása után minden egyes versenyzőre ugyanazt hajtjuk végre,
megkeressük az első legyőzöttett, illetve az első legyőzőt. 
Majd ezeket kiírjuk.

`<victor.cpp>=`

~~~ {#victor_cpp .cpp}
  #include <iostream>
  using namespace std;
  int main(){
    int v1, v2;
    <<Adatok beolvasása>>
    for (int i=0; i<N; i++){
      <<Legyőzött keresése C++>>
      <<Legyőző keresése C++>>
      cout << v1 << " " << v2 << endl;
    } 
    return 0;
  }

~~~
 A beolvasás a hagyományos módon megy, a paraméter meghatározza, hogy 
 mekkora adatszerkezet kell létrehozni, és ebbe direkt tölthetjük is be az 
 adatokat.

`<Adatok beolvasása>=`

~~~ {#Adatok_beolvasása .cpp}
  int N;
  cin >> N;
  int t[N];
  for (int i=0; i<N; i++) cin >> t[i];

~~~
 A két irányban talált személyek indexének tárolására két változót használunk.
Ezek kezdőértéke -1 lesz, felkészülve arra, hogy nincs ilyen személy.
Majd ezután az adott személyt megelőző személyek között keresgélünk.
A C jellemzője, ha a feltétel nem teljesül (mert például az első személy előtt
 próbálnánk keresni), akkor a ciklusmag nem hajtódik végre. 
Így nem okozunk bajt.
Ha pedig a ciklusmagban szereplő feltétel teljesül, megtaláltuk a keresett 
 személyt, felesleges tovább keresni, így elhagyjuk a ciklust.

`<Legyőzött keresése C++>=`

~~~ {#Legyőzött_keresése_C++ .cpp}
  v1 = -1;
  for (int j=i-1; j>=0; j--){
    if (t[j]<t[i]) { v1 = j+1; break; }
  }

~~~
 A másik irányban hasonló a helyzet, csak a másik irányban kell keresni,
 és a ciklusmagban szereplő feltétel is fordított irányú

`<Legyőző keresése C++>=`

~~~ {#Legyőző_keresése_C++ .cpp}
  v2 = -1;
  for (int j=i+1; j<N; j++){
    if (t[j]>t[i]) { v2 = j+1; break; }
  }

~~~

# Python listák
A Python akkor tud hatékonyan dolgozni, ha nem mi készítjük el manuálisan 
 a ciklusokat, hanem hagyjuk a fordítót dolgozni.
Mivel csak számokkal dolgozunk, egy tömbbe gyűjtjük az adatokat,
 hátha ezzel is nyerünk pár századmásodpercet.

`<victor2.py>=`

~~~ {#victor2_py}
  from array import *
  <<Beolvasás>>
  <<Elbonyolított feldolgozás>>

~~~
 

A _t_ tömb _i_ index előtti részére a ```t[:i] formában hivatkozhatunk.
Ebben kell egy olyan értéket keresni, amely a jelenlegi pontszámnál kisebb,
 tehát legyőzött.
Fontos, hogy ez hanyadik versenyző volt. Mivel a Python nullától indexel,
 az ```enumerate``` által megadott számnál eggyel nagyobb értékkel kell
 dolgoznunk. Az összes ilyen versenyző sorszámából készítünk egy listát.


`<Korábbi győzők>=`

~~~ {#Korábbi_győzők}
  a = [j+1 for j,k in enumerate(t[:i]) if k<t[i]]

~~~
 A tömb _i_ index mögötti részére ```t[i+1:]``` formában hivatkozhatunk.
Ebben kell az aktuális pontszámnál nagyobb, azaz legyőző versenyzőket keresni.
Miután nem az eredeti tömb, hanem az elejét csonkolt tömbbel dolgozunk, 
az _1_-en felül még _i+1_-et hozzá kell adni a versenyző _sorszámához_.

`<Későbbi legyőzöttek>=`

~~~ {#Későbbi_legyőzöttek}
  b = [j+i+2 for j,k in enumerate(t[i+1:]) if k>t[i]]

~~~

Miután az két értéket minden versenyzőre ki kell számítani, egy ciklussal 
végigmegyünk a teljes tömbön.

A legyőzött versenyzők közül az utolsóra vagyunk kíváncsiak (```a[-1]```), 
míg a legyőzők közül az elsőre (```b[0]```), ami elég furcsának hat,
ha nem vagyunk tisztában a Python tömbindexelésével.

Természetesen ezeket csak akkor írhatjuk ki, ha léteznek, azaz a kérdéses
tömbök nem üresek. 
A Python-ban a tömb nem üres voltát a tömbnév mint feltétel módon tesztelhetjük.
A C ```?:``` operátora egy más formában a Python-ban is létezik, 
ezt használtuk fel kétszer is az utolsó sorban. 
Ezzel az első tömb utolsó elemét írjuk ki, feltéve ha létezik, 
különben a hiányt jelző számot, illetve a második tömb első elemét, feltéve,
ha létezik, különben megint a hiányt jelző számot.


`<Elbonyolított feldolgozás>=`

~~~ {#Elbonyolított_feldolgozás}
  for i in range(N):
      <<Korábbi győzők>>
      <<Későbbi legyőzöttek>>
      print(a[-1] if a else -1, b[0] if b else -1)

~~~




----

# Kódrészletek
* [Adatok beolvasása](#Adatok_beolvasása)
* [Beolvasás](#Beolvasás)
* [Egyszerű feldolgozás](#Egyszerű_feldolgozás)
* [Elbonyolított feldolgozás](#Elbonyolított_feldolgozás)
* [Korábbi győzők](#Korábbi_győzők)
* [Későbbi legyőzöttek](#Későbbi_legyőzöttek)
* [Legyőzött keresése C++](#Legyőzött_keresése_C++)
* [Legyőzött keresése Python](#Legyőzött_keresése_Python)
* [Legyőző keresése C++](#Legyőző_keresése_C++)
* [Legyőző keresése Python](#Legyőző_keresése_Python)
* [victor.cpp](#victor_cpp)
* [victor1.py](#victor1_py)
* [victor2.py](#victor2_py)
