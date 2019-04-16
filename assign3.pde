final int GAME_START = 0, GAME_RUN = 1, GAME_OVER = 2;
int gameState = 0;

final int Idle =3;
final int Left =4;
final int Down =5;
final int Right =6;
final int BG_MOVE =7;
int actState = Idle;

final int GRASS_HEIGHT = 15;
final int START_BUTTON_W = 144;
final int START_BUTTON_H = 60;
final int START_BUTTON_X = 248;
final int START_BUTTON_Y = 360;

final int SOIL_BLOCK = 8;

int move = 0 ;
int moveTime = 0; 

//groundhog
PImage groundhogIdleImg;
PImage groundhogDownImg;
PImage groundhogLeftImg;
PImage groundhogRightImg;


PImage title, gameover, startNormal, startHovered, restartNormal, restartHovered;
PImage bg, soil8x24;
PImage lifeImg;

PImage stoneImg1,stoneImg2;



int playerHealth = 2 ;
int nbrSoil = 6;
int spacing = 80;
int soilhNbr;
int [] soilY = new int[nbrSoil];
int soilX;

int grassX=0;
int grassY=160 - GRASS_HEIGHT;


int groundhogX = 320;
int groundhogY = 80;
int groundhogSpeed = 5;
int groundhogWidth = 80;

PImage soilImage[] = new PImage[nbrSoil];

// For debug function; DO NOT edit or remove this!
//int playerHealth = 0;
float cameraOffsetY = 0;
boolean debugMode = false;

void setup() {
  size(640, 480, P2D);
  // Enter your setup code here (please put loadImage() here or your game will lag like crazy)
  bg = loadImage("img/bg.jpg");
  title = loadImage("img/title.jpg");
  gameover = loadImage("img/gameover.jpg");
  startNormal = loadImage("img/startNormal.png");
  startHovered = loadImage("img/startHovered.png");
  restartNormal = loadImage("img/restartNormal.png");
  restartHovered = loadImage("img/restartHovered.png");
  soil8x24 = loadImage("img/soil8x24.png");
  groundhogIdleImg = loadImage("img/groundhogIdle.png");
  groundhogDownImg = loadImage("img/groundhogDown.png");
  groundhogLeftImg = loadImage("img/groundhogLeft.png");
  groundhogRightImg = loadImage("img/groundhogRight.png");
  
  stoneImg1 = loadImage("img/stone1.png"); 
  stoneImg2 = loadImage("img/stone2.png");
  
  for(int i =0; i<nbrSoil ; i++){
    soilImage[i] = loadImage("img/soil"+i+".png");
  }
  
  lifeImg = loadImage("img/life.png");
  
  for(int i = 0; i<nbrSoil;i++){
      soilY[i] = 160+i*80*4;
    }
   
   
}

