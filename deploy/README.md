# Deploy — aoe2.prexacode.com

Documentación e infraestructura del sitio publicado. **Acá no hay secretos**: la
API key vive solo en el servidor (`/etc/nginx/aoe2-secret.conf`, `chmod 600`).

## Qué es

Sitio estático (la guía de AoE2) servido por **nginx** en un VPS Ubuntu 24.04,
con HTTPS (Let's Encrypt) en `https://aoe2.prexacode.com`.

El asistente IA usa un **proxy en nginx**: el navegador hace `POST /api/anthropic`
(sin key) y nginx reenvía la petición a la API de Anthropic agregando la API key
del lado del servidor. Así **la key nunca se expone** al navegador y cualquier
visitante puede usar la IA. Modelo fijo: `claude-sonnet-4-6`.

```
navegador  --POST /api/anthropic (sin key)-->  nginx  --+ x-api-key (oculta) -->  api.anthropic.com
```

## Archivos de esta carpeta

| Archivo | Para qué | Dónde va en el server |
|---|---|---|
| `nginx-aoe2.prexacode.com.conf` | server block del sitio + proxy | `/etc/nginx/sites-available/aoe2.prexacode.com` (+ symlink en `sites-enabled/`) |
| `aoe2-ratelimit.conf` | zona de rate-limit (contexto http) | `/etc/nginx/conf.d/aoe2-ratelimit.conf` |
| `aoe2-secret.conf.example` | plantilla del archivo con la key | el real es `/etc/nginx/aoe2-secret.conf` (NO se versiona) |
| `deploy.ps1` | empaqueta y sube el sitio (Windows) | se corre local |
| `disable-ai.sh` / `enable-ai.sh` | apaga/prende el proxy de IA | se corren en el server (root) |

## Actualizar el sitio (subir cambios del HTML/imágenes)

Desde Windows, en la raíz del proyecto:

```powershell
powershell -ExecutionPolicy Bypass -File deploy\deploy.ps1
```

Empaqueta todo (menos `.git`, `config.js`, `index-original.html`, `deploy/`),
lo sube a `/var/www/aoe2` y deja un `config.js` vacío en el server.
Después abrí el sitio con **Ctrl+Shift+R** (para saltear la caché del navegador).

## Prender / apagar el asistente IA

En el servidor (como root):

```bash
bash disable-ai.sh   # el endpoint /api/anthropic devuelve 503 (nadie usa la IA)
bash enable-ai.sh    # reactiva el proxy
```

> Estado actual: **el asistente está DESACTIVADO** (a pedido). Correr `enable-ai.sh` para reactivarlo.

## Setup inicial (si hubiera que rehacerlo en un server limpio)

1. Subir el sitio: `deploy.ps1` (crea `/var/www/aoe2`).
2. Crear el secreto con la key real (ver `aoe2-secret.conf.example`).
3. Copiar `aoe2-ratelimit.conf` a `/etc/nginx/conf.d/`.
4. Copiar el server block a `/etc/nginx/sites-available/` y enlazarlo en `sites-enabled/`.
5. `nginx -t && systemctl reload nginx`
6. HTTPS: `certbot --nginx -d aoe2.prexacode.com` (agrega solo los bloques 443 + redirect).

## Seguridad — pendientes recomendados

- **Límite de gasto** en console.anthropic.com → Billing → Limits. El proxy es de
  uso abierto (con rate-limit de 20 req/min por IP), así que el límite de gasto es
  el resguardo principal contra abuso.
- **Rotar la contraseña root** del VPS y, mejor, pasar a login por clave SSH
  (`ssh-keygen` + `ssh-copy-id`) y desactivar el login por contraseña.
