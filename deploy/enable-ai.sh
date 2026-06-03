#!/bin/bash
# Reactiva el asistente IA (quita el bloqueo 503 del endpoint /api/anthropic).
# Correr en el servidor como root.
set -e
python3 - <<'PYEOF'
import re
f="/etc/nginx/sites-available/aoe2.prexacode.com"
s=open(f).read()
if "AI-DISABLED" not in s:
    print("YA estaba activo")
else:
    # elimina la línea marcada con # AI-DISABLED
    s=re.sub(r'\n[ \t]*return 503[^\n]*# AI-DISABLED', '', s)
    open(f,"w").write(s)
    print("IA REACTIVADA")
PYEOF
nginx -t && systemctl reload nginx && echo "RELOAD_OK"