void draw() {
    /* ------ Debug Function ------ 
      Please DO NOT edit the code here.
      It's for reviewing other requirements when you fail to complete the camera moving requirement.
    */
    if (debugMode) {
      pushMatrix();
      translate(0, cameraOffsetY);
    }
    /* ------ End of Debug Function ------ */

    
  switch (gameState) {

    case GAME_START: // Start Screen
    image(title, 0, 0);

    if(START_BUTTON_X + START_BUTTON_W > mouseX
      && START_BUTTON_X < mouseX
      && START_BUTTON_Y + START_BUTTON_H > mouseY
      && START_BUTTON_Y < mouseY) {

      image(startHovered, START_BUTTON_X, START_BUTTON_Y);
      if(mousePressed){
        gameState = GAME_RUN;
        mousePressed = false;
      }

    }else{

      image(startNormal, START_BUTTON_X, START_BUTTON_Y);

    }
    break;

    case GAME_RUN: // In-Game

    // Background
    image(bg, 0, 0);

    // Sun
      stroke(255,255,0);
      strokeWeight(5);
      fill(253,184,19);
      ellipse(590,50,120,120);

    // Grass
    fill(124, 204, 25);
    noStroke();
    rect(grassX, grassY+move, width, GRASS_HEIGHT);
    


    // Soil - REPLACE THIS PART WITH YOUR LOOP CODE!
    //image(soil8x24, 0, 160);
      for(int soilX = 0 ; soilX<spacing*8; soilX +=spacing ){
        for(int i = 0; i<nbrSoil;i++){
          for(int n = 0 ; n<4 ;n++){
            image(soilImage[i], soilX, soilY[i]+spacing*n+move);  
          }
        }
      }

    //Stone1-8
    for(int i = 0 ;i<SOIL_BLOCK ;i++ ){
      int X = i*spacing;
      int Y = 160+i*spacing;
      image(stoneImg1,X,Y+move);
    }
    //Stone9-16
    for(int n = 0 ; n<4 ; n++){
      for(int i = 0 ;i<SOIL_BLOCK ;i++ ){
        int X = i*spacing+6*spacing-n*4*spacing;
        int Y = 160+8*spacing+i*spacing;
        image(stoneImg1,X,Y+move);
        int X2 = i*(-spacing)+spacing+n*4*spacing;
        int Y2 = 160+8*spacing+i*spacing;
        image(stoneImg1,X2,Y2+move);
      }
    }
    //Stone 17- 24
    for(int n = 0 ; n<SOIL_BLOCK*2 ; n++){
      for(int i = 0 ;i<SOIL_BLOCK ;i++ ){
        if(n %3 ==1){
          int X = i*(-spacing)+n*spacing;
          int Y = 160+16*spacing+i*spacing;
          image(stoneImg1,X,Y+move);
        }
        else if(n %3 == 2){
          int X = i*(-spacing)+n*spacing;
          int Y = 160+16*spacing+i*spacing;
          image(stoneImg1,X,Y+move);
          int X2 = i*(-spacing)+n*spacing;
          int Y2 = 160+16*spacing+i*spacing;
          image(stoneImg2,X2,Y2+move);
        }
      }
    }

    // Player
    switch(actState){
        case Idle:
          image(groundhogIdleImg,groundhogX,groundhogY);
          break;
        case Left:
          groundhogX -= groundhogSpeed;
            image(groundhogLeftImg,groundhogX,groundhogY);
          if(groundhogX %spacing == 0){actState = Idle;}
          if(groundhogX < 0){ 
            groundhogX = 0;
            actState = Idle;
          }
          break;
        case Down:
          groundhogY += groundhogSpeed;
            image(groundhogDownImg,groundhogX,groundhogY);
         if(groundhogY %spacing == 0){actState = Idle;}
          
          if(groundhogY > height-groundhogWidth){
            groundhogY=height-groundhogWidth;
            actState = Idle;
          }
          break;
        case Right:
          groundhogX += groundhogSpeed;
            image(groundhogRightImg,groundhogX,groundhogY);
          if(groundhogX %spacing == 0){actState = Idle;}
          if(groundhogX > width-groundhogWidth){
            groundhogX = width-groundhogWidth;
            actState = Idle;
          }
          break;
         case BG_MOVE:
            move-=groundhogSpeed;
            image(groundhogDownImg,groundhogX,groundhogY);
            if(move % spacing == 0){
              actState = Idle;
            }
          
      }

    // Health UI
    if (playerHealth <= 5){
      for(int i = 0; i<playerHealth ;i++){
        int x = 10+i*70;
        int y = 10;
          image(lifeImg,x,y);       
      }
    }
    break;

    case GAME_OVER: // Gameover Screen
    image(gameover, 0, 0);
    
    if(START_BUTTON_X + START_BUTTON_W > mouseX
      && START_BUTTON_X < mouseX
      && START_BUTTON_Y + START_BUTTON_H > mouseY
      && START_BUTTON_Y < mouseY) {

      image(restartHovered, START_BUTTON_X, START_BUTTON_Y);
      if(mousePressed){
        gameState = GAME_RUN;
        mousePressed = false;
        // Remember to initialize the game here!
      }
    }else{

      image(restartNormal, START_BUTTON_X, START_BUTTON_Y);

    }
    break;
    
  }

    // DO NOT REMOVE OR EDIT THE FOLLOWING 3 LINES
    if (debugMode) {
        popMatrix();
    }
}

void keyPressed(){
  // Add your moving input code here
    if (key == CODED && gameState == GAME_RUN) {
    switch (keyCode) {
      case DOWN:
      if(groundhogY %spacing == 0 && groundhogX %spacing == 0 && move % spacing == 0){
        if (moveTime<20){
          actState = BG_MOVE;
        }else{
          actState = Down;
         }
        moveTime++;
      }
        break;
      case LEFT:
        if(groundhogY %spacing == 0 && groundhogX %spacing == 0 && move % spacing == 0){
          actState = Left;
        }
        
        break;
      case RIGHT:
        if(groundhogY %spacing == 0 && groundhogX %spacing == 0 && move % spacing == 0){
          actState = Right;
        }
        
        break;
    }
   }

  // DO NOT REMOVE OR EDIT THE FOLLOWING SWITCH/CASES
    switch(key){
      case 'w':
      debugMode = true;
      cameraOffsetY += 25;
      break;

      case 's':
      debugMode = true;
      cameraOffsetY -= 25;
      break;

      case 'a':
      if(playerHealth > 0) playerHealth --;
      break;

      case 'd':
      if(playerHealth < 5) playerHealth ++;
      break;
    }
}

void keyReleased(){
}
