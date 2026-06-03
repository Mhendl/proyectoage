# Deploy del sitio estático a aoe2.prexacode.com
# Uso:  powershell -ExecutionPolicy Bypass -File deploy\deploy.ps1
#
# Requiere: OpenSSH (ssh/scp, ya viene en Windows 10/11) y tar.
# Autenticación: usa tu acceso SSH al server. Lo más cómodo es configurar
# una clave SSH (ssh-keygen + ssh-copy-id) para no tener que poner la contraseña.
# Si no, ssh/scp te van a pedir la contraseña de root.
#
# NO sube: .git, config.js (la key local), index-original.html, .gitignore, la carpeta deploy/

param(
  [string]$Server = "root@31.97.94.157",
  [string]$WebRoot = "/var/www/aoe2"
)

$ErrorActionPreference = "Stop"
$src = Split-Path -Parent $PSScriptRoot   # raíz del proyecto (carpeta padre de deploy/)
$tgz = Join-Path $env:TEMP "aoe2_deploy.tgz"

Write-Host "Empaquetando sitio desde $src ..."
if (Test-Path $tgz) { Remove-Item $tgz }
tar -czf $tgz -C $src `
  --exclude=.git --exclude=config.js --exclude=index-original.html `
  --exclude=.gitignore --exclude=deploy .

Write-Host "Subiendo paquete..."
scp -o StrictHostKeyChecking=accept-new $tgz "${Server}:/tmp/aoe2_deploy.tgz"

Write-Host "Extrayendo en el servidor..."
$remote = @"
set -e
mkdir -p $WebRoot
tar -xzf /tmp/aoe2_deploy.tgz -C $WebRoot
# config.js vacío en el server: la key vive en /etc/nginx/aoe2-secret.conf, no acá
printf 'window.AOE_API_KEY = "";\n' > $WebRoot/config.js
chown -R www-data:www-data $WebRoot
rm -f /tmp/aoe2_deploy.tgz
echo "DEPLOY OK"
"@
$b64 = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($remote))
ssh -o StrictHostKeyChecking=accept-new $Server "echo $b64 | base64 -d | bash"

Remove-Item $tgz -ErrorAction SilentlyContinue
Write-Host "Listo: https://aoe2.prexacode.com (hacé Ctrl+Shift+R para ver los cambios)"
