# Use Cases Aegis: CLI-Prototyp

Die folgenden Use Cases beschreiben die Abläufe des ersten Prototyps mit Kommandozeile. Sie beschränken sich auf Installation, Verwaltung eines asymmetrischen Schlüsselpaars sowie symmetrische (Passwort) und asymmetrische (Empfänger) Ver- und Entschlüsselung. Konkrete Befehlsnamen und Parameter werden erst im Entwurf der CLI festgelegt.

## Übersicht

| Nr. | Use Case | Akteur | Bezug zu Anforderungen |
|---|---|---|---|
| UC-01 | Aegis installieren | Nutzer | NFA-40, NFA-41, NFA-42, NFA-44, NFA-45 |
| UC-02 | Aegis deinstallieren | Nutzer | NFA-40 |
| UC-03 | Asymmetrisches Schlüsselpaar erzeugen | Nutzer | FA-29, FA-38, FA-57, NFA-03, NFA-07 |
| UC-04 | Öffentlichen Schlüssel exportieren | Nutzer | FA-30, FA-31, FA-57 |
| UC-05 | Asymmetrisches Schlüsselpaar löschen | Nutzer | FA-40, FA-57 |
| UC-06 | Datei symmetrisch verschlüsseln | Nutzer | FA-01, FA-13, FA-23, FA-25, FA-27, FA-52, FA-53, FA-56, FA-59, FA-80 |
| UC-07 | Datei symmetrisch entschlüsseln | Nutzer, Empfänger | FA-01, FA-07, FA-45, FA-50, FA-51, FA-53, FA-56, FA-59 |
| UC-08 | Datei asymmetrisch verschlüsseln | Nutzer | FA-02, FA-10, FA-13, FA-37, FA-52, FA-53, FA-56, NFA-04 |
| UC-09 | Datei asymmetrisch entschlüsseln | Empfänger | FA-02, FA-07, FA-45, FA-50, FA-51, FA-53, FA-56 |
| UC-10 | Schlüsselpaar sichern und wiederherstellen | Nutzer | FA-39, FA-57, NFA-07 |

Allgemeine Vorbedingung für UC-02 bis UC-10: Aegis ist installiert und über die Kommandozeile aufrufbar.

---

## UC-01: Aegis installieren

| Merkmal | Beschreibung |
|---|---|
| Akteur | Nutzer |
| Ziel | Aegis ist auf dem Rechner installiert und in der Kommandozeile aufrufbar |
| Vorbedingung | Windows 11 oder Fedora 44 auf x86_64; Installationspaket oder portable Version liegt vor |
| Auslöser | Nutzer möchte Aegis verwenden |

**Hauptablauf**
1. Der Nutzer startet den Installer.
2. Der Installer installiert Aegis und trägt das Programm in den Suchpfad (`PATH`) ein.
3. Der Installer meldet den erfolgreichen Abschluss.
4. Der Nutzer ruft Aegis in einer neuen Kommandozeile auf; Aegis zeigt Version und Kurzhilfe an.

**Alternativabläufe**
- 1a. Der Nutzer verwendet die portable Version: Er entpackt das Archiv und ruft Aegis direkt aus dem Ordner auf. Ein Eintrag im Suchpfad entfällt.
- 2a. Aegis ist bereits installiert: Der Installer bietet eine Aktualisierung an; vorhandene Schlüssel bleiben erhalten.
- 2b. Fehlende Berechtigungen: Der Installer fordert Administratorrechte an oder bricht mit einer verständlichen Meldung ab.

**Nachbedingung:** Aegis ist installiert und aufrufbar; es wurden noch keine Schlüssel erzeugt.

---

## UC-02: Aegis deinstallieren

| Merkmal | Beschreibung |
|---|---|
| Akteur | Nutzer |
| Ziel | Aegis ist vollständig vom Rechner entfernt |
| Vorbedingung | Aegis ist installiert |
| Auslöser | Nutzer möchte Aegis nicht mehr verwenden |

