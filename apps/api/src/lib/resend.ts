/**
 * Resend Email Client Configuration for Cloudflare Workers
 *
 * This module provides email sending capabilities using Resend.
 * It uses environment variables passed from wrangler.jsonc bindings.
 *
 * @see https://resend.com/docs
 */

import { Resend, type CreateEmailOptions } from 'resend';

/**
 * Environment bindings interface for Resend
 */
export interface ResendEnv {
  RESEND_KEY: string;
}

/**
 * Re-export the CreateEmailOptions type from Resend for convenience
 */
export type { CreateEmailOptions as SendEmailOptions };

/**
 * Create a Resend client for sending emails
 *
 * @example
 * ```typescript
 * import { createResendClient } from './lib/resend';
 *
 * app.post('/send-email', async (c) => {
 *   const resend = createResendClient(c.env);
 *   const { data, error } = await resend.emails.send({
 *     from: 'onboarding@resend.dev',
 *     to: 'user@example.com',
 *     subject: 'Hello!',
 *     html: '<p>Welcome to our app!</p>',
 *   });
 *   return c.json({ data, error });
 * });
 * ```
 */
export function createResendClient(env: ResendEnv): Resend {
  if (!env.RESEND_KEY) {
    throw new Error('Missing required environment variable: RESEND_KEY');
  }

  return new Resend(env.RESEND_KEY);
}

/**
 * Helper function to send an email with simplified options
 *
 * @example
 * ```typescript
 * import { sendEmail } from './lib/resend';
 *
 * app.post('/contact', async (c) => {
 *   const { error } = await sendEmail(c.env, {
 *     from: 'noreply@yourdomain.com',
 *     to: 'admin@yourdomain.com',
 *     subject: 'New Contact Form Submission',
 *     html: '<p>Someone contacted you!</p>',
 *   });
 *
 *   if (error) {
 *     return c.json({ error: error.message }, 500);
 *   }
 *   return c.json({ success: true });
 * });
 * ```
 */
export async function sendEmail(env: ResendEnv, options: CreateEmailOptions) {
  const resend = createResendClient(env);
  return resend.emails.send(options);
}
