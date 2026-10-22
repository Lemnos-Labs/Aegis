# Bedrohungsmodell Aegis: STRIDE-Analyse

Grundlage ist das Datenflussdiagramm `Aegis_Datenflussdiagramm.drawio` mit den Seiten „Passwortmodus“ und „Empfängermodus“. Die Analyse folgt dem Verfahren STRIDE pro Element: Jedes Element wird gegen die für seinen Typ relevanten Bedrohungsklassen geprüft. Der Umfang entspricht dem CLI-Prototyp.

## 1. Umfang, Annahmen und Ausschlüsse

| Nr. | Annahme | Begründung / Folge |
|---|---|---|
| AN-01 | Die Endgeräte von Sender und Empfänger sind zum Zeitpunkt der Nutzung nicht kompromittiert | Gegen Schadsoftware mit Zugriff auf Arbeitsspeicher oder Tastatureingaben (z. B. Keylogger) kann eine Anwendung im Nutzerkontext nicht schützen; außerhalb des Umfangs |
| AN-02 | Betriebssystem und dessen Zufallsgenerator sind vertrauenswürdig | Grundlage für Schlüsselerzeugung (NFA-06) |
| AN-03 | Die verwendeten Bibliotheken (`age`, `aws-lc-rs`) sind korrekt implementiert | Keine Eigenimplementierung von Primitiven (RB-18); Fehler in Bibliotheken werden über Updates und `cargo audit` behandelt |
| AN-04 | Der Übertragungskanal A2 steht vollständig unter Kontrolle eines Angreifers | Angreifer kann Dateien mitlesen, speichern, verändern, löschen und erneut einspielen |
| AN-05 | Ein Angreifer kontrolliert nicht gleichzeitig A2 und den separaten Kanal A4 | Voraussetzung dafür, dass die getrennte Übermittlung von Passwort bzw. öffentlichem Schlüssel Schutz bietet |
| AN-06 | Physische Seitenkanalangriffe (z. B. Strom- oder elektromagnetische Messungen) sind ausgeschlossen | Unverhältnismäßig für die Zielgruppe; zeitkonstante Implementierungen liefern die verwendeten Bibliotheken |

## 2. Schützenswerte Güter

| Nr. | Gut | Schutzziel |
|---|---|---|
| G-01 | Inhalt der Klartextdatei | Vertraulichkeit, Integrität |
| G-02 | Passwort | Vertraulichkeit |
| G-03 | Privater Schlüssel | Vertraulichkeit, Verfügbarkeit |
| G-04 | Öffentlicher Schlüssel des Empfängers | Authentizität |
| G-05 | Metadaten (Dateiname, Dateigröße, Empfänger, Zeitpunkt) | Vertraulichkeit |
| G-06 | Aegis selbst (Programmdateien) | Integrität |

## 3. Angreifermodelle

| Nr. | Angreifer | Fähigkeiten |
|---|---|---|
| AM-1 | Passiver Mitleser | Liest Dateien auf A2 mit und speichert sie dauerhaft |
| AM-2 | Aktiver Angreifer auf dem Übertragungsweg | Verändert, ersetzt, löscht oder spielt Dateien auf A2 erneut ein |
| AM-3 | Zukünftiger Angreifer mit Quantencomputer | Entschlüsselt heute gespeicherte Daten später („Harvest now, decrypt later“) |
| AM-4 | Dieb eines Geräts oder Datenträgers | Offline-Zugriff auf alle gespeicherten Dateien, inklusive Schlüsseldatei |
| AM-5 | Absender präparierter Dateien | Schickt dem Empfänger gezielt fehlerhafte oder manipulierte Dateien |
| AM-6 | Angreifer auf dem separaten Kanal | Gibt sich am Telefon oder per Nachricht als Sender oder Empfänger aus |

## 4. Sicherheitsziele des eigenen Protokolls

Die Sicherheitsziele legen fest, welche Eigenschaften das eigene Dateiformat garantieren soll. Sie sind der Maßstab für den Protokollentwurf und dessen Bewertung. Für das age-Format gelten die Eigenschaften der age-Spezifikation.

