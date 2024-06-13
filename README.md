# scripts

## Repository: [github.com/sebastianaf/scripts](https://github.com/sebastianaf/scripts)

This repository contains various scripts that can be installed to a hidden folder in the user's directory and added to the system `PATH` for easy access from any terminal.

## Features

- Copies scripts from the `scripts` folder in the repository to a hidden `.scripts` folder in the user's home directory.
- Adds the `.scripts` folder to the user's `PATH` if it's not already present.
- Generates a copy report directly in the terminal with color-coded sections.
- Creates a `.bat` file for each PowerShell script, allowing them to be run from the command line as if they were native commands.
- Optionally terminates open PowerShell, CMD, and Windows Terminal instances to apply the new `PATH` and verifies if they were successfully closed.

## Requirements

- Windows operating system
- PowerShell 5.1 or later

## Installation

### Step-by-Step Instructions

1. **Clone the Repository**

    Clone this repository to your local machine using Git:

    ```sh
    git clone https://github.com/sebastianaf/scripts.git
    cd scripts
    ```

2. **Run the Installation Script**

    Open PowerShell and navigate to the directory where you cloned the repository. Then run the installation script:

    ```powershell
    cd "path\to\your\repository"
    .\install.ps1
    ```

    This script will:
    
    - Create a hidden `.scripts` folder in your home directory if it doesn't already exist.
    - Copy all scripts from the `scripts` folder in the repository to the `.scripts` folder.
    - Add the `.scripts` folder to your `PATH` if it's not already present.
    - Create a `.bat` file for each PowerShell script to allow running them directly from the command line.
    - Display a copy report directly in the terminal with color-coded sections.
    - Optionally terminate open PowerShell, CMD, and Windows Terminal instances to apply the new `PATH` and verify if they were successfully closed.

## Script Details

The primary script included in this repository provides the following functionalities:

- **Set-Wallpaper**: Sets the desktop wallpaper to the specified image path.
- **CreateSolidColorImage**: Creates a solid color image with the specified hex color code.
- **Set-VSCodeTheme**: Sets the Visual Studio Code theme to the specified theme name.
- Toggles between light and dark themes for Windows and Visual Studio Code.
- Restarts Windows Explorer to apply theme changes immediately.

### Command to Execute the Script

After running the installation script, you can toggle between light and dark themes by running the `themesw` command from any terminal. For example:

```powershell
themesw
```

### Troubleshooting
Permission Issues: Make sure you have the necessary permissions to modify the PATH.
Scripts Not Found: Ensure that the .scripts folder has been added to your PATH by opening a new terminal and typing echo $env:PATH. You should see the path to the .scripts folder listed.
License
This project is licensed under the MIT License - see the LICENSE file for details.

### Acknowledgments
Inspired by the need to streamline script management and execution in a Windows environment.