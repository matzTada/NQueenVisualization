//NQueen problem
int fingerx, fingery;
int NUM = 8;
int mousemode = 1;
int [] result = new int [NUM]; //save position of 2
int [][] grid = new int [NUM][NUM];

void setup() {
  size(400, 400);
  frameRate(30);
  background(0);
}

void queenline(int x, int y, int number) {
//  for (int k = 0; k < NUM; k++) if (k != x) grid[k][y] = number;
//  for (int k = 0; k < NUM; k++) if (k != y) grid[x][k] = number;
  for (int k = 1; k < NUM - y; k++) {//earn flag
    if (x - k >= 0) grid[x - k][y + k] = number; 
    if (x + k <= NUM - 1) grid[x + k][y + k] = number;
    grid[x][y+k] = number;
  }
//  for (int k = 1; k <= y; k++) {//earn flag
//    if (x - k >= 0) grid[x - k][y - k] = number; 
//    if (x + k <= NUM - 1) grid[x + k][y - k] = number;
//  }
}

//flag; 0 as able to put queen, 1 as unable, 2 as queen set 
void NQsolve() { //recursvie function
  if (grid[fingerx][fingery] == 1) {
    fingerx++;
    if (fingerx == NUM) {
      fingery--;
      result[fingery]++;
      if (result[fingery] == NUM) {
        println("can't solve any answer");
        exit();
      }
    } //replace previous step queen
  } else if (grid[fingerx][fingery] == 0) {
    grid[fingerx][fingery] = 2; //put queen
    result[fingery] = fingerx;
    if (fingery == NUM - 1) {
      println("finish");
      exit();

      queenline(fingerx, fingery, 2);
      fingerx = 0;
      fingery++;
    }
    NQsolve();
  }
}

void draw() {
  //  NQsolve();
  // grid[0][0] = 2;
  background(255);
  for (int j = 0; j < NUM; j++) {
    for (int i = 0; i < NUM; i++) {
      if ( grid[i][j] == 2) queenline(i, j, 1);
    }
  }
  for (int j = 0; j < NUM; j++) {
    for (int i = 0; i < NUM; i++) {
      if (grid[i][j] == 1) {
        fill(255, 0, 0, 60);
        ellipse((i+1)*40, (j+1)*40, 18, 18);
      } else if (grid[i][j] == 2) {
        fill(255);
        stroke(0, 255, 255);
        ellipse((i+1)*40, (j+1)*40, 36, 36);
      } else {
        stroke(255);
        ellipse((i+1)*40, (j+1)*40, 5, 5);
      }
      fill(0);
      textSize(12);
      text(grid[i][j], (i+1)*40, (j+1)*40);
      noFill();
      stroke(0);
      rect((i+1)*40-20, (j+1)*40-20, 38, 38);
    }
  }
}

void mousePressed() {
  for (int j=0; j<NUM; j++) {
    for (int i=0; i<NUM; i++) {
      if ((i+1)*40-20<=mouseX && mouseX< (i+2)*40-20 && (j+1)*40-20 <= mouseY && mouseY < (j+2)*40-20 ) {
        println(i+","+j+","+mouseX+","+mouseY);
        if (mouseButton  == LEFT){//mousemode == 1) {
          grid[i][j]=2;
        } else if (mouseButton == RIGHT){//mousemode == 0) {
          grid[i][j]=0;
          queenline(i, j, 0);
        }
      }
    }
  }
}

void keyPressed() {
  if (key == 'd' || key == 'D') {
    mousemode = 0;
  } 
  if (key == 's' || key == 'S') {
    mousemode = 1;
  }
  if (key == 'r' || key == 'R') {

    for (int j2 = 0; j2 < NUM; j2++) {
      for (int i2 = 0; i2 < NUM; i2++) {
        grid[i2][j2] =0;
      }
    }
  }
}

