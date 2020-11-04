/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2008                    */
/* Created on:     18/10/2020 16:33:29                          */
/*==============================================================*/


if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('AMIGO') and o.name = 'FK_AMIGO_REFERENCE_USUARIO2')
alter table AMIGO
   drop constraint FK_AMIGO_REFERENCE_USUARIO2
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('AMIGO') and o.name = 'FK_AMIGO_REFERENCE_USUARIO')
alter table AMIGO
   drop constraint FK_AMIGO_REFERENCE_USUARIO
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('BITACORA') and o.name = 'FK_BITACORA_REFERENCE_PUBLICAC')
alter table BITACORA
   drop constraint FK_BITACORA_REFERENCE_PUBLICAC
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('BITACORA') and o.name = 'FK_BITACORA_REFERENCE_USUARIO')
alter table BITACORA
   drop constraint FK_BITACORA_REFERENCE_USUARIO
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('BITACORA') and o.name = 'FK_BITACORA_REFERENCE_TIPO_ACC')
alter table BITACORA
   drop constraint FK_BITACORA_REFERENCE_TIPO_ACC
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('COMENTARIO') and o.name = 'FK_COMENTAR_REFERENCE_PUBLICAC2')
alter table COMENTARIO
   drop constraint FK_COMENTAR_REFERENCE_PUBLICAC2
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('COMENTARIO') and o.name = 'FK_COMENTAR_REFERENCE_PUBLICAC')
alter table COMENTARIO
   drop constraint FK_COMENTAR_REFERENCE_PUBLICAC
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('PUBLICACION') and o.name = 'FK_PUBLICAC_REFERENCE_TIPO_PUB')
alter table PUBLICACION
   drop constraint FK_PUBLICAC_REFERENCE_TIPO_PUB
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('PUBLICACION') and o.name = 'FK_PUBLICAC_REFERENCE_USUARIO')
alter table PUBLICACION
   drop constraint FK_PUBLICAC_REFERENCE_USUARIO
go

if exists (select 1
   from sys.sysreferences r join sys.sysobjects o on (o.id = r.constid and o.type = 'F')
   where r.fkeyid = object_id('PUBLICACION') and o.name = 'FK_PUBLICAC_REFERENCE_DISPOSIT')
alter table PUBLICACION
   drop constraint FK_PUBLICAC_REFERENCE_DISPOSIT
go

if exists (select 1
            from  sysobjects
           where  id = object_id('AMIGO')
            and   type = 'U')
   drop table AMIGO
go

if exists (select 1
            from  sysobjects
           where  id = object_id('BITACORA')
            and   type = 'U')
   drop table BITACORA
go

if exists (select 1
            from  sysobjects
           where  id = object_id('COMENTARIO')
            and   type = 'U')
   drop table COMENTARIO
go

if exists (select 1
            from  sysobjects
           where  id = object_id('DISPOSITIVO')
            and   type = 'U')
   drop table DISPOSITIVO
go

if exists (select 1
            from  sysobjects
           where  id = object_id('PUBLICACION')
            and   type = 'U')
   drop table PUBLICACION
go

if exists (select 1
            from  sysobjects
           where  id = object_id('TIPO_ACCION')
            and   type = 'U')
   drop table TIPO_ACCION
go

if exists (select 1
            from  sysobjects
           where  id = object_id('TIPO_PUBLICACION')
            and   type = 'U')
   drop table TIPO_PUBLICACION
go

if exists (select 1
            from  sysobjects
           where  id = object_id('USUARIO')
            and   type = 'U')
   drop table USUARIO
go

/*==============================================================*/
/* Table: AMIGO                                                 */
/*==============================================================*/
create table AMIGO (
   ID_USUARIO           int                  not null,
   ID_AMIGO             int                  not null,
   ID_AMISTAD           int identity(1,1)    not null,
   constraint PK_AMIGO primary key (ID_AMISTAD)
)
go

/*==============================================================*/
/* Table: BITACORA                                              */
/*==============================================================*/
create table BITACORA (
   ID_BITACORA          int identity(1,1)    not null,
   ID_PUBLICACION       int                  not null,
   ID_USUARIO           int                  not null,
   ID_TIPO_ACCION       int                  not null,
   FECHA_HORA           datetime             not null,
   constraint PK_BITACORA primary key (ID_BITACORA)
)
go

/*==============================================================*/
/* Table: COMENTARIO                                            */
/*==============================================================*/
create table COMENTARIO (
   ID_COMENTARIO        int     not null,
   ID_PUBLICACION_REF   int                  not null,
   ACTIVO               bit                  not null,
   constraint PK_COMENTARIO primary key (ID_COMENTARIO)
)
go


