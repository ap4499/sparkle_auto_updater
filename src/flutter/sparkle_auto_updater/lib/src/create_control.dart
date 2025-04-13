import 'package:flet/flet.dart';
import 'package:flutter/material.dart'; 

import 'sparkle_auto_updater.dart';

CreateControlFactory createControl = (CreateControlArgs args) {
  switch (args.control.type) {
    case "sparkle_auto_updater":
      return SparkleAutoUpdaterControl(
        parent: args.parent,
        control: args.control,
        children: args.children,
        parentDisabled: args.parentDisabled,
        backend: args.backend, 
      );
    default:
      return null;
  }
};

void ensureInitialized() {
}