import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class Supabase {
  static final supabase.SupabaseClient client =
      supabase.Supabase.instance.client;

  Future<void> initialSupabase() async {
    await supabase.Supabase.initialize(
          url: "https://ybhcryoaddiiedlffgki.supabase.co",
          anonKey:
              "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InliaGNyeW9hZGRpaWVkbGZmZ2tpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc4NjgyMjEsImV4cCI6MjA3MzQ0NDIyMX0.ohS_EoHjx4WUYL44YHo_NvbQMrtuvEsQUhL6H1qmP5k",
        )
        .onError((supabaseError, stackTrace) {
          debugPrint(supabaseError.toString());
          throw Exception(supabaseError.toString());
        })
        .whenComplete(() => debugPrint("Supabase initialized"));
  }
}
