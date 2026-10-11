# Prüfprotokoll Konkurrenzanalyse

## Allgemeine Angaben

| Feld | Eintrag |
|---|---|
| Tool | age |
| Version | 1.3.2 |
| Betriebssystem und Version | Windows 11 Education 25H2 |
| Hardware (CPU, RAM) | AMD Ryzen AI 9 HX 370, 32GB DDR5-5200 |
| Datum | 05.10.2026 |
| Prüfer | Oliver Decker |

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
| S1.1 | Welcher Verschlüsselungsalgorithmus wird verwendet? | ChaCha20-Poly1305 |
| S1.2 | Ist die Verschlüsselung authentifiziert (AEAD oder Encrypt-then-MAC)? | ja, AEAD |
| S1.3 | Ist der Header authentifiziert? | ja (HMAC-SHA256) |
| S1.4 | Sind Chunks gegen Vertauschen und Löschen geschützt? | ja (STREAM-Konstruktion) |
| S1.5 | Wird ein Abschneiden der Datei erkannt (Test mit D5)? | ja |
| S1.6 | Wird eine Manipulation erkannt (Test mit D3 und D4)? | ja |

| Punkte | Bedingung |
|:---:|---|
| 4 | AEAD, Header authentifiziert, Chunk-Reihenfolge und Dateiende geschützt |
| 3 | AEAD und Header authentifiziert, Abschneiden wird nicht erkannt |
| 2 | Authentifizierung vorhanden, aber veraltete Konstruktion oder nur optional |
| 1 | Integrität nur über separate Signatur möglich |
| 0 | Kein Integritätsschutz |

**Punkte:** 4 **Begründung:** Alle Bedingungen erfüllt.

### S2 Stärke der Passwort-KDF (Gewicht 6)

| Nr. | Prüffrage | Antwort |
|---|---|---|
| S2.1 | Welche KDF wird im Passwortmodus verwendet? | scrypt |
| S2.2 | Welche Parameter (Speicher, Iterationen, Parallelität)? | N = 2^18, r = 8, p = 1, RAM ≈ 256 MiB (OFFEN: prüfen, ob N im CLI fest oder dynamisch ist) |
| S2.3 | Kann der Nutzer die Parameter abschwächen? | nein |
| S2.4 | Gemessene Dauer der Schlüsselableitung (Sekunden) | ~1 s |

| Punkte | Bedingung |
|:---:|---|
| 4 | Argon2id mit Parametern mindestens nach RFC 9106 (64 MiB, t = 3), nicht abschwächbar |
| 3 | Argon2id mit schwächeren Parametern oder scrypt mit starken Parametern |
| 2 | scrypt mit schwachen Parametern oder PBKDF2 mit hoher Iterationszahl |
| 1 | Iteriertes S2K oder PBKDF2 mit niedriger Iterationszahl |
| 0 | Kein Passwortmodus oder unsichere Ableitung |

**Punkte:** 3 **Begründung:** scrypt mit starken, nicht abschwächbaren Parametern.

### S3 Post-Quanten-Resistenz (Gewicht 6)

| Nr. | Prüffrage | Antwort |
|---|---|---|
| S3.1 | Wird ein Post-Quanten-Verfahren angeboten? | ja |
| S3.2 | Welches Verfahren (z. B. ML-KEM-768, ML-KEM-1024)? | ML-KEM-768 + X25519 (HPKE, Recipient-Typ `mlkem768x25519`) |
| S3.3 | Wird es hybrid mit einem klassischen Verfahren kombiniert? | ja |
| S3.4 | Ist es standardmäßig aktiv? | nein (Schlüsselpaar mit `age-keygen -pq`) |
| S3.5 | Ist es in der stabilen Version verfügbar (nicht Beta oder Plugin)? | ja, seit v1.3.0 |

| Punkte | Bedingung |
|:---:|---|
| 4 | Hybrides standardisiertes Verfahren, standardmäßig aktiv |
| 3 | Hybrides Verfahren verfügbar, muss manuell gewählt werden |
| 2 | Nur über Plugin oder Beta-Version |
| 1 | Angekündigt, aber nicht verfügbar |
| 0 | Nicht vorhanden |

**Punkte:** 3 **Begründung:** Stabiles hybrides Verfahren verfügbar, muss manuell gewählt werden. (OFFEN: Quelle für die Ankündigung „zukünftig evtl. standardmäßig aktiv“ suchen oder Aussage streichen)

