# Prüfprotokoll Konkurrenzanalyse

## Allgemeine Angaben

| Feld | Eintrag |
|---|---|
| Tool | Picocrypt-NG |
| Version | 2.18 |
| Betriebssystem und Version | Windows 11 Home 25H2 26200.9457 |
| Hardware (CPU, RAM) | 13th Gen Intel(R) Core(TM) i7-13620H (2.40 GHz), 16,0 GB |
| Datum | 06.10.2026 |
| Prüfer | Micha Wiedemann |

## Bewertungsregeln

| Regel | Festlegung |
|---|---|
| Teilerfüllung | Mit (☑) markierte Prüfpunkte zählen 0,5. |
| Nicht anwendbare Kriterien | Hat ein Tool eine Funktion konzeptbedingt nicht (z. B. keinen Public-Key-Modus), entfallen die davon abhängigen Kriterien (S3, U4, F2 sowie das Szenario „Falscher privater Schlüssel“ in U3). Der Nutzwert wird auf die Summe der bewerteten Gewichte normiert. Das Fehlen des Modus wird ausschließlich in F1 bewertet. |
| Nicht verifizierte Angaben | Angaben, für die keine Primärquelle gefunden wurde, werden übernommen und als „nicht verifiziert“ gekennzeichnet. |
| F3 | Bewertet wird, ob der RAM-Verbrauch unabhängig von der Dateigröße ist (Vergleich D1 und D2), nicht seine absolute Höhe. |

## Vorbereitung

| Nr. | Testdatei | Beschreibung | Vorhanden |
|---|---|---|:---:|
| D1 | `test_1gb.bin` | 1 GB Zufallsdaten | ☑ |
| D2 | `test_5gb.bin` | 5 GB Zufallsdaten | ☑ |
| D3 | `manipuliert_mitte` | Verschlüsselte D1, ein Byte in der Dateimitte verändert | ☑ |
| D4 | `manipuliert_header` | Verschlüsselte D1, ein Byte im Header verändert | ☑ |
| D5 | `abgeschnitten` | Verschlüsselte D1, letzte 1000 Byte entfernt | ☑ |

---

## Sicherheit

### S1 Moderne AEAD-Verschlüsselung und Integritätsschutz (Gewicht 6)

| Nr. | Prüffrage | Antwort |
|---|---|---|
| S1.1 | Welcher Verschlüsselungsalgorithmus wird verwendet? | XChaCha20 (im Paranoid-Modus zusätzlich Serpent) |
| S1.2 | Ist die Verschlüsselung authentifiziert (AEAD oder Encrypt-then-MAC)? | ja, Encrypt-then-MAC mit BLAKE2b (im Paranoid-Modus HMAC-SHA3) |
| S1.3 | Ist der Header authentifiziert? | ja |
| S1.4 | Sind Chunks gegen Vertauschen und Löschen geschützt? | ja |
| S1.5 | Wird ein Abschneiden der Datei erkannt (Test mit D5)? | ja |
| S1.6 | Wird eine Manipulation erkannt (Test mit D3 und D4)? | ja |

| Punkte | Bedingung |
|:---:|---|
| 4 | AEAD, Header authentifiziert, Chunk-Reihenfolge und Dateiende geschützt |
| 3 | AEAD und Header authentifiziert, Abschneiden wird nicht erkannt |
| 2 | Authentifizierung vorhanden, aber veraltete Konstruktion oder nur optional |
| 1 | Integrität nur über separate Signatur möglich |
| 0 | Kein Integritätsschutz |

**Punkte:** 4 **Begründung:** Encrypt-then-MAC ist als authentifizierte Verschlüsselung gleichwertig zu AEAD. Header authentifiziert, Vertauschen, Manipulation und Abschneiden werden erkannt.

### S2 Stärke der Passwort-KDF (Gewicht 6)

