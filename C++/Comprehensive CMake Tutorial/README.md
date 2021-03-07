# Comprehensive CMake Tutorial

## What is CMake

<hr>

## Prerequisities
//TODO: have gcc or clang installed

<hr>

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
    - Open a browser and go to `https://cmake.org/download/`
    - Find the Linux version and download the belonging shell script (file name ends with **.sh**, see picture below)
    - At the time of writing the latest version on the website is 3.20.0
        - Now you can see why it is better to download CMake from the website
    - Run the shell script by `sudo sh cmake.sh --prefix=/usr/local`
        - You can use the *prefix* argument to specify the install location
    - Verify the installation by running `cmake --version`

![cmake.org/download](images/2.jpg)


### Windows

//TODO

<hr>

## Hello World

1. Create the project
    - Create a new folder for a new project. This is going to be the root folder of your project.
    - Create a `CMakeLists.txt` file and a `main.cpp`
    - Write a basic HelloWorld program in the `main.cpp`
    - CMake will create many additional files along with the Makefile and it is not a good practice to clutter up the root folder so create a separate `build` folder for these
    - Your folder structure should look like this at this point:
    ```
    CMake_example
        |- build/
        |- CMakeLists.txt
        `- main.cpp
    ```
    - In the `CMakeLists.txt`add the following:

    ```
    cmake_minimum_required(VERSION 3.16)

    project(HelloWorld_project  VERSION 1.0.0
                                DESCRIPTION "My first project using CMake"
                                LANGUAGES CXX)

    add_executable(HelloWorld main.cpp)
    #This is a comment line
    ```

    - The first line specifies the minimum version of CMake required to build your app with CMake. 
    - The *project()* function sets the name of the project (first argument) and stores it in a variable called PROJECT_NAME. The VERSION, DESCRIPTION and LANGUAGES words are keywords and are optional to use.
    - The *add_executable()* function creates and executable file. The first argument will be the name of the executable (e.g. HelloWord.exe) and following arguments are the paths to files used in creating that executable.
    - Any line starting the the *#* sign is a comment

2. Build using cmake
    - *cmake* is a command line interface (as opposed to ccmake)
    - Go to your build folder and run `cmake ..`
        - By default CMake will generate the Makefile (and other necessary files) at the current working directory
        - As an argument you have to provide the path to root. There CMake will look for a CMakeLists.txt, so make sure you put it there
    - You should see outputs like
    
    ```
    -- Configuring done
    -- Generating done
    -- Build file have been written to ...
    ```

    - In the build folder now there is a Makefile
        - If you open it you can see that the environment variables are specific to your machine
        - This is why we need the platform independent CMake: to generate platform dependent Makefiles
    - Now you can run `make` from the build folder, which will create the HelloWorld executable. Run it by `./HelloWorld`
    - It is possible to use CMake with a different generator than Make, so the `make` command wouldn't work this case
    - The solution for this is to use the `cmake --build .` command
        - This will use whatever generator you set up for your project

3. Build using ccmake
    - *ccmake* is a terminal based gui. It is somewhere between a command line interface and a nice, windowed GUI, like cmake GUI
    - Go to your build folder and run `ccmake ..`
        - It should automatically configure but if not press c to start it
    - At the bottom you can see hints for available hotkeys
    - Press t to toggle advenced mode
    - You can see all the variables that CMake uses
    - Find the CMAKE_CXX_COMPILER variable. You can see that it found, for example, gcc or clang as your compiler.
    - At this point you can overwrite these variables. For example change gcc to clang. If you did, press c again to reconfigure
    - Press g to generate and exit. This will generate the Makefile
    - Now you can run `make`, which will create the HelloWorld executable. Run it by `./HelloWorld`

<hr>

## Better folder structure

- Usually we don't just throw every source file in the root folder so let's create a nice folder structure
- There is a debate whether to 
    1. put the *\*.h* files in the `include` folder and the *\*.cpp* files in the `src` folder or
    2. leave them next to each other in the `src` folder and don't use `include` folder
- Here I will go with the second one
- Also add a new class in it's own *\*.h* and *\*.cpp* files, give it some functionality and include it in the *main.cpp*

```
CMake_example
    |-build/
    |-src/
        |- Animal.h
        |- Animal.cpp
        |- CMakeLists.txt
        `- main.cpp
    `-CMakeLists.txt
