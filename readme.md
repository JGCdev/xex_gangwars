# xex_gangwars 
Simple script to enable gang wars on any FiveM ESX Server

## Requirements
* es_extended
* rp-progress (optional) [rp-progress](https://github.com/Mobius1/rprogress)

## Installation

Drag the folder into your `<server-data>/resources/` folder and add this to your server.cfg
```
start xex_gangwars
```

## Configuration
-Add your ESX server gang names from DB jobs table to gangs object in config.lua. 
-Change gang's color
-Add new zones (for this you need to adjust a square on the map)

## Use
Player should get 3 points on each zone to conquer it, after conquer the gang win money for owning territory.
Each territory have a 2h cooldown to be on dispute and free to be conquered.
