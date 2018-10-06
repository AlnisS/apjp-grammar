import processing.pdf.*;
import java.util.Arrays;

String[] hexcolors = new String[] {"e6194B", "3cb44b", "ffe119", "4363d8", "f58231",
                                   "911eb4", "42d4f4", "f032e6", "bfef45", "fabebe",
                                   "469990", "e6beff", "9A6324", "fffac8", "800000",
                                   "aaffc3", "808000", "ffd8b1", "000075", "a9a9a9",
                                   "ffffff", "000000"};

void setup() {
  //size(400, 400, PDF, "filename.pdf");
  size(400, 400);
  textFont(createFont("Makinas-Scrap-5.otf", 20));
  noLoop();
}

void draw() {
  Table table = loadTable("info.csv", "tsv");
  TableRow[] testrows = new TableRow[4];
  for (int i = 0; i < 4; i++) {
    testrows[i] = table.getRow(i);
  }
  Pattern pattern = new Pattern(testrows);
  println(pattern);
  
  background(0);
  pattern.show();
  
  
  //JSONArray testArray = new JSONArray();
  //JSONObject test = new JSONObject();
  
  //line(0, 0, frameCount * 4, height);
  //PGraphicsPDF pdf = (PGraphicsPDF) g;
  //if (frameCount == 100) {
  //  println("done");
  //  exit();
  //} else {
  //  pdf.nextPage();
  //}
}

void prettyPrint(float x, float y, String[] text, color[] colors) {
  float accx = x;
  for (int i = 0; i < text.length; i++) {
    stroke(colors[i]);
    text(text[i], accx, y);
    accx += textWidth(text[i]);
  }
}

//color idToColor(String s) {
//
//}

class Pattern {
  String[] basej;
  String[] basee;
  String[] genj;
  color[] basejc;
  color[] baseec;
  color[] genjc;
  Pattern(TableRow[] rows) {
    basej = new String[rows[0].getColumnCount()];
    basejc = new color[rows[0].getColumnCount()];
    basee = new String[rows[2].getColumnCount()];
    baseec = new color[rows[2].getColumnCount()];
    genj = new String[rows[1].getColumnCount()];
    genjc = new color[rows[1].getColumnCount()];
    
    Arrays.fill(basejc, color(255));
    Arrays.fill(baseec, color(255));
    Arrays.fill(genjc, color(255));
    
    for (int i = 0; i < rows[0].getColumnCount(); i++) {
      basej[i] = rows[0].getString(i);
    }
    for (int i = 0; i < rows[2].getColumnCount(); i++) {
      basee[i] = rows[2].getString(i);
    }
    for (int i = 0; i < rows[0].getColumnCount(); i++) {
      genj[i] = rows[1].getString(i).isEmpty() ? rows[0].getString(i) : rows[1].getString(i);
    }
    
    //for (int i = 0; i < rows[1].getColumnCount(); i++) {
    //  basejc[i] = idToColor(rows[1].getString(i));
    //}
  }
  
  void show() {
    prettyPrint(10, 30, basej, basejc);
    prettyPrint(10, 50, basee, baseec);
    prettyPrint(10, 70, genj,  genjc);
  }
  
  String toString() {
    String result = "";
    for (String s : basej) result += s; result += "\n";
    for (String s : basee) result += s; result += "\n";
    for (String s : genj)  result += s; result += "\n";
    return result;
  }
}