| Nr. | Sicherheitsziel | Beschreibung | Gilt für | Bezug |
|---|---|---|---|---|
| SZ-01 | Vertraulichkeit des Inhalts | Ohne Passwort bzw. privaten Schlüssel lässt sich aus einer Datei keine Information über den Inhalt gewinnen, auch nicht durch einen aktiven Angreifer, der veränderte Dateien zur Entschlüsselung vorlegt (IND-CCA2) | Beide Modi | AM-1, AM-2; NFA-01, NFA-02 |
| SZ-02 | Integrität und Vollständigkeit | Jede Veränderung, Umordnung, Entfernung oder Kürzung von Dateikopf oder Blöcken wird erkannt; es wird kein ungeprüfter Klartext ausgegeben (INT-CTXT) | Beide Modi | AM-2; NFA-02, FA-53 |
| SZ-03 | Schutz vor Herabstufung | Formatversion, Verfahrenskennungen und Parameter im Dateikopf sind authentifiziert; ein Angreifer kann keine schwächeren Verfahren oder Parameter erzwingen | Beide Modi | AM-2; NFA-02, NFA-38, NFA-51 |
| SZ-04 | Post-Quanten-Sicherheit des Schlüsselaustauschs | Der Schlüsselaustausch bleibt sicher, solange mindestens eines der beiden kombinierten Verfahren (klassisch oder ML-KEM) sicher ist | Empfängermodus | AM-3; NFA-04, RB-20 |
| SZ-05 | Widerstand gegen Passwortraten | Ein Offline-Angriff auf das Passwort ist nur durch Ausprobieren möglich; jeder Versuch erfordert eine vollständige Argon2id-Berechnung | Passwortmodus, private Schlüsseldatei | AM-4; NFA-03, NFA-07 |
| SZ-06 | Vertraulichkeit der Metadaten | Dateiname und Identität der Empfänger sind aus der verschlüsselten Datei nicht ablesbar | Beide Modi | AM-1; FA-46, NFA-52 |
| SZ-07 | Absenderauthentizität | Der Empfänger kann prüfen, welcher Schlüssel eine Datei signiert hat; Signaturen sind nicht fälschbar (EUF-CMA), auch nicht mit einem Quantencomputer, solange eines der beiden Signaturverfahren sicher ist | Empfängermodus, sobald umgesetzt | AM-2, AM-3; FA-08, NFA-05 |

**Ausdrücklich keine Sicherheitsziele**

| Nr. | Nicht-Ziel | Begründung |
|---|---|---|
| NZ-01 | Forward Secrecy | Bei Dateiverschlüsselung gibt es keine Sitzung, deren Schlüssel verworfen werden könnte; wer den privaten Schlüssel erlangt, kann alle an ihn gerichteten Dateien entschlüsseln |
| NZ-02 | Absenderauthentizität im Passwortmodus | Jeder, der das Passwort kennt, kann gültige Dateien erzeugen |
| NZ-03 | Verbergen der Dateigröße | Die Größe der verschlüsselten Datei entspricht ungefähr der des Inhalts |
| NZ-04 | Schutz vor erneutem Einspielen | Eine gültige ältere Datei bleibt gültig (T-31) |
| NZ-05 | Abstreitbarkeit | Signierte Dateien sollen dem Absender gerade zuordenbar sein |
| NZ-06 | Schutz bei kompromittiertem Endgerät | Außerhalb des Umfangs (AN-01) |

## 5. Bewertungsschema

Wahrscheinlichkeit (W) und Schaden (S) werden jeweils als **niedrig**, **mittel** oder **hoch** eingestuft. Das Risiko ergibt sich aus der Kombination:

| W \ S | Niedrig | Mittel | Hoch |
|---|---|---|---|
| **Niedrig** | Niedrig | Niedrig | Mittel |
| **Mittel** | Niedrig | Mittel | Hoch |
| **Hoch** | Mittel | Hoch | Hoch |

Geprüfte Bedrohungsklassen je Elementtyp (STRIDE pro Element):

| Elementtyp | S | T | R | I | D | E |
|---|:---:|:---:|:---:|:---:|:---:|:---:|
| Externer Akteur | ✓ | | ✓ | | | |
| Prozess | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Datenspeicher | | ✓ | (✓) | ✓ | ✓ | |
| Datenfluss | | ✓ | | ✓ | ✓ | |

