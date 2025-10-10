# Commonroad-scenario-designer docker
*A program GitHub repoja: [**Commonroad-scenario-designer**](https://github.com/CommonRoad/commonroad-scenario-designer).*

Konténerizált megoldás a *"Bevezetés az önvezető autók fejlesztésébe"* című tárgyhoz, mivel az órához kötelező program rendkívül minek van.
Mivel 3 Linux distro-n nem sikerült natívan működésre bírni egy nagyobb workaround nélkül, így gondoltam bedobom egy docker-be, és akkor másnak nem lesz szenvedés a program használata.

`docker build -t commonroad-designer .`\
Majd Linuxon *(A pwd az a terminal aktuális mappája)*:\
`docker run -it --rm -p 6080:6080 -v "$(pwd)/saved_files:/app/files" commonroad-designer`

Programon belül történő fájl mentése a "/app/files" mappába menjen, és akkor a saját gépeden is látni fogod. *(Mentéskor alapból a "/app" mappába mutat, ott pedig csak be kell lépni a "/files" mappába)*

> A konténer végleges mérete körülbelül *(optimalizálás előtt ~3.5GB)* ~1.87GB körül mozog.

Weboldal, ahol futtatás után el tudod érni: [localhost:6080/vnc.html](http://localhost:6080/vnc.html) 
