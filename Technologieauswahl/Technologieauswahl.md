# Technologieauswahl

## Allgemeine Angaben

| Feld | Eintrag |
|---|---|
| Phase | 1 – Vorbereitung, Analyse & Anforderungsdefinition |
| Gegenstand | Rust-Crates, Werkzeuge und kryptografische Verfahren für Aegis |
| Stand der Versionsangaben | 05.11.2026 |
| Grundlage | Randbedingungen, funktionale und nicht-funktionale Anforderungen (Branch `Anforderungsanalyse`, Stand `7c2140c`); Bedrohungsmodell (Branch `Bedrohungsmodell`, Stand `4e654d2`); Crate-Liste aus Branch `code/v.0.1.0/cli` (`d4e3119`) |
| Status | Entwurf zur Abstimmung im Team |

---

## 1. Maßgebliche Vorgaben

Die Auswahl ist an die festgelegten Randbedingungen und Anforderungen gebunden. Für die Technologieauswahl sind vor allem diese maßgeblich:

| Nr. | Vorgabe (Kurzfassung) | Auswirkung auf die Auswahl |
|---|---|---|
| RB-06 | Rust stable, mindestens 1.99, über `rust-toolchain.toml` | Sprache und Toolchain sind gesetzt |
| RB-07 | Entwicklung unter Windows und Fedora, ohne Nix | Build-Abhängigkeiten müssen auf beiden Systemen ohne Nix installierbar sein |
| RB-09 | GUI mit Tauri und TypeScript | GUI-Framework ist gesetzt |
| RB-10 | Kryptokern als eigenständige Crate; getrennt von GUI, CLI und Add-In | Cargo-Workspace (Abschnitt 4.2) |
| RB-11, NFA-40 | Windows 11 und Fedora 44, jeweils x86_64 | Unter Windows wird NASM für aws-lc-rs benötigt (Abschnitt 5.1) |
| RB-16 | Keine Eigenimplementierung kryptografischer Primitive | Alle Primitive aus Bibliotheken |
| RB-17 | Kryptobibliotheken: `age` und `aws-lc-rs` | Argon2id fehlt in aws-lc-rs; Ergänzung nötig (Abschnitt 5.3) |
| RB-18 | Hybride Post-Quanten-Kryptografie für asymmetrische Verschlüsselung verpflichtend | Schränkt den age-Fallback ein (Abschnitt 4.1) |
| RB-19 | Eigenes Protokoll orientiert sich an BSI TR-02102; age-Format ausgenommen | Abgleich der Verfahren mit TR-02102-1 (Abschnitt 5.2) |
| RB-20 | Eigenes Format als Schwerpunkt, age als wählbarer Fallback | Zwei Formate (Abschnitt 4.1) |
| RB-23 | Add-In für Browser-Plugin oder Matrix | Anbindung als nativer Prozess (Abschnitt 4.3) |
| RB-24 | Unit-Tests, Fuzzing, `criterion`, UX-Stichproben | Testwerkzeuge (Abschnitt 9) |
| RB-27 | Repository unter MIT oder Apache-2.0; Lizenzen der Abhängigkeiten werden geprüft | `cargo deny` (Abschnitt 9) |
| NFA-01 | AES-256-GCM, blockweise mit eigener Nonce je Block | Symmetrisches Verfahren ist gesetzt |
| NFA-03 | Argon2id mit 1 GiB, 4 Durchläufen, 4 Threads; nicht abschwächbar | Parameter sind gesetzt; Parallelisierung nötig (NFA-25) |
| NFA-04 | Hybrid aus ML-KEM und klassischem Verfahren; Parametersatz und Kurve nach Abgleich mit TR-02102-1 | Abschnitt 5.2 |
| NFA-05 | Signatur hybrid aus ML-DSA-65 und Ed25519 (S) | Abschnitt 5.2 |
| NFA-23, NFA-24 | RAM unabhängig von der Dateigröße; höchstens KDF-Speicher plus 200 MB | Streaming mit begrenztem Puffer |
| NFA-45 | Nur Laufzeitabhängigkeiten, die der Installer mitbringt oder das System enthält | Statisch gelinkte C-Bibliotheken; Webview vom System (Abschnitt 8) |

## 2. Auswahlkriterien

| Nr. | Kriterium | Beschreibung |
|---|---|---|
| K1 | Sicherheit und Reife | Audits, Validierungen (z. B. FIPS 140-3), formale Verifikation, bekannte Schwachstellen |
| K2 | Funktionsabdeckung | Abdeckung der Verfahren aus NFA-01 bis NFA-05 |
| K3 | Wartung und Verbreitung | Aktive Entwicklung, Einsatz in relevanten Projekten |
| K4 | Plattform- und Build-Eignung | Windows 11 und Fedora 44 (x86_64), Bau ohne Nix, benötigte Build-Werkzeuge |
| K5 | Schutz vor Fehlgebrauch der API | Typsichere Schnittstellen, die falsche Verwendung erschweren |
| K6 | Lizenz | Permissive Lizenz, verträglich mit MIT bzw. Apache-2.0 (RB-27) |

---

## 3. Programmiersprache

Rust ist durch RB-06 gesetzt. Für die Arbeit relevant sind vor allem: Speichersicherheit ohne Garbage Collector, deterministisches Freigeben von Speicher (Voraussetzung für NFA-08) und ein Parser ohne `unsafe` (T-17). In `aegis-core` wird `#![forbid(unsafe_code)]` gesetzt; `unsafe` bleibt damit auf die Bibliotheken beschränkt. Verwendet wird Edition 2024.

