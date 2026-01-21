# Kanban Project Management App - Implementation Plan

## Environment Status (Verified ✅)

| Variable                  | Status |
| ------------------------- | ------ |
| CLOUDFLARE_API            | ✅ Set |
| CLOUDFLARE_ACCOUNT_ID     | ✅ Set |
| SUPABASE_URL              | ✅ Set |
| SUPABASE_ANON_KEY         | ✅ Set |
| SUPABASE_SERVICE_ROLE_KEY | ✅ Set |
| SUPABASE_PROJECT_REF      | ✅ Set |

**Ready for deployment to Cloudflare Workers and Supabase.**

---

## Overview

Build a full-featured project management application with:

- **Kanban boards** (advanced: swimlanes, templates, automations)
- **Chat/posting board** (real-time)
- **Calendar** (integrated with tasks)
- **Role-based access** (Admin & Worker roles)

## Tech Stack

| Layer           | Technology                            |
| --------------- | ------------------------------------- |
| Frontend        | Next.js 14+ (App Router)              |
| Backend API     | Hono on Cloudflare Workers (existing) |
| Database        | Supabase PostgreSQL with RLS          |
| Auth            | Supabase Auth (Magic Link)            |
| Real-time       | Supabase Realtime                     |
| Background Jobs | Trigger.dev (existing)                |
| File Storage    | Supabase Storage                      |

## Database Schema

### Core Tables

```sql
-- Users (extends Supabase auth.users)
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL,
  full_name TEXT,
  avatar_url TEXT,
  role TEXT NOT NULL DEFAULT 'worker' CHECK (role IN ('admin', 'worker')),
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Workspaces (multi-tenant support)
CREATE TABLE workspaces (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  created_by UUID REFERENCES profiles(id),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Workspace Members
CREATE TABLE workspace_members (
  workspace_id UUID REFERENCES workspaces(id) ON DELETE CASCADE,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  role TEXT NOT NULL DEFAULT 'worker' CHECK (role IN ('admin', 'worker')),
  joined_at TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (workspace_id, user_id)
);

-- Boards
CREATE TABLE boards (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID REFERENCES workspaces(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  is_archived BOOLEAN DEFAULT false,
  created_by UUID REFERENCES profiles(id),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Columns
CREATE TABLE columns (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  board_id UUID REFERENCES boards(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  position INTEGER NOT NULL,
  color TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Labels
CREATE TABLE labels (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  board_id UUID REFERENCES boards(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  color TEXT NOT NULL
);

-- Cards
CREATE TABLE cards (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  column_id UUID REFERENCES columns(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  position INTEGER NOT NULL,
  due_date TIMESTAMPTZ,
  swimlane_value TEXT, -- For grouping (assignee_id, priority, etc.)
  swimlane_type TEXT,  -- 'assignee' | 'priority' | 'label' | null
  template_id UUID REFERENCES card_templates(id),
  created_by UUID REFERENCES profiles(id),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Card Assignees (many-to-many)
CREATE TABLE card_assignees (
  card_id UUID REFERENCES cards(id) ON DELETE CASCADE,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  assigned_at TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (card_id, user_id)
);

-- Card Labels (many-to-many)
CREATE TABLE card_labels (
  card_id UUID REFERENCES cards(id) ON DELETE CASCADE,
  label_id UUID REFERENCES labels(id) ON DELETE CASCADE,
  PRIMARY KEY (card_id, label_id)
);

-- Card Comments
CREATE TABLE card_comments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  card_id UUID REFERENCES cards(id) ON DELETE CASCADE,
  user_id UUID REFERENCES profiles(id),
  content TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Card Templates
CREATE TABLE card_templates (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  board_id UUID REFERENCES boards(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  title_template TEXT,
  description_template TEXT,
  default_labels UUID[],
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Automations
CREATE TABLE automations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  board_id UUID REFERENCES boards(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  trigger_type TEXT NOT NULL, -- 'due_date_passed' | 'card_moved' | 'assigned'
  trigger_config JSONB,
  action_type TEXT NOT NULL,  -- 'move_card' | 'notify' | 'add_label'
  action_config JSONB,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Chat Channels
CREATE TABLE channels (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID REFERENCES workspaces(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  is_private BOOLEAN DEFAULT false,
  created_by UUID REFERENCES profiles(id),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Chat Messages
CREATE TABLE messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  channel_id UUID REFERENCES channels(id) ON DELETE CASCADE,
  user_id UUID REFERENCES profiles(id),
  content TEXT NOT NULL,
  reply_to UUID REFERENCES messages(id),
  attachments JSONB DEFAULT '[]',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Message Reactions
CREATE TABLE message_reactions (
  message_id UUID REFERENCES messages(id) ON DELETE CASCADE,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  emoji TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  PRIMARY KEY (message_id, user_id, emoji)
);

-- Calendar Events
CREATE TABLE calendar_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id UUID REFERENCES workspaces(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  start_time TIMESTAMPTZ NOT NULL,
  end_time TIMESTAMPTZ NOT NULL,
  all_day BOOLEAN DEFAULT false,
  card_id UUID REFERENCES cards(id) ON DELETE SET NULL, -- Link to kanban card
  created_by UUID REFERENCES profiles(id),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Event Attendees
CREATE TABLE event_attendees (
  event_id UUID REFERENCES calendar_events(id) ON DELETE CASCADE,
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'declined')),
  PRIMARY KEY (event_id, user_id)
);
```

