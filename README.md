# 🏆 SubastaKipu - Contrato Inteligente en Solidity

Contrato inteligente de una subasta con las siguientes características:
- 📈 Aumento mínimo del 5% por oferta
- ⏳ Extensión automática si se oferta en los últimos 10 minutos
- 💸 Reembolsos automáticos a perdedores con una comisión del 2%
- 🎁 Premio configurable para el ganador

## 📜 Licencia
[MIT](https://opensource.org/licenses/MIT)

## ⚙️ Versión
Solidity `^0.8.0`

---

## 🚀 Cómo funciona

### 🔧 Constructor
Inicializa la subasta con:
- `initialPrice`: Precio base
- `extensionTime`: Tiempo extra si se oferta al final
- `duration`: Duración total

### 💰 Función `pujar()`
Los participantes ofrecen fondos. Para que la oferta sea válida, debe superar al menos un **5%** del valor más alto.

- Si queda menos de 10 minutos, se extiende la duración automáticamente.
- Guarda la oferta en un mapping y actualiza el mejor postor.

### 🎯 Función `definirPremio(string)`
Permite al owner definir una descripción del premio.

### 🎁 Función `transferirPremioAlGanador()`
Marca el premio como entregado. Solo el owner puede ejecutarlo una vez finalizada la subasta.

### 🛑 Función `finalizarSubasta()`
Finaliza la subasta si el tiempo ya pasó y:
- Transfiere el monto al owner
- Devuelve a los perdedores su oferta menos una comisión del **2%**

### 💳 Función `retirarExceso()`
Permite a los postores retirar el exceso de fondos si sobrepujaron por error (no aplica al ganador).

---

## 📊 Funciones de consulta

| Función | Descripción |
|--------|-------------|
| `obtenerGanador()` | Devuelve el address y la oferta del ganador |
| `mostrarOferta(address)` | Muestra cuánto ofertó una dirección |
| `verTodasLasOfertas()` | Devuelve arrays con participantes y sus montos ofertados |

---

## 👮 Roles y Seguridad

- 👑 `owner`: Es quien despliega el contrato. Solo él puede:
  - Definir el premio
  - Entregar el premio
  - Finalizar la subasta

- ⛔ Validaciones:
  - Nadie puede pujar luego de terminado el tiempo
  - El ganador no puede retirar exceso
  - Nadie puede reclamar el premio dos veces

---

## 📦 Eventos Emitidos

- `NuevaOferta(address postor, uint monto)`
- `SubastaFinalizada(address ganador, uint monto)`
- `DepositoDevuelto(address postor, uint monto)`
- `ExcesoRetirado(address postor, uint monto)`

---

## 🧪 Recomendaciones para pruebas

Podés testear este contrato en [Remix IDE](https://remix.ethereum.org):
1. Pegá el código en un nuevo archivo `.sol`
2. Compilá con Solidity 0.8.x
3. Desplegá con valores: `initialPrice`, `extensionTime`, `duration`
4. Simulá distintas cuentas para pujar y ver reembolsos

---

## ✨ Autor

Desarrollado por Walter Liendo - Proyecto educativo con fines demostrativos en blockchain.

