# Backend Scripts

Scripts para crear y configurar proyectos backend con Node.js y Express.

## 📋 Scripts Disponibles

### setup-backend.sh

Crea un proyecto backend completo con Node.js y Express, listo para empezar a programar.

#### Características

- ✅ Soporte para **TypeScript** o **JavaScript**
- ✅ Configuración **interactiva** con menús navegables
- ✅ Estructura de carpetas organizada
- ✅ Dependencias opcionales configurables
- ✅ Instalación automática de paquetes
- ✅ Archivos de ejemplo incluidos

#### Uso

```bash
./scripts/backend/setup-backend.sh
```

#### Opciones Interactivas

Durante la ejecución, el script te preguntará:

1. **Nombre del proyecto**
   - Validación automática
   - No puede empezar con número
   - Solo letras, números, guiones y guiones bajos

2. **Lenguaje**
   - TypeScript (recomendado)
   - JavaScript

3. **Puerto del servidor**
   - Por defecto: 3000
   - Validación de rango (1024-65535)

4. **Paquetes opcionales** (multi-selección con barra espaciadora)
   - **CORS** - Cross-Origin Resource Sharing
   - **dotenv** - Variables de entorno
   - **morgan** - HTTP request logger
   - **winston** - Logger avanzado
   - **zod** - Validación de schemas con TypeScript
   - **joi** - Validación de datos

5. **Herramienta de desarrollo**
   - Para TypeScript:
     - **tsx** (recomendado, más rápido)
     - **ts-node + nodemon**
   - Para JavaScript:
     - **nodemon**

#### Estructura Generada

```
my-backend/
├── src/
│   ├── config/           # Archivos de configuración
│   ├── controllers/      # Controladores de rutas
│   ├── middlewares/      # Middlewares personalizados
│   ├── models/          # Modelos de datos
│   ├── routes/          # Definición de rutas
│   │   └── user.routes.ts  # Ejemplo de rutas CRUD
│   ├── services/        # Lógica de negocio
│   ├── utils/           # Funciones utilitarias
│   └── index.ts         # Punto de entrada de la aplicación
├── .env.example         # Template de variables de entorno (si seleccionaste dotenv)
├── .gitignore          # Archivos a ignorar en git
├── package.json        # Dependencias y scripts
├── tsconfig.json       # Configuración TypeScript (si seleccionaste TS)
└── README.md           # Documentación del proyecto
```

#### Archivo Principal Generado

El archivo `src/index.ts` (o `.js`) incluye:

- ✅ Configuración de Express
- ✅ Middlewares básicos (JSON, URL encoded)
- ✅ Middlewares opcionales según tu selección (CORS, logger)
- ✅ Rutas de ejemplo (`/` y `/health`)
- ✅ Manejo de errores 404 y 500
- ✅ Configuración del servidor

Ejemplo de código generado (TypeScript):

```typescript
import express, { Request, Response, NextFunction } from 'express';
import cors from 'cors';  // Si seleccionaste CORS
import dotenv from 'dotenv';  // Si seleccionaste dotenv

const app = express();
dotenv.config();

// Middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cors());

// Routes
app.get('/', (req: Request, res: Response) => {
  res.json({
    message: 'Welcome to my-backend API',
    status: 'running',
    timestamp: new Date().toISOString()
  });
});

// ... más configuración
```

#### Rutas de Ejemplo

Se genera automáticamente `src/routes/user.routes.ts` con ejemplos de CRUD:

- `GET /api/users` - Listar usuarios
- `GET /api/users/:id` - Obtener usuario por ID
- `POST /api/users` - Crear usuario
- `PUT /api/users/:id` - Actualizar usuario
- `DELETE /api/users/:id` - Eliminar usuario

#### Scripts npm Generados

**Para TypeScript:**
```json
{
  "dev": "tsx watch src/index.ts",      // Desarrollo con hot reload
  "build": "tsc",                        // Compilar a JavaScript
  "start": "node dist/index.js"         // Producción
}
```

