## Westen House (MSX) by Santiago Ontañón Villar

Download latest compiled ROMs (v1.3.1) from (Ensligh, Spanish and Brazilian Portuguese versions available): https://github.com/santiontanon/westen/releases/tag/v1.3.1


You will need an MSX emulator to play the game on a PC, for example OpenMSX: http://openmsx.org

A game video can be seen here: https://youtu.be/weFJe88oebA

Or you can play directly on your browser thanks to Arnaud De Klerk (TFH)!: https://homebrew.file-hunter.com/index.php?id=westernhouse

## Introduction

Westen House is an MSX1 game, in a 48KB ROM cartridge format. I originally started it to participate in the MSXDev'21 competition ( https://www.msxdev.org ), but I did not make it in time. You can play in either 50Hz or 60Hz machines, but the game is a bit more enjoyable in 60Hz machines, as the player walks a bit faster.

Westen House is an isometric adventure that has the goal of exploring the possibility of creating an isometric game for MSX1 that exploits hardware sprites to increase the colorfulness of the game. I grew up playing classics like Batman and Head over Heels, which were my favorite isometric games, and I have been wanting to make an isometric game for a very long time. I hope you  enjoy the game and the story!


## Screenshots

Screenshots (of version 1.2):

<img src="https://raw.githubusercontent.com/santiontanon/westen/main/media/screen1.png" alt="title" width="400"/> <img src="https://raw.githubusercontent.com/santiontanon/westen/main/media/screen2.png" alt="in game 1" width="400"/> 

<img src="https://raw.githubusercontent.com/santiontanon/westen/main/media/screen3.png" alt="in game 2" width="400"/> <img src="https://raw.githubusercontent.com/santiontanon/westen/main/media/screen4.png" alt="in game 2" width="400"/>


### Game Goal

You play as Professor Edward Kelvin, who has been asked to collect the research notes of his deceased colleague Jonathan Westen before Jonathan's family comes to take possession of the house. What Edward cannot imagine is that this seemingly inocent task might turn into one of his biggest adventures!


## Acknowledgments

- Thanks to Jordi Sureda who betatested early versions of the game and caught many, many bugs!
- Thanks to Rafael Jannone for the Brazilian Portuguese translation!
- And thanks to the many, many people that have reported bugs, issues, and given suggestions since the first release!!! Sorry for not listing all the names, sicne I'm sure I would forget someone, but thank you very, very much!


## Compatibility

The game was designed to be played on MSX1 computers with at least 16KB of RAM. I used OpenMSX v0.16 to make sure the game is compatible with lots of MSX models, but if you detect an incompatibility, please let me know!


## Notes:

Some notes and useful links I used when coding Westen House

* There is a "build" script in the home folder. Use it to re-build the game from sources. There is a collection of data files that are generated via a collection of Java scripts. Those are found in the "java" folder. You can re-generate all the data files by running the "Main.java" class (some of them take quite some time to run, so be patient! Also, you will need zx0 ( https://github.com/einar-saukas/ZX0 ) compiled for your operative system (not included) inside of the java folder as well)
* I used my own MDL Z80 code optimizer to both assemble the game and to help me save a few bytes/cycles here and there: https://github.com/santiontanon/mdlz80optimizer
* PSG (sound) registers: http://www.angelfire.com/art2/unicorndreams/msx/RR-PSG.html
* Z80 user manual: http://www.zilog.com/appnotes_download.php?FromPage=DirectLink&dn=UM0080&ft=User%20Manual&f=YUhSMGNEb3ZMM2QzZHk1NmFXeHZaeTVqYjIwdlpHOWpjeTk2T0RBdlZVMHdNRGd3TG5Ca1pnPT0=
* MSX system variables: http://map.grauw.nl/resources/msxsystemvars.php
* MSX bios calls: 
    * http://map.grauw.nl/resources/msxbios.php
    * https://sourceforge.net/p/cbios/cbios/ci/master/tree/
* VDP reference: http://bifi.msxnet.org/msxnet/tech/tms9918a.txt
* VDP manual: http://map.grauw.nl/resources/video/texasinstruments_tms9918.pdf
* In order to compress data I used ZX0: https://github.com/einar-saukas/ZX0