**Hauptablauf**
1. Der Nutzer startet die Deinstallation über das Betriebssystem bzw. den Paketmanager.
2. Die Deinstallation entfernt das Programm und den Eintrag im Suchpfad.
3. Die Deinstallation fragt, ob auch die gespeicherten Schlüssel gelöscht werden sollen; standardmäßig bleiben sie erhalten.
4. Die Deinstallation meldet den erfolgreichen Abschluss.

**Alternativabläufe**
- 3a. Der Nutzer wählt das Löschen der Schlüssel: Aegis warnt, dass damit verschlüsselte Dateien nicht mehr entschlüsselt werden können, und empfiehlt eine Sicherung. Erst nach erneuter Bestätigung werden die Schlüssel gelöscht.
- 1a. Portable Version: Der Nutzer löscht den Programmordner; die Schlüssel im Benutzerverzeichnis bleiben erhalten.

**Nachbedingung:** Das Programm ist entfernt; verschlüsselte Dateien bleiben unverändert erhalten.

---

## UC-03: Asymmetrisches Schlüsselpaar erzeugen

| Merkmal | Beschreibung |
|---|---|
| Akteur | Nutzer |
| Ziel | Der Nutzer besitzt ein eigenes Schlüsselpaar, um Dateien von anderen zu empfangen |
| Vorbedingung | Es existiert noch kein Schlüsselpaar |
| Auslöser | Nutzer möchte Dateien asymmetrisch empfangen können |

**Hauptablauf**
1. Der Nutzer ruft den Befehl zum Erzeugen eines Schlüsselpaars auf.
2. Aegis fordert ein Passwort zum Schutz des privaten Schlüssels an und lässt es bestätigen.
3. Aegis prüft die Passwortstärke.
4. Aegis erzeugt ein hybrides Schlüsselpaar (klassisch und ML-KEM).
5. Aegis speichert den privaten Schlüssel passwortgeschützt im Benutzerverzeichnis.
6. Aegis zeigt den öffentlichen Schlüssel als kopierbare Zeichenkette an und weist darauf hin, dass ein vergessenes Passwort nicht wiederherstellbar ist.

**Alternativabläufe**
- 1a. Es existiert bereits ein Schlüsselpaar: Aegis bricht ab und verweist auf UC-05, um das bestehende Paar zuvor zu löschen.
- 2a. Die Passwörter stimmen nicht überein: Aegis fordert die erneute Eingabe an.
- 3a. Das Passwort ist zu schwach: Aegis lehnt es mit Begründung ab und fordert ein neues an.

**Nachbedingung:** Ein passwortgeschütztes Schlüsselpaar ist gespeichert; der öffentliche Schlüssel kann weitergegeben werden.

---

## UC-04: Öffentlichen Schlüssel exportieren

| Merkmal | Beschreibung |
|---|---|
| Akteur | Nutzer |
| Ziel | Der Nutzer kann seinen öffentlichen Schlüssel an andere weitergeben |
| Vorbedingung | Ein Schlüsselpaar existiert (UC-03) |
| Auslöser | Eine andere Person möchte Dateien für den Nutzer verschlüsseln |

**Hauptablauf**
1. Der Nutzer ruft den Befehl zum Exportieren des öffentlichen Schlüssels auf.
2. Aegis gibt den öffentlichen Schlüssel als Zeichenkette auf der Standardausgabe aus.
3. Der Nutzer gibt die Zeichenkette an die andere Person weiter.

**Alternativabläufe**
- 1a. Der Nutzer gibt eine Zieldatei an: Aegis schreibt den öffentlichen Schlüssel in die Datei; vor dem Überschreiben einer bestehenden Datei wird gewarnt.
- 1b. Es existiert kein Schlüsselpaar: Aegis meldet dies und verweist auf UC-03.

**Nachbedingung:** Der öffentliche Schlüssel liegt als Zeichenkette oder Datei vor; der private Schlüssel wurde nicht ausgegeben.

---

## UC-05: Asymmetrisches Schlüsselpaar löschen