/*==============================================================*/
/* Table: DISPOSITIVO                                           */
/*==============================================================*/
create table DISPOSITIVO (
   ID_DISPOSITIVO       int identity(1,1)    not null,
   NOMBRE               nvarchar(50)         not null,
   constraint PK_DISPOSITIVO primary key (ID_DISPOSITIVO)
)
go

/*==============================================================*/
/* Table: PUBLICACION                                           */
/*==============================================================*/
create table PUBLICACION (
   ID_PUBLICACION       int identity(1,1)    not null,
   ID_DISPOSITIVO       int                  not null,
   ID_TIPO_PUBLICACION  int                  not null,
   ID_USUARIO           int                  not null,
   FECHA_HORA           datetime             not null,
   CONTENIDO            nvarchar(500)        not null,
   IP                   nvarchar(20)         not null,
   constraint PK_PUBLICACION primary key (ID_PUBLICACION)
)
go

/*==============================================================*/
/* Table: TIPO_ACCION                                           */
/*==============================================================*/
create table TIPO_ACCION (
   ID_TIPO_ACCION       int identity(1,1)    not null,
   ACCION               nvarchar(50)         not null,
   constraint PK_TIPO_ACCION primary key (ID_TIPO_ACCION)
)
go

/*==============================================================*/
/* Table: TIPO_PUBLICACION                                      */
/*==============================================================*/
create table TIPO_PUBLICACION (
   ID_TIPO_PUBLICACION  int identity(1,1)    not null,
   TIPO                 nvarchar(50)         not null,
   constraint PK_TIPO_PUBLICACION primary key (ID_TIPO_PUBLICACION)
)
go

/*==============================================================*/
/* Table: USUARIO                                               */
/*==============================================================*/
create table USUARIO (
   ID_USUARIO           int identity(1,1)    not null,
   CORREO               nvarchar(50)         unique not null,
   NOMBRE1              nvarchar(50)         not null,
   NOMBRE2              nvarchar(50)         null,
   APELLIDO1            nvarchar(50)         not null,
   APELLIDO2            nvarchar(50)         null,
   FECHA_DE_NACIMIENT   date                 not null,
   CONTRASENA           nvarchar(50)         not null,
   CANT_MAX_AMIGOS      int                  not null,
   FECHA_CREACION		date			not null,
   constraint PK_USUARIO primary key (ID_USUARIO)
)
go



alter table AMIGO
   add constraint FK_AMIGO_REFERENCE_USUARIO2 foreign key (ID_USUARIO)
      references USUARIO (ID_USUARIO)
go

alter table AMIGO
   add constraint FK_AMIGO_REFERENCE_USUARIO foreign key (ID_AMIGO)
      references USUARIO (ID_USUARIO)
go

alter table BITACORA
   add constraint FK_BITACORA_REFERENCE_PUBLICAC foreign key (ID_PUBLICACION)
      references PUBLICACION (ID_PUBLICACION)
go

alter table BITACORA
   add constraint FK_BITACORA_REFERENCE_USUARIO foreign key (ID_USUARIO)
      references USUARIO (ID_USUARIO)
go

alter table BITACORA
   add constraint FK_BITACORA_REFERENCE_TIPO_ACC foreign key (ID_TIPO_ACCION)
      references TIPO_ACCION (ID_TIPO_ACCION)
go

alter table COMENTARIO
   add constraint FK_COMENTAR_REFERENCE_PUBLICAC2 foreign key (ID_COMENTARIO)
      references PUBLICACION (ID_PUBLICACION)
go

alter table COMENTARIO
   add constraint FK_COMENTAR_REFERENCE_PUBLICAC foreign key (ID_PUBLICACION_REF)
      references PUBLICACION (ID_PUBLICACION)
go

alter table PUBLICACION
   add constraint FK_PUBLICAC_REFERENCE_TIPO_PUB foreign key (ID_TIPO_PUBLICACION)
      references TIPO_PUBLICACION (ID_TIPO_PUBLICACION)
go

alter table PUBLICACION
   add constraint FK_PUBLICAC_REFERENCE_USUARIO foreign key (ID_USUARIO)
      references USUARIO (ID_USUARIO)
go

alter table PUBLICACION
   add constraint FK_PUBLICAC_REFERENCE_DISPOSIT foreign key (ID_DISPOSITIVO)
      references DISPOSITIVO (ID_DISPOSITIVO)
go
