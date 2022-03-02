/**DDL UND DML**/
/**Data Definition Language : CREATE TABLE, ALTER TABLE,DROP TABLE*/
/**Data Manipulation Language : INSERT,UPDATE,DELTE*/


/*Tabellen Kreation fuer Kunde*/
create table kunde (
    kdnr integer,
    name varchar(100),
    ort varchar(100),
    constraint pk_kunde primary key (kdnr)
);
/*Tabellen Kreierung fuer Telefon*/
create table telefon (
    kdnr integer,
    telefon varchar(20),
    constraint pk_telefon primary key (kdnr,telefon),
    constraint fk_telefon foreign key (kdnr) references kunde(kdnr)
);
------------------------------------------------------------------------------------------------------------------------------------------------
/*Insertion in Kunden*/
INSERT INTO KUNDE VALUES(1,'Meier','Hamburg');
/*Fuegt nur Name und nicht nullable PK kdnr ein, ORT wird DEFAULT WERT ODER NULL*/
INSERT INTO KUNDE(kdnr,name) VALUES (2,'Mueller');
INSERT INTO KUNDE(kdnr,name) VALUES (3,'Schulze');
/*Schlaegt fehl, da doppelter key verwendet wird*/
INSERT INTO KUNDE(kdnr,name) VALUES (2,'Dieter');
------------------------------------------------------------------------------------------------------------------------------------------------
/*Insertion in Telefon*/

INSERT INTO TELEFON VALUES(2,'1234567');
/*HIER SCHLAEGT ES FEHL,DA FREMDSCHLUESSEL 4 VON KUNDEN NICHT IN DER DATENBANK IST ! bzw Fremdschluessel Bedingung fk_telefon constraint wurde somit verletzt*/
INSERT INTO TELEFON VALUES(4,'1234567');
------------------------------------------------------------------------------------------------------------------------------------------------
/*GIBT GESAMTE DATENBANKSCHEMA VON KUNDE/TELEFON AUS*/
SELECT * FROM KUNDE;
SELECT * FROM TELEFON;
------------------------------------------------------------------------------------------------------------------------------------------------
/*VERAENDERUNG DES DATENBANKSCHEMAS BZW DER TABELLE MIT ALTER */
/*Hier "droppen" wir den Ortsattribut/Spalte von den Kunden*/
ALTER TABLE KUNDE DROP COLUMN ORT;
/*Hier mittels ADD fuegen wir neues Attribut mit Domaene hinzu*/
ALTER TABLE KUNDE ADD gebdat DATE;
/*Hier fuegen wir einen weiteren Constraint in die Tabelle Kunde hinzu*/
ALTER TABLE KUNDE ADD CONSTRAINT u_geb UNIQUE (name,gebdat);
------------------------------------------------------------------------------------------------------------------------------------------------
/*UPDATEN DER DATENBANK*/
/*Mittels Update koennen wir neue Eingabewerte in die Tabelle hinzufuegen/setzen mit SET, das WHERE ist hierbei eine Bedingung mit gleichsetzung wo die Kdnr = 1 ist (also Meier)*/
UPDATE Kunde SET gebdat = DATE'1990-05-23' WHERE kdnr = 1;
------------------------------------------------------------------------------------------------------------------------------------------------
/*LOESCHUNG VON TUPELN UND DROPPEN VON TABELLEN*/
/*Hier wird das gesamte Schema geloescht*/
DROP TABLE KUNDE;
DROP TABLE TELEFON;
/*Tupel bzw. Zeilen werden mittels DELETE entfernt*/
/*BEACHTE : Man kann die WHERE Klausel auslassen damit die gesamte Tabelle entfernt wird, aber es dabei auch fehlschlagen kann wegen FK-Verletzungen wie hier Telefon.*/
DELETE FROM KUNDE WHERE kdnr=2;
/*Man kann KEINE Tabellen loeschen falls Fremdschluessel von dem PK der jeweiligen Tabelle abhaengt, deswegen muss ZUERST die Tabelle mit dem FK deletet/gedropped werden!!!*/
/*BEACHTE: DELETE ist eine DML-Anweisung die nur die Zeilen loescht, aber nicht die Tabelle selbst !*/
------------------------------------------------------------------------------------------------------------------------------------------------
/*SEQUENZEN ANLEGEN MITTELS SEQUENCE*/
/*Create Sequence kann bspw. fuer eindeutige IDs bzw PK's zu generieren, es verhaelt sich wie eine Art zaehler, zaehlt von 1,2,3,4...*/
CREATE SEQUENCE seq_kdnr;
/*Selektiert die kreierte Sequence und gibt die naechste Sequence Zahl mittels nextval Methode aus, aus der DUAL Params*/
SELECT seq_kdnr.nextval FROM DUAL;
/*Gibt den aktuellen sequence wert aus*/
SELECT seq_kdnr.currval FROM DUAL;
/*Damit lassen sich bspw. fuer keys oder gewissen abfolgewerte als eingabe direkt in bspw. INSERT mit uebergeben*/
INSERT INTO KUNDE(kdnr,name) VALUES(seq_kdnr.nextval,'Mark');
------------------------------------------------------------------------------------------------------------------------------------------------


