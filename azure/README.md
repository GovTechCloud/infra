# Diagrama de la Topología de Red


```
+-------------------------------------------------------------------------------+
|                             Virtual Network (VNet)                            |
|                                                                               |
|   +-------------------+     +-------------------+     +-------------------+   |
|   |   Public Subnet   |<--->|  Service Subnet   |<--->|    Data Subnet    |   |
|   | (subnet-public)   |     | (subnet-service)  |     |   (subnet-data)   |   |
|   +-------------------+     +-------------------+     +-------------------+   |
|             |                       |                       |                 |
|             |                       |                       |                 |
|   +-------------------+     +-------------------+     +-------------------+   |
|   |   nsg-public      |     |   nsg-service     |     |    nsg-data       |   |
|   | (Public Access)   |     | (Private Access,  |     | (Highly Private,  |   |
|   | (HTTPS/HTTP)      |     |  Inbound from     |     |  Inbound from     |   |
|   | (Can be made      |     |  Public, Outbound |     |  Service Only)    |   |
|   |  private)         |     |  to Data)         |     |                   |   |
|   +-------------------+     +-------------------+     +-------------------+   |
+-------------------------------------------------------------------------------+
```

**Explicación del Diagrama de Topología:**

*   **Subred Pública (`subnet-public`)**: Esta subred está destinada a servicios de cara al público. Está asociada con `nsg-public`.
    *   **`nsg-public`**: Por defecto, permite el tráfico entrante HTTPS/HTTP, haciendo que los servicios dentro de esta subred sean accesibles públicamente. Se puede configurar para la privacidad comentando reglas específicas.
*   **Subred de Servicios (`subnet-service`)**: Esta subred es para sus servicios privados. Está asociada con `nsg-service`.
    *   **`nsg-service`**: Este NSG es privado. Permite el tráfico entrante solo desde la subred `public` (por ejemplo, si su aplicación de cara al público necesita comunicarse con una API privada) y el tráfico saliente hacia la subred `data`. Deniega explícitamente el acceso a Internet desde otros puntos.
*   **Subred de Datos (`subnet-data`)**: Esta subred está diseñada para el almacenamiento de datos altamente privado, como bases de datos. Está asociada con `nsg-data`.
    *   **`nsg-data`**: Este NSG es altamente privado. Solo permite el tráfico entrante desde la subred `service`, asegurando que solo los servicios privados autorizados puedan acceder a sus datos. Todo el tráfico entrante y saliente restante está denegado.

---

# Diagrama de Reglas de Seguridad

## `nsg-public` (NSG para Servicios Públicos)

*   **AllowPublicToService** (Salida): TCP 8080 a Subred de Servicios.
*   **AllowOutboundInternet** (Salida): Todo el tráfico a Internet.
*   **AllowHTTPSInbound** (Entrada): TCP 443 (HTTPS) desde Internet.
*   **AllowHTTPInbound** (Entrada): TCP 80 (HTTP) desde Internet.
*   **DenyAllInbound** (Entrada): Denegar todo el tráfico entrante no permitido.
*   **DenyPublicToData** (Salida): Denegar tráfico a Subred de Datos.

## `nsg-service` (NSG para Servicios Privados)

*   **AllowPublicToServiceInbound** (Entrada): TCP 8080 desde Subred Pública.
*   **AllowServiceToData** (Salida): TCP 1433 (Azure SQL) a Subred de Datos.
*   **DenyAllInbound** (Entrada): Denegar todo el tráfico entrante no permitido.
*   **DenyServiceOutboundInternet** (Salida): Denegar tráfico a Internet.

## `nsg-data` (NSG para Datos)

*   **AllowServiceToDataInbound** (Entrada): TCP 1433 (Azure SQL) desde Subred de Servicios.
*   **DenyAllInbound** (Entrada): Denegar todo el tráfico entrante no permitido.
*   **DenyAllOutbound** (Salida): Denegar todo el tráfico saliente no permitido.

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
|   | Subnet: Public (10.X.1.0/24)          |                      |
|   | Associated NSG: nsg-public            |                      |
|   | Ingress:                              |                      |
|   |   - Internet (443/TCP - HTTPS)        |                      |
|   |   - Internet (80/TCP - HTTP)          |                      |
|   |   - Deny All Inbound (Priority 200)   |                      |
|   | Egress:                               |                      |
|   |   - To Backend (8080/TCP)             |                      |
|   |   - To Internet (*)                   |                      |
|   +---------------------------------------+                      |
|              |                                                   |
|              | Frontend to Backend (8080/TCP)                    |
|              V                                                   |
|   +---------------------------------------+                      |
|   | Subnet: Service (10.X.2.0/24)         |                      |
|   | Associated NSG: nsg-service           |                      |
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
|   | Subnet: Data (10.X.3.0/24)            |                      |
|   | Associated NSG: nsg-data              |                      |
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
