--EJERCICIO  1. Utilizar un trigger llamado ins_emple para controlar que en la empresa, sólo está permitido insertar en las tablas de la base de datos durante las horas de oficina normales, entre las 9:30 y las 17:30 horas, de lunes a viernes.


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


--EJERCICIO 2. Un uso habitual de los triggers es el de auditoria. Crear un trigger para guardar en una tabla de control la fecha, el usuario de base de datos y el Tipo de Operación (insert, update o delete) que modificó la tabla EMPLE.
