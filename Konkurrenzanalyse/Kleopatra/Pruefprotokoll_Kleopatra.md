# Prüfprotokoll Konkurrenzanalyse

## Allgemeine Angaben

| Feld | Eintrag |
|---|---|
| Tool | Kleopatra (Gpg4win) |
| Version | Gpg4win 5.1.1, Kleopatra OFFEN: ___, GnuPG OFFEN: ___ |
| Betriebssystem und Version | Windows 11 Education 25H2 |
| Hardware (CPU, RAM) | AMD Ryzen AI 9 HX 370, 32GB DDR5-5200 |
| Datum | 06.10.2026 |
| Prüfer | Oliver Decker |

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
| S1.1 | Welcher Verschlüsselungsalgorithmus wird verwendet? | AES-256 (CFB) |
| S1.2 | Ist die Verschlüsselung authentifiziert (AEAD oder Encrypt-then-MAC)? | nein, OpenPGP-CFB mit MDC (SHA-1-Hash über den Klartext, mitverschlüsselt; kein MAC) |
| S1.3 | Ist der Header authentifiziert? | nein |
| S1.4 | Sind Chunks gegen Vertauschen und Löschen geschützt? | nein |
| S1.5 | Wird ein Abschneiden der Datei erkannt (Test mit D5)? | ja |
| S1.6 | Wird eine Manipulation erkannt (Test mit D3 und D4)? | ja |

| Punkte | Bedingung |
|:---:|---|
| 4 | AEAD, Header authentifiziert, Chunk-Reihenfolge und Dateiende geschützt |
| 3 | AEAD und Header authentifiziert, Abschneiden wird nicht erkannt |
| 2 | Authentifizierung vorhanden, aber veraltete Konstruktion oder nur optional |
| 1 | Integrität nur über separate Signatur möglich |
| 0 | Kein Integritätsschutz |

**Punkte:** 2 **Begründung:** Integritätsschutz nur über die veraltete MDC-Konstruktion, keine echte Authentifizierung von Header und Payload. Bewertet wurde der Passwortmodus. (OFFEN: prüfen, ob Verschlüsselung an PQ-Schlüssel (v5) OCB als AEAD nutzt, und ggf. als Hinweis ergänzen.)

### S2 Stärke der Passwort-KDF (Gewicht 6)

| Nr. | Prüffrage | Antwort |
|---|---|---|
| S2.1 | Welche KDF wird im Passwortmodus verwendet? | S2K 3 (Iterated and Salted S2K) |
| S2.2 | Welche Parameter (Speicher, Iterationen, Parallelität)? | Speicher: 0 MiB (rein CPU-basiert), Iterationen: ~6,5 · 10⁷ verarbeitete Bytes (count = 65011712), Parallelität: 1 |
| S2.3 | Kann der Nutzer die Parameter abschwächen? | ja |
| S2.4 | Gemessene Dauer der Schlüsselableitung (Sekunden) | 0,1 s |

| Punkte | Bedingung |
|:---:|---|
| 4 | Argon2id mit Parametern mindestens nach RFC 9106 (64 MiB, t = 3), nicht abschwächbar |
| 3 | Argon2id mit schwächeren Parametern oder scrypt mit starken Parametern |
| 2 | scrypt mit schwachen Parametern oder PBKDF2 mit hoher Iterationszahl |
| 1 | Iteriertes S2K oder PBKDF2 mit niedriger Iterationszahl |
| 0 | Kein Passwortmodus oder unsichere Ableitung |

**Punkte:** 1 **Begründung:** Abschwächbares S2K 3 ohne Speicheranteil (keine speicherharte KDF).

### S3 Post-Quanten-Resistenz (Gewicht 6)