### S4 Sichere Defaults (Gewicht 6)

| Nr. | Prüffrage | Antwort |
|---|---|---|
| S4.1 | Sind die Standardeinstellungen ohne Änderung sicher? | ja |
| S4.2 | Kann der Nutzer veraltete oder unsichere Algorithmen auswählen? | nein |
| S4.3 | Ist ein leeres Passwort möglich? | nein (bei leerer Eingabe wird ein sicheres Passwort generiert) |
| S4.4 | Wird bei schwachem Passwort gewarnt oder blockiert? | nein |
| S4.5 | Wird unverschlüsselter Klartext unbeabsichtigt zurückgelassen? | nein |

| Punkte | Bedingung |
|:---:|---|
| 4 | Keine unsicheren Optionen wählbar, schwache Passwörter werden abgefangen |
| 3 | Keine unsicheren Optionen, aber keine Passwortprüfung |
| 2 | Unsichere Optionen versteckt in Expertenmenüs wählbar |
| 1 | Unsichere Optionen gleichrangig neben sicheren wählbar |
| 0 | Unsichere Standardeinstellungen |

**Punkte:** 3 **Begründung:** Keine unsicheren Optionen, aber keine Passwortprüfung.

### S5 Öffentliche Spezifikation und Audits (Gewicht 6)

| Nr. | Prüffrage | Antwort |
|---|---|---|
| S5.1 | Gibt es eine öffentliche Spezifikation des Dateiformats? | ja |
| S5.2 | Ist das Format standardisiert (RFC, C2SP o. Ä.)? | ja, C2SP |
| S5.3 | Gab es ein unabhängiges Sicherheitsaudit? Wer, wann? | Cure53, März 2020 (nicht verifiziert, keine Primärquelle gefunden) |
| S5.4 | Wurden die Befunde behoben? | ja (nicht verifiziert) |
| S5.5 | Gibt es öffentliche Testvektoren? | ja (CCTV) |

| Punkte | Bedingung |
|:---:|---|
| 4 | Standardisierte Spezifikation, aktuelles Audit mit behobenen Befunden, Testvektoren |
| 3 | Öffentliche Spezifikation und Audit vorhanden |
| 2 | Nur Spezifikation oder nur Audit |
| 1 | Nur informelle Beschreibung |
| 0 | Weder Spezifikation noch Audit |

**Punkte:** 3 **Begründung:** Standardisierte Spezifikation (C2SP) und Testvektoren vorhanden. Audit laut Angabe vorhanden, aber nicht verifiziert und nicht aktuell; ohne Audit gälte Stufe 2.

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
| U1.1 | Zeit vom Programmstart bis zur fertigen verschlüsselten Datei (T1) | 5 min |
| U1.2 | Wurde Dokumentation oder Websuche benötigt? Wie oft? | ja, mehrfach: Dokumentation, CLI-Hilfe, KI |
| U1.3 | Gab es Fehlversuche? Welche? | ja, Versuch ohne Angabe einer Ausgabedatei |

| Punkte | Bedingung |
|:---:|---|
| 4 | Unter 1 Minute, ohne Hilfe |
| 3 | 1 bis 3 Minuten, ohne Hilfe |
| 2 | 3 bis 5 Minuten oder einmal Dokumentation nötig |
| 1 | Über 5 Minuten oder mehrfach Dokumentation nötig |
| 0 | Aufgabe nicht gelöst |

**Punkte:** 1 **Begründung:** Mehrfach Dokumentation nötig; CLI-Hilfe für Laien nicht verständlich, Dokumentation unübersichtlich.

### U2 Anzahl der Interaktionsschritte (Gewicht 6)

Gezählt werden Klicks, Tastatureingaben von Befehlen und Dialogbestätigungen. Passworteingabe zählt als ein Schritt.

| Aufgabe | Schritte Verschlüsseln | Schritte Entschlüsseln |
|---|:---:|:---:|
| T1 | 10 | 7 |
| T2 | 9 | 3 |
| **Durchschnitt** | 9,5 | 5 |

| Punkte | Bedingung (Durchschnitt pro Vorgang) |
|:---:|---|
| 4 | Höchstens 5 Schritte |
| 3 | 6 bis 10 Schritte |
| 2 | 11 bis 15 Schritte |
| 1 | 16 bis 25 Schritte |
| 0 | Mehr als 25 Schritte |

