export default {
  extends: ['@commitlint/config-conventional'],
  rules: {
    // Type must be one of these
    'type-enum': [
      2,
      'always',
      [
        'feat', // New feature
        'fix', // Bug fix
        'docs', // Documentation changes
        'style', // Code style changes (formatting, semicolons, etc.)
        'refactor', // Code refactoring (no functional changes)
        'perf', // Performance improvements
        'test', // Adding or updating tests
        'build', // Build system or external dependencies
        'ci', // CI/CD configuration
        'chore', // Maintenance tasks
        'revert', // Reverting previous commits
      ],
    ],
    // Type must be lowercase
    'type-case': [2, 'always', 'lower-case'],
    // Type cannot be empty
    'type-empty': [2, 'never'],
    // Subject cannot be empty
    'subject-empty': [2, 'never'],
    // Subject must be lowercase
    'subject-case': [2, 'always', 'lower-case'],
    // Subject should not end with period
    'subject-full-stop': [2, 'never', '.'],
    // Header max length (type + scope + subject)
    'header-max-length': [2, 'always', 100],
    // Body max line length
    'body-max-line-length': [2, 'always', 100],
  },
};
