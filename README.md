# Arduino Installation Script

## Description

This tool prepares the environment to compile Arduino `.ino` files and upload them to an Arduino board using the command line. It automates the installation of necessary packages, sets up directories and configuration files, and provides a sample script to get started.

## Installation

1. Give execution permissions to the script:
    ```sh
    chmod +x install_arduino.sh
    ```

2. Execute the script as root:
    ```sh
    sudo ./install_arduino.sh
    ```
    or
    ```sh
    sudo bash install_arduino.sh
    ```

## Information

This tool will:
1. Install the following packages:
   - **arduino-mk**: To compile the `.ino` files.
   - **screen**: To see the output console.

2. Create the following directories:
   - `arduino`
   - `sketchbooks`
   - `libraries`

3. Generate the following files:
   - `Makefile`: A configuration file for Arduino projects.
   - `first_script.ino`: A sample Arduino script to blink an LED and print "Hello world" to the serial monitor.

4. Ensure the `avrdude.conf` file is correctly placed for Arduino operations.

## Usage

After running the script, you can use the following commands to work with your Arduino projects:

- Compile the project:
    ```sh
    make
    ```

- Upload the compiled code to the Arduino board:
    ```sh
    make upload
    ```

- Clean up build files:
    ```sh
    make clean
    ```

- Combine commands:
    ```sh
    make upload clean
    ```

- Open the serial monitor:
    ```sh
    make monitor
    ```

- Exit the serial monitor:
    - Press: `ctrl-a` + `ctrl-d`

- Stop the monitor port:
    ```sh
    screen -X quit
    ```

