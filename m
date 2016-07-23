From: Bhatia Amit <amitbhatia@rocketmail.com>
Subject: Re: Cannot start array on disk
Date: Sat, 23 Jul 2016 04:00:16 +0000 (UTC)
Message-ID: <1152956900.3399623.1469246417006.JavaMail.yahoo@mail.yahoo.com>
References: <1124605843.526681.1468785592654.JavaMail.yahoo.ref@mail.yahoo.com> <1124605843.526681.1468785592654.JavaMail.yahoo@mail.yahoo.com> <73583e52-ca6b-b043-cbae-02c8a122be24@turmel.org> <1436537429.1672198.1468980612541.JavaMail.yahoo@mail.yahoo.com> <1537154003.1687848.1468983169996.JavaMail.yahoo@mail.yahoo.com> <6b958d9f-ec61-3b87-fcd7-ff63c0af32fe@turmel.org> <1334935791.2305089.1469066429563.JavaMail.yahoo@mail.yahoo.com> <48687c4e-792c-7cdc-7374-3020964f1892@turmel.org>
Reply-To: Bhatia Amit <amitbhatia@rocketmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <48687c4e-792c-7cdc-7374-3020964f1892@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



> Hmm.  I'm stumped.  The only thing left that I'd try is to hexdump

> search the partition looking for an ext4 magic signature.  That would

