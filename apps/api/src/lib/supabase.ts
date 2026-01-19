/**
 * Supabase Client Configuration for Cloudflare Workers
 *
 * This module provides Supabase client setup for use in the Hono API.
 * It uses environment variables passed from wrangler.jsonc bindings.
 */

import { createClient, SupabaseClient } from '@supabase/supabase-js';

/**
 * Environment bindings interface for Cloudflare Workers
 * These should be defined in wrangler.jsonc
 */
export interface Env {
  SUPABASE_URL: string;
  SUPABASE_ANON_KEY: string;
  SUPABASE_SERVICE_ROLE_KEY?: string;
}

/**
 * Create a Supabase client with anonymous key (respects RLS)
 * Use this for client-facing endpoints
 */
export function createSupabaseClient(env: Env): SupabaseClient {
  if (!env.SUPABASE_URL || !env.SUPABASE_ANON_KEY) {
    throw new Error(
      'Missing required Supabase environment variables: SUPABASE_URL and SUPABASE_ANON_KEY'
    );
  }

  return createClient(env.SUPABASE_URL, env.SUPABASE_ANON_KEY, {
    auth: {
      persistSession: false, // Disable persistence for edge functions
      autoRefreshToken: false,
      detectSessionInUrl: false,
    },
  });
}

/**
 * Create a Supabase client with service role key (bypasses RLS)
 * Use this ONLY for server-side operations that need admin access
 * WARNING: Never expose service role key to client
 */
export function createSupabaseAdminClient(env: Env): SupabaseClient {
  if (!env.SUPABASE_URL || !env.SUPABASE_SERVICE_ROLE_KEY) {
    throw new Error(
      'Missing required Supabase environment variables: SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY'
    );
  }

  return createClient(env.SUPABASE_URL, env.SUPABASE_SERVICE_ROLE_KEY, {
    auth: {
      persistSession: false,
      autoRefreshToken: false,
      detectSessionInUrl: false,
    },
  });
}
