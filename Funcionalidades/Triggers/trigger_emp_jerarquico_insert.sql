SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

USE laboratorio;
GO

CREATE OR ALTER TRIGGER validar_area_emp_jerarq_insert 
ON dbo.empleado_jerarquico
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE
        @id_empleado INT,
        @num_area INT,
        @fecha_asignacion DATE;

    DECLARE cur CURSOR FOR
    SELECT id_empleado, num_area, fecha_asignacion
    FROM inserted
    OPEN cur;

    FETCH NEXT FROM cur INTO @id_empleado, @num_area, @fecha_asignacion;
    WHILE @@FETCH_STATUS = 0 
    BEGIN
        IF dbo.validador(@id_empleado, @num_area, 0) = 1
        BEGIN
            INSERT INTO [dbo].[empleado_jerarquico]
                        ([id_empleado]
                        ,[num_area]
                        ,[fecha_asignacion])
            VALUES
                (@id_empleado
                ,@num_area
                ,@fecha_asignacion);
        END;
        ELSE
        BEGIN
            PRINT 'El registro del empleado con id = ' + CAST(@id_empleado AS VARCHAR) + 
                  ' no ha podido ser insertado.';
        END;
        FETCH NEXT FROM cur INTO @id_empleado, @num_area, @fecha_asignacion;
    END;

    CLOSE cur;
    DEALLOCATE cur;
END;
GO