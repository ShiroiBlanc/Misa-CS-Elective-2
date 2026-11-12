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

## Discord authentication

Enable the Discord provider in Supabase Authentication. Create a Discord
application in the Discord Developer Portal, copy its client ID and secret
into the Supabase Discord provider settings, and use this redirect URL in the
Discord application OAuth2 settings:

`https://<project-ref>.supabase.co/auth/v1/callback`

Add this mobile redirect URL to Supabase Authentication URL Configuration:

`io.supabase.cs_elective_2://login-callback/`

The app loads `SUPABASE_URL` and `SUPABASE_ANON_KEY` from `.env`, starts
authentication from the Discord button, and returns to the shop after sign-in.
