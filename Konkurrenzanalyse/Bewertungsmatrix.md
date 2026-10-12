## Bewertungsmatrix: Konkurrenzanalyse

Bewertungsskala: 0 = nicht erfüllt, 1 = kaum erfüllt, 2 = teilweise erfüllt, 3 = weitgehend erfüllt, 4 = vollständig erfüllt; n. a. = nicht anwendbar

Nutzwert = Σ (Gewicht × Punkte) / 4

Bei nicht anwendbaren Kriterien wird der Nutzwert auf die Summe der bewerteten Gewichte normiert: Nutzwert (normiert) = Σ (Gewicht × Punkte / 4) / Σ bewertete Gewichte × 100

Die Einzelbewertungen und Begründungen sind in den Prüfprotokollen der jeweiligen Tools dokumentiert. Cryptomator wird aufgrund seines abweichenden Konzepts nicht bewertet und ist in einem eigenen Steckbrief beschrieben.

| Kategorie | Nr. | Kriterium | Gewicht | Messmethode | Kleopatra | Picocrypt-NG | age |
|---|---|---|---:|---|:---:|:---:|:---:|
| **Sicherheit** | S1 | Moderne AEAD-Verschlüsselung und Integritätsschutz (Header und Chunks) | 6 | Doku/Spezifikation | 2 | 4 | 4 |
| | S2 | Stärke der Passwort-KDF (Argon2id > scrypt > iteriertes S2K) | 6 | Doku/Quellcode | 1 | 4 | 3 |
| | S3 | Post-Quanten-Resistenz (hybrid, standardisiert, standardmäßig aktiv) | 6 | Doku/Release Notes | 3 | n. a. | 3 |
| | S4 | Sichere Defaults, keine unsicheren Optionen wählbar | 6 | Eigener Test | 2 | 3 | 3 |
| | S5 | Öffentliche Spezifikation und unabhängige Audits | 6 | Recherche | 3 | 3 | 3 |
| **Usability** | U1 | Zeit bis zur ersten erfolgreichen Verschlüsselung (Laie) | 8 | Aufgabentest | 4 | 4 | 1 |
| | U2 | Anzahl der Interaktionsschritte pro Standardaufgabe | 6 | Klicks/Befehle zählen | 3 | 4 | 3 |
| | U3 | Verständlichkeit von Fehlermeldungen | 7 | Provozierte Fehler | 1 | 2 | 2 |
| | U4 | Komplexität der Schlüsselverwaltung | 8 | Cognitive Walkthrough | 1 | n. a. | 3 |
| | U5 | Schutz vor Fehlbedienung (Passwortbestätigung, Stärkeanzeige, Überschreibschutz) | 6 | Eigener Test | 2 | 3 | 1 |
| **Funktionsumfang** | F1 | Passwort- und Public-Key-Modus | 5 | Doku | 4 | 2 | 4 |
| | F2 | Mehrere Empfänger pro Datei | 3 | Doku | 3 | n. a. | 3 |
| | F3 | Große Dateien/Streaming ohne hohen RAM-Verbrauch | 4 | Test mit >4 GB-Datei | 4 | 4 | 3 |
| | F4 | Erweiterbarkeit (Plugins, Hardware-Token) | 3 | Doku | 3 | 0 | 4 |
| **Plattform** | P1 | Betriebssystem-Abdeckung | 4 | Doku | 2 | 4 | 3 |
| | P2 | Installation/Portabilität | 3 | Eigener Test | 2 | 4 | 3 |
| | P3 | Interoperabilität, offenes Dateiformat | 3 | Spezifikation | 4 | 3 | 4 |
| **Wartung** | W1 | Aktive Weiterentwicklung | 5 | Commits/Releases | 4 | 4 | 3 |
| | W2 | Lizenz/Open Source | 2 | Repository | 4 | 4 | 4 |
| | W3 | Dokumentation und Community | 3 | Recherche | 4 | 3 | 2 |
| | | **Summe bewertete Gewichte** | | | **100** | **83** | **100** |
| | | **Erreichte gewichtete Punkte** | | | **65,75** | **68,00** | **70,25** |
| | | **Nutzwert (0–100)** | | | **65,75** | **81,93** | **70,25** |

### Teilergebnisse nach Kategorie

Angegeben sind die erreichten gewichteten Punkte, das Maximum der bewerteten Kriterien und der Erfüllungsgrad.

| Kategorie | Max. | Kleopatra | Picocrypt-NG | age |
|---|---:|:---:|:---:|:---:|
| Sicherheit | 30 | 16,50 / 30 (55,0 %) | 21,00 / 24 (87,5 %) | 24,00 / 30 (80,0 %) |
| Usability | 35 | 19,25 / 35 (55,0 %) | 22,00 / 27 (81,5 %) | 17,50 / 35 (50,0 %) |
| Funktionsumfang | 15 | 13,50 / 15 (90,0 %) | 6,50 / 12 (54,2 %) | 13,25 / 15 (88,3 %) |
| Plattform | 10 | 6,50 / 10 (65,0 %) | 9,25 / 10 (92,5 %) | 8,25 / 10 (82,5 %) |
| Wartung | 10 | 10,00 / 10 (100,0 %) | 9,25 / 10 (92,5 %) | 7,25 / 10 (72,5 %) |
| **Gesamt** | **100** | **65,75 / 100 (65,75 %)** | **68,00 / 83 (81,93 %)** | **70,25 / 100 (70,25 %)** |

### Sensitivität der Normierung

Werden die nicht anwendbaren Kriterien von Picocrypt-NG (S3, U4, F2) nicht ausgeklammert, sondern mit 0 Punkten bewertet, ergibt sich folgende Rangfolge:

| Variante | Kleopatra | Picocrypt-NG | age |
|---|:---:|:---:|:---:|
| Normiert (n. a. ausgeklammert) | 65,75 | 81,93 | 70,25 |
| Nicht normiert (n. a. = 0 Punkte) | 65,75 | 68,00 | 70,25 |

### Testszenarien für Usability-Kriterien

| Nr. | Aufgabe | Relevante Kriterien |
|---|---|---|
| T1 | 1-GB-Datei mit Passwort verschlüsseln | U1, U2, U5 |
| T2 | Datei für eine andere Person (Public Key) verschlüsseln | U2, U4 |
| T3 | Datei mit falschem Passwort entschlüsseln | U3 |
| T4 | Manipulierte Datei entschlüsseln | U3, S1 |
