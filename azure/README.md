# Azure Network

Este documento proporciona una descripción general de alto nivel de la arquitectura de red de Azure definida en este repositorio.

```
+------------------------------------------------------------------+
|           Azure Virtual Network (vnet-${workspace_suffix})       |
|                   CIDR: 10.X.0.0/16                              |
|                                                                  |
|   +---------------------+                                        |
|   | Internet (External) |                                        |
|   +---------------------+                                        |
|              |                                                   |
|              | Public (HTTPS/HTTP)                               |
|              V                                                   |
|   +---------------------------------------+                      |
|   | Subnet: Frontend (10.X.1.0/24)        |                      |
|   | Associated NSG: nsg-frontend          |                      |
|   | Ingress:                              |                      |
|   |   - Internet (443/TCP - HTTPS)        |                      |
|   |   - Internet (80/TCP - HTTP)          |                      |
|   |   - Deny All Inbound (Priority 200)   |
|   | Egress:                               |                      |
|   |   - To Backend (8080/TCP)             |                      |
|   |   - To Internet (*)                   |                      |
|   +---------------------------------------+                      |
|              |                                                   |
|              | Frontend to Backend (8080/TCP)                    |
|              V                                                   |
|   +---------------------------------------+                      |
|   | Subnet: Backend (10.X.2.0/24)         |                      |
|   | Associated NSG: nsg-backend           |                      |
|   | Ingress:                              |                      |
|   |   - From Frontend (8080/TCP)          |                      |
|   | Egress:                               |                      |
|   |   - To DB (1433/TCP)                  |                      |
|   |   - Deny All Outbound to Internet     |                      |
|   |   - Deny All other Inbound            |                      |
|   +---------------------------------------+                      |
|              |                                                   |
|              | Backend to DB (1433/TCP)                          |
|              V                                                   |
|   +---------------------------------------+                      |
|   | Subnet: DB (10.X.3.0/24)              |                      |
|   | Associated NSG: nsg-db                |                      |
|   | Ingress:                              |                      |
|   |   - From Backend (1433/TCP)           |                      |
|   | Egress:                               |                      |
|   |   - Deny All Outbound                 |                      |
|   |   - Deny All other Inbound            |                      |
|   +---------------------------------------+                      |
+------------------------------------------------------------------+
```

**Nota sobre Nomenclatura de CIDR:** El `X` en las direcciones CIDR (`10.X.0.0/16`, `10.X.1.0/24`, etc.) corresponde al sufijo del workspace (`workspace_suffix`) de la siguiente manera:
*   `dev`: `10.2.X.X`
*   `staging`: `10.1.X.X`
*   `prod`: `10.0.X.X`

### Elementos clave:

* **Red virtual de Azure (VNet)**: La red principal aislada.

* **Subredes**: Subredes dedicadas para el frontend, el backend y la base de datos.

* **Grupos de seguridad de red (NSG)**: Controlan el flujo de tráfico para cada subred.

* `nsg-frontend`: De forma predeterminada, es de acceso público (HTTPS/HTTP) y permite habilitar la privacidad comentando las reglas.

* `nsg-backend`: Privado, permite el tráfico entrante desde el frontend y el saliente hacia la base de datos, y deniega el acceso a Internet desde otros puntos.

* `nsg-db`: Altamente privado, permite el tráfico entrante solo desde el backend y deniega todo el tráfico entrante y saliente restante.

### Conversión de la interfaz de usuario a privada:

Para convertir la interfaz de usuario en privada, comente las reglas `AllowHTTPSInbound` y `AllowHTTPInbound` en el archivo `azurerm_network_security_groups.tf` dentro del recurso `nsg-frontend`. Esto activará la regla `DenyAllInbound`, bloqueando todo el acceso externo.
