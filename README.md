# 3D Platformer Demo

Proyecto de ejemplo para Godot 4.5 que implementa un juego de plataformas 3D sencillo. Incluye:

- Personaje controlable con movimiento en 3D, salto y cámara en tercera persona.
- Plataformas estáticas distribuidas a diferentes alturas.
- Monedas coleccionables con rotación continua y detección por `Area3D`.
- Interfaz de usuario con contador de monedas y temporizador.

## Estructura

```
scenes/
  Main.tscn           # Escena principal con nivel, jugador y monedas
  player/Player.tscn  # Escena del personaje principal
  items/Coin.tscn     # Escena de moneda coleccionable
scripts/
  main.gd             # Conexión entre jugador y HUD
  player.gd           # Lógica de movimiento y cámara
  coin.gd             # Rotación y recogida de monedas
  hud.gd              # Control del interfaz de usuario
ui/
  HUD.tscn            # Interfaz con panel de información
```

Abre el proyecto en Godot 4.5 seleccionando `project.godot` como archivo de proyecto.

## Controles

- **Movimiento**: WASD o flechas direccionales / stick izquierdo del mando.
- **Saltar**: Barra espaciadora o botón inferior del mando.
- **Girar cámara**: Mueve el ratón. Haz clic derecho para liberar/capturar el cursor.
