
int nbBeats = 1024;
int nbInstr = 4;
int nbPTotalNotes=128;
int nbPNotes = 12;// C C# D D# E F F# G G# A A# B
int nbPModes = 2;// Major Minor
int nbPDegrees = 7;// I II III IV V VI VII
int[][] notes = new int[nbBeats][nbInstr];
Tonality[] tonality = new Tonality[nbBeats];
Instrument[] instruments = new Instrument[nbInstr];
int[] degree = new int[nbBeats];
int[][] forceNotes = new int[nbBeats][nbInstr];
// TODO make smaller divisions and make incoming beats an array of possible notes, then define the real note among them
int startingCommonNotesRequired;
int[] dOrder = {// degree importance order
  6, 2, 5, 1, 3, 4, 0
};
// TODO prepare interface for parameters, forced notes, custom tonality/degrees, separate tonality/notes/subdivisions generation

int randomInstr = floor(random(4));// <- testing purpose

class Tonality {
  boolean[] notes;
  int base;
  int mode;
  Tonality() {
    notes = new boolean[nbPNotes];
    for (int b=0; b<nbPNotes; b++) notes[b]=false;
    base = -1;
    mode = -1;
  }
  Tonality(Tonality other) {
    this.notes=other.notes;
    this.base=other.base;
    this.mode=other.mode;
  }
  Tonality(boolean[] notes, int base, int mode) {
    this.notes=notes;
    this.base=base;
    this.mode=mode;
  }
  String toText() {
    int t2=0;
    for (int i=0; i<nbPNotes; i++) t2+=notes[i]?pow(2, i):0;
    if (t2==2741) return "C M";
    if (t2==1387) return "C#M";
    if (t2==2774) return "D M";
    if (t2==1453) return "D#M";
    if (t2==2906) return "E M";
    if (t2==1717) return "F M";
    if (t2==3434) return "F#M";
    if (t2==2773) return "G M";
    if (t2==1451) return "G#M";
    if (t2==2902) return "A M";
    if (t2==1709) return "A#M";
    if (t2==3418) return "B M";
    if (t2==2477) return "C m";
    if (t2== 859) return "C#m";
    if (t2==1718) return "D m";
    if (t2==3436) return "D#m";
    if (t2==2777) return "E m";
    if (t2==1459) return "F m";
    if (t2==2918) return "F#m";
    if (t2==1741) return "G m";
    if (t2==3482) return "G#m";
    if (t2==2869) return "A m";
    if (t2==1643) return "A#m";
    if (t2==3286) return "B m";
    return "   ";
  }
  boolean[] getChordForDegree(int d) {
    boolean[] result = new boolean[nbPNotes];
    for (int i=0; i<nbPNotes; i++) result[i]=false;
    if (base==-1||mode==-1) return result;
    result[getNoteNumber(d)]=true;
    result[getNoteNumber(d+2)]=true;
    result[getNoteNumber(d+4)]=true;
    if (d+1==5) result[getNoteNumber(d+6)]=true;
    return result;
  }
  int getNoteNumber(int i) {
    if (base==-1||mode==-1) return -1;
    int currentNote = base%nbPNotes;
    while (i>0) {
      currentNote=(currentNote+1)%nbPNotes;
      if (notes[currentNote]) i--;
    }
    return currentNote;
  }
}

