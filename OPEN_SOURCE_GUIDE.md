# 🚀 Guía para Hacer tu Proyecto Open Source

Esta guía te llevará paso a paso para convertir tu proyecto en un proyecto open source exitoso en GitHub.

## 📋 Índice

1. [Preparación Inicial](#1-preparación-inicial)
2. [Configurar el Repositorio en GitHub](#2-configurar-el-repositorio-en-github)
3. [Subir el Código](#3-subir-el-código)
4. [Configuración del Repositorio](#4-configuración-del-repositorio)
5. [Promoción y Comunidad](#5-promoción-y-comunidad)
6. [Mantenimiento](#6-mantenimiento)
7. [Checklist Final](#7-checklist-final)

---

## 1. Preparación Inicial

### ✅ Archivos Creados

Ya hemos creado los siguientes archivos esenciales:

- ✅ **README.md** - Documentación principal del proyecto
- ✅ **LICENSE** - Licencia MIT
- ✅ **CONTRIBUTING.md** - Guía para contribuidores
- ✅ **CODE_OF_CONDUCT.md** - Código de conducta
- ✅ **.github/ISSUE_TEMPLATE/** - Plantillas para issues
- ✅ **.github/pull_request_template.md** - Plantilla para PRs

### 📸 Añadir Capturas de Pantalla

1. Ejecuta tu aplicación
2. Toma capturas de las siguientes pantallas:
   - Pantalla principal (home)
   - Agregar gasto (add_expense)
   - Vista mensual (monthly_view)
3. Guárdalas en la carpeta `screenshots/` con los nombres especificados
4. Asegúrate de que sean de buena calidad pero no muy pesadas (<500KB)

### 🔍 Verificar .gitignore

Asegúrate de que tu `.gitignore` incluya:

```gitignore
# Flutter/Dart
.dart_tool/
.packages
.pub-cache/
.pub/
build/
flutter_*.log

# IDE
.idea/
.vscode/
*.iml

# Android
android/.gradle/
android/local.properties
android/app/debug/
android/app/release/

# iOS
ios/Pods/
ios/.symlinks/
ios/Flutter/.last_build_id

# Windows, macOS, Linux
windows/flutter/ephemeral/
macos/Flutter/ephemeral/
linux/flutter/ephemeral/

# Hive DB (si quieres ignorar datos locales)
*.hive
*.lock
```

---

## 2. Configurar el Repositorio en GitHub

### Paso 1: Crear el Repositorio

1. Ve a [GitHub](https://github.com)
2. Haz clic en el botón **+** en la esquina superior derecha
3. Selecciona **New repository**
4. Configura el repositorio:
   - **Repository name**: `track_expenses`
   - **Description**: "Aplicación multiplataforma de gestión de gastos e ingresos con Flutter"
   - **Public** ✅ (para que sea open source)
   - **NO** marques "Initialize with README" (ya lo tenemos)
   - **NO** añadas .gitignore ni license (ya los tenemos)
5. Haz clic en **Create repository**

### Paso 2: Conectar tu Repositorio Local

GitHub te mostrará comandos. Si ya tienes Git inicializado:

```bash
# Navega a tu proyecto
cd c:\Users\jjoaq\.vscode\track_expenses

# Añade el repositorio remoto
git remote add origin https://github.com/Jjoaquin04/track_expenses.git

# Verifica que se añadió correctamente
git remote -v
```

Si NO tienes Git inicializado:

```bash
# Navega a tu proyecto
cd c:\Users\jjoaq\.vscode\track_expenses

# Inicializa Git
git init

# Añade todos los archivos
git add .

# Haz el primer commit
git commit -m "feat: initial commit with full project structure"

# Añade el repositorio remoto
git remote add origin https://github.com/Jjoaquin04/track_expenses.git

# Cambia a la rama main (si estás en master)
git branch -M main

# Sube el código
git push -u origin main
```

---

## 3. Subir el Código

### Primera Subida

```bash
# Añade todos los archivos
git add .

# Crea un commit con mensaje descriptivo
git commit -m "feat: initial release with core functionality"

# Sube el código a GitHub
git push -u origin main
```

### Verificar la Subida

1. Ve a tu repositorio en GitHub: `https://github.com/Jjoaquin04/track_expenses`
2. Verifica que todos los archivos estén ahí
3. Verifica que el README.md se muestre correctamente

---

## 4. Configuración del Repositorio

### 📋 About Section

1. En tu repositorio, haz clic en el ⚙️ (engranaje) junto a "About"
2. Completa:
   - **Description**: "Aplicación multiplataforma de gestión de gastos e ingresos con Flutter"
   - **Website**: (si tienes una demo online o página web)
   - **Topics** (etiquetas): 
     - `flutter`
     - `dart`
     - `expense-tracker`
     - `expense-manager`
     - `personal-finance`
     - `mobile-app`
     - `clean-architecture`
     - `bloc`
     - `hive`
3. Guarda los cambios

### 🏷️ Crear Releases

1. Ve a la pestaña **Releases**
2. Haz clic en **Create a new release**
3. Configura:
   - **Tag version**: `v0.1.0`
   - **Release title**: `v0.1.0 - Initial Release`
   - **Description**: Describe las características principales
   ```markdown
   ## 🎉 Primera Versión

   ### ✨ Características
   - ✅ Gestión de gastos e ingresos
   - ✅ Categorización de transacciones
   - ✅ Vista mensual con resúmenes
   - ✅ Modo de selección múltiple
   - ✅ Widget de pantalla de inicio (Android)
   - ✅ Persistencia local con Hive

   ### 📦 Instalación
   Sigue las instrucciones en el README para instalar y ejecutar la aplicación.
   ```
4. Si tienes un APK o IPA compilado, adjúntalo
5. Haz clic en **Publish release**

### 🔐 Proteger la Rama Main

1. Ve a **Settings** > **Branches**
2. En "Branch protection rules", haz clic en **Add rule**
3. Configura:
   - **Branch name pattern**: `main`
   - ✅ **Require pull request reviews before merging**
   - ✅ **Require status checks to pass before merging**
4. Guarda los cambios

### 📊 Habilitar Issues y Discussions

1. Ve a **Settings** > **General**
2. En "Features":
   - ✅ **Issues**
   - ✅ **Discussions** (para la comunidad)
   - ✅ **Projects** (opcional, para gestión de tareas)
3. Guarda los cambios

### 🏷️ Crear Labels para Issues

Ve a **Issues** > **Labels** y crea:

- `bug` 🐛 - Rojo - Algo no funciona
- `enhancement` ✨ - Azul - Nueva funcionalidad
- `documentation` 📝 - Verde - Mejoras en documentación
- `good first issue` 🌱 - Morado - Bueno para principiantes
- `help wanted` 🙋 - Amarillo - Se necesita ayuda
- `priority: high` 🔥 - Rojo oscuro - Alta prioridad
- `priority: medium` ⚡ - Naranja - Media prioridad
- `priority: low` 🌙 - Azul claro - Baja prioridad

---

## 5. Promoción y Comunidad

### 📢 Comparte tu Proyecto

1. **Twitter/X**:
   ```
   🎉 ¡He lanzado Track Expenses! Una app open source de gestión de gastos 
   construida con #Flutter 💙
   
   ✨ Features:
   - 📊 Gestión de gastos e ingresos
   - 📅 Vista mensual
   - 🏗️ Clean Architecture + BLoC
   
   ⭐ GitHub: https://github.com/Jjoaquin04/track_expenses
   
   #OpenSource #DartLang #MobileApp
   ```

2. **Reddit**:
   - r/FlutterDev
   - r/opensource
   - r/personalfinance

3. **Dev.to / Medium**:
   Escribe un artículo sobre tu experiencia construyendo la app

4. **LinkedIn**:
   Comparte como logro profesional

### 🌟 Añade a Repositorios Awesome

Busca listas "awesome" relacionadas:
- [awesome-flutter](https://github.com/Solido/awesome-flutter)
- [awesome-dart](https://github.com/yissachar/awesome-dart)

Envía un PR para añadir tu proyecto.

### 📱 Crear un Sitio Web / Landing Page

Considera crear una página simple con:
- Screenshots
- Características principales
- Link de descarga
- Link al repositorio GitHub

Puedes usar:
- GitHub Pages (gratis)
- Netlify (gratis)
- Vercel (gratis)

---

## 6. Mantenimiento

### 📝 Responder a Issues

- Responde rápido (dentro de 24-48h si es posible)
- Sé amable y profesional
- Usa las etiquetas apropiadas
- Cierra issues resueltos

### 🔄 Revisar Pull Requests

- Revisa el código cuidadosamente
- Da feedback constructivo
- Prueba los cambios localmente
- Agradece a los contribuidores

### 📅 Mantener el Proyecto Actualizado

- Actualiza dependencias regularmente
- Corrige bugs rápidamente
- Añade nuevas funcionalidades del roadmap
- Mantén la documentación actualizada

### 📊 Usar GitHub Projects

Crea un proyecto para gestionar el roadmap:
1. Ve a **Projects** > **New project**
2. Usa el template "Board"
3. Crea columnas: To Do, In Progress, Done
4. Añade issues como tarjetas

---

## 7. Checklist Final

Antes de considerar tu proyecto "listo" para open source:

### Documentación
- [ ] README.md completo y claro
- [ ] LICENSE incluido
- [ ] CONTRIBUTING.md con guías claras
- [ ] CODE_OF_CONDUCT.md
- [ ] Screenshots añadidos
- [ ] Comentarios en el código (donde sea necesario)

### Repositorio GitHub
- [ ] Repositorio público
- [ ] About section configurada
- [ ] Topics/etiquetas añadidas
- [ ] Issues habilitados
- [ ] Discussions habilitadas (opcional)
- [ ] Labels creados
- [ ] Templates de issues añadidos
- [ ] Template de PR añadido
- [ ] Primera release creada

### Código
- [ ] Código limpio y bien estructurado
- [ ] Sin credenciales o datos sensibles
- [ ] .gitignore configurado correctamente
- [ ] Compila sin errores
- [ ] Funciona en todas las plataformas objetivo

### Promoción
- [ ] Compartido en redes sociales
- [ ] Publicado en comunidades relevantes
- [ ] Considerado para listas "awesome"
- [ ] Landing page (opcional)

---

## 🎉 ¡Felicidades!

Tu proyecto ahora es open source. Recuerda:

- **Sé paciente**: Construir una comunidad lleva tiempo
- **Sé consistente**: Mantén el proyecto actualizado
- **Sé amable**: Trata a todos con respeto
- **Disfruta**: ¡Es tu proyecto y tu contribución al mundo open source!

## 📚 Recursos Adicionales

- [Guía de Open Source](https://opensource.guide/)
- [Cómo Mantener un Proyecto Open Source](https://opensource.guide/maintaining/)
- [GitHub Docs](https://docs.github.com/)
- [Conventional Commits](https://www.conventionalcommits.org/)

## 🤝 Necesitas Ayuda?

Si tienes dudas, contacta:
- GitHub: [@Jjoaquin04](https://github.com/Jjoaquin04)
- Abre un issue en el repositorio

---

**¡Mucho éxito con tu proyecto open source! 🚀**
