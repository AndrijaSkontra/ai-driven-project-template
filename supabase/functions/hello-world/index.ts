// Supabase Edge Function - Hello World
// Deno runtime

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';

interface RequestBody {
  name?: string;
}

serve(async (req) => {
  // Handle CORS preflight requests
  if (req.method === 'OPTIONS') {
    return new Response(null, {
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
      },
    });
  }

  try {
    // Parse request body if present
    let name = 'World';
    if (req.method === 'POST') {
      const body: RequestBody = await req.json();
      name = body.name || 'World';
    }

    // Get query parameter if present
    const url = new URL(req.url);
    const queryName = url.searchParams.get('name');
    if (queryName) {
      name = queryName;
    }

    // Create response
    const data = {
      message: `Hello ${name}!`,
      timestamp: new Date().toISOString(),
      function: 'hello-world',
      runtime: 'Deno',
    };

    return new Response(JSON.stringify(data, null, 2), {
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
      },
      status: 200,
    });
  } catch (error) {
    return new Response(
      JSON.stringify({
        error: 'Internal Server Error',
        message: error.message,
      }),
      {
        headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
        },
        status: 500,
      }
    );
  }
});