| Nr. | Prüffrage | Antwort |
|---|---|---|
| S2.1 | Welche KDF wird im Passwortmodus verwendet? | Argon2id |
| S2.2 | Welche Parameter (Speicher, Iterationen, Parallelität)? | 1 GiB Speicher, 4 Durchläufe, 4 Threads (Paranoid-Modus: 8 Durchläufe) |
| S2.3 | Kann der Nutzer die Parameter abschwächen? | nein |
| S2.4 | Gemessene Dauer der Schlüsselableitung (Sekunden) | ~1,5 s |

| Punkte | Bedingung |
|:---:|---|
| 4 | Argon2id mit Parametern mindestens nach RFC 9106 (64 MiB, t = 3), nicht abschwächbar |
| 3 | Argon2id mit schwächeren Parametern oder scrypt mit starken Parametern |
| 2 | scrypt mit schwachen Parametern oder PBKDF2 mit hoher Iterationszahl |
| 1 | Iteriertes S2K oder PBKDF2 mit niedriger Iterationszahl |
| 0 | Kein Passwortmodus oder unsichere Ableitung |

**Punkte:** 4 **Begründung:** Argon2id mit starken, nicht abschwächbaren Parametern.

### S3 Post-Quanten-Resistenz (Gewicht 6)

| Nr. | Prüffrage | Antwort |
|---|---|---|
| S3.1 | Wird ein Post-Quanten-Verfahren angeboten? | nein |
| S3.2 | Welches Verfahren (z. B. ML-KEM-768, ML-KEM-1024)? | – |
| S3.3 | Wird es hybrid mit einem klassischen Verfahren kombiniert? | – |
| S3.4 | Ist es standardmäßig aktiv? | – |
| S3.5 | Ist es in der stabilen Version verfügbar (nicht Beta oder Plugin)? | – |

| Punkte | Bedingung |
|:---:|---|
| 4 | Hybrides standardisiertes Verfahren, standardmäßig aktiv |
| 3 | Hybrides Verfahren verfügbar, muss manuell gewählt werden |
| 2 | Nur über Plugin oder Beta-Version |
| 1 | Angekündigt, aber nicht verfügbar |
| 0 | Nicht vorhanden |

**Punkte:** n. a. **Begründung:** Nicht anwendbar, da Picocrypt-NG keinen Public-Key-Modus und damit keinen Schlüsselaustausch hat. Die rein symmetrische Verschlüsselung mit 256-Bit-Schlüssel gilt auch gegenüber Quantencomputern als sicher.

### S4 Sichere Defaults (Gewicht 6)

| Nr. | Prüffrage | Antwort |
|---|---|---|
| S4.1 | Sind die Standardeinstellungen ohne Änderung sicher? | ja |
| S4.2 | Kann der Nutzer veraltete oder unsichere Algorithmen auswählen? | nein |
| S4.3 | Ist ein leeres Passwort möglich? | nein |
| S4.4 | Wird bei schwachem Passwort gewarnt oder blockiert? | (ja), nur über eine unauffällige Stärkeanzeige |
| S4.5 | Wird unverschlüsselter Klartext unbeabsichtigt zurückgelassen? | nein |

| Punkte | Bedingung |
|:---:|---|
| 4 | Keine unsicheren Optionen wählbar, schwache Passwörter werden abgefangen |
| 3 | Keine unsicheren Optionen, aber keine Passwortprüfung |
| 2 | Unsichere Optionen versteckt in Expertenmenüs wählbar |
| 1 | Unsichere Optionen gleichrangig neben sicheren wählbar |
| 0 | Unsichere Standardeinstellungen |

**Punkte:** 3 **Begründung:** Keine unsicheren Optionen; schwache Passwörter werden nicht abgefangen, nur über eine unauffällige Stärkeanzeige angezeigt.

### S5 Öffentliche Spezifikation und Audits (Gewicht 6)

