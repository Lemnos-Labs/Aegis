# Fragebogen zur Festlegung der Randbedingungen

Ziel: Klären, welche Rahmenbedingungen für Aegis vorgegeben oder bewusst festgelegt sind. Jede beantwortete Frage, die den Lösungsraum einschränkt, wird anschließend als Randbedingung (RB-xx) übernommen. Fragen, die offen bleiben, werden als offene Entscheidung markiert.

## 1. Organisation und Rahmen

| Nr. | Frage | Hinweise / Antwortoptionen | Antwort |
|---|---|---|---|
| O1 | Wie lange ist der Bearbeitungszeitraum, und wann ist die Abgabe? | Zwei Semester; konkretes Abgabedatum | Insgesamt 900 h Workload für das Team, verteilt über zwei Theoriesemester und die dazwischenliegende Praxisphase (ca. 3 Monate) |
| O2 | Gibt es Zwischenabgaben, Meilensteine oder Präsentationen? | z. B. Zwischenbericht nach Semester 1 | Keine verpflichtenden Zwischenabgaben, aber regelmäßiger Austausch mit dem Dozenten geplant |
| O3 | Wie viele Personen arbeiten mit, und wie ist die Aufgabenteilung? | z. B. Kryptokern / Oberfläche / Dokumentation | 3 Personen, Aufgabenteilung agil nach Issues mit unterschiedlichem Fokus auf verschiedene Themen |
| O4 | Wie viel Zeit steht pro Person und Woche ungefähr zur Verfügung? | Stunden pro Woche; Phasen mit wenig Zeit (Klausuren, Praxisphase) | Ca. 12 h pro Person und Woche in den Theoriephasen; zusätzlich Arbeit nebenbei in der Praxisphase |
| O5 | Welche Vorgaben macht die DHBW zur Arbeit? | Seitenumfang, Gliederung, Zitierstil, Sprache, Abgabeformat | https://www.ravensburg.dhbw.de/fileadmin/user_upload/Dokumente/Dokumente_fuer_Studierende/251110_Leitlinien_Praxismodule_Studien_Bachelorarbeiten.pdf |
| O6 | Welche Erwartungen hat der Betreuer an Umfang und Schwerpunkt? | Schwerpunkt eher Implementierung, Usability oder Kryptografie? | Schwerpunkt auf Usability, tiefe Kryptografie als Voraussetzung für wissenschaftlichen Anteil |
| O7 | Muss die Anwendung am Ende vorgeführt werden? | Live-Demo, Video, nur schriftlich | Live-Demo als Infostand (evtl. Wettkampf Setup mit Verschlüsselungsapps, die gegeneinander antreten) |
| O8 | Gibt es ein Budget? | Kosten für Zertifikate, Hosting, Testgeräte | nein |

## 2. Technische Basis

| Nr. | Frage | Hinweise / Antwortoptionen | Antwort |
|---|---|---|---|
| T1 | In welcher Programmiersprache wird entwickelt? | Rust (festgelegt?) | Rust |
| T2 | Welche Mindestversion von Rust bzw. welcher Toolchain-Kanal wird verwendet? | stable, festgelegte MSRV | stable, Mindestversion 1.99 (festgelegt über `rust-toolchain.toml`) |
| T3 | Wie sieht die Entwicklungsumgebung aus? | Fedora, Fedora WSL, Nix; Editor/IDE frei wählbar? | Windows und Fedora, ohne Nix |
| T4 | Welche Versionsverwaltung und Plattform wird genutzt? | Git, GitHub (Repository `OkeemoG/Aegis`) | GitHub |
| T5 | Wird CI/CD genutzt? | GitHub Actions für Build, Tests, Releases | CI |
| T6 | Welches GUI-Framework wird verwendet? | Tauri, Slint, iced, egui; oder noch offen | Tauri mit TypeScript |
| T7 | Soll es neben der grafischen Oberfläche eine CLI geben? | ja / nein / später | ja |
| T8 | Gibt es Vorgaben zur Architektur? | Kryptokern als eigenständige Bibliothek (Aufgabenstellung) | Vollmodulare Architektur (GUI, CLI, Kryptokern, optional E2E und Tresor) |