---

## 4. Architekturentscheidungen mit Einfluss auf die Auswahl

### 4.1 Zwei Formate: Aegis-Format und age als Fallback

| Eigenschaft | Aegis-Format (Standard) | age (Fallback, FA-44) |
|---|---|---|
| Zweck | Post-Quanten-hybrides Format nach NFA-01 bis NFA-05 | Etabliertes Format ohne eigene Kryptoimplementierung im Datenpfad |
| Spezifikation | Eigene Spezifikation (Phase 2) | C2SP age v1 [SPEC-C2SP-AGE] |
| Unabhängige Prüfung | Keine im Rahmen der Arbeit | Öffentliche Spezifikation, Testvektoren (CCTV); Audit laut Konkurrenzanalyse nicht verifiziert |
| Kryptobibliothek | aws-lc-rs und argon2 | RustCrypto (intern im Crate `age`) |
| Passwortmodus | Argon2id (NFA-03) | scrypt (N = 2^18, r = 8, p = 1) |
| Empfängermodus | Hybrid aus klassischem Verfahren und ML-KEM (NFA-04) | Nur klassisch (X25519), siehe unten |
| Interoperabilität | Nur Aegis | age, rage, typage u. a. (NFA-32) |

**Begründung:** Der Fallback teilt keinen Kryptocode mit dem Aegis-Format. Ein Fehler in der eigenen Konstruktion betrifft ihn daher nicht. Dateien im age-Format bleiben außerdem mit Standardwerkzeugen entschlüsselbar, auch ohne Aegis. Der Preis sind zwei Kryptobibliotheken im Abhängigkeitsbaum und zwei Codepfade, die getestet werden müssen (NFA-30, NFA-32). Das wird bewusst in Kauf genommen.

**Einschränkungen des Fallbacks (Stand `age` 0.12.1):**

1. **Kein hybrider Empfängermodus – Konflikt mit RB-18.** Das Rust-Crate `age` unterstützt den in age v1.3 eingeführten hybriden Empfängertyp `mlkem768x25519` nicht. Als Post-Quanten-Typ gibt es nur `tagpq`, einen reinen Verschlüsselungstyp [DOC-AGE-RS], [CHANGELOG-AGE-RS]. Für das Crate existiert lediglich ein Community-Entwurf außerhalb des Projekts [ISSUE-RAGE-598]. Ein age-Empfängermodus wäre daher rein klassisch und widerspräche RB-18. **Vorschlag:** Der age-Fallback wird nur im Passwortmodus angeboten. Der Empfängermodus läuft immer im Aegis-Format. Das betrifft FA-44 (die Formatwahl wirkt nur im Passwortmodus) und NFA-32 (Interoperabilitätstests im Passwortmodus). Alternative: RB-18 wird für den Fallback ausdrücklich gelockert, analog zur Ausnahme in RB-19. Das muss das Team entscheiden (O1).
2. **Beta-Status der Rust-Implementierung:** Laut eigener Dokumentation sind alle Versionen vor 1.0 Beta-Versionen [DOC-AGE-RS]. Das Format selbst ist stabil und standardisiert. Gegenmaßnahmen: CCTV-Testvektoren und Kreuztests gegen die Go-Referenzimplementierung in der CI (NFA-32).
3. **Begrifflichkeit:** In der Arbeit wird der Fallback nicht als „100 % sicher“ bezeichnet, sondern als „etabliertes, öffentlich spezifiziertes und unabhängig implementiertes Format“.

Den Typ `mlkem768x25519` selbst über die `Recipient`-Schnittstelle des Crates nachzurüsten, wird verworfen: Damit gäbe es auch im Fallback wieder eigenen Kryptocode, und der Zweck des Fallbacks entfiele.

### 4.2 Aufteilung in einen Cargo-Workspace (RB-10, NFA-33)

| Crate | Art | Inhalt |
|---|---|---|
| `aegis-core` | Bibliothek | Containerformat, Schlüsselableitung, Hybrid-KEM, Streaming, Schlüssel- und Kontaktverwaltung, Anbindung des age-Fallbacks |
| `aegis-cli` | Programm | Kommandozeile (FA-56 bis FA-62) |
| `aegis-gui` | Programm | Tauri-Backend; Oberfläche in TypeScript (RB-09) |
| `aegis-addin` | Programm | Add-In-Schnittstelle und Prototyp (FA-68 bis FA-70) |

Regeln für `aegis-core`:

- keine Abhängigkeiten zu CLI- oder GUI-Crates (`clap`, `rpassword`, `anyhow`, `tauri`)
- typisierte Fehler über `thiserror`, damit jede Oberfläche eigene verständliche Meldungen ableiten kann (FA-50, FA-51)
- öffentliche Funktionen mit rustdoc und Beispiel (NFA-37)

Der Branch `code/v.0.1.0/cli` enthält derzeit ein einzelnes Paket `aegis`. Er wird beim nächsten Codeschritt auf diese Struktur umgestellt.

### 4.3 Anbindung des Add-Ins (RB-23)

aws-lc-rs unterstützt von den WebAssembly-Zielen nur `wasm32-unknown-emscripten`. `wasm32-unknown-unknown` fehlt, und genau dieses Ziel nutzen Browser-Erweiterungen über wasm-bindgen [DOC-AWSLC-PLATFORM]. Der Kryptokern kann daher nicht im Browser laufen.