### Row Level Security (RLS) Policies

```sql
-- Profiles: Users can read all profiles in their workspace, update own
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view profiles in their workspaces" ON profiles
  FOR SELECT USING (
    id IN (
      SELECT wm.user_id FROM workspace_members wm
      WHERE wm.workspace_id IN (
        SELECT workspace_id FROM workspace_members WHERE user_id = auth.uid()
      )
    )
  );

CREATE POLICY "Users can update own profile" ON profiles
  FOR UPDATE USING (id = auth.uid());

-- Workspace members can access workspace data
CREATE POLICY "Workspace access" ON boards
  FOR ALL USING (
    workspace_id IN (
      SELECT workspace_id FROM workspace_members WHERE user_id = auth.uid()
    )
  );

-- Admin-only policies for user management
CREATE POLICY "Admins can manage workspace members" ON workspace_members
  FOR ALL USING (
    EXISTS (
      SELECT 1 FROM workspace_members
      WHERE workspace_id = workspace_members.workspace_id
      AND user_id = auth.uid()
      AND role = 'admin'
    )
  );
```

## API Endpoints (Hono)

### Authentication

- `POST /auth/magic-link` - Send magic link email
- `GET /auth/callback` - Handle magic link callback
- `GET /auth/me` - Get current user profile
- `POST /auth/logout` - Sign out

### User Management (Admin only)

- `GET /users` - List all users in workspace
- `POST /users/invite` - Invite user via email
- `PATCH /users/:id/role` - Change user role
- `PATCH /users/:id/status` - Activate/deactivate user

### Workspaces

- `GET /workspaces` - List user's workspaces
- `POST /workspaces` - Create workspace
- `GET /workspaces/:id` - Get workspace details
- `PATCH /workspaces/:id` - Update workspace

### Boards

- `GET /workspaces/:id/boards` - List boards
- `POST /workspaces/:id/boards` - Create board
- `GET /boards/:id` - Get board with columns & cards
- `PATCH /boards/:id` - Update board
- `DELETE /boards/:id` - Archive board

### Columns

- `POST /boards/:id/columns` - Create column
- `PATCH /columns/:id` - Update column
- `DELETE /columns/:id` - Delete column
- `POST /columns/reorder` - Reorder columns

### Cards

