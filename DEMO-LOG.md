# Demo Log — DevOps Day 2026
## Despliegue de infraestructura en IBM Cloud con una sola frase usando Bob

**Fecha:** 19 de octubre de 2026  
**Duración total:** ~6-7 minutos  
**Resultado:** VSI Ubuntu 22.04 corriendo en IBM Cloud `us-south-1` con IP pública `52.116.135.203`

---

## Frase de inicio

> *"I need to provision a VSI (ibm-ubuntu-22-04-5-minimal-amd64-19) with a public IP on IBM Cloud for the payments team."*

Con esta única frase Bob activó el skill `provision-ibm-cloud` y comenzó el flujo de 11 pasos.

---

## Paso 1 — Selección de organización

**Qué hizo Bob:**
- Consultó las organizaciones disponibles en la cuenta de HCP Terraform con `tfctl`
- Presentó la lista al usuario

**Qué aprobó el usuario:**
- Confirmó la organización **`IBMCE`**

**Por qué es importante:**
- Todo lo que se crea (workspace, variables, módulos) vive dentro de una organización de HCP Terraform
- Bob nunca asume la organización aunque solo haya una — siempre pide confirmación

---

## Paso 2 — Descubrimiento de módulos privados

**Qué hizo Bob:**
- Consultó el registry privado de la organización `IBMCE` en HCP Terraform
- Identificó el módulo `vpc-standard v1.0.0` como la base de red para la VSI

**Sin intervención del usuario** — solo observación.

**Resultado:**
```
app.terraform.io/IBMCE/vpc-standard/ibm  v1.0.0
Crea: VPC · Subred · Public Gateway · Security Group
```

---

## Paso 3 — Consulta al registry público

**Qué hizo Bob:**
- Consultó el registry público de Terraform para el provider `IBM-Cloud/ibm`
- Confirmó los argumentos requeridos para los recursos que el módulo privado no cubre

**Sin intervención del usuario** — solo observación.

**Recursos identificados:**
| Recurso | Argumentos requeridos |
|---|---|
| `ibm_is_ssh_key` | `name`, `public_key` |
| `ibm_is_instance` | `name`, `vpc`, `zone`, `profile`, `image`, `primary_network_interface` |
| `ibm_is_floating_ip` | `name`, `target` |

---

## Paso 4 — Diseño propuesto ✋ Checkpoint 1

**Qué hizo Bob:**
- Presentó el diseño completo de la infraestructura antes de crear nada
- Solicitó los datos que aún faltaban

**Qué aprobó el usuario:**
- Confirmó el diseño completo
- Proporcionó los datos faltantes:
  - Workspace: `payments-dev`
  - GitHub repo: `kurono7/terraform-ibm-payments-dev`, rama `main`
  - SSH key path: `prerequisites/ssh-keys/payments-demo.pub`

**Por qué es importante:**
- Este es el primer checkpoint crítico — nada se crea hasta aquí
- El usuario tiene visibilidad completa de lo que se va a construir antes de comprometerse

---

## Paso 5 — Resolución del directorio de trabajo

**Qué hizo Bob:**
- Buscó en el proyecto un directorio Git cuyo `origin` apuntara a `kurono7/terraform-ibm-payments-dev`
- Encontró `live/terraform-ibm-payments-dev/`

**Sin intervención del usuario.**

**Resultado:**
```
Directorio de trabajo: live/terraform-ibm-payments-dev/
```

---

## Paso 6 — Creación del workspace y configuración

**Qué hizo Bob:**

1. Detectó el tipo de integración VCS consultando `/github-app/installations`
   → GitHub App (`ghain-LvqonWSzS2s6FQYB`)

2. Creó el workspace `payments-dev` en HCP Terraform:
   - Modo: `remote`
   - Auto-apply: `false`
   - Sin VCS por ahora (el repo aún no tenía código Terraform)

3. Adjuntó el variable set `ibm-cloud-creds` al workspace:
   - Inyecta `IC_API_KEY` como variable de entorno en cada run

4. Agregó la variable `ssh_public_key` (RSA 4096) al workspace

5. Agregó la variable `image_id` con el ID real de la imagen:
   - `r006-2cbe47f3-b1cd-4af6-88d4-35469bf795af` (Ubuntu 22.04 minimal amd64, us-south)

**Sin intervención del usuario.**

**Resultado:**
```
Workspace:    payments-dev  (ws-YrR7Ex5GgRpBBwjB)
Variable set: ibm-cloud-creds adjuntado
Variables:    ssh_public_key · image_id
```

---

## Paso 7 — Generación del código Terraform

**Qué hizo Bob:**
Generó los siguientes archivos dentro de `live/terraform-ibm-payments-dev/`:

| Archivo | Contenido |
|---|---|
| `terraform.tf` | Bloque `cloud {}` con org `IBMCE` y workspace `payments-dev` + provider `IBM-Cloud/ibm >= 1.65.0` |
| `main.tf` | `module "network"` (vpc-standard) + `ibm_is_ssh_key` + `ibm_is_instance` + `ibm_is_floating_ip` |
| `variables.tf` | `region`, `zone`, `instance_profile`, `image_id`, `ssh_public_key` |
| `outputs.tf` | `public_ip`, `ssh_command` |
| `.gitignore` | Excluye `.terraform/`, `*.tfstate`, `*.tfvars`, `.DS_Store` |
| `README.md` | Documentación del workspace |

**Sin intervención del usuario.**