| Nr. | Prüffrage | Antwort |
|---|---|---|
| S3.1 | Wird ein Post-Quanten-Verfahren angeboten? | ja |
| S3.2 | Welches Verfahren (z. B. ML-KEM-768, ML-KEM-1024)? | Getestet: Kyber 1024 (bp384) = ML-KEM-1024 + BrainpoolP384r1. Voreinstellung: Kyber 768 (bp256) = ML-KEM-768 + BrainpoolP256r1. Weitere: ML-KEM-768 + X25519, ML-KEM-1024 + X448 |
| S3.3 | Wird es hybrid mit einem klassischen Verfahren kombiniert? | ja |
| S3.4 | Ist es standardmäßig aktiv? | nein |
| S3.5 | Ist es in der stabilen Version verfügbar (nicht Beta oder Plugin)? | ja |

| Punkte | Bedingung |
|:---:|---|
| 4 | Hybrides standardisiertes Verfahren, standardmäßig aktiv |
| 3 | Hybrides Verfahren verfügbar, muss manuell gewählt werden |
| 2 | Nur über Plugin oder Beta-Version |
| 1 | Angekündigt, aber nicht verfügbar |
| 0 | Nicht vorhanden |

**Punkte:** 3 **Begründung:** Stabiles hybrides Verfahren verfügbar, muss manuell gewählt werden. Umsetzung nach LibrePGP, nicht nach dem IETF-Standard RFC 9980; PQ-Schlüssel sind daher nur mit LibrePGP-Implementierungen kompatibel.

### S4 Sichere Defaults (Gewicht 6)

| Nr. | Prüffrage | Antwort |
|---|---|---|
| S4.1 | Sind die Standardeinstellungen ohne Änderung sicher? | (ja), S2K und MDC jedoch kryptografisch veraltet |
| S4.2 | Kann der Nutzer veraltete oder unsichere Algorithmen auswählen? | ja, über Expertenmenüs und Konfiguration |
| S4.3 | Ist ein leeres Passwort möglich? | nein |
| S4.4 | Wird bei schwachem Passwort gewarnt oder blockiert? | ja, gewarnt |
| S4.5 | Wird unverschlüsselter Klartext unbeabsichtigt zurückgelassen? | nein |

| Punkte | Bedingung |
|:---:|---|
| 4 | Keine unsicheren Optionen wählbar, schwache Passwörter werden abgefangen |
| 3 | Keine unsicheren Optionen, aber keine Passwortprüfung |
| 2 | Unsichere Optionen versteckt in Expertenmenüs wählbar |
| 1 | Unsichere Optionen gleichrangig neben sicheren wählbar |
| 0 | Unsichere Standardeinstellungen |

**Punkte:** 2 **Begründung:** Unsichere Optionen über Expertenmenüs wählbar.

### S5 Öffentliche Spezifikation und Audits (Gewicht 6)

| Nr. | Prüffrage | Antwort |
|---|---|---|
| S5.1 | Gibt es eine öffentliche Spezifikation des Dateiformats? | ja |
| S5.2 | Ist das Format standardisiert (RFC, C2SP o. Ä.)? | teilweise: IETF RFC 4880 sowie LibrePGP (kein IETF-Standard). RFC 9580 und RFC 9980 werden von GnuPG nicht implementiert |
| S5.3 | Gab es ein unabhängiges Sicherheitsaudit? Wer, wann? | BSI-Zulassung VS-NfD für Gpg4win und Gpg4KDE 3.X (BSI-VSA-10187, 31.01.2019). OFFEN: Angabe „Cure53 (2017)“ nicht belegbar, Quelle suchen oder streichen |
| S5.4 | Wurden die Befunde behoben? | OFFEN: abhängig von S5.3 |
| S5.5 | Gibt es öffentliche Testvektoren? | ja |

| Punkte | Bedingung |
|:---:|---|
| 4 | Standardisierte Spezifikation, aktuelles Audit mit behobenen Befunden, Testvektoren |
| 3 | Öffentliche Spezifikation und Audit vorhanden |
| 2 | Nur Spezifikation oder nur Audit |
| 1 | Nur informelle Beschreibung |
| 0 | Weder Spezifikation noch Audit |

