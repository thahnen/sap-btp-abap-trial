# Einstieg in ABAP: SAP BTP ABAP Environment Trial

Meine Materialien zum Buch "Einstieg in ABAP" (Rheinwerk Computing, 6. Auflage) in Verbindung zur
SAP BTP ABAP Environment Trial und keiner On-Premise SAP Installation.

## Export des ABAP Source Code

Quelltexte können entweder per [abapGit](https://github.com/abapGit/abapGit) oder "manuell" (man
kann sich das bestimmt auch automatisieren) exportiert werden. Bei der manuellen Exportierung muss
aus Eclipse heraus per Kontext-Menu auf dem Objekt der Export angestossen werden:
*Export -> General/File System*

Zum ausführen der Analyse mittels SonarCloud muss der folgende Befehl aufgerufen werden.
> sonar-scanner -D$(cat .sonar-project.properties)

## abapGit "latest" Source Code

Um den Quelltext von abapGit selbst zu analysieren (nur den ABAP-Teil), kann dieser mit dem letzten
Build-Artefakt heruntergeladen werden:

> mkdir abapGit && curl -L https://raw.githubusercontent.com/abapGit/build/main/zabapgit_standalone.prog.abap > abapGit/zabapgit_standalone.prog.abap

## TODO: Locale Quelltexte mit SonarLint verbinden

Als Cache scheint ADT for Eclipse die lokalen Quelltexte des Cloud-Projekts an einem Ordner im
Workspace abzulegen. Der Pfad folgt wohl dem Schema:

`${workspace_loc}/.metadata/.plugins/org.eclipse.core.resources.semantic/.cache/${eclipse_project_name}/.adt/classlib/classes/${abap_class_name}`

Dies ist ein guter Einstieg für die Extension Points um die Datei, ähnlich der Integration in COBOL IDEs, zur Verfügung zu stellen.
