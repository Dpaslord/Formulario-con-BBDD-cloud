# 📋 Formulario con Base de Datos (SwiftUI + Supabase)

Proyecto iOS desarrollado en **SwiftUI** que implementa un formulario con validación, persistencia en base de datos cloud (Supabase) y listado de registros propios.

Ejercicio técnico basado en:

> Formulario con validación que inserta en Supabase y muestra el listado de registros ordenados por fecha descendente.

## 🚀 Funcionalidades

### ✅ Formulario con validación
- Campos:
  - Título
  - Descripción
  - Categoría
  - Prioridad (1–5)
  - Email
- Validaciones:
  - Título: 5–60 caracteres
  - Descripción: 20–500 caracteres
  - Email válido (regex)
  - Prioridad entre 1 y 5
- Feedback visual por campo inválido
- Botón deshabilitado si el formulario no es válido
- Estado de carga `"Enviando..."`
- Prevención de doble envío

---

### ☁️ Persistencia en Supabase
- Inserción en tabla `solicitudes`
- UUID generado en cliente para evitar duplicados
- Ordenado por `created_at` descendente
- Manejo de errores de red y decodificación
- Reintento manual ante fallo

---

### 📄 Listado
- Sección "Mis solicitudes"
- Ordenadas por fecha descendente
- Recarga automática al iniciar
- Actualización tras insertar registro

---

## 🏗️ Arquitectura

Se ha implementado **MVVM**:

- `FormMainView` → Vista principal
- `FormViewModel` → Lógica de negocio y validación
- `Solicitud` → Modelo
- `SupabaseManager` → Capa de acceso a datos

Buenas prácticas aplicadas:

- `@MainActor` para sincronización UI
- `@Published` + `ObservableObject`
- Manejo de errores tipado
- Separación clara de responsabilidades
- Validación desacoplada por propiedad

---

## 🛠️ Tecnologías utilizadas

- Swift 5
- SwiftUI
- Supabase iOS SDK
- Combine
- Async/Await
- MVVM

---

## ⚙️ Configuración

### 1️⃣ Clonar el repositorio

git clone https://github.com/Dpaslord/Formulario-con-BBDD-cloud.git

### 2️⃣ Configurar variables de entorno en Xcode

En el Scheme del proyecto añadir:

- `SUPABASE_URL`
- `SUPABASE_KEY`

Estas variables son necesarias para inicializar el cliente Supabase.

### 3️⃣ Crear tabla en Supabase

Ejemplo de tabla:

create table solicitudes (
  id uuid primary key,
  titulo text not null,
  descripcion text not null,
  categoria text,
  prioridad int not null,
  email text not null,
  created_at timestamptz default now()
);

## 🧪 Escenario de prueba (demo)

1. Intentar enviar formulario inválido → botón deshabilitado
2. Corregir campos → botón habilitado
3. Enviar → estado "Enviando..."
4. Confirmación de éxito
5. Registro aparece en listado
6. Simular red offline → error mostrado
7. Reintento manual → carga correcta
8. No se generan duplicados

## 🎯 Objetivo del ejercicio

Demostrar:

- Validación de formulario en SwiftUI
- Integración con backend cloud
- Manejo de estados asíncronos
- Gestión de errores
- Arquitectura limpia y mantenible

## 📌 Posibles mejoras futuras

- Separar listado en vista independiente
- Inyección de dependencias
- Tests unitarios del ViewModel
- Paginación
- Autenticación de usuario
- Modo offline con caché local

## 👨‍💻 Autor

David Pascual Lorenzo

