# Einstieg in ABAP: SAP BTP ABAP Environment Trial

Meine Materialien zum Buch "Einstieg in ABAP" (Rheinwerk Computing, 6. Auflage) in Verbindung zur
SAP BTP ABAP Environment Trial und keiner On-Premise SAP Installation.

## Export des ABAP Source Code

[abapGit](https://github.com/abapGit/abapGit) kann leider nicht mit SAP BTP verwendet werden, da es
die SAP GUI benötigt. Daher müssen ABAP-Objekte manuell aus Eclipse heraus exportiert werden. Das
kann über das Kontext-Menu auf dem Object ausgeführt werden: *Export -> General/File System*

Zum ausführen der Analyse mittels SonarCloud muss der folgende Befehl aufgerufen werden.
> sonar-scanner -D$(cat .sonar-project.properties)