# Expense Tracker App

Una aplicación de seguimiento de gastos con frontend en Flutter, backend en Django, base de datos MySQL y comunicación mediante WebSockets.

## Índice
1. [Requisitos previos](#requisitos-previos)
2. [Estructura del proyecto](#estructura-del-proyecto)
3. [Configuración del entorno](#configuración-del-entorno)
4. [Construcción y ejecución de los contenedores](#construcción-y-ejecución-de-los-contenedores)
5. [Verificación y pruebas](#verificación-y-pruebas)
6. [Detalles adicionales](#detalles-adicionales)

## Requisitos previos

Antes de empezar, asegúrate de tener instalados los siguientes programas:

- [Docker](https://www.docker.com/get-started)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [Git](https://git-scm.com/)
- [Flutter](https://flutter.dev/docs/get-started/install) (para desarrollo y compilación del frontend)

## Estructura del proyecto

El proyecto está organizado de la siguiente manera:

Posee una carpeta que contiene todo en Frontend en Flutter, organizado bajo la estructura típica del Framework. En cuanto al Backend, se organiza a partir del componente base que tiene el mismo nombre de la carpeta, y sigue la estructura de Django.

## Configuración del entorno

### 1. Clonar el repositorio

git clone https://github.com/Frank5005/Taller2ArquitecturaSoftware.git

cd Taller2ArquitecturaSoftware

### 2. Configurar las variables de entorno

Crea un archivo .env en el directorio backend con el siguiente contenido:

DATABASE_NAME=presarqui
DATABASE_USER=admin1
DATABASE_PASSWORD=12345678
DATABASE_HOST=db
DATABASE_PORT=3306
DJANGO_SETTINGS_MODULE=expense_tracker_backend.settings

### 3. Configurar settings.py en el backend

Asegúrate de que settings.py en Django esté configurado para utilizar las variables de entorno:

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': os.getenv('DATABASE_NAME'),
        'USER': os.getenv('DATABASE_USER'),
        'PASSWORD': os.getenv('DATABASE_PASSWORD'),
        'HOST': os.getenv('DATABASE_HOST'),
        'PORT': os.getenv('DATABASE_PORT'),
    }
}


## Construcción y ejecución de los contenedores

### 1. Construir los contenedores

docker-compose build

### 2. Ejecutar los contenedores

docker-compose up

Esto iniciará los servicios de:

MySQL en el puerto 3307,
Django en el puerto 8094 y 
Flutter (Nginx) en el puerto 8094

### 3. Migrar la base de datos de Django

En otra terminal, ejecuta el siguiente comando:

docker-compose exec django python manage.py migrate

### 4. Crear un superusuario en Django

docker-compose exec django python manage.py createsuperuser

Sigue las instrucciones para crear el superusuario.

## Verificación y pruebas

### 1. Acceder a la aplicación Flutter
Abre un navegador y visita: http://localhost:8094.

### 2. Acceder al backend de Django
Para acceder a la administración de Django, visita: http://localhost:8094/admin/ e inicia sesión con el superusuario creado.

### 3. Verificar la conexión de WebSockets
Asegúrate de que los mensajes de WebSocket se están enviando y recibiendo correctamente. Puedes usar herramientas como WebSocket Test Client para verificar la conexión.

## Detalles adicionales

### Configuración de CORS

Asegúrate de tener configurado django-cors-headers en settings.py:

INSTALLED_APPS = [
    ...
    'corsheaders',
]

MIDDLEWARE = [
    'corsheaders.middleware.CorsMiddleware',
    ...
]

CORS_ALLOWED_ORIGINS = [
    'http://localhost:8094',  # Flutter frontend
    'http://127.0.0.1:8094',
]

### Configuración de WebSocket en Flutter

En tu archivo de servicio de WebSocket en Flutter, usa la URL correcta:

final websocketService = WebSocketService();
websocketService.connect('ws://localhost:8094/ws/expenses/');

### Despliegue en producción

Para el despliegue en un entorno de producción, asegúrate de:

- Usar gunicorn o daphne con nginx para servir Django.
- Utilizar wss:// para conexiones seguras de WebSocket.
- Asegurarte de que las variables de entorno estén correctamente configuradas.










