# payments-dev

Infraestructura de payments-dev en IBM Cloud, gestionada con HCP Terraform.

## Resumen

| | |
|---|---|
| Organización HCP Terraform | `IBMCE` |
| Workspace | `payments-dev` |
| Modo | remote · auto-apply desactivado |
| Región / Zona | `us-south` / `us-south-1` |
| Repo | `kurono7/terraform-ibm-payments-dev` (rama `main`) |

## Módulos y providers

- Módulo privado: [`app.terraform.io/IBMCE/vpc-standard/ibm`](https://app.terraform.io/app/IBMCE/registry/modules/private/IBMCE/vpc-standard/ibm) `v1.0.0` — red (VPC, subnet, security group, gateway)
- Provider: `IBM-Cloud/ibm` — SSH key, VSI, floating IP

## Recursos declarados directamente

| Recurso | Nombre lógico | Nombre en IBM Cloud |
|---|---|---|
| `ibm_is_ssh_key` | `payments_key` | `payments-demo-key` |
| `ibm_is_instance` | `payments_vsi` | `payments-vsi` |
| `ibm_is_floating_ip` | `payments_fip` | `payments-fip` |

## Variables

Variables de código (con default, versionadas en `variables.tf`):

| Variable | Default | Descripción |
|---|---|---|
| `region` | `us-south` | Región IBM Cloud |
| `zone` | `us-south-1` | Zona dentro de la región |
| `instance_profile` | `bx2-2x8` | Perfil de la VSI |
| `image_id` | `r006-2cbe47f3-b1cd-4af6-88d4-35469bf795af` | ID de imagen Ubuntu 22.04 minimal amd64 |

Variables gestionadas como workspace variable en HCP Terraform:

| Variable | Descripción |
|---|---|
| `ssh_public_key` | Contenido de la llave pública RSA para la VSI |
| `image_id` | Sobreescribe el default con el ID real de IBM Cloud |

Credenciales de IBM Cloud inyectadas por el variable set `ibm-cloud-creds`
como `IC_API_KEY` — no se declaran como variable de Terraform.

## Uso

```bash
terraform init
terraform validate
```

El `plan` y el `apply` corren remotamente en HCP Terraform, nunca localmente.

## Outputs

| Output | Descripción |
|---|---|
| `public_ip` | IP pública asignada a la VSI |
| `ssh_command` | Comando SSH completo para conectarse |

## Conectarse a la VSI

```bash
ssh -i prerequisites/ssh-keys/payments-demo ubuntu@<public_ip>
```

> ⚠️ El usuario es `ubuntu`, no `root`. IBM Cloud VPC solo acepta llaves RSA.

---
Generado por el skill `provision-ibm-cloud` de Bob.
