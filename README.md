# Cornell Box — Iluminación Interactiva en Godot 4

Escena 3D que compara o modelo **PBR predeterminado de Godot** cun **Phong clásico** implementado con `ShaderMaterial`, dentro dunha Cornell Box simplificada.

---

## Estrutura de ficheiros

```
cornell_box/
├── main.gd               # Lóxica principal: cámaras, teclas, materiais
├── cornell_box_setup.gd  # Xera a xeometría por código (paredes, esferas, prismas)
├── phong_classic.gdshader # Shader GLSL do modelo Phong clásico
└── README.md
```

---

## Escena e xeometría

A escena segue a estrutura da [Cornell Box](https://en.wikipedia.org/wiki/Cornell_box):

| Elemento | Descripción |
|---|---|
| Chan | Gris claro, mate (`roughness ≈ 0.85`) |
| Parede esquerda | Vermella mate |
| Parede dereita | Verde mate |
| Parede do fondo | Branca mate |
| Teito | Aberto (sen mesh) |
| Prismas (×2) | Bloques brancos detrás das esferas |
| **SphereA** | PBR plástico (`metallic=0`, `roughness=0.4`) |
| **SphereB** | PBR metálica (`metallic=1`, `roughness=0.2`) |
| **SphereC** | Phong clásico vía `ShaderMaterial` |

---

## Materiais

### StandardMaterial3D (SphereA e SphereB)
Usa o pipeline **PBR** de Godot. Configúrase directamente cos parámetros `metallic` e `roughness`.

### ShaderMaterial + phong_classic.gdshader (SphereC)
Implementación manual do modelo de Phong:

```
color = Ia + Σ [ Id·(N·L) + Is·(R·V)^n ]
```

- `render_mode unshaded` — desactiva o PBR de Godot
- Compoñentes: **ambiental + difusa (Lambert) + especular (Phong)**
- Soporta dúas luces: direccional e omni lateral con atenuación cuadrática

---

## Luces

| Nodo | Tipo | Posición/Rotación | Enerxía | Sombras |
|---|---|---|---|---|
| `DirectionalLight` | `DirectionalLight3D` | rot `(-45°, 30°, 0°)` | 1.2 | ✅ |
| `OmniLateral` | `OmniLight3D` | `(-2.5, 1.5, 0)` | 0.6 | ✅ |
| `OmniSuperior` | `OmniLight3D` | `(0, 3.5, 0)` | 0.4 | ❌ |

O `WorldEnvironment` usa un `ProceduralSkyMaterial` con enerxía ambiental baixa (`0.15`) para non dominar a iluminación.

---

## Cámaras

| Tecla | Cámara | Descripción |
|---|---|---|
| `4` | Exterior | Vista completa da escena desde fóra |
| `5` | Interior | Tiro alto dentro da caixa |
| `6` | FPS | Cámara libre (WASD + rato) |

A cámara FPS captura o rato automaticamente (`MOUSE_MODE_CAPTURED`).

---

## Controis de teclado

| Tecla | Acción |
|---|---|
| `1` | Activar/desactivar `DirectionalLight3D` |
| `2` | Activar/desactivar `OmniLight3D` lateral |
| `3` | Activar/desactivar `OmniLight3D` superior |
| `O` | Activar/desactivar **Ambient Occlusion** (SSAO) |
| `E` | Activar/desactivar **WorldEnvironment** (Sky) |
| `4/5/6` | Cambiar cámara |
| `W A S D` | Mover cámara FPS |
| Rato | Rotar cámara FPS |

---

## Comparación de modelos

| Característica | PBR (StandardMaterial3D) | Phong Clásico (ShaderMaterial) |
|---|---|---|
| Enerxía conservada | ✅ | ❌ |
| Parámetros físicos | `metallic`, `roughness` | `shininess`, cores manuais |
| Reflexos de entorno | ✅ (IBL) | ❌ |
| Control total | ❌ | ✅ |
| Custo computacional | Moderado | Baixo |