| Nr. | Prüffrage | Antwort |
|---|---|---|
| S5.1 | Gibt es eine öffentliche Spezifikation des Dateiformats? | ja |
| S5.2 | Ist das Format standardisiert (RFC, C2SP o. Ä.)? | nein |
| S5.3 | Gab es ein unabhängiges Sicherheitsaudit? Wer, wann? | ja, Radically Open Security, Sommer 2024; geprüft wurde das Original-Picocrypt, nicht der NG-Fork |
| S5.4 | Wurden die Befunde behoben? | ja (im Original-Picocrypt) |
| S5.5 | Gibt es öffentliche Testvektoren? | ja |

| Punkte | Bedingung |
|:---:|---|
| 4 | Standardisierte Spezifikation, aktuelles Audit mit behobenen Befunden, Testvektoren |
| 3 | Öffentliche Spezifikation und Audit vorhanden |
| 2 | Nur Spezifikation oder nur Audit |
| 1 | Nur informelle Beschreibung |
| 0 | Weder Spezifikation noch Audit |

**Punkte:** 3 **Begründung:** Öffentliche, nicht standardisierte Spezifikation und öffentliche Testvektoren. Audit mit behobenen Befunden vorhanden, gilt aber für das Original-Picocrypt; Änderungen im NG-Fork sind nicht auditiert.

---

## Usability

### Testaufgaben

| Nr. | Aufgabe |
|---|---|
| T1 | D1 mit Passwort verschlüsseln und wieder entschlüsseln |
| T2 | D1 für eine andere Person per Public Key verschlüsseln (inkl. Schlüsselerzeugung und -austausch) |
| T3 | Verschlüsselte D1 mit falschem Passwort entschlüsseln |
| T4 | D3, D4 und D5 entschlüsseln |

### U1 Zeit bis zur ersten erfolgreichen Verschlüsselung (Gewicht 8)

| Nr. | Prüffrage | Antwort |
|---|---|---|
| U1.1 | Zeit vom Programmstart bis zur fertigen verschlüsselten Datei (T1) | 26,12 s |
| U1.2 | Wurde Dokumentation oder Websuche benötigt? Wie oft? | nein |
| U1.3 | Gab es Fehlversuche? Welche? | nein |

| Punkte | Bedingung |
|:---:|---|
| 4 | Unter 1 Minute, ohne Hilfe |
| 3 | 1 bis 3 Minuten, ohne Hilfe |
| 2 | 3 bis 5 Minuten oder einmal Dokumentation nötig |
| 1 | Über 5 Minuten oder mehrfach Dokumentation nötig |
| 0 | Aufgabe nicht gelöst |

**Punkte:** 4 **Begründung:** Unter 1 Minute ohne Hilfe gelöst.

### U2 Anzahl der Interaktionsschritte (Gewicht 6)

Gezählt werden Klicks, Tastatureingaben von Befehlen und Dialogbestätigungen. Passworteingabe zählt als ein Schritt.

| Aufgabe | Schritte Verschlüsseln | Schritte Entschlüsseln |
|---|:---:|:---:|
| T1 | 5 | 5 |
| T2 | – (kein Public-Key-Modus) | – (kein Public-Key-Modus) |
| **Durchschnitt** | 5 | 5 |

| Punkte | Bedingung (Durchschnitt pro Vorgang) |
|:---:|---|
| 4 | Höchstens 5 Schritte |
| 3 | 6 bis 10 Schritte |
| 2 | 11 bis 15 Schritte |
| 1 | 16 bis 25 Schritte |
| 0 | Mehr als 25 Schritte |

**Punkte:** 4 **Begründung:** Durchschnittlich 5 Schritte pro Vorgang. Der fehlende Public-Key-Modus wird in F1, F2 und U4 bewertet. Dateiauswahl nur per Drag-and-Drop.

### U3 Verständlichkeit von Fehlermeldungen (Gewicht 7)

Teilerfüllung (☑ in Klammern) zählt 0,5. Da ein Szenario entfällt, sind maximal 16 Punkte möglich; das Ergebnis wird auf 20 hochgerechnet.

