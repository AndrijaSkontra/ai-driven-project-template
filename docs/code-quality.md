# Git Hooks & Code Quality

This project uses [Husky](https://typicode.github.io/husky/) to enforce code quality standards via Git hooks. All hooks run automatically — no manual intervention required.

## Automated Checks

| Hook           | When                        | What it does                                                                                         |
| -------------- | --------------------------- | ---------------------------------------------------------------------------------------------------- |
| **pre-commit** | Before each commit          | Runs Prettier on staged files to ensure consistent formatting                                        |
| **commit-msg** | When writing commit message | Validates commit messages follow [Conventional Commits](https://www.conventionalcommits.org/) format |

## Commit Message Format

All commits must follow the **Conventional Commits** specification:

```
<type>(<scope>): <subject>

[optional body]

[optional footer]
```

### Allowed Types

| Type       | Description                                 |
| ---------- | ------------------------------------------- |
| `feat`     | New feature                                 |
| `fix`      | Bug fix                                     |
| `docs`     | Documentation changes                       |
| `style`    | Code style changes (formatting, semicolons) |
| `refactor` | Code refactoring (no functional changes)    |
| `perf`     | Performance improvements                    |
| `test`     | Adding or updating tests                    |
| `build`    | Build system or external dependencies       |
| `ci`       | CI/CD configuration                         |
| `chore`    | Maintenance tasks                           |
| `revert`   | Reverting previous commits                  |

### Examples

```bash
# ✅ Good commit messages
git commit -m "feat: add user authentication"
git commit -m "fix(api): resolve database connection timeout"
git commit -m "docs: update README with deployment instructions"
git commit -m "refactor(auth): simplify token validation logic"

# ❌ Bad commit messages (will be rejected)
git commit -m "fixed stuff"
git commit -m "WIP"
git commit -m "Update file"
```

## Code Formatting

The project uses [Prettier](https://prettier.io/) for consistent code formatting.

### Commands

```bash
# Format all files
bun run format

# Check formatting without making changes
bun run format:check
```

### Supported File Types

- TypeScript/JavaScript (`.ts`, `.tsx`, `.js`, `.jsx`)
- JSON/YAML (`.json`, `.yaml`, `.yml`)
- Markdown (`.md`)
- CSS/SCSS (`.css`, `.scss`)
- HTML (`.html`)

## Configuration Files

| File                    | Purpose                            |
| ----------------------- | ---------------------------------- |
| `.husky/pre-commit`     | Pre-commit hook script             |
| `.husky/commit-msg`     | Commit message validation hook     |
| `commitlint.config.js`  | Commit message rules               |
| `lint-staged.config.js` | Staged files linting configuration |
| `.prettierrc`           | Prettier formatting rules          |
| `.prettierignore`       | Files to exclude from formatting   |

## Bypassing Hooks (Emergency Only)

In rare cases where you need to bypass hooks (not recommended):

```bash
# Skip pre-commit hook
git commit --no-verify -m "feat: emergency fix"

# Skip all hooks
HUSKY=0 git commit -m "feat: emergency fix"
```

> **Warning:** Only bypass hooks in genuine emergencies. Bypassing regularly defeats the purpose of automated quality checks.
