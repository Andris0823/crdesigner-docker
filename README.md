# Commonroad-scenario-designer docker
*A program GitHub repoja: [**Commonroad-scenario-designer**](https://github.com/CommonRoad/commonroad-scenario-designer).*

Konténerizált megoldás a *"Bevezetés az önvezető autók fejlesztésébe"* című tárgyhoz, mivel az órához kötelező program rendkívül minek van.
Mivel 3 Linux distro-n nem sikerült natívan működésre bírni egy nagyobb workaround nélkül, így gondoltam bedobom egy docker-be, és akkor másnak nem lesz szenvedés a program használata.

A feltöltött fájlok között van egy **Build**, és van egy **Csomagolt** (.tar) változat. Lentebb mindegyik alá odaraktam a parancsot is, amivel tudod futtatni, ha a csatolt batch file nem futna.\
Felraktam docker.io-ra is, szerintem onnan a legegyszerűbb megoldani az egészet.

**Docker.io image pull** parancsa, és innen le tudod húzni az image-et:\
`docker pull andris0823/commonroad-designer:latest`\
Majd:\
`docker run -it --rm -p 6080:6080 -p 5900:5900 andris0823/commonroad-designer:latest`

**Build változat** fő lényege: Ha nagyon nem szereted magad, akkor megpróbálhatod optimalizálni a dependency listát, amire én már azért nem fordítottam figyelmet, mert így is örültem, hogy elindult.
Másrészről raktam bele egy run.bat fájlt, szóval Windows-on csak elindítod, és felépíti önmagát *(4KB ez a változat letöltve)*.
Build time SSD és merevlemez között kérdőjeles időt vesz igénybe, az én kis krumplimon *(SSD-n)* 400 másodperc volt a leghosszabb talán.\
`docker build -t commonroad-designer .`\
`docker run -it --rm -p 6080:6080 -p 5900:5900 commonroad-designer`

**Csomagolt változat**: Ha nem szeretnéd magadnak buildelni, akármilyen okból kifolyólag, akkor ezt töltsd le. Kicsit nagyobb *(866MB)*, viszont ez offline is működik *(persze, ha le van szedve :D)*
Ennek idézőjeles kicsomagolása körülbelül 5-10 percet vesz igénybe *(merevlemezen lehet több is)*. A batch script itt nem ír részletes folyamatot, szóval nem kell megijedni, megy a háttérben a folyamat.\
`docker load -i commonroad-designer.tar`\
`docker run -it --rm -p 6080:6080 -p 5900:5900 commonroad-designer`

> A konténer végleges mérete körülbelül ~3.5GB körül mozog.

Weboldal, ahol futtatás után el tudod érni: [localhost:6080/vnc.html](http://localhost:6080/vnc.html) 
