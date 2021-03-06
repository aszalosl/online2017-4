% Karavánok találkozása 4/2
% Aszalós László

# Naív Python megoldás

Az input három fajta adatot tartalmaz, ennek megfelelően a program első része
 ezt a felosztást követi. 
Majd ezek után jön a számolás rész, mely tartalmazni fogja az eredmények
 kiírását is.

`<caravan.py>=`

~~~ {#caravan_py .python}
  from collections import defaultdict
  <<Paraméterek>>
  <<Távolságok>>
  <<Útvonalak>>
  <<Közös pihenések>>

~~~
 Az input első sora a feladat paramétereit tartalmazza.
Ennek beolvasása a megszokott mintát követi.


`<Paraméterek>=`

~~~ {#Paraméterek .python}
  N, M, K = [int(x) for x in input().split()]

~~~

Ezt követik az egyes oázisok távolságai.
Mivel a távolság feltételezhetően szimmetrikus érték, 
az egyszerűség kedvéért a ```dict``` adatszerkezetben mindkét irányt
 szerepeltetjük.


`<Távolságok>=`

~~~ {#Távolságok .python}
  tavol={}
  for i in range(M):
      k, v, h = [int(x) for x in input().split()]
      tavol[k,v] = h
      tavol[v,k] = h

~~~

A soron következő sorok tárolják az egyes karavánok indulásának időpontját,
és a felkeresett oázisokat. 
A sor második számaként tárolt darabszámot nem használjuk, Python esetén
nincs rá szükség.

Miután kiszámoltuk azokat az időpontokat, amikor elérte a karaván az oázist,
eltároljuk az adott naphoz (illetve a feladat szövegét követve a következőhöz)
és az adott oázishoz a karaván azonosítóját.
Itt újfent asszociatív tömböt használunk, és hogy ne okozzon gondot a hiányzó
 kezdőérték, ez ```defaultdict``` lesz, és azonosítók listáját tartalmazza.

`<Útvonalak>=`

~~~ {#Útvonalak .python}
  pihen = defaultdict(list)
  for i in range(K):
      l = [int(x) for x in input().split()]
      start = l[0]
      <<Pihenők meghatározása>>
      for (n, o) in zip(ns, l[3:]):
          pihen[(n,o)].append(i+1)
          pihen[(n+1,o)].append(i+1)

~~~

Talán átláthatóbb lenne, ha minden egyes ciklust kifejtenénk, 
 de ekkor a futási idő nagyságrenddel nagyobb lenne. 
Épp ezért a lista értelmezést alkalmazzuk.
Elsőként az egymást követő oázisok azonosítóiból párokat képzünk (```zip```),
 majd tekintjük az ezekhez eltárolt távolságokat (napokban mérve).
Ezután ezek kumulált összegeit határozzuk meg (a ```sum``` szerkezetben).
Miután az oázisban a karaván megpihen egy napra, az összeghez képest egyre
 növevő mértékben eltérnek a pihenők időpontjai.
Ehhez az ```enumerate``` pont jó számokat szolgáltat, s már csak a kezdő 
 időpontot kell még ezekhez hozzáadni, és meg is vannak az oázisba érkezések
 időpontjai.


`<Pihenők meghatározása>=`

~~~ {#Pihenők_meghatározása .python}
  ds = [tavol[xy] for xy in zip(l[2:],l[3:])]
  ns = [start+j+x for (j,x) in enumerate(sum(ds[:z]) for z in range(1,len(ds)+1))]

~~~

Van egy hatalmas adatszerkezetünk, mely az összes pihenő adatát tartalmazza.
Számunkra csak az izgalmas, ha a karaván egy másik karavánnak együtt pihen.
Épp ezért csak azok a bejegyzéseket vesszük figyelembe (```t```), 
 ahol egyszerre többen is vannak, azaz a tárolt lista hossza legalább 2.
Ezek után végigmegyünk az összes karavánon, és keressünk azokat a 
 bejegyzéseket ```t```-ben, ahol ez a karavánazonosító előfordul.
Ez egy listák listáját adná, amit ellaposítunk, hogy csak egy listánk legyen.
Nincs kizárva, hogy egy másik karavánnal többször is találkozik az adott
 karaván, ezért a listából egy halmazt készítünk, hogy a dupla előfordulások
 eltűnjenek.
Ha az eredményül kapott lista üres, akkor 0-t kell kiírni, míg ha nem, 
 akkor a vele együtt pihenő karavánok számát, de mivel a halmazban a saját
 karaván is szerepel, így a lista méreténél eggyel kisebbet kell megadni.
Az egyszerűség kedvéért mindezt egy kifejezésbe vontuk össze.

`<Közös pihenések>=`

~~~ {#Közös_pihenések .python}
  t = [pihen[x] for x in pihen if len(pihen[x])>1]
  for i in range(K):
      x = len(set(e for l in t for e in l if i+1 in l))
      print(x-1 if x>1 else 0)

~~~


# C++ megoldás

Elég összetett a feladat, és igen hosszú programkód is tartozik hozzá.
Ha viszont azt akarjuk, hogy hatékony legyen a megoldásunk, erre szükség lehet.
Az alábbiakból látható, hogy felhasználjuk a vektorok adta lehetőséget, illetve
a kulcslépés is itt található a programlistában, rendezzük az összegyűjtött 
adatokat!


`<caravan.cpp>=`

~~~ {#caravan_cpp .cpp}
  #include <iostream>
  #include <vector>
  #include <algorithm>
  using namespace std;
  <<Segédstruktúra>>
  int main(){
    <<Paraméterek és távolságok beolvasása>>
    <<Útvonalak beolvasása és feldolgozása>>
    sort(piheno.begin(), piheno.end(), kisebb);
    <<Találkozások meghatározása>>
    <<Eredmények kiírása>>
   return 0;
  }

~~~
 Az nem elég, hogy két karaván ugyanabban a sivatagban pihen meg, 
vagy ha ugyanazon a napon pihennek meg, csak akkor találkoznak, ha ugyanazon az
éjszakán ugyanott szállnak meg. 
Éppen ezért egy struktúrát hozunk létre, melyben ezen a két adaton felül még 
a karaván azonosítója is szerepel. 

Annak érdekében, hogy az ilyen bejegyzések sorozatát lexografikus sorrendbe
lehessen állítani, megalkotunk egy segédfüggvényt is, mely két ilyen hármast
összehasonlít.

Sőt kell egy olyan függvény is, mely a találkozást teszteli


`<Segédstruktúra>=`

~~~ {#Segédstruktúra .cpp}
  typedef struct {int mikor; int hol; int ki;} Pihen;
  bool kisebb(const Pihen& x, const Pihen& y) {
    if (x.mikor != y.mikor) return (x.mikor < y.mikor);
    if (x.hol != y.hol) return (x.hol < y.hol);
    return x.ki < y.ki;
  }
  bool talalkozik(const Pihen& x, const Pihen& y) {
    return (x.mikor == y.mikor) && (x.hol == y.hol);
  }

~~~
 A beolvasás nem sok újdonságot tartalmaz.
A paraméterek beolvasása után most egy asszociatív tömb helyett egy egyszerű
 mátrixot hozunk létre, ahol a nem 0 elemek a távolságokat jelölik.
Természetesen ez is szimmetrikus mátrix lesz, mint az előző megoldásban.
Helytakarékosságból és mivel a C++ is 0-tól kezdi a számozást, az oázisok
 azonosítóiból egyet levonunk.


`<Paraméterek és távolságok beolvasása>=`

~~~ {#Paraméterek_és_távolságok_beolvasása .cpp}
  int N, M, K;
  cin >> N >> M >> K;
  int tavol[N][N] = {0};
  int x, y, w;
  for (int i=0; i<M; i++){
    cin >> x >> y >> w;
    tavol[x-1][y-1] = w;
    tavol[y-1][x-1] = w;
  }

~~~
 Egyetlen vektorba gyűjtjük az összes karaván általi oázisbeli éjszakázások
adatait.
Ehhez sorra kell venni az egyes karavánokat, és végiglépdelni az útvonalukon,
figyelembe véve a kezdés időpontját, az egyes oázisok távolságát, illetve 
az 1-1 nap pihenőt. A megfelelő hármasokat eltároljuk (mind a két alkalmat).


`<Útvonalak beolvasása és feldolgozása>=`

~~~ {#Útvonalak_beolvasása_és_feldolgozása .cpp}
  vector <Pihen> piheno; 
  for (int i=0; i<K; i++){
    int start, db, actual, next, nap;
    cin >> start >> db;
    vector <Pihen> l;
    nap = start;
    cin >> actual;
    for (int j=0; j<db-2; j++){
      cin >> next;
      nap += tavol[actual-1][next-1];
      Pihen p;
      p.mikor = nap; p.hol = next; p.ki = i;
      piheno.push_back(p);
      p.mikor = nap+1;
      piheno.push_back(p);
      actual = next;
      nap += 1;
    }
    cin >> actual;
  }

~~~
 Miután minden éjszaka birtokában vagyunk, és az adatokat rendeztük a napok 
és oázisok szerint, végigmegyünk ezen a listán.
Az találkozásokat egy logikai mátrixban fogjuk tárolni, melynek méretét a
karavánok száma adja meg.

Ha egymás után két azonos napra és oázisra vonatkozó bejegyzést találunk,
akkor még továbbiak után is keresünk, majd minden párosításra feljegyezzük
a találkozást.


`<Találkozások meghatározása>=`

~~~ {#Találkozások_meghatározása .cpp}
  bool talal[K][K];
  for (int i=0; i<K; i++)
    for (int j=0; j<K; j++)
      talal[i][j] = false;
  
  for (uint i=0; i<piheno.size()-1; i++){
    if (talalkozik(piheno[i], piheno[i+1])){
        uint j=i+1;
        while (j<piheno.size()-1 && talalkozik(piheno[j], piheno[j+1])) j++;
        for (uint k=i; k<=j; k++)
          for (uint l=i; l<=j; l++)
            if (k!=l) {
              talal[piheno[k].ki][piheno[l].ki] = true;
              talal[piheno[l].ki][piheno[k].ki] = true;
            }
    }
  }

~~~
 A mátrix minden sorában ott van, hogy mely karaván melyekkel találkozott.
Nincs más dolgunk, mint ezeket sorra összeszámolni és kiírni.


`<Eredmények kiírása>=`

~~~ {#Eredmények_kiírása .cpp}
  for (int i=0; i<K; i++){
    int k = 0;
    for (int j=0; j<K; j++)
      if (talal[i][j]) k++;
    cout << k << endl;
  }

~~~



----

# Kódrészletek
* [Eredmények kiírása](#Eredmények_kiírása)
* [Közös pihenések](#Közös_pihenések)
* [Paraméterek](#Paraméterek)
* [Paraméterek és távolságok beolvasása](#Paraméterek_és_távolságok_beolvasása)
* [Pihenők meghatározása](#Pihenők_meghatározása)
* [Segédstruktúra](#Segédstruktúra)
* [Találkozások meghatározása](#Találkozások_meghatározása)
* [Távolságok](#Távolságok)
* [caravan.cpp](#caravan_cpp)
* [caravan.py](#caravan_py)
* [Útvonalak](#Útvonalak)
* [Útvonalak beolvasása és feldolgozása](#Útvonalak_beolvasása_és_feldolgozása)
