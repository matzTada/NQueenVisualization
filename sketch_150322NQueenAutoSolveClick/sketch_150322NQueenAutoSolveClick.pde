//NQueen problem
int NUM = 8;
int mousemode = 1;
int [][] grid = new int [NUM+1][NUM+1];

int fingerx, fingery;
int solvedflag = 0;
int testcounter=0;
int solvedcounter=0;

void queenline(int x, int y, int gridnumber, int undernumber) { //when flag=1 => delete flag=0 => set
  grid[x][y] = gridnumber;
  for (int k = 1; k < NUM - y; k++) {//earn flag
    grid[x    ][y + k] = undernumber;
    if (x - k >= 0)       grid[x - k][y + k] = undernumber; 
    if (x + k <= NUM - 1) grid[x + k][y + k] = undernumber;
  }
}

void goup() {
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

void NQsolveStep() {
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

//flag; 0 as able to put queen, 1 as unable, 2 as queen set 
int [] result = new int [NUM]; //save queen's x-position of y
void NQsolveInitialize() { //recursvie function
  fingerx=0; 
  fingery=0;
  for (int j = 0; j < NUM + 1; j++) grid[NUM][j] = 3;
}

void setup() {
  size(600, 600);
  frameRate(30);
  background(0);
  NQsolveInitialize();
}

void draw() {
  background(255);

  int gridsize = width / (NUM+1);

  stroke(0, 255, 0);
  strokeWeight(4);
  ellipse((fingerx+1)*gridsize, (fingery+1)*gridsize, gridsize*0.9, gridsize*0.9);
  strokeWeight(1);
  noStroke();
  for (int j = 0; j < NUM; j++) {
    for (int i = 0; i < NUM; i++) {
      if (grid[i][j] == 1) {
        fill(255, 0, 0, 60);
        ellipse((i+1)*gridsize, (j+1)*gridsize, gridsize*0.3, gridsize*0.3);
        noFill();
      } else if (grid[i][j] == 2) {
        fill(255);
        stroke(0, 255, 255);
        strokeWeight(4);
        ellipse((i+1)*gridsize, (j+1)*gridsize, gridsize, gridsize);
        noFill();
        strokeWeight(1);
        noStroke();
      } else {
        stroke(255);
        ellipse((i+1)*gridsize, (j+1)*gridsize, gridsize, gridsize);
        noStroke();
      }
      fill(0);
      textSize(gridsize/2);
      text(grid[i][j], (i+1)*gridsize-gridsize/4, (j+1)*gridsize+gridsize/4);
      noFill();
      stroke(0);
      rect((i+1)*gridsize-gridsize/2, (j+1)*gridsize-gridsize/2, gridsize, gridsize);
      noStroke();
    }
  }
}

void keyPressed() {
  NQsolveStep();
}

void mousePressed() {
  for (int i=0; i < 100000; i++) {
    NQsolveStep();
    if (solvedflag==1) break;
  }
}

