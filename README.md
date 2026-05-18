# 🚚 Sistema de Envíos - Innovatech Chile (Proyecto DevOps)

Este repositorio contiene el código fuente, la contenedorización y la Infraestructura como Código (IaC) para el Sistema de Envíos y Ventas de Innovatech Chile. El proyecto demuestra la aplicación de prácticas DevOps reales, asegurando escalabilidad, mantenibilidad, seguridad y automatización de despliegues en AWS.

---

## 🏛️ Arquitectura del Sistema

El proyecto está diseñado bajo una arquitectura orientada a microservicios:

* **Frontend (`front_despacho`):** Interfaz de usuario pública accesible a través de Internet.
* **Microservicio de Despachos (`back-Despachos_SpringBoot`):** API REST en Java Spring Boot encargada de la lógica de envíos.
* **Microservicio de Ventas (`back-Ventas_SpringBoot`):** API REST en Java Spring Boot encargada de la gestión de ventas.
* **Base de Datos:** MySQL versión 8, operando en una subred privada con persistencia de datos mediante volúmenes de Docker.

---

## 🛠️ Tecnologías y Herramientas DevOps

* **Desarrollo:** Java (Spring Boot), JavaScript/TypeScript (Node.js/Nginx).
* **Contenedorización:** Docker, Docker Compose.
    * *Buenas prácticas:* Multi-stage builds, ejecución con usuarios no root, optimización de caché de capas.
* **Infraestructura como Código (IaC):** Terraform.
* **Cloud Provider (AWS):** EC2 (Instancias), ECR (Elastic Container Registry), ECS (Elastic Container Service), Security Groups.
* **CI/CD:** GitHub Actions (Automatización de Build, Push y Deploy).

---

## 🚀 Despliegue Local (Entorno de Desarrollo)

Para levantar el proyecto en tu máquina local, asegúrate de tener instalado **Docker** y **Docker Compose**.

1.  Clona este repositorio:
    ```bash
    git clone [https://github.com/OrellanaBenjamin/ProyectoDespachos.git](https://github.com/OrellanaBenjamin/ProyectoDespachos.git)
    cd ProyectoDespachos
    ```

2.  Ejecuta el entorno con Docker Compose:
    ```bash
    docker compose up -d --build
    ```

3.  Verifica los servicios:
    * Frontend: `http://localhost:3000` (o el puerto configurado).
    * Backends: `http://localhost:8080` / `http://localhost:8081`.

---

## ☁️ Despliegue en AWS (Infraestructura)

La infraestructura de producción está gestionada y automatizada con Terraform.

### Pre-requisitos:
* Tener configuradas las credenciales de AWS en tu entorno (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN`).

### Pasos para aprovisionar:

1.  Navega a la carpeta de infraestructura:
    ```bash
    cd infra
    ```

2.  Inicializa Terraform (descarga de plugins de AWS):
    ```bash
    terraform init
    ```

3.  Verifica los recursos a crear (Security Groups, EC2, ECR, ECS):
    ```bash
    terraform plan
    ```

4.  Aplica los cambios en AWS:
    ```bash
    terraform apply
    ```
*(Nota: Las direcciones IP públicas y privadas de las instancias, así como las URLs de los registros ECR, se mostrarán en la consola al finalizar el proceso).*

---

## 🔒 Seguridad y Networking

La infraestructura fue diseñada con políticas estrictas de seguridad (Zero Trust a nivel de red):
* **Frontend Security Group:** Permite tráfico entrante HTTP (80) y HTTPS (443) desde cualquier origen (`0.0.0.0/0`).
* **Backend Security Group:** Totalmente privado. Solo acepta peticiones entrantes si provienen exclusivamente del Security Group del Frontend. Bloquea el acceso externo a la Base de Datos (3306) y a las APIs (8080).

---

## ⚙️ Pipeline CI/CD

El proyecto cuenta con un flujo de Integración y Despliegue Continuo (CI/CD) automatizado mediante la rama `deploy`. 
1.  **Build:** Se compilan las imágenes Docker utilizando caché.
2.  **Push:** Se publican las imágenes de forma segura en los registros privados de AWS ECR.
3.  **Deploy:** Se actualizan los contenedores en las instancias EC2 correspondientes sin tiempo de inactividad prolongado.