| Szenario | Fehler erkannt | Für Laien verständlich | Handlungsempfehlung | Ursache korrekt benannt | Wortlaut der Meldung |
|---|:---:|:---:|:---:|:---:|---|
| T3 falsches Passwort | ☑ | (☑) | ☐ | (☑) | The password is incorrect or header is tampered |
| D3 Manipulation Mitte | ☑ | (☑) | ☐ | ☑ | data corrupted |
| D4 Manipulation Header | ☑ | ☐ | ☐ | ☐ | password is incorrect or the file is not a volume |
| D5 abgeschnitten | ☑ | (☑) | ☐ | ☑ | data corrupted |
| Falscher privater Schlüssel | – | – | – | – | entfällt (kein Public-Key-Modus) |
| **Anzahl erfüllt (max. 16)** | 4 | 1,5 | 0 | 2,5 | **8** (auf 20 hochgerechnet: **10**) |

| Punkte | Bedingung |
|:---:|---|
| 4 | 18 bis 20 erfüllt |
| 3 | 14 bis 17 erfüllt |
| 2 | 10 bis 13 erfüllt |
| 1 | 5 bis 9 erfüllt |
| 0 | Weniger als 5 erfüllt |

**Punkte:** 2 **Begründung:** 8 von 16 erfüllt, hochgerechnet 10 von 20.

### U4 Komplexität der Schlüsselverwaltung (Gewicht 8)

| Nr. | Prüffrage | Antwort |
|---|---|---|
| U4.1 | Schritte bis zum eigenen Schlüsselpaar | – |
| U4.2 | Schritte bis zur Weitergabe des öffentlichen Schlüssels | – |
| U4.3 | Schritte bis zum Import eines fremden Schlüssels | – |
| U4.4 | Wird ein Schlüssel als kopierbare Zeichenkette dargestellt? | – |
| U4.5 | Welche Fachbegriffe muss man verstehen? | – |
| U4.6 | Gibt es Warnungen oder Rückfragen, die ohne Vorwissen unverständlich sind? | – |

| Punkte | Bedingung |
|:---:|---|
| 4 | Keine Schlüssel nötig oder Erzeugung und Austausch mit einem Klick |
| 3 | Schlüssel als einfache Zeichenkette kopierbar, höchstens zwei Fachbegriffe |
| 2 | Eigene Verwaltungsoberfläche, verständlich, drei bis vier Fachbegriffe |
| 1 | Vertrauensmodell oder Beglaubigungen müssen verstanden werden |
| 0 | Ohne Vorwissen nicht bedienbar |

**Punkte:** n. a. **Begründung:** Nicht anwendbar, da kein Public-Key-Modus vorhanden ist.

### U5 Schutz vor Fehlbedienung (Gewicht 6)

| Nr. | Schutzmechanismus | Vorhanden |
|---|---|:---:|
| U5.1 | Passwort muss bestätigt werden | ☑ |
| U5.2 | Anzeige der Passwortstärke | ☑ |
| U5.3 | Warnung vor dem Überschreiben bestehender Dateien | ☑ |
| U5.4 | Abbruch hinterlässt keine unvollständige Ausgabedatei | ☑ |
| U5.5 | Hinweis, dass ein vergessenes Passwort nicht wiederherstellbar ist | ☐ |
| U5.6 | Originaldatei wird nicht ohne Nachfrage gelöscht | ☑ |
| **Anzahl erfüllt (max. 6)** | | **5** |

| Punkte | Bedingung |
|:---:|---|
| 4 | 6 erfüllt |
| 3 | 5 erfüllt |
| 2 | 3 bis 4 erfüllt |
| 1 | 1 bis 2 erfüllt |
| 0 | Keiner erfüllt |

**Punkte:** 3 **Begründung:** 5 erfüllt. Die Stärkeanzeige ist vorhanden, aber unauffällig.

---

## Funktionsumfang

### F1 Passwort- und Public-Key-Modus (Gewicht 5)

| Nr. | Prüffrage | Antwort |
|---|---|---|
| F1.1 | Passwortmodus vorhanden? | ja (optional mit Schlüsseldateien) |
| F1.2 | Public-Key-Modus vorhanden? | nein |
| F1.3 | Sind beide über dieselbe Oberfläche erreichbar? | – |

