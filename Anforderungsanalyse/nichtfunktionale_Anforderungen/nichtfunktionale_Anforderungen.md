# Nicht-funktionale Anforderungen Aegis

Nicht-funktionale Anforderungen beschreiben die Qualitätseigenschaften von Aegis. Wo möglich, enthalten sie einen messbaren Zielwert, der in der Evaluation geprüft wird. Die Gewichtung folgt der MoSCoW-Methode:

| Gewichtung | Bedeutung |
|---|---|
| **M** (Must) | Zwingend erforderlich; ohne diese Anforderung gilt das Projekt als nicht erfüllt |
| **S** (Should) | Wichtig, wird umgesetzt, sofern die Zeit es zulässt |
| **C** (Could) | Wünschenswert, wird nur bei freien Kapazitäten umgesetzt |
| **W** (Won't) | Bewusst nicht Teil dieser Arbeit; dient der Abgrenzung des Umfangs |

Referenzhardware für alle Messwerte: AMD Ryzen AI 9 HX 370, 32 GB RAM, Windows 11 und Fedora 44.

| Nr. | Bezeichnung | Erklärung | Gewichtung |
|---|---|---|:---:|
| NFA-01 | Symmetrische Verschlüsselung | AES-256-GCM, blockweise mit eigener Nonce je Block | M |
| NFA-02 | Integritätsschutz | Authentifizierter Header; Blöcke gegen Vertauschen, Löschen und Abschneiden geschützt | M |
| NFA-03 | Passwortableitung | Argon2id mit 1 GiB Speicher, 4 Durchläufen und 4 Threads; nicht abschwächbar | M |
| NFA-04 | Post-Quanten-Schlüsselaustausch | Hybrid aus ML-KEM und einem klassischen Verfahren; Parametersatz und Kurve nach Abgleich mit BSI TR-02102-1 | M |
| NFA-05 | Post-Quanten-Signatur | Hybrid aus ML-DSA-65 und Ed25519 | S |
| NFA-06 | Zufallswerte | Ausschließlich aus dem kryptografisch sicheren Zufallsgenerator des Betriebssystems | M |
| NFA-07 | Schutz des privaten Schlüssels | Verschlüsselung mit einem per Argon2id aus dem Passwort abgeleiteten Schlüssel | M |
| NFA-08 | Löschen sensibler Daten | Schlüssel und Passwörter werden nach Gebrauch im Arbeitsspeicher überschrieben | M |
| NFA-09 | Klartext auf der Festplatte | Klartext entsteht nur im Zielverzeichnis als temporäre Datei; sie erhält erst nach vollständiger Integritätsprüfung den endgültigen Namen und wird bei Fehler oder Abbruch gelöscht | M |
| NFA-10 | Prüfung der Abhängigkeiten | `cargo audit` und `cargo deny` in der CI | S |
| NFA-11 | Testvektoren | Eigene Testvektoren für das Protokoll | M |
| NFA-12 | Fuzzing | Fuzzing des Dateiformat-Parsers | S |
| NFA-13 | Erste Verschlüsselung | Ein Laie verschlüsselt die erste Datei in unter 1 Minute ohne Hilfe | M |
| NFA-14 | Interaktionsschritte | Höchstens 5 Schritte pro Vorgang im Passwortmodus | S |
| NFA-15 | SUS-Mindestwert | System Usability Scale mindestens 68 | M |
| NFA-16 | SUS-Zielwert | System Usability Scale mindestens 80 | S |
| NFA-17 | Verständliche Fehlermeldungen | Mindestens 18 von 20 Prüfpunkten im Fehlermeldungstest der Konkurrenzanalyse | M |
| NFA-18 | Keine Fachbegriffe | Im Standardablauf keine Fachbegriffe wie Schlüsselpaar, Zertifikat oder Fingerprint; nur im Bereich „Erweitert“ mit Erklärung | M |
| NFA-19 | Tastaturbedienung | Vollständig per Tastatur bedienbar | S |
| NFA-20 | Kontrast | Kontrast nach WCAG 2.2 Stufe AA | S |
| NFA-21 | Screenreader | Beschriftete Bedienelemente; Test mit Screenreader | C |
| NFA-22 | Verschlüsselungsgeschwindigkeit | Mindestens so schnell wie age auf derselben Hardware, gemessen mit `criterion` | S |
| NFA-23 | RAM-Verbrauch konstant | Der Arbeitsspeicherbedarf ist unabhängig von der Dateigröße | M |
| NFA-24 | RAM-Obergrenze | Höchstens Speicher der Schlüsselableitung plus 200 MB | S |
| NFA-25 | Dauer der Schlüsselableitung | Höchstens 2 Sekunden auf der Referenzhardware | S |
| NFA-26 | Programmstart | Hauptfenster nach höchstens 2 Sekunden bedienbar | S |
| NFA-27 | Bedienbarkeit während der Verarbeitung | Verschlüsselung läuft im Hintergrund, die Oberfläche bleibt bedienbar | M |
| NFA-28 | Dateigröße | Unterstützung von Dateien bis mindestens 100 GB, getestet mit 20 GB | M |
| NFA-29 | Absturzsicherheit | Bei Absturz oder Stromausfall bleibt die Originaldatei unverändert und unter dem endgültigen Namen entsteht keine unvollständige Datei; verbliebene temporäre Dateien werden beim nächsten Start erkannt und gelöscht | M |
| NFA-30 | Rundlauftests | Automatisierte Tests: Verschlüsseln und Entschlüsseln liefert identische Daten, für beide Formate | M |
| NFA-31 | Abwärtskompatibilität | Jede veröffentlichte Formatversion bleibt entschlüsselbar | M |
| NFA-32 | Interoperabilität mit age | Dateien von Aegis im age-Format lassen sich mit age entschlüsseln und umgekehrt, automatisiert getestet | M |
| NFA-33 | Modularität | GUI und CLI greifen nur über die öffentliche Schnittstelle des Kryptokerns zu | M |
| NFA-34 | Testabdeckung | Mindestens 80 % Testabdeckung im Kryptokern | S |
| NFA-35 | Formatierung | Code mit `rustfmt` formatiert | M |
| NFA-36 | Statische Analyse | Code ohne `clippy`-Warnungen | S |
| NFA-37 | Schnittstellendokumentation | Alle öffentlichen Funktionen des Kryptokerns mit rustdoc und Beispiel dokumentiert | S |
| NFA-38 | Krypto-Agilität | Verfahren über eine Kennung im Dateikopf austauschbar, ohne bestehende Dateien unlesbar zu machen | S |
| NFA-39 | Continuous Integration | Build, Tests und Formatprüfung bei jedem Pull Request | M |
| NFA-40 | Plattformen | Lauffähig unter Windows 11 und Fedora 44, jeweils x86_64 | M |
| NFA-41 | Installer | Bereitstellung als Installer | M |
| NFA-42 | Portable Version | Bereitstellung als portable Version ohne Installation | S |
| NFA-43 | Paketgröße | Installationspaket höchstens 30 MB | C |
| NFA-44 | Installationsdauer | Unter 1 Minute bis zur Einsatzbereitschaft | S |
| NFA-45 | Laufzeitabhängigkeiten | Nur Abhängigkeiten, die der Installer mitbringt oder die das System bereits enthält | M |
| NFA-46 | Kein Netzwerkzugriff | Keine Netzwerkverbindungen; ausgenommen die optionale Accountverwaltung und der Add-In-Prototyp, wenn der Nutzer sie aktiv einrichtet | M |
| NFA-47 | Keine Telemetrie | Keine Erhebung von Nutzungsdaten | M |
| NFA-48 | Protokolldateien | Keine Passwörter, Schlüssel, Dateiinhalte oder Dateinamen in Protokolldateien | M |
| NFA-49 | Kein Verlauf | Aegis speichert keinen Verlauf zuletzt verwendeter Dateien | M |
| NFA-50 | Integrität der Releases | Jedes Release wird mit SHA-256-Prüfsummen und einer kostenfreien Signatur (z. B. minisign oder Sigstore) veröffentlicht | M |
| NFA-51 | Obergrenzen für Dateikopf-Parameter | Alle Parameter aus dem Dateikopf (KDF-Kosten, Headerlänge, Anzahl der Empfänger) werden vor der Verarbeitung gegen feste Obergrenzen geprüft | M |
| NFA-52 | Anonyme Empfänger | Der Dateikopf des eigenen Formats enthält keine Kennung, aus der sich der öffentliche Schlüssel eines Empfängers ableiten lässt | S |
| NFA-53 | Ausführung ohne erhöhte Rechte | Aegis benötigt zur Laufzeit keine Administratorrechte | M |

### Hinweis zur Verwendung von KI-Werkzeugen

| Eingesetztes KI-Werkzeug | Zweck / Art der Nutzung |
|---|---|
| Claude Opus 5.5 | Erstellung des Fragebogens zur Festlegung der nicht-funktionalen Anforderungen; Vorschlag der Antworten, Zielwerte und Gewichtung nach MoSCoW auf Grundlage der Teamentscheidungen und der Konkurrenzanalyse; Überführung in die vorliegende Tabelle |