**Punkte:** 3 **Begründung:** Öffentliche, teilweise standardisierte Spezifikation und Prüfung durch das BSI vorhanden, diese bezieht sich jedoch auf Version 3.X und ist nicht aktuell.

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
| U1.1 | Zeit vom Programmstart bis zur fertigen verschlüsselten Datei (T1) | 35 s |
| U1.2 | Wurde Dokumentation oder Websuche benötigt? Wie oft? | nein |
| U1.3 | Gab es Fehlversuche? Welche? | nein |

| Punkte | Bedingung |
|:---:|---|
| 4 | Unter 1 Minute, ohne Hilfe |
| 3 | 1 bis 3 Minuten, ohne Hilfe |
| 2 | 3 bis 5 Minuten oder einmal Dokumentation nötig |
| 1 | Über 5 Minuten oder mehrfach Dokumentation nötig |
| 0 | Aufgabe nicht gelöst |

**Punkte:** 4 **Begründung:** Mit 35 Sekunden unter 1 Minute ohne externe Hilfe gelöst.

### U2 Anzahl der Interaktionsschritte (Gewicht 6)

Gezählt werden Klicks, Tastatureingaben von Befehlen und Dialogbestätigungen. Passworteingabe zählt als ein Schritt.

| Aufgabe | Schritte Verschlüsseln | Schritte Entschlüsseln |
|---|:---:|:---:|
| T1 | 6 | 6 |
| T2 | 7 | 6 |
| **Durchschnitt** | 6,5 | 6 |

| Punkte | Bedingung (Durchschnitt pro Vorgang) |
|:---:|---|
| 4 | Höchstens 5 Schritte |
| 3 | 6 bis 10 Schritte |
| 2 | 11 bis 15 Schritte |
| 1 | 16 bis 25 Schritte |
| 0 | Mehr als 25 Schritte |

**Punkte:** 3 **Begründung:** Durchschnittlich 6,25 Schritte pro Vorgang.

### U3 Verständlichkeit von Fehlermeldungen (Gewicht 7)

Teilerfüllung (☑ in Klammern) zählt 0,5.

| Szenario | Fehler erkannt | Für Laien verständlich | Handlungsempfehlung | Ursache korrekt benannt | Wortlaut der Meldung |
|---|:---:|:---:|:---:|:---:|---|
| T3 falsches Passwort | ☑ | ☑ | ☐ | ☑ | Failed to decrypt ‘test_1gb.bin.gpg’: Bad passphrase. |
| D3 Manipulation Mitte | ☑ | ☐ | ☐ | (☑) | Failed to decrypt ‘test_1gb.bin - Copy.gpg’: Checksum error. |
| D4 Manipulation Header | ☑ | ☐ | ☐ | ☐ | The file ‘C:\Users\user\dev\Studienarbeit\Aegis\Konkurrenzanalyse\test_1gb.bin - Copy (2).gpg’ contains certificates and can't be decrypted or verified. |
| D5 abgeschnitten | ☑ | ☐ | ☐ | (☑) | Failed to decrypt ‘test_1gb.bin.gpg’: Checksum error. |
| Falscher privater Schlüssel | ☑ | ☐ | ☐ | ☑ | Unable to decrypt ‘test_1gb.bin_asymmetric.gpg’: No secret key. The data was not encrypted for any secret key in your certificate list. Recipient: One unknown recipient |
| **Anzahl erfüllt (max. 20)** | 5 | 1 | 0 | 3 | **9** |

| Punkte | Bedingung |
|:---:|---|
| 4 | 18 bis 20 erfüllt |
| 3 | 14 bis 17 erfüllt |
| 2 | 10 bis 13 erfüllt |
| 1 | 5 bis 9 erfüllt |
| 0 | Weniger als 5 erfüllt |

**Punkte:** 1 **Begründung:** 9 von 20 erfüllt. Die Meldung zu D4 benennt fälschlich Zertifikate als Ursache.

### U4 Komplexität der Schlüsselverwaltung (Gewicht 8)