| Merkmal | Beschreibung |
|---|---|
| Akteur | Nutzer |
| Ziel | Das eigene Schlüsselpaar ist entfernt |
| Vorbedingung | Ein Schlüsselpaar existiert (UC-03) |
| Auslöser | Nutzer möchte das Schlüsselpaar ersetzen oder nicht mehr verwenden |

**Hauptablauf**
1. Der Nutzer ruft den Befehl zum Löschen des Schlüsselpaars auf.
2. Aegis warnt, dass Dateien, die für diesen Schlüssel verschlüsselt wurden, danach nicht mehr entschlüsselt werden können, und empfiehlt eine Sicherung (UC-10).
3. Aegis fordert eine ausdrückliche Bestätigung an.
4. Der Nutzer bestätigt.
5. Aegis löscht das Schlüsselpaar und meldet den Abschluss.

**Alternativabläufe**
- 4a. Der Nutzer bestätigt nicht: Aegis bricht ab, das Schlüsselpaar bleibt erhalten.
- 1a. Es existiert kein Schlüsselpaar: Aegis meldet dies und beendet den Vorgang.

**Nachbedingung:** Das Schlüsselpaar ist gelöscht; ein neues kann mit UC-03 erzeugt werden.

---

## UC-06: Datei symmetrisch verschlüsseln

| Merkmal | Beschreibung |
|---|---|
| Akteur | Nutzer |
| Ziel | Eine Datei ist mit einem Passwort verschlüsselt |
| Vorbedingung | Die zu verschlüsselnde Datei existiert |
| Auslöser | Nutzer möchte eine Datei mit einem Passwort schützen |

**Hauptablauf**
1. Der Nutzer ruft den Befehl zum Verschlüsseln mit der Eingabedatei und der Option für Passwortverschlüsselung auf.
2. Aegis fordert das Passwort interaktiv an und lässt es bestätigen.
3. Aegis prüft die Passwortstärke und weist darauf hin, dass ein vergessenes Passwort nicht wiederherstellbar ist.
4. Aegis leitet den Namen der Ausgabedatei automatisch ab (z. B. `datei.pdf.aegis`).
5. Aegis verschlüsselt die Datei in eine temporäre Datei und benennt sie nach Abschluss um.
6. Aegis meldet den Erfolg und den Pfad der Ausgabedatei und empfiehlt, das Passwort auf einem anderen Weg als die Datei zu übermitteln.

**Alternativabläufe**
- 1a. Die Eingabedatei existiert nicht: Aegis meldet dies mit Pfadangabe und beendet den Vorgang.
- 1b. Der Nutzer gibt einen eigenen Ausgabenamen an: Schritt 4 entfällt.
- 2a. Die Passwörter stimmen nicht überein: Aegis fordert die erneute Eingabe an.
- 3a. Das Passwort ist zu schwach: Aegis lehnt es mit Begründung ab.
- 4a. Die Ausgabedatei existiert bereits: Aegis fragt, ob überschrieben werden soll, und bricht sonst ab.
- 5a. Abbruch durch den Nutzer oder Fehler: Aegis entfernt die temporäre Datei; die Originaldatei bleibt unverändert.

**Nachbedingung:** Die verschlüsselte Datei liegt vor; die Originaldatei ist unverändert erhalten.

---

## UC-07: Datei symmetrisch entschlüsseln

| Merkmal | Beschreibung |
|---|---|
| Akteur | Nutzer oder Empfänger |
| Ziel | Der Inhalt einer passwortverschlüsselten Datei ist wiederhergestellt |
| Vorbedingung | Eine mit Passwort verschlüsselte Datei liegt vor; das Passwort ist bekannt |
| Auslöser | Nutzer möchte eine verschlüsselte Datei öffnen |

**Hauptablauf**
1. Der Nutzer ruft den Befehl zum Entschlüsseln mit der verschlüsselten Datei auf.
2. Aegis erkennt Format und Verschlüsselungsmodus am Dateikopf.
3. Aegis fordert das Passwort interaktiv an.
4. Aegis entschlüsselt die Datei in eine temporäre Datei und prüft dabei die Integrität.
5. Aegis stellt den Originalnamen wieder her (eigenes Format) bzw. leitet ihn ab (age), benennt die Datei um und meldet den Erfolg.