| Punkte | Bedingung |
|:---:|---|
| 4 | Beide Modi vollwertig in derselben Oberfläche |
| 3 | Beide Modi, einer davon umständlich erreichbar |
| 2 | Nur ein Modus, dieser vollwertig |
| 1 | Nur ein Modus, eingeschränkt |
| 0 | Keiner nutzbar |

**Punkte:** 2 **Begründung:** Nur Passwortmodus, dieser vollwertig.

### F2 Mehrere Empfänger (Gewicht 3)

| Nr. | Prüffrage | Antwort |
|---|---|---|
| F2.1 | Kann eine Datei für mehrere Empfänger verschlüsselt werden? | nein |
| F2.2 | Getestete Anzahl Empfänger | – |
| F2.3 | Können Empfänger nachträglich hinzugefügt werden? | – |

| Punkte | Bedingung |
|:---:|---|
| 4 | Beliebig viele Empfänger, nachträgliches Hinzufügen möglich |
| 3 | Beliebig viele Empfänger |
| 2 | Begrenzte Anzahl oder nur umständlich |
| 1 | Nur über Umwege (z. B. mehrfach verschlüsseln) |
| 0 | Nicht möglich |

**Punkte:** n. a. **Begründung:** Nicht anwendbar, da kein Public-Key-Modus vorhanden ist.

### F3 Große Dateien und Streaming (Gewicht 4)

| Nr. | Prüffrage | Antwort |
|---|---|---|
| F3.1 | Wurde D2 erfolgreich ver- und entschlüsselt? | ja |
| F3.2 | Maximaler RAM-Verbrauch beim Verschlüsseln | 1519,39 MB (OFFEN: Vergleichsmessung mit D1, um Konstanz zu belegen) |
| F3.3 | Maximaler RAM-Verbrauch beim Entschlüsseln | 1548,14 MB |
| F3.4 | Gibt es eine Fortschrittsanzeige? | ja |
| F3.5 | Gibt es ein dokumentiertes Größenlimit? | nein (Desktop-Version); 512 MiB (Web-Version) |

| Punkte | Bedingung |
|:---:|---|
| 4 | Erfolgreich, RAM unabhängig von der Dateigröße, Fortschrittsanzeige |
| 3 | Erfolgreich, RAM unabhängig von der Dateigröße, keine Fortschrittsanzeige |
| 2 | Erfolgreich, RAM wächst mit Dateigröße |
| 1 | Größenlimit oder extrem langsam |
| 0 | Fehlgeschlagen |

**Punkte:** 4 **Begründung:** Erfolgreich mit Fortschrittsanzeige. Der hohe, aber konstante RAM-Verbrauch ergibt sich aus Argon2id (1 GiB). (OFFEN: Konstanz durch Vergleichsmessung mit D1 belegen.)

### F4 Erweiterbarkeit (Gewicht 3)

| Nr. | Prüffrage | Antwort |
|---|---|---|
| F4.1 | Gibt es eine Plugin-Schnittstelle? | nein |
| F4.2 | Werden Hardware-Token unterstützt (YubiKey, Smartcard, TPM)? | nein |
| F4.3 | Gibt es eine Bibliothek oder API für Entwickler? | nein |

| Punkte | Bedingung |
|:---:|---|
| 4 | Plugins, Hardware-Token und Bibliothek |
| 3 | Zwei der drei |
| 2 | Eines der drei, gut dokumentiert |
| 1 | Eines der drei, eingeschränkt |
| 0 | Keines |

**Punkte:** 0 **Begründung:** Keine Bedingung erfüllt.

---

## Plattform

### P1 Betriebssystem-Abdeckung (Gewicht 4)

| System | Offiziell unterstützt |
|---|:---:|
| Windows | ☑ |
| macOS | ☑ |
| Linux | ☑ |
| Android | ☑ |
| iOS | ☐ |

