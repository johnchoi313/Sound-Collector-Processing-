//Initial robot code by yoggy on Stackoverflow.  
//https://gist.github.com/yoggy/8280330

//Clipboard copy by Carl Bosch.
//http://stackoverflow.com/questions/1248510/convert-string-to-keyevents

//Minim code used from Minim sample:
//http://code.compartmental.net/tools/minim/quickstart/

/* NOTES:
 * Needs 1920x1080 monitor.
 * Works only on Windows.
 * Maximize Processing to left. (Windows key+Left key)
 * Maximize Google Chrome to right. (Windows key+Right key)
 */

/* --- PRE SETUP --- */
import java.awt.*;
import java.awt.event.*;
import java.awt.Toolkit;
import java.awt.datatransfer.*;
import java.awt.event.KeyEvent;
import java.awt.event.InputEvent;
import ddf.minim.*;

//search vars
String search[] = {"mozart","dubstep","hamburger","monkey","art","rocket","airplane","happy"};
int searchIndex = 0;
String url= "https://www.youtube.com/results?search_query=";
boolean searched = false;
int page = 1; int pages = 4; //searches pages-1 pages
int link = 0; int links = 4; //goes through links+1 links

//robot vars
Robot robot;

int urlX = 1200;
int urlY = 60;

int linkX = 1200;
int linkY[] = {200,340,480,610,750};

int timer = 0;
int wait = 100;
int load = 2000;

//Minim vars
Minim minim;
AudioInput in;
AudioRecorder recorder[] = new AudioRecorder[3];

boolean listening = false;
int listeningTime = 0;
int listeningTimer = 5000;
int listeningTo = 0;

/* ----- SETUP ----- */
void setup() {
  try {
    robot = new Robot();
  } catch (Exception e) {
    e.printStackTrace();
  }
  minim = new Minim(this);
  in = minim.getLineIn();
  
  for(int r = 0; r < search.length; r++) {
    recorder[r] = minim.createRecorder(in, search[r]+".wav",true);
  }
}

/* --- MAIN LOOP --- */
void draw() {
  
  //if we're not listening:
  if(listening == false) {
    //search for the next entry in search:
    if(!searched){
      //if we've reached the end of the queries, quit.
      if(searchIndex >= search.length-1) {backspace(); delay(load); exit();}
      //search for the query on youtube:
      mouseMoveAndClick(urlX,urlY);
      type(url+search[searchIndex]+"&page="+page);
      listeningTo = searchIndex;
      enter();
      if(page <= pages) {
        page+=1;
      } else {
        recorder[listeningTo].save();
        searchIndex+=1;
        page=1;
      }
      searched = true;
      //wait for load time:
      delay(load);
    }
    //click on the links one by one:
    if(searched) {
      mouseMoveAndClick(linkX,linkY[link]);
      if(link < links) {
        link+=1;
      } else {
        link = 0;
        page+=1;
        searched = false;
      }
      delay(load);
      listeningTime = millis();
      listening = true;
      recorder[listeningTo].beginRecord();
    }
  }
  //if we're listening:
  if(listening == true) {
    //if done listening, get out.
    if (millis() - listeningTime > listeningTimer) {
      listening = false;
      recorder[listeningTo].endRecord();
      backspace();
      delay(load);
    }
  }
}

//robot commands
void mouseMoveAndClick(int x, int y) {
  robot.mouseMove(x, y);
  delay(wait);
  robot.mousePress(InputEvent.BUTTON1_MASK);
  delay(wait);
  robot.mouseRelease(InputEvent.BUTTON1_MASK);
  delay(wait);
}
void type(String characters) {
  Clipboard clipboard = Toolkit.getDefaultToolkit().getSystemClipboard();
  StringSelection stringSelection = new StringSelection( characters );
  clipboard.setContents(stringSelection,null);

  robot.keyPress(KeyEvent.VK_CONTROL);
  robot.keyPress(KeyEvent.VK_A);
  delay(wait);
  robot.keyRelease(KeyEvent.VK_A);
  robot.keyRelease(KeyEvent.VK_CONTROL);
  delay(wait);

  robot.keyPress(KeyEvent.VK_CONTROL);
  robot.keyPress(KeyEvent.VK_V);
  delay(wait);
  robot.keyRelease(KeyEvent.VK_V);
  robot.keyRelease(KeyEvent.VK_CONTROL);
  delay(wait);
}
void enter() {
  robot.keyPress(KeyEvent.VK_ENTER);
  delay(wait);
  robot.keyRelease(KeyEvent.VK_ENTER);
  delay(wait);
}
void backspace() {
  robot.keyPress(KeyEvent.VK_BACK_SPACE);
  delay(wait);
  robot.keyRelease(KeyEvent.VK_BACK_SPACE);
  delay(wait);
}
void delay(int delay) {
  int time = millis();
  while(millis() - time <= delay);
}