**Alternativabläufe**
- 2a. Die Datei ist keine von Aegis unterstützte Datei: Aegis meldet dies verständlich und beendet den Vorgang.
- 2b. Die Datei ist asymmetrisch verschlüsselt: Aegis wechselt zu UC-09.
- 4a. Das Passwort ist falsch: Aegis meldet ein falsches Passwort und bietet eine erneute Eingabe an.
- 4b. Die Datei wurde verändert oder ist beschädigt: Aegis meldet die Manipulation getrennt vom falschen Passwort, verwirft die temporäre Datei und empfiehlt, die Datei erneut anzufordern.
- 5a. Die Zieldatei existiert bereits: Aegis fragt, ob überschrieben werden soll, und bricht sonst ab.

**Nachbedingung:** Die entschlüsselte Datei liegt vor; bei einem Fehler entsteht keine Ausgabedatei.

---

## UC-08: Datei asymmetrisch verschlüsseln

| Merkmal | Beschreibung |
|---|---|
| Akteur | Nutzer |
| Ziel | Eine Datei ist so verschlüsselt, dass nur bestimmte Empfänger sie öffnen können |
| Vorbedingung | Die zu verschlüsselnde Datei existiert; der öffentliche Schlüssel mindestens eines Empfängers liegt vor (UC-04 beim Empfänger) |
| Auslöser | Nutzer möchte eine Datei sicher an eine andere Person übergeben |

**Hauptablauf**
1. Der Nutzer ruft den Befehl zum Verschlüsseln mit der Eingabedatei und dem öffentlichen Schlüssel des Empfängers als Zeichenkette oder Datei auf.
2. Aegis prüft, ob der öffentliche Schlüssel gültig ist.
3. Besitzt der Nutzer ein eigenes Schlüsselpaar, verschlüsselt Aegis zusätzlich für den eigenen öffentlichen Schlüssel.
4. Aegis leitet den Namen der Ausgabedatei automatisch ab.
5. Aegis verschlüsselt die Datei hybrid (klassisch und ML-KEM) in eine temporäre Datei und benennt sie nach Abschluss um.
6. Aegis meldet den Erfolg, den Pfad der Ausgabedatei und die Empfänger.

**Alternativabläufe**
- 1a. Der Nutzer gibt mehrere Empfänger an: Aegis verschlüsselt für alle angegebenen Schlüssel.
- 1b. Die Eingabedatei existiert nicht: Aegis meldet dies mit Pfadangabe.
- 2a. Der öffentliche Schlüssel ist ungültig oder unvollständig: Aegis meldet dies und empfiehlt, den Schlüssel erneut anzufordern.
- 3a. Der Nutzer schließt sich selbst über eine Option aus: Schritt 3 entfällt.
- 4a. Die Ausgabedatei existiert bereits: Aegis fragt, ob überschrieben werden soll.
- 5a. Abbruch oder Fehler: Aegis entfernt die temporäre Datei; die Originaldatei bleibt unverändert.

**Nachbedingung:** Die verschlüsselte Datei liegt vor und kann nur mit einem der zugehörigen privaten Schlüssel entschlüsselt werden.

---

## UC-09: Datei asymmetrisch entschlüsseln

| Merkmal | Beschreibung |
|---|---|
| Akteur | Empfänger |
| Ziel | Der Inhalt einer für den Empfänger verschlüsselten Datei ist wiederhergestellt |
| Vorbedingung | Der Empfänger besitzt ein Schlüsselpaar (UC-03); die Datei wurde für dessen öffentlichen Schlüssel verschlüsselt |
| Auslöser | Empfänger hat eine verschlüsselte Datei erhalten |

**Hauptablauf**
1. Der Empfänger ruft den Befehl zum Entschlüsseln mit der verschlüsselten Datei auf.
2. Aegis erkennt Format und Verschlüsselungsmodus am Dateikopf.
3. Aegis fordert das Passwort des privaten Schlüssels an.
4. Aegis entsperrt den privaten Schlüssel und entschlüsselt die Datei in eine temporäre Datei; dabei wird die Integrität geprüft.
5. Aegis stellt den Originalnamen wieder her, benennt die Datei um und meldet den Erfolg.