| Punkte | Bedingung |
|:---:|---|
| 4 | Alle drei Desktop-Systeme und mindestens ein mobiles System |
| 3 | Alle drei Desktop-Systeme |
| 2 | Zwei Systeme |
| 1 | Ein System |
| 0 | Nur inoffizielle Portierungen |

**Punkte:** 4 **Begründung:** Alle drei Desktop-Systeme und Android (über F-Droid, Volumes kompatibel zur Desktop-Version).

### P2 Installation und Portabilität (Gewicht 3)

| Nr. | Prüffrage | Antwort |
|---|---|---|
| P2.1 | Größe des Downloads | 11.605 KB |
| P2.2 | Sind Administratorrechte nötig? | nein |
| P2.3 | Gibt es eine portable Version ohne Installation? | ja |
| P2.4 | Dauer bis zur Einsatzbereitschaft | < 1 min |
| P2.5 | Müssen zusätzliche Abhängigkeiten installiert werden? | nein |

| Punkte | Bedingung |
|:---:|---|
| 4 | Portabel, keine Adminrechte, keine Abhängigkeiten, unter 1 Minute |
| 3 | Einfacher Installer, keine Abhängigkeiten |
| 2 | Installer mit Adminrechten oder großer Download |
| 1 | Zusätzliche Abhängigkeiten oder Paketmanager nötig |
| 0 | Nur aus dem Quellcode installierbar |

**Punkte:** 4 **Begründung:** Portabel, keine Administratorrechte, unter 1 Minute einsatzbereit.

### P3 Interoperabilität (Gewicht 3)

| Nr. | Prüffrage | Antwort |
|---|---|---|
| P3.1 | Gibt es weitere kompatible Implementierungen? Welche? | Picocrypt (Original, Vorgänger), Picocrypt Web |
| P3.2 | Test: Datei mit Tool A verschlüsselt, mit Tool B entschlüsselt | erfolgreich |
| P3.3 | Ist das Format versioniert und abwärtskompatibel? | ja |

| Punkte | Bedingung |
|:---:|---|
| 4 | Mehrere unabhängige kompatible Implementierungen, Test erfolgreich |
| 3 | Eine weitere kompatible Implementierung |
| 2 | Offenes Format, aber nur eine Implementierung |
| 1 | Format nur aus dem Quellcode ableitbar |
| 0 | Proprietäres Format |

**Punkte:** 3 **Begründung:** Kompatible Implementierungen existieren nur innerhalb des Picocrypt-Ökosystems (Original als Vorgänger, Web-Version); keine unabhängige Implementierung.

---

## Wartung

### W1 Aktive Weiterentwicklung (Gewicht 5)

| Nr. | Prüffrage | Antwort |
|---|---|---|
| W1.1 | Datum des letzten Releases | 28.06.2026 |
| W1.2 | Anzahl Releases in den letzten 12 Monaten | 19 |
| W1.3 | Anzahl aktiver Maintainer | 2–4 |
| W1.4 | Ist das Repository archiviert? | nein |
| W1.5 | Reaktionszeit auf neue Issues (Stichprobe) | wenige Tage |

| Punkte | Bedingung |
|:---:|---|
| 4 | Mehrere Releases im letzten Jahr, mehrere Maintainer |
| 3 | Mindestens ein Release im letzten Jahr |
| 2 | Letztes Release 1 bis 2 Jahre alt |
| 1 | Letztes Release über 2 Jahre alt |
| 0 | Archiviert oder eingestellt |

**Punkte:** 4 **Begründung:** Mehrere aktive Maintainer, aktuelle Releases, aktives Projekt.

### W2 Lizenz (Gewicht 2)

| Nr. | Prüffrage | Antwort |
|---|---|---|
| W2.1 | Lizenz | GNU GPLv3 |
| W2.2 | OSI-anerkannte Open-Source-Lizenz? | ja |
| W2.3 | Ist der vollständige Quellcode verfügbar? | ja |

| Punkte | Bedingung |
|:---:|---|
| 4 | OSI-Lizenz, vollständiger Quellcode |
| 2 | Quellcode einsehbar, aber eingeschränkte Lizenz |
| 0 | Proprietär |