- `POST /columns/:id/cards` - Create card
- `GET /cards/:id` - Get card details
- `PATCH /cards/:id` - Update card
- `DELETE /cards/:id` - Delete card
- `POST /cards/:id/move` - Move card (column/position)
- `POST /cards/:id/assignees` - Add assignee
- `DELETE /cards/:id/assignees/:userId` - Remove assignee
- `POST /cards/:id/labels` - Add label
- `DELETE /cards/:id/labels/:labelId` - Remove label
- `POST /cards/:id/comments` - Add comment

### Templates & Automations

- `GET /boards/:id/templates` - List templates
- `POST /boards/:id/templates` - Create template
- `GET /boards/:id/automations` - List automations
- `POST /boards/:id/automations` - Create automation
- `PATCH /automations/:id` - Update automation

### Chat

- `GET /workspaces/:id/channels` - List channels
- `POST /workspaces/:id/channels` - Create channel
- `GET /channels/:id/messages` - Get messages (paginated)
- `POST /channels/:id/messages` - Send message
- `POST /messages/:id/reactions` - Add reaction
- `DELETE /messages/:id/reactions/:emoji` - Remove reaction

### Calendar

- `GET /workspaces/:id/events` - Get events (date range)
- `POST /workspaces/:id/events` - Create event
- `PATCH /events/:id` - Update event
- `DELETE /events/:id` - Delete event
- `GET /workspaces/:id/calendar/tasks` - Get tasks for calendar view

## Frontend Structure (Next.js App Router)

```
apps/web/
├── app/
│   ├── (auth)/
│   │   ├── login/page.tsx
│   │   ├── auth/callback/route.ts
│   │   └── layout.tsx
│   ├── (dashboard)/
│   │   ├── layout.tsx              # Sidebar, header
│   │   ├── page.tsx                # Dashboard home
│   │   ├── boards/
│   │   │   ├── page.tsx            # Boards list
│   │   │   └── [boardId]/
│   │   │       ├── page.tsx        # Kanban view
│   │   │       └── settings/page.tsx
│   │   ├── chat/
│   │   │   ├── page.tsx            # Channel list
│   │   │   └── [channelId]/page.tsx
│   │   ├── calendar/
│   │   │   └── page.tsx
│   │   └── admin/
│   │       ├── users/page.tsx
│   │       └── settings/page.tsx
│   ├── api/                        # Next.js API routes (optional)
│   └── layout.tsx
├── components/
│   ├── ui/                         # Base components (shadcn/ui)
│   ├── kanban/
│   │   ├── Board.tsx
│   │   ├── Column.tsx
│   │   ├── Card.tsx
│   │   ├── CardModal.tsx
│   │   └── Swimlane.tsx
│   ├── chat/
│   │   ├── ChannelList.tsx
│   │   ├── MessageList.tsx
│   │   ├── MessageInput.tsx
│   │   └── Message.tsx
│   ├── calendar/
│   │   ├── CalendarView.tsx
│   │   └── EventModal.tsx
│   └── layout/
│       ├── Sidebar.tsx
│       └── Header.tsx
├── lib/
│   ├── supabase/
│   │   ├── client.ts               # Browser client
│   │   ├── server.ts               # Server client
│   │   └── middleware.ts
│   ├── api.ts                      # API client
│   └── utils.ts
├── hooks/
│   ├── useRealtimeMessages.ts
│   ├── useRealtimeCards.ts
│   └── useAuth.ts
└── types/
    └── index.ts
```

## Implementation Phases

### Phase 1: Foundation (Week 1-2)

**Goal:** Auth, database, and basic project structure

1. Set up Next.js app in `apps/web`
2. Configure Supabase Auth with Magic Link
3. Create database migrations (all tables)
4. Set up RLS policies
5. Create profile management on sign-up
6. Build auth UI (login, callback handling)
7. Create basic dashboard layout

**Files to create/modify:**

- `apps/web/` - New Next.js app
- `supabase/migrations/` - Database schema
- `apps/api/src/routes/auth.ts` - Auth endpoints

