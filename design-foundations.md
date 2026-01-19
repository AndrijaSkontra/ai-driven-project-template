# Design Foundations (Agent-Readable)

> **⚠️ Template Note:** This document contains placeholder values that must be filled in for your project. Replace all `<placeholder>` values with your actual design tokens.

This document is the **single source of truth** for shared UI foundations across apps.

## Principles

- **Readable first**: prioritize clarity over decoration.
- **Consistent**: the same concept looks/behaves the same across platforms.
- **Accessible**: WCAG 2.1 AA for web; respect Dynamic Type on iOS.
- **Responsive**: layouts adapt; no pixel-perfect rigidity.

## Tokens

### Color

- **Primary**: `<primary-color>`
- **Primary hover/dark**: `<primary-dark-color>`
- **Success**: `<success-color>`
- **Warning**: `<warning-color>`
- **Error**: `<error-color>`

Neutrals (UI surfaces + text):

- **Bg**: `<background-color>`
- **Surface**: `<surface-color>`
- **Border**: `<border-color>`
- **Text**: `<text-color>`
- **Muted text**: `<muted-text-color>`

### Typography

- **Web**: system UI font stack; use `font-size: <font-scale>` scale.
- **iOS**: SF Pro, use Dynamic Type text styles.

### Spacing

Use a **4px base**:

`<spacing-scale>` (e.g., 4, 8, 12, 16, 24, 32, 48, 64)

### Radius

- small: `<radius-small>`
- medium: `<radius-medium>`
- pill: `<radius-pill>`

### Shadow (web)

- subtle: `<shadow-subtle>`
- hover: `<shadow-hover>`

## Components (behavioral expectations)

### Button

- Primary button uses Primary color with white text.
- Disabled state is visually obvious and non-interactive.
- Focus state is visible (web) with a 2px ring.

### Inputs

- Clear label, help text optional.
- Error state shows message and red border.
- Touch targets at least 44px tall.

### Layout

- Mobile-first; don't hardcode desktop widths.
- Max content width on web: `<max-content-width>` centered.
- Use generous whitespace and clear headings.

## Accessibility checklist (web)

- All interactive elements are keyboard reachable.
- Visible focus styles.
- Meaningful labels for inputs and buttons.
- Contrast meets AA.

## How to use with `designs/`

If a screen spec in `designs/*.md` conflicts with this file, the screen spec wins **for that screen**, but try to keep the spirit of these foundations.

---

# Design Foundations (Detailed)

> **For AI Agents:** This document contains all design specifications, tokens, and patterns that should be followed when implementing UI/UX across all applications in this project.

## Design Philosophy

Our design system emphasizes:

- **Clarity:** Clear visual hierarchy and information architecture
- **Consistency:** Unified patterns across all platforms
- **Accessibility:** WCAG 2.1 AA compliance minimum
- **Performance:** Optimized for smooth interactions
- **Modern Aesthetics:** Clean, minimal, and contemporary

## Color Palette

### Primary Colors

```
Primary:       <primary-color>
Primary Dark:  <primary-dark-color>
Primary Light: <primary-light-color>
```

### Secondary Colors

```
Secondary Green:  <secondary-green>
Secondary Red:    <secondary-red>
Secondary Yellow: <secondary-yellow>
```

### Neutral Colors

```
White:     <neutral-white>
Gray 50:   <gray-50>
Gray 100:  <gray-100>
Gray 200:  <gray-200>
Gray 300:  <gray-300>
Gray 400:  <gray-400>
Gray 500:  <gray-500>
Gray 600:  <gray-600>
Gray 700:  <gray-700>
Gray 800:  <gray-800>
Gray 900:  <gray-900>
Black:     <neutral-black>
```

### Semantic Colors

```
Success: <success-color>
Error:   <error-color>
Warning: <warning-color>
Info:    <info-color>
```

## Typography

### Font Families

- **Primary:** `<primary-font-stack>`
- **Monospace:** `<monospace-font-stack>`

### Type Scale

```
Display Large:   <display-large-size>
Display Medium:  <display-medium-size>
Heading 1:       <heading-1-size>
Heading 2:       <heading-2-size>
Heading 3:       <heading-3-size>
Heading 4:       <heading-4-size>
Body Large:      <body-large-size>
Body:            <body-size>
Body Small:      <body-small-size>
Caption:         <caption-size>
```

### Font Weights

- **Light:** `<font-weight-light>`
- **Regular:** `<font-weight-regular>`
- **Medium:** `<font-weight-medium>`
- **Semibold:** `<font-weight-semibold>`
- **Bold:** `<font-weight-bold>`

## Spacing System

Base unit: `<spacing-base-unit>`