## 6. STRIDE-Tabelle

### 6.1 Externe Akteure

| Nr. | Element | STRIDE | Bedrohung | W | S | Risiko | Gegenmaßnahme | Bezug |
|---|---|:---:|---|:---:|:---:|:---:|---|---|
| T-01 | A1 Sender | S | Ein Angreifer verschlüsselt eine eigene Datei für den Empfänger und gibt sich als Sender aus. Im Empfängermodus kann jeder mit dem öffentlichen Schlüssel verschlüsseln, im Passwortmodus jeder, der das Passwort kennt | Mittel | Hoch | **Hoch** | Kombinierte Signatur im eigenen Protokoll; Anzeige des Absenders beim Entschlüsseln. Bis zur Umsetzung Restrisiko | FA-08, NFA-05 |
| T-02 | A1 Sender | R | Der Sender bestreitet, eine Datei verschickt zu haben | Niedrig | Niedrig | Niedrig | Signatur liefert Nachweis der Urheberschaft | FA-08 |
| T-03 | A3 Empfänger | S | Ein Angreifer gibt sich als Empfänger aus und lässt den Sender für seinen Schlüssel verschlüsseln | Mittel | Hoch | **Hoch** | Siehe T-27 (Austausch des öffentlichen Schlüssels) | FA-36 |
| T-04 | A3 Empfänger | R | Der Empfänger bestreitet den Erhalt einer Datei | Niedrig | Niedrig | Niedrig | Nicht im Umfang; keine Empfangsbestätigung vorgesehen. Akzeptiert | – |
| T-05 | A2 Übertragungskanal | S | Der Kanal selbst ist nicht authentisch | – | – | – | Wird über die Datenflüsse F5/F6 behandelt (T-26, T-30 bis T-32) | – |
| T-06 | A4 Separater Kanal | S | Ein Angreifer gibt sich am Telefon als Sender oder Empfänger aus und übermittelt ein falsches Passwort oder einen falschen Schlüssel | Niedrig | Hoch | Mittel | Siehe T-27 und T-28; Hinweis in der Benutzerdokumentation, Gesprächspartner zu verifizieren | FA-36 |

### 6.2 Prozesse

