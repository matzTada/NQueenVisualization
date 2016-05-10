//NQueen problem
int NUM = 6;
int [][] grid = new int [NUM][NUM];

void setqueen(int x, int y) {
  int number = 1;
  grid[x][y] = -1;
  for (int k = 1; k < NUM - y; k++) {//earn flag
    grid[x    ][y + k] += number;
    if (x - k >= 0)       grid[x - k][y + k] += number; 
    if (x + k <= NUM - 1) grid[x + k][y + k] += number;
  }
}

void deletequeen(int x, int y) {
  int number = -1;
  grid[x][y] = 0;
  for (int k = 1; k < NUM - y; k++) {//earn flag
    grid[x    ][y + k] += number;
    if (x - k >= 0)       grid[x - k][y + k] += number; 
    if (x + k <= NUM - 1) grid[x + k][y + k] += number;
  }
}

int [] result = new int [NUM];
void NQsolve() { //recursvie function  
  int solvedflag = 1;
  int testcounter=0;
  int fingerx=0, fingery=0;

  //initial condition set queen at (0, 0)
  setqueen(fingerx, fingery);
  result[fingery] = fingerx;

  fingery++; //going next line

  for (int i=0; i < 10000; i++) {
    testcounter++;
    print("befor" + testcounter + "th_x:" + fingerx + "_y:" + fingery + "\n");

    //check grid
    int ifflag = 0;
    if (grid[fingerx][fingery] == 0) {//good grid
      setqueen(fingerx, fingery);
      result[fingery] = fingerx;
      fingery++;
      fingerx = 0;
      if (fingery == NUM) {
        println("finish");
        break;
      }
      ifflag = 1;
    } else if (grid[fingerx][fingery] >= 1 && ifflag == 0) {//bad grid
      fingerx++;
    }

    //back to upper line
    for (int temp2 = 0; temp2<NUM; temp2++) {
      int linecounter=0;
      for (int temp = 0; temp<NUM; temp++) {
        if (grid[temp][temp2]>=1) linecounter++;
      }   
      if (linecounter == NUM) {
        fingery--;
        if (fingery == -1) {
          println("can't solve any answer");
          break;
        }
        //shift upper queen
        deletequeen(result[temp2], temp2);
        result[temp2]++;
        fingerx = result[temp2];
      }
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
      if (grid[i][j] >= 1) {
        fill(255, 0, 0, 60);
        ellipse((i+1)*40, (j+1)*40, 18, 18);
      } else if (grid[i][j] == -1) {//queen
        fill(255);
        stroke(0, 255, 255);
        ellipse((i+1)*40, (j+1)*40, 36, 36);
      } else {
        stroke(255);
        ellipse((i+1)*40, (j+1)*40, 5, 5);
      }
      fill(0);
      textSize(12);
      text(grid[i][j], (i+1)*40-4, (j+1)*40+2);
      noFill();
      stroke(0);
      rect((i+1)*40-20, (j+1)*40-20, 38, 38);
    }
  }
}

