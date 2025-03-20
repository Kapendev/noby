# Noby

The next next generation of the NoBuild/Nob idea.

## NoBuild/Nob Idea

The idea is that you should not need anything but a D compiler to build a D project.
No DUB, no Make, no Shell etc. Only D compiler.
So with the D compiler you bootstrap your build system and then you use the build system to build everything else.

## Getting Started

1. Copy the [noby.d](source/noby.d) file into your project.
2. Replace the content of the main function with your own code.

Then, run the script with the appropriate command:

* Windows:

    ```cmd
    dmd -run noby.d
    ```

* Linux:

    ```cmd
    ./noby.d
    ```

## Using Noby With Dub

To create a local noby.d file, run:

```cmd
dub run noby:init
```
