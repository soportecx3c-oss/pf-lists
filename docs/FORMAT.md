# Formato de listas (CSV)

Columnas:
- ip_or_cidr: IP o red CIDR (ej. 203.0.113.5 o 198.51.100.0/24)
- label: etiqueta de clasificación (ej. bruteforce, datacenter, trusted-dns, partner)
- added_at: fecha/hora UTC ISO8601 (ej. 2025-11-05T14:08:00Z)
- expires_at: fecha/hora UTC ISO8601 o vacío si no expira
- comment: texto libre

Reglas:
- Una fila por IP/CIDR.
- Usa UTC (terminado en 'Z') para facilitar purgas por tiempo.
- Evita comas en comment; si es necesario, usa punto y coma.
