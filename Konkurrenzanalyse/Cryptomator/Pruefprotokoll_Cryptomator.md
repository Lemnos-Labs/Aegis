# Steckbrief Konkurrenzanalyse (Honorable Mention)

## Allgemeine Angaben

| Feld | Eintrag |
|---|---|
| Tool | Cryptomator |
| Version | 1.19.3 |
| Art der Analyse | Dokumentenanalyse, kein Praxistest |
| Datum | 07.10.2026 |
| Verfasser | Oliver Decker |

## Begründung der Aufnahme

Cryptomator wird nicht in der Nutzwertanalyse bewertet, da es ein abweichendes Konzept verfolgt. Es wird dennoch betrachtet, weil es zeigt, wie Verschlüsselung für Laien im Alltag nahezu unsichtbar werden kann, und weil eine Tresor-Funktion als mögliche Erweiterung von Aegis in Betracht kommt.

## Abgrenzung

| Merkmal | Aegis und Hauptkandidaten | Cryptomator |
|---|---|---|
| Einheit der Verschlüsselung | Einzelne Datei | Tresor mit vielen Dateien |
| Bedienung | Datei auswählen, verschlüsseln | Tresor entsperren und als virtuelles Laufwerk einbinden, danach normal mit den Dateien arbeiten |
| Weitergabe an Dritte | Verschlüsselte Datei versenden | Tresor über Cloud-Speicher teilen, Passwort separat weitergeben |
| Public-Key-Modus | Vorhanden oder geplant | Nicht vorhanden; Mehrbenutzerzugriff nur über den kostenpflichtigen Cryptomator Hub |
| Hauptanwendungsfall | Dateiaustausch | Schutz von Cloud-Speicher |

## Steckbrief

| Bereich | Merkmal | Beschreibung |
|---|---|---|
| Konzept | Funktionsweise | Ein Tresor ist ein Ordner, meist im Cloud-Speicher. Nach dem Entsperren wird er als virtuelles Laufwerk eingebunden; Dateien werden beim Speichern automatisch verschlüsselt und beim Öffnen entschlüsselt |
| Konzept | Verschlüsselungseinheit | Jede Datei im Tresor wird einzeln verschlüsselt. Bei Änderungen muss nur die betroffene Datei neu synchronisiert werden |
| Kryptografie | Passwort-KDF | scrypt (Kostenparameter N = 32768, Blockgröße r = 8) erzeugt einen Schlüssel zum Entschlüsseln der Masterkeys |
| Kryptografie | Schlüsselverwaltung | Zufällige Masterkeys, mit AES Key Wrap (RFC 3394) geschützt in einer Datei im Tresor gespeichert. Eine Passwortänderung erfordert daher keine Neuverschlüsselung der Dateien |
| Kryptografie | Dateiinhalte | AES-256-GCM in Blöcken (Tresorformat 8, Modus `SIV_GCM`) |
| Kryptografie | Dateinamen und Struktur | Dateinamen mit AES-SIV verschlüsselt; Ordnerstruktur wird verschleiert |
| Kryptografie | Sichtbare Metadaten | Anzahl der Dateien, ungefähre Dateigrößen und Änderungszeitpunkte bleiben für den Cloud-Anbieter erkennbar |
| Post-Quanten | Tresor | Nach Angabe des Herstellers bereits quantensicher, da nur symmetrische Verfahren mit 256-Bit-Schlüsseln verwendet werden |
| Post-Quanten | Cryptomator Hub | Derzeit ECDH auf P-384. Geplant ist ein hybrides Verfahren auf Basis von X-Wing (X25519 + ML-KEM-768); noch kein Termin |
| Audits | Durchgeführt | Cure53 (Kryptobibliotheken, Bericht vom 27.11.2017); Tim McLean (SIV-Implementierung, 2016) |
| Plattformen | Unterstützung | Windows, macOS, Linux; Android und iOS als kostenpflichtige Apps |
| Lizenz | Desktop-Anwendung | GPLv3 |
| Entwicklung | Ausblick | Gemeinsames „Unified Vault Format“ mit Cyberduck, gocryptfs und rclone in Arbeit; soll Schlüsselrotation und den Wechsel von Algorithmen ermöglichen |

