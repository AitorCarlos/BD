--EJERCICIO  1. Utilizar un trigger llamado ins_emple para controlar que en la empresa, sólo está permitido insertar en las tablas de la base de datos durante las horas de oficina normales, entre las 9:30 y las 17:30 horas, de lunes a viernes.
/*

SET SERVEROUTPUT ON
CREATE OR REPLACE TRIGGER ins_emple
before insert on emple
begin 
--Solo si la fecha actual no esta ni antes de las 9:30 a las 17:30 
if(to_char(SYSDATE,'HH24:MI')not between '09:30' and '17:30')
--ni es sabado o domingo
or(to_char(SYSDATE,'DY')IN ('SAB','DOM'))
--nos saltara el error 'SOLO SE PUEDEN AÑADIR DURANTE EL HORARIO LABORAL'
then RAISE_APPLICATION_ERROR (-20001,'SOLO SE PUEDEN AÑADIR DURANTE EL HORARIO LABORAL');
end if;
end;
--INSERTAR EL EMPLEADO MUÑOZ A LA TABLA EMPLE
INSERT INTO EMPLE VALUES (1112,'MUÑOZ','EMPLEADO',7782,'23/01/1982',169000,NULL,10);
--BORRAR AL EMPLEADO CON EL VALOR '1111'
--DELETE FROM EMPLE where emp_no =('1112');
  
  --PARA DESACTIVAR EL TRIGGER
 ALTER TRIGGER ins_emple DISABLE
  
*/
 

--EJERCICIO 2. Un uso habitual de los triggers es el de auditoria. Crear un trigger para guardar en una tabla de control la fecha, el usuario de base de datos y el Tipo de Operación (insert, update o delete) que modificó la tabla EMPLE.
CREATE OR REPLACE TRIGGER Control_Empleados
AFTER INSERT OR DELETE OR UPDATE ON EMPLE
FOR EACH ROW

BEGIN

CASE
  WHEN INSERTING THEN
     INSERT INTO CTRL_EMPLEADOS VALUES('Empleados',(select USER from DUAL),SYSDATE,'INSERT');
  WHEN UPDATING THEN
    INSERT INTO CTRL_EMPLEADOS VALUES('Empleados',(select USER from DUAL),SYSDATE,'UPDATE');
  WHEN DELETING THEN
   INSERT INTO CTRL_EMPLEADOS VALUES('Empleados',(select USER from DUAL),SYSDATE,'DELETE');

END CASE;

END Control_Empleados;

-- para probar que funciona

DELETE FROM EMPLE where emp_no =('7934');
SELECT * FROM emple;

INSERT INTO EMPLE VALUES (7934,'MUÑOZ','EMPLEADO',7782,'23/01/1982',169000,NULL,10);
select * from Ctrl_Empleados;

UPDATE EMPLE 
  SET SALARIO = 1000
  WHERE EMP_NO = 8934;
select * from Ctrl_Empleados;

drop trigger CONTROL_EMPLEADOS;
--EJERCICIO 3. Crear un trigger para que no permita insertar empleados en el departamento  "Ventas".

SET SERVEROUTPUT ON
CREATE OR REPLACE TRIGGER Ventas
BEFORE INSERT ON EMPLE
FOR EACH ROW WHEN (NEW.DEPT_NO=30)
BEGIN
RAISE_APPLICATION_ERROR(-20001, 'CODIGO NO VALIDO');
END;

INSERT INTO EMPLE VALUES (0001,'SARRALDE','EMPLEADO',2222,'23/01/1982',169000,NULL,10);
select * from depart;

DELETE FROM EMPLE where emp_no =('0001');

--correccion
SET SERVEROUTPUT ON
CREATE OR REPLACE TRIGGER ins_vent
  BEFORE INSERT ON EMPLE
  FOR EACH ROW

DECLARE
V_CODDEPART DEPART.DEPT_NO%TYPE;

BEGIN

SELECT DEPT_NO INTO V_CODDEPART
FROM DEPART
WHERE UPPER(DNOMBRE) = 'VENTAS';

  IF :NEW.DEPT_NO=V_CODDEPART THEN
  RAISE_APPLICATION_ERROR(-20500,'se ha intentado insertar en el departamento de ventas');
END IF;
END ;

INSERT INTO EMPLE VALUES (7934,'SARRALDE','EMPLEADO',7782,'23/01/1982',169000,NULL,10);
INSERT INTO EMPLE VALUES (7934,'SARRALDE','EMPLEADO',7782,'23/01/1982',169000,NULL,30);











--EJERCICIO 4. Crear un trigger para impedir que se aumente el salario de un empleado en más de un 20%.

DROP TRIGGER UPD_SALARIO;

CREATE OR REPLACE TRIGGER UPD_SALARIO BEFORE
UPDATE OF SALARIO ON EMPLE FOR EACH ROW WHEN (NEW.SALARIO>OLD.SALARIO*1.2)

BEGIN
--PARA UNO
  RAISE_APPLICATION_ERROR(-20600,'Se ha intentado aumentar el salario mas de un 20% para el empleado'||TO_CHAR(:new.EMP_NO));
--PARA TODOS
  --DBMS_OUTPUT.PUT_LINE('Se ha intentado aumentar el salario mas de un 20% para el empleado'||TO_CHAR(:new.EMP_NO));
END;

select * from emple 
where dept_no=20 
order by salario;


UPDATE EMPLE
 SET SALARIO=SALARIO*2
 WHERE DEPT_NO=20;

select * from emple 
where dept_no=20 
order by salario;




--Ejercicio 5.  Existe la vista “EmpleadoDpto”en la que se recoge el numero  y nombre del empleado junto con el nombre del departamento.




































