# GitHub Repository Access Checker

A Bash script that lists all collaborators with **read (pull) access** to a specified GitHub repository using the GitHub REST API.

---

##  Prerequisites

Before running this script, ensure the following tools are installed on your system:

| Tool   | Purpose                              | Install Command          |
|--------|--------------------------------------|--------------------------|
| `curl` | Makes HTTP requests to the GitHub API | Pre-installed on most systems |
| `jq`   | Parses and filters JSON responses     | `sudo apt install jq`    |

---

##  Setup & Configuration

### Step 1 — Generate a GitHub Personal Access Token (PAT)

1. Log in to the GitHub account of the **repository owner**
2. Click your **profile picture** (top-right corner)
3. Go to **Settings**
4. Scroll down and click **Developer Settings**
5. Click **Personal Access Tokens** → select **Tokens (classic)**
6. Click **Generate new token** (top-right)
7. Give the token a descriptive name, set an expiry, and grant the following scopes:
   -  `repo` — Full control of private repositories
   -  `read:org` — Read org and team membership
8. Click **Generate token**
9. **Copy the token immediately** — it will not be shown again

---

### Step 2 — Export Your Credentials as Environment Variables

Open your terminal and run the following commands, replacing the placeholder values with your actual credentials:

```bash
export username="your-github-username"
export token="your-personal-access-token"
```

>  **Important:** These variables must be exported in the same terminal session where you run the script. They are not persisted across sessions.

---

### Step 3 — Grant Execute Permission to the Script

```bash
chmod 755 list-users.sh
```

> 💡 `755` is recommended over `777` as it grants execute permission without allowing others to write to the file.

---

## Usage

```bash
sh list-users.sh <REPO_OWNER> <REPO_NAME>
```

Or if execute permission is granted:

```bash
./list-users.sh <REPO_OWNER> <REPO_NAME>
```

### Arguments

| Argument     | Description                                      | Example        |
|--------------|--------------------------------------------------|----------------|
| `REPO_OWNER` | The GitHub organization name or repository owner | `my-org`       |
| `REPO_NAME`  | The name of the target repository                | `my-repo`      |

### Example

```bash
export username="john-doe"
export token="ghp_xxxxxxxxxxxxxxxxxxxx"

./list-users.sh my-org my-repo
```

### Help

```bash
./list-users.sh --help
```

---

##  Expected Output

Listing users with read access to my-org/my-repo...
Users with read access to my-org/my-repo:
alice
bob
charlie

If no users are found:

##  Expected Output

No users with read access found for my-org/my-repo.

---

##  Troubleshooting

| Error                        | Cause                                      | Fix                                              |
|------------------------------|--------------------------------------------|--------------------------------------------------|
| `jq: command not found`      | `jq` is not installed                      | Run `sudo apt install jq`                        |
| `curl: command not found`    | `curl` is not installed                    | Run `sudo apt install curl`                      |
| `Error: Missing arguments`   | No arguments passed to the script          | Provide `REPO_OWNER` and `REPO_NAME`             |
| `Error: Missing env variables` | Credentials not exported               | Run `export username` and `export token`         |
| Empty collaborator list      | Token lacks sufficient permissions         | Regenerate token with `repo` and `read:org` scopes |

---

##  Security Notes

- **Never hardcode** your token or username directly in the script
- **Never commit** credentials to version control — add `.env` to your `.gitignore`
- Tokens should be scoped with the **minimum required permissions**
- Rotate your token regularly and revoke it when no longer needed

---

##  Notes

- You must authenticate with the **organization's GitHub account** to check access on organization-owned repositories
- To list **admins** instead of read-access users, update the `jq` filter in the script from:
```bash
  select(.permissions.pull == true)
```
  to:
```bash
  select(.permissions.admin == true)
```