**Punkte:** 4 **Begründung:** OSI-Lizenz, vollständiger Quellcode.

### W3 Dokumentation und Community (Gewicht 3)

| Nr. | Prüffrage | Antwort |
|---|---|---|
| W3.1 | Gibt es eine Anleitung für Endnutzer? | ja |
| W3.2 | Ist die Dokumentation auf Deutsch verfügbar? | nein |
| W3.3 | Gibt es FAQ oder Tutorials? | ja |
| W3.4 | Gibt es ein aktives Forum oder aktive Issue-Diskussionen? | ja |

| Punkte | Bedingung |
|:---:|---|
| 4 | Alle vier erfüllt |
| 3 | Drei erfüllt |
| 2 | Zwei erfüllt |
| 1 | Eines erfüllt |
| 0 | Keines erfüllt |

**Punkte:** 3 **Begründung:** Drei erfüllt, keine deutsche Dokumentation.

---

## Zusammenfassung

| Nr. | Kriterium | Gewicht | Punkte (0–4) | Gewichtet (Gewicht × Punkte / 4) |
|---|---|---:|:---:|:---:|
| S1 | AEAD und Integritätsschutz | 6 | 4 | 6,00 |
| S2 | Passwort-KDF | 6 | 4 | 6,00 |
| S3 | Post-Quanten-Resistenz | 6 | n. a. | – |
| S4 | Sichere Defaults | 6 | 3 | 4,50 |
| S5 | Spezifikation und Audits | 6 | 3 | 4,50 |
| U1 | Zeit bis zur ersten Verschlüsselung | 8 | 4 | 8,00 |
| U2 | Interaktionsschritte | 6 | 4 | 6,00 |
| U3 | Fehlermeldungen | 7 | 2 | 3,50 |
| U4 | Schlüsselverwaltung | 8 | n. a. | – |
| U5 | Schutz vor Fehlbedienung | 6 | 3 | 4,50 |
| F1 | Passwort- und Public-Key-Modus | 5 | 2 | 2,50 |
| F2 | Mehrere Empfänger | 3 | n. a. | – |
| F3 | Große Dateien | 4 | 4 | 4,00 |
| F4 | Erweiterbarkeit | 3 | 0 | 0,00 |
| P1 | Betriebssystem-Abdeckung | 4 | 4 | 4,00 |
| P2 | Installation | 3 | 4 | 3,00 |
| P3 | Interoperabilität | 3 | 3 | 2,25 |
| W1 | Aktive Entwicklung | 5 | 4 | 5,00 |
| W2 | Lizenz | 2 | 4 | 2,00 |
| W3 | Dokumentation und Community | 3 | 3 | 2,25 |
| | **Summe bewertete Kriterien** | **83** | | **68,00** |
| | **Nutzwert (normiert: 68,00 / 83 × 100)** | | | **81,93** |

## Beobachtete UX-Schwachstellen

| Nr. | Situation | Beobachtung | Schweregrad (gering / mittel / hoch) | Konsequenz für Aegis |
|---|---|---|---|---|
| 1 | Datei auswählen | Dateien lassen sich nur per Drag-and-Drop hinzufügen, es gibt keine Möglichkeit, die Datei durch die Applikation auszuwählen. Picocrypt und Explorer müssen gleichzeitig geöffnet und nebeneinander angeordnet werden. Nach dem Hineinziehen ist der Name der gewählten Datei nicht mehr sichtbar, sodass sich nicht prüfen lässt, ob die richtige Datei gewählt wurde | mittel | Drag-and-Drop und Dateiauswahldialog gleichwertig anbieten; gewählte Datei mit Name, Größe und Symbol dauerhaft anzeigen, bis der Vorgang abgeschlossen ist |
| 2 | Gesamteindruck der Oberfläche | Veraltete, durchgehend graue Gestaltung ohne farbliche Hervorhebung. Wichtige Elemente (Passwortfeld, Start-Schaltfläche, Stärkeanzeige) heben sich nicht von Nebensächlichem ab, die Übersichtlichkeit leidet | gering | Zeitgemäße Gestaltung mit klarer visueller Hierarchie; Farbe gezielt für die Hauptaktion, Status und Warnungen einsetzen |
| 3 | Optionen beim Verschlüsseln | Zahlreiche Zusatzoptionen (u. a. Paranoid-Modus, Schlüsseldateien, Reed-Solomon, Komprimierung, Aufteilen) stehen unkategorisiert und gleichrangig neben dem Standardablauf. Laien können nicht einschätzen, welche Optionen nötig oder riskant sind | mittel | Sichere Voreinstellungen ohne Wahlzwang; Zusatzoptionen gruppiert in einem einklappbaren Bereich „Erweitert“ mit kurzer Erklärung je Option |