void setup() {
  size(200, 200);
  // define instruments
  instruments[0] = new Instrument(24, 70, 12);// cello
  instruments[1] = new Instrument(36, 75, 19);// viola
  instruments[2] = new Instrument(43, 93, 12);// violin
  instruments[3] = new Instrument(43, 93, 12);// violin
  /*
   instruments[0] = new Instrument(10, 50, 24);
   instruments[1] = new Instrument(20, 60, 19);
   instruments[2] = new Instrument(30, 70, 12);
   instruments[3] = new Instrument(35, 75, 10);
   instruments[4] = new Instrument(40, 80, 7);
   instruments[5] = new Instrument(45, 85, 6);
   */
  // for (int j=0; j<nbInstr; j++) instruments[j] = new Instrument(20+j*7, 30+j*7, 20-j*2);
  // define starting notes
  for (int i=0; i<nbBeats; i++) {
    tonality[i] = new Tonality();
    for (int j=0; j<nbInstr; j++) {
      forceNotes[i][j]=-1;
    }
    // TEST
    /*
    if (random(10)<1) randomInstr = floor(random(nbInstr));
     int lastForcedNote=-1;
     for (int i2=i-1; i2>=0; i2--) {
     if (forceNotes[i2][randomInstr]!=-1) {
     lastForcedNote=forceNotes[i2][randomInstr];
     break;
     }
     }
     forceNotes[i][randomInstr] = (i==0||lastForcedNote==-1)?floor((instruments[randomInstr].lowestNoteIncl+instruments[randomInstr].highestNoteExcl)/2):constrain(floor(lastForcedNote+random(-4, 4)), instruments[randomInstr].lowestNoteIncl, instruments[randomInstr].highestNoteExcl);
     */
  }
  for (int i=0; i<nbBeats; i++) {
    for (int j=0; j<nbInstr; j++) {
      if (random(8)<1) forceNotes[i][j] = floor((instruments[randomInstr].lowestNoteIncl+instruments[randomInstr].highestNoteExcl)/2+random(random(-12, 12)));
    }
  }
  // TEST
  /*
  forceNotes[0][3] = 1+48+12;
   forceNotes[1][3] = 1+48+12;
   forceNotes[2][3] = 1+48+12;
   forceNotes[3][3] = 1+48+12;
   forceNotes[4][3] = 1+48+12;
   forceNotes[5][3] = 1+48+12;
   forceNotes[6][3] = 4+48+12;
   forceNotes[7][3] = 4+48+12;
   forceNotes[8][3] = 3+48+12;
   forceNotes[9][3] = 3+48+12;
   forceNotes[10][3] = 3+48+12;
   forceNotes[11][3] = 3+48+12;
   forceNotes[12][3] = 3+48+12;
   forceNotes[13][3] = 3+48+12;
   forceNotes[14][3] = 6+48+12;
   forceNotes[15][3] = 6+48+12;
   forceNotes[16][3] = 2+48+12;
   forceNotes[17][3] = 2+48+12;
   forceNotes[18][3] = 4+48+12;
   forceNotes[19][3] = 2+48+12;
   forceNotes[20][3] = 0+48+12;
   forceNotes[21][3] = 0+48+12;
   forceNotes[22][3] = -1+48+12;
   forceNotes[23][3] = -1+48+12;
   forceNotes[24][3] = -1+48+12;
   forceNotes[25][3] = -1+48+12;
   forceNotes[26][3] = -3+48+12;
   forceNotes[27][3] = -3+48+12;
   forceNotes[28][3] = -3+48+12;
   forceNotes[29][3] = -3+48+12;
   forceNotes[30][3] = -1+48+12;
   forceNotes[31][3] = -1+48+12;
   forceNotes[32][3] = 1+48+12;
   forceNotes[33][3] = 1+48+12;
   forceNotes[34][3] = 1+48+12;
   forceNotes[35][3] = 1+48+12;
   forceNotes[36][3] = 1+48+12;
   forceNotes[37][3] = 1+48+12;
   forceNotes[38][3] = 4+48+12;
   forceNotes[39][3] = 4+48+12;
   forceNotes[40][3] = 3+48+12;
   forceNotes[41][3] = 3+48+12;
   forceNotes[42][3] = 3+48+12;
   forceNotes[43][3] = 3+48+12;
   forceNotes[44][3] = 3+48+12;
   forceNotes[45][3] = 3+48+12;
   forceNotes[46][3] = 6+48+12;
   forceNotes[47][3] = 6+48+12;
   forceNotes[48][3] = 6+48+12;
   forceNotes[49][3] = 6+48+12;
   forceNotes[50][3] = 6+48+12;
   forceNotes[51][3] = 4+48+12;
   forceNotes[52][3] = 6+48+12;
   forceNotes[53][3] = 6+48+12;
   forceNotes[54][3] = 4+48+12;
   forceNotes[55][3] = 4+48+12;
   forceNotes[56][3] = 4+48+12;
   forceNotes[57][3] = 4+48+12;
   forceNotes[58][3] = 4+48+12;
   forceNotes[59][3] = 4+48+12;
   forceNotes[60][3] = 2+48+12;
   forceNotes[61][3] = 2+48+12;
   forceNotes[62][3] = 2+48+12;
   forceNotes[63][3] = 2+48+12;
   */
  for (int i=0; i<nbBeats; i++) {
    for (int j=0; j<nbInstr; j++) {
      notes[i][j] = forceNotes[i][j];
    }
  }
  // define tonalities
  int commonNotesRequired = startingCommonNotesRequired;  
  int toBeDefined = -1;// beats to be defined
  while (toBeDefined!=0) {
    int bestStart=-1;
    int bestEnd=-1;
    int bestDegreeScore=-1;
    Tonality bestTonality = new Tonality();
    boolean solutionFound = false;
    // go through all existing tonalities
    for (int tonalityIndex = 0; tonalityIndex < nbPNotes*nbPModes; tonalityIndex++) {
      Tonality thisTonality = generateTonality(tonalityIndex%nbPNotes, floor(tonalityIndex/nbPNotes));
      // for this tonality search for the longest run
      int thisBestStart = -1;
      int thisBestEnd = -1;   
      int thisStart=-1;
      for (int b=0; b<nbBeats+1; b++) {
        if (thisStart==-1) thisStart=b;
        boolean goOn = true;
        if (b==nbBeats) {// if this was the last beat
          goOn = false;
        } else {
          // don't go on if this beat is already defined
          goOn &= (tonality[b].base==-1);
          // don't go on if tonality does not match
          goOn &= checkPoolMatch(thisTonality.notes, notes[b]);
          // don't go on if a melodic movement is required but not there (leading -> tonic on the soprano)
          if (notes[b][nbInstr-1]%nbPNotes==thisTonality.getNoteNumber(6)) {
            if (b<nbBeats-1) goOn &= (notes[b+1][nbInstr-1]%nbPNotes==thisTonality.getNoteNumber(0));
          }
          // check that a new tonality is introduced by notes that allow V
          if (thisStart==b && b>0) goOn &= checkPoolMatch(thisTonality.getChordForDegree(4), notes[b]);
        }
        if (!goOn) {
          // update the solution if this one is best and the length is not zero
          if ((thisBestEnd-thisBestStart)<=(b-thisStart)&&(b-thisStart)>0) {
            // but first check te number of common notes with the surroundings
            boolean enoughCommonNotes=true;
            if (thisStart>0) if (tonality[thisStart-1].base!=-1) if (commonNotes(thisTonality.notes, tonality[thisStart-1].notes)<commonNotesRequired) enoughCommonNotes=false;
            if (b<nbBeats-1) if (tonality[b+1].base!=-1) if (commonNotes(thisTonality.notes, tonality[b+1].notes)<commonNotesRequired) enoughCommonNotes=false;
            if (enoughCommonNotes) {
              thisBestStart=thisStart;
              thisBestEnd=b;
              solutionFound = true;
            }
          }
          // try a new start
          thisStart=-1;
        }
        // compute a score based on degrees
      }
      int thisDegreeScore=0;      
      for (int b=thisBestStart; b<thisBestEnd; b++) {
        for (int i=0; i<nbInstr; i++) {          
          if (forceNotes[b][i]!=-1) {
            for (int j=0; j<dOrder.length; j++) {
              if (forceNotes[b][i]%nbPNotes==thisTonality.getNoteNumber(dOrder[j])) thisDegreeScore+=j+1;
            }
          }
        }
      }
      // keep the best tonality and position
      if ((bestEnd-bestStart)<(thisBestEnd-thisBestStart)) {
        bestStart=thisBestStart;
        bestEnd=thisBestEnd;
        bestTonality=thisTonality;
        bestDegreeScore=thisDegreeScore;
      } else if ((bestEnd-bestStart)==(thisBestEnd-thisBestStart)) {
        if (thisDegreeScore>=bestDegreeScore) {
          bestStart=thisBestStart;
          bestEnd=thisBestEnd;
          bestTonality=thisTonality;
          bestDegreeScore=thisDegreeScore;
        }
      }
    }
    // apply the defined tonality
    if (solutionFound) {      
      for (int b=bestStart; b<bestEnd; b++) {
        for (int i=0; i<nbPNotes; i++) {
          tonality[b] = new Tonality(bestTonality);
        }
      }
    }
    // update toBeDefined
    toBeDefined=0;
    for (int b=0; b<nbBeats; b++) if (tonality[b].base==-1) toBeDefined++;
    // if no other solution available allow for more tonal jumps then go anyway
    if (!solutionFound) {
      if (commonNotesRequired>0) commonNotesRequired--;
      else toBeDefined=0;
    }
  }
  // TODO try to replace tonalities by other that better match their neighbors
  // find matching degrees
  for (int b=0; b<nbBeats; b++) {
    degree[b]=-1;
    boolean[] availableDegrees = new boolean[nbPDegrees];
    for (int d=0; d<nbPDegrees; d++) {
      availableDegrees[d]=false;
      boolean[] theseNotes = tonality[b].getChordForDegree(d);
      if (checkPoolMatch(theseNotes, notes[b])) availableDegrees[d]=true;
    }
    // check that the lowest note is matching
    int lowestNote=-1;
    for (int i=0; i<nbInstr; i++) if (lowestNote==-1||(notes[b][i]<lowestNote&&notes[b][i]!=-1)) lowestNote = notes[b][i];
    // if the lowest instrument isn't defined, consider the lowest note isn't defined
    if (notes[b][0]==-1) lowestNote=-1;
    if (lowestNote!=-1) {
      for (int i=0; i<nbPDegrees; i++) {
        if (availableDegrees[i]) {
          boolean matchingStatusFound = false;
          if (lowestNote%nbPNotes==tonality[b].getNoteNumber(i)) matchingStatusFound=true;
          if (lowestNote%nbPNotes==tonality[b].getNoteNumber(i+2)) matchingStatusFound=true;
          if (!matchingStatusFound) availableDegrees[i] = false;
        }
      }
    }
    // select the most common degree
    for (int d=0; d<nbPDegrees; d++) {
      degree[b] = (availableDegrees[dOrder[d]])?dOrder[d]:degree[b];
    }
    if (b>0) {
      // if the tonality changes 
      if (!tonality[b].toText().equals(tonality[b-1].toText())) {// TODO optimize this
        if (availableDegrees[4]) degree[b]=4;// put V if forced notes match
      }
    }
    // TODO favor degree change if tonality and forced notes stay static
    // TODO ban configuration if the bass does not fit with the first drop of this degree
  }
  // TODO make separate reusable functions for bans, and use them one after each other while there is still some possible chords
  for (int b=0; b<nbBeats; b++) {// for each beat
    println("generating chords for beat "+b);
    // define all possible combinations of notes
    ArrayList<int[]> possibleChords = new ArrayList<int[]>();
    int[] chordModel = new int[nbInstr];
    for (int i=0; i<chordModel.length; i++) chordModel[i]=-1;
    fillWithAllPossibleChords(possibleChords, chordModel, instruments, forceNotes[b]);
    println("there are "+possibleChords.size()+" possible combinations of notes");
    int[] causeForChordBanning = new int[9];// log causes for wrong chords for debugging purposes
    String[] banningCauseStr = {
      "large interval", 
      "wrong bass", 
      "#9", 
      "harmonic limit", 
      "no fundamental", 
      "parallel 5th/8ve", 
      "direct movements", 
      "unresolved leading note", 
      "notes outside of the tonality"
    };
    for (int i=0; i<causeForChordBanning.length; i++) causeForChordBanning[i]=0;        
    for (int c=0; c<possibleChords.size (); c++) {
      boolean allow = true;
      // ban if one of the intervals is too large
      for (int i=1; i<nbInstr; i++) {
        if (possibleChords.get(c)[i]-possibleChords.get(c)[i-1]>instruments[i].maxInterval) {
          allow=false;
          causeForChordBanning[0]++;
        }
      }
      // ban if the bass does not fit with the degree or the first drop
      if (forceNotes[b][0]==-1) {// if the bass isn't forced
        if (possibleChords.get(c)[0]%nbPNotes!=tonality[b].getNoteNumber(degree[b]) && possibleChords.get(c)[0]%nbPNotes!=tonality[b].getNoteNumber(degree[b]+2)) {
          allow=false;
          causeForChordBanning[1]++;
        }
      }
      for (int i=0; i<nbInstr-1; i++) {
        for (int j=i+1; j<nbInstr; j++) {
          // ban if there is a #9 or positive drop of it somewhere
          int thisInterval = abs(possibleChords.get(c)[j]-possibleChords.get(c)[i]);
          if (thisInterval%nbPNotes==1&&thisInterval>1) {
            allow=false;
            causeForChordBanning[2]++;
          }
        }
      }
      for (int i=1; i<nbInstr; i++) {
        // admit low notes only if they that have a strong harmonic relation with the bass (below A2=33 if 7 or 12)
        if (possibleChords.get(c)[i]<33) {
          int thisBassInterval = possibleChords.get(c)[i]-possibleChords.get(c)[0];
          if (thisBassInterval%nbPNotes!=0&&thisBassInterval%nbPNotes!=7) {
            allow=false;
            causeForChordBanning[3]++;
          }
        }
      }
      // ban if no fundamental
      boolean fundamentalFound = false;
      for (int i=1; i<nbInstr; i++) if (possibleChords.get(c)[i]%nbPNotes==tonality[b].getNoteNumber(degree[b])) fundamentalFound = true; 
      if (!fundamentalFound) {
        allow=false;
        causeForChordBanning[4]++;
      }
      if (b>0) {
        // check the relation with the previous chord
        for (int i=0; i<nbInstr-1; i++) {
          for (int j=i+1; j<nbInstr; j++) {
            if (notes[b-1][i]!=-1&&notes[b-1][j]!=-1) {
              int thisInterval = possibleChords.get(c)[j]-possibleChords.get(c)[i];
              if (thisInterval%nbPNotes==0||thisInterval%nbPNotes==7) {// if this interval is a drop of a 5th or 8ve
                if (notes[b-1][j]!=possibleChords.get(c)[j] && (notes[b-1][j]-notes[b-1][i])==thisInterval) {// ban if parallel 5th or 8ves
                  allow=false;
                  causeForChordBanning[5]++;
                }
                // check direct movement
                if (i==0&&j==nbInstr-1) {// if bass and soprano
                  if (degree[b]==0||degree[b]==3||degree[b]==4) {// if strong degree
                    if (abs(notes[b-1][i]-possibleChords.get(c)[i])>2&&abs(notes[b-1][j]-possibleChords.get(c)[j])>2) {// ban if the bass is disjoint and the soprano is disjoint
                      allow=false;
                      causeForChordBanning[6]++;
                    }
                  } else {// if weak degree
                    if (abs(notes[b-1][j]-possibleChords.get(c)[j])>2) {// ban if the soprano is disjoint
                      allow=false;
                      causeForChordBanning[6]++;
                    }
                  }
                } else {// if other than bass and soprano
                  if (abs(notes[b-1][i]-possibleChords.get(c)[i])>2&&abs(notes[b-1][j]-possibleChords.get(c)[j])>2) {// ban if both instruments are disjoint
                    allow=false;
                    causeForChordBanning[6]++;
                  }
                }
              }
            }
          }
        }
        // if the previous soprano was a leading tone
        if (notes[b-1][nbInstr-1]%nbPNotes==tonality[b].getNoteNumber(6)) {
          // ban if it doesn't lead to the tonic
          if (possibleChords.get(c)[nbInstr-1]%nbPNotes!=tonality[b].getNoteNumber(0)||abs(notes[b-1][nbInstr-1]-possibleChords.get(c)[nbInstr-1])>1) {
            allow=false;
            causeForChordBanning[7]++;
          }
        }
      }
      // ban if notes don't belong to the tonality
      for (int i=0; i<nbInstr; i++) {
        if (!tonality[b].notes[possibleChords.get(c)[i]%nbPNotes]) {
          allow=false;
          causeForChordBanning[8]++;
        }
      }
      if (!allow) {
        possibleChords.remove(c);
        c--;
      }
    }
    println("after banning forbidden chords, "+possibleChords.size()+" of them remain");
    int[] scores = new int[possibleChords.size()];
    for (int c=0; c<possibleChords.size (); c++) {
      // compute a score for a given chord
      scores[c]=0;
      // higher ranking if notes are common for this chord
      for (int i=0; i<nbInstr; i++) {
        // check common chord notes for this degree
        // TODO add less common notes as well 
        if (tonality[b].getChordForDegree(degree[b])[possibleChords.get(c)[i]%nbPNotes]) scores[c]+=5;// TODO tweak value
        else scores[c]-=5;
      }
      // lower ranking if duplicate notes
      for (int i=0; i<nbInstr-1; i++) {
        for (int j=i+1; j<nbInstr; j++) {
          if (possibleChords.get(c)[i]%nbPNotes==possibleChords.get(c)[j]%nbPNotes) scores[c]-=3;
        }
      }
      // lower ranking if very small top interval
      if (abs(possibleChords.get(c)[nbInstr-1]-possibleChords.get(c)[nbInstr-2])<2) scores[c]--;
      if (abs(possibleChords.get(c)[nbInstr-1]-possibleChords.get(c)[nbInstr-2])<3) scores[c]--;
      // after first chord 
      if (b>0) {
        // higher ranking if smooth melodic contour
        for (int i=0; i<nbInstr-1; i++) {
          scores[c] -= ceil((float)abs(possibleChords.get(c)[i]-notes[b-1][i])/5);// TODO tweak division
        }
        // favor other drops if the tonality is static
        if (tonality[b-1].mode==tonality[b].mode) {
          for (int i=0; i<nbInstr; i++) {
            if (notes[b-1][i]!=possibleChords.get(c)[i]) scores[c]++;
            else scores[c]--;
          }
        }
        // lower ranking if leading !-> tonic
        for (int i=0; i<nbInstr; i++) {
          if (notes[b-1][i]%nbPNotes==tonality[b].getNoteNumber(6) && possibleChords.get(c)[i]%nbPNotes!=tonality[b].getNoteNumber(0)) scores[c]-=5;// TODO tweak value
        }
      }
      // higher ranking if higher intervals
      for (int i=0; i<nbInstr-1; i++) {
        for (int j=i+1; j<nbInstr; j++) {
          scores[c] += floor((float)(possibleChords.get(c)[j]-possibleChords.get(c)[i])/4);// TODO tweak division
        }
      }
      // TODO lower ranking if wrong notes are duplicated
      // TODO lower ranking if no 3rd in the chord      
      // TODO favor notes that have not been seen much so far in the song
      // TODO higher ranking if the bass makes a nice drop (fundamental or first)
      // TODO favor inverse melodic contours bewteen voices
      // TODO si Ve degré, vérifier où va la tierce et la septième
    }
    // increase all the scores to at least a 0 value
    int lowestScore = 0;
    for (int i=0; i<scores.length; i++) lowestScore = min(scores[i], lowestScore);
    for (int i=0; i<scores.length; i++) scores[i] -= lowestScore;    
    // choose the chord with highest score
    int chosenChord = -1;
    int bestScore = -1;
    for (int c=0; c<possibleChords.size (); c++) {
      if (scores[c]>bestScore) {
        chosenChord=c;
        bestScore=scores[c];
      }
    }
    for (int j=0; j<nbInstr; j++) {
      if (chosenChord>=0) notes[b][j] = possibleChords.get(chosenChord)[j];
    }
    for (int i=0; i<causeForChordBanning.length; i++) println("banning for cause "+i+" : "+causeForChordBanning[i]+" ("+banningCauseStr[i]+")");
  }
  // TODO add more subdivisions, then nonchord notes and try to justify them
  // export text file
  String[] textExp = new String[nbInstr+2];
  for (int j=0; j<nbInstr; j++) {
    textExp[nbInstr-(j+1)] = "";
    for (int i=0; i<nbBeats; i++) {
      String txtNote ="";
      txtNote += noteToText(notes[i][j]);
      if (notes[i][j]==-1) txtNote+="___";
      textExp[nbInstr-(j+1)] += txtNote + "("+notes[i][j]+")"+" | ";
    }
  }
  textExp[nbInstr] = "";
  for (int i=0; i<nbBeats; i++) {
    String thisT = tonality[i].toText();
    textExp[nbInstr] += thisT + " | ";
  }
  textExp[nbInstr+1] = "";
  for (int i=0; i<nbBeats; i++) {
    textExp[nbInstr+1] += nf(degree[i]+1, 3) + " | ";
  }
  for (int i=0; i<textExp.length; i++) println(textExp[i]);
  saveStrings("textExp.txt", textExp);
  // export midi file
  // requires a copyrighted piece of code, not included in repository
  // if that part doesn't work, comment from here --------------------
  MidiFile mf = new MidiFile();
  mf.progChange(48);
  for (int i=0; i<nbBeats; i++) {
    int notesInChord=0;
    for (int j=0; j<nbInstr; j++) {
      if (notes[i][j]!=-1) {
        notesInChord++;
        mf.noteOn (notesInChord==1?1:0, notes[i][j]+12, 80);
      }
    }
    notesInChord=0;
    int noteTime = floor(pow(2, floor(4+random(-3, 2)))+(floor(random(random(2)))*4)-1);// TODO this is now here for fun only
    for (int j=0; j<nbInstr; j++) {
      if (notes[i][j]!=-1) {
        notesInChord++;
        mf.noteOff (notesInChord==1?noteTime:0, notes[i][j]+12);
      }
    }
  }
  try {
    mf.writeToFile(dataPath("../result.mid"));
  } 
  catch (Exception e) {
    println(e.toString());
  }
  // to here --------------------------------------------------------
}