**Punkte:** 3 **Begründung:** Durchschnittlich 7,25 Schritte pro Vorgang. Gezählt ohne Nachschlagen in der Dokumentation und mit einmaligem Wechsel in das Arbeitsverzeichnis; ansonsten zusätzliche Navigation über Explorer oder PowerShell nötig.

### U3 Verständlichkeit von Fehlermeldungen (Gewicht 7)

Teilerfüllung (☑ in Klammern) zählt 0,5.

| Szenario | Fehler erkannt | Für Laien verständlich | Handlungsempfehlung | Ursache korrekt benannt | Wortlaut der Meldung |
|---|:---:|:---:|:---:|:---:|---|
| T3 falsches Passwort | ☑ | ☑ | ☐ | ☑ | age: error: incorrect passphrase |
| D3 Manipulation Mitte | ☑ | ☐ | ☐ | (☑) | age: error: failed to decrypt and authenticate payload chunk, file may be corrupted or tampered with |
| D4 Manipulation Header | ☑ | ☐ | ☐ | ☑ | age: error: failed to read header: parsing age header: unexpected intro: "age-encryplion.org/v1\n" |
| D5 abgeschnitten | ☑ | ☐ | ☐ | (☑) | age: error: failed to decrypt and authenticate payload chunk, file may be corrupted or tampered with |
| Falscher privater Schlüssel | ☑ | ☐ | ☐ | ☑ | OFFEN: Test wiederholen. Getestet wurde eine beschädigte Schlüsseldatei („malformed secret key: invalid checksum“), nicht ein gültiger fremder Schlüssel |
| **Anzahl erfüllt (max. 20)** | 5 | 1 | 0 | 4 | **10** |

| Punkte | Bedingung |
|:---:|---|
| 4 | 18 bis 20 erfüllt |
| 3 | 14 bis 17 erfüllt |
| 2 | 10 bis 13 erfüllt |
| 1 | 5 bis 9 erfüllt |
| 0 | Weniger als 5 erfüllt |

**Punkte:** 2 **Begründung:** 10 von 20 erfüllt. (OFFEN: Ergebnis kann sich nach Wiederholung des Tests mit falschem Schlüssel ändern.)

### U4 Komplexität der Schlüsselverwaltung (Gewicht 8)

| Nr. | Prüffrage | Antwort |
|---|---|---|
| U4.1 | Schritte bis zum eigenen Schlüsselpaar | 1 |
| U4.2 | Schritte bis zur Weitergabe des öffentlichen Schlüssels | 2 |
| U4.3 | Schritte bis zum Import eines fremden Schlüssels | 0 (kein Import nötig, der Empfänger wird direkt als Zeichenkette übergeben) |
| U4.4 | Wird ein Schlüssel als kopierbare Zeichenkette dargestellt? | ja |
| U4.5 | Welche Fachbegriffe muss man verstehen? | ☐ Zertifikat ☐ Fingerprint ☐ Beglaubigung ☐ Vertrauensstufe ☐ Keyserver ☐ Ablaufdatum ☑ Identität/Recipient |
| U4.6 | Gibt es Warnungen oder Rückfragen, die ohne Vorwissen unverständlich sind? | ja |

| Punkte | Bedingung |
|:---:|---|
| 4 | Keine Schlüssel nötig oder Erzeugung und Austausch mit einem Klick |
| 3 | Schlüssel als einfache Zeichenkette kopierbar, höchstens zwei Fachbegriffe |
| 2 | Eigene Verwaltungsoberfläche, verständlich, drei bis vier Fachbegriffe |
| 1 | Vertrauensmodell oder Beglaubigungen müssen verstanden werden |
| 0 | Ohne Vorwissen nicht bedienbar |

**Punkte:** 3 **Begründung:** Schlüssel als kopierbare Zeichenkette, nur ein Fachbegriff. Schlüsselpaar existiert nur als lokale Textdatei oder Konsolenausgabe, keine Verwaltungsoberfläche.

### U5 Schutz vor Fehlbedienung (Gewicht 6)

