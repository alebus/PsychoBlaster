My project is called PsychoBlaster and it's a game made with LOVE and Lua. 
Here's how the game works and a description of some of the features: 
- The player is a shape that can move and shoot in any direction independently. I limited the rate of fire but it's constant when the gamepad stick or keyboard is held down. I gave the control a bit of a slippery feeling by not completely stopping the player when the controls are released. 
- There are 4 layers for the background with a parallax scrolling effect. I made the art for the backgound in Photoshop. It's controlled with a background class that lets you  pass in an image and then specify how fast it moves relative to the player's velocity, to create the parallax effect. You can also zoom/rotate some of the layers, etc.
- Enemies spawn from random edges of the screen, with randomized colors and sizes, in a randomized range of delay. 
- The enemies move towards the player by trying to change their own x and y values to the same as the player, and if they touch the player there is collision detection and the  game is over. 
- Each time an enemy spawns, their speed increases so the game gets more and more difficult.
- After 25 enemies, the delay between enemies is reduced (and their movement speed still keeps increasing) and a message saying "Let's get PSYCHO!" displays on the screen while the score starts flashing red. 
- The bullets and enemies are added to tables which track their velocity, and when a collision occurs or they leave the screen then they are deleted from the table. 
- The player gets a point for every enemy killed and the goal is to survive as long as possible. 
- I made the sound effects in SoundForge and Rytmik Studio. 

