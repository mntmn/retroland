package main

import "image/png"
//import "io"
import "io/ioutil"
import "os"
//import "fmt"

func main() {
	infile, err := os.Open(os.Args[1])
	if err != nil {
		panic(err)
	}
	defer infile.Close()
	img, _ := png.Decode(infile)

	//rect := img.Bounds()
	//w := rect.Dx()
	//h := rect.Dy()

	charset := make([]byte,256*8)

	for y:=0; y<16; y++ {
		for x:=0; x<16; x++ {
			for p:=0; p<8; p++ {
				pix:=byte(0)
				for o:=0; o<8; o++ {
					pix<<=1
					r,g,b,_ := img.At(x*8+o,y*8+p).RGBA()
					if (r>128 && g>128 && b>128) {
						pix |= 1
					}
				}
				charset[(y*16+x)*8+p]=pix
			}
		}
	}

	ioutil.WriteFile(os.Args[2], charset, 666)
}