| Nr. | Element | STRIDE | Bedrohung | W | S | Risiko | Gegenmaßnahme | Bezug |
|---|---|:---:|---|:---:|:---:|:---:|---|---|
| T-07 | P1, P2 Aegis | S | Ein Angreifer verbreitet eine manipulierte Aegis-Version, z. B. über einen gefälschten Download. Da der Programmcode nicht signiert ist, kann der Nutzer die Echtheit nicht über das Betriebssystem prüfen | Mittel | Hoch | **Hoch** | Bezug nur über das offizielle Repository; SHA-256-Prüfsummen und kostenfrei signierte Releases (z. B. mit minisign oder Sigstore) | RB-16, **neu: NFA-50** |
| T-08 | P1, P2 Aegis | T | Manipulation der installierten Programmdateien | – | – | – | Nur mit Zugriff auf das Gerät möglich; außerhalb des Umfangs (AN-01) | AN-01 |
| T-09 | P1, P2 Aegis | R | Abstreiten von Aktionen innerhalb der Anwendung | – | – | – | Nicht relevant: lokale Einzelplatzanwendung ohne Nutzerkonten | – |
| T-10 | P1, P2 Aegis | I | Passwörter, Schlüssel oder Klartext verbleiben nach Gebrauch im Arbeitsspeicher und gelangen in Auslagerungsdatei oder Absturzabbilder | Niedrig | Hoch | Mittel | Überschreiben sensibler Daten nach Gebrauch; keine Klartext-Zwischendateien. Auslagerung durch das Betriebssystem bleibt Restrisiko | NFA-08, NFA-09 |
| T-11 | P1, P2 Aegis | I | Fehlermeldungen oder Protokolle enthalten sensible Daten | Niedrig | Mittel | Niedrig | Keine Passwörter, Schlüssel, Inhalte oder Dateinamen in Protokollen | NFA-48 |
| T-12 | P1 Aegis (Sender) | I | Implementierungsfehler schwächen die Verschlüsselung, z. B. Wiederverwendung einer Nonce | Niedrig | Hoch | Mittel | Eigene Nonce je Block, Zufall aus dem Betriebssystem, eigene Testvektoren, Rundlauftests | NFA-01, NFA-06, NFA-11, NFA-30 |
| T-13 | P2 Aegis (Empfänger) | I | Unterscheidbare Fehlermeldungen (falsches Passwort gegenüber Manipulation) dienen als Orakel | Niedrig | Niedrig | Niedrig | Kein Online-Orakel, da lokale Anwendung; getrennte Meldungen sind für die Usability gewollt. Akzeptiert | FA-50 |
| T-14 | P2 Aegis (Empfänger) | I, T | Teile einer manipulierten oder abgeschnittenen Datei werden als Klartext ausgegeben, bevor die Integritätsprüfung abgeschlossen ist | Mittel | Hoch | **Hoch** | Ausgabe nur in temporäre Datei, Freigabe erst nach vollständiger Prüfung; bei Fehler wird die temporäre Datei verworfen | FA-53, NFA-02, NFA-09 |
| T-15 | P2 Aegis (Empfänger) | D | Eine präparierte Datei enthält extreme Parameter im Dateikopf (z. B. sehr hohe KDF-Kosten, riesige Headerlänge, sehr viele Empfänger) und blockiert Rechner oder Arbeitsspeicher | Mittel | Mittel | Mittel | Obergrenzen für alle Parameter aus dem Dateikopf; Fuzzing des Parsers | NFA-12, **neu: NFA-51** |
| T-16 | P1, P2 Aegis | D | Sehr große Dateien erschöpfen Arbeitsspeicher oder Speicherplatz | Niedrig | Mittel | Niedrig | RAM-Verbrauch unabhängig von der Dateigröße; Speicherplatzprüfung | NFA-23, FA-55 |
| T-17 | P2 Aegis (Empfänger) | E | Ein Speicherfehler beim Einlesen einer präparierten Datei führt zur Ausführung von Schadcode | Niedrig | Hoch | Mittel | Speichersichere Sprache Rust ohne `unsafe` im Parser; Fuzzing | RB-08, NFA-12 |
| T-18 | P1, P2 Aegis | E | Aegis läuft mit unnötig hohen Rechten, sodass ein Fehler größeren Schaden anrichtet | Niedrig | Hoch | Mittel | Aegis benötigt zur Laufzeit keine Administratorrechte; nur der Installer darf sie anfordern | RB-15, **neu: NFA-53** |

### 6.3 Datenspeicher

| Nr. | Element | STRIDE | Bedrohung | W | S | Risiko | Gegenmaßnahme | Bezug |
|---|---|:---:|---|:---:|:---:|:---:|---|---|
| T-19 | D1 Klartextdatei, D3 Entschlüsselte Datei | I | Die unverschlüsselte Datei bleibt nach dem Ver- bzw. Entschlüsseln auf dem Datenträger und ist bei Diebstahl des Geräts lesbar | Mittel | Hoch | **Hoch** | Optionales Löschen der Originaldatei; Empfehlung einer Festplattenverschlüsselung (BitLocker, LUKS) in der Benutzerdokumentation. Sicheres Überschreiben auf SSDs nicht zuverlässig möglich: Restrisiko | FA-17, FA-18 |
| T-20 | D3 Entschlüsselte Datei | T | Eine bestehende Datei gleichen Namens wird beim Entschlüsseln überschrieben | Mittel | Mittel | Mittel | Warnung vor dem Überschreiben, Auswahl der Umbenennung | FA-52 |
| T-21 | D2 Verschlüsselte Datei | I | Offline-Angriff auf ein schwaches Passwort durch Ausprobieren | Mittel | Hoch | **Hoch** | Argon2id mit hohen Kosten; Mindestanforderung und Vorschlag sicherer Passwörter | NFA-03, FA-25, FA-26 |
| T-22 | D2 Verschlüsselte Datei | I | Metadaten verraten Informationen: Dateiname, Dateigröße, Anzahl und Identität der Empfänger | Hoch | Niedrig | Mittel | Dateiname im Container verschlüsselt; keine Kennung des Empfängerschlüssels im Klartext-Dateikopf. Dateigröße bleibt sichtbar: Restrisiko | FA-46, **neu: NFA-52** |
| T-23 | D4 Private Schlüsseldatei | I | Die gestohlene Schlüsseldatei wird offline per Ausprobieren des Passworts geknackt | Mittel | Hoch | **Hoch** | Verschlüsselung mit Argon2id-abgeleitetem Schlüssel; Mindestanforderung an das Passwort | NFA-07, NFA-03, FA-25 |
| T-24 | D4 Private Schlüsseldatei | T | Die Schlüsseldatei wird manipuliert oder ausgetauscht | Niedrig | Hoch | Mittel | Authentifizierte Verschlüsselung der Schlüsseldatei erkennt Manipulation; Austausch erfordert Gerätezugriff (AN-01) | NFA-02, NFA-07 |
| T-25 | D4 Private Schlüsseldatei | D | Verlust der Schlüsseldatei (Defekt, Deinstallation, versehentliches Löschen) macht alle für den Empfänger verschlüsselten Dateien unlesbar | Mittel | Hoch | **Hoch** | Sicherung und Wiederherstellung des Schlüsselpaars; Warnungen vor dem Löschen und bei der Deinstallation | FA-39, FA-40, UC-02, UC-05, **neu: UC-10** |