| Nr. | Prüffrage | Antwort |
|---|---|---|
| U4.1 | Schritte bis zum eigenen Schlüsselpaar | 4 |
| U4.2 | Schritte bis zur Weitergabe des öffentlichen Schlüssels | 2 |
| U4.3 | Schritte bis zum Import eines fremden Schlüssels | 4 |
| U4.4 | Wird ein Schlüssel als kopierbare Zeichenkette dargestellt? | nein |
| U4.5 | Welche Fachbegriffe muss man verstehen? | ☑ Zertifikat ☑ Fingerprint ☑ Beglaubigung ☑ Vertrauensstufe ☑ Keyserver ☑ Ablaufdatum ☑ Identität/Recipient |
| U4.6 | Gibt es Warnungen oder Rückfragen, die ohne Vorwissen unverständlich sind? | ja |

| Punkte | Bedingung |
|:---:|---|
| 4 | Keine Schlüssel nötig oder Erzeugung und Austausch mit einem Klick |
| 3 | Schlüssel als einfache Zeichenkette kopierbar, höchstens zwei Fachbegriffe |
| 2 | Eigene Verwaltungsoberfläche, verständlich, drei bis vier Fachbegriffe |
| 1 | Vertrauensmodell oder Beglaubigungen müssen verstanden werden |
| 0 | Ohne Vorwissen nicht bedienbar |

**Punkte:** 1 **Begründung:** Vertrauensmodell, Beglaubigungen und 7 Fachbegriffe müssen verstanden werden; Warnungen ohne kryptografisches Vorwissen unverständlich.

### U5 Schutz vor Fehlbedienung (Gewicht 6)

Teilerfüllung (☑ in Klammern) zählt 0,5.

| Nr. | Schutzmechanismus | Vorhanden |
|---|---|:---:|
| U5.1 | Passwort muss bestätigt werden | ☑ |
| U5.2 | Anzeige der Passwortstärke | (☑) |
| U5.3 | Warnung vor dem Überschreiben bestehender Dateien | ☑ |
| U5.4 | Abbruch hinterlässt keine unvollständige Ausgabedatei | ☐ |
| U5.5 | Hinweis, dass ein vergessenes Passwort nicht wiederherstellbar ist | ☐ |
| U5.6 | Originaldatei wird nicht ohne Nachfrage gelöscht | ☑ |
| **Anzahl erfüllt (max. 6)** | | **3,5** |

| Punkte | Bedingung |
|:---:|---|
| 4 | 6 erfüllt |
| 3 | 5 erfüllt |
| 2 | 3 bis 4 erfüllt |
| 1 | 1 bis 2 erfüllt |
| 0 | Keiner erfüllt |

**Punkte:** 2 **Begründung:** 3 volle und 1 Teilerfüllung (keine Stärkeanzeige, nur Warnung bei schwachem Passwort; bei Abbruch verbleibt eine `.part`-Datei).

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

**Punkte:** 4 **Begründung:** Beide Modi vollwertig nebeneinander im selben Dialog erreichbar.

### F2 Mehrere Empfänger (Gewicht 3)

| Nr. | Prüffrage | Antwort |
|---|---|---|
| F2.1 | Kann eine Datei für mehrere Empfänger verschlüsselt werden? | ja |
| F2.2 | Getestete Anzahl Empfänger | OFFEN: Test mit mehreren Empfängern durchführen (laut Dokumentation kein Limit) |
| F2.3 | Können Empfänger nachträglich hinzugefügt werden? | nein |

| Punkte | Bedingung |
|:---:|---|
| 4 | Beliebig viele Empfänger, nachträgliches Hinzufügen möglich |
| 3 | Beliebig viele Empfänger |
| 2 | Begrenzte Anzahl oder nur umständlich |
| 1 | Nur über Umwege (z. B. mehrfach verschlüsseln) |
| 0 | Nicht möglich |

**Punkte:** 3 **Begründung:** Beliebig viele Empfänger gleichzeitig wählbar; nachträgliches Hinzufügen nur durch erneutes Verschlüsseln.

### F3 Große Dateien und Streaming (Gewicht 4)

