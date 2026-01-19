export default {
  // Format TypeScript and JavaScript files
  '*.{ts,tsx,js,jsx,mjs,cjs}': ['prettier --write'],

  // Format JSON, YAML, and Markdown files
  '*.{json,yaml,yml,md}': ['prettier --write'],

  // Format CSS and related files
  '*.{css,scss,sass,less}': ['prettier --write'],

  // Format HTML files
  '*.html': ['prettier --write'],
};
