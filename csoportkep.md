% Csoportkép, 4/1
% Aszalós László

A feladatban azon időpontok számát kellett megszámolni egyes 
időintervallumokban, mikor a jelenlevők száma egy adott paramétert 
nem halad meg.

# Naív megoldás
## Python-ban
A legkézenfekvőbb megoldás esetén egy tömbben eltároljuk, 
hogy adott pillanatban hányan vannak jelen, 
és majd ezen számoljuk össze az egyes intervallumokba eső időpontok számát.

`<cskep1.py>=`

~~~ {#cskep1_py}
  <<Egyszerű beolvasás>>
  <<Egyszerű számolás>>

~~~


A paramétereket a feladat kitűzésének megfelelő nagybetűkkel írjuk.
Mind a személyekre, mind a felvételekre vonatkozó, 
kezdő és vég időpontokat a Python programban párban (```tuple```) tároljuk, 
és ezekből a párokból egy listát hozunk létre.


`<Egyszerű beolvasás>=`

~~~ {#Egyszerű_beolvasás .python}
  N, F = [int(x) for x in input().split()]
  szemely = []
  for i in range(N):
      kezd,veg = [int(x) for x in input().split()]
      szemely.append((kezd,veg))
  felvetel = []
  M = int(input())
  for i in range(M):
      kezd,veg = [int(x) for x in input().split()]
      felvetel.append((kezd,veg))

~~~

Miután minden megjelent személy adata ismert, 
tekintsük a távozásaik időpontjának a maximumát, hogy akkora adatszerkezetet
hozzunk létre. Miután csak számokról van szó, a hagyományos lista helyett az 
```array```-t használjuk.

Miután ez megvan, akkor minden egyes személy esetén azon időpontokhoz tartozó
 számlálót -- amikor jelen van -- eggyel növeljük. 
Ezzel a ```jelen``` tömbben -- a minta inputot használva --
 megkapjuk az ábrán látható pontok _y_ koordinátáit.

![Jelenlevők száma az idő függvényében](csoport1.png)

Végül nem maradt más dolgunk, mint végigmenni az egyes felvételeken,
 és összeszámolni azokat az időpontokat, melyek megfelelnek a feltételnek.
Majd felvételenként ezt egyből ki is írjuk.


`<Egyszerű számolás>=`

~~~ {#Egyszerű_számolás .python}
  from array import *
  hossz = max([x[1] for x in szemely])+1
  jelen = array("l",[0]*hossz)
  
  for k,v in szemely:
      for i in range(k,v+1):
          jelen[i]+=1
  # print(jelen)   # lásd az adatszerkezetet!
  
  for k,v in felvetel:
      szamol = 0
      for i in range(k,min(hossz,v+1)):
          if 0 < jelen[i] and jelen[i] <= F:
              szamol += 1
      print(szamol)

~~~
 
## C++-ban
Nincs alapvető különbség, ha ugyanezt C++-ban írjuk meg, csak ez a nyelv 
 kicsit szószátyárabb, nagyobb a körítés:


`<cskep1.cpp>=`

~~~ {#cskep1_cpp .cpp}
  #include <iostream>
  #include <algorithm>
  using namespace std;
  int main(){
    <<Vendégek adatai>>
    <<Aktuálisan jelenlévők száma>>
    <<Videófelvételek>>
    return 0;
  }

~~~
 Miután első input a vendégek száma, így az érkezések és távozások számára
 konkrét méretű adatszerkezetet (tömböt) lehet létrehozni. 
Akár közös tömbbe is szervezhetnénk ezeket az adatokat, de mivel a 
 távozásokkal külön foglalkozunk, ezért maradunk az elszeparáltságnál.


`<Vendégek adatai>=`

~~~ {#Vendégek_adatai .cpp}
  int N, F;
  cin >> N >> F;
  int kezd[N], veg[N];
  for (int i=0; i<N; i++){
    cin >> kezd[i] >> veg[i];
  }

~~~
 Noha egy ciklussal meg lehetne határozni a távozások ```veg``` tömbjének 
maximális elemét, de minél több kódot írunk, annál nagyobb az esélye egy 
programhibának. 
Ezért felhasználjuk a könyvtári függvényt, mely ennek az elemnek a helyét 
 adja vissza. 
Nekünk az értékre van szükségünk, ezért kell használni a ```*``` karaktert
 (lásd mutatók).

Miután már tudjuk, hogy mekkora tömbre van szükségünk, hogy minden változást
 feljegyezhessünk, létrehozzunk és inicializáljuk a tömböt.
Majd a jelenlevők adatai alapján kiszámoljuk az egyes időpillanatban jelenlevők
 számát.
Figyeljünk arra, hogy a távozás pillanatában még jelen van a kérdéses személy.


`<Aktuálisan jelenlévők száma>=`

~~~ {#Aktuálisan_jelenlévők_száma .cpp}
  int limit = *max_element(veg, veg+N);
  int jelen[limit+1] = {0};
  for (int i=0; i<N; i++){
    for (int j=kezd[i]; j<=veg[i]; j++){
      jelen[j] += 1;
    }
  }

~~~
 Ezek után már vehetjük az egyes videófelvélek adatait, és sorra 
 megszámolhatjuk, hogy hány olyan időpillanat van a felvétel során,
 mikor a kért feltétel teljesül.
Nincs más dolgunk, mint ezt egyszerűen kiírni.

`<Videófelvételek>=`

~~~ {#Videófelvételek .cpp}
  int M;
  cin >> M;
  int b, k, szamol;
  for (int i=0; i<M; i++){
      cin >> b >> k;
      szamol = 0;
      for (int j=b; j<=k; j++){
        if (0<jelen[j] && jelen[j]<=F) szamol++;
      }
      cout << szamol << endl;
  }

~~~

# Csak a változások figyelembe vétele
## Python megoldás
Abban az esetben, ha nem történik semmi (nem érkezik és nem is megy el senki),
akkor ugyanaz a csoportkép készül el (vagy nem készül el, ha túl sokan vannak).
Éppen ezért próbáljuk meg meghatározni azokat az időintervallumokat, melyek 
során a felvételek elkészülnek!

Míg az előbb összegyűjtöttük az összes személyre vonatkozó adatot,
és az alapján hoztunk létre egy adatszerkezetet, most egy ```dict```-ben
tároljuk a változásokat. Azért, hogy ne kelljen minden egyes kulcsnál 
inicializálni az értéket, a ```defaultdict``` variánst használjuk.


`<cskep2.py>=`

~~~ {#cskep2_py .python}
  from collections import defaultdict
  valt = defaultdict(int)
  N, F = [int(x) for x in input().split()]
  <<Változások feljegyzése>>
  <<Intervallumok meghatározása>>
  <<Metszetek mérete>>

~~~
 Amint valaki megérkezik, akkor a létszám egyből eggyel nő. 
Ha viszont elmegy, akkor abban az időpillanatban még rajta van a képen, 
így csak a rákövetkező időpillanatban csökken a létszám.


`<Változások feljegyzése>=`

~~~ {#Változások_feljegyzése .python}
  for i in range(N):
      kezd,veg = [int(x) for x in input().split()]
      valt[kezd] += 1
      valt[veg+1] -= 1
  # print(valt)  # adatszerkezet megmutatása

~~~


![Jelenlevők számának változása az idő függvényében](csoport2.png)

A minta inputot felhasználva a képen látható pontok kerülnek be a ```valt``` 
változóba, de ezek akármilyen sorrendben lehetnek.

A ```valt``` változóban található változásokat sorrendben kell figyelembe 
 venni, ezért a kulcsait rendezve használjuk fel. 
A ```jelen``` változó az aktuálisan jelenlévők számát tárolja. 
A ```vaku``` logikai változó jelzi, hogy milyen fázisnál tartunk. 
Ha hamis, azaz nem készültek fényképek, de most már teljesül a feltétel,
 akkor a váltunk, illetve elkezdünk egy új fényképezési intervallumot.
Míg ha a ```vaku``` igaz értékénél már nem teljesül a feltétel, le kell zárni
 az intervallumot, és hozzáadni a ```van_kep``` listához.
Természetesen ha úgy fogynak el a változásaink, hogy még villogtak a vakuk, 
akkor az utoljára megnyitott intervallumot kell lezárni.


`<Intervallumok meghatározása>=`

~~~ {#Intervallumok_meghatározása .python}
  jelen = 0
  van_kep=[]
  vaku = False
  for i in sorted(valt.keys()):
      jelen += valt[i]
      if 0 < jelen and jelen <= F and not vaku:
          vaku = True
          kezd = i
      elif (jelen > F or jelen <= 0) and vaku:
          van_kep.append((kezd,i-1))
          vaku = False
  if vaku:
      van_kep.append((kezd, max(valt.keys())))

~~~
 Egyrészt adottak a fényképezési, másrész a videós intervallumok.
Ezek metszeteit kell elkészíteni. 
Ehhez a sorban érkezdő videós intervallumot sorra elmetszük 
a fényképezős intervallumokkal, és ha a metszet nem üres, 
akkor a metszerek hosszát összegezzük.


`<Metszetek mérete>=`

~~~ {#Metszetek_mérete .python}
  felvetel = []
  M = int(input())
  for i in range(M):
      kezd,veg = [int(x) for x in input().split()]
      hossz = 0
      for k,v in van_kep:
          ik = max(kezd,k)
          iv = min(veg, v)
          if ik<=iv:
              hossz += iv-ik+1
          if v>veg:
              break; # biztos nincs tobb illeszkedo intervallum
      print(hossz)

~~~


## C++-ban
Lássuk ugyanez hogyan fogalmazható meg C++ nyelven!

Annak érdekében, hogy egyszerűbben fogalmazzunk, bevezetünk két új típust. 
Az első a változások "dict"-je, azaz C++ terminológiában ```map```-ja,
míg a másik az intervallumot leíró pár lesz.

A program szerkezete lényegében ugyanaz, mint az előbb, csak mivel egy 
fájlban szerepel a Python és C++ változat is, ugyanannak a résznek nem 
adhatjuk ugyanazokat az elnevezéseket.


`<cskep2.cpp>=`

~~~ {#cskep2_cpp .cpp}
  #include <iostream>
  #include <map>
  #include <vector>
  using namespace std;
  typedef std::map <int, int> Mii; 
  typedef pair <int, int> intervallum;
  <<Változások rögzítése>>
  int main(){
    <<Jelenlévők>>
    <<Összegzés>>
    <<Összehasonlítás>>
    return 0;
  }

~~~
 C++ esetén ```defaultdict```-hez hasonló szerkezet nem létezik alapból,
ezt nekünk kellene megcsinálni. Mindent nem implementálunk belőle, csak 
a feladat megoldásához szükséges részt. 
Azért, hogy az itt elvégzett változások a főprogramban is megmaradjanak,
a ```map``` adatszerkezetünket referenciaként kell használni.


`<Változások rögzítése>=`

~~~ {#Változások_rögzítése .cpp}
  void beszur(Mii &valt, int kulcs, int ertek){
    Mii::iterator it = valt.find(kulcs);
    if (it==valt.end()){
      valt[kulcs]=ertek;
    } else {
      valt[kulcs] += ertek;
    }
  }

~~~
 A korábbiakhoz hasonlóan itt is bekérjük a paramétereket, 
majd a vendégek adatait, mint változásokat eltároljuk.


`<Jelenlévők>=`

~~~ {#Jelenlévők .cpp}
  int N, F;
  cin >> N >> F;
  Mii valtozik;
  int kezd, veg;
  for (int i=0; i<N; i++){
    cin >> kezd >> veg;
    beszur(valtozik, kezd, 1);
    beszur(valtozik, veg+1, -1);
  }

~~~
 Az előzőtől eltérően itt most kihasználhatjuk a C++ azon tulajdonságát, hogy
a ```map```-ben a kulcsok szerint rendezetten szerepelnek az adatok.
Azaz csak végig kell menni az adatszerkezeten, és a kulcsokhoz tartozó 
akkumulált értékek alapján döntünk, hogy a fényképkészítés feltétele teljesül.
vagy sem. Amint egy fényképezési szakasz (intervallum) lezárul, azt eltároljuk.
Végül ha van elkezdett szakaszunk, az is le kell zárni, az utolsó kulccsal.
Erre a fordított iterátor (```rbegin```) nagyon jól használható.


`<Összegzés>=`

~~~ {#Összegzés .cpp}
  vector <intervallum> fotok;
  bool vaku=false;
  int szint = 0;
  for (Mii::iterator it=valtozik.begin(); it!=valtozik.end(); it++){
    szint += it->second;
    if (0<szint && szint<=F && !vaku){
      vaku = true;
      kezd = it->first;
    } else {
      if ((szint > F || szint <= 0) && vaku) {
        fotok.push_back(make_pair(kezd, it->first-1));
        vaku=false;
      }
    }
  }
  if (vaku){
    fotok.push_back(make_pair(kezd, valtozik.rbegin->first));
  }

~~~
 Szinte ugyanazt csináljuk, mint az előbb, a videóhoz tartozó intervallumhoz 
keresünk illeszkedő fotós intervallumot.
A minimum és maximum számítással megkeressük az intervallumok metszetét, 
és ha ez létezik, felhasználjuk a hosszát.
Ha biztosak vagyunk, hogy már nem várható több metszet, 
akkor a ciklust lezárjuk.


`<Összehasonlítás>=`

~~~ {#Összehasonlítás .cpp}
  int M;
  cin >> M;
  int b, k, db;
  for (int i=0; i<M; i++){
      cin >> b >> k;
      db = 0;
      for (auto it=fotok.begin(); it!=fotok.end(); it++){
        int ik=max(b,it->first);
        int iv=min(k,it->second);
        if (ik<=iv) db += iv-ik+1;
        if (it->second > k) break;
      }
      cout << db << endl;
  }

~~~




----

# Kódrészletek
* [Aktuálisan jelenlévők száma](#Aktuálisan_jelenlévők_száma)
* [Egyszerű beolvasás](#Egyszerű_beolvasás)
* [Egyszerű számolás](#Egyszerű_számolás)
* [Intervallumok meghatározása](#Intervallumok_meghatározása)
* [Jelenlévők](#Jelenlévők)
* [Metszetek mérete](#Metszetek_mérete)
* [Vendégek adatai](#Vendégek_adatai)
* [Videófelvételek](#Videófelvételek)
* [Változások feljegyzése](#Változások_feljegyzése)
* [Változások rögzítése](#Változások_rögzítése)
* [cskep1.cpp](#cskep1_cpp)
* [cskep1.py](#cskep1_py)
* [cskep2.cpp](#cskep2_cpp)
* [cskep2.py](#cskep2_py)
* [Összegzés](#Összegzés)
* [Összehasonlítás](#Összehasonlítás)