| Nr. | Prüffrage | Antwort |
|---|---|---|
| F3.1 | Wurde D2 erfolgreich ver- und entschlüsselt? | ja |
| F3.2 | Maximaler RAM-Verbrauch beim Verschlüsseln | 138,39 MB |
| F3.3 | Maximaler RAM-Verbrauch beim Entschlüsseln | 136,61 MB |
| F3.4 | Gibt es eine Fortschrittsanzeige? | ja |
| F3.5 | Gibt es ein dokumentiertes Größenlimit? | nein |

| Punkte | Bedingung |
|:---:|---|
| 4 | Erfolgreich, RAM unter 200 MB, Fortschrittsanzeige |
| 3 | Erfolgreich, RAM unter 200 MB, keine Fortschrittsanzeige |
| 2 | Erfolgreich, RAM wächst mit Dateigröße |
| 1 | Größenlimit oder extrem langsam |
| 0 | Fehlgeschlagen |

**Punkte:** 4 **Begründung:** D2 erfolgreich ver- und entschlüsselt, RAM konstant unter 200 MB, Fortschrittsanzeige vorhanden.

### F4 Erweiterbarkeit (Gewicht 3)

| Nr. | Prüffrage | Antwort |
|---|---|---|
| F4.1 | Gibt es eine Plugin-Schnittstelle? | nein |
| F4.2 | Werden Hardware-Token unterstützt (YubiKey, Smartcard, TPM)? | ja (YubiKey und Smartcard über scdaemon; TPM nein) |
| F4.3 | Gibt es eine Bibliothek oder API für Entwickler? | ja (GPGME / GpgMEpp) |

| Punkte | Bedingung |
|:---:|---|
| 4 | Plugins, Hardware-Token und Bibliothek |
| 3 | Zwei der drei |
| 2 | Eines der drei, gut dokumentiert |
| 1 | Eines der drei, eingeschränkt |
| 0 | Keines |

**Punkte:** 3 **Begründung:** Hardware-Token und vollwertige Entwicklerbibliothek vorhanden, aber keine Plugin-Schnittstelle.

---

## Plattform

### P1 Betriebssystem-Abdeckung (Gewicht 4)

| System | Offiziell unterstützt |
|---|:---:|
| Windows | ☑ |
| macOS | ☐ |
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

**Punkte:** 2 **Begründung:** Offiziell und nativ für zwei Systeme unterstützt (Windows und Linux).

### P2 Installation und Portabilität (Gewicht 3)

| Nr. | Prüffrage | Antwort |
|---|---|---|
| P2.1 | Größe des Downloads | 43.781 KB |
| P2.2 | Sind Administratorrechte nötig? | ja |
| P2.3 | Gibt es eine portable Version ohne Installation? | nein |
| P2.4 | Dauer bis zur Einsatzbereitschaft | 5 min |
| P2.5 | Müssen zusätzliche Abhängigkeiten installiert werden? | nein |

| Punkte | Bedingung |
|:---:|---|
| 4 | Portabel, keine Adminrechte, keine Abhängigkeiten, unter 1 Minute |
| 3 | Einfacher Installer, keine Abhängigkeiten |
| 2 | Installer mit Adminrechten oder großer Download |
| 1 | Zusätzliche Abhängigkeiten oder Paketmanager nötig |
| 0 | Nur aus dem Quellcode installierbar |

**Punkte:** 2 **Begründung:** Installer erfordert Administratorrechte zur Systemeinbindung.

### P3 Interoperabilität (Gewicht 3)

| Nr. | Prüffrage | Antwort |
|---|---|---|
| P3.1 | Gibt es weitere kompatible Implementierungen? Welche? | ja (Sequoia-PGP, RNP/Thunderbird, OpenPGP.js, Bouncy Castle, GopenPGP). Einschränkung: PQ-Schlüssel nach LibrePGP sind nicht mit Implementierungen nach RFC 9580/9980 kompatibel |
| P3.2 | Test: Datei mit Tool A verschlüsselt, mit Tool B entschlüsselt | erfolgreich (GnuPG-Chiffrat mit Sequoia `sq decrypt` entschlüsselt; OFFEN: verwendeten Schlüsseltyp angeben) |
| P3.3 | Ist das Format versioniert und abwärtskompatibel? | ja |