**Festlegung:** `aegis-addin` ist ein nativer Prozess.

- **Browser-Plugin:** Native-Messaging-Host, Kommunikation per JSON über stdin/stdout. Der JavaScript-Teil enthält keine Kryptografie.
- **Matrix:** natives Rust-Programm, das sich als Client oder Bot anbindet. Das wird mit der Wahl des Kanals festgelegt.

| Vorteil | Nachteil |
|---|---|
| Schlüsselmaterial verlässt den Browser- bzw. Client-Prozess nicht | Native Komponente muss mitinstalliert und registriert werden |
| Derselbe Kern wie in CLI und GUI (NFA-33) | Plattformabhängige Registrierung des Native-Messaging-Hosts |

Eine reine WebAssembly-Variante würde ein zweites Krypto-Backend aus reinen Rust-Bibliotheken erfordern und widerspräche RB-17. Sie wird nur im Ausblick erwähnt.

---

## 5. Kryptografie

### 5.1 Kryptobibliothek des Aegis-Formats: aws-lc-rs

RB-17 legt aws-lc-rs fest. Der folgende Vergleich dokumentiert die Begründung für die Arbeit.

| Kriterium | aws-lc-rs | RustCrypto | libcrux | ring | openssl (Crate) |
|---|---|---|---|---|---|
| ML-KEM-768/1024 | ja | ja (`ml-kem` 0.3.4; laut eigener Angabe nie unabhängig auditiert [DOC-MLKEM-RC]) | ja, formal verifiziert | nach unserer Recherche keine ML-KEM-Schnittstelle | in OpenSSL ab 3.5; Abdeckung durch das Rust-Crate nicht geprüft |
| ML-DSA | ja, nur über Feature `unstable` [DOC-AWSLC-MLDSA] | ja | ja | nein | in OpenSSL ab 3.5 |
| Validierung/Verifikation | FIPS-140-3-validiertes Modul verfügbar, Teile von AWS-LC formal verifiziert | Audits einzelner Crates | formale Verifikation | keine FIPS-Validierung | FIPS-Provider abhängig von der Systeminstallation |
| Alle Primitive außer Argon2id aus einer Bibliothek | ja | ja, verteilt auf viele Einzel-Crates | weitgehend | nein | ja |
| Build-Voraussetzungen | C-Compiler, unter Windows x86_64 zusätzlich NASM | nur Rust | nur Rust | C-Compiler | Systembibliothek, unter Windows aufwendig |
| API | an ring angelehnt, typsicher | uneinheitlich über die Crates | teils maschinennah | typsicher | maschinennah |

**Entscheidung: aws-lc-rs**, Version 1.18.2. Die aktuelle Version 1.19.0 ist kompatibel und wird über den Versionsbereich automatisch genutzt.

Begründung:

- deckt `kem` (ML-KEM), `agreement` (X25519, P-256, P-384, P-521), `hkdf`, `hmac`, `aead` (AES-256-GCM), `signature` (Ed25519) und `rand` in einer Bibliothek ab
- AWS-LC ist FIPS-140-3-validiert, und Teile der Implementierung sind formal verifiziert. Den FIPS-Modus nutzt Aegis selbst nicht (er erfordert zusätzlich CMake und Go, und Argon2id ist kein FIPS-Verfahren). Aegis profitiert aber von derselben geprüften Codebasis.
- typsichere, an ring angelehnte API (K5), weit verbreitet (u. a. Standard-Backend von rustls)
- unter Fedora reicht für den Bau ein C-Compiler; CMake, Go und bindgen sind nicht nötig [DOC-AWSLC-PLATFORM]

Bekannte Einschränkungen:

| Nr. | Einschränkung | Umgang |
|---|---|---|
| E1 | Im Browser nicht als WebAssembly nutzbar | Add-In als nativer Prozess (Abschnitt 4.3) |
| E2 | Private ML-KEM-Schlüssel lassen sich nur über `key_bytes()` exportieren und über `new()` wieder laden. Ein geladener Schlüssel kann den öffentlichen Schlüssel nicht mehr ableiten, und ein Import aus dem 64-Byte-Seed ist nicht vorgesehen [DOC-AWSLC-KEM] | Die Schlüsseldatei (FA-38) speichert den öffentlichen Schlüssel mit. Zu Beginn von Phase 3 bestätigt ein kurzer Test, dass `key_bytes()` das erweiterte Format nach FIPS 203 liefert, sonst sind Schlüsseldatei und Sicherung (FA-39) an aws-lc-rs gebunden. Seed-basierte Speicherung [BLOG-MLKEM-SEEDS] wird neu bewertet, sobald aws-lc-rs sie anbietet |
| E3 | Windows x86_64 benötigt NASM; vorassemblierte Objekte nur über das Feature `prebuilt-nasm` [DOC-AWSLC-WIN] | Entwicklungsrechner: Visual Studio Build Tools und NASM; CI: NASM installieren oder `prebuilt-nasm` |
| E4 | ML-DSA nur über das Feature `unstable`, ohne Semver-Garantie [DOC-AWSLC-MLDSA] | Erst bei Umsetzung von FA-08 aktivieren; dann aws-lc-rs auf eine exakte Version festlegen |
| E5 | Keine Brainpool-Kurven | Relevant für den Abgleich mit TR-02102-1 (Abschnitt 5.2) |

### 5.2 Verfahren des Aegis-Formats

