# Personas Aegis

Personas sind fiktive Stellvertreter der Zielgruppen von Aegis. Sie dienen als Bezugspunkt für Designentscheidungen und als Grundlage für die Auswahl der Tester in den Usability-Tests. Die primären Personas nutzen Aegis aktiv. Die sekundären Persona empfangen lediglich mit Aegis verschlüsselte Dateien.

## Übersicht

| Persona | Rolle | Technisches Vorwissen | Hauptsächlicher Zugang | Priorität für Usability-Tests |
|---|---|---|---|:---:|
| Maria Meier | Primär | Gering | Grafische Oberfläche, Kontextmenü | Hoch |
| Klaus Müller | Sekundär | Gering | Doppelklick auf erhaltene Datei | Hoch |
| Lea Fischer | Primär | IT-kenntnisse, ohne Sicherheitswissen | Grafische Oberfläche, Browser-Add-In | Mittel |
| Johan Krüger | Primär | Hoch | Kommandozeile | Gering |

---

## Persona 1: Maria Meier, die Bürofachkraft

| Merkmal | Beschreibung |
|---|---|
| Alter | 46 Jahre |
| Beruf | Sachbearbeiterin in der Lohnbuchhaltung |
| Technisches Vorwissen | Gering; sicher im Umgang mit Outlook, Word, Excel, aber keine Kenntnisse über Verschlüsselung |
| Geräte | Office-Laptop mit Windows 11 |
| Nutzungskontext | Bekommt Aegis von der IT-Abteilung installiert, mit der Vorgabe, Lohnabrechnungen und Personalunterlagen nur noch verschlüsselt per E-Mail zu schicken |
| Nutzungshäufigkeit | Mehrmals pro Woche |

**Ziele**
- Sensible Dokumente schnell und ohne Umwege verschlüsseln
- Sicher sein, dass sie alles richtig gemacht hat
- Den Arbeitsablauf möglichst wenig ändern

**Hürden**
- Fachbegriffe verunsichern sie
- Angst, versehentlich Daten zu löschen oder unverschlüsselt zu verschicken
- Unverständliche Fehlermeldungen ohne Hinweis, was zu tun ist

**Erwartungen an Aegis**
- Verschlüsseln direkt per Rechtsklick auf die Datei
- Klare Bestätigung, dass die Datei verschlüsselt wurde und wo sie liegt
- Eindeutige Warnung, bevor etwas Unwiderrufliches passiert

**Relevante Anforderungen:** FA-01, FA-11, FA-12, FA-13, FA-16, FA-21, FA-27, FA-50, FA-51, FA-52, FA-63, NFA-13, NFA-17, NFA-18

---

## Persona 2: Klaus Müller, Empfänger (sekundär)

| Merkmal | Beschreibung |
|---|---|
| Alter | 61 Jahre |
| Beruf | Inhaber einer kleinen Kanzlei, Geschäftspartner von Maria Meier |
| Technisches Vorwissen | Gering; nutzt E-Mail und PDF-Reader |
| Geräte | Office-PC mit Windows 11 |
| Nutzungskontext | Erhält von seinen Mandanten Dateien, die mit einem Passwort verschlüsselt sind, und das Passwort getrennt, z. B. telefonisch. Ein eigenes Schlüsselpaar besitzt er nicht. |
| Nutzungshäufigkeit | Unregelmäßig, je nach Mandant |

**Ziele**
- Die erhaltene Datei mit möglichst wenig Aufwand öffnen
- Keine zusätzliche Software verstehen müssen, die er nur selten braucht

**Hürden**
- Weiß nicht, was eine `.aegis`-Datei ist und welches Programm er braucht

**Erwartungen an Aegis**
- Eine kurze, verständliche Anleitung direkt bei der Datei
- Schnelle Installation ohne Einrichtung
- Öffnen der Datei per Doppelklick

**Relevante Anforderungen:** FA-07, FA-45, FA-47, FA-50, FA-51, FA-65, NFA-41, NFA-44

---

## Persona 3: Lea Fischer, die technikaffine Studentin

| Merkmal | Beschreibung |
|---|---|
| Alter | 22 Jahre |
| Beruf | Studentin, arbeitet nebenbei in einer Beratungsstelle |
| Technisches Vorwissen | Mittel; probiert gerne neue Apps aus, hat aber kein Wissen über Kryptografie oder sichere Passwörter |
| Geräte | Privater Laptop mit Windows 11, Smartphone |
| Nutzungskontext | Möchte Ausweisdokumente, Bewerbungsunterlagen und Notizen aus der Beratungsstelle schützen und vertrauliche Nachrichten verschlüsselt verschicken |
| Nutzungshäufigkeit | Gelegentlich, dafür spontan |

**Ziele**
- Dateien und Nachrichten ohne großen Aufwand schützen
- Verschlüsselt kommunizieren
- Eine moderne, ansprechende GUI

**Hürden**
- Wählt schwache oder mehrfach verwendete Passwörter
- Verliert das Interesse bei umständlichen Abläufen

**Erwartungen an Aegis**
- Wenige Schritte bis zum Ergebnis
- Ein sicheres Passwort, ohne sich selbst eines ausdenken zu müssen
- Schlüssel einfach mit anderen teilen können.

**Relevante Anforderungen:** FA-02, FA-24, FA-25, FA-26, FA-29, FA-30, FA-33, FA-35, FA-68, FA-69, NFA-14, NFA-15

---

## Persona 4: Johan Krüger, Informatiker

| Merkmal | Beschreibung |
|---|---|
| Alter | 29 Jahre |
| Beruf | Backend-Entwickler in einem Softwareunternehmen |
| Technisches Vorwissen | Hoch; nutzt age und GnuPG, kennt Grundlagen der Kryptografie und Post-Quanten-Kryptografie |
| Geräte | Laptop mit Fedora, Heimserver |
| Nutzungskontext | Verschlüsselt Backups und Konfigurationsdateien automatisiert per Skript und sucht eine Alternative mit Post-Quanten-Kryptografie |
| Nutzungshäufigkeit | Täglich, überwiegend automatisiert |

**Ziele**
- Verschlüsselung in Skripte und Pipelines einbinden
- Zukunftssichere Kryptografie mit hybriden Post-Quanten-Verfahren
- Volle Kontrolle über Formate und Verfahren

**Hürden**
- Misstrauen gegenüber neuen, nicht geprüften Formaten
- Unklare Dokumentation des Dateiformats

**Erwartungen an Aegis**
- Eine schnelle, skriptbare Kommandozeile
- age als erprobter Fallback
- Nachvollziehbare Spezifikation und Versionierung des eigenen Dateiformats

**Relevante Anforderungen:** FA-44, FA-49, FA-56, FA-57, FA-58, FA-60, FA-62, NFA-04, NFA-22, NFA-32, NFA-38

---

## Bedeutung für die Usability-Tests

Die Testpersonen werden so ausgewählt, dass sie den Personas möglichst entsprechen. Den Schwerpunkt bilden Maria Meier und Klaus Müller: Kommen Personen ohne technisches Vorwissen mit Aegis zurecht, ist das zentrale Ziel der Arbeit erreicht. Johan Krüger wird vor allem für die Kommandozeile und die technischen Tests berücksichtigt.

### Hinweis zur Verwendung von KI-Werkzeugen

| Eingesetztes KI-Werkzeug |  Nutzung |
|---|---|
| Claude Opus 5.5 | Story überarbeitung der vom Team vorgegebenen Personas, Zuordnung der relevanten Anforderungen |