| Nr. | Schutzmechanismus | Vorhanden |
|---|---|:---:|
| U5.1 | Passwort muss bestätigt werden | ☑ |
| U5.2 | Anzeige der Passwortstärke | ☐ |
| U5.3 | Warnung vor dem Überschreiben bestehender Dateien | ☐ |
| U5.4 | Abbruch hinterlässt keine unvollständige Ausgabedatei | ☐ |
| U5.5 | Hinweis, dass ein vergessenes Passwort nicht wiederherstellbar ist | ☐ |
| U5.6 | Originaldatei wird nicht ohne Nachfrage gelöscht | ☑ |
| **Anzahl erfüllt (max. 6)** | | **2** |

| Punkte | Bedingung |
|:---:|---|
| 4 | 6 erfüllt |
| 3 | 5 erfüllt |
| 2 | 3 bis 4 erfüllt |
| 1 | 1 bis 2 erfüllt |
| 0 | Keiner erfüllt |

**Punkte:** 1 **Begründung:** 2 Schutzmechanismen erfüllt.

---

## Funktionsumfang

### F1 Passwort- und Public-Key-Modus (Gewicht 5)

| Nr. | Prüffrage | Antwort |
|---|---|---|
| F1.1 | Passwortmodus vorhanden? | ja |
| F1.2 | Public-Key-Modus vorhanden? | ja |
| F1.3 | Sind beide über dieselbe Oberfläche erreichbar? | ja |

| Punkte | Bedingung |
|:---:|---|
| 4 | Beide Modi vollwertig in derselben Oberfläche |
| 3 | Beide Modi, einer davon umständlich erreichbar |
| 2 | Nur ein Modus, dieser vollwertig |
| 1 | Nur ein Modus, eingeschränkt |
| 0 | Keiner nutzbar |

**Punkte:** 4 **Begründung:** Beide Modi mit verschiedenen Parametern über die CLI erreichbar.

### F2 Mehrere Empfänger (Gewicht 3)

| Nr. | Prüffrage | Antwort |
|---|---|---|
| F2.1 | Kann eine Datei für mehrere Empfänger verschlüsselt werden? | ja |
| F2.2 | Getestete Anzahl Empfänger | OFFEN: Test mit mehreren Empfängern durchführen (Header wächst laut Dokumentation pro Empfänger um ca. 200 B) |
| F2.3 | Können Empfänger nachträglich hinzugefügt werden? | nein, nur durch erneutes Verschlüsseln |

| Punkte | Bedingung |
|:---:|---|
| 4 | Beliebig viele Empfänger, nachträgliches Hinzufügen möglich |
| 3 | Beliebig viele Empfänger |
| 2 | Begrenzte Anzahl oder nur umständlich |
| 1 | Nur über Umwege (z. B. mehrfach verschlüsseln) |
| 0 | Nicht möglich |

**Punkte:** 3 **Begründung:** Beliebig viele Empfänger; nachträgliches Hinzufügen nur durch erneutes Verschlüsseln.

### F3 Große Dateien und Streaming (Gewicht 4)

| Nr. | Prüffrage | Antwort |
|---|---|---|
| F3.1 | Wurde D2 erfolgreich ver- und entschlüsselt? | ja |
| F3.2 | Maximaler RAM-Verbrauch beim Verschlüsseln | 265,55 MB |
| F3.3 | Maximaler RAM-Verbrauch beim Entschlüsseln | 558,25 MB (OFFEN: Ursache für doppelten Verbrauch prüfen) |
| F3.4 | Gibt es eine Fortschrittsanzeige? | nein |
| F3.5 | Gibt es ein dokumentiertes Größenlimit? | nein (theoretisch ca. 1,18 ZB) |

| Punkte | Bedingung |
|:---:|---|
| 4 | Erfolgreich, RAM unabhängig von der Dateigröße, Fortschrittsanzeige |
| 3 | Erfolgreich, RAM unabhängig von der Dateigröße, keine Fortschrittsanzeige |
| 2 | Erfolgreich, RAM wächst mit Dateigröße |
| 1 | Größenlimit oder extrem langsam |
| 0 | Fehlgeschlagen |

**Punkte:** 3 **Begründung:** Praktisch kein Größenlimit, RAM unabhängig von der Dateigröße zwischen 200 MB und 600 MB, keine Fortschrittsanzeige. (OFFEN: Konstanz durch Vergleichsmessung mit D1 belegen.)

### F4 Erweiterbarkeit (Gewicht 3)

