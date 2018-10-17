package dfpwm

import (
	"bufio"
	"errors"
	"io"

	"github.com/1lann/dissonance/audio"
)

// SampleRate is the expected sample rate used by DFPWM.
const SampleRate = 14110 //48000

const (
	respPrec    = 10
	lpfStrength = 140
)

func iterate(bit, lastBit bool, level, response int) (int, int) {
	target := -128
	if bit {
		target = 127
	}

	lastLevel := level
	level = level + ((response*(target-level) +
		(1 << (respPrec - 1))) >> respPrec)
	if level == lastLevel && lastLevel != target {
		if bit {
			level++
		} else {
			level--
		}
	}

	var rTarget int
	if bit == lastBit {
		rTarget = (1 << respPrec) - 1
	} else {
		rTarget = 0
	}

	if response != rTarget {
		if bit == lastBit {
			response++
		} else {
			response--
		}
	}

	if response < (2 << (respPrec - 8)) {
		response = (2 << (respPrec - 8))
	}

	return level, response
}

// Decoder represents a DFPWM decoder.
type Decoder struct {
	sampleRate int
	reader     io.Reader
	response   int
	level      int
	flast      int
	lpf        int
	lastBit    bool
	buffer     []int8
}

// NewDecoder returns a DFPWM decoder that is an audio.Stream.
func NewDecoder(input io.Reader, sampleRate int) audio.Stream {
	d := &Decoder{
		sampleRate: sampleRate,
		reader:     input,
	}

	return d
}

func (d *Decoder) decompress(compressed []byte) []int8 {
	decomp := make([]int8, len(compressed)*8)
	for c, val := range compressed {
		for i := 0; i < 8; i++ {
			bit := val&1 != 0
			val >>= 1
			d.level, d.response, d.flast, d.lpf = decompress(bit,
				d.lastBit, d.level, d.response, d.flast, d.lpf)
			d.lastBit = bit
			decomp[c*8+i] = int8(d.lpf)
		}
	}

	return decomp
}

func (d *Decoder) Read(dst interface{}) (int, error) {
	length := audio.SliceLength(dst)

	if len(d.buffer) < length {
		size := (length - len(d.buffer)/8) + 1
		result := make([]byte, size)
		n, err := io.ReadFull(d.reader, result)
		if n == 0 {
			return 0, err
		}

		data := d.decompress(result[:n])

		d.buffer = append(d.buffer, data...)

		if len(d.buffer) < length {
			if len(d.buffer) == 0 {
				return 0, io.EOF
			}

			copied := len(d.buffer)
			audio.ReadFromInt8(dst, d.buffer, copied)
			d.buffer = nil
			return copied, nil
		}
	}

	audio.ReadFromInt8(dst, d.buffer, length)
	d.buffer = d.buffer[length:]
	return length, nil
}

// SampleRate returns the sample rate of the stream.
func (d *Decoder) SampleRate() int {
	return d.sampleRate
}

// EncodeDFPWM encodes the given stream into output using DFPWM.
func EncodeDFPWM(output io.Writer, stream audio.Stream) error {
	if stream.SampleRate() != SampleRate {
		return errors.New("dfpwm: sample rate must be 48000 Hz")
	}

	response := 0
	level := 0
	lastBit := false

	input := make([]int8, 8)
	w := bufio.NewWriter(output)
	defer w.Flush()

	for {
		count := 0
		for count < 8 {
			n, err := stream.Read(input[count:])
			if err == io.EOF {
				return nil
			} else if err != nil {
				return err
			}
			count += n
		}

		var b byte

		for _, in := range input {
			bit := int(in) > level || (int(in) == level && level == 127)
			b >>= 1
			if bit {
				b += 128
			}
			level, response = iterate(bit, lastBit, level, response)
			lastBit = bit
		}

		w.WriteByte(b)
	}
}

func abs(a int) int {
	if a < 0 {
		return a * -1
	}
	return a
}

func findBest(original []int8, current []bool, sum int, lastBit bool,
	level, response, flast, lpf int) ([]bool, int) {
	if len(original) == 0 {
		return current, sum
	}

	tLevel, tResponse, tFlast, tLpf := decompress(true,
		lastBit, level, response, flast, lpf)
	fLevel, fResponse, fFlast, fLpf := decompress(false,
		lastBit, level, response, flast, lpf)

	dTrue := abs(int(original[0]) - int(int8(tLpf)))
	dFalse := abs(int(original[0]) - int(int8(fLpf)))

	tSum := sum + dTrue*dTrue
	fSum := sum + dFalse*dFalse

	tCurrent := make([]bool, len(current)+1)
	fCurrent := make([]bool, len(current)+1)
	copy(tCurrent, current)
	copy(fCurrent, current)
	tCurrent[len(current)] = true
	fCurrent[len(current)] = false

	tResult, tResultSum := findBest(original[1:], tCurrent, tSum, true, tLevel, tResponse, tFlast, tLpf)
	fResult, fResultSum := findBest(original[1:], fCurrent, fSum, false, fLevel, fResponse, fFlast, fLpf)

	if tResultSum > fResultSum {
		return fResult, fResultSum
	}

	return tResult, tResultSum
}

func decompress(bit, lastBit bool, level, response, flast, lpf int) (int, int, int, int) {
	level, response = iterate(bit, lastBit, level, response)

	blevel := int8(byte(level))
	if bit != lastBit {
		blevel = int8(byte((flast + level + 1) >> 1))
	}
	flast = level

	lpf += ((lpfStrength*(int(blevel)-lpf) + 0x80) >> 8)
	return level, response, flast, lpf
}