**Para JavaScript:**
```json
{
  "dev": "nodemon src/index.js",        // Desarrollo con hot reload
  "start": "node src/index.js"          // Producción
}
```

#### Después de Crear el Proyecto

1. **Navegar al proyecto:**
   ```bash
   cd my-backend
   ```

2. **Configurar variables de entorno** (si usaste dotenv):
   ```bash
   cp .env.example .env
   # Edita .env con tus valores
   ```

3. **Iniciar servidor de desarrollo:**
   ```bash
   npm run dev
   ```

4. **Probar el servidor:**
   ```bash
   curl http://localhost:3000
   # O visita http://localhost:3000 en tu navegador
   ```

#### Dependencias Incluidas

**Siempre:**
- `express` - Framework web

**TypeScript:**
- `typescript`
- `@types/node`
- `@types/express`
- `tsx` o `ts-node + nodemon`

**JavaScript:**
- `nodemon`

**Opcionales (según selección):**
- `cors` + `@types/cors`
- `dotenv`
- `morgan` + `@types/morgan`
- `winston`
- `zod`
- `joi`

#### Requisitos

- Node.js >= 14.x
- npm, yarn, o pnpm
- Git (recomendado)

#### Tips

1. **Usar TypeScript para proyectos grandes** - Mejor tipado y autocompletado
2. **Incluir dotenv desde el inicio** - Facilita la configuración
3. **Usar CORS si planeas un frontend separado** - Evita problemas de CORS
4. **Elegir un logger (morgan o winston)** - Ayuda con debugging
5. **Usar validadores (zod o joi)** - Valida datos de entrada

#### Próximos Pasos Recomendados

Después de crear tu proyecto:

1. **Configurar base de datos**
   - Agregar ORM (Prisma, TypeORM, Mongoose)
   - Configurar conexión en `src/config/`

2. **Agregar autenticación**
   - JWT, Passport, etc.
   - Crear middlewares de autenticación

3. **Implementar rutas reales**
   - Usar la estructura de ejemplo en `routes/`
   - Separar lógica en controllers y services

4. **Agregar tests**
   - Jest, Mocha, etc.
   - Tests unitarios y de integración

5. **Configurar CI/CD**
   - GitHub Actions, GitLab CI, etc.

#### Troubleshooting

**Error: "Node.js is not installed"**
- Instala Node.js desde https://nodejs.org/

**Error: "Project name cannot start with a number"**
- Los nombres de proyectos npm deben empezar con letra

**Error: "Port must be between 1024 and 65535"**
- Usa un puerto válido (por ejemplo: 3000, 8080)

**Error durante instalación de dependencias**
- Verifica tu conexión a internet
- Intenta limpiar caché: `npm cache clean --force`
- Instala manualmente: `cd my-backend && npm install`

#### Ejemplos de Uso

**Proyecto TypeScript completo:**
```bash
./scripts/backend/setup-backend.sh
# Nombre: my-api
# Lenguaje: TypeScript
# Puerto: 3000
# Paquetes: CORS, dotenv, morgan, zod
# Dev tool: tsx
```

**Proyecto JavaScript simple:**
```bash
./scripts/backend/setup-backend.sh
# Nombre: simple-api
# Lenguaje: JavaScript
# Puerto: 8080
# Paquetes: dotenv
# Dev tool: nodemon
```

## 🔧 Personalización

Si necesitas personalizar los templates o agregar más opciones, edita:

- Templates: `templates/backend-ts/files/`
- Script: `scripts/backend/setup-backend.sh`
- Funciones de UI: `lib/ui.sh`

## 📚 Más Información

- [Express Documentation](https://expressjs.com/)
- [TypeScript Documentation](https://www.typescriptlang.org/)
- [Node.js Best Practices](https://github.com/goldbergyoni/nodebestpractices)
