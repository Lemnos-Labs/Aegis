# Funktionale Anforderungen Aegis

Funktionale Anforderungen beschreiben, was Aegis leisten soll. Die Gewichtung folgt der MoSCoW-Methode:

| Gewichtung | Bedeutung |
|---|---|
| **M** (Must) | Zwingend erforderlich; ohne diese Anforderung gilt das Projekt als nicht erfüllt |
| **S** (Should) | Wichtig, wird umgesetzt, sofern die Zeit es zulässt |
| **C** (Could) | Wünschenswert, wird nur bei freien Kapazitäten umgesetzt |
| **W** (Won't) | Bewusst nicht Teil dieser Arbeit; dient der Abgrenzung des Umfangs |

| Nr. | Bezeichnung | Erklärung | Gewichtung |
|---|---|---|:---:|
| FA-01 | Passwortverschlüsselung | Dateien können mit einem Passwort ver- und entschlüsselt werden | M |
| FA-02 | Empfängerverschlüsselung | Dateien können mit dem öffentlichen Schlüssel einer anderen Person ver- und mit dem eigenen privaten Schlüssel entschlüsselt werden | M |
| FA-03 | Einzelne Datei | Eine einzelne Datei kann ver- und entschlüsselt werden | M |
| FA-04 | Mehrere Dateien | Mehrere Dateien können in einem Vorgang verarbeitet werden; jede wird einzeln verschlüsselt | S |
| FA-05 | Ordner | Ein Ordner kann als ein gemeinsamer Container verschlüsselt werden | S |
| FA-06 | Text | Text aus der Zwischenablage kann in der Oberfläche ver- und entschlüsselt werden | C |
| FA-07 | Automatische Modus-Erkennung | Aegis erkennt am Dateikopf, ob eine Datei ver- oder entschlüsselt werden muss | M |
| FA-08 | Signatur | Das eigene Protokoll signiert verschlüsselte Dateien; beim Entschlüsseln wird die Signatur geprüft und der Absender angezeigt | S |
| FA-09 | Eigenständiges Signieren | Signieren ohne Verschlüsselung | W |
| FA-10 | Für mich verschlüsseln | Beim Verschlüsseln für andere wird standardmäßig auch für den eigenen Schlüssel verschlüsselt; abwählbar | M |
| FA-11 | Dateiauswahl | Dateien können per Drag-and-Drop und über einen Dateiauswahldialog gewählt werden | M |
| FA-12 | Anzeige der gewählten Datei | Name, Größe und Symbol der gewählten Datei bleiben bis zum Abschluss sichtbar | M |
| FA-13 | Automatischer Ausgabename | Der Name der Ausgabedatei wird automatisch abgeleitet (z. B. `datei.pdf.aegis`) und ist vor dem Start änderbar | M |
| FA-14 | Speicherort | Die Ausgabedatei wird standardmäßig neben der Originaldatei gespeichert | M |
| FA-15 | Abweichender Speicherort | Ein anderer Ausgabeordner kann gewählt werden | S |
| FA-16 | Originaldatei erhalten | Die Originaldatei bleibt nach dem Verschlüsseln erhalten | M |
| FA-17 | Originaldatei löschen | Die Originaldatei kann nach ausdrücklicher Nachfrage gelöscht werden | C |
| FA-18 | Sicheres Überschreiben | Sicheres Überschreiben der Originaldatei; auf SSDs nicht zuverlässig umsetzbar | W |
| FA-19 | Fortschritt und Abbruch | Fortschrittsbalken während des Vorgangs; Abbrechen jederzeit möglich, ohne Restdateien | M |
| FA-20 | Restzeit | Anzeige der geschätzten Restzeit | C |
| FA-21 | Erfolgsmeldung | Nach Abschluss erscheint eine Erfolgsmeldung mit der Ausgabedatei | M |
| FA-22 | Ordner öffnen | Schaltfläche, die den Ordner der Ausgabedatei öffnet | S |
| FA-23 | Passwortbestätigung | Beim Verschlüsseln muss das Passwort zweimal eingegeben werden | M |
| FA-24 | Passwortstärke | Deutliche, farbige Anzeige der Passwortstärke mit kurzer Erklärung in Worten | M |
| FA-25 | Mindestanforderung an Passwörter | Zu schwache Passwörter werden blockiert, schwache mit einer Warnung versehen | S |
| FA-26 | Passwortvorschlag | Aegis schlägt eine zufällige Passphrase aus Wörtern vor | S |
| FA-27 | Hinweis auf Unwiderrufbarkeit | Vor dem Verschlüsseln wird deutlich darauf hingewiesen, dass ein vergessenes Passwort nicht wiederherstellbar ist | M |
| FA-28 | Schlüsseldatei als zweiter Faktor | Zusätzlich zum Passwort kann eine Schlüsseldatei verlangt werden (Multi-Faktor) | C |
| FA-29 | Schlüsselpaar erzeugen | Bei der ersten Nutzung des Empfänger-Modus wird die Erzeugung eines Schlüsselpaars mit einem Klick angeboten | M |
| FA-30 | Öffentlichen Schlüssel teilen | Der eigene öffentliche Schlüssel kann als Zeichenkette kopiert werden | M |
| FA-31 | Schlüssel als Datei exportieren | Der eigene öffentliche Schlüssel kann als Datei exportiert werden | S |
| FA-32 | QR-Code | Der eigene öffentliche Schlüssel kann als QR-Code angezeigt werden | C |
| FA-33 | Schlüssel einfügen | Fremde Schlüssel können aus der Zwischenablage hinzugefügt werden | M |
| FA-34 | Schlüssel importieren | Fremde Schlüssel können aus einer Datei importiert werden | S |
| FA-35 | Kontaktliste | Fremde Schlüssel werden als Kontakte mit selbst vergebenem Namen verwaltet, ohne Fachbegriffe | M |
| FA-36 | Sicherheitsnummer | Zur Prüfung der Echtheit wird eine kurze Sicherheitsnummer angezeigt; Kontakte können als „überprüft“ markiert werden | S |
| FA-37 | Mehrere Empfänger | Eine Datei kann für mehrere Empfänger gleichzeitig verschlüsselt werden | S |
| FA-38 | Speicherung des privaten Schlüssels | Der private Schlüssel wird als passwortgeschützte Datei gespeichert | M |
| FA-39 | Schlüsselsicherung | Der private Schlüssel kann als Sicherungskopie exportiert und wiederhergestellt werden | S |
| FA-40 | Löschen | Kontakte und eigene Schlüssel können gelöscht werden | M |
| FA-41 | Schlüssel ersetzen | Der eigene Schlüssel kann durch einen neuen ersetzt werden | S |
| FA-42 | Widerruf | Widerruf von Schlüsseln gegenüber anderen; ohne Server nicht verteilbar | W |
| FA-43 | Ablaufdatum | Ablaufdaten für Schlüssel | W |
| FA-44 | Formatwahl | In den Einstellungen kann zwischen dem eigenen Format (Standard) und age als Fallback gewählt werden | M |
| FA-45 | Entschlüsseln beider Formate | Beide Formate werden unabhängig von der Einstellung erkannt und entschlüsselt | M |
| FA-46 | Verschlüsselte Dateinamen | Im eigenen Format wird der Originalname mitverschlüsselt und beim Entschlüsseln wiederhergestellt | M |
| FA-47 | Unverschlüsselte Notiz | Im eigenen Format kann eine lesbare Notiz, z. B. eine Anleitung für Empfänger, angehängt werden; mit deutlichem Hinweis | C |
| FA-48 | Dateiendungen | `.aegis` für das eigene Format, `.age` für das Fallback-Format | M |
| FA-49 | Formatversion | Die Formatversion steht im Dateikopf | M |
| FA-50 | Getrennte Fehlermeldungen | Falsches Passwort und manipulierte Datei werden getrennt gemeldet, soweit das Format es zulässt; Meldungen von age werden in verständliche Texte übersetzt | M |
| FA-51 | Handlungsempfehlung | Jede Fehlermeldung enthält einen konkreten nächsten Schritt | M |
| FA-52 | Überschreibschutz | Vor dem Überschreiben bestehender Dateien wird gewarnt; Auswahl zwischen Überschreiben und automatischer Umbenennung | M |
| FA-53 | Keine Restdateien | Ausgabe zunächst in eine temporäre Datei, die erst nach Abschluss umbenannt wird | M |
| FA-54 | Schutz vor Doppelverschlüsselung | Bereits verschlüsselte Dateien werden entschlüsselt statt erneut verschlüsselt; Doppelverschlüsselung nur über erweiterte Option | S |
| FA-55 | Speicherplatzprüfung | Vor dem Start wird geprüft, ob genug Speicherplatz vorhanden ist | C |
| FA-56 | CLI: Ver- und Entschlüsseln | Die CLI unterstützt Ver- und Entschlüsseln in beiden Modi | M |
| FA-57 | CLI: Schlüsselverwaltung | Die CLI kann Schlüssel erzeugen und Kontakte verwalten | S |
| FA-58 | CLI: Pipes | Ein- und Ausgabe über Pipes | S |
| FA-59 | CLI: Passworteingabe | Passwörter werden interaktiv eingegeben und nie als Parameter übergeben | M |
| FA-60 | CLI: Passwort aus Datei | Für Skripte kann das Passwort aus einer Datei gelesen werden | S |
| FA-61 | CLI: Hilfe | Kurze Hilfe mit Beispielen für die häufigsten Aufgaben | M |
| FA-62 | CLI: Maschinenlesbare Ausgabe | Ausgabe im JSON-Format für Skripte (`--json`) | C |
| FA-63 | Kontextmenü Windows | Ver- und Entschlüsseln über das Kontextmenü im Windows-Explorer | S |
| FA-64 | Kontextmenü Linux | Ver- und Entschlüsseln über das Kontextmenü gängiger Linux-Dateimanager | C |
| FA-65 | Dateizuordnung | Aegis registriert sich als Standardprogramm für `.aegis` und optional `.age` | S |
| FA-66 | Startargument | Dateipfade können beim Start als Argument übergeben werden | M |
| FA-67 | Infobereich | Betrieb im Infobereich der Taskleiste | W |
| FA-68 | Add-In-Schnittstelle | Schnittstelle zum Ver- und Entschlüsseln von Text sowie zum Abfragen von Kontakten und öffentlichen Schlüsseln | M |
| FA-69 | Add-In-Prototyp | Prototyp für ein Browser-Plugin oder Matrix; Nachrichten werden per Knopfdruck verschlüsselt | S |
| FA-70 | Erkennung verschlüsselter Nachrichten | Der Prototyp erkennt verschlüsselte Nachrichten und bietet eine Schaltfläche zum Entschlüsseln | S |
| FA-71 | Sprachwahl | Sprache automatisch nach Systemsprache, manuell änderbar; Deutsch und Englisch | M |
| FA-72 | Erweiterte Optionen | Erweiterte Optionen in einem einklappbaren Bereich „Erweitert“ mit Erklärung je Option | M |
| FA-73 | Einführung | Kurzer, überspringbarer Einführungsdialog beim ersten Start | S |
| FA-74 | Hilfetexte | Kurze Hilfetexte an Ort und Stelle | S |
| FA-75 | Heller und dunkler Modus | Die Oberfläche folgt der Systemeinstellung | C |
| FA-76 | Accountverwaltung | Schnittstelle zu einer Accountverwaltung, z. B. für den Austausch öffentlicher Schlüssel, ohne eigenen Server | C |
| FA-77 | Tresor | Ordner mit automatischer Verschlüsselung; nur konzeptionell im Ausblick | W |
| FA-78 | Hardware-Token | Unterstützung von YubiKey, TPM oder Smartcards | W |
| FA-79 | Updateprüfung | Automatische Suche nach Updates | W |

### Hinweis zur Verwendung von KI-Werkzeugen

| Eingesetztes KI-Werkzeug | Zweck / Art der Nutzung |
|---|---|
| Claude Opus 5.5 | Erstellung des Fragebogens zur Festlegung der funktionalen Anforderungen; Vorschlag der Antworten und der Gewichtung nach MoSCoW auf Grundlage der Teamentscheidungen und der Konkurrenzanalyse; Überführung in die vorliegende Tabelle |