### 6.4 Datenflüsse

| Nr. | Element | STRIDE | Bedrohung | W | S | Risiko | Gegenmaßnahme | Bezug |
|---|---|:---:|---|:---:|:---:|:---:|---|---|
| T-26 | F5/F6 Verschlüsselte Datei über A2 | T | Ein aktiver Angreifer verändert, vertauscht oder kürzt Blöcke der Datei | Mittel | Hoch | **Hoch** | Authentifizierter Dateikopf; Blöcke gegen Vertauschen, Löschen und Abschneiden geschützt | NFA-02 |
| T-27 | F7/F8 Öffentlicher Schlüssel (Empfängermodus) | T | Ein Angreifer ersetzt den öffentlichen Schlüssel des Empfängers durch seinen eigenen (Man-in-the-Middle) und kann danach alle Dateien lesen | Mittel | Hoch | **Hoch** | Sicherheitsnummer zum Vergleich über einen zweiten Weg; Markierung geprüfter Kontakte | FA-36 |
| T-28 | F7/F8 Passwort (Passwortmodus) | I | Der Sender schickt das Passwort über denselben Kanal wie die Datei, z. B. in derselben E-Mail | Hoch | Hoch | **Hoch** | Hinweis nach dem Verschlüsseln, das Passwort über einen anderen Weg zu übermitteln | **neu: FA-80** |
| T-29 | F7/F8 Passwort (Passwortmodus) | I | Der separate Kanal wird ebenfalls abgehört | Niedrig | Hoch | Mittel | Außerhalb des Einflusses von Aegis (AN-05); Restrisiko. Empfängermodus empfehlen, wenn die Kommunikation regelmäßig erfolgt | AN-05 |
| T-30 | F5/F6 Verschlüsselte Datei über A2 | I | Ein Angreifer speichert die Datei und entschlüsselt sie später mit einem Quantencomputer | Mittel | Hoch | **Hoch** | Hybrider Post-Quanten-Schlüsselaustausch im Empfängermodus; symmetrische Verfahren mit 256 Bit | NFA-04, NFA-01, RB-20 |
| T-31 | F5/F6 Verschlüsselte Datei über A2 | T | Ein Angreifer spielt eine ältere, gültige Datei erneut ein | Niedrig | Niedrig | Niedrig | Kein Schutz vorgesehen; Zeitstempel in der Signatur denkbar. Akzeptiert | FA-08 |
| T-32 | F5/F6 Verschlüsselte Datei über A2 | D | Der Übertragungskanal verliert oder blockiert die Datei | Niedrig | Mittel | Niedrig | Außerhalb des Einflusses von Aegis; Original bleibt beim Sender erhalten | FA-16 |
| T-33 | F1/F9 Lokale Passworteingabe | I | Das Passwort wird als Kommandozeilenparameter übergeben und landet in der Shell-Historie oder der Prozessliste | Mittel | Hoch | **Hoch** | Passwort nur interaktiv oder aus einer Datei, nie als Parameter | FA-59, FA-60 |
| T-34 | F11 Privater Schlüssel D4 ↔ P2 | I | Der entschlüsselte private Schlüssel verbleibt im Arbeitsspeicher | Niedrig | Hoch | Mittel | Überschreiben nach Gebrauch | NFA-08 |

