# Imagen base ligera con Nginx
FROM nginx:alpine

# Metadatos de la imagen (trazabilidad)
LABEL org.opencontainers.image.title="reserva-horas-medicas" \
      org.opencontainers.image.description="Sitio web estático de reserva de horas médicas servido con Nginx" \
      org.opencontainers.image.version="1.0.0"

# Copia únicamente los archivos estáticos del sitio
COPY src/ /usr/share/nginx/html/

# Puerto interno de Nginx
EXPOSE 80

# Verificación de salud del contenedor (usa wget incluido en Alpine)
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -q --spider http://localhost/ || exit 1
