# Étape 1 : Build / installation
FROM python:3.9-slim AS builder

# Définit le répertoire de travail
WORKDIR /app

# Copie uniquement les fichiers nécessaires pour installer les dépendances
COPY requirements.txt .

# Installe les dépendances sans cache pour réduire la taille
RUN pip install --no-cache-dir -r requirements.txt

# Étape 2 : Image finale (plus légère)
FROM python:3.9-slim

WORKDIR /app

# Copie le code de l'application et les dépendances depuis l'image builder
COPY --from=builder /usr/local/lib/python3.9 /usr/local/lib/python3.9
COPY --from=builder /usr/local/bin /usr/local/bin
COPY . .

# Définit la variable d’environnement (sécurité)
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    FLASK_APP=app.py \
    FLASK_RUN_HOST=0.0.0.0 \
    PORT=5000

# Expose le port de l’application
EXPOSE 5000

# Démarre l’application Flask
CMD ["flask", "run", "--host=0.0.0.0", "--port=5000"]
