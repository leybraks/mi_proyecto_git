from flask import Flask
import redis
import os

app = Flask(__name__)
# Se conecta al servicio 'db' (Redis) definido en docker-compose.yml
# Docker Compose se encarga de que el nombre 'db' se resuelva a la IP correcta.
cache = redis.Redis(host='db', port=6379)

def get_hit_count():
    # Intenta incrementar el contador en Redis. Si falla, asume 0.
    try:
        return cache.incr('hits')
    except Exception:
        return "error"

@app.route('/')
def hello():
    count = get_hit_count()
    if count == "error":
        html = "<h3>¡Hola!</h3><b>Redis no está disponible.</b> El contador falló."
    else:

        html = "<h3>¡Automatización Total Lograda! V20.0 ✅</h3>El número de visitantes es: <b>{0}</b>"

    return html.format(count)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
