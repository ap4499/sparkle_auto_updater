
import 'package:flet/flet.dart';
import 'package:flutter/material.dart';
import 'package:auto_updater/auto_updater.dart';
import 'dart:async';

class SparkleAutoUpdaterControl extends StatefulWidget {
  final Control? parent;
  final Control control;
  final List<Control> children;
  final bool parentDisabled;
  final FletControlBackend backend; // Needs backend object

  const SparkleAutoUpdaterControl({
    super.key,
    required this.parent,
    required this.control,
    required this.children,
    required this.parentDisabled,
    required this.backend, // Needs backend object
  });

  @override
  State<SparkleAutoUpdaterControl> createState() => _SparkleAutoUpdaterControlState();
}

class _SparkleAutoUpdaterControlState extends State<SparkleAutoUpdaterControl> {
  String? _currentFeedURL; // Store the currently configured URL

  @override
  void initState() {
    super.initState();
    debugPrint("[Sparkle Control Init] initState START"); // Log start
    try {
      // Subscribe to method calls from Python
      widget.backend.subscribeMethods(widget.control.id, _handleMethodCall);
      debugPrint("[Sparkle Control Init] subscribeMethods SUCCESS for control ID: ${widget.control.id}"); // Log success
    } catch (e, s) {
      debugPrint("[Sparkle Control Init] subscribeMethods FAILED: $e"); // Log failure
      debugPrint("[Sparkle Control Init] Stack Trace: $s");
    }
    debugPrint("[Sparkle Control Init] initState END"); // Log end
  }

  @override
  void dispose() {
    debugPrint("[Sparkle Control Dispose] dispose START for control ID: ${widget.control.id}"); // Log start
    // Unsubscribe when the control is removed
    widget.backend.unsubscribeMethods(widget.control.id);
    debugPrint("[Sparkle Control Dispose] unsubscribeMethods called"); // Log called
    super.dispose();
    debugPrint("[Sparkle Control Dispose] dispose END"); // Log end
  }

  // Handles method calls received from Python via invoke_method
  Future<String?> _handleMethodCall(String methodName, Map<String, String> args) async {
     debugPrint("[Sparkle Control] _handleMethodCall RECEIVED method: $methodName with args: $args");
    if (methodName == "check_for_updates") {
      // Don't await here if Python doesn't need to wait
       _performCheckForUpdates();
    } else {
      debugPrint("[Sparkle Control] Received unknown method: $methodName");
    }
    // Return null to match the expected Future<String?> signature.
    return null;
  }


  // Performs the actual update check logic
  Future<void> _performCheckForUpdates() async {
    // Read feedUrl attribute Freshly when check is requested
    var feedURL = widget.control.attrString("feedUrl");
    debugPrint("[Sparkle Control] _performCheckForUpdates started. Feed URL: $feedURL");

    if (feedURL == null || feedURL.isEmpty) {
       debugPrint("[Sparkle Control] ERROR: Feed URL is not set when check_for_updates called.");
       // Optionally report error back to Python
       // widget.backend.triggerControlEvent(widget.control.id, "error", "Feed URL not set");
       return; // Stop if no URL
    }

    try {
        // Set Feed URL before checking 
        debugPrint("[Sparkle Control] Calling setFeedURL: $feedURL");
        await autoUpdater.setFeedURL(feedURL);
        _currentFeedURL = feedURL; // Update stored URL
        debugPrint("[Sparkle Control] setFeedURL SUCCESS");


        debugPrint("[Sparkle Control] Calling checkForUpdates...");
        await autoUpdater.checkForUpdates();
        // IMPORTANT: This log only means the *call* finished, not that UI appeared or check succeeded.
        debugPrint("[Sparkle Control] checkForUpdates call FINISHED");

    } catch (e, s) { // Catch both error (e) and stack trace (s)
       debugPrint("[Sparkle Control] ERROR during auto_updater calls: $e");
       debugPrint("[Sparkle Control] Stack Trace: $s"); // Print the stack trace

    }
  }

  @override
  Widget build(BuildContext context) {
     debugPrint("[Sparkle Control Build] build method called for ID: ${widget.control.id}");
     // Build method no longer needs triggerCheck logic or to call _performCheckForUpdates.

     // Set initial URL only if _currentFeedURL hasn't been set yet.
     var initialFeedURL = widget.control.attrString("feedUrl");
     if (initialFeedURL != null && _currentFeedURL == null) {
         // Using Future.microtask to avoid calling async directly in build
         Future.microtask(() async {
              try {
                  debugPrint("[Sparkle Control Build] Setting initial Feed URL in build: $initialFeedURL");
                  await autoUpdater.setFeedURL(initialFeedURL);
                  _currentFeedURL = initialFeedURL;
                  debugPrint("[Sparkle Control Build] Initial setFeedURL SUCCESS");
              } catch (e, s) {
                 debugPrint("[Sparkle Control Build] ERROR setting initial Feed URL: $e");
                 debugPrint("[Sparkle Control Build] Stack Trace: $s");
              }
          });
     }

     return const SizedBox.shrink(); // Non-visual control
  }
}