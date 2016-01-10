package main

import "fmt"
import "github.com/veandco/go-sdl2/sdl"
import "math/rand"
import "os"
import "io/ioutil"

type TileDef struct {
	Color uint32
	Name  string
}

type Tile struct {
	Def *TileDef
}

var tiledefs = map[string]*TileDef{
	"1":  &TileDef{Color: 0xff0000ff, Name: "1"},
	"2":  &TileDef{Color: 0xff1111ff, Name: "2"},
	"3":  &TileDef{Color: 0xff2222ff, Name: "2"},
	"4":  &TileDef{Color: 0xff3333ff, Name: "2"},
	"5":  &TileDef{Color: 0xff4444ff, Name: "2"},
	"6":  &TileDef{Color: 0xffffff55, Name: "2"},
	"7":  &TileDef{Color: 0xffffff66, Name: "2"},
	"8":  &TileDef{Color: 0xff77ff77, Name: "2"},
	"9":  &TileDef{Color: 0xff88ff88, Name: "2"},
	"10": &TileDef{Color: 0xff99ff99, Name: "2"},
	"11": &TileDef{Color: 0xffaaaaaa, Name: "2"},
	"12": &TileDef{Color: 0xffbbbbbb, Name: "2"},
	"13": &TileDef{Color: 0xffcccccc, Name: "2"},
	"14": &TileDef{Color: 0xffdddddd, Name: "2"},
	"15": &TileDef{Color: 0xffeeeeee, Name: "2"},
	"16": &TileDef{Color: 0xffffffff, Name: "2"},
}

const MAPW = 256
const MAPH = 256

var tilew = 2
var tileh = 2
var tiles [MAPW * MAPH]Tile

var heightmap [MAPW * MAPH]float32

var tilenames = []string{}

const roughness = 1

func getHeightmap(x int, y int) float32 {
	if x < 0 || y < 0 || x >= MAPW || y >= MAPH {
		return -1
	}
	return heightmap[MAPW*y+x]
}

func setHeightmap(x int, y int, h float32) {
	if x < 0 || y < 0 || x >= MAPW || y >= MAPH {
		return
	}
	heightmap[MAPW*y+x] = h
}

func diamond(x int, y int, size int, offset float32) {
	var ave = (getHeightmap(x, y-size) + getHeightmap(x+size, y) + getHeightmap(x, y+size) + getHeightmap(x-size, y)) / 4
	setHeightmap(x, y, ave+offset)
}

func square(x int, y int, size int, offset float32) {
	var ave = (getHeightmap(x-size, y-size) + getHeightmap(x+size, y-size) + getHeightmap(x+size, y+size) + getHeightmap(x-size, y+size)) / 4
	setHeightmap(x, y, ave+offset)
}

func divideHeightmap(size float32) {
	half := float32(size / 2)
	scale := roughness * size
	if half < 1 {
		return
	}

	for y := half; y < MAPH; y += size {
		for x := half; x < MAPW; x += size {
			square(int(x), int(y), int(half), rand.Float32()*scale*2-scale)
		}
	}

	for y := float32(0); y <= MAPH; y += half {
		for x := float32(int((y + half)) % int(size)); x <= MAPW; x += size {
			diamond(int(x), int(y), int(half), rand.Float32()*scale*2-scale)
		}
	}
	divideHeightmap(size / 2)
}

func renderMap(surface *sdl.Surface, window *sdl.Window) {

	divideHeightmap(MAPW)

	fmt.Println("generating…")

	ascii := make([]byte, 40)
	ox := 50
	oy := 50

	rect := sdl.Rect{0, 0, int32(tilew), int32(tileh)}
	for y := 0; y < MAPH; y++ {
		for x := 0; x < MAPW; x++ {
			rect.X = int32(x * tilew)
			rect.Y = int32(y * tileh)

			//idx := int(rand.Float32() * float32(len(tiledefs)))
			idx := int(getHeightmap(x, y)/32) + 8
			if idx < 0 {
				idx = 0
			}
			if idx > 15 {
				idx = 15
			}

			tiles[x*MAPW].Def = tiledefs[tilenames[idx]]

			if x >= ox && x < (ox+20) && y >= oy && y < (oy+12) {
				ascii[(x - ox)] = byte(1 + idx)
			}
			if x == (ox+20) && y >= oy && y < (oy+12) {
				window.UpdateSurface()
				fmt.Println("transmitting…")
				ioutil.WriteFile("/dev/ttyUSB0", ascii, 0777)
				sdl.Delay(200)
			}

			surface.FillRect(&rect, tiles[x*MAPW].Def.Color)
		}
	}
	window.UpdateSurface()

}

func run() int {
	sdl.Init(sdl.INIT_EVERYTHING)

	window, err := sdl.CreateWindow("retroland", sdl.WINDOWPOS_UNDEFINED, sdl.WINDOWPOS_UNDEFINED,
		MAPW*tilew, MAPH*tileh, sdl.WINDOW_SHOWN)
	if err != nil {
		panic(err)
	}
	defer window.Destroy()

	surface, err := window.GetSurface()
	if err != nil {
		panic(err)
	}

	for k := range tiledefs {
		tilenames = append(tilenames, k)
	}

	renderMap(surface, window)

	running := true
	for running {
		for event := sdl.PollEvent(); event != nil; event = sdl.PollEvent() {
			switch t := event.(type) {
			case *sdl.QuitEvent:
				running = false
			case *sdl.MouseMotionEvent:
				//fmt.Printf("[%d ms] MouseMotion\ttype:%d\tid:%d\tx:%d\ty:%d\txrel:%d\tyrel:%d\n", t.Timestamp, t.Type, t.Which, t.X, t.Y, t.XRel, t.YRel)
			case *sdl.MouseButtonEvent:
				fmt.Printf("[%d ms] MouseButton\ttype:%d\tid:%d\tx:%d\ty:%d\tbutton:%d\tstate:%d\n",
					t.Timestamp, t.Type, t.Which, t.X, t.Y, t.Button, t.State)
				if t.Type == 1026 {
					renderMap(surface, window)
				}
			case *sdl.MouseWheelEvent:
				fmt.Printf("[%d ms] MouseWheel\ttype:%d\tid:%d\tx:%d\ty:%d\n",
					t.Timestamp, t.Type, t.Which, t.X, t.Y)
			case *sdl.KeyUpEvent:
				fmt.Printf("[%d ms] Keyboard\ttype:%d\tsym:%c\tmodifiers:%d\tstate:%d\trepeat:%d\n",
					t.Timestamp, t.Type, t.Keysym.Sym, t.Keysym.Mod, t.State, t.Repeat)
			}
		}
	}
	return 0
}

func main() {
	os.Exit(run())
}