## 3. Zielplattformen und Verteilung

| Nr. | Frage | Hinweise / Antwortoptionen | Antwort |
|---|---|---|---|
| P1 | Auf welchen Betriebssystemen muss Aegis laufen? | Windows, Linux, macOS | Vorerst Windows und Linux |
| P2 | Welche Mindestversionen der Betriebssysteme werden unterstützt? | z. B. Windows 10/11, aktuelle Fedora- und Ubuntu-Version | Windows 11 und Fedora 44 |
| P3 | Welche Prozessorarchitekturen werden unterstützt? | x86_64, ARM64 | x86_64 |
| P4 | Welche Testgeräte stehen tatsächlich zur Verfügung? | Betriebssystem und Hardware je Teammitglied | XMG Evo 14 Ryzen AI 9 HX 370, 32GB Ram (Fedora und Windows), Dell Precision I7-13700H, 32GB Ram (Windows) |
| P5 | Wie wird Aegis verteilt? | Installer, portable Datei, winget, Flatpak, Nix, nur Quellcode | Installer und portabel |
| P6 | Sind Administratorrechte bei der Installation zulässig? | ja / nein | ja |
| P7 | Wird der Programmcode signiert? | Code-Signing-Zertifikat (kostenpflichtig) oder unsigniert mit SmartScreen-Warnung | vorerst nicht |
| P8 | Sind mobile Plattformen Teil der Arbeit? | nein / optional / später | wenn dann nur theoretische Berücksichtigung |

## 4. Kryptografie und Sicherheit

| Nr. | Frage | Hinweise / Antwortoptionen | Antwort |
|---|---|---|---|
| K1 | Dürfen kryptografische Primitive selbst implementiert werden? | Laut Aufgabenstellung nein | nein |
| K2 | Welche Kryptobibliotheken kommen infrage? | z. B. RustCrypto, ring, aws-lc-rs, libsodium | `age` (Rust-Implementierung aus dem rage-Projekt), `aws-lc-rs` |
| K3 | Welche Anforderungen gelten für Bibliotheken? | Audit vorhanden, aktive Wartung, Lizenz kompatibel | nur "angesehene" Bibliotheken mit kompatibler Lizenz |
| K4 | Dürfen nur standardisierte Verfahren verwendet werden? | NIST, IETF, C2SP | nein |
| K5 | Ist Post-Quanten-Kryptografie Pflicht oder optional? | Aufgabenstellung nennt sie als optionale Erweiterung | hybride PQC ist für asymmetrische Verschlüsselung pflicht|
| K6 | Gibt es Vorgaben zu Sicherheitsniveaus? | z. B. 128 oder 256 Bit, BSI TR-02102 | Orientierung an BSI TR-02102 für das eigene Protokoll; das age-Format wird unverändert übernommen und ist davon ausgenommen |
| K7 | Soll ein eigenes Dateiformat entwickelt oder ein bestehendes verwendet werden? | Eigenes Format, age-Format, OpenPGP | Eigenes Dateiformat und Protokoll als Schwerpunkt der Arbeit; age-Format als sicherer Fallback |
| K8 | Muss Aegis mit anderen Tools kompatibel sein? | z. B. Dateien von age lesen können | Kompatibilität mit age |
| K9 | Darf Aegis eine Netzwerkverbindung aufbauen? | vollständig offline, Updateprüfung, Keyserver | Kein Betrieb eigener Serverinfrastruktur (außerhalb des Umfangs); Accountverwaltung nur als optionale Schnittstelle vorgesehen |
| K10 | Ist Telemetrie oder Absturzberichterstattung zulässig? | ja / nein | nein |

## 5. Erweiterbarkeit und Add-In-Schnittstelle

