
import java.io.*;
import java.util.*;

public class MidiFile {

  static final int SEMIQUAVER = 4;
  static final int QUAVER = 8;
  static final int CROTCHET = 16;
  static final int MINIM = 32;
  static final int SEMIBREVE = 64;

  final int header[] = new int[] {
    0x4d, 0x54, 0x68, 0x64, 0x00, 0x00, 0x00, 0x06, 
    0x00, 0x00, 
    0x00, 0x01, 
    0x00, 0x10, 
    0x4d, 0x54, 0x72, 0x6B
  };

  final int footer[] = new int[]{
    0x01, 0xFF, 0x2F, 0x00
  };

  final int tempoEvent[] = new int[]{
    0x00, 0xFF, 0x51, 0x03, 
    0x0F, 0x42, 0x40
  };

  final int keySigEvent[] = new int[]{
    0x00, 0xFF, 0x59, 0x02, 
    0x00, 
    0x00
  };

  final int timeSigEvent[] = new int[]{
    0x00, 0xFF, 0x58, 0x04, 
    0x04, 
    0x02, 
    0x30, 
    0x08 
  };

  protected ArrayList playEvents;

  public MidiFile() {
    playEvents = new ArrayList();
  }

  public void writeToFile (String filename) throws IOException {
    FileOutputStream fos = new FileOutputStream (filename);

    fos.write (intArrayToByteArray (header));

    int size = tempoEvent.length + keySigEvent.length + timeSigEvent.length + footer.length;

    for (int i = 0; i < playEvents.size(); i++) size += ((int[])playEvents.get(i)).length;

    int high = size / 256;
    int low = size - (high * 256);
    fos.write ((byte) 0);
    fos.write ((byte) 0);
    fos.write ((byte) high);
    fos.write ((byte) low);

    fos.write (intArrayToByteArray (tempoEvent));
    fos.write (intArrayToByteArray (keySigEvent));
    fos.write (intArrayToByteArray (timeSigEvent));

    for (int i = 0; i < playEvents.size(); i++) {
      fos.write (intArrayToByteArray ((int[])playEvents.get(i)));
    }

    fos.write (intArrayToByteArray (footer));
    fos.close();
  }

  protected byte[] intArrayToByteArray (int[] ints) {
    int l = ints.length;
    byte[] out = new byte[ints.length];
    for (int i = 0; i < l; i++) {
      out[i] = (byte) ints[i];
    }
    return out;
  }

  public void noteOn (int delta, int note, int velocity) {
    int[] data = new int[4];
    data[0] = delta;
    data[1] = 0x90;
    data[2] = note;
    data[3] = velocity;
    playEvents.add (data);
  }

  public void noteOff (int delta, int note) {
    int[] data = new int[4];
    data[0] = delta;
    data[1] = 0x80;
    data[2] = note;
    data[3] = 0;
    playEvents.add (data);
  }

  public void progChange (int prog) {
    int[] data = new int[3];
    data[0] = 0;
    data[1] = 0xC0;
    data[2] = prog;
    playEvents.add (data);
  }

  public void noteOnOffNow (int duration, int note, int velocity) {
    noteOn (0, note, velocity);
    noteOff (duration, note);
  }

  public void noteSequenceFixedVelocity (int[] sequence, int velocity) {
    boolean lastWasRest = false;
    int restDelta = 0;
    for (int i = 0; i < sequence.length; i += 2) {
      int note = sequence[i];
      int duration = sequence[i + 1];
      if (note < 0) {
        restDelta += duration;
        lastWasRest = true;
      } else {
        if (lastWasRest) {
          noteOn (restDelta, note, velocity);
          noteOff (duration, note);
        } else {
          noteOn (0, note, velocity);
          noteOff (duration, note);
        }
        restDelta = 0;
        lastWasRest = false;
      }
    }
  }
}