| Zweck | Verfahren | Bibliothek | Begründung / Bezug |
|---|---|---|---|
| Nutzdaten | AES-256-GCM in der STREAM-Konstruktion [PAPER-STREAM] | aws-lc-rs | NFA-01, NFA-02; Hardwarebeschleunigung auf der Referenzhardware (AES-NI/VAES). Die Nonce je Block wird deterministisch aus Blockzähler und Endmarkierung gebildet; je Datei wird ein frischer Schlüssel abgeleitet |
| Schlüsselaustausch, klassisch | X25519 [RFC-7748], vorbehaltlich O2 | aws-lc-rs | NFA-04; siehe Abgleich unten |
| Schlüsselaustausch, Post-Quanten | ML-KEM-768 [FIPS-203], vorbehaltlich O2 | aws-lc-rs | NFA-04, SZ-04, T-30 |
| Kombination beider Schlüssel | HKDF-SHA256 [RFC-5869] | aws-lc-rs | SZ-04; Aufbau nach X-Wing (siehe unten) |
| Header-Authentisierung | HMAC-SHA256 | aws-lc-rs | NFA-02, SZ-03. Bindet den Header an den Dateischlüssel; gleicht aus, dass AES-GCM den Schlüssel selbst nicht bindet (kein „key commitment“) |
| Passwortbasierte Schlüsselableitung | Argon2id [RFC-9106] | argon2 | NFA-03, NFA-07; Abschnitt 5.3 |
| Signatur (S) | ML-DSA-65 + Ed25519 | aws-lc-rs | FA-08, NFA-05; ML-DSA nur über `unstable` (E4) |
| Zufallszahlen | Zufallsquelle des Betriebssystems | aws-lc-rs (`SystemRandom`) | NFA-06 |

**Abgleich mit BSI TR-02102-1 (NFA-04, RB-19):** Maßgeblich ist TR-02102-1 in Version 2026-01 vom 23.01.2026 [BSI-TR-02102-1]. Das PDF konnte für diesen Entwurf nicht ausgewertet werden. Laut Sekundärquelle empfiehlt die Richtlinie ML-KEM-768 und ML-KEM-1024 sowie die hybride Schlüsseleinigung [SEK-BSI-PQC]. Ob Curve25519 bzw. X25519 als klassischer Anteil aufgeführt ist, bleibt offen. aws-lc-rs bietet X25519, P-256, P-384 und P-521, aber keine Brainpool-Kurven.

- **Vorläufige Festlegung:** X25519 + ML-KEM-768. Dieselbe Kombination nutzen X-Wing, age (`mlkem768x25519`) und TLS (`X25519MLKEM768`). Sie hat kompakte klassische Schlüssel und weit verbreitete zeitkonstante Implementierungen.
- **Ausweichregel:** Führt TR-02102-1 Curve25519 nicht auf, wird P-256 + ML-KEM-768 verwendet (analog `SecP256r1MLKEM768`), bei angestrebtem höherem Sicherheitsniveau P-384 + ML-KEM-1024 (analog `SecP384r1MLKEM1024`). Beides ist ohne weitere Bibliothek mit aws-lc-rs umsetzbar.
- Im selben Schritt werden Argon2id, HKDF und AES-GCM gegen die Richtlinie geprüft (O2). HKDF entspricht dem zweistufigen Ableitungsverfahren nach NIST SP 800-56C.

**Anforderungen an die Kombination (Detaillierung in Phase 2):** Der Combiner folgt dem Aufbau von X-Wing [DRAFT-XWING]. In die HKDF-Ableitung gehen ein: beide Shared Secrets, der ML-KEM-Ciphertext, der ephemere klassische Schlüssel, der klassische Schlüssel des Empfängers und ein festes Label zur Domänentrennung. Die Schlüssel des Empfängers gehen nur in die Ableitung ein und stehen nicht im Header (NFA-52). X-Wing verwendet SHA3-256; die Abweichung zu HKDF-SHA256 wird in der Spezifikation begründet.

**Hinweis zur Nonce:** NFA-01 verlangt eine eigene Nonce je Block. Die STREAM-Konstruktion erfüllt das mit einer aus dem Blockzähler abgeleiteten Nonce; erst dadurch werden Vertauschen und Abschneiden erkannt (NFA-02). Die Formulierung „Eigener Zufallswert je Block“ in T-12 des Bedrohungsmodells sollte entsprechend angepasst werden.

### 5.3 Passwortbasierte Schlüsselableitung: argon2

| Alternative | Bewertung |
|---|---|
| **argon2 (RustCrypto)** | **Gewählt**, Version 0.6.0. Reiner Rust-Code; Features `zeroize` und `parallel` verfügbar [DOC-ARGON2]. Nötig, weil aws-lc-rs kein Argon2 enthält |
| scrypt | Von age genutzt; erfüllt NFA-03 nicht |
| PBKDF2 | Nicht speicherhart, anfällig für GPU-Angriffe; erfüllt NFA-03 nicht |
| Bindings an die C-Referenzimplementierung | Zusätzliche C-Abhängigkeit ohne Mehrwert |