### Phase 2: User & Workspace Management (Week 2-3)

**Goal:** Admin functionality and workspace setup

1. Build user management API (invite, roles, status)
2. Create workspace CRUD
3. Build admin UI for user management
4. Implement role-based route protection
5. Add workspace switcher

**Files to create/modify:**

- `apps/api/src/routes/users.ts`
- `apps/api/src/routes/workspaces.ts`
- `apps/api/src/middleware/auth.ts`
- `apps/web/app/(dashboard)/admin/`

### Phase 3: Kanban Board (Week 3-5)

**Goal:** Full kanban functionality

1. Board, column, card CRUD APIs
2. Build kanban UI with drag-and-drop (@dnd-kit/core)
3. Card modal with all fields
4. Labels and assignees
5. Comments system
6. Swimlane grouping
7. Card templates
8. Real-time card updates via Supabase Realtime

**Files to create/modify:**

- `apps/api/src/routes/boards.ts`
- `apps/api/src/routes/cards.ts`
- `apps/web/components/kanban/`

### Phase 4: Chat System (Week 5-6)

**Goal:** Real-time messaging

1. Channel and message APIs
2. Real-time subscriptions setup
3. Chat UI with message list
4. Rich text input (Tiptap or similar)
5. File uploads (Supabase Storage)
6. Reactions
7. Thread replies

**Files to create/modify:**

- `apps/api/src/routes/channels.ts`
- `apps/api/src/routes/messages.ts`
- `apps/web/components/chat/`
- `apps/web/hooks/useRealtimeMessages.ts`

### Phase 5: Calendar (Week 6-7)

**Goal:** Calendar view and events

1. Calendar events API
2. Calendar UI (@fullcalendar/react)
3. Event creation/editing modal
4. Task integration (show card due dates)
5. Attendee management

**Files to create/modify:**

- `apps/api/src/routes/calendar.ts`
- `apps/web/components/calendar/`
- `apps/web/app/(dashboard)/calendar/`

### Phase 6: Automations & Polish (Week 7-8)

**Goal:** Automations and production readiness

1. Automation rules API
2. Trigger.dev jobs for automation execution:
   - Due date checker (scheduled)
   - Card move handler
   - Notification sender
3. Automation builder UI
4. Email notifications
5. Performance optimization
6. Error handling & loading states

**Files to create/modify:**

- `apps/api/src/routes/automations.ts`
- `apps/jobs/src/automation-*.ts`
- `apps/web/components/automations/`

## Key Libraries

### Frontend (apps/web)

```json
{
  "dependencies": {
    "next": "^14.0.0",
    "@supabase/supabase-js": "^2.x",
    "@supabase/ssr": "^0.x",
    "@dnd-kit/core": "^6.x",
    "@dnd-kit/sortable": "^8.x",
    "@fullcalendar/react": "^6.x",
    "@fullcalendar/daygrid": "^6.x",
    "@tiptap/react": "^2.x",
    "date-fns": "^3.x",
    "zustand": "^4.x",
    "tailwindcss": "^3.x"
  }
}
```

## Verification & Testing

After each phase, verify:

1. **Auth:** Magic link email received, login works, session persists
2. **RLS:** Users only see their workspace data
3. **Admin:** Only admins can access /admin routes and user management
4. **Kanban:** Drag-drop works, changes persist, real-time sync
5. **Chat:** Messages appear instantly for all users in channel
6. **Calendar:** Events display correctly, task due dates sync

### Manual Testing Checklist

- [ ] Sign up with magic link
- [ ] Create workspace
- [ ] Invite another user as worker
- [ ] Create board with columns
- [ ] Create and move cards
- [ ] Add comments to cards
- [ ] Send messages in chat (verify real-time)
- [ ] Create calendar events
- [ ] Test admin can change roles
- [ ] Test worker cannot access admin features

### Automated Tests

- API endpoint tests with Vitest
- E2E tests with Playwright (MCP configured)
