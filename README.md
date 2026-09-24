# Karyna Yunevych — Portfolio

Una web, dos caras 🌙☀️

| Tema | Cara | Colores |
|---|---|---|
| 🌙 Oscuro | Programación · PLANFORM · Ingeniería Informática (UBU) | Burdeos + mantequilla |
| ☀️ Claro | Diseño gráfico (UOC) | Butter + burdeos |

- Hecha con **Flutter Web** y publicada en **GitHub Pages**.
- Idiomas: **ES · EN · RU · UK**.
- Tipografías: **Bebas Neue** (títulos), **Iosevka Charon** (texto) y **Oswald** para los títulos en cirílico (Bebas Neue no tiene letras rusas/ucranianas).

Enlaces directos a una cara o idioma:

- `https://karynayunevych.github.io/?mode=design` → abre directamente la parte de diseño
- `https://karynayunevych.github.io/?lang=uk` → abre en ucraniano
- Se pueden combinar: `?mode=design&lang=en`

---

## 🚀 Publicarla por primera vez

1. En GitHub crea un repositorio **público** llamado exactamente
   **`karynayunevych.github.io`** (sin README, vacío).
2. Sube esta carpeta desde la terminal:

   ```bash
   cd ruta/a/portfolio
   git init
   git add .
   git commit -m "Primera versión del portfolio"
   git branch -M main
   git remote add origin https://github.com/karynayunevych/karynayunevych.github.io.git
   git push -u origin main
   ```

3. En el repo ve a **Settings → Pages → Build and deployment → Source** y elige **GitHub Actions**.
4. Ve a la pestaña **Actions**: verás "Deploy to GitHub Pages" trabajando (tarda ~3 min).
   Si falló porque aún no habías hecho el paso 3, pulsa **Re-run jobs**.
5. ¡Listo! 👉 **https://karynayunevych.github.io**

A partir de ahí, cada `git push` a `main` actualiza la web sola.

---

## ✏️ Cambiar el contenido

Casi todo está en **`lib/content.dart`**:

- `Profile` → email, LinkedIn, Behance, Instagram (si lo dejas `''` no se muestra).
- `devContent` → cara de programación: sobre mí, experiencia, estudios, habilidades, proyectos.
- `designContent` → cara de diseño.

Cada texto va en 4 idiomas, en este orden:

```dart
Tr('español', 'english', 'русский', 'українська')
```

Para textos iguales en todos los idiomas: `Tr.all('Flutter')`.

Los colores están en **`lib/theme.dart`** (`Palette.dev` y `Palette.design`).
Los textos de botones y menús están en **`lib/i18n.dart`**.

## 💻 Verla en tu ordenador

Con [Flutter](https://docs.flutter.dev/get-started/install) instalado:

```bash
bash tool/get_fonts.sh   # descarga las tipografías (solo la primera vez)
flutter pub get
flutter run -d chrome
```

## 📁 Estructura

```
lib/
  main.dart              arranque de la app
  app_state.dart         modo (dev/diseño) e idioma
  theme.dart             colores, tipografías, tamaños de pantalla
  i18n.dart              textos de la interfaz en 4 idiomas
  content.dart           ⭐ TU CONTENIDO
  pages/home_page.dart   la página con todas las secciones
  sections/              portada, sobre mí, proyectos, contacto…
  widgets/               barra de navegación, botones, transición del tema
assets/fonts/            licencias de las tipografías (los .ttf los descarga tool/get_fonts.sh)
tool/get_fonts.sh        descarga Bebas Neue, Iosevka Charon y Oswald
web/                     index.html, iconos
.github/workflows/       publicación automática en GitHub Pages
```
