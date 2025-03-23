# Arduino Installation Script

## Installation

1. Give execution permissions to the script:
    ```sh
    chmod +x start-config
    ```

2. Execute the script:
    ```sh
    sudo ./start-config
    ```
    or
    ```sh
    sudo bash start-config
    ```

## Information

This tool will install the following packages:
1. **arduino-mk**: To compile the `.ino` files.
2. **screen**: To see the output console.

Additionally, it will create the following directories:
- `arduino`
- `sketchbooks`
- `libraries`

And the following files:
- `Makefile`

