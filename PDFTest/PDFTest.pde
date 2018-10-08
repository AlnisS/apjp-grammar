import processing.pdf.*;
import java.util.Arrays;

String[] hexcolors = new String[] {"e6194BFF", "3cb44bFF", "ffe119FF", "4363d8FF", "f58231FF",
                                   "911eb4FF", "42d4f4FF", "f032e6FF", "bfef45FF", "fabebeFF",
                                   "469990FF", "e6beffFF", "9A6324FF", "fffac8FF", "800000FF",
                                   "aaffc3FF", "808000FF", "ffd8b1FF", "000075FF", "a9a9a9FF",
                                   "ffffffFF", "000000FF"};

void setup() {
  size(1024, 576, PDF, "filename.pdf");
  //size(1024, 576);
  textFont(createFont("ume-hgo4.ttf", 40));
  noLoop();
}

void draw() {
  Table table = loadTable("info.csv", "tsv");
  TableRow[] testrows = new TableRow[4];
  PGraphicsPDF pdf = (PGraphicsPDF) g;
  for (int j = 0; j < 3; j++) {
    String unit = table.getRow(j * 6).getString(0);
    for (int i = 0; i < 4; i++) {
      testrows[i] = table.getRow(j * 6 + 1 + i);
    }
    Pattern pattern = new Pattern(testrows, unit);
    println(pattern);
    
    background(0);
    pattern.show();
    pdf.nextPage();
  }
  exit();
}

void prettyPrint(float x, float y, String[] text, color[] colors) {
  float accx = x;
  for (int i = 0; i < text.length; i++) {
    fill(colors[i]);
    text(text[i], accx, y);
    accx += textWidth(text[i]);
  }
}

color idToColor(String s) {
  switch (s) {
    case "S1": return unhex(hexcolors[0]);
    case "S2": return unhex(hexcolors[1]);
    case "P1": return unhex(hexcolors[2]);
    case "X1": return unhex(hexcolors[3]);
    case "X2": return unhex(hexcolors[4]);
    case "T1": return unhex(hexcolors[5]);
    default: return color(255);
  }
}

class Pattern {
  String unit;
  String[] basej;
  String[] basee;
  String[] genj;
  color[] basejc;
  color[] baseec;
  color[] genjc;
  Pattern(TableRow[] rows, String unit) {
    this.unit = unit;
    
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
      String s = rows[1].getString(i);
      if (s.isEmpty() || s.charAt(0) == 'X') {
        genj[i] = basej[i];
        continue;
      }
      genj[i] = rows[1].getString(i);
    }
    
    for (int i = 0; i < rows[1].getColumnCount(); i++) {
      basejc[i] = idToColor(rows[1].getString(i));
    }
    System.arraycopy(basejc, 0, genjc, 0, basejc.length);
    for (int i = 0; i < rows[3].getColumnCount(); i++) {
      String string = rows[3].getString(i);
      color c;
      if (string.length() == 0) {
        c = color(255);
      } else {
        c = basejc[string.charAt(0) - 65];
      }
      baseec[i] = c;
    }
    print();
  }
  
  void show() {
    prettyPrint(10, 50, new String[] {unit}, new color[] {color(255)});
    prettyPrint(10, 100, basej, basejc);
    prettyPrint(10, 150, basee, baseec);
    prettyPrint(10, 200, genj,  genjc);
  }
  
  String toString() {
    String result = "";
    for (String s : basej) result += s; result += "\n";
    for (String s : basee) result += s; result += "\n";
    for (String s : genj)  result += s; result += "\n";
    return result;
  }
}