class Instrument {
  int lowestNoteIncl;
  int highestNoteExcl;
  int maxInterval;
  Instrument(int low, int high, int maxI) {
    this.lowestNoteIncl = low;
    this.highestNoteExcl = high;
    this.maxInterval = maxI;
  }
}

Tonality generateTonality(int note, int mode) {
  boolean[] tonality = new boolean[nbPNotes];
  boolean[] modeNotes = new boolean[nbPNotes];
  for (int i=0; i<nbPNotes; i++) {
    if (mode==0) modeNotes[i] = (i==0||i==2||i==4||i==5||i==7||i==9||i==11);
    if (mode==1) modeNotes[i] = (i==0||i==2||i==3||i==5||i==7||i==8||i==11);
  }
  for (int i=0; i<nbPNotes; i++) {
    tonality[i] = modeNotes[(i-note+nbPNotes)%nbPNotes];
  }
  return new Tonality(tonality, note, mode);
}

boolean checkPoolMatch(boolean[] pool, int[] notes) {
  // return true if the notes belong to the pool
  boolean result = true;
  for (int i=0; i<notes.length; i++) {
    if (notes[i]!=-1) result &= pool[notes[i]%nbPNotes];
  }
  return result;
}

int commonNotes(boolean[] a, boolean[] b) {
  int result=0;
  for (int i=0; i<min (a.length, b.length); i++) if (a[i]&&b[i]) result++;
  return result;
}