```
xs:  <spacing-xs>
sm:  <spacing-sm>
md:  <spacing-md>
lg:  <spacing-lg>
xl:  <spacing-xl>
2xl: <spacing-2xl>
3xl: <spacing-3xl>
4xl: <spacing-4xl>
```

## Component Patterns

### Buttons

**Primary Button:**

- Background: `<button-primary-bg>`
- Text: `<button-primary-text>`
- Padding: `<button-padding>`
- Border radius: `<button-radius>`
- Font: `<button-font>`
- Hover: `<button-primary-hover>`
- Disabled: `<button-disabled-bg>` background, `<button-disabled-text>` text

**Secondary Button:**

- Background: `<button-secondary-bg>`
- Text: `<button-secondary-text>`
- Border: `<button-secondary-border>`
- Padding: `<button-padding>`
- Border radius: `<button-radius>`
- Font: `<button-font>`
- Hover: `<button-secondary-hover>`

### Cards

- Background: `<card-bg>`
- Border: `<card-border>`
- Border radius: `<card-radius>`
- Padding: `<card-padding>`
- Shadow: `<card-shadow>`
- Hover: `<card-hover-shadow>`

### Input Fields

- Background: `<input-bg>`
- Border: `<input-border>`
- Border radius: `<input-radius>`
- Padding: `<input-padding>`
- Font: `<input-font>`
- Focus: `<input-focus-border>`
- Error: `<input-error-border>`

### Navigation

- Height: `<nav-height>`
- Background: `<nav-bg>`
- Border bottom: `<nav-border>`
- Padding: `<nav-padding>`
- Font: `<nav-font>`

## Animation Guidelines

### Duration

- **Fast:** `<animation-fast>` (micro-interactions)
- **Normal:** `<animation-normal>` (standard transitions)
- **Slow:** `<animation-slow>` (complex animations)

### Easing

- **Ease In:** `<easing-in>`
- **Ease Out:** `<easing-out>`
- **Ease In Out:** `<easing-in-out>`

### Common Animations

- **Fade In:** opacity 0 → 1
- **Slide Up:** translateY(10px) → translateY(0)
- **Scale:** scale(0.95) → scale(1)
- **Hover:** transform scale(1.02) or translateY(-2px)

## Responsive Breakpoints

### Web

```
Mobile:  < <breakpoint-mobile>
Tablet:  <breakpoint-mobile> - <breakpoint-tablet>
Desktop: <breakpoint-tablet> - <breakpoint-desktop>
Large:   > <breakpoint-desktop>
```

### Mobile (iOS/Android)

- Design for smallest: `<mobile-min-width>` width
- Design for largest: `<mobile-max-width>` width
- Support all orientations

## Accessibility

### Contrast Ratios

- **Normal text:** Minimum `<contrast-normal>`
- **Large text:** Minimum `<contrast-large>`
- **Interactive elements:** Minimum `<contrast-interactive>`

### Focus States

- Visible focus indicators on all interactive elements
- Focus ring: `<focus-ring>`
- Focus offset: `<focus-offset>`

### Touch Targets

- Minimum size: `<touch-target-ios>` (iOS) / `<touch-target-android>` (Android)
- Adequate spacing between interactive elements

## Platform-Specific Guidelines

### Web

- Support keyboard navigation
- Ensure proper ARIA labels
- Optimize for various screen sizes
- Consider browser compatibility

### iOS

- Follow Human Interface Guidelines
- Use SF Symbols for icons
- Support Dynamic Type
- Respect safe areas

### Android

- Follow Material Design principles
- Use Material Icons
- Support different screen densities
- Handle system UI visibility

## Layout Principles

### Grid System

- **Web:** `<grid-columns>`-column grid with `<grid-gutter>` gutters
- **Mobile:** Flexible grid adapting to screen size
- **Consistent margins:** `<margin-mobile>` on mobile, `<margin-tablet>` on tablet, `<margin-desktop>` on desktop

### Content Width

- **Mobile:** Full width minus margins
- **Tablet:** Max `<content-max-tablet>` centered
- **Desktop:** Max `<content-max-desktop>` centered

## Image Guidelines

### Formats

- **Photos:** JPEG or WebP
- **Icons/Graphics:** SVG preferred, PNG fallback
- **Optimization:** Compress all images

### Sizes

- **Thumbnail:** `<image-thumbnail>`
- **Medium:** `<image-medium>`
- **Large:** `<image-large>`
- **Hero:** `<image-hero>`

## Icon System

- **Size:** `<icon-sizes>`
- **Style:** Outlined (default), Filled (for active states)
- **Color:** Inherit from parent or use semantic colors

---

**For AI Agents:** When implementing any UI component, refer to these specifications. If a design in `designs/` directory conflicts with these foundations, the design file takes precedence for that specific screen, but should align with these overall principles.