- **Parameter:** m = 1 GiB, t = 4, p = 4 (NFA-03), für Dateien und die private Schlüsseldatei (NFA-07).
- **Parallelisierung:** Das Feature `parallel` berechnet die vier Lanes parallel. Ohne Parallelisierung ist NFA-25 (höchstens 2 s) auf der Referenzhardware voraussichtlich nicht einzuhalten. Die Messung erfolgt in Phase 3.
- **Speicherbudget:** Die 1 GiB der Schlüsselableitung bilden den Grundbedarf aus NFA-24.
- **Header-Parameter:** Die Parameter stehen authentisiert im Header (SZ-03). Beim Entschlüsseln werden nur Werte innerhalb fester Grenzen akzeptiert (NFA-51, T-15).
- **Folge für RB-17:** argon2 ist neben `age` und `aws-lc-rs` eine dritte Kryptobibliothek. RB-17 und Annahme AN-03 des Bedrohungsmodells sollten um `argon2` (RustCrypto) ergänzt werden (O3).

### 5.4 Fallback: age

Version 0.12.1 mit Feature `armor` für die Textdarstellung. Die Features `ssh` und `plugin` werden nicht aktiviert: Hardware-Token sind nicht Teil der Arbeit (FA-78), und so bleibt die Angriffsfläche klein. Fehlermeldungen von age werden in verständliche Texte übersetzt (FA-50). Einschränkungen siehe Abschnitt 4.1.

### 5.5 Geheimnisse im Arbeitsspeicher

| Crate | Version | Zweck | Bezug |
|---|---|---|---|
| secrecy | 0.10.3 | Typen `SecretBox` und `SecretString`: Zugriff nur explizit über `expose_secret()`, keine Ausgabe in Debug-Ausgaben oder Protokollen | NFA-08, NFA-48 |
| zeroize | 1.9.1 | Überschreiben eigener Puffer und Strukturen beim Freigeben (`Zeroize`, `ZeroizeOnDrop` per Derive) | NFA-08, T-10, T-34 |
| rpassword | 7.5.4 | Passworteingabe im Terminal ohne Echo; nur in `aegis-cli` | FA-59, T-33 |

`zeroize` arbeitet nach dem Best-Effort-Prinzip. Kopien durch Verschieben, Reallokation, Auslagerung oder Absturzabbilder werden nicht erfasst; das entspricht Restrisiko RR-04. Schlüssel innerhalb von aws-lc-rs verwaltet AWS-LC selbst. Beides wird in der Speicheranalyse (Phase 5) geprüft.

---

## 6. Datenformat, Dateien und Kodierung

| Crate | Version | Zweck | Bezug |
|---|---|---|---|
| winnow | 1.0.4 | Parser für den Dateikopf | FA-07, FA-49, NFA-12, NFA-51, T-15, T-17 |
| base64 | 0.23.1 | Textdarstellung verschlüsselter Daten | FA-06, FA-68 |
| bech32 | 0.12.0 | Öffentliche Schlüssel als Zeichenkette mit Prüfsumme | FA-30, FA-33 |
| tempfile | 3.27.0 | Ausgabe in temporäre Datei, Umbenennen erst nach Abschluss | FA-19, FA-53, NFA-09, NFA-29 |
| serde (Feature `derive`), serde_json | 1.0.229, 1.0.154 | Einstellungen, Kontaktliste, JSON-Ausgabe der CLI, Nachrichten der Add-In-Schnittstelle | FA-35, FA-44, FA-62, FA-68 |
| tar | 0.4.46 | Ordner als gemeinsamer Container | FA-05 (S) |
| zstd | 0.14.3 | Optionale Kompression, Feature `compression` | keine Anforderung, siehe unten |

**winnow:** Der Dateikopf ist nicht vertrauenswürdige Eingabe (AM-5). Mit Parser-Kombinatoren lässt er sich in kleine, einzeln testbare Funktionen ohne `unsafe` zerlegen. Fehlerstellen werden genau gemeldet, was für verständliche Meldungen (FA-50) wichtig ist. Obergrenzen werden während des Parsens geprüft (NFA-51). Verworfen: nom (winnow ist ein aktiv weiterentwickelter Fork von nom mit überarbeiteter API), deklarative Binär-Crates wie binrw (weniger Kontrolle über Fehlerfälle) und manuelles Parsen (fehleranfällig).

**base64:** Für die Text-Verschlüsselung (FA-06) und die Add-In-Schnittstelle (FA-68). Im Fallback übernimmt `age` die Armor-Darstellung. `base64` arbeitet nicht in konstanter Zeit und wird nur für öffentliche Daten und Chiffrate genutzt.

**bech32:** Öffentliche Schlüssel als kopierbare Zeichenkette mit Prüfsumme; Tippfehler beim Einfügen (FA-33) werden erkannt. Ein hybrider öffentlicher Schlüssel aus X25519 und ML-KEM-768 umfasst 32 + 1.184 = 1.216 Byte, also rund 1.950 Bech32-Zeichen. Die Standard-Prüfsummen `Bech32` und `Bech32m` sind nur bis 1.023 Zeichen definiert, und das Crate verweigert längere Kodierungen mit `EncodeError::TooLong` [SRC-BECH32]. Lösungsweg: ein eigener `Checksum`-Typ mit demselben Generatorpolynom und erhöhter Codelänge. Oberhalb von 1.023 Zeichen gelten die Garantien zur Fehlererkennung nur eingeschränkt. Da sich eine Zeichenkette dieser Länge kaum von Hand prüfen lässt, sind Export als Datei (FA-31), QR-Code (FA-32) und Sicherheitsnummer (FA-36) die eigentlichen Austausch- und Prüfwege. Festlegung in Phase 2 (O5).