```

- Each folder you are using should have it's CMakeLists.tx file

The root CMakeLists.txt:
```
cmake_minimum_required(VERSION 3.16)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(PROJECT_NAME CMake_tutorial)
#set(EXAMPLE_VARIABLE 12345) 

project(${PROJECT_NAME} VERSION 1.0.0)

add_subdirectory(src)
```

- With the *set()* function we can give values to variables
- The first argument is the name of the variable, the second is its value.
- Any variable starting with `CMAKE_` or `_CMAKE_` is a CMake variable
- The `CMAKE_CXX_STANDARD` variable sets the wanted C++ version. In this case we are using C++17
- You can create your own variables. See the *EXAMPLE_VARIABLE*
- We use a *PROJECT_NAME* variable because we will use it in several other files throughout the project
- You can use any variable by putting it in {} and prefix with *$*. See the *project()* function.
- As all of our source files are in the `src` directory we have to use the *add_subdirectory()* function
- CMake will go into that directory and parse the CMakeLists.txt there and continue with it's commands

The src/CMakeLists.txt:
```
add_library(Animals Animal.h Animal.cpp)

add_executable(${PROJECT_NAME} main.cpp)

target_link_libraries(${PROJECT_NAME} PRIVATE Animals)
```

- From the new class we just created we make a separate lib file with the *add_library()* function. The first argument will be the name of the lib file. Note that CMake automatically appends `lib` at the beginning of the filename. So in this case the lib file will be named `libAnimals`. The following arguments are the files used to create this lib file. Including header files are not necessary but helps the IDE
- Just like before, we create an executable from the *main.cpp*
- Now this *main.cpp* uses functions from the lib file so we have to link these two together with the *target_link_libraries()* function. For the difference between the PRIVATE and the PUBLIC keyword check out the official description [here](https://cmake.org/pipermail/cmake/2016-May/063400.html)
- After runnig the `make` command from the build folder, a `src` folder will be created and within that the `libAnimals.a` file (on Linux) and the `CMake_tutorial` executable

<hr>

## More structuring

- Let's assume we have different modules in our source code
- For that we would create separate subdirectories under `src`
- Add another class to the source code and put the classes in their respective folders:

```
CMake_example
    |-build/
    |-src/
        |- Animals
            |- Animal.h
            |- Animal.cpp
            `- CMakeLists.txt
        |- Vehicles
            |- CMakeLists.txt
            |- Vehicle.h
            `- Vehicle.cpp
        |- CMakeLists.txt
        `- main.cpp
    `-CMakeLists.txt
```

- As before, every folder needs its own CMakeLists.txt
- The root CMakeLists.txt doesn't change this time

The src/CMakeLists.txt:
```
include_directories(Animals)
include_directories(Vehicles)

add_subdirectory(Animals)
add_subdirectory(Vehicles)

add_executable(${PROJECT_NAME} main.cpp)

target_link_libraries(${PROJECT_NAME} PRIVATE Animals)
target_link_libraries(${PROJECT_NAME} PRIVATE Vehicles)
```

- The *include_directory()* function make every file within that folder accessible in the source tree. This way in the *main.cpp* file we can use `#include "Animal.h"` and not `#include "Animals/Animal.h"`
- All the other commands should be familiar from before

The src/Animals/CMakeFile.txt:
```
add_library(Animals Animal.cpp Animal.h)
```

The src/Vehicles/CMakeLists.txt
```
add_library(Vehicles Vehicle.h Vehicle.cpp)
```

- At this point it is enough to run the `make` command from the build folder, no need for `cmake ..` before. It is because make is clever enough to see that some files have changed and calls CMake first automatically. If you run only `make`, at the beginning of the outputs you will see the same messages as with cmake.

<hr>

## Testing with google test

- Create a `lib` folder in the project root
- Clone or download az ZIP the googletest repo from `https://github.com/google/googletest`
- Copy the googletest folder into the `lib` folder
- Create a `test` folder in the project root. We will put the test files here

```
CMake_example
    |-build/
    |-lib
        `- googletest
    |-src/
        |- Animals
            |- Animal.h
            |- Animal.cpp
            `- CMakeLists.txt
        |- Vehicles
            |- CMakeLists.txt
            |- Vehicle.h
            `- Vehicle.cpp
        |- CMakeLists.txt
        `- main.cpp
    `-CMakeLists.txt
```
