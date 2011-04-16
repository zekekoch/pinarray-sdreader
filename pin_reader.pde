/*
 * This sketch will list all files in the root directory and 
 * then do a recursive list of all directories on the SD card.
 *
 */

#include <SD.h>
#include <stdio.h>
#include "Tlc5940.h"



Sd2Card card;
SdVolume volume;
SdFile root;

byte colors[3][3][3];
float depth[3][3];
unsigned long startTime;
File frameFile;

void setup() {
  Serial.begin(9600);
  Tlc.init(0);
  Serial.println("Type any character to start");
  while (!Serial.available());
  startTime = millis();
  
  Serial.println("Free RAM: ");
  Serial.println(FreeRam());  
  
  pinMode(10, OUTPUT);
  if(!SD.begin(8)) {
   Serial.println("initialization failed!");
   return;
  }
  
}

void drawFrame(File frame)
{
  byte i = 0;
  Tlc.clear();
  for (byte x=15;x<18;x++)
  {
    for (byte y=0;y<3;y++)
    {
      if(i>15)
        break;
      Tlc.set(i++, (int)frame.read()); // red
      //Tlc.set(i++, (int)frame.read()*15);
      Tlc.set(i++, (int)frame.read()); //blue
      Tlc.set(i++, (int)frame.read()); // green
      //Tlc.set(i++, (int)frame.read()*15);
    } 
    //Serial.print(colorFile.position());Serial.print(",");
    frame.seek(48*3*(x+1));
    //Serial.print(colorFile.position());
  }
  Tlc.update();  
}


void loop() { 
  for(byte i = 0;i<205;i++)
  {
    char colorFile[18];
//    sprintf(colorFile, "DEPTH/BC%i.CSV", i);
    sprintf(colorFile, "Icons/BC%i.CSV", i);
    frameFile = SD.open(colorFile, FILE_READ);
    Serial.println(colorFile);
    if (!colorFile) {
      Serial.println("couldn't open file");
      return;
    }
    drawFrame(frameFile);
    frameFile.close();
    delay(500);
  }

}
