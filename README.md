# sparkle-auto-updater

Sparkle integration for Flet applications, enabling automatic updates on macOS using the [leanflutter/auto_updater](https://github.com/leanflutter/auto_updater) native plugin which utilizes the [Sparkle Project](https://github.com/sparkle-project/Sparkle/).

This package provides a non-visual Flet control (SparkleAutoUpdater) that you add to your application's overlay to handle update checks against a standard Sparkle Appcast feed.

## Installation

You can install `sparkle-auto-updater` directly from GitHub using `pip`. Choose between the latest stable release or the current development version.

**1. Stable Release (Recommended) - current: v1.0.0**

Install the latest stable version using its specific Git tag.

* **In `pyproject.toml`:**
    Add the dependency to your `dependencies` list:
    ```toml
    [project]
    dependencies = [
        "sparkle-auto-updater @ git+https://github.com/ap4499/sparkle_auto_updater.git@v1.0.0",
    ]
    ```

* **Or with `pip`:**
    Install directly from the command line:
    ```bash
    pip install "git+https://github.com/ap4499/sparkle_auto_updater.git@v1.0.0"
    ```
    *(Replace `v1.0.0` with the desired release tag if installing a different specific version)*

**2. Latest Development Version (Potentially Unstable)**

Install the very latest code directly from the `main` branch. Note that this version may contain bugs or incomplete features and is not recommended for production use.

* **In `pyproject.toml`:**
    Specify the `main` branch instead of a tag:
    ```toml
    [project]
    dependencies = [
        "sparkle-auto-updater @ git+https://github.com/ap4499/sparkle_auto_updater.git@main",
    ]
    ```

* **Or with `pip`:**
    Use `@main` to target the development branch:
    ```bash
    pip install "git+https://github.com/ap4499/sparkle_auto_updater.git@main"
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

## Sparkle native steps
_These steps are Sparkle native._

You should obtain a copy of Sparkle from https://github.com/sparkle-project/Sparkle/releases/tag/2.7.0 (this file: Sparkle-2.7.0.tar.xz.)

The official documentation can be found here: https://sparkle-project.org/documentation/


8.  **Generating keys:**
    Reference in official documentation: "3. Segue for security concerns - EdDSA (ed25519) signatures"
    
    - It details how to create your key pairs and how they are used. You will of course need the public key to place inside of your pyproject.toml (which is destined for the .plist file).
    
    - Within the bin folder of the Sparkle application referenced above, you will find the scripts that you need to generate the keys. Note that you may need to rename your keychain entry to "Sparkle EdDSA Private Key". You will likely be able to search your keychain for "Sparkle" to identify the original entry.


9.  **Generating an appcast:**
    Reference in official documentation: "5. Publish your appcast"
    
    - You will need to generate an appcast, and place it onto a server that is HTTPS. This is what Sparkle will use as the comparator, to determine whether an update should be made. 
    
    - From the bin folder, running the "generate_appcast" will generate both the appcast file that you will need, and also the public facing output that is the combination of your application's hash, and your private key (note - the private key must _never_ be shared).




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