**Alternativabläufe**
- 2a. Die Datei ist mit Passwort verschlüsselt: Aegis wechselt zu UC-07.
- 3a. Der Empfänger besitzt kein Schlüsselpaar: Aegis meldet dies und verweist auf UC-03.
- 4a. Das Passwort des privaten Schlüssels ist falsch: Aegis meldet dies und bietet eine erneute Eingabe an.
- 4b. Die Datei wurde nicht für diesen Schlüssel verschlüsselt: Aegis meldet verständlich, dass die Datei für eine andere Person bestimmt ist, und empfiehlt, beim Absender nachzufragen.
- 4c. Die Datei wurde verändert oder ist beschädigt: Aegis meldet die Manipulation, verwirft die temporäre Datei und empfiehlt, die Datei erneut anzufordern.
- 5a. Die Zieldatei existiert bereits: Aegis fragt, ob überschrieben werden soll.

**Nachbedingung:** Die entschlüsselte Datei liegt vor; bei einem Fehler entsteht keine Ausgabedatei.

---

## UC-10: Schlüsselpaar sichern und wiederherstellen

| Merkmal | Beschreibung |
|---|---|
| Akteur | Nutzer |
| Ziel | Das eigene Schlüsselpaar ist gesichert und kann nach einem Verlust wiederhergestellt werden |
| Vorbedingung | Sichern: Ein Schlüsselpaar existiert (UC-03). Wiederherstellen: Eine Sicherung liegt vor |
| Auslöser | Nutzer möchte sich gegen den Verlust des Schlüsselpaars absichern oder hat es verloren |

**Hauptablauf**
1. Der Nutzer ruft den Befehl zum Sichern des Schlüsselpaars mit einer Zieldatei auf.
2. Aegis schreibt das Schlüsselpaar in die Zieldatei; der private Schlüssel bleibt dabei mit seinem Passwort geschützt.
3. Aegis meldet den Pfad der Sicherung und empfiehlt, sie getrennt vom Rechner aufzubewahren, z. B. auf einem USB-Stick.
4. Aegis weist darauf hin, dass die Sicherung mit demselben Passwort geschützt ist und bei vergessenem Passwort nicht hilft.

**Alternativabläufe**
- 1a. Es existiert kein Schlüsselpaar: Aegis meldet dies und verweist auf UC-03.
- 1b. Der Nutzer ruft den Befehl zum Wiederherstellen mit einer Sicherungsdatei auf: Aegis fordert das Passwort des privaten Schlüssels an, prüft damit die Sicherung, speichert das Schlüsselpaar im Benutzerverzeichnis und meldet den Abschluss.
- 1c. Beim Wiederherstellen existiert bereits ein Schlüsselpaar: Aegis bricht ab und verweist auf UC-05, um das bestehende Paar zuvor zu löschen.
- 1d. Beim Wiederherstellen ist das Passwort falsch oder die Sicherungsdatei beschädigt: Aegis meldet die Ursache getrennt und speichert nichts.
- 2a. Die Zieldatei existiert bereits: Aegis fragt, ob überschrieben werden soll, und bricht sonst ab.

**Nachbedingung:** Sichern: Eine passwortgeschützte Sicherung des Schlüsselpaars liegt vor; der private Schlüssel wurde nie unverschlüsselt ausgegeben. Wiederherstellen: Das Schlüsselpaar ist wieder verfügbar; zuvor dafür verschlüsselte Dateien lassen sich entschlüsseln.

### Hinweis zur Verwendung von KI-Werkzeugen

| Eingesetztes KI-Werkzeug | Zweck / Art der Nutzung |
|---|---|
| Claude Opus 5.5 | Ausarbeitung der vom Team festgelegten Use Cases für den CLI-Prototyp mit Haupt- und Alternativabläufen sowie Zuordnung der relevanten Anforderungen |
