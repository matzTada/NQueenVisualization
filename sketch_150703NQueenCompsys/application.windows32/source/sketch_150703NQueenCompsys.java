import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.lang.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class sketch_150703NQueenCompsys extends PApplet {



//NQueen problem
int NUM = 8;
int mousemode = 1;
int [][] grid = new int [NUM+1][NUM+1];

int fingerx, fingery;
int solvedflag = 0;
int testcounter=0;
int solvedcounter=0;

int adjuster_x = 6;
int adjuster_y = 6;
int adjuster_size = 8;
int gridsize;

int [] verticalcheck = new int[NUM];
int [] leftdiagonalcheck = new int[NUM*2];
int [] rightdiagonalcheck = new int[NUM*2];

int [] result = new int [NUM]; //save queen's x-position of y


//flag; 0 as able to put queen, 1 as unable, 2 as queen set 
public void queenline(int x, int y, int gridnumber, int undernumber) { //when flag=1 => delete flag=0 => set
  grid[x][y] = gridnumber;
  for (int k = 1; k < NUM - y; k++) {//earn flag
    grid[x    ][y + k] = undernumber;
    if (x - k >= 0)       grid[x - k][y + k] = undernumber; 
    if (x + k <= NUM - 1) grid[x + k][y + k] = undernumber;
  }
}

public void updateCheckbox(int x, int y, int number) {//if tick : 1, delete : 1
  verticalcheck[x] = number;
  leftdiagonalcheck[x+y] = number;
  rightdiagonalcheck[x - y + NUM] = number;
}

public void goup() {
  fingery--;
  if (fingery == -1) {
    println("error");
    solvedflag = 1;
    return;
  }

  for (int j = fingery+1; j < NUM; j++) for (int i1 = 0; i1 < NUM; i1++) grid[i1][j] = 0;
  //shift upper queen
  queenline(result[fingery], fingery, 1, 0);

  result[fingery]++;
  fingerx = result[fingery];
}

public void NQsolveStep() {
  solvedflag = 0;
  testcounter++;

  for (int j = 0; j < NUM; j++) { 
    for (int i1 = 0; i1 < NUM; i1++) {
      if (grid[i1][j] == 2) queenline(i1, j, 2, 1);
    }
  }

  //  print("befor" + testcounter + "th_x:" + fingerx + "_y:" + fingery + "\n");
  if (fingery == 0 && fingerx == NUM) {
    println("finish");
    solvedflag=1;
    return;
  }

  //check grid
  int ifflag = 0;
  if (grid[fingerx][fingery] == 0) {//good grid
    queenline(fingerx, fingery, 2, 1); //put queen

    //--------new 20150703------------
    updateCheckbox(fingerx, fingery, 1); //tick box
    //--------------------------------

    result[fingery] = fingerx;
    fingery++;
    fingerx = 0;
    ifflag = 1;
  } else if (grid[fingerx][fingery] == 1 && ifflag == 0) {//bad grid
    fingerx++;
  }

  //back to upper line
  //    int linecounter=0;
  //    for (int temp = 0; temp < NUM; temp++) if (grid[temp][fingery]==1) linecounter++; 
  if (fingery == NUM) {//solved!!!
    solvedflag = 1;
    solvedcounter++;
    print("NUM:" + NUM + " calc:" + testcounter + " solved:" + solvedcounter + " position:");
    for (int k = 0; k < NUM; k++) { 
      print(result[k] + ",");
    }
    println();
    //    goup();
  }

  if (fingerx == NUM || fingery == NUM) {
    //--------new 20150703------------
    updateCheckbox(result[fingery-1], fingery-1, 0);//delete box
    //--------------------------------

    goup();
  }
  //  print("after" + testcounter + "th_x:" + fingerx + "_y:" + fingery + "\n");
  //  for (int j = 0; j < NUM; j++) { 
  //    for (int k = 0; k < NUM; k++) { 
  //      print(grid[k][j] + " ");
  //    }
  //    println();
  //  }
}

public void NQsolveInitialize() { //recursvie function
  fingerx=0; 
  fingery=0;
  for (int j = 0; j < NUM + 1; j++) grid[NUM][j] = 3;
}

public void setup() {
  size(600, 600);
  frameRate(30);
  background(0);
  NQsolveInitialize();
  gridsize   = width / (NUM+1+adjuster_size);
}

public void draw() {
  background(255);
  //draw testcounter
  fill(0);
  textSize(gridsize/2);
  text("NUM:" + NUM + " calc:" + testcounter + " solved:" + solvedcounter, 0, 20);
  noFill();

  //current indicatar
  stroke(0, 255, 0);
  strokeWeight(4);
  ellipse((fingerx+adjuster_x)*gridsize, (fingery+adjuster_y)*gridsize, gridsize*0.9f, gridsize*0.9f);
  strokeWeight(1);
  noStroke();


  for (int j = 0; j < NUM; j++) {
    for (int i = 0; i < NUM; i++) {
      //disable to be put
      if (grid[i][j] == 2) {
        //draw line
        //line downward to the right
        stroke(255, 204, 102);
        strokeWeight(3);
        line((i+10+adjuster_x)*gridsize, (j+10+adjuster_y)*gridsize, (i-10+adjuster_x)*gridsize, (j-10+adjuster_y)*gridsize);
        noStroke();      //able to put nothing at all
        //line downward to the left
        stroke(204, 255, 102);
        strokeWeight(3);
        line((i-10+adjuster_x)*gridsize, (j+10+adjuster_y)*gridsize, (i+10+adjuster_x)*gridsize, (j-10+adjuster_y)*gridsize);
        noStroke(); 
        //line downward
        stroke(104, 204, 255);
        strokeWeight(3);
        line((i+adjuster_x)*gridsize, (adjuster_y-10)*gridsize, (i+adjuster_x)*gridsize, (adjuster_y+18)*gridsize);
        noStroke(); 


        fill(255, 0, 0);
        stroke(255, 0, 0);
        strokeWeight(4);
        ellipse((i+adjuster_x)*gridsize, (j+adjuster_y)*gridsize, gridsize, gridsize);
        noFill();
        strokeWeight(1);
        noStroke();

        //able to put nothing at all
      } else if (grid[i][j] == 1) {
        //        fill(255, 0, 0, 60);
        //        ellipse((i+adjuster_x)*gridsize, (j+adjuster_y)*gridsize, gridsize*0.3, gridsize*0.3);
        //        noFill();
        //if queen is here
      } else {
        stroke(255);
        ellipse((i+adjuster_x)*gridsize, (j+adjuster_y)*gridsize, gridsize, gridsize);
        noStroke();
      }
      //draw text
      //      fill(0);
      //      textSize(gridsize/2);
      //      text(grid[i][j], (i+adjuster_x)*gridsize-gridsize/4, (j+adjuster_y)*gridsize+gridsize/4);
      //      noFill();
      //draw grid
      stroke(0);
      strokeWeight(1);
      rect((i+adjuster_x)*gridsize-gridsize/2, (j+adjuster_y)*gridsize-gridsize/2, gridsize, gridsize);
      noStroke();
    }
  }
  //draw X scale 
  for (int i = 0; i < NUM; i++) {    
    fill(0);
    textSize(gridsize/2);
    text(i, (i+adjuster_x)*gridsize-gridsize/4, (0+adjuster_y-1)*gridsize+gridsize/4);
    noFill();
  }
  //draw Y scale 
  for (int j = 0; j < NUM; j++) {
    fill(0);
    textSize(gridsize/2);
    text(j, (0+adjuster_x-1)*gridsize-gridsize/4, (j+adjuster_y)*gridsize+gridsize/4);
    noFill();
  }

  drawCheckboxes();


}

public void drawCheckboxes() {
  //left diagonal line checkbox
  //draw X
  for (int i = 0; i < NUM; i++) {    
    fill(0);
    textSize(gridsize/2);
    text(i, (i+adjuster_x +2)*gridsize-gridsize/4, (0+adjuster_y-1 -2)*gridsize+gridsize/4);
    noFill();
    //draw grid
    if (leftdiagonalcheck[i]==1) fill(204, 255, 102, 255);
    else fill(204, 255, 102, 50);
    stroke(0);
    strokeWeight(1);
    rect((i+adjuster_x+2)*gridsize-gridsize/2, (0+adjuster_y-1-1)*gridsize-gridsize/2, gridsize, gridsize);
    noStroke();
    noFill();
    //draw text
    fill(0);
    textSize(gridsize/2);
    text(leftdiagonalcheck[i], (i+adjuster_x +2)*gridsize-gridsize/4, (0+adjuster_y-1 -1)*gridsize+gridsize/4);
    noFill();
  }
  //draw Y  
  for (int j = 0; j < NUM; j++) {
    fill(0);
    textSize(gridsize/2);
    text(j+8, (0+adjuster_x-1 + NUM+1 +2)*gridsize-gridsize/4, (j+adjuster_y-1)*gridsize+gridsize/4);
    noFill();
    //draw grid
    if (leftdiagonalcheck[j+8]==1) fill(204, 255, 102, 255);
    else fill(204, 255, 102, 50);
    stroke(0);
    strokeWeight(1);
    rect((0+adjuster_x-1 + NUM+1 +1)*gridsize-gridsize/2, (j+adjuster_y-1)*gridsize-gridsize/2, gridsize, gridsize);
    noStroke();
    noFill();
    //draw text
    fill(0);
    textSize(gridsize/2);
    text(leftdiagonalcheck[j+8], (0+adjuster_x-1 + NUM+1 +1)*gridsize-gridsize/4, (j+adjuster_y-1)*gridsize+gridsize/4);
    noFill();
  }
  //right diagonal line checkbox
  //draw X 
  for (int i = 0; i < NUM; i++) {    
    fill(0);
    textSize(gridsize/2);
    text(i+NUM, (i+adjuster_x -4)*gridsize-gridsize/4, (0+adjuster_y -1 -4)*gridsize+gridsize/4);
    noFill();
    //draw grid
    if (rightdiagonalcheck[i+NUM]==1) fill( 255, 204, 102, 255);
    else fill(255, 204, 102, 50);
    stroke(0);
    strokeWeight(1);
    rect((i+adjuster_x-4)*gridsize-gridsize/2, (0+adjuster_y -1 -4 +1)*gridsize-gridsize/2, gridsize, gridsize);
    noStroke();
    noFill();
    //draw text
    fill(0);
    textSize(gridsize/2);
    text(rightdiagonalcheck[i+NUM], (i+adjuster_x -4)*gridsize-gridsize/4, (0+adjuster_y -1 -3)*gridsize+gridsize/4);
    noFill();
  }
  //draw Y
  for (int j = 0; j < NUM; j++) {
    fill(0);
    textSize(gridsize/2);
    text(-j-1, (0+adjuster_x-5)*gridsize-gridsize/4, (j+adjuster_y-3)*gridsize+gridsize/4);
    text("[" + (NUM-1-j) + "]", (0+adjuster_x-3)*gridsize-gridsize/4, (j+adjuster_y-3)*gridsize+gridsize/4);
    noFill();
    //draw grid 
    if (rightdiagonalcheck[NUM-1-j]==1) fill( 255, 204, 102, 255);
    else fill(255, 204, 102, 50);
    stroke(0);
    strokeWeight(1);
    rect((0+adjuster_x -5 + 1)*gridsize-gridsize/2, (j+adjuster_y-3)*gridsize-gridsize/2, gridsize, gridsize);
    noStroke();
    noFill();
    //draw text
    fill(0);
    textSize(gridsize/2);
    text(rightdiagonalcheck[NUM - 1 - j], (0+adjuster_x-4)*gridsize-gridsize/4, (j+adjuster_y-3)*gridsize+gridsize/4);
    noFill();
  }
  //draw vertical
  for (int i = 0; i < NUM; i++) {    
    fill(0);
    textSize(gridsize/2);
    text("[" + i + "]", (i+adjuster_x)*gridsize-gridsize/4, (0+adjuster_y+NUM+2)*gridsize+gridsize/4);
    noFill();
    if (verticalcheck[i] == 1)fill(104, 204, 255, 255);
    else fill(104, 204, 255, 50);
    stroke(0);
    strokeWeight(1);
    rect((i+adjuster_x)*gridsize-gridsize/2, (0+adjuster_y+NUM+1)*gridsize-gridsize/2, gridsize, gridsize);
    noStroke();
    noFill();
    //draw text
    fill(0);
    textSize(gridsize/2);
    text(verticalcheck[i], (i+adjuster_x)*gridsize-gridsize/4, (0+adjuster_y+NUM+1)*gridsize+gridsize/4);
    noFill();
  }
}

public void keyPressed() {
  NQsolveStep();
}

public void mousePressed() {
  for (int i=0; i < 10000; i++) {
    NQsolveStep();
    if (solvedflag==1) break;
  }
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "sketch_150703NQueenCompsys" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
