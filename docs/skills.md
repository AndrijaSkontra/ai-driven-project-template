# Claude Code Skills

This project includes custom skills to streamline common development tasks.

## `/dependencies`

Manage project dependencies across all apps.

| Feature            | Description                                   |
| ------------------ | --------------------------------------------- |
| **Auto-detection** | Runs `bun install` in the correct directories |
| **Verification**   | Confirms installation success                 |
| **Cross-platform** | Works on Unix/Mac/Windows                     |

**Usage:**

```
/dependencies
```

## `/check-envs`

Validate environment variables configuration.

| Feature                   | Description                                |
| ------------------------- | ------------------------------------------ |
| **Required vars**         | Checks Cloudflare credentials              |
| **Optional vars**         | Checks Supabase configuration              |
| **Placeholder detection** | Identifies values that need updating       |
| **Status report**         | Color-coded output with setup instructions |
| **Cross-platform**        | Works on Unix/Mac/Windows                  |

**Usage:**

```
/check-envs
```

**Output Legend:**

- ✅ Variable is properly configured
- ⚠️ Placeholder value detected
- ❌ Required variable is missing

## `/deployment`

Unified deployment to Cloudflare Workers and/or Supabase Edge Functions.

| Feature                | Description                                                |
| ---------------------- | ---------------------------------------------------------- |
| **Platform selection** | Interactive choice: Cloudflare / Supabase / Both           |
| **Validation**         | Verifies platform-specific environment variables           |
| **Branch detection**   | Automatically detects git branch for environment targeting |
| **Status report**      | Returns deployment URLs and status                         |
| **Cross-platform**     | Works on Unix/Mac/Windows                                  |

**Usage:**

```
/deployment
```

**Deployment URLs:**

- **Cloudflare Production:** `https://api.<subdomain>.workers.dev`
- **Cloudflare Preview:** `https://api-<branch>.<subdomain>.workers.dev`
- **Supabase Production:** `https://<project-ref>.supabase.co/functions/v1/`
- **Supabase Preview:** `https://<branch-ref>.supabase.co/functions/v1/`

## Creating Custom Skills

Skills are defined in `.claude/skills/`. Each skill has:

```
.claude/skills/
└── skill-name/
    ├── SKILL.md          # Skill definition and instructions
    └── scripts/
        ├── script.sh     # Unix/Mac script
        └── script.ps1    # Windows script
```

See existing skills for examples of the structure.
