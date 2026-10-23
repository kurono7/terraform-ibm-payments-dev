# LAB-4206 — Intent-Based Infrastructure Provisioning

> IBM TechXchange 2026  
> Provision a production-grade IBM Cloud VSI using a single natural-language request to IBM Bob, IBM's AI development assistant.

---

## What you will build

By the end of this lab you will have:

- A **private Terraform module** (`vpc-standard`) published in HCP Terraform's private registry
- A **Terraform workspace** (`payments-dev`) connected to a GitHub repository via VCS
- IBM Cloud **credentials managed centrally** as a variable set (`ibm-cloud-creds`)
- A fully automated **VPC + VSI** deployment triggered by a `git push`
- A running **Ubuntu 22.04 virtual server** with a public floating IP

```
GitHub repo ──► HCP Terraform workspace ──► IBM Cloud VPC + VSI
                        ▲
                  ibm-cloud-creds
                  (variable set)
```

The entire provisioning flow is driven by Bob through the `provision-ibm-cloud` skill, which follows a 12-step workflow from a single natural-language request to a live server.

---

## Repository structure

```
lab-4206/
├── prerequisites/                         ← One-time setup (do this first)
│   ├── README.md                          ← Prerequisites checklist
│   ├── ssh-keys/                          ← SSH key pair for VSI access
│   └── modules/
│       └── terraform-ibm-vpc-standard/   ← Private module source code
│
└── live/                                  ← Bob writes Terraform files here during the lab
    └── terraform-ibm-payments-dev/        ← Created by Bob in Step 5 of the workflow
        ├── terraform.tf                   ← HCP Terraform cloud block
        ├── main.tf                        ← VPC module + SSH key + VSI + floating IP
        ├── variables.tf                   ← Input variables
        ├── outputs.tf                     ← public_ip and ssh_command outputs
        └── .gitignore                     ← Standard Terraform .gitignore
```

> The files inside `live/terraform-ibm-payments-dev/` do not exist yet — Bob generates them during the lab workflow.

---

## Prerequisites

Ensure the following are in place before starting the lab:

| Tool | Install | Verify |
|---|---|---|
| Terraform CLI `>= 1.9.0` | [terraform.io/downloads](https://developer.hashicorp.com/terraform/downloads) | `terraform version` |
| HCP Terraform account | [app.terraform.io](https://app.terraform.io) | Log in to the UI |
| IBM Cloud CLI | `brew install ibm-cloud-cli` | `ibmcloud version` |
| IBM Bob | Install IBM Bob (AI development IDE) | Open this project in Bob and select the **IBM Cloud Platform Engineer** mode |
| Git | `brew install git` | `git version` |

You will also need:
- An **IBM Cloud API key** (`IC_API_KEY`) — create one at [cloud.ibm.com/iam/apikeys](https://cloud.ibm.com/iam/apikeys)
- A **GitHub account** with permission to create repositories

---

## One-time setup (before starting the lab)

### Setup 1 — Clone this repository

```bash
git clone https://github.com/jaimcuev/lab-4206.git
cd lab-4206
```

---

### Setup 2 — Generate an SSH key pair

```bash
mkdir -p prerequisites/ssh-keys
ssh-keygen -t ed25519 -C "payments-demo" -f prerequisites/ssh-keys/payments-demo -N ""
```

This creates:
- `prerequisites/ssh-keys/payments-demo` — private key (**never commit this**)
- `prerequisites/ssh-keys/payments-demo.pub` — public key (passed to Terraform as a workspace variable)

---

### Setup 3 — Configure HCP Terraform

1. Log in to [app.terraform.io](https://app.terraform.io) and create a **new organization** (e.g. `my-lab-org`).
2. Connect your **GitHub VCS provider**:  
   `Settings → VCS Providers → Add VCS Provider → GitHub`
3. Create the **variable set** `ibm-cloud-creds`:
   - `Settings → Variable Sets → New variable set`
   - Add an **environment variable** `IC_API_KEY` — mark it as **sensitive**

---

### Setup 4 — Publish the private module

The `vpc-standard` module source is in `prerequisites/modules/terraform-ibm-vpc-standard/`.

1. Push that directory to a new GitHub repository named **`terraform-ibm-vpc-standard`**.
2. Tag the initial release:
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```
3. In HCP Terraform: `Registry → Publish module → GitHub → terraform-ibm-vpc-standard`

Verify the module is available at:
```
app.terraform.io/<your-org>/vpc-standard/ibm
```

---

### Setup 5 — Create the GitHub repo for the workspace

Create an empty repository named **`terraform-ibm-payments-dev`** in GitHub, then clone it:

```bash
git clone git@github.com:<your-username>/terraform-ibm-payments-dev.git live/terraform-ibm-payments-dev
```

> Bob will write all generated files into this directory during the lab.

---

## Lab workflow — 12 steps driven by Bob

Open this project in IBM Bob and switch to the **IBM Cloud Platform Engineer** mode (defined in `.bob/custom_modes.yaml`). The entire workflow below starts with a single request and Bob follows the `provision-ibm-cloud` skill to completion.

---

### Step 1 — Send the opening request

Type this into Bob:

```
I need to provision a VSI (ibm-ubuntu-22-04-5-minimal-amd64-17) with a public IP
on IBM Cloud for the payments team.
```

Bob activates the `provision-ibm-cloud` skill and begins the workflow.

---

### Step 2 — Select your HCP Terraform organization

Bob lists the available organizations in your HCP Terraform account and asks which one to use.

👉 **Your action:** confirm the organization (e.g. `my-lab-org`).

---

### Step 3 — Discover available private modules

Bob queries the private module registry of your organization and identifies the `vpc-standard` module as the network foundation for the VSI.

👉 **Your action:** review what Bob found and confirm it matches what you published in Setup 4.

---

### Step 4 — Fill in the gaps with the public registry

Bob queries the public Terraform registry for the `IBM-Cloud/ibm` provider to confirm the required arguments for the resources not covered by the private module: `ibm_is_ssh_key`, `ibm_is_instance`, and `ibm_is_floating_ip`.

👉 **Your action:** observe — no input needed at this step.

---

### Step 5 — Review the design and confirm (checkpoint)

Bob presents a summary of the proposed infrastructure:

- Private module to use and its version
- Resources to declare directly
- Information still needed: workspace name, GitHub repo (`owner/repo` + branch), and path to the public SSH key

👉 **Your action:** confirm the design. Provide any missing details:
- Workspace name: `payments-dev`
- GitHub repo: `<your-username>/terraform-ibm-payments-dev`, branch `main`
- SSH key path: `prerequisites/ssh-keys/payments-demo.pub`

---

### Step 6 — Bob locates the working directory

Bob searches the project root for a Git clone whose `origin` matches the confirmed repository. It finds `live/terraform-ibm-payments-dev/` (the directory you cloned in Setup 5) and uses it as the working directory for all generated files.

👉 **Your action:** confirm the directory Bob reports.

---

### Step 7 — Create the workspace, attach credentials, and add the SSH key

Bob creates the `payments-dev` workspace in HCP Terraform:
- Mode: `remote`, auto-apply: disabled
- VCS connection: your GitHub repo, branch `main`

Bob then:
1. Detects whether your org uses **GitHub App** (`ghain-*`) or **OAuth** (`ot-*`) for VCS integration and uses the correct field automatically
2. Attaches the `ibm-cloud-creds` variable set to the workspace
3. Adds `ssh_public_key` as a Terraform workspace variable from `prerequisites/ssh-keys/payments-demo.pub`

👉 **Your action:** observe — Bob handles this automatically.

---

### Step 8 — Generate the Terraform code and `.gitignore`

Bob writes the following files inside `live/terraform-ibm-payments-dev/`:

| File | Contents |
|---|---|
| `terraform.tf` | `required_version`, `cloud {}` block (org + workspace), `required_providers` |
| `main.tf` | `module "network"` (vpc-standard), `ibm_is_ssh_key`, `ibm_is_instance`, `ibm_is_floating_ip` |
| `variables.tf` | `region`, `zone`, `instance_profile`, `image_id`, `ssh_public_key` |
| `outputs.tf` | `public_ip`, `ssh_command` |
| `.gitignore` | Excludes `.terraform/`, `*.tfstate`, `*.tfvars`, `.DS_Store`, etc. |

> `IC_API_KEY` is **not** declared as a Terraform variable — it is injected by the `ibm-cloud-creds` variable set as an environment variable.

👉 **Your action:** review the generated files.

---

### Step 9 — Bob generates the workspace README

Bob writes a `README.md` inside `live/terraform-ibm-payments-dev/` documenting the workspace: org, workspace name, region/zone, repo, private module version, declared resources, variables, and outputs.

👉 **Your action:** observe.

---

### Step 10 — Validate and push (checkpoint)

Bob runs `terraform validate` inside the working directory and shows you the result.

Bob then asks for **explicit confirmation** before pushing — this is a checkpoint.

👉 **Your action:** review the validation output and type **yes** to approve the push.

Bob runs:
```bash
git add .
git commit -m "feat: payments-dev initial infrastructure"
git push origin main
```

The push triggers HCP Terraform automatically. A new run appears in the workspace.

---

### Step 11 — Trigger the plan and review

Bob triggers a `plan_only` run and streams the logs:

```
Trigger a plan_only run on the payments-dev workspace in <your-org>
and show me the plan logs when it finishes.
```

Review the 7 resources Terraform will create:

| Resource | Name |
|---|---|
| `ibm_is_vpc` | `payments-dev-vpc` |
| `ibm_is_subnet` | `payments-dev-subnet` |
| `ibm_is_public_gateway` | `payments-dev-pgw` |
| `ibm_is_security_group` | `payments-dev-sg` |
| `ibm_is_ssh_key` | `payments-demo-key` |
| `ibm_is_instance` | `payments-vsi` |
| `ibm_is_floating_ip` | `payments-fip` |

---

### Step 12 — Apply and retrieve the public IP (checkpoint)

Bob asks whether you want to apply. When you confirm:

```
Trigger a plan_and_apply run on payments-dev. When it finishes,
use tfctl to read the current state version and extract the public_ip output.
```

Once the apply completes (~5 minutes), connect to your VSI:

```bash
ssh -i prerequisites/ssh-keys/payments-demo ubuntu@<public_ip>
```

---

## Architecture overview

```
┌─────────────────────────────────────────────────────────┐
│  IBM Cloud — us-south-1                                 │
│                                                         │
│  ┌─────────────────────────────────────────────────┐   │
│  │  VPC: payments-dev-vpc                          │   │
│  │                                                 │   │
│  │  ┌───────────────────┐                         │   │
│  │  │  Subnet           │  ◄── Public Gateway     │   │
│  │  │  10.240.0.0/24    │                         │   │
│  │  │                   │                         │   │
│  │  │  ┌─────────────┐  │                         │   │
│  │  │  │  VSI        │  │ ◄── Floating IP         │   │
│  │  │  │  bx2-2x8    │  │     (public)            │   │
│  │  │  │  Ubuntu 22  │  │                         │   │
│  │  │  └─────────────┘  │                         │   │
│  │  └───────────────────┘                         │   │
│  │  Security Group: SSH (22) + ICMP inbound        │   │
│  └─────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

---

## Cleanup

To destroy all IBM Cloud resources and avoid charges:

```
Trigger a destroy run on the payments-dev workspace in <your-org>.
```

Or via the HCP Terraform UI: `Workspace → Settings → Destruction and Deletion → Queue destroy plan`.

---

## Troubleshooting

| Problem | Solution |
|---|---|
| `terraform validate` fails | Check that `terraform.tf` references the correct org name and workspace |
| Plan fails with auth error | Verify `IC_API_KEY` is set correctly in the `ibm-cloud-creds` variable set |
| Module not found | Confirm the `vpc-standard` module is published and the version tag exists |
| VCS connection error | Verify GitHub App or OAuth is configured under `Settings → VCS Providers` |
| SSH connection refused | Wait 2–3 minutes after apply; the VSI needs time to initialize |
| `ssh_public_key` variable missing | Ask Bob to add the workspace variable from `prerequisites/ssh-keys/payments-demo.pub` |

---

## Key concepts covered

- **Intent-based provisioning** — a single natural-language request drives the full infrastructure lifecycle
- **Private module registry** — reusable, company-approved network patterns enforced as code
- **Variable sets** — centralized credential management across all workspaces
- **VCS-driven workflows** — `git push` is the only deployment trigger; no manual `terraform apply`
- **Remote execution** — plan and apply run in HCP Terraform, never on a local machine
- **Checkpoint pattern** — Bob asks for explicit confirmation before any destructive or external action

---

## Reference

| Resource | Link |
|---|---|
| IBM Cloud provider docs | [registry.terraform.io/providers/IBM-Cloud/ibm](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs) |
| HCP Terraform docs | [developer.hashicorp.com/terraform/cloud-docs](https://developer.hashicorp.com/terraform/cloud-docs) |
| IBM Cloud VPC docs | [cloud.ibm.com/docs/vpc](https://cloud.ibm.com/docs/vpc) |
| VPC module source | [`prerequisites/modules/terraform-ibm-vpc-standard/`](prerequisites/modules/terraform-ibm-vpc-standard/) |
| Bob skill source | [`.bob/skills/provision-ibm-cloud/SKILL.md`](.bob/skills/provision-ibm-cloud/SKILL.md) |
