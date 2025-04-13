# Introduction

SparkleAutoUpdater for Flet.

## Examples

```python
import flet as ft

# Import control.
from sparkle_auto_updater import SparkleAutoUpdater

def main(page: ft.Page):
    page.title = "Sparkle AutoUpdater Example"
    page.vertical_alignment = ft.MainAxisAlignment.CENTER
    page.horizontal_alignment = ft.CrossAxisAlignment.CENTER

    # ==============================================================
    # IMPORTANT: Replace with your actual Sparkle Appcast feed URL!
    # This MUST be a valid URL pointing to your update XML feed.
    # ==============================================================
    feed_url = "REPLACE_WITH_YOUR_SPARKLE_APPCAST_XML_URL"

    if not feed_url or feed_url == "REPLACE_WITH_YOUR_SPARKLE_APPCAST_XML_URL":
         page.add(ft.Text("Error: Update Feed URL not configured in examples/sparkle_auto_updater_example/src/main.py", color=ft.colors.RED))
         page.update()
         return

    # Instantiate the control, pass in the feel_url.
    updater = SparkleAutoUpdater(feed_url=feed_url)

    # Add the non-visual control to the page overlay
    page.overlay.append(updater)

    def trigger_check(e):
        print("Check for Updates button clicked!")

        # Define the SnackBar first
        sb = ft.SnackBar(
            content=ft.Text("Checking for updates..."),
            open=False # Start closed
            )
        # Add it to the overlay BEFORE trying to open it
        page.overlay.append(sb)
        page.update() # Update the page to include the SnackBar in the overlay

        # Call the update check method AFTER setting up the SnackBar
        updater.check_for_updates()

        # Now open the SnackBar
        sb.open = True
        page.update() # Update the page to show the SnackBar


    # Add a button to the main page content
    page.add(
        ft.ElevatedButton("Check for Updates", on_click=trigger_check)
    )
    
    # We use this text to show the version number, which is helpful when testing Sparkle.
    page.add(ft.Text("Version1"))

    page.update() # Update the page to show the button initially

# This runs when you execute `flet run src/main.py` from this example directory
ft.app(target=main)
```

## Classes

[SparkleAutoUpdater](SparkleAutoUpdater.md)


