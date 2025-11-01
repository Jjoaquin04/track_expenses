# Guía de Contribución

¡Gracias por tu interés en contribuir a Track Expenses! 🎉

## 📋 Tabla de Contenidos

- [Código de Conducta](#código-de-conducta)
- [¿Cómo puedo contribuir?](#cómo-puedo-contribuir)
- [Configuración del Entorno de Desarrollo](#configuración-del-entorno-de-desarrollo)
- [Proceso de Contribución](#proceso-de-contribución)
- [Estándares de Código](#estándares-de-código)
- [Guía de Commits](#guía-de-commits)
- [Pull Request](#pull-request)

## 📜 Código de Conducta

Este proyecto se adhiere a un código de conducta. Al participar, se espera que mantengas este código. Por favor, reporta comportamientos inaceptables a [tu-email@ejemplo.com].

### Nuestros Estándares

**Comportamientos que contribuyen a crear un ambiente positivo:**

- Uso de lenguaje acogedor e inclusivo
- Respeto a diferentes puntos de vista y experiencias
- Aceptación de críticas constructivas
- Enfoque en lo que es mejor para la comunidad
- Empatía hacia otros miembros de la comunidad

**Comportamientos inaceptables:**

- Uso de lenguaje o imágenes sexualizadas
- Trolling, comentarios insultantes o despectivos
- Acoso público o privado
- Publicación de información privada de terceros
- Otras conductas no éticas o no profesionales

## 🤔 ¿Cómo puedo contribuir?

### Reportar Bugs

Antes de crear un reporte de bug:

- **Verifica** que no exista ya un issue sobre el problema
- **Recopila información** sobre el bug
- **Determina** qué versión de Flutter y Dart estás usando

#### ¿Cómo enviar un buen reporte de bug?

Los bugs se rastrean como [GitHub issues](https://github.com/Jjoaquin04/track_expenses/issues). Crea un issue y proporciona la siguiente información:

- **Título claro y descriptivo**
- **Pasos exactos para reproducir el problema**
- **Comportamiento esperado vs comportamiento actual**
- **Capturas de pantalla** (si es aplicable)
- **Información del entorno:**
  ```
  Flutter version: X.X.X
  Dart version: X.X.X
  OS: [Android/iOS/Windows/macOS/Linux]
  Device: [modelo del dispositivo si es móvil]
  ```

### Sugerir Mejoras

#### ¿Cómo enviar una buena sugerencia de mejora?

Las mejoras también se rastrean como [GitHub issues](https://github.com/Jjoaquin04/track_expenses/issues).

- **Usa un título claro y descriptivo**
- **Proporciona una descripción detallada** de la mejora sugerida
- **Explica por qué esta mejora sería útil** para la mayoría de los usuarios
- **Lista algunos ejemplos** de cómo debería funcionar
- **Incluye mockups o bocetos** si es posible

### Tu Primera Contribución de Código

¿No sabes por dónde empezar? Puedes comenzar buscando issues etiquetados como:

- `good first issue` - issues fáciles para comenzar
- `help wanted` - issues que necesitan ayuda

## 🛠 Configuración del Entorno de Desarrollo

1. **Instala Flutter**
   - Sigue la [guía oficial de instalación](https://docs.flutter.dev/get-started/install)
   - Verifica que tengas Flutter 3.9.2 o superior

2. **Fork y clona el repositorio**
   ```bash
   git clone https://github.com/tu-usuario/track_expenses.git
   cd track_expenses
   ```

3. **Instala las dependencias**
   ```bash
   flutter pub get
   ```

4. **Genera los archivos necesarios**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

5. **Ejecuta la aplicación**
   ```bash
   flutter run
   ```

## 🔄 Proceso de Contribución

1. **Fork** el repositorio
2. **Crea una rama** para tu característica (`git checkout -b feature/AmazingFeature`)
3. **Realiza tus cambios** siguiendo los estándares de código
4. **Prueba** tus cambios exhaustivamente
5. **Commit** tus cambios (`git commit -m 'feat: add some AmazingFeature'`)
6. **Push** a la rama (`git push origin feature/AmazingFeature`)
7. **Abre un Pull Request**

## 📝 Estándares de Código

### Estilo de Código Dart/Flutter

- Sigue las [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Usa `flutter analyze` para verificar el código
- Formatea el código con `flutter format .`

### Estructura de Archivos

- Mantén los archivos pequeños y enfocados
- Un widget por archivo (excepto widgets privados pequeños)
- Nombra los archivos en snake_case: `my_widget.dart`
- Nombra las clases en PascalCase: `MyWidget`

### Comentarios y Documentación

```dart
/// Breve descripción de lo que hace la clase/función.
///
/// Descripción más detallada si es necesario.
///
/// ```dart
/// // Ejemplo de uso
/// final widget = MyWidget();
/// ```
class MyWidget extends StatelessWidget {
  // ...
}
```

### Arquitectura

- Sigue la **Clean Architecture**
- Usa **BLoC** para la gestión de estado
- Mantén la separación de capas:
  - **Data**: Modelos, datasources, repositories implementation
  - **Domain**: Entities, repository interfaces, use cases
  - **Presentation**: BLoC, pages, widgets

## 📌 Guía de Commits

Usamos [Conventional Commits](https://www.conventionalcommits.org/) para los mensajes de commit.

### Formato

```
<tipo>(<scope>): <descripción>

[cuerpo opcional]

[footer opcional]
```

### Tipos

- `feat`: Nueva funcionalidad
- `fix`: Corrección de bug
- `docs`: Cambios en documentación
- `style`: Formato, puntos y comas, etc (no cambios de código)
- `refactor`: Refactorización de código
- `perf`: Mejoras de rendimiento
- `test`: Añadir o modificar tests
- `chore`: Cambios en el proceso de build, herramientas auxiliares, etc

### Ejemplos

```bash
feat(expenses): add monthly summary view
fix(widget): resolve widget update issue on Android
docs(readme): update installation instructions
refactor(bloc): simplify expense state management
```

## 🔍 Pull Request

### Antes de enviar

- [ ] El código sigue los estándares del proyecto
- [ ] Has ejecutado `flutter analyze` sin errores
- [ ] Has formateado el código con `flutter format`
- [ ] Has probado los cambios en diferentes plataformas (si es aplicable)
- [ ] Has actualizado la documentación si es necesario
- [ ] Tus commits siguen la convención de commits

### Plantilla de Pull Request

```markdown
## Descripción
Breve descripción de los cambios realizados.

## Tipo de cambio
- [ ] Bug fix (cambio que corrige un problema)
- [ ] Nueva funcionalidad (cambio que añade funcionalidad)
- [ ] Breaking change (fix o feature que causaría que la funcionalidad existente no funcione como se esperaba)
- [ ] Documentación

## ¿Cómo se ha probado?
Describe las pruebas que realizaste.

## Checklist
- [ ] Mi código sigue el estilo de este proyecto
- [ ] He realizado una auto-revisión de mi código
- [ ] He comentado mi código en áreas difíciles de entender
- [ ] He realizado cambios correspondientes en la documentación
- [ ] Mis cambios no generan nuevas advertencias
- [ ] He probado que mi corrección es efectiva o que mi funcionalidad funciona

## Screenshots (si aplica)
Añade capturas de pantalla para ayudar a explicar tu cambio.
```

## ❓ ¿Preguntas?

Si tienes alguna pregunta, no dudes en:

- Abrir un [issue](https://github.com/Jjoaquin04/track_expenses/issues)
- Contactar al mantenedor: [@Jjoaquin04](https://github.com/Jjoaquin04)

## 🎉 ¡Gracias!

Gracias por contribuir a Track Expenses. ¡Tu ayuda es muy apreciada! 💙
