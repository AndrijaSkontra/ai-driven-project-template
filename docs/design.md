# Design System

This template includes a design system to ensure consistent UI/UX across all applications.

## Design Foundations

The `design-foundations.md` file is the **single source of truth** for shared UI foundations.

> **Important:** This file contains placeholder values (`<placeholder>`) that must be replaced with your actual design tokens before use.

### What to Define

- Color palette (primary, secondary, semantic colors)
- Typography (font families, type scale, weights)
- Spacing system
- Component patterns (buttons, cards, inputs)
- Animation guidelines
- Responsive breakpoints

## Screen Designs

Individual screen designs live in the `designs/` folder. Each design file can specify:

- Screen layout and components
- User interactions and flows
- Screen-specific overrides to the foundations

> **Note:** If a screen spec in `designs/*.md` conflicts with `design-foundations.md`, the screen spec wins for that specific screen.

## Creating ASCII Wireframes

For quick wireframing, use [ASCII Flow](https://asciiflow.com) — a free web app for drawing ASCII diagrams.

### How to Use ASCII Flow

1. **Visit** [https://asciiflow.com](https://asciiflow.com)
2. **Draw** your wireframe using the tools:
   - Rectangle tool for containers, cards, buttons
   - Line tool for borders and separators
   - Text tool for labels and content
   - Arrow tool for flows and connections
3. **Export** your diagram (Select All → Copy)
4. **Paste** into your design file in `designs/`

### Example Wireframe

```
┌────────────────────────────────────┐
│  Header                      [Menu]│
├────────────────────────────────────┤
│                                    │
│  ┌──────────┐  ┌──────────┐       │
│  │  Card 1  │  │  Card 2  │       │
│  └──────────┘  └──────────┘       │
│                                    │
│  [Primary Button]                  │
│                                    │
└────────────────────────────────────┘
```

## AI Workflow for Screen Design

1. **Sketch in ASCII Flow** — Draw a rough wireframe of your screen
2. **Create a design file** — Save as `designs/your-screen.md`
3. **Add the wireframe** — Paste your ASCII art in a code block
4. **Add specifications** — Document interactions, states, and data
5. **Share with AI** — Tell your AI agent:
   > "Read `designs/your-screen.md` and `design-foundations.md`, then implement this screen"

### Example Prompt

```
Read the design spec in designs/dashboard.md along with design-foundations.md.
Implement this screen using React/SwiftUI/etc following the design tokens and
patterns defined in the foundations.
```

This workflow gives AI agents clear visual context and design constraints, resulting in more accurate implementations.