## Erkenntnisse für Aegis

| Nr. | Beobachtung | Übertragbar auf Aegis? | Begründung |
|---|---|---|---|
| 1 | Nach dem einmaligen Entsperren arbeitet man ganz normal mit den Dateien; die Verschlüsselung ist im Alltag unsichtbar | ja, als spätere Erweiterung | Höchste denkbare Benutzerfreundlichkeit. Ein virtuelles Laufwerk erfordert aber zusätzliche Treiber (z. B. WinFsp unter Windows, FUSE unter Linux) und erhöht den Aufwand deutlich; daher nicht für die erste Version |
| 2 | Jede Datei im Tresor wird einzeln verschlüsselt | ja | Ein Aegis-Tresor könnte jede Datei als eigenen Aegis-Container speichern. So wird der bestehende Kryptokern wiederverwendet und der Tresor bleibt synchronisationsfreundlich |
| 3 | Dateinamen und Ordnerstruktur werden mitverschlüsselt | ja | Auch bei Einzeldateien verrät der Dateiname oft den Inhalt. Aegis sollte den Originalnamen im verschlüsselten Container speichern und beim Entschlüsseln wiederherstellen |
| 4 | Passwort schützt nur die Masterkeys, nicht die Dateien direkt | ja | Ermöglicht Passwortänderungen ohne Neuverschlüsselung aller Dateien. Für einen Aegis-Tresor das passende Schlüsselmodell |
| 5 | Mehrbenutzerzugriff über Hub mit individuellem Schlüssel je Nutzer; Entzug von Rechten erst mit Schlüsselrotation möglich | ja, als Hinweis | Zeigt, dass das Teilen von Tresoren dieselben Fragen aufwirft wie die geplante E2E-Erweiterung von Aegis: Verteilung von Schlüsseln an mehrere Empfänger und Widerruf von Zugriffsrechten |
| 6 | Für den Post-Quanten-Schlüsselaustausch im Hub ist X-Wing geplant | ja | X-Wing kombiniert X25519 und ML-KEM-768 als standardisiertes hybrides KEM und entspricht damit der für Aegis geplanten Kombination. Statt eines eigenen Kombinierers über HKDF-SHA256 sollte X-Wing als Alternative geprüft werden |
| 7 | Anzahl, Größe und Zeitpunkte der Dateien bleiben sichtbar | ja | Gehört als bekannte Grenze in das Bedrohungsmodell eines möglichen Aegis-Tresors |

### Hinweis zur Verwendung von KI-Werkzeugen

| Eingesetztes KI-Werkzeug | Zweck / Art der Nutzung |
|---|---|
| Claude Opus 5.5 | Erstellung der Gliederung, Recherche und Zusammenfassung der Dokumentation, Ableitung der Erkenntnisse für Aegis |

### Ergänzende Quellen

| ID | Typ | Urheber / Projekt | Titel / Ressource | Stand / URL |
|---|---|---|---|---|
| **[DOC-CRYPTO-ARCH]** | Dokumentation | Skymatic GmbH | *Cryptomator: Security Architecture* | `https://docs.cryptomator.org/security/architecture/` |
| **[BLOG-CRYPTO-PQ]** | Blogbeitrag | Skymatic GmbH | *Our Roadmap to Post-Quantum Cryptography* | 24.07.2025<br>`https://cryptomator.org/blog/2025/07/24/post-quantum-roadmap/` |
| **[FORUM-CRYPTO-AUDIT]** | Forumsbeitrag | Cryptomator Community | *Has there been a security review / audit of Cryptomator?* | `https://community.cryptomator.org/t/has-there-been-a-security-review-audit-of-cryptomator/44` |
| **[REPO-CRYPTO]** | GitHub-Repository | Skymatic GmbH | *cryptomator/cryptomator* | `https://github.com/cryptomator/cryptomator` |