/**SCHEMA ANFRAGEN / QUERIES*/


/*SELECT MIT EXPRESSIONS UND BEDINGUNGEN*/
/*SELECT ist wie PI(Projektion)*/
/*Selected alles vom Kunden bzw zeigt alle Zeilen und Spalten an*/
SELECT * FROM KUNDE;
/*Selected nur einzigartige Mendeneingaben, da SQL nicht auf mehrstelliger Mengenrelation Arbeitet und bspw. falls nicht angegeben mehrere gleiche Eintraege erlaubt*/
SELECT DISTINCT * FROM KUNDE;
/*Selected nur unter gewissen Bedingungen/conditions mit NOT, AND OR oder Praedikaten bzw einer Expression*/
/*Where ist wie Sigma(Selektion)*/
/*BEACHTE : WHERE evaluiert wie IF zu true oder false bzw. gibt alle Zeilen an bei den true ausfaellt*/
SELECT * FROM KUNDE WHERE NAME='Mueller';
SELECT * FROM KUNDE WHERE ort IS NULL;
SELECT name,ID FROM Angestellter WHERE salary BETWEEN 4000 AND 8000;
/*Ebenso kann man gewisse Attribut Werte in der Projektion veraendern und als einzelne Spalte ausgeben*/
SELECT gehalt,gehalt*2 FROM Angestellter WHERE ID>10;
/*Fuer abfragen bei String benutzt man das Schluesselwort LIKE und kann mit bspw upper formatieren bzw. dann ist gross/kleinschreibung egal !!*/
/*BEACHTE : Es ist wichtig wo das % Zeichen auftaucht, da %B alle String mit ENDUNG B ausgibt und B% alle Strings die mit B ANFANGEN*/
SELECT gehalt,department FROM Angestellter WHERE upper(last_name) LIKE %SON;
/*Ebenso kann man bspw. gewisse CASE Beindungen aufstellen und werte dazu einsetzen*/
/*Hier wird zum beispiel Alle Attribute die den Wert NULL haben mit 0 ersetzt und hat komission UMBENANNT ZU kommi, die gesamte Tabelle wird hierbei ausgegeben, da ELSE Cond.*/
SELECT name,gehalt,AID,
    CASE
        WHEN komission is NULL THEN 0
        ELSE komission
    END as kommi
FROM Angestellter;
------------------------------------------------------------------------------------------------------------------------------------------------
/*Sortierung der Elemente in der Tabelle*/
/*Sortierungen lassen sich mittels ORDER BY sortieren,dabei kann man genauer angeben ob ASC (ascending) oder DESC (descending) sortiert werden soll*/
/*Hierbei gilt es auch zu selektieren ZU was sortiert werden soll mittels Select*/
/*ASC von klein auf gross bzw von A nach Z und DESC von gross nach klein bzw von Z nach A*/
Select gehalt,name FROM Angestellter ORDER BY gehalt ASC,name DESC;
------------------------------------------------------------------------------------------------------------------------------------------------
/*Formattierung und DUMMY TABELLE*/
/*dummy tabelle dual gibt uns eine dummy vor bzw vorlage schema*/
SELECT * FROM dual; /*ergibt X in einer Relation*/
/*Gibt uns derzeitiges Datum,Timestamp und nutze aus*/
SELECT current_date,current_timestamp , user FROM dual;
/*Formattieren kann man mittels to_char*/
SELECT to_char(current_date,'DD.MM.YY'), current_timestamp,user FROM dual;
------------------------------------------------------------------------------------------------------------------------------------------------
/*FUNKTIONEN in SQL*/
/*Funktionen erlauben es uns Funktionen anzuwenden auf Daten und koennen jene veraendern.Funktionen arbeiten auf Argumenten*/
/*Hier wird die maximale anzahl von salary aus der Employee Tabelle ausgegeben (MEHRTUPEL-FUNKTION, da alle Ergebnisse verwendet werden fuer eine Ausgabe(naemlich die maximalste))*/
SELECT max(salary) FROM hr.employees;
/*Fuer eine Eintupel Funktion ist bspw log moeglich, da fuer JEDES Tupel EINZELN berechnet wird (hier zu log 2) Eintupel funktionen haben meist 2 Parameter*/
Select log(2, salary) FROM hr.employees;
/*CASE WHEN Bedingungen sind ahenlich mit IF-Else-Then Statements vergleichbar*/
/*Hier fragen wir wenn gewisse JOB-IDs abgefragt werden und deren salary um gewisse anzahl angestiegen wird und in dem new_salary attribut abgelegt wird*/
SELECT salary,job_id,first_name,
        CASE WHEN job_id='FI_ACCOUNT' THEN salary*1.1
            WHEN job_id = 'ST_CLERK' THEN salary*1.5
            WHEN job_id = 'ST_MAN' THEN salary*1.20
            ELSE salary
            END new_salary