> give us a clue.
> 
> { Fair warning: this doesn't often end well. }
> 
> To find possible ext4 signatures, use this:
> 
> hexdump -C /dev/sdc4 |egrep '^[0-9a-f]+30  .+  53 ef' >sb.lst
> 
> Not all of them will be superblocks, of course, but that will give
> addresses that can be more closely examined.  Paste the first hundred or
> so matches in your reply.



Hi Phil,

Following is the output from hexdump command you suggested above. Additionally, the r-linux tool that I had used to scan the disk for files, had claimed to find superblocks at multiple locations on disk. So, after the hexdump output, I have also dumped some information from hex output of the claimed superblock region, from three locations (first, middle and last superblock) on disk. Also, each superblock is claimed to occupy 2 sectors, but I have only pasted the first sector here, because the second sector is all zeros. The first two superblocks look to be exactly the same, but the last one seems a little different.


Thanks,
Amit

$ sudo hexdump -C /dev/sdc4 |egrep '^[0-9a-f]+30  .+  53 ef' >sb.lst
^C
$ cat sb.lst 
105bf330  c7 c2 ed 89 e6 42 12 cf  53 ef 9a 71 0b b5 90 48  |.....B..S..q...H|
10f66530  98 d5 99 9c fa f1 f2 22  53 ef 42 bb db 27 7d 71  |......."S.B..'}q|
110ec130  b8 39 a0 79 5a 1c 62 c8  53 ef b1 e4 46 a4 91 07  |.9.yZ.b.S...F...|
127ab030  e4 74 55 04 d1 e1 82 0d  53 ef f4 d6 cf 70 a1 86  |.tU.....S....p..|
132fb230  11 e6 63 f9 19 5b 1d d4  53 ef a1 8e c1 6f 57 48  |..c..[..S....oWH|
13ad2d30  eb 4c 2e 55 6b 97 74 41  53 ef 46 44 0d 63 d9 7e  |.L.Uk.tAS.FD.c.~|
15c01f30  d4 1e 67 0c 30 40 a4 c6  53 ef 4e e8 36 f4 e9 bd  |..g.0@..S.N.6...|
15de7730  4c fa 94 59 e5 bd b6 b2  53 ef f4 0f c7 78 78 0e  |L..Y....S....xx.|
16ecd230  75 3d a7 28 81 0a c6 73  53 ef 96 2a d7 10 ae cc  |u=.(...sS..*....|
18307f30  40 a5 5f 2a ec 1c 56 d0  53 ef 28 d7 d9 8d b4 f4  |@._*..V.S.(.....|
187eab30  f7 1b 1e e5 5e 83 28 37  53 ef b7 b4 42 13 c1 0c  |....^.(7S...B...|
192f3030  e7 73 5a 17 5e 11 21 a5  53 ef 05 8f bd 5d 2d 92  |.sZ.^.!.S....]-.|
1d28de30  32 33 bd 1c b7 10 e6 78  53 ef 88 a5 9b 88 b6 50  |23.....xS......P|
2129fe30  1b 0e 6d 27 46 04 da 81  53 ef 58 14 15 09 58 45  |..m'F...S.X...XE|
2326d730  7f fc 78 d3 55 d6 12 ac  53 ef 73 67 80 15 15 70  |..x.U...S.sg...p|
23b56d30  4f 9c 76 9c e8 17 86 a3  53 ef 78 1b 58 e2 e2 47  |O.v.....S.x.X..G|
2624bd30  ad 07 ec 2d e8 db 0a 30  53 ef 65 c0 90 11 3e 1b  |...-...0S.e...>.|
26afc630  fd 35 c8 6d fc f1 13 17  53 ef 61 44 7e 1b d2 ca  |.5.m....S.aD~...|
27db4b30  02 d8 79 1e 76 7c 93 14  53 ef 9a f8 77 62 0a 7e  |..y.v|..S...wb.~|
27dece30  a3 8f 27 a4 c2 f4 96 3a  53 ef 3a 3a 71 df 44 e8  |..'....:S.::q.D.|
2a925930  fa f1 c4 dd 01 77 d0 34  53 ef 40 71 42 e0 75 0c  |.....w.4S.@qB.u.|
2c3cec30  92 76 09 be ad c8 47 86  53 ef 72 16 57 4d 81 cb  |.v....G.S.r.WM..|
2c400f30  24 cb 98 10 3c d0 f3 d5  53 ef 53 d4 b3 e1 63 e6  |$...<...S.S...c.|
2cdc8c30  16 81 f1 14 36 ec d6 cc  53 ef 73 64 f5 ea 5d 5d  |....6...S.sd..]]|
2d6f1630  f0 bf e7 bb 29 ad f2 0d  53 ef ba 32 a0 68 84 74  |....)...S..2.h.t|
2e9c2330  db e8 f5 ed f5 12 26 f6  53 ef f3 d6 61 c0 26 e3  |......&.S...a.&.|
2faf0830  9c 68 d2 d1 f7 fa 15 0d  53 ef 63 21 da d1 0e 8b  |.h......S.c!....|
32f30930  35 23 2d 12 64 67 2c 54  53 ef d8 fa 36 2c 95 f2  |5#-.dg,TS...6,..|
f90ba830  91 88 98 6e f4 19 e1 c4  53 ef a9 fc b1 52 b1 97  |...n....S....R..|
f91c6530  bc 30 41 c1 8c 1b 8c a8  53 ef 94 a9 9b f0 8e 56  |.0A.....S......V|
fa245930  a4 66 34 9c 70 bc 44 70  53 ef 32 d5 46 fa 3c aa  |.f4.p.DpS.2.F.<.|
fb143c30  b1 13 45 db d6 19 00 ec  53 ef fd 49 a5 7f b0 e8  |..E.....S..I....|
fc20f030  33 e1 02 bf cc ee 1f 93  53 ef 2b 4a ff 3e fc e3  |3.......S.+J.>..|
fcd6be30  3f 36 8c bf 11 8e 17 c3  53 ef 49 86 15 22 27 c6  |?6......S.I.."'.|
fd436f30  98 5c cc 71 7a 12 6f 15  53 ef f2 67 06 68 80 e9  |.\.qz.o.S..g.h..|
ff5b6830  fd 41 f4 49 7b 59 52 1f  53 ef 59 05 57 56 7d 89  |.A.I{YR.S.Y.WV}.|
fff80030  47 9d ba 50 03 00 1b 00  53 ef 00 00 01 00 00 00  |G..P....S.......|
1003e5030  a3 70 2a c3 b7 ff 00 a8  53 ef ff 00 e0 93 fe 2f  |.p*.....S....../|
1020cdf30  b9 46 dc 14 4d c7 cc 38  53 ef 4a 0c 99 a1 cd a6  |.F..M..8S.J.....|
10629e830  19 0c 14 0e b9 ab 5f f0  53 ef 83 1e 1c f1 47 c1  |......_.S.....G.|
10801e530  81 d7 38 e9 83 5f 3b 53  53 ef b3 fa ee 8d 75 a9  |..8.._;SS.....u.|
109421e30  a9 92 47 01 f3 df 24 fa  53 ef 6c 25 7b 43 18 e1  |..G...$.S.l%{C..|
109440b30  f8 fe d1 a4 08 21 79 09  53 ef ed 4e 90 32 0d 82  |.....!y.S..N.2..|
10bc21830  0d c4 cf e6 80 36 b6 3e  53 ef de a3 82 db 73 99  |.....6.>S.....s.|
10c4bef30  8c 46 79 e3 8e 95 c1 5b  53 ef f0 0f df b1 62 29  |.Fy....[S.....b)|
10e0edd30  0d 70 ad 87 da e0 9e 7a  53 ef a4 95 67 48 dd 63  |.p.....zS...gH.c|
111dfc630  dd 2e 72 ce 16 59 24 8d  53 ef 7f c0 eb f4 0a d5  |..r..Y$.S.......|
1131ea130  b2 8d 82 ec b9 56 db bd  53 ef 2f bf a5 29 b6 45  |.....V..S./..).E|
1133f4e30  e1 8e 42 0e 82 be 56 0b  53 ef 65 ac ae 67 5c 59  |..B...V.S.e..g\Y|
11401ff30  49 36 31 43 b4 f5 53 d4  53 ef 25 fb 3d a1 11 31  |I61C..S.S.%.=..1|
1145c1530  a0 86 2f 29 db 6e d6 cf  53 ef 4b 9d 91 b3 cc 4a  |../).n..S.K....J|
1146b0930  6d e2 6b 58 91 a6 58 6e  53 ef 44 4f de af 33 37  |m.kX..XnS.DO..37|
114a2b430  89 21 93 70 45 0b 8f 4c  53 ef 35 0b 6d 32 ca 5b  |.!.pE..LS.5.m2.[|
115032330  66 45 5d 92 65 19 93 f9  53 ef 95 e2 b6 1e 46 d5  |fE].e...S.....F.|
115205730  7e 64 6e 08 dd f2 ed 01  53 ef d4 73 25 2d 49 9f  |~dn.....S..s%-I.|
1165ed030  39 00 1a 69 2c d2 3c db  53 ef 60 00 6b f2 28 3b  |9..i,.<.S.`.k.(;|
1185acd30  d1 98 5b f7 6a 0e 13 6f  53 ef 51 6a 06 37 75 8c  |..[.j..oS.Qj.7u.|
11984b230  18 f4 ab 40 fa 55 90 5e  53 ef 57 c1 ad 0c cb e0  |...@.U.^S.W.....|
11c077930  00 d7 af 14 c0 1c 93 cf  53 ef 5d b0 89 9c e5 76  |........S.]....v|
11c38ff30  33 cf 3c c5 c9 f9 87 e7  53 ef 5c f5 14 00 f0 e3  |3.<.....S.\.....|
11db89230  61 c0 1f 9f a8 e6 ff 00  53 ef 5d 7a 83 ac a8 6c  |a.......S.]z...l|
11e947c30  e6 6d e0 55 51 d6 cb 9c  53 ef 98 0f 55 6e fe b8  |.m.UQ...S...Un..|
11eadce30  8b 7d 71 7c 1c 0f ad c1  53 ef a0 1d 65 66 fa 06  |.}q|....S...ef..|
11f485430  5e 2f 5a 2b 48 69 62 44  53 ef 65 d5 06 a0 29 a2  |^/Z+HibDS.e...).|
11fc23030  a9 97 1f b7 75 ef f6 45  53 ef f6 f5 59 d2 4f 25  |....u..ES...Y.O%|
1248a2b30  63 b9 43 b5 5d 4e e8 47  53 ef ed 4b e6 06 52 e0  |c.C.]N.GS..K..R.|
127ad8830  a5 9c 2a 44 50 2f f0 0f  53 ef cf eb 57 46 37 d4  |..*DP/..S...WF7.|
129bc9630  04 04 01 01 01 01 04 02  53 ef 2f 57 69 6e 64 6f  |........S./Windo|
12a04da30  4e 68 f3 63 2a ab 18 d8  53 ef 7b d6 36 be c5 a6  |Nh.c*...S.{.6...|
12b8a2b30  59 ab c2 61 49 da 68 2b  53 ef 8b 13 03 e5 f7 02  |Y..aI.h+S.......|
12d963530  92 cd 5e 5f 0d 56 8e 4b  53 ef a7 13 b2 64 a0 d2  |..^_.V.KS....d..|
12dba1330  ff df 64 ae f0 b0 b6 f7  53 ef 97 06 ff 92 9b 82  |..d.....S.......|
12de94f30  88 85 59 bb 88 5f 50 58  53 ef 18 af 98 14 c1 62  |..Y.._PXS......b|
12e2d6930  d0 26 8c 44 8a 91 9e 2e  53 ef 9b 1e f8 af a6 70  |.&.D....S......p|
12f111030  23 df 68 37 78 f3 ad bb  53 ef 73 61 37 81 56 54  |#.h7x...S.sa7.VT|
12f4f4430  40 ba 7d 05 40 3d f0 82  53 ef 21 a8 f3 a8 bc 7d  |@.}.@=..S.!....}|
12fd32030  fa 67 9f b2 bc 4c 6d b0  53 ef 05 62 62 32 93 81  |.g...Lm.S..bb2..|
130852230  e9 fa c8 0c af 14 93 bd  53 ef 33 ee 09 61 1e 6b  |........S.3..a.k|
1323fd330  7d 4e cb 58 78 ca 8d e1  53 ef 12 f6 ee 19 68 46  |}N.Xx...S.....hF|
132ae3b30  50 35 42 46 d9 bf af a0  53 ef 6c dd 82 8b c4 ce  |P5BF....S.l.....|
132c99830  38 69 aa 62 1d ce 64 7b  53 ef 77 fe 80 59 f4 35  |8i.b..d{S.w..Y.5|
133d49730  1a 48 8a 29 f6 1a 68 c8  53 ef 65 17 6f 78 9d f7  |.H.)..h.S.e.ox..|
1345ed230  01 71 89 16 36 c4 b0 26  53 ef 66 9f 02 f6 39 1b  |.q..6..&S.f...9.|
13490ec30  95 03 fb 23 62 06 9b 5b  53 ef 1c 9a 24 6e 2b c3  |...#b..[S...$n+.|
135bc7930  c8 4d 9d 4e 5e 24 9a 33  53 ef b7 4f 56 6c 9f c7  |.M.N^$.3S..OVl..|
13efd6e30  09 03 03 03 02 99 42 19  53 ef 09 03 03 03 02 99  |......B.S.......|
1433a1630  19 bb 0a 03 04 03 54 83  53 ef 1d 19 bc 0a 03 04  |......T.S.......|
1529e6f30  12 0f bc 17 8f 9f 1a 48  53 ef 5c 2b b1 1f df 73  |.......HS.\+...s|
157810530  65 49 0b 1d 4a 68 08 00  53 ef 8f e3 37 97 7d 78  |eI..Jh..S...7.}x|
157a38730  7f c0 98 96 b4 cf ea 3a  53 ef 59 c8 e0 72 d7 c4  |.......:S.Y..r..|
15a696530  41 ab e4 ce 11 c6 14 9e  53 ef b9 7b 0d c7 23 ee  |A.......S..{..#.|
15b0bb230  71 e4 7f 75 89 9f 49 5c  53 ef bf e5 84 21 7b a9  |q..u..I\S....!{.|
15b3cfc30  d3 a3 15 81 14 01 89 a0  53 ef e4 0c c1 9b e0 09  |........S.......|
15e5c2e30  51 0c d3 53 dd 7f 5b e7  53 ef 7b 4e fe d0 9c 39  |Q..S..[.S.{N...9|
15f417c30  66 b6 00 ca ca 90 2d ae  53 ef 47 aa eb 68 18 30  |f.....-.S.G..h.0|
1611a6530  ad e5 c0 08 7e 9f 1f 02  53 ef d6 d5 f3 df 6e f6  |....~...S.....n.|
167671330  6c 00 2c 17 f7 94 11 00  53 ef d3 61 00 28 16 47  |l.,.....S..a.(.G|
168ad2730  9f 7a 9a 77 da 7f a9 bf  53 ef 9d 74 be b5 36 ef  |.z.w....S..t..6.|
1696ba630  e2 e9 32 48 30 b8 c9 4b  53 ef 8b 58 2e 9d 24 09  |..2H0..KS..X..$.|
16b326930  5f 01 e6 7c 20 c9 39 be  53 ef 69 08 f5 d1 ee 86  |_..| .9.S.i.....|
16b431830  40 64 66 38 0c 06 15 ba  53 ef de bd d3 ee fb 7e  |@df8....S......~|
1706ca530  3a e1 b9 b2 e1 4d d4 00  53 ef f0 45 c8 4e ce 33  |:....M..S..E.N.3|
170cd5230  c6 7e dd 7d a0 21 80 2d  53 ef 9d b1 09 d4 ea aa  |.~.}.!.


$ cat sblock.txt 

Name: Ext2/Ext3/Ext4 SuperBlock
Offset (in sectors): 8387584
Size (in sectors): 2


Sector 8387584 (Parent: WDC WD30EZRX-00D8PB0 80.00A80 Record: 17419264)

FFF80000:  00 46 B7 02 5F 8C B9 02 - 00 00 00 00 62 25 B6 02  .F.._.......b%..
FFF80010:  1A 3B B7 02 00 00 00 00 - 06 00 00 00 06 00 00 00  .;..............
FFF80020:  F8 FF 00 00 F8 FF 00 00 - 00 FF 00 00 43 3E B3 4F  ............C>.O
FFF80030:  47 9D BA 50 03 00 1B 00 - 53 EF 00 00 01 00 00 00  G..P....S.......
FFF80040:  3B B5 02 00 00 4E ED 00 - 00 00 00 00 01 00 00 00  ;....N..........
FFF80050:  00 00 00 00 0B 00 00 00 - 00 01 01 00 3C 00 00 00  ............<...
FFF80060:  42 02 00 00 7B 00 00 00 - B6 7F 9F FD 12 BF 4D 57  B...{.........MW
FFF80070:  A8 34 DD 09 E9 E8 BA C0 - 00 00 00 00 00 00 00 00  .4..............
FFF80080:  00 00 00 00 00 00 00 00 - 2F 43 61 63 68 65 56 6F  ......../CacheVo
FFF80090:  6C 75 6D 65 00 C8 24 9E - 20 22 82 24 22 C8 1B 60  lume..$. ".$"..`
FFF800A0:  60 FF FF FF 9C CA D0 E4 - 5C C8 13 41 80 C0 10 E6  `.......\..A....
FFF800B0:  68 C8 08 21 60 CA D0 E4 - 5C 00 00 00 00 CD AC 46  h..!`...\......F
FFF800C0:  80 C8 1C 5A 60 C8 24 9E - 00 00 00 00 00 00 20 00  ...Z`.$....... .
FFF800D0:  00 00 00 00 00 00 00 00 - 00 00 00 00 00 00 00 00  ................
FFF800E0:  08 00 00 00 00 00 00 00 - 00 00 00 00 FC ED 10 2F  .............../
FFF800F0:  38 44 66 85 D0 AC 7C A3 - FF F3 B0 AF 01 01 00 00  8Df...|.........
FFF80100:  00 00 00 00 00 00 00 00 - 3B B5 02 00 0A F3 02 00  ........;.......
FFF80110:  04 00 00 00 00 00 00 00 - 00 00 00 00 FF 7F 00 00  ................
FFF80120:  78 EA B0 02 FF 7F 00 00 - 01 00 00 00 77 6A B1 02  x...........wj..
FFF80130:  00 00 00 00 00 00 00 00 - 00 00 00 00 00 00 00 00  ................
FFF80140:  00 00 00 00 00 00 00 00 - 00 00 00 00 00 00 00 80  ................
FFF80150:  00 00 00 00 00 00 00 00 - 00 00 00 00 1C 00 1C 00  ................
FFF80160:  02 00 00 00 FF 78 00 00 - 00 00 00 00 00 00 00 00  .....x..........
FFF80170:  00 00 00 00 04 00 00 00 - 94 F3 87 01 00 00 00 00  ................
FFF80180:  00 00 00 00 00 00 00 00 - 00 00 00 00 00 00 00 00  ................
FFF80190:  00 00 00 00 00 00 00 00 - 00 00 00 00 00 00 00 00  ................
FFF801A0:  00 00 00 00 00 00 00 00 - 00 00 00 00 00 00 00 00  ................
FFF801B0:  00 00 00 00 00 00 00 00 - 00 00 00 00 00 00 00 00  ................
FFF801C0:  00 00 00 00 00 00 00 00 - 00 00 00 00 00 00 00 00  ................
FFF801D0:  00 00 00 00 00 00 00 00 - 00 00 00 00 00 00 00 00  ................
FFF801E0:  00 00 00 00 00 00 00 00 - 00 00 00 00 00 00 00 00  ................
FFF801F0:  00 00 00 00 00 00 00 00 - 00 00 00 00 00 00 00 00  ................



Name: Ext2/Ext3/Ext4 SuperBlock
Offset (in sectors): 2038182912
Size (in sectors): 2


Sector 2038182912 (Parent: WDC WD30EZRX-00D8PB0 80.00A80 Record: 2047214592)


F2F8680000:  00 46 B7 02 5F 8C B9 02 - 00 00 00 00 62 25 B6 02  .F.._.......b%..
F2F8680010:  1A 3B B7 02 00 00 00 00 - 06 00 00 00 06 00 00 00  .;..............
F2F8680020:  F8 FF 00 00 F8 FF 00 00 - 00 FF 00 00 43 3E B3 4F  ............C>.O
F2F8680030:  47 9D BA 50 03 00 1B 00 - 53 EF 00 00 01 00 00 00  G..P....S.......
F2F8680040:  3B B5 02 00 00 4E ED 00 - 00 00 00 00 01 00 00 00  ;....N..........
F2F8680050:  00 00 00 00 0B 00 00 00 - 00 01 F3 00 3C 00 00 00  ............<...
F2F8680060:  42 02 00 00 7B 00 00 00 - B6 7F 9F FD 12 BF 4D 57  B...{.........MW
F2F8680070:  A8 34 DD 09 E9 E8 BA C0 - 00 00 00 00 00 00 00 00  .4..............
F2F8680080:  00 00 00 00 00 00 00 00 - 2F 43 61 63 68 65 56 6F  ......../CacheVo
F2F8680090:  6C 75 6D 65 00 C8 24 9E - 20 22 82 24 22 C8 1B 60  lume..$. ".$"..`
F2F86800A0:  60 FF FF FF 9C CA D0 E4 - 5C C8 13 41 80 C0 10 E6  `.......\..A....
F2F86800B0:  68 C8 08 21 60 CA D0 E4 - 5C 00 00 00 00 CD AC 46  h..!`...\......F
F2F86800C0:  80 C8 1C 5A 60 C8 24 9E - 00 00 00 00 00 00 20 00  ...Z`.$....... .
F2F86800D0:  00 00 00 00 00 00 00 00 - 00 00 00 00 00 00 00 00  ................
F2F86800E0:  08 00 00 00 00 00 00 00 - 00 00 00 00 FC ED 10 2F  .............../
F2F86800F0:  38 44 66 85 D0 AC 7C A3 - FF F3 B0 AF 01 01 00 00  8Df...|.........
F2F8680100:  00 00 00 00 00 00 00 00 - 3B B5 02 00 0A F3 02 00  ........;.......
F2F8680110:  04 00 00 00 00 00 00 00 - 00 00 00 00 FF 7F 00 00  ................
F2F8680120:  78 EA B0 02 FF 7F 00 00 - 01 00 00 00 77 6A B1 02  x...........wj..
F2F8680130:  00 00 00 00 00 00 00 00 - 00 00 00 00 00 00 00 00  ................
F2F8680140:  00 00 00 00 00 00 00 00 - 00 00 00 00 00 00 00 80  ................
F2F8680150:  00 00 00 00 00 00 00 00 - 00 00 00 00 1C 00 1C 00  ................
F2F8680160:  02 00 00 00 FF 78 00 00 - 00 00 00 00 00 00 00 00  .....x..........
F2F8680170:  00 00 00 00 04 00 00 00 - 94 F3 87 01 00 00 00 00  ................
F2F8680180:  00 00 00 00 00 00 00 00 - 00 00 00 00 00 00 00 00  ................
F2F8680190:  00 00 00 00 00 00 00 00 - 00 00 00 00 00 00 00 00  ................
F2F86801A0:  00 00 00 00 00 00 00 00 - 00 00 00 00 00 00 00 00  ................
F2F86801B0:  00 00 00 00 00 00 00 00 - 00 00 00 00 00 00 00 00  ................
F2F86801C0:  00 00 00 00 00 00 00 00 - 00 00 00 00 00 00 00 00  ................
F2F86801D0:  00 00 00 00 00 00 00 00 - 00 00 00 00 00 00 00 00  ................
F2F86801E0:  00 00 00 00 00 00 00 00 - 00 00 00 00 00 00 00 00  ................
F2F86801F0:  00 00 00 00 00 00 00 00 - 00 00 00 00 00 00 00 00  ................



Name: Ext2/Ext3/Ext4 SuperBlock
Offset (in sectors): 5781334786
Size (in sectors): 2



Sector 5781334786 (Parent: WDC WD30EZRX-00D8PB0 80.00A80 Record: 5790366466)


2B130560400:  00 46 B7 02 5F 8C B9 02 - 00 00 00 00 25 7F 09 02  .F.._.......%...
2B130560410:  DC F8 99 02 00 00 00 00 - 06 00 00 00 06 00 00 00  ................
2B130560420:  F8 FF 00 00 F8 FF 00 00 - 00 FF 00 00 6D C8 02 57  ............m..W
2B130560430:  6D C8 02 57 2E 00 1B 00 - 53 EF 01 00 01 00 00 00  m..W....S.......
2B130560440:  3B B5 02 00 00 4E ED 00 - 00 00 00 00 01 00 00 00  ;....N..........
2B130560450:  00 00 00 00 0B 00 00 00 - 00 01 00 00 3C 00 00 00  ............<...
2B130560460:  46 02 00 00 7B 00 00 00 - B6 7F 9F FD 12 BF 4D 57  F...{.........MW
2B130560470:  A8 34 DD 09 E9 E8 BA C0 - 00 00 00 00 00 00 00 00  .4..............
2B130560480:  00 00 00 00 00 00 00 00 - 2F 43 61 63 68 65 56 6F  ......../CacheVo
2B130560490:  6C 75 6D 65 00 C7 4B BE - 20 24 82 24 82 C8 1B A0  lume..K. $.$....
2B1305604A0:  60 FF FF FF 9C C0 F1 11 - DC C8 13 2A A0 C0 10 E6  `..........*....
2B1305604B0:  68 C8 08 21 60 C0 F1 11 - DC 00 00 00 00 CF 3D 2A  h..!`.........=*
2B1305604C0:  E0 C2 94 C1 60 C7 4B BE - 00 00 00 00 00 00 20 00  ....`.K....... .
2B1305604D0:  00 00 00 00 00 00 00 00 - 00 00 00 00 00 00 00 00  ................
2B1305604E0:  08 00 00 00 00 00 00 00 - 00 00 00 00 FC ED 10 2F  .............../
2B1305604F0:  38 44 66 85 D0 AC 7C A3 - FF F3 B0 AF 01 01 00 00  8Df...|.........
2B130560500:  00 00 00 00 00 00 00 00 - 3B B5 02 00 0A F3 02 00  ........;.......
2B130560510:  04 00 00 00 00 00 00 00 - 00 00 00 00 FF 7F 00 00  ................
2B130560520:  78 EA B0 02 FF 7F 00 00 - 01 00 00 00 77 6A B1 02  x...........wj..
2B130560530:  00 00 00 00 00 00 00 00 - 00 00 00 00 00 00 00 00  ................
2B130560540:  00 00 00 00 00 00 00 00 - 00 00 00 00 00 00 00 80  ................
2B130560550:  00 00 00 00 00 00 00 00 - 00 00 00 00 1C 00 1C 00  ................
2B130560560:  02 00 00 00 FF 78 00 00 - 00 00 00 00 00 00 00 00  .....x..........
2B130560570:  00 00 00 00 04 00 00 00 - D4 DD EB 54 00 00 00 00  ...........T....
2B130560580:  00 00 00 00 00 00 00 00 - 00 00 00 00 00 00 00 00  ................
2B130560590:  00 00 00 00 00 00 00 00 - 00 00 00 00 00 00 00 00  ................
2B1305605A0:  00 00 00 00 00 00 00 00 - 00 00 00 00 00 00 00 00  ................
2B1305605B0:  00 00 00 00 00 00 00 00 - 00 00 00 00 00 00 00 00  ................
2B1305605C0:  00 00 00 00 00 00 00 00 - 00 00 00 00 00 00 00 00  ................
2B1305605D0:  00 00 00 00 00 00 00 00 - 00 00 00 00 00 00 00 00  ................
2B1305605E0:  00 00 00 00 00 00 00 00 - 00 00 00 00 00 00 00 00  ................
2B1305605F0:  00 00 00 00 00 00 00 00 - 00 00 00 00 00 00 00 00  ................