**tempfile:** `NamedTempFile` im Zielverzeichnis, `persist_noclobber()` nach erfolgreicher Integritätsprüfung (FA-52, FA-53). Ein festes Namenspräfix ermöglicht es, verbliebene temporäre Dateien beim nächsten Start zu erkennen (NFA-29).

**serde/serde_json:** JSON ist das Austauschformat der Add-In-Schnittstelle (Native Messaging) und der CLI-Ausgabe. Einstellungen und Kontaktliste werden ebenfalls als JSON gespeichert. Tauri setzt serde ohnehin voraus.

**tar:** Für FA-05 wird der Ordner vor der Verschlüsselung als tar-Archiv gestreamt. Beim Entpacken werden Pfade auf das Zielverzeichnis begrenzt (Schutz vor Path Traversal durch präparierte Dateien, AM-5).

**zstd:** Keine Anforderung verlangt Kompression. Wird sie eingesetzt, hängt die Größe der verschlüsselten Datei vom Inhalt ab; das geht über NZ-03 hinaus und ermöglicht bei Nachrichten mit teilweise angreiferkontrolliertem Inhalt Angriffe nach dem Muster von CRIME/BREACH. Daher gilt: Kompression ist optional und standardmäßig aus, im Add-In nie aktiv, und ob komprimiert wurde, steht im authentisierten Header. Gegen Dekompressionsbomben wird die Ausgabegröße begrenzt (NFA-51). Ob zstd im Umfang der Arbeit bleibt, entscheidet das Team (O6).

**Passwortprüfung und -vorschlag:**

| Crate | Version | Zweck | Bezug |
|---|---|---|---|
| zxcvbn | 3.1.1 | Schätzung der Passwortstärke für Anzeige und Mindestanforderung | FA-24, FA-25, FB-05 |

zxcvbn bewertet Passwörter anhand von Mustern und Wörterbüchern; die mitgelieferten Wörterbücher sind englischsprachig, deutsche Wörter erkennt es daher schlechter. Der Passwortvorschlag (FA-26) braucht keine weitere Crate: Wörter werden mit `SystemRandom` gleichverteilt (Rejection Sampling) aus einer eingebetteten Wortliste gezogen. Wortliste und Lizenz werden bei der Umsetzung festgelegt (O7).

---

## 7. Parallelisierung: rayon

Version 1.12.0. Zwei Einsatzzwecke:

1. Parallele Argon2-Lanes über `argon2/parallel` (NFA-03, NFA-25).
2. Paralleles Ver- und Entschlüsseln der Blöcke. Die Blöcke der STREAM-Konstruktion sind voneinander unabhängig. Verarbeitet wird in Fenstern mit fester Blockanzahl, damit der Speicherbedarf konstant bleibt (NFA-23, NFA-24) und die Geschwindigkeit mindestens der von age entspricht (NFA-22).

Die Verarbeitung läuft außerhalb des UI-Threads, damit die Oberfläche bedienbar bleibt (NFA-27). Verworfen: manuelles Thread-Management (mehr Code, gleiche Wirkung) und async-Laufzeiten wie tokio für die Kryptoarbeit (für rechenintensive Aufgaben ungeeignet).

---

## 8. Anwendungsschicht

| Crate | Version | Verwendung | Begründung / Bezug |
|---|---|---|---|
| clap (Feature `derive`) | 4.6.7 | `aegis-cli` | FA-56 bis FA-62; Hilfe mit Beispielen für typische Aufgaben (FA-61) |
| anyhow | 1.0.104 | nur Programme | Einfache Fehlerweitergabe bis zur Oberfläche; im Kern ungeeignet, da die Fehlerart verloren geht |
| thiserror | 2.0.21 | `aegis-core` | Typisierte Fehler; jede Fehlerart wird auf eine verständliche Meldung mit Handlungsempfehlung abgebildet (FA-50, FA-51, NFA-17) |
| time (Features `formatting`, `parsing`) | 0.3.55 | `aegis-core` | Erstellungsdatum in Schlüsseldatei und Kontaktliste. **Nicht** im Containerheader (Metadaten sparsam halten, G-05). Verworfen: chrono (funktional gleichwertig, kein Vorteil hier) |
| tauri | 2.12.5 | `aegis-gui` | RB-09. Das Rust-Backend ruft `aegis-core` über Tauri-Commands auf; die Oberfläche (TypeScript) enthält keine Kryptografie |

**Laufzeitabhängigkeiten der GUI (NFA-45):** Tauri nutzt die Webview des Betriebssystems, unter Windows 11 WebView2 (Systembestandteil) und unter Fedora WebKitGTK (als Paketabhängigkeit des Installers). aws-lc und libzstd werden statisch gelinkt.

**Sprachen (FA-71, RB-29):** Die Übersetzung der Oberfläche erfolgt im TypeScript-Frontend. Die Auswahl der Bibliothek für die Internationalisierung gehört zu Phase 4.

---

## 9. Qualitätssicherung

| Werkzeug | Version | Zweck | Bezug |
|---|---|---|---|
| criterion | 0.8.2 (dev) | Durchsatzmessung, Vergleich mit age und weiteren Werkzeugen | RB-24, NFA-22, NFA-25 |
| proptest | 1.12.0 (dev) | Property-basierte Tests: Rundlauf beliebiger Eingaben; Erkennung von Abschneiden, Vertauschen und Manipulation | NFA-30, V-01 |
| cargo-fuzz | – | Fuzzing von Header-Parser und Entschlüsselung (benötigt eine Nightly-Toolchain) | RB-24, NFA-12, V-04 |
| cargo-audit, cargo-deny | – | Sicherheitsmeldungen, Lizenzen, doppelte Abhängigkeiten in der CI | NFA-10, RB-27 |
| cargo-llvm-cov | – | Messung der Testabdeckung im Kryptokern | NFA-34 |
| rustfmt, clippy | Toolchain | Formatierung (verpflichtend) und statische Analyse | RB-25, NFA-35, NFA-36 |
| age (Go-Referenzimplementierung) | aktuelle Version | Kreuztests in beide Richtungen in der CI | NFA-32 |