## Beobachtete UX-Stärken

| Nr. | Situation | Beobachtung | Übertragbar auf Aegis? | Begründung |
|---|---|---|---|---|
| 1 | Standardablauf | Reduzierter Ablauf in einem festen Fenster: Datei hineinziehen, Passwort eingeben, verschlüsseln. Keine Menüs, keine Pop-ups | ja | Entspricht dem Ziel, Verschlüsselung für Laien in wenigen Schritten zu ermöglichen; Grundlage für den Hauptablauf von Aegis |
| 2 | Kommentarfunktion | Der verschlüsselten Datei kann ein Kommentar beigefügt werden, z. B. eine Anleitung zum Entschlüsseln für den Empfänger, die im Klartext mit der Datei übertragen wird | ja, mit Hinweis | Erleichtert Empfängern ohne Vorwissen den Einstieg. Der Kommentar wird unverschlüsselt gespeichert; Aegis muss das in der Oberfläche deutlich kennzeichnen, damit keine vertraulichen Inhalte hineingeschrieben werden |
| 3 | Modus-Erkennung | Verschlüsselte Dateien werden automatisch erkannt, der Nutzer muss nicht zwischen Ver- und Entschlüsseln wählen | ja | Entfernt eine Entscheidung und damit eine Fehlerquelle; Aegis sollte den Modus ebenfalls am Dateiformat erkennen |

### Hinweis zur Verwendung von KI-Werkzeugen

| Eingesetztes KI-Werkzeug | Zweck / Art der Nutzung |
|---|---|
| Claude Opus 5.5 | Erste Erstellung der Kriterien für die Nutzwertanalyse, Bereitstellung des Prüfprotokolls als Markdown Code, Prüfung der ausgefüllten Protokolle auf Konsistenz und sachliche Richtigkeit |
| Gemini 3.8 Flash | Unterstützung bei der Beantwortung einzelner Prüffragen und der Durchsuchung von Dokumentation |

### Ergänzende Quellen & Eigene Prüfleistungen

| ID | Typ | Urheber / Projekt | Titel / Ressource | Stand / URL |
|---|---|---|---|---|
| **[REPO-NG]** | GitHub-Repository | Picocrypt-NG Community | *Picocrypt-NG GitHub Repository* | `https://github.com/Picocrypt-NG/Picocrypt-NG` |
| **[REPO-ORIG]** | GitHub-Repository | Picocrypt | *Picocrypt GitHub Repository (Original, archiviert)* | `https://github.com/Picocrypt` |
| **[AUDIT-ROS]** | Audit-Bericht | Radically Open Security | *Picocrypt Audit Report* | Sommer 2024<br>`https://github.com/Picocrypt/storage/blob/main/Picocrypt.Audit.Report.pdf` |
| **[FDROID-NG]** | App-Verzeichnis | F-Droid | *Picocrypt-NG (Android)* | `https://f-droid.org/packages/io.github.picocrypt_ng.picocrypt_ng/` |
| **[EXP-TESTS]** | Eigene Erhebung | Micha Wiedemann | *Empirische Funktions- und Sicherheitsanalyse (Protokollprüfungen auf Windows 11)* | Eigene Prüfungen (06.10.2026) |
