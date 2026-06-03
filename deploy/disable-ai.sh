#!/bin/bash
# Desactiva temporalmente el asistente IA (el endpoint /api/anthropic devuelve 503).
# No borra la API key; solo bloquea el endpoint. Reversible con enable-ai.sh.
# Correr en el servidor como root.
set -e
python3 - <<'PYEOF'
f="/etc/nginx/sites-available/aoe2.prexacode.com"
s=open(f).read()
if "AI-DISABLED" in s:
    print("YA estaba desactivado")
else:
    anchor="location = /api/anthropic {"
    off='\n        return 503 \'{"error":{"message":"El asistente IA esta desactivado temporalmente"}}\'; # AI-DISABLED'
    s=s.replace(anchor, anchor+off, 1)
    open(f,"w").write(s)
    print("IA DESACTIVADA")
PYEOF
nginx -t && systemctl reload nginx && echo "RELOAD_OK"