## 7. Bedrohungen durch Fehlbedienung

STRIDE betrachtet Angreifer. Bei einem Werkzeug für Laien entsteht ein großer Teil des Risikos jedoch durch Fehlbedienung. Die folgenden Bedrohungen werden nach demselben Schema bewertet und vorrangig in den Usability-Tests geprüft.

| Nr. | Bedrohung | Betroffene Persona | W | S | Risiko | Gegenmaßnahme | Bezug |
|---|---|---|:---:|:---:|:---:|---|---|
| FB-01 | Die unverschlüsselte Originaldatei wird statt der verschlüsselten verschickt | Sabine Hoffmann | Mittel | Hoch | **Hoch** | Eindeutige Endung `.aegis`; Erfolgsmeldung nennt den vollständigen Pfad der verschlüsselten Datei | FA-13, FA-21, FA-48 |
| FB-02 | Die Datei wird für einen falschen Empfänger verschlüsselt | Sabine Hoffmann, Lea Yilmaz | Mittel | Hoch | **Hoch** | Anzeige der Empfänger nach dem Verschlüsseln; Kontakte mit selbst vergebenem Namen | UC-08, FA-35 |
| FB-03 | Das Passwort einer verschlüsselten Datei wird vergessen | Alle | Mittel | Hoch | **Hoch** | Hinweis auf Unwiderrufbarkeit; Passwortvorschlag mit Empfehlung eines Passwortmanagers; Originaldatei bleibt standardmäßig erhalten | FA-16, FA-26, FA-27 |
| FB-04 | Das Passwort des privaten Schlüssels wird vergessen; alle an den Nutzer gerichteten Dateien sind unlesbar | Gerhard Brandt, Lea Yilmaz | Mittel | Hoch | **Hoch** | Hinweis bei der Schlüsselerzeugung; eine Sicherung hilft hier nicht, da sie mit demselben Passwort geschützt ist. Restrisiko | UC-03, FA-27 |
| FB-05 | Ein schwaches oder mehrfach verwendetes Passwort wird gewählt | Lea Yilmaz | Hoch | Hoch | **Hoch** | Mindestanforderung, Stärkeanzeige, Passwortvorschlag | FA-24, FA-25, FA-26 |
| FB-06 | Das Passwort wird zusammen mit der Datei verschickt | Sabine Hoffmann | Hoch | Hoch | **Hoch** | Hinweis zur getrennten Übermittlung (T-28) | FA-80 |
| FB-07 | Die Warnung vor dem Löschen des Schlüsselpaars wird reflexhaft bestätigt | Lea Yilmaz | Mittel | Hoch | **Hoch** | Bestätigung durch Eingabe eines Wortes statt durch einfaches „j“ | FA-40, **neu: FA-81** |
| FB-08 | Eine manipulierte Datei wird für einen Passwortfehler gehalten, und der Nutzer probiert weiter | Gerhard Brandt | Mittel | Mittel | Mittel | Getrennte Meldungen mit Handlungsempfehlung | FA-50, FA-51 |
| FB-09 | Häufige Warnungen werden aus Gewohnheit ignoriert (Warnmüdigkeit) | Lea Yilmaz | Hoch | Mittel | **Hoch** | Warnungen nur an kritischen Stellen; kurze, eindeutige Texte | NFA-18 |
| FB-10 | Eine manipulierte Aegis-Version wird trotz Warnung des Betriebssystems installiert | Gerhard Brandt | Mittel | Hoch | **Hoch** | Bezug nur über das offizielle Repository; Anleitung zur Prüfung von Prüfsumme und Signatur (T-07) | NFA-50 |

## 8. Neu identifizierte Anforderungen

