#!/usr/bin/env bash

echo 'The following Maven command installs your Maven-built Java application'
echo 'into the local Maven repository, which will ultimately be stored in'
echo 'Jenkins''s local Maven repository (and the "maven-repository" Docker data'
echo 'volume).'
set -x
# Prüfen und Erstellen des Zielverzeichnisses
mkdir -p target
# Ausführen des Maven-Befehls
mvn jar:jar install:install help:evaluate -Dexpression=project.name
set +x

echo 'The following command extracts the value of the <name/> element'
echo 'within <project/> of your Java/Maven project''s "pom.xml" file.'
set -x
# Überprüfen und Ausführen des Maven-Befehls
if command -v mvn &>/dev/null; then
    NAME=$(mvn -q -DforceStdout help:evaluate -Dexpression=project.name)
else
    echo "Maven is not installed or not in PATH"
    exit 1
fi
set +x

echo 'The following command behaves similarly to the previous one but'
echo 'extracts the value of the <version/> element within <project/> instead.'
set -x
# Überprüfen und Ausführen des Maven-Befehls
if command -v mvn &>/dev/null; then
    VERSION=$(mvn -q -DforceStdout help:evaluate -Dexpression=project.version)
else
    echo "Maven is not installed or not in PATH"
    exit 1
fi
set +x

echo 'The following command runs and outputs the execution of your Java'
echo 'application (which Jenkins built using Maven) to the Jenkins UI.'
set -x
# Ausführen der Java-Anwendung
java -jar target/${NAME}-${VERSION}.jar