| Nr. | Frage | Hinweise / Antwortoptionen | Antwort |
|---|---|---|---|
| E1 | Für welche Kommunikationskanäle ist das Add-In gedacht? | E-Mail (Thunderbird, Outlook), Messenger, Browser | Browser-Plugins oder Matrix (Signal und WhatsApp bieten keine Schnittstelle für Erweiterungen) |
| E2 | Wie weit wird das Add-In umgesetzt? | Nur Schnittstelle, Prototyp für einen Kanal, vollständig | Erstmal Schnittstelle, später Prototyp und Validierung |
| E3 | In welcher Form wird der Kryptokern bereitgestellt? | Rust-Crate, C-Schnittstelle (FFI), WebAssembly, CLI | Eigenständige Rust-Crate (Kryptokern), intern auf Basis von `age` und `aws-lc-rs` |
| E4 | Welche optionalen Erweiterungen sind vorgesehen? | MFA, Post-Quanten, Tresor, weitere Plattformen | Erstmal nur symmetrische und asymmetrische Verschlüsselung |

## 6. Qualität und Tests

| Nr. | Frage | Hinweise / Antwortoptionen | Antwort |
|---|---|---|---|
| Q1 | Welche Testarten sind vorgesehen? | Unit-Tests, Integrationstests, Testvektoren, Fuzzing | Unit-Tests, Stichproben mit standardisierten Protokollen für die UX, Fuzzing, QA |
| Q2 | Gibt es Vorgaben zur Testabdeckung? | z. B. Mindestabdeckung für den Kryptokern | nein |
| Q3 | Werden Performance-Messungen durchgeführt? | z. B. mit `criterion` | ja |
| Q4 | Gibt es Code-Konventionen? | `rustfmt`, `clippy`, Code-Reviews per Pull Request | `rustfmt` verpflichtend, `clippy` empfohlen |
| Q5 | Wie wird die Usability geprüft? | Klickdummy mit Beobachtung, Usability-Studie, SUS | Klickdummy mit Beobachtung, Dokumentation mit SUS |

## 7. Recht und Datenschutz

| Nr. | Frage | Hinweise / Antwortoptionen | Antwort |
|---|---|---|---|
| R1 | Unter welcher Lizenz wird Aegis veröffentlicht? | MIT, Apache-2.0, GPLv3, keine Veröffentlichung | MIT oder Apache-2.0 für das öffentliche Repository; darüber hinaus keine Veröffentlichung im Rahmen der Projektarbeit |
| R2 | Gibt es Einschränkungen durch Lizenzen der Abhängigkeiten? | z. B. GPL-Bibliotheken bei freizügiger Lizenz | Keine bekannt, `age` und `aws-lc-rs` sind freizügig lizenziert; vor der Veröffentlichung prüfen (z. B. mit `cargo-deny`) |
| R3 | Gibt es Vorgaben der DHBW oder eines Partnerunternehmens zu Rechten am Code? | Nutzungsrechte, Geheimhaltung | Nein |
| R4 | Wie werden Nutzertests datenschutzkonform durchgeführt? | Einwilligung, Anonymisierung, Testdateien | Schriftliche Einwilligung, anonymisierte Auswertung, nur bereitgestellte Testdateien |
| R5 | Sind Exportbeschränkungen für Kryptografie relevant? | Bei Open-Source-Veröffentlichung in der EU in der Regel unkritisch | nein |

## 8. Dokumentation

| Nr. | Frage | Hinweise / Antwortoptionen | Antwort |
|---|---|---|---|
| D1 | In welcher Sprache werden Code, Kommentare und Dokumentation verfasst? | Deutsch, Englisch | Code Kommentare und Commit Messages in Englisch, restliche Dokumentation in Deutsch |
| D2 | In welcher Sprache ist die Oberfläche? | Deutsch, Englisch, beides | Deutsch und Englisch |
| D3 | Welche Dokumentation wird neben der Arbeit erstellt? | README, Benutzerhandbuch, API-Dokumentation | README, Benutzer Dokumentation, CLI- und In-App-Hilfe |
| D4 | Wie wird der Einsatz von KI-Werkzeugen dokumentiert? | Tabelle wie in den Prüfprotokollen | Tabellarisch oder in-line wenn für die Transparenz nötig |

### Hinweis zur Verwendung von KI-Werkzeugen

| Eingesetztes KI-Werkzeug | Zweck / Art der Nutzung |
|---|---|
| Claude Opus 5.5 | Erstellung der Gliederung und der Fragen des Fragebogens zur Festlegung der Randbedingungen, Prüfung der Antworten auf Widersprüche |