Testvektoren: CCTV für den age-Fallback, eigene Vektoren für das Aegis-Format (NFA-11). Die Korrektheit der einzelnen Primitive prüfen die Bibliotheken selbst mit ihren Testsuiten.

---

## 10. Build-Umgebung und CI

- **Toolchain:** `rust-toolchain.toml` mit stabiler Toolchain ab 1.99 (RB-06); für cargo-fuzz zusätzlich Nightly. Kein Nix (RB-07).
- **Fedora 44:** C-Compiler für `aws-lc-sys` und `zstd-sys`; Entwicklungspakete von WebKitGTK für Tauri.
- **Windows 11:** Visual Studio Build Tools, NASM (E3), WebView2.
- **CI (RB-08, NFA-39):** GitHub Actions mit Windows- und Linux-Runnern: Build, Tests, `rustfmt --check`, `clippy`, `cargo audit`, `cargo deny` und die age-Kreuztests bei jedem Pull Request.
- **Reproduzierbarkeit:** `Cargo.lock` wird versioniert.
- **Releases (NFA-50):** SHA-256-Prüfsummen und Signatur mit minisign oder Sigstore. Die Auswahl erfolgt mit dem ersten Release.

---

## 11. Ergebnis

### 11.1 Abhängigkeiten je Crate

| Crate | Abhängigkeiten | Optional |
|---|---|---|
| `aegis-core` | aws-lc-rs, argon2, age, secrecy, zeroize, thiserror, winnow, base64, bech32, tempfile, serde, serde_json, tar, zxcvbn, time, rayon | zstd (`compression`) |
| `aegis-cli` | aegis-core, clap, anyhow, rpassword, secrecy, serde_json | – |
| `aegis-gui` | aegis-core, tauri, anyhow, serde, serde_json | – |
| `aegis-addin` | aegis-core, anyhow, serde, serde_json | – |
| Entwicklung | criterion, proptest | – |

### 11.2 Workspace-Abhängigkeiten

```toml
[workspace]
resolver = "3"
members = ["crates/aegis-core", "crates/aegis-cli"]

[workspace.package]
edition = "2024"
rust-version = "1.99"

[workspace.dependencies]
aws-lc-rs = "1.18.2"
argon2 = { version = "0.6.0", default-features = false, features = ["alloc", "zeroize", "parallel"] }
age = { version = "0.12.1", features = ["armor"] }
secrecy = "0.10.3"
zeroize = { version = "1.9.1", features = ["derive"] }
thiserror = "2.0.21"
winnow = "1.0.4"
base64 = "0.23.1"
bech32 = "0.12.0"
tempfile = "3.27.0"
serde = { version = "1.0.229", features = ["derive"] }
serde_json = "1.0.154"
tar = "0.4.46"
zxcvbn = "3.1.1"
zstd = "0.14.3"
rayon = "1.12.0"
time = { version = "0.3.55", features = ["formatting", "parsing"] }
clap = { version = "4.6.7", features = ["derive"] }
anyhow = "1.0.104"
rpassword = "7.5.4"
tauri = "2.12.5"
criterion = "0.8.2"
proptest = "1.12.0"
```

Gegenüber der Crate-Liste im Branch `code/v.0.1.0/cli` hinzugekommen: `zeroize`, `thiserror`, `tempfile`, `serde`, `serde_json`, `tar`, `zxcvbn`, `tauri`, `criterion` und `proptest`.

---

## 12. Offene Punkte

| Nr. | Punkt | Betrifft | Klärung |
|---|---|---|---|
| O1 | age-Fallback nur im Passwortmodus anbieten oder RB-18 für den Fallback lockern | RB-18, FA-44, NFA-32 | Teamentscheidung vor Phase 2 |
| O2 | TR-02102-1 (2026-01) im Original prüfen: klassische Kurve, ML-KEM-Parametersatz, Argon2id, HKDF, AES-GCM; danach NFA-04 konkretisieren | NFA-04, RB-19 | vor Abschluss der Spezifikation |
| O3 | RB-17 und AN-03 um `argon2` (RustCrypto) ergänzen | RB-17, AN-03 | Teamentscheidung |
| O4 | Format der ML-KEM-Schlüssel aus `key_bytes()` per kurzem Test bestätigen (E2) | FA-38, FA-39 | Phase 3, zu Beginn |
| O5 | Bech32-Variante für lange hybride Schlüssel festlegen | FA-30, FA-33 | Phase 2 |
| O6 | Kompression (zstd) im Umfang behalten oder streichen | NZ-03 | Teamentscheidung |
| O7 | Wortliste für den Passwortvorschlag (Deutsch/Englisch) und deren Lizenz | FA-26, RB-27 | bei Umsetzung |
| O8 | Unterstützung von `mlkem768x25519` im Crate `age` beobachten [ISSUE-RAGE-598] | O1 | laufend |
| O9 | Add-In-Kanal (Browser-Plugin oder Matrix) festlegen | RB-23, FA-69 | Entwurf der Add-In-Schnittstelle |
| O10 | Formulierung von T-12 im Bedrohungsmodell an die zählerbasierte Nonce anpassen (Abschnitt 5.2) | T-12 | Bedrohungsmodell |

