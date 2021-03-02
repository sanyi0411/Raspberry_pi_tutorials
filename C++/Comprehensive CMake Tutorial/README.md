# Comprehensive CMake Tutorial

## What is CMake

## Prerequisities
//TODO: have gcc or clang installed

## How to install

### Linux

For this tutorial I am using Ubuntu 20.04 LTS

There are 2 ways to install CMake on Ubuntu but the easier and faster way may not get you the latest release of CMake, so I advise you to choose the second option below

1. Install from command line
    - Open a command line and run `apt search cmake\$` to see the available version
    - At the time of writing the latest release you can get this way is 3.16.3
    - Run `sudo apt-get install cmake` to download and install CMake
    - Verify the installation by running `cmake --version`

![latest CMake version from command line](images/1.jpg)

2. Install from shell script
    - Open a browser and go to `cmake.org/download/`
    - Find the Linux version and download the belonging shell script (file name ends with **.sh**)
    - At the time of writing the latest version on the website is 3.20.0
        - Now you can see why it is better to download CMake from the website
    - Run the shell script by `sudo sh cmake.sh --prefix=/usr/local`
        - You can use the prefix argument to specify the install location
    - Verify the installation by running `cmake --version`

![cmake.org/download](images/2.jpg)


### Windows

## Hello World

1. Create the project
    - Create a new folder for a new project. This is going to be the root folder of your project.
    - It is good practice to keep your source and build files separate so create a **build** and a **src** folder in the root folder
    - In the **src** folder create a **main.cpp** and write a simple Hello World application
    - Create a `CMakeLists.txt` in the root folder and add the following:

    ```
    cmake_minimum_required(VERSION 3.16)
    project(MyProject VERSION 1.0.0)

    add_executable(Hello src/main.cpp)
    ```

    - The first line specifies the minimum version required to build your app with CMake. 
        - If someone tries to build your app with a lower version, it will fail
    - The second line sets the name of the project and stores it in a variable PROJECT_NAME. The VERSION is optional.
    - On the third line the first argument is what the name of the executable will be (e.g Hello.exe on Windows) and the following arguments are the source files used for the build

2. Build using cmake
    - *cmake* is a command line interface (as opposed to ccmake)
    - Go to your build folder and run `cmake ..`
        - By default CMake will generate the Makefile (and other necessary file) at the current working directory
        - As an argument you have to provide the path to source
            - There CMake will look for a CMakeLists.txt, so make sure you put it there
    - You should see outputs like
    
    ```
    -- Configuring done
    -- Generating done
    -- Build file have been written to ...
    ```

    - In the build folder now there is a Makefile
        - If you open it you can see that the environment variables are specific to your machine
        - This is why we need the platform independent CMake: to generate platform dependent Makefiles
    - Now you can run `make`, which will create the Hello executable. Run it by `./Hello`
    - It is possible to use CMake with an other generator than Make, so the `make` command wouldn't work this time
    - The solution for this is to use the `cmake --build .` command
        - This will use whatever generator you set up for your project

3. Build using ccmake
    - *ccmake* is a terminal based gui. It is somewhere between a command line interface and a nice, windowed GUI, like cmake GUI
    - Go to your build folder and run `ccmake ..`
        - It should automatically configure but if not press c to start it
    - At the bottom you can see hints for what hotkeys there are
    - Press t to toggle advenced mode
    - You can see all the variables the CMake uses
    - Find the CMAKE_CXX_COMPILER variable. You can see that it found, for example, gcc or clang as your compiler.
    - At this point you can overwrite these variables. If you did, press c again to reconfigure
    - Press g to generate and exit
    - Now you can run `make`, which will create the Hello executable. Run it by `./Hello`

## Adding libraries
- Next to your **main.cpp** create a new header and cpp file with some functionality
- Include the header in **main.cpp**
- If you try to build now, you will get an error: undefined reference
    - This is because CMake wasn't told to include the new files you just made
- Open your root CMakeLists.txt and this line before the *add_executable* :

```
add_library(myLibrary hello.h hello.cpp)
```

- The first argument is the name of the library, you can choose anything you want
- The following argument are the files you want to include in that library
- Now we have to link this library to the executable. Add this line after *add_executable* :

```
target_link_libraries(Hello PRIVATE myLibrary)
```

- The first argument is the target, in this case the executable
- The second is the link interface mode. Leave it PRIVATE for now
- The third is the source library, you want to link
- Now it is sufficient to run `make`. It recognizes that you made changes and will call CMake to reconfigure
