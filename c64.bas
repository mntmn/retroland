
10 rem *************** control register settings
15 :
20 br=8: rem 1200 baud 
30 db=0: rem 8 data bits (one a parity bit, see line 80) 
40 sb=0: rem 1 stop bit
45 :
50 rem *************** command register settings
55 :
60 hs=1   : rem x-wire
70 ua=0   : rem vollduplex
80 pa=160 : rem mark parity (8.databit always 1)
90 :
100 rem ************** general settings
105 :
100 lf=2 : rem logical file number (free choiceable)
110 ga=2 : rem device number of rs-232 interface
120 sa=0 : rem sekundary adress
125 :
200 open lf,ga,sa, chr$(br+db+sb) + chr$(hs+ua+pa)

209 d%=0
210 get#2, a$
211 if len(a$) then poke 55296+d%, asc(a$):poke 1024+d%, asc(a$):d%=d%+1
212 if d%>1023 then d%=0
213 goto 210
