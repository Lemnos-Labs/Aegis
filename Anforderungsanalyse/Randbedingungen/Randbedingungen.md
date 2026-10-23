# Randbedingungen Aegis

Randbedingungen sind vorgegebene oder bewusst festgelegte Einschränkungen, die den Lösungsraum für Anforderungen, Architektur und Umsetzung begrenzen. Sie sind grundsätzlich verbindlich und daher mit **M** (Must) gewichtet.

| Nr. | Bezeichnung | Erklärung | Gewichtung |
|---|---|---|:---:|
| RB-01 | Bearbeitungszeitraum | 900 h Workload für das Team, verteilt über zwei Theoriesemester und die dazwischenliegende Praxisphase von ca. 3 Monaten | M |
| RB-02 | Team | Drei Personen; Aufgabenteilung agil über Issues mit unterschiedlichen Schwerpunkten | M |
| RB-03 | Zeitbudget | Ca. 12 h pro Person und Woche in den Theoriephasen, zusätzlich Arbeit in der Praxisphase | M |
| RB-04 | Formale Vorgaben | Einhaltung der Leitlinien der DHBW Ravensburg für Praxismodule, Studien- und Bachelorarbeiten | M |
| RB-05 | Schwerpunkt | Schwerpunkt auf Usability; vertiefte Kryptografie als Voraussetzung für den wissenschaftlichen Anteil | M |
| RB-06 | Abschlusspräsentation | Live-Demo als Infostand, ggf. im Vergleich mit anderen Verschlüsselungsanwendungen | M |
| RB-07 | Budget | Kein Budget; ausschließlich kostenfreie Software, Bibliotheken und Dienste | M |
| RB-08 | Programmiersprache | Rust, stable, Mindestversion 1.99, festgelegt über `rust-toolchain.toml` | M |
| RB-09 | Entwicklungsumgebung | Entwicklung unter Windows und Fedora, ohne Nix | M |
| RB-10 | Versionsverwaltung | Git mit GitHub; Continuous Integration über GitHub Actions | M |
| RB-11 | GUI-Framework | Tauri mit TypeScript | M |
| RB-12 | Architektur | Modulare Architektur mit getrenntem Kryptokern, GUI, CLI und Add-In-Schnittstelle; Kryptokern als eigenständige Rust-Crate | M |
| RB-13 | Zielplattformen | Windows 11 und Fedora 44, jeweils x86_64 | M |
| RB-14 | Testgeräte | XMG Evo 14 (Ryzen AI 9 HX 370, 32 GB RAM, Windows und Fedora); Dell Precision (i7-13700H, 32 GB RAM, Windows) | M |
| RB-15 | Verteilung | Installer und portable Version; Administratorrechte bei der Installation zulässig | M |
| RB-16 | Codesignatur | Keine Signatur des Programmcodes; Windows zeigt beim ersten Start eine SmartScreen-Warnung | M |
| RB-17 | Mobile Plattformen | Nur theoretische Berücksichtigung, keine Umsetzung | M |
| RB-18 | Kryptografische Primitive | Keine Eigenimplementierung kryptografischer Primitive | M |
| RB-19 | Kryptobibliotheken | `age` (Rust-Implementierung aus dem rage-Projekt) und `aws-lc-rs`; nur etablierte Bibliotheken mit kompatibler Lizenz | M |
| RB-20 | Post-Quanten-Kryptografie | Hybride Post-Quanten-Kryptografie ist für asymmetrische Verschlüsselung verpflichtend | M |
| RB-21 | Sicherheitsrichtlinie | Das eigene Protokoll orientiert sich an BSI TR-02102; das unverändert übernommene age-Format ist davon ausgenommen | M |
| RB-22 | Dateiformate | Eigenes Dateiformat und Protokoll als Schwerpunkt; age als wählbarer, erprobter Fallback. Die Formate sind nicht untereinander kompatibel | M |
| RB-23 | Serverinfrastruktur | Kein Betrieb eigener Server; eine Accountverwaltung ist nur als optionale Schnittstelle vorgesehen | M |
| RB-24 | Telemetrie | Keine Telemetrie und keine Absturzberichte | M |
| RB-25 | Add-In-Kanäle | Browser-Plugin oder Matrix; zunächst Schnittstelle, danach Prototyp und Validierung | M |
| RB-26 | Testarten | Unit-Tests, Fuzzing, Performance-Messungen mit `criterion` und UX-Stichproben mit standardisierten Protokollen | M |
| RB-27 | Code-Konventionen | `rustfmt` verpflichtend, `clippy` empfohlen | M |
| RB-28 | Usability-Prüfung | Klickdummy mit Beobachtung von Testpersonen; Bewertung mit der System Usability Scale (SUS) | M |
| RB-29 | Lizenz | MIT oder Apache-2.0 für das öffentliche Repository; Lizenzen der Abhängigkeiten werden vor der Veröffentlichung geprüft | M |
| RB-30 | Datenschutz bei Nutzertests | Schriftliche Einwilligung, anonymisierte Auswertung, nur bereitgestellte Testdateien | M |
| RB-31 | Sprachen | Code-Kommentare und Commit-Nachrichten auf Englisch, Dokumentation auf Deutsch, Oberfläche auf Deutsch und Englisch | M |
| RB-32 | Dokumentation | README, Benutzerdokumentation, CLI- und In-App-Hilfe | M |
| RB-33 | KI-Dokumentation | Einsatz von KI-Werkzeugen wird tabellarisch oder, wo für die Transparenz nötig, im Text dokumentiert | M |

### Hinweis zur Verwendung von KI-Werkzeugen

| Eingesetztes KI-Werkzeug | Zweck / Art der Nutzung |
|---|---|
| Claude Opus 5.5 | Erstellung des Fragebogens zur Festlegung der Randbedingungen; Prüfung der Antworten auf Widersprüche; Überführung der Antworten in die vorliegende Tabelle |
