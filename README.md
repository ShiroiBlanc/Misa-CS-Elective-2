# cs_elective_2

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, and a full API reference.

## Google authentication

Enable the Google provider in Supabase Authentication. Configure an OAuth
client in Google Cloud and copy its client ID and secret into Supabase.
Use this redirect URL in the Google OAuth client settings:

`https://<project-ref>.supabase.co/auth/v1/callback`

Add this mobile redirect URL to Supabase Authentication URL Configuration:

`io.supabase.cs_elective_2://login-callback/`

The app loads `SUPABASE_URL` and `SUPABASE_ANON_KEY` from `.env`, starts
authentication from the Google button, and returns to the shop after sign-in.

## Assignment setup

Run [`supabase/schema.sql`](supabase/schema.sql) in the Supabase SQL Editor
before launching the app. It creates the role-based schema, signup trigger,
checkout function, RLS policies, and sample products.

To make an account an administrator, update its profile after signing up:

```sql
update public.profiles
set role_id = (select id from public.roles where role = 'admin')
where email = 'admin@example.com';
```
