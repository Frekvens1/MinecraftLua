package main

import (
	"fmt"
	"io"
	"os"

	"github.com/1lann/dissonance/ffmpeg"
	"github.com/Frekvens1/MinecraftLua/Computronics/Golang/dfpwm"
)

func main() {
	if len(os.Args) < 2 {
		fmt.Println("You must specify a file to read from")
		os.Exit(1)
	}

	stream, err := ffmpeg.NewFFMPEGStreamFromFile(os.Args[1], false)
	if err != nil {
		panic(err)
	}

	rd, wr := io.Pipe()

	go func() {
		dfpwm.EncodeDFPWM(wr, stream)
		wr.Close()
	}()
	//dec := dfpwm.NewDecoder(rd, 48000)

	 file, err := os.Create("./output.dfpwm")
	 if err != nil {
	 	panic(err)
	 }
	 defer file.Close()
	
	if rd != nil {
		//Do nothing, not sure what 'rd / wr' actually does	
	}

	 fmt.Println(dfpwm.EncodeDFPWM(file, stream))

	 file, err = os.Open("./output.dfpwm")
	 if err != nil {
	 	panic(err)
	 }

	 defer file.Close()

}