FROM hr.employees;

/*mittels sum koennen wir die summe der gesamten Employees oder gewisser Abteilungen berechen*/
SELECT sum(salary) FROM hr.employees;
------------------------------------------------------------------------------------------------------------------------------------------------
/*AGGREGATIONSFUNKTION mittels GROUP BY und HAVING*/
/*Mittels GROUP BY kann man Tabellen nach bspw. department ID gruppieren um dann den hoechsten Gehalt oder die Summe aus der jew. Gruppe Der Mitarbeiter herauszubekommen*/
SELECT department_id,sum(salary) FROM hr.employees GROUP BY department_id;
/*Oder fuer das hoechste gehalt mittels max(salary)*/
/*BEACHTE DABEI DASS SUM ODER MAX eine EINTUPELFUNKTION !!!! ist und somit man hier nicht nochmal last_name bspw. reinnehmen kann da schon uber department_id gruppiert wird*/
SELECT department_id,sum(salary) FROM hr.employees WHERE department_id IS NOT NULL GROUP BY department_id ORDER BY sum(salary) ASC;
/*Andere Aggregationsfunktionen*/
/*Zaehlt alle Zeilen/Reihen aus Tabelle Employees (evaluiert auf einen Integer)*/
SELECT count(*) from hr.employees;
/*Zaehlt gesamtgehalt von allein Eintraegen aus employees*/
SELECT sum(salary) from hr.employees;
/*Zaehlt Durchschnitsgehalt von allen Eintraegen aus employees*/
SELECT avg(salary) from hr.employees;
/*Gibt max. Wert fuer Gehalt aus employees Tabelle aus*/
Select max(salary) from hr.employees;
/*Zaehlt alle DISTINKTEN, also nicht doppelte/unterschiedliche manager IDs aus employees*/
SELECT count(DISTINCT manager_id) from hr.employees;
/*GRUPPIERUNG IST DIE ZERLEGUNG DER RELATION ZU DISJUNKTEN MENGEN*/
/*Somit kann man nicht last_name waehrend max(salary) ausgeben. Die mengen sind eine einzelne Gruppe*/
------------------------------------------------------------------------------------------------------------------------------------------------
/*Nach gruppierung kann man dann spezifizieren inwieweit jene Gruppe definiert ist, bzw. laesst uns jene Gruppe als GANZES untersuchen*/
/*Hier wird der durschnittsgehalt eines departments ausgerechnet und gruppiert*/
Select department_id, round(avg(salary)) FROM hr.employees GROUP BY department_id;
/*Hier werden nur Departments ausu_gebgegeben die MEHR als einen Arbeiter haben!!!*/
/*DIe HAVING klausel folgt IMMER NACH der Group BY klausel und definiert welche eigenschaften die Gruppen erfuellen muessen !!!*/
Select round(avg(salary)) as Durchschnitt FROM hr.employees GROUP BY department_id HAVING count(*)>1 ORDER BY avg(salary) ASC;
------------------------------------------------------------------------------------------------------------------------------------------------
/*JOIN UND VERBUND OPERATION AUF TABELLEN*/
/*Verschiedene Joins wie auch aus R.A. Natural, LEFT-OUTER,RIght-Outer und bedingungs/Theta-Joins, ebenso Kreuzprodukt*/
/*Abstrakte darstellung*/
SELECT <selection> FROM <tabelle>
<JOINTYP> JOIN <tabelle2>
// <jointyp> ::= Inner | <outer-join-typ> [OUTER]
ON <SUCHBEDINGUNG> | USING <Spaltenname>
/*Kreuzprodukt*/
SELECT * FROM A CROSS JOIN B;
SELECT d.department_id, e.last_name FROM hr.departments d CROSS JOIN hr.employees e;
/*EQUI-JOIN*/
/*Beachte emp und dep sind hier aliases die bei dem ON Vergleich zur eindeutigen Identifikation der Objekte gelten*/
/*Die Projektion mittels SELECT funktioniert hier ebenso mit den aliases bzw. welche genaue Tabellenrelation wir auswaehlen*/
SELECT d.department_id , e.last_name FROM hr.departments d JOIN hr.employees e ON d.department_id = e.employee_id ORDER BY 1 ASC;
SELECT * FROM hr.employees emp JOIN hr.departments dep ON dep.department_id = emp.department_id;
/*NATURAL JOIN verbindet automatisch gleiche keys bzw. gleichwertige attribute miteinander,falls mehrere gleich sind kanns zu problematiken kommen*/
/*Hier koennen bspw einige wegfallen, da hierbei die manager_id fuer den JOIN verwendet wurde !!! Es wurde ja nicht mit ON Vergleich angegeben welches Attribut verglichen werden soll*/
SELECT dep.department_name, emp.last_name FROM hr.departments dep NATURAL JOIN hr.employees emp;
/*OUTER JOINS*/
/*Outer joins sind wie in der rel. ALgebra lassen NULL werte zu und es ist abhaengig WO die Relation dann steht !!!*/
SELECT dep.department_name, emp.last_name FROM hr.employees LEFT JOIN hr.departments dep ON emp.department_id = dep.department_id;
/*Ebeneso kann man die Null-Werte mittels WHERE Klausel abfragen*/
SELECT emp.last_name,dep.department_id FROM hr.employees emp LEFT JOIN hr.departments dep ON emp.department_id = dep.department_id WHERE emp.department_id IS NULL;
------------------------------------------------------------------------------------------------------------------------------------------------
/*MENGENOPERATIONEN*/
/*Hier gibts Vereinigungen/Differenz und Durchschnitt der Mengen*/
/*Mann muss zwei Objekte oder Eingaben Selektieren um jene zu vereinen oder den durchschnitt zu bilden*/
/*Hier wird manager id von employees mit der Manager_id von den departments vereinigt (Beachte: Es schliesst DOPPELTE WERTE aus!) UNION ALL erlaubt alle doppelten Tupel*/
SELECT manager_id FROM hr.employees UNION SELECT manager_id hr.departments;
/*Differenz*/
SELECT manager_id FROM hr.employees MINUS SELECT manager_id hr.departments;
/*Durchschnittsmenge*/
SELECT manager_id FROM hr.employees INTERSECT SELECT manager_id hr.departments;
/*Aehnlich wie outer joins und alle ausser NULL auswirft kann man dies auch mit der Differenzoperation machen (16 Departments). Also Deps MIT angestellten*/
SELECT department_name FROM hr.departments dep MINUS (
SELECT depa.department_name FROM hr.departments depa JOIN hr.employees emp ON depa.department_id = emp.department_id);
------------------------------------------------------------------------------------------------------------------------------------------------
/*UNTERABFRAGEN*/
/*Unterabfragen koennen bspw. in der WHERE Klausel mit stehen,obere bzw aussere Abfragen sind vor dem WHERE*/
/*Hier alle Namen ausgeben die ein hoeheres gehalt als das durchschnitssgehalt von den employees bekommt*/
SELECT last_name FROM hr.employees WHERE (SELECT round(avg(salary)) FROM hr.employees);
/*Oder bspw spezifisch abfragen die Mitarbeiter die vor dem Chef herrn King gearbeitet hatten*/
SELECT last_name FROM hr.employees WHERE hire_date < (SELECT hire_date WHERE last_name = 'King' AND first_name= 'Steven');
/*Oder hier alle Mitarbeiter die keine Angestellten sind, wobei mittels NOT IN abgefragt wird*/
SELECT first_name,last_name FROM hr.employees WHERE employee_id NOT IN (SELECT manager_id FROM hr.employees where manager_id IS NOT NULL);
/*In UNTER Abfragen koennen gewisse Operatoren die innere Menge abfrage wie bspw. ALL or ANY*/
/*ALL muss fuer ALLE unterabfragen WAHR sein und ANY muss mindestens EIN Ergebnis WAHR sein*/
/*Wenns bspw. mehrere gleiche Tupel gibt wie die Abfrage ueber den Arbeiter Herr Taylor der doppelt vorhanden ist muss man genau mit any Vorbedingung der Menge arbeiten*/
/*Diese unterbfrage alleine gibt 2 Hire dates von den Arbeitern namens Taylor an*/
SELECT last_name FROM hr.employees WHERE hire_date < (SELECT hire_date FROM hr.employees WHERE last_name = 'Taylor');
/*Mittels any koennen wir mittels ANY alle Arbeiter ausgeben der ENTWEDER bei einem ODER bei dem anderen zu Wahr evaluiert wird,welcher Taylor ist hier egal*/
SELECT last_name FROM hr.employees WHERE hire_date < ANY (SELECT hire_date FROM hr.employees WHERE last_name = 'Taylor');
/*Mit all kann man das abfrage datum abfragen die frueher als BEIDE/ALLE Taylors angefangen haben zu arbeiten*/
SELECT last_name FROM hr.employees WHERE hire_date < ALL (SELECT hire_date FROM hr.employees WHERE last_name = 'Taylor');