Die Analyse hat Bedrohungen aufgedeckt, für die es noch keine Anforderung gab. Vorschlag zur Ergänzung:

| Nr. | Bezeichnung | Erklärung | Gewichtung | Aus Bedrohung |
|---|---|---|:---:|---|
| FA-80 | Hinweis zur Passwortübermittlung | Nach dem Verschlüsseln mit Passwort wird empfohlen, das Passwort über einen anderen Weg als die Datei zu übermitteln | M | T-28 |
| UC-10 | Schlüsselpaar sichern und wiederherstellen | Eigener Use Case; FA-39 sollte von S auf M angehoben werden | M | T-25 |
| NFA-50 | Integrität der Releases | Jedes Release wird mit SHA-256-Prüfsummen und einer kostenfreien Signatur (z. B. minisign oder Sigstore) veröffentlicht | M | T-07 |
| NFA-51 | Obergrenzen für Dateikopf-Parameter | Alle Parameter aus dem Dateikopf (KDF-Kosten, Headerlänge, Anzahl der Empfänger) werden vor der Verarbeitung gegen feste Obergrenzen geprüft | M | T-15 |
| NFA-52 | Anonyme Empfänger | Der Dateikopf des eigenen Formats enthält keine Kennung, aus der sich der öffentliche Schlüssel eines Empfängers ableiten lässt | S | T-22 |
| NFA-53 | Ausführung ohne erhöhte Rechte | Aegis benötigt zur Laufzeit keine Administratorrechte | M | T-18 |
| FA-81 | Bestätigung durch Eingabe | Unwiderrufliche Aktionen wie das Löschen des Schlüsselpaars werden durch Eingabe eines Wortes bestätigt, nicht durch eine einfache Ja/Nein-Abfrage | S | FB-07 |

## 9. Verifikation der Gegenmaßnahmen

Für alle Bedrohungen mit hohem Risiko wird festgelegt, wie die Wirksamkeit der Gegenmaßnahme geprüft wird. Die Prüfungen dienen zugleich als Testfälle für die Implementierung.

| Nr. | Bedrohung | Prüfmethode | Erwartetes Ergebnis | Art |
|---|---|---|---|---|
| V-01 | T-26 Manipulation auf dem Übertragungsweg | Verschlüsselte Testdateien mit einzelnem veränderten Bit im Dateikopf, veränderten Blöcken, vertauschten Blöcken, entferntem Block und abgeschnittenem Ende entschlüsseln | Jeder Fall wird als Manipulation erkannt; es entsteht keine Ausgabedatei | Integrationstest |
| V-02 | T-14 Ausgabe ungeprüften Klartexts | Entschlüsselung einer am Ende manipulierten großen Datei abbrechen lassen und Zielverzeichnis prüfen | Keine Ausgabe- und keine temporäre Datei verbleibt | Integrationstest |
| V-03 | SZ-03 Herabstufung | Verfahrenskennung oder KDF-Parameter im Dateikopf verändern | Datei wird als manipuliert abgelehnt | Integrationstest |
| V-04 | T-15 Präparierte Dateiköpfe | Fuzzing des Parsers; Testdateien mit Parametern oberhalb der Obergrenzen | Kein Absturz, keine übermäßige Last; verständliche Ablehnung | Fuzzing, Integrationstest |
| V-05 | T-21, T-23 Passwortraten | KDF-Parameter aus erzeugten Dateien und der Schlüsseldatei auslesen; Liste bekannter schwacher Passwörter testen | Parameter entsprechen NFA-03; schwache Passwörter werden abgelehnt | Unit-Test |
| V-06 | T-30 Quantenangreifer | Prüfen, dass jede Datei im Empfängermodus beide Anteile des hybriden Verfahrens enthält; Abgleich mit Testvektoren | Hybrider Anteil vorhanden; Testvektoren stimmen überein | Unit-Test, Review |
| V-07 | T-27 Untergeschobener öffentlicher Schlüssel | Sicherheitsnummer für denselben Schlüssel auf zwei Rechnern erzeugen; für einen abweichenden Schlüssel erzeugen | Gleiche Schlüssel ergeben gleiche Nummern, abweichende Schlüssel unterschiedliche | Unit-Test |
| V-08 | T-33 Passwort in der Kommandozeile | Hilfe und Parameter der CLI prüfen; während der Eingabe Prozessliste und Shell-Historie prüfen | Kein Parameter für das Passwort; Passwort weder in Prozessliste noch in Historie | Review, manueller Test |
| V-09 | T-25 Verlust der Schlüsseldatei | Sicherung erstellen, Schlüsselpaar löschen, Sicherung wiederherstellen und eine ältere Datei entschlüsseln; Deinstallation durchführen | Entschlüsselung nach Wiederherstellung erfolgreich; Schlüssel bleiben bei Deinstallation standardmäßig erhalten | Integrationstest |
| V-10 | T-07, FB-10 Manipulierte Programmversion | Prüfsumme und Signatur eines Releases nach der Anleitung prüfen; Prüfung mit verändertem Archiv wiederholen | Echtes Release wird bestätigt, verändertes abgelehnt | Manueller Test |
| V-11 | T-28, FB-06 Passwort über denselben Kanal | Verschlüsselung im Passwortmodus durchführen | Hinweis zur getrennten Übermittlung erscheint | Usability-Test |
| V-12 | T-19 Klartext auf dem Datenträger | Benutzerdokumentation prüfen | Empfehlung zur Festplattenverschlüsselung ist enthalten | Review |
| V-13 | FB-01 bis FB-05, FB-07, FB-09 Fehlbedienung | Beobachtung von Testpersonen entsprechend den Personas | Fehlbedienungen treten nicht oder nur vereinzelt auf; beobachtete Fälle werden dokumentiert und behoben | Usability-Test |
| V-14 | T-01 Fehlende Absenderauthentizität | Signierte Datei mit verändertem Inhalt oder fremder Signatur prüfen (erst nach Umsetzung von FA-08) | Signaturprüfung schlägt fehl; Absender wird nicht als bestätigt angezeigt | Integrationstest |

