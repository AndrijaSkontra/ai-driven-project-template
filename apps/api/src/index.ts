import { Hono } from 'hono';
import pc from 'picocolors';
import { createSupabaseClient, type Env } from './lib/supabase';

const app = new Hono<{ Bindings: Env }>();

app.get('/', (c) => {
  console.log(pc.green(`Starting the ${pc.italic(`server`)}`));
  return c.text('AI start in feature testing! New feature');
});

app.get('/db-test', async (c) => {
  try {
    // Get environment variables from Cloudflare Workers bindings
    const env = c.env;

    // Check if Supabase is configured
    if (!env.SUPABASE_URL || !env.SUPABASE_ANON_KEY) {
      return c.json(
        {
          status: 'not_configured',
          message:
            'Supabase environment variables not set. Please configure SUPABASE_URL and SUPABASE_ANON_KEY.',
          configured: false,
        },
        200
      );
    }

    // Create Supabase client
    const supabase = createSupabaseClient(env);

    // Test connection by fetching Supabase metadata
    // This doesn't require any tables to exist
    const { data, error } = await supabase.auth.getSession();

    if (error && error.message !== 'Auth session missing!') {
      throw error;
    }

    return c.json({
      status: 'connected',
      message: 'Successfully connected to Supabase!',
      configured: true,
      supabase_url: env.SUPABASE_URL,
      timestamp: new Date().toISOString(),
    });
  } catch (error) {
    console.error('Supabase connection error:', error);
    return c.json(
      {
        status: 'error',
        message: error instanceof Error ? error.message : 'Unknown error occurred',
        configured: true,
      },
      500
    );
  }
});

export default app;