---

## Paso 8 — Generación del README

**Qué hizo Bob:**
- Generó `README.md` usando la plantilla `readme-template.md` del skill
- Documentó: org, workspace, región/zona, repo, módulo privado, recursos, variables y outputs

**Sin intervención del usuario.**

---

## Paso 9 — Validación y push ✋ Checkpoint 2

**Qué hizo Bob:**
- Ejecutó `terraform init -backend=false` → descargó el módulo privado y el provider
- Ejecutó `terraform validate` → **Success**
- Presentó el resultado al usuario y pidió confirmación antes de hacer push

**Qué aprobó el usuario:**
- Revisó la validación y escribió **`yes`**

**Qué ejecutó Bob tras la aprobación:**
```bash
git add .
git commit -m "feat: payments-dev initial infrastructure"
git push origin main
```

**Resultado:**
```
6 archivos subidos a kurono7/terraform-ibm-payments-dev rama main
```

Inmediatamente después conectó el VCS al workspace:
```
kurono7/terraform-ibm-payments-dev  →  payments-dev  (GitHub App)
```

---

## Paso 10 — Plan

**Qué hizo Bob:**
- Lanzó un run `plan_only` en el workspace `payments-dev`
- Esperó a que terminara y mostró los resultados

**Sin intervención del usuario.**

**Resultado — 10 recursos a crear, 0 a destruir:**
```
+ ibm_is_vpc.main
+ ibm_is_subnet.main
+ ibm_is_public_gateway.main
+ ibm_is_security_group.main
+ ibm_is_security_group_rule.ssh_inbound
+ ibm_is_security_group_rule.icmp_inbound
+ ibm_is_security_group_rule.all_outbound
+ ibm_is_ssh_key.payments_key
+ ibm_is_instance.payments_vsi
+ ibm_is_floating_ip.payments_fip
```

**Tiempos del plan:**
- Inicio: `20:17:11 UTC`
- Fin: `20:17:35 UTC` (24 segundos)

---

## Paso 11 — Apply ✋ Checkpoint 3

**Qué hizo Bob:**
- Presentó el resultado del plan y preguntó si aplicar

**Qué aprobó el usuario:**
- Escribió **`yes`**

**Qué ejecutó Bob:**
- Lanzó un run `plan_and_apply`
- Confirmó el apply vía API (`/runs/<id>/actions/apply`)
- Monitoreó el estado hasta `applied`

**Tiempos del apply:**
- Inicio: `20:18:04 UTC`
- Fin: `20:19:33 UTC` (89 segundos)

**Resultado final:**
```
10 recursos creados en IBM Cloud us-south-1
public_ip:   52.116.135.203
ssh_command: ssh -i prerequisites/ssh-keys/payments-demo ubuntu@52.116.135.203
```

---

## Resumen de checkpoints

| Checkpoint | Momento | Qué decidió el usuario |
|---|---|---|
| **1** | Antes de crear cualquier cosa | Aprobó el diseño y dio los datos del workspace |
| **2** | Antes del git push | Revisó `terraform validate` y autorizó subir el código a GitHub |
| **3** | Antes del apply | Revisó el plan (10 recursos) y autorizó crear la infraestructura |

---

## Lecciones aprendidas (errores de la primera vuelta)

| Error | Causa | Fix aplicado |
|---|---|---|
| `CreateKeyWithContext failed: public key provided is not of type rsa` | La llave SSH fue generada con `ed25519` | Regenerar siempre con `ssh-keygen -t rsa -b 4096` |
| `CreateInstanceWithContext failed: image not found` | Se usó el nombre de la imagen en lugar del ID | Usar el ID real: `r006-2cbe47f3-b1cd-4af6-88d4-35469bf795af` |
| `BearerToken property is required` | El key del variable set era `ibmCE` en lugar de `IC_API_KEY` | Verificar el nombre exacto de la variable en el variable set |
| VCS connection error en workspace | El repo estaba vacío al crear el workspace con VCS | Crear el workspace sin VCS → hacer push → conectar VCS |
| `Permission denied (publickey)` al hacer SSH | Se usó ruta relativa y usuario `root` | Usar ruta absoluta y usuario `ubuntu` |

---

## Arquitectura desplegada

```
┌─────────────────────────────────────────────────────┐
│  IBM Cloud — us-south-1                             │
│                                                     │
│  ┌─────────────────────────────────────────────┐   │
│  │  VPC: payments-dev-vpc                      │   │
│  │                                             │   │
│  │  ┌─────────────────────┐                   │   │
│  │  │  Subnet             │ ◄── Public Gateway │   │
│  │  │  10.240.0.0/24      │                   │   │
│  │  │                     │                   │   │
│  │  │  ┌───────────────┐  │                   │   │
│  │  │  │  VSI bx2-2x8  │  │ ◄── Floating IP   │   │
│  │  │  │  Ubuntu 22.04 │  │   52.116.135.203  │   │
│  │  │  └───────────────┘  │                   │   │
│  │  └─────────────────────┘                   │   │
│  │  Security Group: SSH(22) + ICMP inbound     │   │
│  └─────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────┘
```

---

## Comando para conectarse

```bash
ssh -i ~/Downloads/devops-day-2026/prerequisites/ssh-keys/payments-demo ubuntu@52.116.135.203
```

## Comando para destruir

```bash
# Pídele a Bob:
Trigger a destroy run on the payments-dev workspace in IBMCE.
```
