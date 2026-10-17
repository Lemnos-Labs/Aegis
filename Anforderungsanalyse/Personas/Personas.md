# Personas Aegis

Personas sind fiktive, aber realistische Stellvertreter der Zielgruppen von Aegis. Sie dienen als Bezugspunkt für Designentscheidungen („Würde Sabine das ohne Hilfe verstehen?“) und als Grundlage für die Auswahl der Testpersonen in den Usability-Tests. Die primären Personas nutzen Aegis aktiv; die sekundäre Persona kommt nur als Empfänger verschlüsselter Dateien mit Aegis in Berührung.

## Übersicht

| Persona | Rolle | Technisches Vorwissen | Hauptsächlicher Zugang | Priorität für Usability-Tests |
|---|---|---|---|:---:|
| Sabine Hoffmann | Primär | Gering | Grafische Oberfläche, Kontextmenü | Hoch |
| Gerhard Brandt | Sekundär | Gering | Erhaltene Datei, Doppelklick | Hoch |
| Lea Yilmaz | Primär | Mittel, ohne Sicherheitswissen | Grafische Oberfläche, Add-In | Mittel |
| Jonas Keller | Primär | Hoch | Kommandozeile | Gering |

---

## Persona 1: Sabine Hoffmann, die Bürofachkraft

| Merkmal | Beschreibung |
|---|---|
| Alter | 46 Jahre |
| Beruf | Sachbearbeiterin in der Lohnbuchhaltung eines mittelständischen Maschinenbauunternehmens mit 180 Mitarbeitenden |
| Technisches Vorwissen | Gering; sicher im Umgang mit Outlook, Word, Excel und der Lohnsoftware, aber keine Kenntnisse über Verschlüsselung |
| Geräte | Office-Laptop mit Windows 11 |
| Nutzungskontext | Bekommt Aegis von der IT-Abteilung installiert, mit der Vorgabe, Lohnabrechnungen und Personalunterlagen nur noch verschlüsselt per E-Mail an den externen Steuerberater zu schicken |
| Nutzungshäufigkeit | Mehrmals pro Woche |

**Zitat:** „Ich will einfach nur die Datei sicher verschicken. Wenn da plötzlich etwas von Schlüsseln und Zertifikaten steht, rufe ich lieber die IT an.“

**Ziele**
- Sensible Dokumente schnell und ohne Umwege verschlüsseln
- Sicher sein, dass sie alles richtig gemacht hat
- Den Arbeitsablauf in Outlook und im Explorer möglichst wenig ändern

**Hürden und Frustrationen**
- Fachbegriffe verunsichern sie und führen zu Abbrüchen
- Angst, versehentlich Daten zu löschen oder unverschlüsselt zu verschicken
- Unverständliche Fehlermeldungen ohne Hinweis, was zu tun ist
- Hat bei einem früheren Versuch mit Kleopatra nach wenigen Minuten aufgegeben

**Erwartungen an Aegis**
- Verschlüsseln direkt per Rechtsklick auf die Datei
- Klare Bestätigung, dass die Datei verschlüsselt wurde und wo sie liegt
- Eindeutige Warnung, bevor etwas Unwiderrufliches passiert

**Relevante Anforderungen:** FA-01, FA-11, FA-12, FA-13, FA-16, FA-21, FA-27, FA-50, FA-51, FA-52, FA-63, NFA-13, NFA-17, NFA-18

---

## Persona 2: Gerhard Brandt, der Empfänger (sekundär)

| Merkmal | Beschreibung |
|---|---|
| Alter | 61 Jahre |
| Beruf | Inhaber einer kleinen Steuerberatungskanzlei, Mandant bzw. Geschäftspartner von Sabine Hoffmann |
| Technisches Vorwissen | Gering; nutzt E-Mail, PDF-Reader und die Kanzleisoftware |
| Geräte | Office-PC mit Windows 11 |
| Nutzungskontext | Erhält von verschiedenen Mandanten verschlüsselte Dateien und hat Aegis vorher nie gesehen |
| Nutzungshäufigkeit | Unregelmäßig, je nach Mandant |

**Zitat:** „Ich habe hier eine Datei bekommen, die sich nicht öffnen lässt. Was soll ich damit machen?“

**Ziele**
- Die erhaltene Datei mit möglichst wenig Aufwand öffnen
- Keine zusätzliche Software verstehen müssen, die er nur selten braucht

**Hürden und Frustrationen**
- Weiß nicht, was eine `.aegis`-Datei ist und welches Programm er braucht
- Installiert ungern Software unbekannter Herkunft
- Hat das Passwort per Telefon bekommen und ist unsicher, ob er es richtig eingetippt hat