| Punkte | Bedingung |
|:---:|---|
| 4 | Mehrere unabhängige kompatible Implementierungen, Test erfolgreich |
| 3 | Eine weitere kompatible Implementierung |
| 2 | Offenes Format, aber nur eine Implementierung |
| 1 | Format nur aus dem Quellcode ableitbar |
| 0 | Proprietäres Format |

**Punkte:** 4 **Begründung:** Mehrere unabhängige OpenPGP-Implementierungen verfügbar, Entschlüsselungstest erfolgreich. Für PQ-Schlüssel ist die Interoperabilität durch die Spaltung zwischen LibrePGP und IETF eingeschränkt.

---

## Wartung

### W1 Aktive Weiterentwicklung (Gewicht 5)

| Nr. | Prüffrage | Antwort |
|---|---|---|
| W1.1 | Datum des letzten Releases | 23.09.2026 |
| W1.2 | Anzahl Releases in den letzten 12 Monaten | 4 |
| W1.3 | Anzahl aktiver Maintainer | 2–4 |
| W1.4 | Ist das Repository archiviert? | nein |
| W1.5 | Reaktionszeit auf neue Issues (Stichprobe) | 1–4 Tage |

| Punkte | Bedingung |
|:---:|---|
| 4 | Mehrere Releases im letzten Jahr, mehrere Maintainer |
| 3 | Mindestens ein Release im letzten Jahr |
| 2 | Letztes Release 1 bis 2 Jahre alt |
| 1 | Letztes Release über 2 Jahre alt |
| 0 | Archiviert oder eingestellt |

**Punkte:** 4 **Begründung:** 4 Releases im letzten Jahr, mehrere aktive Entwickler, zügige Bearbeitung von Issues.

### W2 Lizenz (Gewicht 2)

| Nr. | Prüffrage | Antwort |
|---|---|---|
| W2.1 | Lizenz | GNU GPLv2+ |
| W2.2 | OSI-anerkannte Open-Source-Lizenz? | ja |
| W2.3 | Ist der vollständige Quellcode verfügbar? | ja |

| Punkte | Bedingung |
|:---:|---|
| 4 | OSI-Lizenz, vollständiger Quellcode |
| 2 | Quellcode einsehbar, aber eingeschränkte Lizenz |
| 0 | Proprietär |

**Punkte:** 4 **Begründung:** OSI-Lizenz (GPLv2+), vollständiger Quellcode.

### W3 Dokumentation und Community (Gewicht 3)

| Nr. | Prüffrage | Antwort |
|---|---|---|
| W3.1 | Gibt es eine Anleitung für Endnutzer? | ja |
| W3.2 | Ist die Dokumentation auf Deutsch verfügbar? | ja |
| W3.3 | Gibt es FAQ oder Tutorials? | ja |
| W3.4 | Gibt es ein aktives Forum oder aktive Issue-Diskussionen? | ja |

| Punkte | Bedingung |
|:---:|---|
| 4 | Alle vier erfüllt |
| 3 | Drei erfüllt |
| 2 | Zwei erfüllt |
| 1 | Eines erfüllt |
| 0 | Keines erfüllt |

**Punkte:** 4 **Begründung:** Deutschsprachiges Gpg4win-Kompendium, Handbuch, FAQ, Tutorials und aktives Forum vorhanden.

---

## Zusammenfassung

