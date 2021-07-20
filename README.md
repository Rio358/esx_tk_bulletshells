# esx_tk_bulletshells
Is a script that leaves bullet shells to the ground when a gun is shot which police can inspect. Great way to allow police to investigate crime scenes. 
- **[Video](https://www.youtube.com/watch?v=Y84ymYKUVEE)**

# Useful information
- Not tested with multiple players
- Only tested with ESX V1 Final

# Features
- Saves bullet shell at player coords when a gun is shot
- Police can inspect bullets shells while holding a flashlight
- Inspecting a shell reveals the gun and the time the gun was shot
- Shells automatically save to database
- Police:
  - Idle > 0.03 ms 
  - Aiming with flashlight with shell infront > ~0.10 ms (More shells = Bigger usage)
- Non-police:
  - Idle > 0.01 ms
  - Shooting > ~0.05 ms

# Requirements
- [es_extended](https://github.com/esx-framework/esx-legacy/tree/main/%5Besx%5D/es_extended)
- [mysql-async](https://github.com/brouznouf/fivem-mysql-async)
- [mythic_notify](https://github.com/JayMontana36/mythic_notify) (You can easily change the notification in client/main.lua file)

# Downloading & installing the script
- Download the file and extract ```esx_tk_bulletshells``` into your resources/ folder
- Add ```start esx_tk_bulletshells``` to your ```server.cfg``` file
- Insert the ```esx_tk_bulletshells.sql``` file into your database
- _(Optional) Edit ```config.lua``` to your liking_
