#include <stdio.h>
#include <cbm.h>

#define u8 unsigned char

extern u8 TILES[];

u8* screen = (u8*)0x0400;
u8* colormap = (u8*)55296;

u8* vic_banksel = (u8*)0xd018;
u8* vic_font = (u8*)0x3800;
u8* vic_border = (u8*)0xd020;
u8* vic_bg = (u8*)0xd021;

void copy_tiles() {
  int i;
  for (i=0; i<256*8; i++) {
    vic_font[i]=TILES[i];
  }
}

u8 map[20*12];

void rand_map() {
  int i;
  for (i=0; i<20*12; i++) {
    map[i]=2;
  }
  map[20*2+2] = 0; // tree
  map[20*2+4] = 0; // tree
  map[20*3+4] = 0; // tree

  map[20*5+6] = 1; // mountain
  map[20*6+6] = 1; // mountain
  map[20*6+7] = 1; // mountain
  map[20*7+6] = 1; // mountain
  
  map[20*6+8] = 17;
  map[20*7+7] = 17;
  
  map[21*7+9] = 16;
  
}

void paint_tile(x,y) {
  int sp,tx,ty,i,toff,t;
  i=y*20+x;
  t=map[i];
  ty=t>>4;
  tx=(t&0x0f)<<1;
  toff=(ty<<5)+tx;
  sp=(x*2)+(y*2*40);
  screen[sp]    = toff;
  screen[sp+1]  = toff+1;
  screen[sp+40] = toff+16;
  screen[sp+41] = toff+17;
  colormap[sp]  = t;
  colormap[sp+1]  = t;
  colormap[sp+40]  = t;
  colormap[sp+41]  = t;
}

void paint_map() {
  int x,y,sp,tx,ty,i,toff,t;
  i=0;
  sp=0;
  for (y=0; y<24; y+=2) {
    for (x=0; x<40; x+=2) {
      t=map[i];
      ty=map[i]/16;
      tx=2*(map[i]%16);
      toff=ty*32+tx;
      screen[sp]    = toff;
      screen[sp+1]  = toff+1;
      screen[sp+40] = toff+16;
      screen[sp+41] = toff+17;
      
      sp+=2;
      i++;
    }
    sp+=40;
  }
  for (x=0; x<40; x++) {
    screen[sp+x]=0xff;
  }
}

u8 recv_tile(int x, int y) {
  u8 t = cbm_k_getin();
  if (t) {
    map[y*20+x] = t-1;
    //screen[4] = t;
    paint_tile(x,y);
  }
  return t;
}

void init_serial() {
  char ser_params[3] = {8,161,0}; // baud rate 1200 = 8
  cbm_k_setlfs(2,2,0);
  cbm_k_setnam(ser_params);
  cbm_k_open();
  cbm_k_chkin(2);

  screen[0] = 'S';
}

int main() {
  int rx,ry;
  *vic_border=COLOR_WHITE;
  init_serial();
  *vic_border=COLOR_BLACK;
  *vic_bg=COLOR_BLACK;
  
  *vic_banksel = *vic_banksel | 0xe; // charset at 3800
  copy_tiles();
  //rand_map();
  //paint_map();

  rx=0;
  ry=0;
  while(1){
    u8 t = recv_tile(rx,ry);
    if (t) {
      rx++;
      if (rx>=20) {
        rx=0;
        ry++;
      }
      if (ry>=12) {
        ry=0;
      }
    }
  };
  return 0;
}
