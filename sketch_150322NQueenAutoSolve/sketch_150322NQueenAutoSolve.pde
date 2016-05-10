//NQueen problem
int NUM = 8;
int mousemode = 1;
int [][] grid = new int [NUM+1][NUM+1];

void queenline(int x, int y, int number) {
  for (int k = 1; k < NUM - y; k++) {//earn flag
                          grid[x    ][y + k] = number;
    if (x - k >= 0)       grid[x - k][y + k] = number; 
    if (x + k <= NUM - 1) grid[x + k][y + k] = number;
  }
}

//flag; 0 as able to put queen, 1 as unable, 2 as queen set 
int [] result = new int [NUM]; //save queen's x-position of y
void NQsolve() { //recursvie function
  int solvedflag = 1;
  int testcounter=0;
  int fingerx=0, fingery=0;
  for (int j = 0; j < NUM + 1; j++) grid[NUM][j] = 3; 

  //initial condition set queen at (0, 0)
  grid[fingerx][fingery] = 2;
  result[fingery] = fingerx;
  fingery++; //next line

  for (int i=0; i < 10000; i++) {
    testcounter++;

    for (int j = 0; j < NUM; j++) { 
      for (int i1 = 0; i1 < NUM; i1++) {
        if (grid[i1][j] == 2) queenline(i1, j, 1);
      }
    }

    print("befor" + testcounter + "th_x:" + fingerx + "_y:" + fingery + "\n");

    //check grid
    int ifflag = 0;
    if (grid[fingerx][fingery] == 0) {//good grid
      grid[fingerx][fingery] = 2; //put queen
      result[fingery] = fingerx;
      fingery++;
      fingerx = 0;
      if (fingery == NUM) {
        println("finish");
        break;
      }
      ifflag = 1;
    } else if (grid[fingerx][fingery] == 1 && ifflag == 0) {//bad grid
      fingerx++;
    }

    //back to upper line
    //    int linecounter=0;
    //    for (int temp = 0; temp < NUM; temp++) if (grid[temp][fingery]==1) linecounter++; 
    if (fingerx == NUM) {
      fingery--;
      if (fingery == -1) {
        println("can't solve any answer");
        break;
      }

      for (int j = fingery+1; j < NUM; j++) for (int i1 = 0; i1 < NUM; i1++) grid[i1][j] = 0;
      //shift upper queen
      grid[result[fingery]][fingery] = 1;
      queenline(result[fingery], fingery, 0);

      result[fingery]++;
      fingerx = result[fingery];
    }

    print("after" + testcounter + "th_x:" + fingerx + "_y:" + fingery + "\n");
    for (int j = 0; j < NUM; j++) { 
      for (int k = 0; k < NUM; k++) { 
        print(grid[k][j] + " ");
      }
      println();
    }
  }
}

void setup() {
  size(400, 400);
  frameRate(30);
  background(0);
  NQsolve();
}

void draw() {
  background(255);
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
