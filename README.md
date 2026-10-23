# payments-vsi-dev

Infraestructura de payments-vsi-dev en IBM Cloud, gestionada con HCP Terraform.

## Resumen

| | |
|---|---|
| Organización HCP Terraform | `IBMCE` |
| Workspace | `payments-vsi-dev` |
| Modo | remote · auto-apply desactivado |
| Región / Zona | `us-south` / `us-south-1` |
| Repo | `kurono7/terraform-ibm-payments-dev` (rama `main`) |

## Módulos y providers

- Módulo privado: ninguno — todos los recursos declarados directamente
- Provider: `IBM-Cloud/ibm ~> 1.71` — VPC, subnet, security group, SSH key, VSI, floating IP

## Recursos declarados directamente

| Recurso | Nombre lógico | Propósito |
|---|---|---|
| `ibm_is_vpc` | `main` | VPC del entorno payments |
| `ibm_is_subnet` | `main` | Subnet en `us-south-1` |
| `ibm_is_security_group` | `main` | Security group (SSH in + all out) |
| `ibm_is_security_group_rule` | `ssh_in` | Permite SSH entrante (TCP 22) |
| `ibm_is_security_group_rule` | `all_out` | Permite todo el tráfico saliente |
| `ibm_is_ssh_key` | `main` | SSH key registrada en IBM Cloud |
| `ibm_is_instance` | `main` | VSI Ubuntu 22.04 minimal (`bx2-2x8`) |
| `ibm_is_floating_ip` | `main` | IP pública asociada a la NIC primaria |

## Variables

Variables de código (con default, versionadas en `variables.tf`):

| Variable | Default | Descripción |
|---|---|---|
| `region` | `us-south` | Región IBM Cloud |
| `zone` | `us-south-1` | Zona IBM Cloud |
| `prefix` | `payments-dev` | Prefijo para nombres de recursos |
| `profile` | `bx2-2x8` | Perfil de la VSI |
| `image` | `ibm-ubuntu-22-04-5-minimal-amd64-1` | Imagen de la VSI |

Variables gestionadas como workspace variable en HCP Terraform (sin default en
código — HCP es la fuente de verdad):

| Variable | Tipo | Sensible | Descripción |
|---|---|---|---|
| `ssh_public_key` | Terraform | Sí | Contenido de la public key SSH |

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
Lanza un run plan_only en el workspace payments-vsi-dev de IBMCE
y muéstrame los logs del plan cuando termine.
```

## Outputs

| Output | Descripción |
|---|---|
| `public_ip` | IP pública asignada a la VSI |
| `ssh_command` | Comando SSH completo para conectarse |

Para leer el output tras un apply:

```
Con tfctl, lee el state version actual de payments-vsi-dev
y extrae el output public_ip.
```

---
Generado por el skill `provision-ibm-cloud` de Bob.