| Nr. | Prüffrage | Antwort |
|---|---|---|
| F4.1 | Gibt es eine Plugin-Schnittstelle? | ja |
| F4.2 | Werden Hardware-Token unterstützt (YubiKey, Smartcard, TPM)? | ja, über Plugins (z. B. age-plugin-yubikey, age-plugin-tpm) |
| F4.3 | Gibt es eine Bibliothek oder API für Entwickler? | ja (Go-Paket filippo.io/age) |

| Punkte | Bedingung |
|:---:|---|
| 4 | Plugins, Hardware-Token und Bibliothek |
| 3 | Zwei der drei |
| 2 | Eines der drei, gut dokumentiert |
| 1 | Eines der drei, eingeschränkt |
| 0 | Keines |

**Punkte:** 4 **Begründung:** Plugin-Schnittstelle, Hardware-Token über Plugins und Bibliothek vorhanden.

---

## Plattform

### P1 Betriebssystem-Abdeckung (Gewicht 4)

| System | Offiziell unterstützt |
|---|:---:|
| Windows | ☑ |
| macOS | ☑ |
| Linux | ☑ |
| Android | ☐ |
| iOS | ☐ |

| Punkte | Bedingung |
|:---:|---|
| 4 | Alle drei Desktop-Systeme und mindestens ein mobiles System |
| 3 | Alle drei Desktop-Systeme |
| 2 | Zwei Systeme |
| 1 | Ein System |
| 0 | Nur inoffizielle Portierungen |

**Punkte:** 3 **Begründung:** Alle drei Desktop-Systeme; mobile Systeme nur über inoffizielle Umwege.

### P2 Installation und Portabilität (Gewicht 3)

| Nr. | Prüffrage | Antwort |
|---|---|---|
| P2.1 | Größe des Downloads | 19.777 KB (ZIP) |
| P2.2 | Sind Administratorrechte nötig? | nein |
| P2.3 | Gibt es eine portable Version ohne Installation? | ja |
| P2.4 | Dauer bis zur Einsatzbereitschaft | 5 min |
| P2.5 | Müssen zusätzliche Abhängigkeiten installiert werden? | nein |

| Punkte | Bedingung |
|:---:|---|
| 4 | Portabel, keine Adminrechte, keine Abhängigkeiten, unter 1 Minute |
| 3 | Einfacher Installer, keine Abhängigkeiten |
| 2 | Installer mit Adminrechten oder großer Download |
| 1 | Zusätzliche Abhängigkeiten oder Paketmanager nötig |
| 0 | Nur aus dem Quellcode installierbar |

**Punkte:** 3 **Begründung:** Grundsätzlich portabel, aber nicht unter 1 Minute einsatzbereit. Download der Binärdateien über GitHub ist für Laien umständlich, Installation über winget einfach.

### P3 Interoperabilität (Gewicht 3)

| Nr. | Prüffrage | Antwort |
|---|---|---|
| P3.1 | Gibt es weitere kompatible Implementierungen? Welche? | rage (Rust), typage (TypeScript, npm-Paket age-encryption), pyage (Python), Crypt::age (Perl), libage (OFFEN: prüfen) |
| P3.2 | Test: Datei mit Tool A verschlüsselt, mit Tool B entschlüsselt | erfolgreich |
| P3.3 | Ist das Format versioniert und abwärtskompatibel? | ja |

| Punkte | Bedingung |
|:---:|---|
| 4 | Mehrere unabhängige kompatible Implementierungen, Test erfolgreich |
| 3 | Eine weitere kompatible Implementierung |
| 2 | Offenes Format, aber nur eine Implementierung |
| 1 | Format nur aus dem Quellcode ableitbar |
| 0 | Proprietäres Format |

**Punkte:** 4 **Begründung:** Mehrere unabhängige Implementierungen; Format strikt versioniert, abwärtskompatibel und werkzeugunabhängig.

---

## Wartung

### W1 Aktive Weiterentwicklung (Gewicht 5)

| Nr. | Prüffrage | Antwort |
|---|---|---|
| W1.1 | Datum des letzten Releases | 29.08.2026 |
| W1.2 | Anzahl Releases in den letzten 12 Monaten | 3 |
| W1.3 | Anzahl aktiver Maintainer | 1–2 |
| W1.4 | Ist das Repository archiviert? | nein |
| W1.5 | Reaktionszeit auf neue Issues (Stichprobe) | ~1 Monat |

