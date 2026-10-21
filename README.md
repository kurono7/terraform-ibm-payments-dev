# payments-dev

Infraestructura de payments-dev en IBM Cloud, gestionada con HCP Terraform.

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

- `data.ibm_is_image.ubuntu` — imagen `ibm-ubuntu-22-04-5-minimal-amd64-19`
- `ibm_is_ssh_key.payments_key` — llave SSH RSA
- `ibm_is_instance.payments_vsi` — VSI (perfil `bx2-2x8`)
- `ibm_is_floating_ip.payments_fip` — IP pública

## Variables

Variables de código (con default, versionadas en `variables.tf`):

- `region` = `us-south`
- `zone` = `us-south-1`
- `instance_profile` = `bx2-2x8`
- `image_name` = `ibm-ubuntu-22-04-5-minimal-amd64-19`

Variables gestionadas como workspace variable en HCP Terraform (sin default en
código — HCP es la fuente de verdad):

- `ssh_public_key` — contenido de `prerequisites/ssh-keys/payments-demo.pub`

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

Para leer el output tras un apply:

```
Con tfctl, lee el state version actual de terraform-ibm-payments-dev
y extrae el output public_ip.
```

---
Generado por el skill `provision-ibm-cloud` de Bob.