**Erwartungen an Aegis**
- Eine kurze, verständliche Anleitung direkt bei der Datei
- Schnelle Installation ohne Einrichtung
- Öffnen der Datei per Doppelklick

**Relevante Anforderungen:** FA-07, FA-45, FA-47, FA-50, FA-51, FA-65, NFA-41, NFA-44

---

## Persona 3: Lea Yilmaz, die technikaffine Studentin

| Merkmal | Beschreibung |
|---|---|
| Alter | 22 Jahre |
| Beruf | Studentin der Sozialen Arbeit, arbeitet nebenbei in einer Beratungsstelle |
| Technisches Vorwissen | Mittel; probiert neue Apps ohne Scheu aus, hat aber kein Wissen über Kryptografie oder sichere Passwörter |
| Geräte | Privater Laptop mit Windows 11, Smartphone |
| Nutzungskontext | Möchte Ausweisdokumente, Bewerbungsunterlagen und Notizen aus der Beratungsstelle schützen und vertrauliche Nachrichten verschlüsselt verschicken |
| Nutzungshäufigkeit | Gelegentlich, dafür spontan |

**Zitat:** „Hauptsache, es geht schnell. Die Hinweise lese ich eh nicht.“

**Ziele**
- Dateien und Nachrichten ohne großen Aufwand schützen
- Mit Freundinnen und Kolleginnen verschlüsselt kommunizieren
- Eine moderne, ansprechende Oberfläche

**Hürden und Frustrationen**
- Wählt schwache oder mehrfach verwendete Passwörter
- Überspringt Hinweistexte und klickt Dialoge schnell weg
- Verliert das Interesse bei umständlichen Abläufen

**Erwartungen an Aegis**
- Wenige Schritte bis zum Ergebnis
- Ein sicheres Passwort, ohne sich selbst eines ausdenken zu müssen
- Schlüssel einfach mit anderen teilen können, z. B. als kopierbaren Text

**Relevante Anforderungen:** FA-02, FA-24, FA-25, FA-26, FA-29, FA-30, FA-33, FA-35, FA-68, FA-69, NFA-14, NFA-15

---

## Persona 4: Jonas Keller, der Tech-Nerd

| Merkmal | Beschreibung |
|---|---|
| Alter | 29 Jahre |
| Beruf | Backend-Entwickler in einem Softwareunternehmen |
| Technisches Vorwissen | Hoch; nutzt age und GnuPG, kennt Grundlagen der Kryptografie und verfolgt die Entwicklung der Post-Quanten-Kryptografie |
| Geräte | Laptop mit Fedora, Heimserver |
| Nutzungskontext | Verschlüsselt Backups und Konfigurationsdateien automatisiert per Skript und sucht eine Alternative mit Post-Quanten-Kryptografie |
| Nutzungshäufigkeit | Täglich, überwiegend automatisiert |

**Zitat:** „Ein neues Format nutze ich nur, wenn die Spezifikation offen ist und ich im Zweifel zu etwas Bewährtem zurück kann.“

**Ziele**
- Verschlüsselung in Skripte und Pipelines einbinden
- Zukunftssichere Kryptografie mit hybriden Post-Quanten-Verfahren
- Volle Kontrolle über Formate und Verfahren

**Hürden und Frustrationen**
- Misstrauen gegenüber neuen, nicht geprüften Formaten
- Grafische Oberflächen ohne Kommandozeile bremsen ihn aus
- Unklare Dokumentation des Dateiformats

**Erwartungen an Aegis**
- Eine schnelle, skriptbare Kommandozeile mit Pipes
- age als erprobter Fallback
- Nachvollziehbare Spezifikation und Versionierung des eigenen Formats

**Relevante Anforderungen:** FA-44, FA-49, FA-56, FA-57, FA-58, FA-60, FA-62, NFA-04, NFA-22, NFA-32, NFA-38

---

## Bedeutung für die Usability-Tests

Die Testpersonen werden so ausgewählt, dass sie den Personas möglichst entsprechen. Den Schwerpunkt bilden Sabine Hoffmann und Gerhard Brandt: Kommen Personen ohne technisches Vorwissen mit Aegis zurecht, ist das zentrale Ziel der Arbeit erreicht. Jonas Keller wird vor allem über die Kommandozeile und die technischen Tests berücksichtigt, nicht über die Nutzerbeobachtung.

### Hinweis zur Verwendung von KI-Werkzeugen

| Eingesetztes KI-Werkzeug | Zweck / Art der Nutzung |
|---|---|
| Claude Opus 5.5 | Überarbeitung der vom Team vorgegebenen Personas (Tech-Nerd, Bürofachkraft, technikaffiner junger Mensch), Vorschlag der zusätzlichen Persona „Empfänger“, Zuordnung der relevanten Anforderungen |