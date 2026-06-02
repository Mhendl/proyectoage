# Proyecto Age — Guía de Age of Empires II: Definitive Edition

Página web (un solo archivo `index.html`, en español) con la guía de **counters, unidades, civilizaciones y árbol tecnológico** de Age of Empires II: Definitive Edition, incluyendo todas las expansiones.

## Características

- **Unidades por categoría** (Infantería, Caballería, Arqueros, Asedio, Naval, Animales) con stats, cadena de mejoras y "Fuerte vs / Débil vs".
- **Tiers interactivos**: al hacer clic en cada tier (p. ej. Milicia → Hombre de Armas → … → Campeón) cambian imagen, stats y counters.
- **Buscador global** que atraviesa todas las pestañas a la vez.
- **Tech Tree**: árbol tecnológico oficial del juego, en español, incrustado desde [aoe2techtree.net](https://aoe2techtree.net) (licencia MIT).
- **Asistente IA** (botón 🤖): chat que responde sobre counters, civilizaciones, estrategia y tech tree, usando los datos de la página y, cuando hace falta, consultando en vivo la wiki de AoE. Usa la API de Anthropic (Claude).

## Configuración del asistente IA

El chat necesita una API key de Anthropic. Hay dos formas:

1. **Recomendado** — abrí el chat con 🤖, entrá a ⚙ y pegá tu clave. Se guarda solo en tu navegador (`localStorage`).
2. **Sin ingresarla cada vez** — creá un archivo `config.js` junto a `index.html` con:
   ```js
   window.AOE_API_KEY = "sk-ant-...";
   ```
   Ese archivo está en `.gitignore` y **no se sube al repositorio** (la clave es privada).

Conseguí una clave en [console.anthropic.com](https://console.anthropic.com/settings/keys).

## Uso

Abrí `index.html` en el navegador. El Tech Tree y el asistente IA requieren conexión a internet.

## Créditos de datos

- Counters basados en la planilla *AoE2HD Strength & Weakness Spreadsheet*.
- Tech tree por [aoe2techtree.net](https://aoe2techtree.net) (MIT).
- Stats de unidades nuevas desde los datos abiertos de aoe2techtree.
