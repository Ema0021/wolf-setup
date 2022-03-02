# WoLF: Whole-body Locomotion Framework for quadruped robots

<p align="center">
  <img src="docs/wolf-logo.jpeg" width="250" height="185" />
</p>

This repo contains the setup for the whole-body controller presented in the following [paper](https://hal.archives-ouvertes.fr/hal-03005133/document): 

```
@article{raiola2020simple,
  title={A simple yet effective whole-body locomotion framework for quadruped robots},
  author={Raiola, Gennaro and Mingo Hoffman, Enrico and Focchi, Michele and Tsagarakis, Nikos and Semini, Claudio},
  journal={Frontiers in Robotics and AI},
  volume={7},
  pages={159},
  year={2020},
  publisher={Frontiers}
}
```

## Features

WoLF provides several features for your quadruped robotic friend:


<center>

|  Push recovery |  Step reflex | Navigation ready  | Loco-manipulation  | Multi robot  |
|:-:|:-:|:-:|:-:|:-:|
|  <img src="docs/push_recovery.gif" width="200" height="120" /> |   <img src="docs/step_reflex.gif" width="200" height="120" />  | <img src="docs/spot_navigation.gif" width="200" height="120" />  | <img src="docs/spot_arm.gif" width="200" height="120" />  | <img src="docs/robots.png" width="160" height="120" />  |

</center>

## Packages

- wolf-setup
- wolf_descriptions
- wolf_hardware_interface
- wolf_gazebo_interface
- wolf_gazebo_resources
- wolf_navigation
- wolf_controller

## How to run the controller

You can run the controller by installing it on your computer or by running it in a docker container. First be sure to clone the repo:

`git clone https://github.com/graiola/wolf-setup.git`

### Docker container for Ubuntu 16.04 - 18.04 - 20.04

To download the image from [docker-hub](https://hub.docker.com/repository/docker/serger87/wolf) and launch the controller within a docker container, run the following script:

`./run_docker.sh`

Use the help argument to see what are the available options:

`./run_docker.sh --help`

If you need to install docker on your computer, you can run the following:

`./support/install_docker.sh`

#### Notes:

- It could be necessary to restart the computer after  installing docker with `install_docker.sh`.
- Use the `install_nvidia.sh` script in the `support` folder  if you are experiencing the following problem: `could not select device driver "" with capabilities: [[gpu]]`. 
- If you are experiencing this problem `nvidia-container-cli initialization error nvml error driver not loaded`, it probably means that your computer does not have the latest nvidia-drivers installed. Be sure that they are installed and updated.

### System installation for Ubuntu 18.04 - 20.04

To install the required dependencies (including ROS) and the WoLF debian packages run the following:

`./install.sh`

After the installation, update your bash enviroment:

`source ~/.bashrc`

#### How to start the controller

WoLF provides three interfaces to move the robot:

- A [PS3](docs/ps3.png) joypad interface: `roslaunch wolf_controller wolf_controller_bringup.launch input_device:=ps3`
- A [XBox](docs/xbox.jpeg) joypad interface: `roslaunch wolf_controller wolf_controller_bringup.launch input_device:=xbox`
- A [keyboard](docs/keyboard.png) interface: `roslaunch wolf_controller wolf_controller_bringup.launch input_device:=keyboard`

A twist topic is always active and listening for velocity commands on `/robot_name/wolf_controller/twist`. This topic can be used to send twist commands at a lower priority than the above mentioned interfaces.
It can be used to send `move_base` commands if you want  to use the ROS navigation stack, see [wolf_navigation](https://github.com/graiola/wolf_navigation) for an example.
To make the robot stand up, press the `start` button on the joypad or press the `enter` key if you are using the keyboard.

## How to add a new robot

If you want to test a different quadruped robot check out [wolf_descriptions](https://github.com/graiola/wolf_descriptions).

## Legal notes

- `wolf-setup` is distributed and licensed under a license GNU General Public License v3.0.
- `wolf-controller` is licensed under a [license]("http://creativecommons.org/licenses/by-nc-nd/4.0/") Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License</a>.
![2](https://i.creativecommons.org/l/by-nc-nd/4.0/88x31.png)
- For the other packages please check the respective `LICENSE` document.