| Punkte | Bedingung |
|:---:|---|
| 4 | Mehrere Releases im letzten Jahr, mehrere Maintainer |
| 3 | Mindestens ein Release im letzten Jahr |
| 2 | Letztes Release 1 bis 2 Jahre alt |
| 1 | Letztes Release über 2 Jahre alt |
| 0 | Archiviert oder eingestellt |

**Punkte:** 3 **Begründung:** 3 Releases im letzten Jahr, aber im Wesentlichen ein Hauptentwickler und Reaktionszeit von etwa einem Monat.

### W2 Lizenz (Gewicht 2)

| Nr. | Prüffrage | Antwort |
|---|---|---|
| W2.1 | Lizenz | BSD-3-Clause |
| W2.2 | OSI-anerkannte Open-Source-Lizenz? | ja |
| W2.3 | Ist der vollständige Quellcode verfügbar? | ja |

| Punkte | Bedingung |
|:---:|---|
| 4 | OSI-Lizenz, vollständiger Quellcode |
| 2 | Quellcode einsehbar, aber eingeschränkte Lizenz |
| 0 | Proprietär |

**Punkte:** 4 **Begründung:** OSI-Lizenz, vollständiger Quellcode öffentlich.

### W3 Dokumentation und Community (Gewicht 3)

| Nr. | Prüffrage | Antwort |
|---|---|---|
| W3.1 | Gibt es eine Anleitung für Endnutzer? | ja, aber für Laien schwer verständlich |
| W3.2 | Ist die Dokumentation auf Deutsch verfügbar? | nein |
| W3.3 | Gibt es FAQ oder Tutorials? | nein |
| W3.4 | Gibt es ein aktives Forum oder aktive Issue-Diskussionen? | ja |

| Punkte | Bedingung |
|:---:|---|
| 4 | Alle vier erfüllt |
| 3 | Drei erfüllt |
| 2 | Zwei erfüllt |
| 1 | Eines erfüllt |
| 0 | Keines erfüllt |

**Punkte:** 2 **Begründung:** Zwei erfüllt. Anleitung vorhanden, aber unübersichtlich und für Laien ungeeignet.

---

## Zusammenfassung

| Nr. | Kriterium | Gewicht | Punkte (0–4) | Gewichtet (Gewicht × Punkte / 4) |
|---|---|---:|:---:|:---:|
| S1 | AEAD und Integritätsschutz | 6 | 4 | 6,00 |
| S2 | Passwort-KDF | 6 | 3 | 4,50 |
| S3 | Post-Quanten-Resistenz | 6 | 3 | 4,50 |
| S4 | Sichere Defaults | 6 | 3 | 4,50 |
| S5 | Spezifikation und Audits | 6 | 3 | 4,50 |
| U1 | Zeit bis zur ersten Verschlüsselung | 8 | 1 | 2,00 |
| U2 | Interaktionsschritte | 6 | 3 | 4,50 |
| U3 | Fehlermeldungen | 7 | 2 | 3,50 |
| U4 | Schlüsselverwaltung | 8 | 3 | 6,00 |
| U5 | Schutz vor Fehlbedienung | 6 | 1 | 1,50 |
| F1 | Passwort- und Public-Key-Modus | 5 | 4 | 5,00 |
| F2 | Mehrere Empfänger | 3 | 3 | 2,25 |
| F3 | Große Dateien | 4 | 3 | 3,00 |
| F4 | Erweiterbarkeit | 3 | 4 | 3,00 |
| P1 | Betriebssystem-Abdeckung | 4 | 3 | 3,00 |
| P2 | Installation | 3 | 3 | 2,25 |
| P3 | Interoperabilität | 3 | 4 | 3,00 |
| W1 | Aktive Entwicklung | 5 | 3 | 3,75 |
| W2 | Lizenz | 2 | 4 | 2,00 |
| W3 | Dokumentation und Community | 3 | 2 | 1,50 |
| | **Nutzwert** | **100** | | **70,25** |

## Beobachtete UX-Schwachstellen

Schweregrad: hoch = kann zu Datenverlust oder scheinbarer Sicherheit führen; mittel = führt zu Fehlbedienung oder Verzögerung, ist aber behebbar; gering = beeinträchtigt nur Komfort oder Ästhetik.

