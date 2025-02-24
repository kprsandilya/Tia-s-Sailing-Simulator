# BoilerMakeXII Project - Tias's Sailing Simulation

https://www.youtube.com/watch?v=4KYQdsFEecg&t=48s

## Group Members

Sandi Kambhampati, Shivam Patel, Sharan Suthaharan, Manith Kamalakanth

## Project Overview

We designed a sailing game in Godot using GDScript, then incorporated the Llama 3.1 8B quantized model for generative prompts from the game to the user hosted through a state-of-the-art Cloud AI Computing infrastructure, Modal. This generated prompt would then be piped to Cartesia's Sonic API which took the generated text, converting it to an MP3 file through the provided Text-to-Speech service. This service provides an educational aspect to the game which otherwise focuses on the survival aspect of seafaring.

## How to Play

- The objective of the game is to keep your hunger bar up for as long as possible, if not, then the game is over
- Rippling areas of water mean there's an opportunity to catch a fish
- Three kinds of fish - regular, clownfish, and shark
- You are able to eat these fish to keep your hunger bar up, each fish replenishes more health than the last
- Tia is able to give you fun facts about the vast open sea and its diverse marine life!

## Setup and Installation

- Create a conda environment inside of the python-backend folder that contains each of the packages listed in the environment.yml file
- Create a .env file inside of the godot-game folder that stores three key values as listed in the .env.example file
- Launch the modal server with modal deploy modal-server within the python-backend folder
- Launch Godot at 4.3 for a stable experience within the godot-game folder
- Monitor the state through the Modal app interface
- Enjoy the game

## Credits

Assets from:
- https://ninjikin.itch.io/water
- https://koreanois.itch.io/boat-and-ship-sprites
- https://josie-makes-stuff.itch.io/pixel-art-farming-assets