---

### Hinweis zur Verwendung von KI-Werkzeugen

| Eingesetztes KI-Werkzeug | Zweck / Art der Nutzung |
|---|---|
| Claude Opus 5.5 | Recherche zu Versionen, Plattformunterstützung und Einschränkungen der vom Team ausgewählten Crates; Abgleich mit Randbedingungen, Anforderungen und Bedrohungsmodell; Ableitung ergänzender Crates aus den Anforderungen; Erstellung des Dokumententwurfs |

### Quellen

| ID | Typ | Urheber / Projekt | Titel / Ressource | Stand / URL |
|---|---|---|---|---|
| **[BSI-TR-02102-1]** | Technische Richtlinie | BSI | *TR-02102-1: Kryptographische Verfahren: Empfehlungen und Schlüssellängen*, Version 2026-01 | `https://www.bsi.bund.de/SharedDocs/Downloads/DE/BSI/Publikationen/TechnischeRichtlinien/TR02102/BSI-TR-02102.html` |
| **[SEK-BSI-PQC]** | Sekundärquelle | DuoKey | *Germany Post-Quantum Cryptography Regulation: What BSI TR-02102 Actually Requires* | `https://duokey.com/en/resources/germany-post-quantum-cryptography-regulation-bsi-tr-02102` |
| **[DOC-AWSLC-PLATFORM]** | Dokumentation | Amazon Web Services | *AWS Libcrypto for Rust User Guide: Platform Support* | `https://aws.github.io/aws-lc-rs/platform_support.html` |
| **[DOC-AWSLC-WIN]** | Dokumentation | Amazon Web Services | *AWS Libcrypto for Rust User Guide: Windows* | `https://aws.github.io/aws-lc-rs/requirements/windows.html` |
| **[DOC-AWSLC-KEM]** | API-Dokumentation | Amazon Web Services | *aws_lc_rs::kem::DecapsulationKey* | `https://docs.rs/aws-lc-rs/latest/aws_lc_rs/kem/struct.DecapsulationKey.html` |
| **[DOC-AWSLC-MLDSA]** | API-Dokumentation | Amazon Web Services | *aws_lc_rs::unstable::signature* | `https://docs.rs/aws-lc-rs/latest/aws_lc_rs/unstable/signature/index.html` |
| **[DOC-AGE-RS]** | API-Dokumentation | str4d (Jack Grigg) | *age 0.12.1* | `https://docs.rs/age/latest/age/` |
| **[CHANGELOG-AGE-RS]** | Changelog | str4d (Jack Grigg) | *age/CHANGELOG.md* | `https://github.com/str4d/rage/blob/main/age/CHANGELOG.md` |
| **[ISSUE-RAGE-598]** | Issue | rage-Projekt | *Entwurf eines Post-Quanten-Empfängers (X-Wing) für age/rage* | `https://github.com/str4d/rage/issues/598` |
| **[SPEC-C2SP-AGE]** | Spezifikation (C2SP) | C2SP / Filippo Valsorda | *The age encryption format (v1)* | `https://github.com/C2SP/C2SP/blob/main/age.md` |
| **[DOC-MLKEM-RC]** | API-Dokumentation | RustCrypto | *ml-kem 0.3.4* | `https://docs.rs/crate/ml-kem/latest` |
| **[DOC-ARGON2]** | API-Dokumentation | RustCrypto | *argon2 0.6.0: Feature flags* | `https://docs.rs/crate/argon2/0.6.0/features` |
| **[SRC-BECH32]** | Quellcode | rust-bitcoin | *bech32 0.12.0, src/lib.rs* | `https://docs.rs/crate/bech32/latest/source/src/lib.rs` |
| **[BLOG-MLKEM-SEEDS]** | Fachartikel | Filippo Valsorda | *Let's All Agree to Use Seeds as ML-KEM Keys* | `https://words.filippo.io/ml-kem-seeds/` |
| **[DRAFT-XWING]** | Internet-Draft | Connolly, Schwabe, Westerbaan | *X-Wing: general-purpose hybrid post-quantum KEM* | `https://datatracker.ietf.org/doc/draft-connolly-cfrg-xwing-kem/` |
| **[PAPER-STREAM]** | Fachartikel | Hoang, Reyhanitabar, Rogaway, Vizár | *Online Authenticated-Encryption and its Nonce-Reuse Misuse-Resistance* (CRYPTO 2015) | `https://eprint.iacr.org/2015/189` |
| **[FIPS-203]** | Standard | NIST | *FIPS 203: Module-Lattice-Based Key-Encapsulation Mechanism Standard* | `https://csrc.nist.gov/pubs/fips/203/final` |
| **[RFC-9106]** | Standard | IRTF | *RFC 9106: Argon2 Memory-Hard Function* | `https://www.rfc-editor.org/rfc/rfc9106` |
| **[RFC-7748]** | Standard | IRTF | *RFC 7748: Elliptic Curves for Security* | `https://www.rfc-editor.org/rfc/rfc7748` |
| **[RFC-5869]** | Standard | IETF | *RFC 5869: HMAC-based Extract-and-Expand Key Derivation Function (HKDF)* | `https://www.rfc-editor.org/rfc/rfc5869` |
