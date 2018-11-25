USE [master]
GO
/****** Object:  Database [laboratorio]    Script Date: 24/11/2018 18:38:18 ******/
CREATE DATABASE [laboratorio]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'laboratorio2', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\laboratorio2.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'laboratorio2_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\laboratorio2_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [laboratorio] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [laboratorio].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [laboratorio] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [laboratorio] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [laboratorio] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [laboratorio] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [laboratorio] SET ARITHABORT OFF 
GO
ALTER DATABASE [laboratorio] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [laboratorio] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [laboratorio] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [laboratorio] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [laboratorio] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [laboratorio] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [laboratorio] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [laboratorio] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [laboratorio] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [laboratorio] SET  DISABLE_BROKER 
GO
ALTER DATABASE [laboratorio] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [laboratorio] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [laboratorio] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [laboratorio] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [laboratorio] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [laboratorio] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [laboratorio] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [laboratorio] SET RECOVERY FULL 
GO
ALTER DATABASE [laboratorio] SET  MULTI_USER 
GO
ALTER DATABASE [laboratorio] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [laboratorio] SET DB_CHAINING OFF 
GO
ALTER DATABASE [laboratorio] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [laboratorio] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [laboratorio] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'laboratorio', N'ON'
GO
ALTER DATABASE [laboratorio] SET QUERY_STORE = OFF
GO
USE [laboratorio]
GO
/****** Object:  UserDefinedFunction [dbo].[validador]    Script Date: 24/11/2018 18:38:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[validador]
    (@id_empleado INT,
    @num_area INT,
    @tipo_empleado INT) -- 1 Emp Jerarq, 2 EPPermanente, 3 EPContratado, 4 EmpNoProf
RETURNS INT
AS
BEGIN
    DECLARE
        @id_nivel_seg_emp INT,
        @nombre_id_nivel_seg_emp VARCHAR(15),
        @id_nivel_seg_area INT,
        @nombre_id_nivel_seg_area VARCHAR(15),
		@nReturn INT;
    
    SELECT @id_nivel_seg_emp = E.id_nivel_seg, @nombre_id_nivel_seg_emp = NS.nombre
    FROM empleado E
    INNER JOIN nivel_seguridad NS ON E.id_nivel_seg = NS.id_nivel_seg
	WHERE E.id_empleado = @id_empleado;

	SELECT @id_nivel_seg_area = A.id_nivel_seg, @nombre_id_nivel_seg_area = NS.nombre
    FROM area A
    INNER JOIN nivel_seguridad NS ON A.id_nivel_seg = NS.id_nivel_seg
	WHERE A.num_area = @num_area;

    IF @id_nivel_seg_emp = @id_nivel_seg_area OR
       (@tipo_empleado <> 4 AND  
       (@nombre_id_nivel_seg_emp = 'Alto' OR 
       (@nombre_id_nivel_seg_emp = 'Medio' AND @nombre_id_nivel_seg_area = 'Bajo')))
        SET @nReturn = 1;
    ELSE
        SET @nReturn = 0;
	RETURN @nReturn;
END;
GO
/****** Object:  Table [dbo].[area]    Script Date: 24/11/2018 18:38:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[area](
	[num_area] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](50) NOT NULL,
	[id_nivel_seg] [int] NOT NULL,
 CONSTRAINT [PK_area] PRIMARY KEY CLUSTERED 
(
	[num_area] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[empleado]    Script Date: 24/11/2018 18:38:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[empleado](
	[id_empleado] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](50) NOT NULL,
	[apellido] [varchar](50) NOT NULL,
	[tipo_doc] [char](3) NOT NULL,
	[documento] [int] NOT NULL,
	[e_mail] [varchar](50) NOT NULL,
	[telefono] [varchar](15) NOT NULL,
	[tipo] [varchar](25) NOT NULL,
	[id_nivel_seg] [int] NOT NULL,
	[id_datos_confidenciales] [int] NOT NULL,
 CONSTRAINT [PK_empleado] PRIMARY KEY CLUSTERED 
(
	[id_empleado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[registro]    Script Date: 24/11/2018 18:38:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[registro](
	[id_empleado] [int] NOT NULL,
	[num_area] [int] NOT NULL,
	[num_registro] [int] IDENTITY(1,1) NOT NULL,
	[accion] [varchar](15) NOT NULL,
	[fecha_hora] [smalldatetime] NOT NULL,
	[autorizado] [char](2) NOT NULL,
 CONSTRAINT [PK_registro] PRIMARY KEY CLUSTERED 
(
	[id_empleado] ASC,
	[num_area] ASC,
	[num_registro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[intentos_fallidos]    Script Date: 24/11/2018 18:38:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[intentos_fallidos] AS 
SELECT empleado.id_empleado,
       empleado.nombre,
       empleado.apellido,
       area.num_area,
       area.nombre AS 'nombre_area'
FROM   empleado INNER JOIN registro R1 ON empleado.id_empleado = R1.id_empleado 
                INNER JOIN area ON R1.num_area = area.num_area 
WHERE  CONVERT(date, R1.fecha_hora, 101) = GETDATE() 
       AND R1.autorizado = 'No' 
       AND R1.accion = 'Ingreso'
       AND CONVERT(time, R1.fecha_hora) = (SELECT MAX(CONVERT(time, R2.fecha_hora)) 
                                                 FROM registro R2
                                                 WHERE R2.id_empleado = empleado.id_empleado
                                                       AND R2.accion = 'Ingreso'
            				                           AND CONVERT(date, R2.fecha_hora, 101) = GETDATE());
GO
/****** Object:  Table [dbo].[acceso]    Script Date: 24/11/2018 18:38:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[acceso](
	[id_empleado] [int] NOT NULL,
	[id_franja] [int] NOT NULL,
	[num_area] [int] NOT NULL,
 CONSTRAINT [PK_acceso] PRIMARY KEY CLUSTERED 
(
	[id_empleado] ASC,
	[id_franja] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[auditoria]    Script Date: 24/11/2018 18:38:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[auditoria](
	[id_trabajo] [int] NOT NULL,
	[num_auditoria] [int] IDENTITY(1,1) NOT NULL,
	[fecha_hora] [smalldatetime] NOT NULL,
	[resultado] [varchar](50) NOT NULL,
 CONSTRAINT [PK_auditoria] PRIMARY KEY CLUSTERED 
(
	[id_trabajo] ASC,
	[num_auditoria] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[contratado_en]    Script Date: 24/11/2018 18:38:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[contratado_en](
	[id_empleado] [int] NOT NULL,
	[id_trabajo] [int] NOT NULL,
	[num_area] [int] NOT NULL,
	[inicio_contrato] [date] NOT NULL,
	[fin_contrato] [date] NOT NULL,
 CONSTRAINT [PK_contratado_en] PRIMARY KEY CLUSTERED 
(
	[id_empleado] ASC,
	[id_trabajo] ASC,
	[inicio_contrato] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[datos_confidenciales]    Script Date: 24/11/2018 18:38:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[datos_confidenciales](
	[id_datos_confidenciales] [int] IDENTITY(1,1) NOT NULL,
	[contrasena] [char](32) NOT NULL,
	[huella_dactilar] [char](32) NOT NULL,
 CONSTRAINT [PK_datos_confidenciale] PRIMARY KEY CLUSTERED 
(
	[id_datos_confidenciales] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[empleado_jerarquico]    Script Date: 24/11/2018 18:38:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[empleado_jerarquico](
	[id_empleado] [int] NOT NULL,
	[num_area] [int] NOT NULL,
	[fecha_asignacion] [date] NOT NULL,
 CONSTRAINT [PK_empleado_jerarquico] PRIMARY KEY CLUSTERED 
(
	[id_empleado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[empleado_no_profesional]    Script Date: 24/11/2018 18:38:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[empleado_no_profesional](
	[id_empleado] [int] NOT NULL,
 CONSTRAINT [PK_empleado_no_profesional] PRIMARY KEY CLUSTERED 
(
	[id_empleado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[empleado_prof_contratado]    Script Date: 24/11/2018 18:38:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[empleado_prof_contratado](
	[id_empleado] [int] NOT NULL,
 CONSTRAINT [PK_empleado_prof_contratado] PRIMARY KEY CLUSTERED 
(
	[id_empleado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[empleado_prof_permanente]    Script Date: 24/11/2018 18:38:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[empleado_prof_permanente](
	[id_empleado] [int] NOT NULL,
	[num_area] [int] NOT NULL,
 CONSTRAINT [PK_empleado_planta_permanente] PRIMARY KEY CLUSTERED 
(
	[id_empleado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[empleado_profesional]    Script Date: 24/11/2018 18:38:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[empleado_profesional](
	[id_empleado] [int] NOT NULL,
	[tipo] [varchar](25) NOT NULL,
 CONSTRAINT [PK_empleado_profesional] PRIMARY KEY CLUSTERED 
(
	[id_empleado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[evento]    Script Date: 24/11/2018 18:38:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[evento](
	[num_area] [int] NOT NULL,
	[num_evento] [int] IDENTITY(1,1) NOT NULL,
	[fecha_hora] [smalldatetime] NOT NULL,
	[descripcion] [varchar](150) NOT NULL,
 CONSTRAINT [PK_evento] PRIMARY KEY CLUSTERED 
(
	[num_area] ASC,
	[num_evento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[franja_horaria]    Script Date: 24/11/2018 18:38:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[franja_horaria](
	[id_franja] [int] IDENTITY(1,1) NOT NULL,
	[horario_inicio] [time](0) NOT NULL,
	[horario_fin] [time](0) NOT NULL,
 CONSTRAINT [PK_franja_horaria] PRIMARY KEY CLUSTERED 
(
	[id_franja] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[nivel_seguridad]    Script Date: 24/11/2018 18:38:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[nivel_seguridad](
	[id_nivel_seg] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](25) NOT NULL,
	[categoria] [varchar](20) NOT NULL,
	[descripcion] [varchar](100) NOT NULL,
 CONSTRAINT [PK_nivel_seguridad] PRIMARY KEY CLUSTERED 
(
	[id_nivel_seg] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[trabajo]    Script Date: 24/11/2018 18:38:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[trabajo](
	[id_trabajo] [int] IDENTITY(1,1) NOT NULL,
	[descripcion] [varchar](100) NOT NULL,
 CONSTRAINT [PK_trabajo] PRIMARY KEY CLUSTERED 
(
	[id_trabajo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[area] ON 

INSERT [dbo].[area] ([num_area], [nombre], [id_nivel_seg]) VALUES (1, N'Ventas', 2)
INSERT [dbo].[area] ([num_area], [nombre], [id_nivel_seg]) VALUES (2, N'RRHH', 2)
INSERT [dbo].[area] ([num_area], [nombre], [id_nivel_seg]) VALUES (3, N'Producción', 3)
INSERT [dbo].[area] ([num_area], [nombre], [id_nivel_seg]) VALUES (4, N'Dirección General', 1)
INSERT [dbo].[area] ([num_area], [nombre], [id_nivel_seg]) VALUES (5, N'Finanzas', 2)
SET IDENTITY_INSERT [dbo].[area] OFF
SET IDENTITY_INSERT [dbo].[datos_confidenciales] ON 

INSERT [dbo].[datos_confidenciales] ([id_datos_confidenciales], [contrasena], [huella_dactilar]) VALUES (1, N'96917805fd060e3766a9a1b834639d35', N'96917805fd060e3766a9a1b834639d35')
INSERT [dbo].[datos_confidenciales] ([id_datos_confidenciales], [contrasena], [huella_dactilar]) VALUES (2, N'96917805fd060e3766a9a1b834639d35', N'96917805fd060e3766a9a1b834639d35')
INSERT [dbo].[datos_confidenciales] ([id_datos_confidenciales], [contrasena], [huella_dactilar]) VALUES (3, N'96917805fd060e3766a9a1b834639d35', N'96917805fd060e3766a9a1b834639d35')
INSERT [dbo].[datos_confidenciales] ([id_datos_confidenciales], [contrasena], [huella_dactilar]) VALUES (4, N'96917805fd060e3766a9a1b834639d35', N'96917805fd060e3766a9a1b834639d35')
INSERT [dbo].[datos_confidenciales] ([id_datos_confidenciales], [contrasena], [huella_dactilar]) VALUES (5, N'96917805fd060e3766a9a1b834639d35', N'96917805fd060e3766a9a1b834639d35')
INSERT [dbo].[datos_confidenciales] ([id_datos_confidenciales], [contrasena], [huella_dactilar]) VALUES (6, N'96917805fd060e3766a9a1b834639d35', N'96917805fd060e3766a9a1b834639d35')
INSERT [dbo].[datos_confidenciales] ([id_datos_confidenciales], [contrasena], [huella_dactilar]) VALUES (7, N'96917805fd060e3766a9a1b834639d35', N'96917805fd060e3766a9a1b834639d35')
INSERT [dbo].[datos_confidenciales] ([id_datos_confidenciales], [contrasena], [huella_dactilar]) VALUES (8, N'96917805fd060e3766a9a1b834639d35', N'96917805fd060e3766a9a1b834639d35')
INSERT [dbo].[datos_confidenciales] ([id_datos_confidenciales], [contrasena], [huella_dactilar]) VALUES (9, N'96917805fd060e3766a9a1b834639d35', N'96917805fd060e3766a9a1b834639d35')
INSERT [dbo].[datos_confidenciales] ([id_datos_confidenciales], [contrasena], [huella_dactilar]) VALUES (10, N'96917805fd060e3766a9a1b834639d35', N'96917805fd060e3766a9a1b834639d35')
INSERT [dbo].[datos_confidenciales] ([id_datos_confidenciales], [contrasena], [huella_dactilar]) VALUES (11, N'96917805fd060e3766a9a1b834639d35', N'96917805fd060e3766a9a1b834639d35')
INSERT [dbo].[datos_confidenciales] ([id_datos_confidenciales], [contrasena], [huella_dactilar]) VALUES (12, N'96917805fd060e3766a9a1b834639d35', N'96917805fd060e3766a9a1b834639d35')
INSERT [dbo].[datos_confidenciales] ([id_datos_confidenciales], [contrasena], [huella_dactilar]) VALUES (13, N'96917805fd060e3766a9a1b834639d35', N'96917805fd060e3766a9a1b834639d35')
INSERT [dbo].[datos_confidenciales] ([id_datos_confidenciales], [contrasena], [huella_dactilar]) VALUES (14, N'96917805fd060e3766a9a1b834639d35', N'96917805fd060e3766a9a1b834639d35')
INSERT [dbo].[datos_confidenciales] ([id_datos_confidenciales], [contrasena], [huella_dactilar]) VALUES (15, N'96917805fd060e3766a9a1b834639d35', N'96917805fd060e3766a9a1b834639d35')
INSERT [dbo].[datos_confidenciales] ([id_datos_confidenciales], [contrasena], [huella_dactilar]) VALUES (16, N'96917805fd060e3766a9a1b834639d35', N'96917805fd060e3766a9a1b834639d35')
INSERT [dbo].[datos_confidenciales] ([id_datos_confidenciales], [contrasena], [huella_dactilar]) VALUES (17, N'96917805fd060e3766a9a1b834639d35', N'96917805fd060e3766a9a1b834639d35')
INSERT [dbo].[datos_confidenciales] ([id_datos_confidenciales], [contrasena], [huella_dactilar]) VALUES (18, N'96917805fd060e3766a9a1b834639d35', N'96917805fd060e3766a9a1b834639d35')
INSERT [dbo].[datos_confidenciales] ([id_datos_confidenciales], [contrasena], [huella_dactilar]) VALUES (19, N'96917805fd060e3766a9a1b834639d35', N'96917805fd060e3766a9a1b834639d35')
INSERT [dbo].[datos_confidenciales] ([id_datos_confidenciales], [contrasena], [huella_dactilar]) VALUES (20, N'96917805fd060e3766a9a1b834639d35', N'96917805fd060e3766a9a1b834639d35')
INSERT [dbo].[datos_confidenciales] ([id_datos_confidenciales], [contrasena], [huella_dactilar]) VALUES (21, N'96917805fd060e3766a9a1b834639d35', N'96917805fd060e3766a9a1b834639d35')
INSERT [dbo].[datos_confidenciales] ([id_datos_confidenciales], [contrasena], [huella_dactilar]) VALUES (22, N'96917805fd060e3766a9a1b834639d35', N'96917805fd060e3766a9a1b834639d35')
INSERT [dbo].[datos_confidenciales] ([id_datos_confidenciales], [contrasena], [huella_dactilar]) VALUES (23, N'96917805fd060e3766a9a1b834639d35', N'96917805fd060e3766a9a1b834639d35')
INSERT [dbo].[datos_confidenciales] ([id_datos_confidenciales], [contrasena], [huella_dactilar]) VALUES (24, N'96917805fd060e3766a9a1b834639d35', N'96917805fd060e3766a9a1b834639d35')
INSERT [dbo].[datos_confidenciales] ([id_datos_confidenciales], [contrasena], [huella_dactilar]) VALUES (25, N'96917805fd060e3766a9a1b834639d35', N'96917805fd060e3766a9a1b834639d35')
INSERT [dbo].[datos_confidenciales] ([id_datos_confidenciales], [contrasena], [huella_dactilar]) VALUES (26, N'96917805fd060e3766a9a1b834639d35', N'96917805fd060e3766a9a1b834639d35')
INSERT [dbo].[datos_confidenciales] ([id_datos_confidenciales], [contrasena], [huella_dactilar]) VALUES (27, N'96917805fd060e3766a9a1b834639d35', N'96917805fd060e3766a9a1b834639d35')
INSERT [dbo].[datos_confidenciales] ([id_datos_confidenciales], [contrasena], [huella_dactilar]) VALUES (28, N'96917805fd060e3766a9a1b834639d35', N'96917805fd060e3766a9a1b834639d35')
INSERT [dbo].[datos_confidenciales] ([id_datos_confidenciales], [contrasena], [huella_dactilar]) VALUES (29, N'96917805fd060e3766a9a1b834639d35', N'96917805fd060e3766a9a1b834639d35')
INSERT [dbo].[datos_confidenciales] ([id_datos_confidenciales], [contrasena], [huella_dactilar]) VALUES (30, N'96917805fd060e3766a9a1b834639d35', N'96917805fd060e3766a9a1b834639d35')
SET IDENTITY_INSERT [dbo].[datos_confidenciales] OFF
SET IDENTITY_INSERT [dbo].[empleado] ON 

INSERT [dbo].[empleado] ([id_empleado], [nombre], [apellido], [tipo_doc], [documento], [e_mail], [telefono], [tipo], [id_nivel_seg], [id_datos_confidenciales]) VALUES (68, N'Georgi', N'Facello', N'DNI', 30123456, N'abc@gmail.com', N'5492235123456', N'Empleado jerárquico', 1, 1)
INSERT [dbo].[empleado] ([id_empleado], [nombre], [apellido], [tipo_doc], [documento], [e_mail], [telefono], [tipo], [id_nivel_seg], [id_datos_confidenciales]) VALUES (69, N'Bezalel', N'Simmel', N'DNI', 30123456, N'abc@gmail.com', N'5492235123456', N'Empleado jerárquico', 1, 2)
INSERT [dbo].[empleado] ([id_empleado], [nombre], [apellido], [tipo_doc], [documento], [e_mail], [telefono], [tipo], [id_nivel_seg], [id_datos_confidenciales]) VALUES (70, N'Parto', N'Bamford', N'DNI', 30123456, N'abc@gmail.com', N'5492235123456', N'Empleado jerárquico', 1, 3)
INSERT [dbo].[empleado] ([id_empleado], [nombre], [apellido], [tipo_doc], [documento], [e_mail], [telefono], [tipo], [id_nivel_seg], [id_datos_confidenciales]) VALUES (71, N'Chirstian', N'Koblick', N'DNI', 30123456, N'abc@gmail.com', N'5492235123456', N'Empleado jerárquico', 1, 4)
INSERT [dbo].[empleado] ([id_empleado], [nombre], [apellido], [tipo_doc], [documento], [e_mail], [telefono], [tipo], [id_nivel_seg], [id_datos_confidenciales]) VALUES (72, N'Kyoichi', N'Maliniak', N'DNI', 30123456, N'abc@gmail.com', N'5492235123456', N'Empleado jerárquico', 1, 5)
INSERT [dbo].[empleado] ([id_empleado], [nombre], [apellido], [tipo_doc], [documento], [e_mail], [telefono], [tipo], [id_nivel_seg], [id_datos_confidenciales]) VALUES (73, N'Anneke', N'Preusig', N'DNI', 30123456, N'abc@gmail.com', N'5492235123456', N'Empleado profesional', 1, 6)
INSERT [dbo].[empleado] ([id_empleado], [nombre], [apellido], [tipo_doc], [documento], [e_mail], [telefono], [tipo], [id_nivel_seg], [id_datos_confidenciales]) VALUES (74, N'Tzvetan', N'Zielinski', N'DNI', 30123456, N'abc@gmail.com', N'5492235123456', N'Empleado profesional', 1, 7)
INSERT [dbo].[empleado] ([id_empleado], [nombre], [apellido], [tipo_doc], [documento], [e_mail], [telefono], [tipo], [id_nivel_seg], [id_datos_confidenciales]) VALUES (75, N'Saniya', N'Kalloufi', N'DNI', 30123456, N'abc@gmail.com', N'5492235123456', N'Empleado profesional', 2, 8)
INSERT [dbo].[empleado] ([id_empleado], [nombre], [apellido], [tipo_doc], [documento], [e_mail], [telefono], [tipo], [id_nivel_seg], [id_datos_confidenciales]) VALUES (76, N'Sumant', N'Peac', N'DNI', 30123456, N'abc@gmail.com', N'5492235123456', N'Empleado profesional', 2, 9)
INSERT [dbo].[empleado] ([id_empleado], [nombre], [apellido], [tipo_doc], [documento], [e_mail], [telefono], [tipo], [id_nivel_seg], [id_datos_confidenciales]) VALUES (77, N'Duangkaew', N'Piveteau', N'DNI', 30123456, N'abc@gmail.com', N'5492235123456', N'Empleado profesional', 2, 10)
INSERT [dbo].[empleado] ([id_empleado], [nombre], [apellido], [tipo_doc], [documento], [e_mail], [telefono], [tipo], [id_nivel_seg], [id_datos_confidenciales]) VALUES (78, N'Mary', N'Sluis', N'DNI', 30123456, N'abc@gmail.com', N'5492235123456', N'Empleado profesional', 3, 11)
INSERT [dbo].[empleado] ([id_empleado], [nombre], [apellido], [tipo_doc], [documento], [e_mail], [telefono], [tipo], [id_nivel_seg], [id_datos_confidenciales]) VALUES (79, N'Patricio', N'Bridgland', N'DNI', 30123456, N'abc@gmail.com', N'5492235123456', N'Empleado profesional', 3, 12)
INSERT [dbo].[empleado] ([id_empleado], [nombre], [apellido], [tipo_doc], [documento], [e_mail], [telefono], [tipo], [id_nivel_seg], [id_datos_confidenciales]) VALUES (80, N'Eberhardt', N'Terkki', N'DNI', 30123456, N'abc@gmail.com', N'5492235123456', N'Empleado profesional', 2, 13)
INSERT [dbo].[empleado] ([id_empleado], [nombre], [apellido], [tipo_doc], [documento], [e_mail], [telefono], [tipo], [id_nivel_seg], [id_datos_confidenciales]) VALUES (81, N'Berni', N'Genin', N'DNI', 30123456, N'abc@gmail.com', N'5492235123456', N'Empleado profesional', 3, 14)
INSERT [dbo].[empleado] ([id_empleado], [nombre], [apellido], [tipo_doc], [documento], [e_mail], [telefono], [tipo], [id_nivel_seg], [id_datos_confidenciales]) VALUES (82, N'Guoxiang', N'Nooteboom', N'DNI', 30123456, N'abc@gmail.com', N'5492235123456', N'Empleado profesional', 2, 15)
INSERT [dbo].[empleado] ([id_empleado], [nombre], [apellido], [tipo_doc], [documento], [e_mail], [telefono], [tipo], [id_nivel_seg], [id_datos_confidenciales]) VALUES (83, N'Kazuhito', N'Cappelletti', N'DNI', 30123456, N'abc@gmail.com', N'5492235123456', N'Empleado profesional', 2, 16)
INSERT [dbo].[empleado] ([id_empleado], [nombre], [apellido], [tipo_doc], [documento], [e_mail], [telefono], [tipo], [id_nivel_seg], [id_datos_confidenciales]) VALUES (84, N'Cristinel', N'Bouloucos', N'DNI', 30123456, N'abc@gmail.com', N'5492235123456', N'Empleado profesional', 3, 17)
INSERT [dbo].[empleado] ([id_empleado], [nombre], [apellido], [tipo_doc], [documento], [e_mail], [telefono], [tipo], [id_nivel_seg], [id_datos_confidenciales]) VALUES (85, N'Kazuhide', N'Peha', N'DNI', 30123456, N'abc@gmail.com', N'5492235123456', N'Empleado profesional', 1, 18)
INSERT [dbo].[empleado] ([id_empleado], [nombre], [apellido], [tipo_doc], [documento], [e_mail], [telefono], [tipo], [id_nivel_seg], [id_datos_confidenciales]) VALUES (86, N'Lillian', N'Haddadi', N'DNI', 30123456, N'abc@gmail.com', N'5492235123456', N'Empleado profesional', 2, 19)
INSERT [dbo].[empleado] ([id_empleado], [nombre], [apellido], [tipo_doc], [documento], [e_mail], [telefono], [tipo], [id_nivel_seg], [id_datos_confidenciales]) VALUES (87, N'Mayuko', N'Warwick', N'DNI', 30123456, N'abc@gmail.com', N'5492235123456', N'Empleado no profesional', 2, 20)
INSERT [dbo].[empleado] ([id_empleado], [nombre], [apellido], [tipo_doc], [documento], [e_mail], [telefono], [tipo], [id_nivel_seg], [id_datos_confidenciales]) VALUES (88, N'Ramzi', N'Erde', N'DNI', 30123456, N'abc@gmail.com', N'5492235123456', N'Empleado no profesional', 3, 21)
INSERT [dbo].[empleado] ([id_empleado], [nombre], [apellido], [tipo_doc], [documento], [e_mail], [telefono], [tipo], [id_nivel_seg], [id_datos_confidenciales]) VALUES (89, N'Shahaf', N'Famili', N'DNI', 30123456, N'abc@gmail.com', N'5492235123456', N'Empleado no profesional', 3, 22)
INSERT [dbo].[empleado] ([id_empleado], [nombre], [apellido], [tipo_doc], [documento], [e_mail], [telefono], [tipo], [id_nivel_seg], [id_datos_confidenciales]) VALUES (90, N'Bojan', N'Montemayor', N'DNI', 30123456, N'abc@gmail.com', N'5492235123456', N'Empleado no profesional', 1, 23)
INSERT [dbo].[empleado] ([id_empleado], [nombre], [apellido], [tipo_doc], [documento], [e_mail], [telefono], [tipo], [id_nivel_seg], [id_datos_confidenciales]) VALUES (91, N'Suzette', N'Pettey', N'DNI', 30123456, N'abc@gmail.com', N'5492235123456', N'Empleado no profesional', 2, 24)
INSERT [dbo].[empleado] ([id_empleado], [nombre], [apellido], [tipo_doc], [documento], [e_mail], [telefono], [tipo], [id_nivel_seg], [id_datos_confidenciales]) VALUES (92, N'Prasadram', N'Heyers', N'DNI', 30123456, N'abc@gmail.com', N'5492235123456', N'Empleado no profesional', 2, 25)
INSERT [dbo].[empleado] ([id_empleado], [nombre], [apellido], [tipo_doc], [documento], [e_mail], [telefono], [tipo], [id_nivel_seg], [id_datos_confidenciales]) VALUES (93, N'Yongqiao', N'Berztiss', N'DNI', 30123456, N'abc@gmail.com', N'5492235123456', N'Empleado no profesional', 2, 26)
INSERT [dbo].[empleado] ([id_empleado], [nombre], [apellido], [tipo_doc], [documento], [e_mail], [telefono], [tipo], [id_nivel_seg], [id_datos_confidenciales]) VALUES (94, N'Divier', N'Reistad', N'DNI', 30123456, N'abc@gmail.com', N'5492235123456', N'Empleado no profesional', 3, 27)
INSERT [dbo].[empleado] ([id_empleado], [nombre], [apellido], [tipo_doc], [documento], [e_mail], [telefono], [tipo], [id_nivel_seg], [id_datos_confidenciales]) VALUES (95, N'Domenick', N'Tempesti', N'DNI', 30123456, N'abc@gmail.com', N'5492235123456', N'Empleado no profesional', 3, 28)
INSERT [dbo].[empleado] ([id_empleado], [nombre], [apellido], [tipo_doc], [documento], [e_mail], [telefono], [tipo], [id_nivel_seg], [id_datos_confidenciales]) VALUES (96, N'Otmar', N'Herbst', N'DNI', 30123456, N'abc@gmail.com', N'5492235123456', N'Empleado no profesional', 2, 29)
INSERT [dbo].[empleado] ([id_empleado], [nombre], [apellido], [tipo_doc], [documento], [e_mail], [telefono], [tipo], [id_nivel_seg], [id_datos_confidenciales]) VALUES (97, N'Elvis', N'Demeyer', N'DNI', 30123456, N'abc@gmail.com', N'5492235123456', N'Empleado no profesional', 1, 30)
SET IDENTITY_INSERT [dbo].[empleado] OFF
INSERT [dbo].[empleado_jerarquico] ([id_empleado], [num_area], [fecha_asignacion]) VALUES (68, 1, CAST(N'2018-05-20' AS Date))
INSERT [dbo].[empleado_jerarquico] ([id_empleado], [num_area], [fecha_asignacion]) VALUES (69, 2, CAST(N'2016-11-14' AS Date))
INSERT [dbo].[empleado_jerarquico] ([id_empleado], [num_area], [fecha_asignacion]) VALUES (70, 3, CAST(N'2013-01-07' AS Date))
INSERT [dbo].[empleado_jerarquico] ([id_empleado], [num_area], [fecha_asignacion]) VALUES (71, 4, CAST(N'2017-08-23' AS Date))
INSERT [dbo].[empleado_jerarquico] ([id_empleado], [num_area], [fecha_asignacion]) VALUES (72, 5, CAST(N'2012-09-29' AS Date))
INSERT [dbo].[empleado_no_profesional] ([id_empleado]) VALUES (87)
INSERT [dbo].[empleado_no_profesional] ([id_empleado]) VALUES (88)
INSERT [dbo].[empleado_no_profesional] ([id_empleado]) VALUES (89)
INSERT [dbo].[empleado_no_profesional] ([id_empleado]) VALUES (90)
INSERT [dbo].[empleado_no_profesional] ([id_empleado]) VALUES (91)
INSERT [dbo].[empleado_no_profesional] ([id_empleado]) VALUES (92)
INSERT [dbo].[empleado_no_profesional] ([id_empleado]) VALUES (93)
INSERT [dbo].[empleado_no_profesional] ([id_empleado]) VALUES (94)
INSERT [dbo].[empleado_no_profesional] ([id_empleado]) VALUES (95)
INSERT [dbo].[empleado_no_profesional] ([id_empleado]) VALUES (96)
INSERT [dbo].[empleado_no_profesional] ([id_empleado]) VALUES (97)
INSERT [dbo].[empleado_prof_contratado] ([id_empleado]) VALUES (79)
INSERT [dbo].[empleado_prof_contratado] ([id_empleado]) VALUES (80)
INSERT [dbo].[empleado_prof_contratado] ([id_empleado]) VALUES (81)
INSERT [dbo].[empleado_prof_contratado] ([id_empleado]) VALUES (82)
INSERT [dbo].[empleado_prof_contratado] ([id_empleado]) VALUES (83)
INSERT [dbo].[empleado_prof_contratado] ([id_empleado]) VALUES (84)
INSERT [dbo].[empleado_prof_contratado] ([id_empleado]) VALUES (85)
INSERT [dbo].[empleado_prof_contratado] ([id_empleado]) VALUES (86)
INSERT [dbo].[empleado_prof_permanente] ([id_empleado], [num_area]) VALUES (73, 2)
INSERT [dbo].[empleado_prof_permanente] ([id_empleado], [num_area]) VALUES (74, 4)
INSERT [dbo].[empleado_prof_permanente] ([id_empleado], [num_area]) VALUES (75, 5)
INSERT [dbo].[empleado_prof_permanente] ([id_empleado], [num_area]) VALUES (76, 2)
INSERT [dbo].[empleado_prof_permanente] ([id_empleado], [num_area]) VALUES (77, 1)
INSERT [dbo].[empleado_prof_permanente] ([id_empleado], [num_area]) VALUES (78, 3)
INSERT [dbo].[empleado_profesional] ([id_empleado], [tipo]) VALUES (73, N'EPPermanente')
INSERT [dbo].[empleado_profesional] ([id_empleado], [tipo]) VALUES (74, N'EPPermanente')
INSERT [dbo].[empleado_profesional] ([id_empleado], [tipo]) VALUES (75, N'EPPermanente')
INSERT [dbo].[empleado_profesional] ([id_empleado], [tipo]) VALUES (76, N'EPPermanente')
INSERT [dbo].[empleado_profesional] ([id_empleado], [tipo]) VALUES (77, N'EPPermanente')
INSERT [dbo].[empleado_profesional] ([id_empleado], [tipo]) VALUES (78, N'EPPermanente')
INSERT [dbo].[empleado_profesional] ([id_empleado], [tipo]) VALUES (79, N'EPContratado')
INSERT [dbo].[empleado_profesional] ([id_empleado], [tipo]) VALUES (80, N'EPContratado')
INSERT [dbo].[empleado_profesional] ([id_empleado], [tipo]) VALUES (81, N'EPContratado')
INSERT [dbo].[empleado_profesional] ([id_empleado], [tipo]) VALUES (82, N'EPContratado')
INSERT [dbo].[empleado_profesional] ([id_empleado], [tipo]) VALUES (83, N'EPContratado')
INSERT [dbo].[empleado_profesional] ([id_empleado], [tipo]) VALUES (84, N'EPContratado')
INSERT [dbo].[empleado_profesional] ([id_empleado], [tipo]) VALUES (85, N'EPContratado')
INSERT [dbo].[empleado_profesional] ([id_empleado], [tipo]) VALUES (86, N'EPContratado')
SET IDENTITY_INSERT [dbo].[franja_horaria] ON 

INSERT [dbo].[franja_horaria] ([id_franja], [horario_inicio], [horario_fin]) VALUES (5, CAST(N'08:00:00' AS Time), CAST(N'15:59:59' AS Time))
INSERT [dbo].[franja_horaria] ([id_franja], [horario_inicio], [horario_fin]) VALUES (6, CAST(N'16:00:00' AS Time), CAST(N'23:59:59' AS Time))
INSERT [dbo].[franja_horaria] ([id_franja], [horario_inicio], [horario_fin]) VALUES (7, CAST(N'00:00:00' AS Time), CAST(N'07:59:59' AS Time))
SET IDENTITY_INSERT [dbo].[franja_horaria] OFF
SET IDENTITY_INSERT [dbo].[nivel_seguridad] ON 

INSERT [dbo].[nivel_seguridad] ([id_nivel_seg], [nombre], [categoria], [descripcion]) VALUES (1, N'Alto', N'Registrado', N'Bla bla')
INSERT [dbo].[nivel_seguridad] ([id_nivel_seg], [nombre], [categoria], [descripcion]) VALUES (2, N'Medio', N'Registrado', N'Bla bla')
INSERT [dbo].[nivel_seguridad] ([id_nivel_seg], [nombre], [categoria], [descripcion]) VALUES (3, N'Bajo', N'NoRegistrado', N'Bla bla')
SET IDENTITY_INSERT [dbo].[nivel_seguridad] OFF
SET IDENTITY_INSERT [dbo].[trabajo] ON 

INSERT [dbo].[trabajo] ([id_trabajo], [descripcion]) VALUES (1, N'Mantenimiento de instalaciones')
INSERT [dbo].[trabajo] ([id_trabajo], [descripcion]) VALUES (2, N'Reemplazo de mobiliario')
INSERT [dbo].[trabajo] ([id_trabajo], [descripcion]) VALUES (3, N'Compra de materiales')
INSERT [dbo].[trabajo] ([id_trabajo], [descripcion]) VALUES (4, N'Limpieza del área')
INSERT [dbo].[trabajo] ([id_trabajo], [descripcion]) VALUES (5, N'Digitalización de documentos')
INSERT [dbo].[trabajo] ([id_trabajo], [descripcion]) VALUES (6, N'Capacitación de personal')
INSERT [dbo].[trabajo] ([id_trabajo], [descripcion]) VALUES (7, N'Supervisión de trabajo')
SET IDENTITY_INSERT [dbo].[trabajo] OFF
ALTER TABLE [dbo].[acceso]  WITH CHECK ADD  CONSTRAINT [FK_acceso_id_empleado] FOREIGN KEY([id_empleado])
REFERENCES [dbo].[empleado_no_profesional] ([id_empleado])
GO
ALTER TABLE [dbo].[acceso] CHECK CONSTRAINT [FK_acceso_id_empleado]
GO
ALTER TABLE [dbo].[acceso]  WITH CHECK ADD  CONSTRAINT [FK_acceso_id_franja] FOREIGN KEY([id_franja])
REFERENCES [dbo].[franja_horaria] ([id_franja])
GO
ALTER TABLE [dbo].[acceso] CHECK CONSTRAINT [FK_acceso_id_franja]
GO
ALTER TABLE [dbo].[acceso]  WITH CHECK ADD  CONSTRAINT [FK_acceso_num_area] FOREIGN KEY([num_area])
REFERENCES [dbo].[area] ([num_area])
GO
ALTER TABLE [dbo].[acceso] CHECK CONSTRAINT [FK_acceso_num_area]
GO
ALTER TABLE [dbo].[area]  WITH CHECK ADD  CONSTRAINT [FK_area_id_nivel_seg] FOREIGN KEY([id_nivel_seg])
REFERENCES [dbo].[nivel_seguridad] ([id_nivel_seg])
GO
ALTER TABLE [dbo].[area] CHECK CONSTRAINT [FK_area_id_nivel_seg]
GO
ALTER TABLE [dbo].[auditoria]  WITH CHECK ADD  CONSTRAINT [FK_auditoria_id_trabajo] FOREIGN KEY([id_trabajo])
REFERENCES [dbo].[trabajo] ([id_trabajo])
GO
ALTER TABLE [dbo].[auditoria] CHECK CONSTRAINT [FK_auditoria_id_trabajo]
GO
ALTER TABLE [dbo].[contratado_en]  WITH CHECK ADD  CONSTRAINT [FK_contratado_en_id_empleado] FOREIGN KEY([id_empleado])
REFERENCES [dbo].[empleado_prof_contratado] ([id_empleado])
GO
ALTER TABLE [dbo].[contratado_en] CHECK CONSTRAINT [FK_contratado_en_id_empleado]
GO
ALTER TABLE [dbo].[contratado_en]  WITH CHECK ADD  CONSTRAINT [FK_contratado_en_id_trabajo] FOREIGN KEY([id_trabajo])
REFERENCES [dbo].[trabajo] ([id_trabajo])
GO
ALTER TABLE [dbo].[contratado_en] CHECK CONSTRAINT [FK_contratado_en_id_trabajo]
GO
ALTER TABLE [dbo].[contratado_en]  WITH CHECK ADD  CONSTRAINT [FK_contratado_en_num_area] FOREIGN KEY([num_area])
REFERENCES [dbo].[area] ([num_area])
GO
ALTER TABLE [dbo].[contratado_en] CHECK CONSTRAINT [FK_contratado_en_num_area]
GO
ALTER TABLE [dbo].[empleado]  WITH CHECK ADD  CONSTRAINT [FK_empleado_id_datos_confidenciales] FOREIGN KEY([id_datos_confidenciales])
REFERENCES [dbo].[datos_confidenciales] ([id_datos_confidenciales])
GO
ALTER TABLE [dbo].[empleado] CHECK CONSTRAINT [FK_empleado_id_datos_confidenciales]
GO
ALTER TABLE [dbo].[empleado]  WITH CHECK ADD  CONSTRAINT [FK_empleado_id_nivel_seg] FOREIGN KEY([id_nivel_seg])
REFERENCES [dbo].[nivel_seguridad] ([id_nivel_seg])
GO
ALTER TABLE [dbo].[empleado] CHECK CONSTRAINT [FK_empleado_id_nivel_seg]
GO
ALTER TABLE [dbo].[empleado_jerarquico]  WITH CHECK ADD  CONSTRAINT [FK_empleado_jerarquico_id_empleado] FOREIGN KEY([id_empleado])
REFERENCES [dbo].[empleado] ([id_empleado])
GO
ALTER TABLE [dbo].[empleado_jerarquico] CHECK CONSTRAINT [FK_empleado_jerarquico_id_empleado]
GO
ALTER TABLE [dbo].[empleado_jerarquico]  WITH CHECK ADD  CONSTRAINT [FK_empleado_jerarquico_num_area] FOREIGN KEY([num_area])
REFERENCES [dbo].[area] ([num_area])
GO
ALTER TABLE [dbo].[empleado_jerarquico] CHECK CONSTRAINT [FK_empleado_jerarquico_num_area]
GO
ALTER TABLE [dbo].[empleado_no_profesional]  WITH CHECK ADD  CONSTRAINT [FK_empleado_no_profesional_id_empleado] FOREIGN KEY([id_empleado])
REFERENCES [dbo].[empleado] ([id_empleado])
GO
ALTER TABLE [dbo].[empleado_no_profesional] CHECK CONSTRAINT [FK_empleado_no_profesional_id_empleado]
GO
ALTER TABLE [dbo].[empleado_prof_contratado]  WITH CHECK ADD  CONSTRAINT [FK_empleado_prof_contratado_id_empleado] FOREIGN KEY([id_empleado])
REFERENCES [dbo].[empleado_profesional] ([id_empleado])
GO
ALTER TABLE [dbo].[empleado_prof_contratado] CHECK CONSTRAINT [FK_empleado_prof_contratado_id_empleado]
GO
ALTER TABLE [dbo].[empleado_prof_permanente]  WITH CHECK ADD  CONSTRAINT [FK_empleado_prof_permanente_id_empleado] FOREIGN KEY([id_empleado])
REFERENCES [dbo].[empleado_profesional] ([id_empleado])
GO
ALTER TABLE [dbo].[empleado_prof_permanente] CHECK CONSTRAINT [FK_empleado_prof_permanente_id_empleado]
GO
ALTER TABLE [dbo].[empleado_prof_permanente]  WITH CHECK ADD  CONSTRAINT [FK_empleado_prof_permanente_num_area] FOREIGN KEY([num_area])
REFERENCES [dbo].[area] ([num_area])
GO
ALTER TABLE [dbo].[empleado_prof_permanente] CHECK CONSTRAINT [FK_empleado_prof_permanente_num_area]
GO
ALTER TABLE [dbo].[empleado_profesional]  WITH CHECK ADD  CONSTRAINT [FK_empleado_profesional_id_empleado] FOREIGN KEY([id_empleado])
REFERENCES [dbo].[empleado] ([id_empleado])
GO
ALTER TABLE [dbo].[empleado_profesional] CHECK CONSTRAINT [FK_empleado_profesional_id_empleado]
GO
ALTER TABLE [dbo].[evento]  WITH CHECK ADD  CONSTRAINT [FK_evento_num_area] FOREIGN KEY([num_area])
REFERENCES [dbo].[area] ([num_area])
GO
ALTER TABLE [dbo].[evento] CHECK CONSTRAINT [FK_evento_num_area]
GO
ALTER TABLE [dbo].[registro]  WITH CHECK ADD  CONSTRAINT [FK_registro_id_empleado] FOREIGN KEY([id_empleado])
REFERENCES [dbo].[empleado] ([id_empleado])
GO
ALTER TABLE [dbo].[registro] CHECK CONSTRAINT [FK_registro_id_empleado]
GO
ALTER TABLE [dbo].[registro]  WITH CHECK ADD  CONSTRAINT [FK_registro_num_area] FOREIGN KEY([num_area])
REFERENCES [dbo].[area] ([num_area])
GO
ALTER TABLE [dbo].[registro] CHECK CONSTRAINT [FK_registro_num_area]
GO
/****** Object:  StoredProcedure [dbo].[consulta_1]    Script Date: 24/11/2018 18:38:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- 1 - Consulta (división con la forma enseñada por Leticia)
CREATE   PROCEDURE [dbo].[consulta_1]
AS
SELECT empleado.nombre, empleado.apellido, empleado.id_empleado 
FROM   empleado 
WHERE  NOT EXISTS (SELECT * 
                   FROM area 
                   WHERE NOT EXISTS (SELECT * 
                                     FROM acceso 
                                     WHERE acceso.id_empleado = empleado.id_empleado AND
                                           acceso.num_area = area.num_area));
GO
/****** Object:  StoredProcedure [dbo].[consulta_3]    Script Date: 24/11/2018 18:38:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[consulta_3]
AS
SELECT empleado.id_empleado, empleado.nombre, empleado.apellido, empleado.documento
FROM empleado
INNER JOIN registro ON empleado.id_empleado = registro.id_empleado
INNER JOIN area ON registro.num_area = area.num_area
INNER JOIN nivel_seguridad NE ON empleado.id_nivel_seg = NE.id_nivel_seg
INNER JOIN nivel_seguridad NA ON area.num_area = NA.id_nivel_seg
WHERE DATEDIFF(DAY, CONVERT(date, registro.fecha_hora, 101), GETDATE()) <= 30
      AND (NE.nombre = 'Alto' OR (NE.nombre = 'Medio' AND NA.nombre = 'Medio')) --Error contraseña
	  AND registro.autorizado = 'No'
GROUP BY empleado.id_empleado, empleado.nombre, empleado.apellido, empleado.documento
HAVING COUNT(*) > 5

UNION

SELECT empleado.id_empleado, empleado.nombre, empleado.apellido, empleado.documento
FROM empleado
INNER JOIN registro ON empleado.id_empleado = registro.id_empleado AND empleado.id_nivel_seg <> '1'
INNER JOIN area ON registro.num_area = area.num_area
INNER JOIN nivel_seguridad NE ON empleado.id_nivel_seg = NE.id_nivel_seg
INNER JOIN nivel_seguridad NA ON area.num_area = NA.id_nivel_seg
WHERE DATEDIFF(DAY, CONVERT(date, registro.fecha_hora, 101), GETDATE()) <= 30
      AND registro.autorizado = 'No'
	  AND ((NE.nombre = 'Bajo' AND (NA.nombre = 'Medio' OR NA.nombre = 'Alto'))
            OR (NE.nombre = 'Medio' AND NA.nombre = 'Alto'))
GO
USE [master]
GO
ALTER DATABASE [laboratorio] SET  READ_WRITE 
GO
