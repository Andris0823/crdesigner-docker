# Commonroad-scenario-designer Docker

*A program GitHub repója: [**Commonroad-scenario-designer**](https://github.com/CommonRoad/commonroad-scenario-designer).*

Konténerizált megoldás a *"Bevezetés az önvezető autók fejlesztésébe"* című tárgyhoz, mivel az órához kötelező program rendkívül minek van.
Hallgatóknak elég egyetlen `docker run` parancs, a Docker automatikusan letölti az image‑et, ha még nincs meg lokálisan.

Megjegyzések:
- A noVNC felület a 6080‑as porton érhető el böngészőből.
- A VNC szerver jelszó nélkül fut (SecurityTypes None), ezért csak megbízható, helyi hálózaton használd.
---

## Követelmények
- Telepített és futó Docker/docker-cli (Linux, macOS, Windows)
- Szabad 6080‑as port (ha VNC klienst is használsz: 5900)
- *Ajánlott: legalább 2–4 GB szabad RAM*

---

## Futtatás (perzisztens mentéssel)

Az alábbi parancsok automatikusan lehúzzák az image‑et, ha nincs lokálisan.  
A `saved_files` mappát a jelenlegi könyvtáradban hozza létre (ha még nem létezik), és a konténerben `/app/files` néven jelenik meg.
(Programon belül történő fájl mentése a `/app/files` mappába menjen, és akkor a saját gépeden is látni fogod a `saved_files` mappában. *(Mentéskor alapból a `/app` mappába dob be, ott pedig csak be kell lépni a `/files` mappába)*)

Használandó image:
- docker.io/andris0823/commonroad-designer:latest

### Linux / macOS / WSL (Bash)
```bash
docker run -it --rm -p 6080:6080 -v "$(pwd)/saved_files:/app/files" andris0823/commonroad-designer:latest
```

### Windows (PowerShell)
```powershell
docker run -it --rm -p 6080:6080 -v "${PWD}/saved_files:/app/files" andris0823/commonroad-designer:latest
```

### Windows (Command Prompt)
```cmd
docker run -it --rm -p 6080:6080 -v "%cd%\saved_files:/app/files" andris0823/commonroad-designer:latest
```

Opcionális: ha VNC klienst is használnál, add hozzá a 5900‑as portot:
- Bash/PowerShell/CMD: `-p 5900:5900`

---

## Elérés
- Böngésző: [localhost:6080/vnc.html](http://localhost:6080/vnc.html) (noVNC)
- VNC kliens (opcionális): `localhost:5900` (jelszó nélkül)

Leállítás: a futó terminálban Ctrl+C

---

## Offline / korlátozott hálózat esetén (.tar, Release-ben letölthető)
1) Image betöltése:
```bash
docker load -i crdesigner.tar
```

2) Futtatás:
- Bash (Linux/macOS/WSL):
  ```bash
  docker run -it --rm -p 6080:6080 -v "$(pwd)/saved_files:/app/files" crdesigner
  ```
- Windows PowerShell:
  ```powershell
  docker run -it --rm -p 6080:6080 -v "${PWD}/saved_files:/app/files" crdesigner
  ```
- Windows CMD:
  ```cmd
  docker run -it --rm -p 6080:6080 -v "%cd%\saved_files:/app/files" crdesigner
  ```

Ha nem vagy biztos a betöltött címkében, listázd ki:  
- Linux/macOS: `docker images | grep crdesigner`  
- Windows: `docker images`

---

## Fejlesztőknek (opcionális): Build + Run

Ez a rész teljesen opcionális viszont leírom, ha valaki szeretné a GitHub-ra feltöltött fájlokból buildelni.

1) Build parancs (Mindegyik rendszeren ugyan az):
```
docker build -t crdesigner .
```
2) Futtatás:

- Linux / macOS / WSL (Bash)
  ```bash
  docker run -it --rm -p 6080:6080 -v "$(pwd)/saved_files:/app/files" crdesigner
  ```

- Windows (PowerShell 7+)
  ```powershell
  docker run -it --rm -p 6080:6080 -v "${PWD}/saved_files:/app/files" crdesigner
  ```

- Windows (PowerShell 5.1)
  ```powershell
  docker run -it --rm -p 6080:6080 -v "${PWD}/saved_files:/app/files" crdesigner
  ```

- Windows (Command Prompt)
  ```cmd
  docker run -it --rm -p 6080:6080 -v "%cd%\saved_files:/app/files" crdesigner
  ```

---

## Hibakeresés
- Üres/fehér noVNC oldal: pár másodperc indulási idő természetes; frissíts rá, ha szükséges.
- Kapcsolódási hiba:
  - Biztosan fut a Docker?
  - A 6080/5900 portokat nem használja más folyamat? Próbáld: `-p 6081:6080` (és/vagy `-p 5901:5900`).
- Windows:
  - Docker Desktop/WSL2 legyen telepítve és fusson.
