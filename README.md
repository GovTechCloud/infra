Este proyecto es una aplicación completa que utiliza **Infraestructura como Código (IaC)**, específicamente **Terraform**, para gestionar y aprovisionar recursos en la nube (AWS y Azure). Esto permite un despliegue consistente, repetible y versionado de la infraestructura, además de la configuración de los repositorios de GitHub.

## Architecture

![Architecture](https://drive.google.com/uc?export=view&id=19oNOqljoBDMLu4r3685pPv-qssJkwNHJ)

## Repositorios

[Infra](https://github.com/GovTechCloud/infra)
[Backend](https://github.com/GovTechCloud/api-service)
[Frontend](https://github.com/GovTechCloud/app-web)

## 1. Tecnologías Utilizadas

### Infraestructura como Código (`infra`):
*   **Terraform** (herramienta de IaC)
*   **AWS** (Amazon Web Services)
*   **Azure** (Microsoft Azure)
*   **Shell Scripting** (scripts auxiliares)

### Backend (`api-service`):
*   **Node.js**, **Express.js**
*   **SQL** (MySQL)
*   **ESLint**, **Jest** (para linting y testing)
*   **Docker** (para contenerización)

### Frontend (`app-web`):
*   **React**, **JavaScript/JSX**, **CSS**
*   **Axios** (cliente HTTP)
*   **Create React App**, **Jest/React Testing Library** (para desarrollo y testing)

### Seguridad y Validación:

*   **TFLint:** Herramienta de linting para Terraform que verifica la configuración y posibles errores en los archivos `.tf`.
*   **Checkov:** Herramienta de seguridad estática de código (SAST) para infraestructura como código (IaC), que detecta configuraciones erróneas y vulnerabilidades en Terraform, CloudFormation, Kubernetes, etc.
*   **SonarQube (Potencial):** Herramienta de análisis estático de código (SAST) para detectar vulnerabilidades y problemas de calidad.
*   **OWASP ZAP (Guías):** Se siguen las directrices de seguridad de la Open Web Application Security Project para prevenir vulnerabilidades comunes en aplicaciones web.
*   **ESLint:** Herramienta de linting para asegurar la calidad y buenas prácticas de seguridad en el código.
*   **Security Groups (AWS) / Network Security Groups (Azure):** Configuración de firewall a nivel de red para controlar el tráfico de entrada y salida.


## 2. Arquitectura

El proyecto está organizado en repositorios especializados para modularidad, desarrollo independiente y gestión eficiente:

*   **`api-service`:** Contiene el código fuente del backend (API Node.js/Express, lógica de negocio, acceso a datos, Dockerfile).
*   **`app-web`:** Aloja el código fuente del frontend (aplicación React, componentes UI, páginas, configuración de Axios).
*   **`infra`:** Gestiona la infraestructura de la aplicación en la nube utilizando Terraform.
    *   **`aws/`:** Configuraciones de Terraform para recursos en AWS (VPC, Security Groups, RDS, EC2, etc.).
    *   **`azure/`:** Configuraciones de Terraform para recursos en Azure (Container Registry, Container Apps, MySQL, Static Web Apps, Virtual Network, etc.).

Esta organización promueve la especialización, el desarrollo paralelo y la capacidad de escalar y gestionar cada parte de la aplicación de forma independiente y automatizada.

Además se incluye la ejecución de pruebas de seguridad estáticas (SAST) (SonarQube), análisis de calidad de código (con ESLint) y otras validaciones en cada etapa del pipeline para garantizar la seguridad y robustez del código antes del despliegue, siguiendo las directrices de OWASP ZAP.

## Infraestructura

Infraestructura como código (IaC) utilizando Terraform para desplegar servicios en AWS y Azure.

### Servicios AWS

*   **VPC (Virtual Private Cloud):** Entorno de red aislado.
*   **Internet Gateway (IGW):** Permite la comunicación entre la VPC e Internet.
*   **Subnets:** Subredes públicas y privadas para organizar los recursos.
*   **Route Tables:** Controla el enrutamiento del tráfico de red.
*   **Security Groups:** Para acceso público (ej. host bastión con SSH) y para recursos internos (ej. bases de datos, servicios backend).
*   **RDS (Relational Database Service):** Servicio de base de datos relacional gestionado.
*   **EC2 (Elastic Compute Cloud):** Servicio de computación escalable en la nube.

### Servicios Azure

*   **Resource Group:** Contenedor lógico para recursos de Azure.
*   **Virtual Network (VNet) y Subnets:** para aislamiento y organización de red.
*   **Network Security Groups (NSG):** Para controlar el tráfico de red de entrada y salida a las subredes.
*   **Container Registry (ACR):** Para almacenar y gestionar imágenes Docker.
*   **Container App Environment:** Para alojar aplicaciones en contenedores.
*   **Container App:** Para ejecutar aplicaciones en contenedores.
*   **Log Analytics Workspace:** Para recopilar y analizar registros.
*   **MySQL Flexible Server:** Servicio de base de datos MySQL gestionado.
*   **Static Web App:** Para alojar contenido web estático (ej. aplicaciones frontend).