String noteToText(int n) {
  n-=12;
  if (n%nbPNotes==0) return "C "+floor(n/12);
  if (n%nbPNotes==1) return "C#"+floor(n/12);
  if (n%nbPNotes==2) return "D "+floor(n/12);
  if (n%nbPNotes==3) return "D#"+floor(n/12);
  if (n%nbPNotes==4) return "E "+floor(n/12);
  if (n%nbPNotes==5) return "F "+floor(n/12);
  if (n%nbPNotes==6) return "F#"+floor(n/12);
  if (n%nbPNotes==7) return "G "+floor(n/12);
  if (n%nbPNotes==8) return "G#"+floor(n/12);
  if (n%nbPNotes==9) return "A "+floor(n/12);
  if (n%nbPNotes==10) return "A#"+floor(n/12);
  if (n%nbPNotes==11) return "B "+floor(n/12);
  return "";
}

void fillWithAllPossibleChords(ArrayList<int[]> possibleChords, int[] currentChord, Instrument[] instruments, int[] forceNotes) {
  int thisInstrument=-1;
  for (int i=0; i<currentChord.length && thisInstrument==-1; i++) if (currentChord[i]==-1) thisInstrument=i;
  int lowestNote=instruments[thisInstrument].lowestNoteIncl;
  int highestNote=min(instruments[thisInstrument].highestNoteExcl, nbPTotalNotes);
  if (thisInstrument>0) {
    lowestNote = max(lowestNote, currentChord[thisInstrument-1]+1);
    highestNote = min(highestNote, currentChord[thisInstrument-1]+instruments[thisInstrument].maxInterval+1);
  }
  if (forceNotes[thisInstrument]!=-1) {
    lowestNote = max(lowestNote, forceNotes[thisInstrument]);
    highestNote = min(highestNote, forceNotes[thisInstrument]+1);
  }
  for (int n=lowestNote; n<highestNote; n++) {
    currentChord[thisInstrument]=n;
    int[] chordModel = new int[currentChord.length];
    for (int i=0; i<chordModel.length; i++) chordModel[i]=currentChord[i];
    if (thisInstrument<currentChord.length-1) {
      fillWithAllPossibleChords(possibleChords, chordModel, instruments, forceNotes);
    } else {
      possibleChords.add(chordModel);
    }
  }
}
