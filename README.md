# flet-sparkle-auto-updater

Sparkle integration for Flet applications, enabling automatic updates on macOS using the [leanflutter/auto_updater](https://github.com/leanflutter/auto_updater) native plugin which utilizes the [Sparkle Project](https://github.com/sparkle-project/Sparkle/).

This package provides a non-visual Flet control (SparkleAutoUpdater) that you add to your application's overlay to handle update checks against a standard Sparkle Appcast feed.

## Installation

Add the dependency to the pyproject.toml file of your Flet app:

**1. Stable Release (Recommended) - current: v1.0.0**

To install a specific stable version (e.g., v1.0.0), use the tag in the URL:

* In `pyproject.toml`:
    ```toml
    dependencies = [
      "flet-sparkle-auto-updater @ git+[https://github.com/ap4499/sparkle_auto_updater.git@v1.0.0](https://github.com/ap4499/sparkle_auto_updater.git@v1.0.0)",
      # ...
    ]
    ```
* Or with pip:
    ```bash
    pip install "flet-sparkle-auto-updater @ git+[https://github.com/ap4499/sparkle_auto_updater.git@v1.0.0](https://github.com/ap4499/sparkle_auto_updater.git@v1.0.0)"
    ```
    *(Replace `v1.0.0` with the desired release tag)*

**2. Latest Development Version (Potentially Unstable)**

To install the very latest code from the `main` branch:

* In `pyproject.toml`:
    ```toml
    dependencies = [
      "flet-sparkle-auto-updater @ git+[https://github.com/ap4499/sparkle_auto_updater.git](https://github.com/ap4499/sparkle_auto_updater.git)",
      # ...
    ]
    ```
* Or with pip:
    ```bash
    pip install "flet-sparkle-auto-updater @ git+[https://github.com/ap4499/sparkle_auto_updater.git](https://github.com/ap4499/sparkle_auto_updater.git)"
    ```



## Basic Usage

1.  **Import the control:**
```python
from sparkle_auto_updater import SparkleAutoUpdater
```

2.  **Instantiate and add to overlay:**
Make sure to replace "YOUR_APPCAST_FEED_URL_HERE" with your actual Sparkle feed URL (must be HTTPS).
```python
# Inside your main Flet function (e.g., main(page: ft.Page))
updater = SparkleAutoUpdater(feed_url="YOUR_APPCAST_FEED_URL_HERE")
page.overlay.append(updater)
page.update()
```

3.  **Check for updates when needed:**
```python
# Call this method when you want to trigger a check (e.g., on a button click)
updater.check_for_updates()
```

4.  **Setting/Getting the Feed URL:**
You can set or get the feed URL property directly:
```python
updater.feed_url = "YOUR_NEW_APPCAST_FEED_URL_HERE"
current_url = updater.feed_url
```

5.  **Entries for pyproject.toml:**
```toml
# These are the entries required to setup Sparkle.
# See: https://sparkle-project.org/documentation/

[tool.flet.macos.info]
# Add Sparkle keys using native TOML types
SUFeedURL = "https://USER.github.io/APP/appcast.xml" # TOML String. Example assumes using Github for hosting.
SUEnableAutomaticChecks = true                            # TOML Boolean
SUScheduledCheckInterval = 86400                          # TOML Integer
SUPublicEDKey = "1234567890qwertyuiop" # TOML String. (EXAMPLE Key) Use Sparkle’s generate_keys tool to get it.


[tool.flet]
# org name in reverse domain name notation, e.g. "com.mycompany".
# Combined with project.name to build bundle ID for iOS and Android apps
org = "com.mycompany"
build_number = 2 # This is "Bundle version". It is used by Sparkle as the comparator to determine updates.
# It is recommended to use an Integer. Advanced users can see Sparkle documentation to see how semantic versioning works.
```

6.  **Sparkle notes:**
- When SUEnableAutomaticChecks is set to True, Sparkle will automatically try to update the application (when it is run). The user can override this within the pop-up.

7.  **Dev commands:**
Sparkle automatically creates defaults. During development you may wish to reset these, to check behaviour.

Read variables example (MacOS terminal):
```defaults read com.mycompany.sparkle-auto-updater-example```

example response:
```
{
    SUAutomaticallyUpdate = 1;
    SUEnableAutomaticChecks = 1;
    SUHasLaunchedBefore = 1;
    SULastCheckTime = "2025-04-07 12:30:13 +0000";
    SUSendProfileInfo = 0;
    SUSkippedVersion = 3;
    SUUpdateGroupIdentifier = 351040012;
}
```


Delete all defaults:
```defaults delete com.mycompany.sparkle-auto-updater-example```

8.  **Generating keys:**

See the following heading within (https://sparkle-project.org/documentation/):
EdDSA (ed25519) signatures

It details how to create your key pairs and how they are used. You will of course need the public key to place inside of your pyproject.toml (which is destined for the .plist file).

To generate keys, you should access the file: Sparkle-2.7.0.tar.xz. Within the bin folder, you will find the scripts that you need to generate the keys. I did also have to rename the keychain entry to "Sparkle EdDSA Private Key".




## License Information and Dependencies

This project (flet-sparkle-auto-updater) is licensed under the **BSD 2-Clause License** ("Simplified BSD"). The full license text can be found in the LICENSE file in this repository.

**Key Terms (BSD 2-Clause):**

* You are free to use, modify, and redistribute the code (in source or binary forms).
* You **must** retain the original copyright notice (Copyright (c) 2025, Alex Proctor) and the license text in redistributions.
* The software is provided "AS IS", without warranty.

### Included Dependencies

This project utilizes or is derived from code from the following upstream projects:

* **Sparkle Project:** [https://github.com/sparkle-project/Sparkle/](https://github.com/sparkle-project/Sparkle/)
* **leanflutter/auto_updater:** [https://github.com/leanflutter/auto_updater](https://github.com/leanflutter/auto_updater)

In accordance with their licensing terms, the required copyright notices and license texts for these dependencies are included in this distribution. Please see the following files in this repository:

* LICENSE (sparkle-project:Sparkle).txt
* LICENSE (leanflutter:auto_updater).txt
