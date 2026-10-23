# terraform-ibm-payments-dev

Infraestructura de terraform-ibm-payments-dev en IBM Cloud, gestionada con HCP Terraform.

## Resumen

| | |
|---|---|
| Organización HCP Terraform | `IBMCE` |
| Workspace | `terraform-ibm-payments-dev` |
| Modo | remote · auto-apply desactivado |
| Región / Zona | `us-south` / `us-south-1` |
| Repo | `kurono7/terraform-ibm-payments-dev` (rama `main`) |

## Módulos y providers

- Módulo privado: [`app.terraform.io/IBMCE/vpc-standard/ibm`](https://app.terraform.io/app/IBMCE/registry/modules/private/IBMCE/vpc-standard/ibm) `v1.0.0` — red (VPC, subnet, security group, gateway)
- Provider: `IBM-Cloud/ibm` — SSH key, VSI, floating IP

## Recursos declarados directamente

| Recurso | Nombre lógico | Propósito |
|---|---|---|
| `ibm_is_ssh_key` | `payments` | Sube la clave pública `payments-demo` a IBM Cloud VPC |
| `ibm_is_instance` | `payments` | VSI Ubuntu 22.04 minimal, perfil `bx2-2x8` |
| `ibm_is_floating_ip` | `payments` | IP pública asociada al NIC primario de la VSI |

## Variables

Variables de código (con default, versionadas en `variables.tf`):

| Variable | Default | Descripción |
|---|---|---|
| `name` | `payments-dev` | Prefijo base para todos los recursos |
| `region` | `us-south` | Región IBM Cloud |
| `zone` | `us-south-1` | Zona de disponibilidad |
| `subnet_cidr` | `10.240.0.0/24` | CIDR de la subred |
| `image_id` | `ibm-ubuntu-22-04-5-minimal-amd64-3` | ID de imagen de la VSI |
| `profile` | `bx2-2x8` | Perfil de instancia (2 vCPU, 8 GB) |
| `tags` | `["team:payments","env:dev","managed-by:terraform"]` | Etiquetas de recursos |

Variables gestionadas como workspace variable en HCP Terraform (sin default en
código — HCP es la fuente de verdad):

| Variable | Sensible | Descripción |
|---|---|---|
| `ssh_public_key` | ✅ sí | Contenido de la clave pública SSH `payments-demo` |

Credenciales de IBM Cloud inyectadas por el variable set `ibm-cloud-creds`
como `IC_API_KEY` — no se declaran como variable de Terraform.

## Uso

```bash
terraform init
terraform validate
```

El `plan` y el `apply` corren remotamente en HCP Terraform, nunca localmente.
Para lanzar un run:

```
Lanza un run plan_only en el workspace terraform-ibm-payments-dev de IBMCE
y muéstrame los logs del plan cuando termine.
```

## Outputs

| Output | Descripción |
|---|---|
| `public_ip` | IP pública asignada a la VSI |
| `ssh_command` | Comando SSH completo para conectarse |
| `vpc_id` | ID de la VPC creada para el equipo de pagos |
| `vsi_id` | ID de la VSI de pagos |

Para leer el output tras un apply:

```
Con tfctl, lee el state version actual de terraform-ibm-payments-dev
y extrae el output public_ip.
```

---
Generado por el skill `provision-ibm-cloud` de Bob.