| Nr. | Situation | Beobachtung | Schweregrad (gering / mittel / hoch) | Konsequenz für Aegis |
|---|---|---|---|---|
| 1 | Gesamte Bedienung | age ist ein reines Kommandozeilenprogramm ohne grafische Oberfläche. Nutzer müssen Befehle, Parameter und Dateipfade kennen und im Terminal navigieren. Für Laien ist das Programm damit praktisch nicht nutzbar | mittel | Grafische Oberfläche als primäre Bedienform; alle Standardaufgaben ohne Terminal erledigbar |
| 2 | Einstieg und Hilfe | Die eingebaute Hilfe (`age --help`) und die Dokumentation sind knapp, setzen Vorwissen voraus und enthalten kaum Beispiele für typische Aufgaben. Die erste Verschlüsselung gelang erst nach mehrfachem Nachschlagen in Dokumentation und Hilfe | mittel | Hilfe direkt in der Oberfläche an der Stelle, wo sie gebraucht wird; für die CLI-Version eine Hilfe mit konkreten Beispielen für die häufigsten Aufgaben |
| 3 | Ausgabedatei festlegen | Es gibt keinen Standardnamen für die Ausgabedatei. Der Name muss bei jedem Aufruf mit `-o` angegeben werden; ohne `-o` schlägt der erste Versuch fehl | mittel | Ausgabename automatisch ableiten (z. B. `datei.pdf` → `datei.pdf.aegis`), bei Bedarf änderbar; vor dem Überschreiben bestehender Dateien warnen |

## Beobachtete UX-Stärken

| Nr. | Situation | Beobachtung | Übertragbar auf Aegis? | Begründung |
|---|---|---|---|---|
| 1 | Kommandozeile | Die CLI eignet sich für technisch versierte Nutzer, die einen Großteil der heutigen Verschlüsselungsnutzer ausmachen, sowie für Skripte und Automatisierung | ja, als Ergänzung | Aegis sollte neben der grafischen Oberfläche eine CLI auf Basis desselben Kryptokerns anbieten. Das passt zur modularen Architektur und erschließt die technische Zielgruppe, ohne die Hauptzielgruppe zu belasten |
| 2 | Parameterumfang | Die Parameter sind auf das Wesentliche reduziert (Ver- und Entschlüsseln, Passwort, Empfänger, Schlüsseldatei, Ausgabe, Textformat). Es gibt keine Konfigurationsoptionen für Algorithmen | ja | Leitlinie für die Aegis-CLI und -GUI: wenige, klar benannte Parameter und keine unsicheren Wahlmöglichkeiten |
| 3 | Installation | Installation unter Windows mit einem einzigen Befehl über winget, ohne Administratorrechte und ohne Abhängigkeiten | ja | Aegis zusätzlich über Paketmanager verteilen (z. B. winget, Flatpak, Nix), damit Installation und Updates einfach bleiben |

### Hinweis zur Verwendung von KI-Werkzeugen

| Eingesetztes KI-Werkzeug | Zweck / Art der Nutzung |
|---|---|
| Claude Opus 5.5 | Erste Erstellung der Kriterien für die Nutzwertanalyse, Bereitstellung des Prüfprotokolls als Markdown Code, Prüfung der ausgefüllten Protokolle auf Konsistenz und sachliche Richtigkeit |
| Gemini 3.8 Flash | Unterstützung bei der Beantwortung einzelner Prüffragen und der Durchsuchung von Dokumentation |

### Ergänzende Quellen & Eigene Prüfleistungen

| ID | Typ | Urheber / Projekt | Titel / Ressource | Stand / URL |
|---|---|---|---|---|
| **[REPO-AGE]** | GitHub-Repository | Filippo Valsorda | *FiloSottile/age: A simple, modern and secure encryption tool (and Go library) with small keys, no config options, and UNIX-style composability* | GitHub Repository<br>`https://github.com/FiloSottile/age` |
| **[SPEC-C2SP-AGE]** | Spezifikation (C2SP) | Community Cryptography Specification Project (C2SP) / Filippo Valsorda | *The age encryption format (v1)* | C2SP Spezifikation (GitHub)<br>`https://github.com/C2SP/C2SP/blob/main/age.md` |
| **[REL-AGE-130]** | Release Notes | Filippo Valsorda | *age v1.3.0: Post-quantum recipients* | GitHub Releases<br>`https://github.com/FiloSottile/age/releases` |
| **[EXP-TESTS]** | Eigene Erhebung | Oliver Decker | *Empirische Funktions- und Sicherheitsanalyse (Protokollprüfungen auf Windows 11)* | Eigene Prüfungen (05.10.2026) |
