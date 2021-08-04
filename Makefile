OUTPUT_JAR := sqlc-evcore-ndk-driver.jar

all: ndkbuild

init:
	git submodule update --init

regen:
	java -cp gluegentools/antlr.jar:gluegentools/gluegen.jar com.jogamp.gluegen.GlueGen -I. -Ecom.jogamp.gluegen.JavaEmitter -CEVNDKDriver.cfg native/sqlc.h
	sed -i.orig 's/^import/\/\/import/' java/io/sqlc/EVNDKDriver.java
	sed -i.orig 's/ $$//g' native/EV*.c

ndkbuild:
	rm -rf lib libs *.jar
	javac -d .  java/io/sqlc/*.java
	ndk-build
	cp -r libs lib
	jar cf $(OUTPUT_JAR) io lib

clean:
	rm -rf java/io/sqlc/*.orig native/*.orig io obj lib libs *.jar *.zip *.jar
