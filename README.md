# Reserva de horas médicas – Proyecto DevOps integrador

Servicio web **estático** de reserva de horas médicas para una clínica ficticia (*Clínica Vida Sana*), servido con **Nginx** dentro de un contenedor **Docker**. Proyecto académico de la asignatura DevOps (IACC 2026).

> El sitio es una simulación: **no** tiene API ni base de datos, y el formulario no envía ni guarda información.

## Contexto

La empresa administra una plataforma de reserva de horas médicas. Las entregas se instalaban manualmente y una versión podía funcionar en el equipo del desarrollador pero fallar en el servidor de pruebas. Este proyecto aplica prácticas DevOps (control de versiones, contenedores, automatización, trazabilidad y monitoreo) para obtener un entorno **local y reproducible**.

## Estructura del proyecto

```text
reserva-horas-medicas/
├── src/
│   ├── index.html            # Página con formulario, datos de atención y estado del servicio
│   └── styles.css            # Hoja de estilos
├── Dockerfile                # Imagen basada en nginx:alpine
├── docker-compose.yml        # Levanta el servicio en el puerto 8080
├── .env.example              # Variables de ejemplo (sin valores sensibles)
├── .gitignore                # Archivos que no se versionan
├── README.md
└── .github/workflows/
    └── devops-automation.yml # (Complementario) validación con GitHub Actions
```

## Requisitos previos

- Git instalado y configurado
- Docker Desktop instalado e iniciado
- Navegador web
- (Opcional) Visual Studio Code

## Instalación

```bash
git clone https://github.com/manuelpc44-prog/reserva-horas-medicas.git
cd reserva-horas-medicas
cp .env.example .env      # Opcional: solo si deseas cambiar el puerto
```

En Windows (PowerShell) usa `Copy-Item .env.example .env`.

## Ejecución

```bash
docker compose up -d --build
```

Esto construye la imagen `nginx:alpine` con los archivos de `src/`, crea el contenedor `reserva-horas-web` y publica el servicio en el puerto 8080.

## Verificación

```bash
docker compose ps                 # Estado del servicio (debe aparecer "running" / "healthy")
curl -I http://localhost:8080     # Debe responder HTTP/1.1 200 OK
```

Abre en el navegador: **http://localhost:8080**

## Monitoreo básico local

```bash
docker compose logs               # Logs de Nginx (accesos y errores)
docker logs reserva-horas-web     # Logs del contenedor por nombre
docker stats --no-stream          # CPU y memoria en un instante
docker ps                         # Contenedores activos
```

También puedes ver logs y métricas desde la pestaña *Containers* de Docker Desktop.

## Detener y limpiar

```bash
docker compose down               # Detiene y elimina contenedor y red
docker image rm reserva-horas-medicas:1.0.0   # (Opcional) elimina la imagen
```

## Buenas prácticas de seguridad aplicadas

- No se publican credenciales, tokens, claves ni datos personales; el formulario usa solo datos ficticios.
- `.env` real está en `.gitignore`; solo se versiona `.env.example` sin valores sensibles.
- Imagen mínima `nginx:alpine` (menor superficie de ataque).
- `no-new-privileges` activado en el contenedor.
- La versión de la imagen está etiquetada (`1.0.0`) para facilitar la trazabilidad.
- El flujo de GitHub Actions usa permisos mínimos (`contents: read`) y verifica que `.env` no esté versionado.
- Antes de cada commit se revisa `git status` y `git diff --staged` para evitar subir información sensible.

## Flujo de trabajo con Git

- Rama estable: `main` (solo se actualiza mediante *pull request*).
- Ramas de trabajo: `feature/...`, `fix/...`, `docs/...`.
- Commits pequeños con mensajes descriptivos (`feat:`, `fix:`, `docs:`, `chore:`).
- Todo cambio se revisa en un pull request antes de fusionarse a `main`.

## Automatización (complementaria)

El archivo `.github/workflows/devops-automation.yml` se ejecuta en cada *push* o *pull request* hacia `main`: valida archivos obligatorios, revisa que `.env` no esté versionado, construye la imagen, levanta el contenedor y comprueba que el servicio responda. No publica la aplicación en servidores externos.

## Solución de problemas

| Problema | Posible causa | Solución |
|---|---|---|
| `port is already allocated` | El puerto 8080 está en uso | Cambiar `HOST_PORT` en `.env` o detener el otro servicio |
| `Cannot connect to the Docker daemon` | Docker Desktop no está iniciado | Abrir Docker Desktop y esperar a que indique *running* |
| La página no refleja cambios | Imagen antigua en caché | `docker compose up -d --build` |

## Licencia y uso

Proyecto con fines educativos. Todos los datos de la clínica son ficticios.