| Nr. | Kriterium | Gewicht | Punkte (0–4) | Gewichtet (Gewicht × Punkte / 4) |
|---|---|---:|:---:|:---:|
| S1 | AEAD und Integritätsschutz | 6 | 2 | 3,00 |
| S2 | Passwort-KDF | 6 | 1 | 1,50 |
| S3 | Post-Quanten-Resistenz | 6 | 3 | 4,50 |
| S4 | Sichere Defaults | 6 | 2 | 3,00 |
| S5 | Spezifikation und Audits | 6 | 3 | 4,50 |
| U1 | Zeit bis zur ersten Verschlüsselung | 8 | 4 | 8,00 |
| U2 | Interaktionsschritte | 6 | 3 | 4,50 |
| U3 | Fehlermeldungen | 7 | 1 | 1,75 |
| U4 | Schlüsselverwaltung | 8 | 1 | 2,00 |
| U5 | Schutz vor Fehlbedienung | 6 | 2 | 3,00 |
| F1 | Passwort- und Public-Key-Modus | 5 | 4 | 5,00 |
| F2 | Mehrere Empfänger | 3 | 3 | 2,25 |
| F3 | Große Dateien | 4 | 4 | 4,00 |
| F4 | Erweiterbarkeit | 3 | 3 | 2,25 |
| P1 | Betriebssystem-Abdeckung | 4 | 2 | 2,00 |
| P2 | Installation | 3 | 2 | 1,50 |
| P3 | Interoperabilität | 3 | 4 | 3,00 |
| W1 | Aktive Entwicklung | 5 | 4 | 5,00 |
| W2 | Lizenz | 2 | 4 | 2,00 |
| W3 | Dokumentation und Community | 3 | 4 | 3,00 |
| | **Nutzwert** | **100** | | **65,75** |

---

## Beobachtete UX-Schwachstellen

| Nr. | Situation | Beobachtung | Schweregrad (gering / mittel / hoch) | Konsequenz für Aegis |
|---|---|---|---|---|
| 1 | | | | |
| 2 | | | | |
| 3 | | | | |

---

### Hinweis zur Verwendung von KI-Werkzeugen

| Eingesetztes KI-Werkzeug | Zweck / Art der Nutzung |
|---|---|
| Claude Opus 5.5 | Erste Erstellung der Kriterien für die Nutzwertanalyse, Bereitstellung des Prüfprotokolls als Markdown Code, Prüfung der ausgefüllten Protokolle auf Konsistenz und sachliche Richtigkeit |
| Gemini 3.8 Flash | Unterstützung bei der Beantwortung einzelner Prüffragen und der Durchsuchung von Dokumentation |

---

### Ergänzende Quellen & Eigene Prüfleistungen

| ID | Typ | Urheber / Projekt | Titel / Ressource | Stand / URL |
|---|---|---|---|---|
| **[REPO-KLEO]** | GitHub-Repository | KDE Community | *KDE/kleopatra: Certificate manager and universal crypto GUI* | GitHub Repository<br>`https://github.com/KDE/kleopatra` |
| **[REPO-GPG4WIN]** | GitHub-Repository | Gpg4win Initiative | *gpg/gpg4win: Gpg4win build scripts and Windows installer packaging* | GitHub Repository<br>`https://github.com/gpg/gpg4win` |
| **[WEB-GPG4WIN]** | Website (Dokumentation) | Gpg4win Initiative | *Gpg4win – Secure e-mail and file encryption for Windows* | Offizielle Website<br>`https://www.gpg4win.org/index.html` |
| **[WEB-KDE-KLEO]** | Website (App-Übersicht) | KDE Community | *KDE Applications: Kleopatra* | KDE Software-Portal<br>`https://apps.kde.org/kleopatra/` |
| **[GPG-T8092]** | Issue-Tracker | GnuPG Project | *T8092: Add algorithm info for all kyber choices on certificate generation* | `https://dev.gnupg.org/T8092` |
| **[BSI-VSA-10187]** | Zulassungsreport | Bundesamt für Sicherheit in der Informationstechnik | *Zulassung BSI-VSA-10187 für Gpg4 VS-NfD (Gpg4win und Gpg4KDE), Version 3.X* | 31.01.2019 |
| **[RFC-4880]** | Standard | IETF | *RFC 4880: OpenPGP Message Format* | `https://www.rfc-editor.org/rfc/rfc4880` |
| **[LIBREPGP]** | Spezifikation | LibrePGP / Werner Koch | *LibrePGP Message Format* | `https://librepgp.org` |
| **[EXP-TESTS]** | Eigene Erhebung | Oliver Decker | *Empirische Funktions- und Sicherheitsanalyse (Protokollprüfungen auf Windows 11)* | Eigene Prüfungen (06.10.2026) |