## 10. Restrisiken

| Nr. | Restrisiko | Begründung |
|---|---|---|
| RR-01 | Fehlende Absenderauthentizität bis zur Umsetzung der Signatur | FA-08 ist mit S gewichtet; im Prototyp nicht enthalten (T-01) |
| RR-02 | Klartext verbleibt auf dem Datenträger | Liegt außerhalb der Kontrolle von Aegis; Empfehlung einer Festplattenverschlüsselung (T-19) |
| RR-03 | Dateigröße ist sichtbar | Auffüllen auf feste Größen wäre möglich, aber nicht vorgesehen (T-22) |
| RR-04 | Auslagerung sensibler Daten durch das Betriebssystem | Nicht vollständig durch die Anwendung verhinderbar (T-10) |
| RR-05 | Kompromittierte Endgeräte | Außerhalb des Umfangs (AN-01) |
| RR-06 | Gleichzeitig abgehörter separater Kanal | Außerhalb des Umfangs (AN-05, T-29) |
| RR-07 | Vergessene Passwörter führen zu Datenverlust | Bewusst keine Wiederherstellung, da jede Hintertür die Sicherheit schwächen würde (FB-03, FB-04) |

## 11. Fortschreibung

Das Bedrohungsmodell gilt für den CLI-Prototyp. Es wird fortgeschrieben, sobald neue Komponenten hinzukommen, insbesondere die grafische Oberfläche, das Kontextmenü, die Add-In-Schnittstelle mit Browser-Plugin oder Matrix sowie die optionale Accountverwaltung. Diese bringen neue Datenflüsse und Vertrauensgrenzen mit sich.

### Hinweis zur Verwendung von KI-Werkzeugen

| Eingesetztes KI-Werkzeug | Zweck / Art der Nutzung |
|---|---|
| Claude Opus 5.5 | Erstellung des Datenflussdiagramms auf Grundlage des Teamentwurfs; Ausarbeitung von Annahmen, Angreifermodellen und STRIDE-Analyse inklusive Bewertung, Gegenmaßnahmen und Zuordnung zu den Anforderungen; Formulierung der Sicherheitsziele, Analyse von Fehlbedienungen, Festlegung der Verifikation; Ableitung neuer Anforderungen und Restrisiken |