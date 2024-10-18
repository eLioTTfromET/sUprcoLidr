(
SynthDef("earth",{
	arg freq=7.83, amp=0.1;
	var sig;
	var trig = Dust.kr(10);
	var rand = TRand.kr(freq * -0.01, freq * 0.01, trig);
	sig=SinOsc.ar(freq:[freq+rand,freq+rand*2,freq+rand*3,freq+rand*4],mul:[amp,amp/2,amp/4,amp/8]);
	sig=Mix.ar(sig);
	sig=Splay.ar(sig);
	Out.ar(0,sig);
}).add; // use "add" instead of play
)

(
a = Synth("earth",[\freq,7.83*15]);
b = Synth("earth",[\freq,7.83*16]);
c = Synth("earth",[\freq,7.83*18]);
d = Synth("earth",[\freq,7.83*19]);
e = Synth("earth",[\freq,7.83*21]);
f = Synth("earth",[\freq,7.83*24]);
)

(
Routine({
    loop({
        Synth.new("earth"); 0.5.wait;
    })
}).play;
)

(
SynthDef("help-Rand", { arg out=0;
    Out.ar(out,
        FSinOsc.ar(
            Rand(200.0, 400.0),
            0, Line.kr(0.2, 0, 1, doneAction: Done.freeSelf))
    )
}).add;
)

(
Routine({
    8.do({
        Synth.new("help-Rand"); 0.1.wait;
    })
}).play;
)

(
SynthDef("help-LinRand", { arg out=0, minmax=1;
    Out.ar(out,
        FSinOsc.ar(
            LinRand(200.0, 10000.0, minmax),
            0, Line.kr(0.2, 0, 0.01, doneAction: Done.freeSelf))
    )
}).add;
)

/////////////////////////////////////////////////////////////////////////////////

(
SynthDef("earth", {
	arg freq=7.83*20, amp=0.1, lagTime = 1.0; // added lagTime argument to control ramp duration
	var sig, trig, rand, freqOffset;

	// Trigger at random intervals
	trig = Dust.kr(10);

	// Random value generator with a trigger, but use Lag to create smooth transitions
	rand = TRand.kr(freq * -0.01, freq * 0.01, trig);
	freqOffset = Lag.kr(rand, lagTime); // Smooth the random value change over 'lagTime'

	// The frequency modulated by random offset with smooth transitions
	freq = freq + freqOffset;

	// Generate the signal with varying frequencies
	sig = SinOsc.ar(
		freq: [freq + freqOffset, freq + freqOffset * 2, freq + freqOffset * 3, freq + freqOffset * 4],
		mul: [amp, amp / 2, amp / 4, amp / 8]
	);
	sig = Mix.ar(sig);
	sig = Splay.ar(sig);

	// Output the sound
	Out.ar(0, sig);
}).add; // use "add" instead of play for flexibility
)

// Now you can play the synth with optional control over ramp time
Synth("earth", [\lagTime, 0.1]);  // Ramp time is 2 seconds
