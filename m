From: Phil Turmel <philip@turmel.org>
Subject: Re: broken raid level 5 array caused by user error
Date: Tue, 10 Nov 2015 08:55:21 -0500
Message-ID: <5641F749.2070804@turmel.org>
References: <15194c2e14b9a7c3431853dea9dc8b5e@pingofdeath.de>
 <alpine.DEB.2.02.1511091254290.24520@uplift.swm.pp.se>
 <5640A4B1.4050207@turmel.org>
 <07de4cd96f39ecb6154794d072ca12e7@pingofdeath.de>
 <5640B8AD.3030800@turmel.org>
 <ed5f0f3cde3f017eae97bab65c792983@pingofdeath.de>
 <d764bf541381927fa4183c9266fb3f5a@pingofdeath.de>
 <5640C38B.4060503@turmel.org>
 <a3a91665c4b7cdd70dacc7d8815cc365@pingofdeath.de>
 <56410C67.2090202@turmel.org>
 <420c63e0400e6d3f50b794e64f6a8d96@pingofdeath.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <420c63e0400e6d3f50b794e64f6a8d96@pingofdeath.de>
Sender: linux-raid-owner@vger.kernel.org
To: Mathias Mueller <raidfail@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Mathias,

On 11/10/2015 03:37 AM, Mathias Mueller wrote:
> Hi Phil,
> 
> sadly, my ssh-session died while hexdumping over night, but I post what
> I got (restarted the processes anyway):

'screen' is your friend for long-running server tasks.  It's installed in many distros by default.

> 
>> dd if=/dev/sdd1 bs=1M count=1M |hexdump -C |grep -E '[048c]30  .+  53 ef'

I should have put "|head -n 50" on the end of that. :-)

> sdb1:
> http://pastebin.com/ERehrYYR

Pastebin expires.  The list accepts up to ~100k.  I'm pasting this
for the record:

> 00000430  d9 45 8b 4c 00 00 27 00  53 ef 01 00 01 00 00 00  |.E.L..'.S.......|
> 010d8030  9c a9 4c 27 20 97 fe 4c  53 ef 40 e8 dd 2c 1a d6  |..L' ..LS.@..,..|
> 04db5030  4b 5c ea 17 1d 0b b3 1c  53 ef 7c 3f 74 90 97 10  |K\......S.|?t...|
> 07ed8030  73 96 e8 8d 3a d5 9d c4  53 ef dc 1c d8 a5 1d 2b  |s...:...S......+|
> 131af430  c1 77 bd d9 84 c3 25 8f  53 ef 0c e6 17 3e ea 06  |.w....%.S....>..|
> 1ea2b830  87 83 16 e7 b6 ac 24 61  53 ef 70 53 fa 10 dc 27  |......$aS.pS...'|
> 1f79a430  db b2 90 27 87 1c bb bf  53 ef 26 7c 6f 76 23 34  |...'....S.&|ov#4|
> 2a21e830  a7 63 f4 cc 85 1c 7a 8c  53 ef 69 b1 a8 5d ae b0  |.c....z.S.i..]..|
> 3562a830  9d f4 99 e3 62 ae 6b 3f  53 ef 65 04 12 0d 3c 77  |....b.k?S.e...<w|
> 3562c430  15 8e ab 0d 2c cf a2 77  53 ef 03 73 06 6f ab cd  |....,..wS..s.o..|
> 3d254830  3a f2 3f 34 82 1f 8f 98  53 ef 9c 68 c3 81 dc f4  |:.?4....S..h....|
> 4040b030  01 01 10 06 5a 8b 26 43  53 ef ba e2 ce 33 ec 5c  |....Z.&CS....3.\|
> 410dc430  f4 40 bf 4d 8a f1 43 06  53 ef d8 c2 a4 69 ab 0a  |.@.M..C.S....i..|
> 4d8b2c30  32 ed b7 f6 15 bb ab d5  53 ef 1c 6e d6 4c 36 99  |2.......S..n.L6.|
> 4e100030  85 54 ac 57 46 8f a6 57  53 ef 9d 4c 50 60 cc f5  |.T.WF..WS..LP`..|
> 4f23fc30  a8 77 c6 f1 87 80 ca c1  53 ef c7 41 93 db 8b e6  |.w......S..A....|
> 52c41c30  d2 3e d6 ce 01 6d d4 f3  53 ef 3d 7a a2 db 95 5e  |.>...m..S.=z...^|
> 597e1c30  7b 4a 38 58 ff 4c 38 f1  53 ef 77 b1 6c 6a 0a d4  |{J8X.L8.S.w.lj..|
> 5e634430  b7 f2 21 f2 f6 06 0c ff  53 ef 1b a7 bb 78 76 a0  |..!.....S....xv.|
> 6546d430  e7 63 6a 5b 93 69 9e 8b  53 ef 50 99 76 4f 1a 61  |.cj[.i..S.P.vO.a|
> 65d2c430  45 27 46 b4 56 8a 91 ab  53 ef af fa 08 26 a4 99  |E'F.V...S....&..|
> 6625ec30  cd 99 a9 ae 65 08 b3 97  53 ef e3 7e 83 9b 6d a2  |....e...S..~..m.|
> 6b3cc030  cd 6c f0 fd f2 b1 f7 b6  53 ef 8f 9d a3 2a 3f 76  |.l......S....*?v|
> 6d7f2430  07 9b 5a 4f 01 f0 d3 d8  53 ef ed ef b8 26 38 5f  |..ZO....S....&8_|
> 70547030  74 8d 3b 05 2a 99 b4 4f  53 ef 69 20 2d ad 5f 2b  |t.;.*..OS.i -._+|
> 75a74830  f5 c8 3f 03 a9 df 9f 59  53 ef 68 e1 d4 51 9d c5  |..?....YS.h..Q..|
> 83393430  39 54 23 d3 5e b3 7a ef  53 ef 31 90 7f fb ff f3  |9T#.^.z.S.1.....|
> 8442d830  d7 32 76 ca c3 f8 bd a1  53 ef f2 5a 81 ff 27 f2  |.2v.....S..Z..'.|
> 8b4d2c30  b8 97 0c 36 a7 1c a0 29  53 ef 1c dc 21 6d f2 21  |...6...)S...!m.!|
> 9d1f4830  9e 65 ff fe fc 2e 58 e8  53 ef ca 99 9c ad b1 19  |.e....X.S.......|
> a1806030  1d 8e 2b 24 e2 ae 30 54  53 ef 8b 96 16 0b d3 93  |..+$..0TS.......|
> a7c4c030  ef aa f0 35 2d 59 2b d1  53 ef 24 d4 fe e9 4f 35  |...5-Y+.S.$...O5|
> a9597430  75 3a 95 b9 7b 70 c7 9f  53 ef 5c f8 8b 69 20 f0  |u:..{p..S.\..i .|
> ad5ab830  bd 10 15 57 80 89 fd fd  53 ef 2f 04 63 e1 f1 95  |...W....S./.c...|
> b1863830  45 bc 30 8c 0b 9f 2f aa  53 ef bd d1 6e a8 a9 42  |E.0.../.S...n..B|
> b213ec30  a3 3d ba 3d 23 4f 6b fa  53 ef 38 b6 b3 96 37 aa  |.=.=#Ok.S.8...7.|
> bb04a030  85 3b 32 5f 95 fb 42 f1  53 ef 63 7b f9 30 07 81  |.;2_..B.S.c{.0..|
> c7cf2830  66 51 61 82 c5 5a ec c4  53 ef 81 66 df f1 c6 00  |fQa..Z..S..f....|
> c8926c30  29 74 85 31 27 6d 49 1c  53 ef af cd 02 df 4c 2c  |)t.1'mI.S.....L,|
> ca006030  1d 8e 2b 24 e2 ae 30 54  53 ef 8b 96 16 0b d3 93  |..+$..0TS.......|
> cadfbc30  2c c1 b5 c5 72 88 3d bb  53 ef bf de b8 ae b8 a5  |,...r.=.S.......|
> cee41430  a0 51 cf d2 f0 28 78 e2  53 ef 3b c4 f8 aa 95 6c  |.Q...(x.S.;....l|
> d91a3c30  8e 28 30 d6 6f ed de 6e  53 ef 52 5e 27 67 cf f8  |.(0.o..nS.R^'g..|
> d9e76030  14 b0 31 80 64 52 f7 d4  53 ef 4a 48 e5 83 1e 55  |..1.dR..S.JH...U|
> da9ea830  d0 e5 18 b8 ed 03 90 be  53 ef d0 47 90 2f 01 e2  |........S..G./..|
> e6625c30  ca e9 df 4f 39 4d 6d 42  53 ef f1 3c 07 1b 58 de  |...O9MmBS..<..X.|
> f7284830  e7 fa 23 37 40 bc e5 9e  53 ef 01 3e 7e 91 35 5a  |..#7@...S..>~.5Z|
> f981ac30  20 17 eb ed 1e 8f e9 0e  53 ef ac f5 63 ee 9b 08  | .......S...c...|
> fa3cc030  b4 f6 f3 5f a7 16 6a 5c  53 ef 9c 6c 36 53 2c da  |..._..j\S..l6S,.|
> fd574030  db 77 39 c7 8d fe bb 7e  53 ef 5a 85 ea 36 41 8e  |.w9....~S.Z..6A.|

None of these have a write timestamp in the recent past. {Look for 0x55 or
0x56 in the 4th byte on each line.}

> 
> sdc1:
> http://pastebin.com/WMpRtPs5

> 00000430  d9 45 8b 4c 00 00 27 00  53 ef 01 00 01 00 00 00  |.E.L..'.S.......|
> 00100430  28 ab 3f 56 06 00 19 00  53 ef 01 00 01 00 00 00  |(.?V....S.......|                                                                                                                                                               

This ^^ is encouraging: Sun, 08 Nov 2015 20:06:00 GMT
It's in the right spot for data offset == 2048 if this
is the first device.

> 02b80030  7c 6b 4b 55 12 00 19 00  53 ef 00 00 01 00 00 00  ||kKU....S.......|                                                                                                                                                               
> 08100030  7c 6b 4b 55 12 00 19 00  53 ef 00 00 01 00 00 00  ||kKU....S.......|                                                                                                                                                               

These ^^ look like backup ext4 superblocks, written Thu, 07 May 2015
13:41:16 GMT.  If you had uptime from May all the way to November, this
is believable.  And there's more of them scattered below.

> 0a7dc030  45 ae b5 ff 5b 76 73 5b  53 ef 28 ca 3c 11 0c 0f  |E...[vs[S.(.<...|                                                                                                                                                               
> 0d600030  7c 6b 4b 55 12 00 19 00  53 ef 00 00 01 00 00 00  ||kKU....S.......|                                                                                                                                                               
> 0d7a9030  0b f3 69 7e c6 3f 43 15  53 ef 91 f2 36 8f 89 74  |..i~.?C.S...6..t|                                                                                                                                                               
> 11eb9430  73 e9 26 d8 d5 22 07 cd  53 ef 90 13 35 29 92 db  |s.&.."..S...5)..|                                                                                                                                                               
> 12b80030  7c 6b 4b 55 12 00 19 00  53 ef 00 00 01 00 00 00  ||kKU....S.......|                                                                                                                                                               
> 15af5830  60 dc 27 cc 15 97 82 6d  53 ef ab b0 77 a3 84 15  |`.'....mS...w...|                                                                                                                                                               
> 18100030  7c 6b 4b 55 12 00 19 00  53 ef 00 00 01 00 00 00  ||kKU....S.......|                                                                                                                                                               
> 1e8e2030  c1 7a d1 05 cd a8 e0 c2  53 ef f6 7a 9c 33 50 1f  |.z......S..z.3P.|                                                                                                                                                               
> 1f60ac30  48 3c 15 58 ad ef d9 15  53 ef 5b 18 c7 0c 81 1d  |H<.X....S.[.....|                                                                                                                                                               
> 1fccf430  eb 93 ad 0e dc 75 56 3b  53 ef 6e d4 14 ab 2a 6d  |.....uV;S.n...*m|                                                                                                                                                               
> 267ccc30  3c 24 c2 5b 10 a4 9e f5  53 ef bf e1 7f 24 c6 a0  |<$.[....S....$..|                                                                                                                                                               
> 27e15c30  03 07 98 da d5 86 d6 4a  53 ef 20 93 89 b0 3f de  |.......JS. ...?.|                                                                                                                                                               
> 287bdc30  c1 6c 79 2f 8b e0 72 65  53 ef ed f8 92 5d 56 e6  |.ly/..reS....]V.|                                                                                                                                                               
> 2b843830  ab ad 5c 9a 3b e1 c5 22  53 ef ef 8d 1f a8 0f ff  |..\.;.."S.......|                                                                                                                                                               
> 2cac8030  7b 6d 61 51 b9 45 58 87  53 ef 30 13 39 6e 2d 9b  |{maQ.EX.S.0.9n-.|                                                                                                                                                               
> 35b55030  38 e4 b9 f2 9f 54 b2 2b  53 ef a0 b8 a6 4d f4 4b  |8....T.+S....M.K|                                                                                                                                                               
> 362b7030  ec 54 b8 8d 9e b0 73 88  53 ef 45 22 58 6e 58 a5  |.T....s.S.E"XnX.|                                                                                                                                                               
> 383f0830  0b 36 cd 48 d3 a0 5c 5a  53 ef 28 8a e3 7e 28 e2  |.6.H..\ZS.(..~(.|                                                                                                                                                               
> 40db5830  99 22 6a bd 33 f2 39 99  53 ef 86 e4 70 e8 bd d6  |."j.3.9.S...p...|                                                                                                                                                               
> 42b80030  7c 6b 4b 55 12 00 19 00  53 ef 00 00 01 00 00 00  ||kKU....S.......|                                                                                                                                                               
> 4681d430  38 7b 67 9b a5 2e 96 44  53 ef 35 fd c9 e2 a9 71  |8{g....DS.5....q|                                                                                                                                                               
> 48100030  7c 6b 4b 55 12 00 19 00  53 ef 00 00 01 00 00 00  ||kKU....S.......|                                                                                                                                                               
> 4a403c30  b1 25 08 7b 88 0a 69 3f  53 ef fc 93 c8 46 93 f3  |.%.{..i?S....F..|                                                                                                                                                               
> 4bcad030  f4 bf 6f fc 48 34 d6 72  53 ef bb c5 69 d0 d7 27  |..o.H4.rS...i..'|                                                                                                                                                               
> 4eed7830  68 32 c6 73 f4 f0 57 68  53 ef d5 5c 3a 3b ca 49  |h2.s..WhS..\:;.I|                                                                                                                                                               
> 51807430  46 f8 72 b4 ac 58 46 b9  53 ef ad aa d3 de 8c 94  |F.r..XF.S.......|                                                                                                                                                               
> 51ad4430  28 16 ed f1 f2 00 98 b8  53 ef e3 04 2c ad e9 70  |(.......S...,..p|                                                                                                                                                               
> 55491430  d7 3f 87 00 15 70 40 bc  53 ef 7d 18 a1 6e 67 e8  |.?...p@.S.}..ng.|                                                                                                                                                               
> 576ed030  2a f0 e4 4c ad 4a 19 a4  53 ef d8 3c bd 00 c7 7f  |*..L.J..S..<....|                                                                                                                                                               
> 62e40c30  6d 1e 1e 64 c6 29 fc 6c  53 ef 57 bd 2d 99 ca 87  |m..d.).lS.W.-...|                                                                                                                                                               
> 63d2d030  ab bc c3 76 a9 3e af 4c  53 ef 6e 72 11 6a cc 34  |...v.>.LS.nr.j.4|
> 6acc0c30  37 db ad 49 4c 9a 72 4a  53 ef 3b 6e 8f bb 18 6e  |7..IL.rJS.;n...n|
> 75359830  7c d8 e0 62 51 e1 70 fa  53 ef 5f a2 ea c1 92 0f  ||..bQ.p.S._.....|
> 799fb430  77 b2 62 cb 73 8c b5 48  53 ef 76 49 59 fc 97 ad  |w.b.s..HS.vIY...|
> 7badc430  3d 3c 7c 72 b5 0f 6c f1  53 ef cb 6d 6e 69 d4 e5  |=<|r..l.S..mni..|
> 81413c30  a8 58 4a be a2 f6 36 3a  53 ef 0c 7b 31 3c bf 8a  |.XJ...6:S..{1<..|
> 82b80030  7c 6b 4b 55 12 00 19 00  53 ef 00 00 01 00 00 00  ||kKU....S.......|
> 85182430  ef 21 64 5f 3b c4 46 7f  53 ef 9d fc 88 72 e8 d1  |.!d_;.F.S....r..|
> 86245030  86 ca b9 f4 cd ff a9 cd  53 ef ad 62 a8 e8 fb 0b  |........S..b....|
> 864d1430  6c a0 5b 34 9d e6 4b 97  53 ef 87 9b ea 8e 4f ac  |l.[4..K.S.....O.|
> 8cea9030  53 43 cc c0 93 a9 69 9b  53 ef 65 9f ee 82 75 ca  |SC....i.S.e...u.|
> 940c0030  32 8d 87 1f 79 f2 f5 13  53 ef bf 0f 9b a6 e8 6a  |2...y...S......j|
> 9bcd4430  e3 da 47 63 bc eb 10 54  53 ef 54 29 4d 82 07 d2  |..Gc...TS.T)M...|
> aa4e9430  b8 09 b8 5a ea 6e ab ad  53 ef 6f 0e 10 01 5f aa  |...Z.n..S.o..._.|
> b5343830  37 3a 8b f3 c9 bc dd 77  53 ef 38 9a f1 08 13 0e  |7:.....wS.8.....|
> b7c0b030  f6 cc 47 b4 b5 a7 cc 1b  53 ef 78 f8 9e 1e de 7d  |..G.....S.x....}|

> 
> sdd1:
> http://pastebin.com/5QxGuGGY

> 00000430  7b f0 ca 4d 15 00 21 00  53 ef 01 00 01 00 00 00  |{..M..!.S.......|
> 0171c430  b2 44 ab 17 a0 1e b0 43  53 ef c7 5c fb 83 95 47  |.D.....CS..\...G|
> 01734830  a7 81 e8 1d 83 04 88 1c  53 ef b4 e2 11 18 a9 90  |........S.......|
> 06715c30  16 cd a6 93 42 5a f1 21  53 ef 06 3c ea ac 96 2f  |....BZ.!S..<.../|
> 0942cc30  4b 9d 1a a7 04 46 2d 55  53 ef 3f 8c 1e 25 26 94  |K....F-US.?..%&.|
> 0a46b430  c4 43 bc ab 49 30 46 93  53 ef 63 8e ff c9 0e c8  |.C..I0F.S.c.....|
> 0cd7d030  8c 26 bd 38 15 80 e9 d6  53 ef 2a 24 4f 4f a8 af  |.&.8....S.*$OO..|
> 11faec30  7a 7d 11 5e bc b0 c7 4c  53 ef e7 81 e5 30 f2 7a  |z}.^...LS....0.z|
> 187cac30  d4 ce cf bc a5 fc c5 fa  53 ef 8d a6 0e ef 87 7d  |........S......}|
> 1df88030  96 4a 06 8f 63 89 90 9c  53 ef de 53 04 17 ea a6  |.J..c...S..S....|
> 1ec74830  95 08 9e 18 78 27 3c d2  53 ef 4f a8 d8 9b 5c 6a  |....x'<.S.O...\j|
> 1f7ef830  96 37 d6 93 a2 cb ff 1f  53 ef 6d e8 fc 5d 7d 19  |.7......S.m..]}.|
> 22c9a830  6d 89 a4 e7 66 d6 0f 57  53 ef 2c 39 47 c8 a7 cf  |m...f..WS.,9G...|
> 241d3c30  d6 67 39 79 e0 ef 6e a1  53 ef 28 00 fe 1d 38 89  |.g9y..n.S.(...8.|
> 243a8830  50 76 ae 32 e1 ae 73 c4  53 ef b8 30 2a ce cc 2e  |Pv.2..s.S..0*...|
> 278ed430  4b a0 32 0f e8 06 41 ce  53 ef da c0 a4 6b 57 31  |K.2...A.S....kW1|
> 2c1fac30  84 52 60 2c 5e 93 52 45  53 ef 30 37 98 ec c2 56  |.R`,^.RES.07...V|
> 2e503030  22 b6 6b 9b c1 4b 20 7f  53 ef ed 5a 35 34 a0 a5  |".k..K .S..Z54..|
> 390cd830  66 08 74 9b b7 e9 24 16  53 ef 77 71 11 4e b3 28  |f.t...$.S.wq.N.(|
> 3a85ac30  4b 5c 7d fc c0 99 29 7c  53 ef 58 cf ff 1a cf ff  |K\}...)|S.X.....|
> 66c15430  c1 29 7f aa 5e c2 9f ec  53 ef b5 32 ee 3d de ee  |.)..^...S..2.=..|
> 76755830  bb 69 6b 92 cb ba bd 6d  53 ef d6 65 4b 31 ad 03  |.ik....mS..eK1..|
> 851a4830  5c 81 d7 1b d3 2a 5e 83  53 ef 98 d4 5b 2e 4b 2b  |\....*^.S...[.K+|
> 8fda7030  4d f6 ca ba a9 34 f7 87  53 ef 7f 59 7b 70 cb e5  |M....4..S..Y{p..|
> 9cabe030  32 ee 5f 43 4d 11 0e 79  53 ef a5 60 1f c8 cb ac  |2._CM..yS..`....|
> a1293c30  3d 51 81 9a 08 a2 e0 c7  53 ef b0 ec 68 cd 27 50  |=Q......S...h.'P|
> a595bc30  40 70 9e 35 40 fe b7 af  53 ef 52 10 a9 d7 ca 81  |@p.5@...S.R.....|
> a8d12c30  2c c1 b5 c5 72 88 3d bb  53 ef bf de b8 ae b8 a5  |,...r.=.S.......|
> aa15dc30  db b5 ed c3 ee a7 6b c2  53 ef f1 1d 7f 59 69 95  |......k.S....Yi.|
> b963d830  30 a6 25 18 e4 55 b7 3b  53 ef 67 5b 25 59 76 31  |0.%..U.;S.g[%Yv1|
> baefc830  07 88 0f 60 34 a7 8d f1  53 ef 0b 5e 68 21 7f 4d  |...`4...S..^h!.M|
> bbb7b430  51 00 91 ad b6 c3 89 5b  53 ef cf 10 5c 54 ef ff  |Q......[S...\T..|
> bc850c30  e1 d6 6f 4b 52 26 f3 5c  53 ef 1f fd e7 3e 0e f5  |..oKR&.\S....>..|
> c046cc30  4b ad 54 a6 92 54 91 f7  53 ef b5 1f ea 1d 99 68  |K.T..T..S......h|
> c17c0830  37 63 0e 04 5f 09 9a 9d  53 ef 13 74 94 c0 0f eb  |7c.._...S..t....|
> c8080030  98 fd 13 ca db d8 86 59  53 ef 08 ce 0e 98 ec 76  |.......YS......v|
> cd36cc30  4b ad 54 a6 92 54 91 f7  53 ef b5 1f ea 1d 99 68  |K.T..T..S......h|
> d03e7830  f8 18 1d e9 70 61 5a e7  53 ef 3c d6 71 90 c2 23  |....paZ.S.<.q..#|
> d25fa430  a2 00 05 d1 6c e6 23 6d  53 ef 39 55 49 06 64 48  |....l.#mS.9UI.dH|
> d3e86430  b8 c8 8c 86 4b 03 1c 42  53 ef e1 16 79 c6 30 48  |....K..BS...y.0H|
> d7d0e030  64 dd c2 20 da e9 fe c1  53 ef e0 b7 04 71 be ed  |d.. ....S....q..|
> d7d79430  e0 3f 7f f3 16 48 3d ac  53 ef 4a 63 25 69 5f 6f  |.?...H=.S.Jc%i_o|
> d84e6c30  f2 de 6a 35 5d 41 94 d7  53 ef e9 39 2c f1 fb cd  |..j5]A..S..9,...|
> ddd98c30  ca 84 3a 09 8b b0 fb ee  53 ef 45 0f 07 04 b6 04  |..:.....S.E.....|
> ea2e1030  50 be a2 62 3c f0 db 68  53 ef ff a6 85 32 77 e5  |P..b<..hS....2w.|
> ef0b9830  84 5e c3 0d 52 48 76 53  53 ef e8 24 96 73 12 ac  |.^..RHvSS..$.s..|
> f8fe9830  f6 e8 24 f7 c2 9f 45 9a  53 ef 98 74 4b 5f 5d 80  |..$...E.S..tK_].|
> fac0e830  c2 56 65 0c e1 c0 cc ef  53 ef 12 18 b3 89 c4 2d  |.Ve.....S......-|
> 1034b7c30  ea 4b 6a 1b 9a 63 fc 9d  53 ef aa 53 5b e7 43 5f  |.Kj..c..S..S[.C_|
> 10a378430  ff d3 d8 4a 5f 7d 52 c0  53 ef 5b 50 66 f1 38 f5  |...J_}R.S.[Pf.8.|

Nothing here ^^.

> 
> sde1:
> http://pastebin.com/CAC8Pkt9

> 00000430  d5 cb 62 51 05 00 24 00  53 ef 01 00 01 00 00 00  |..bQ..$.S.......|
> 00100430  28 ab 3f 56 06 00 19 00  53 ef 01 00 01 00 ef 1a  |(.?V....S.......|

Another candidate for a first disk, with offset 2048.  Also written
Sun, 08 Nov 2015 20:06:00 GMT.  Either sdc or sde is your first disk.
The other is parity, which is the last disk on the first stripe, with
zeros in the matching offsets of the other two disks.

> 04975030  22 e0 84 41 68 0b 2a 3e  53 ef fa 4d ab cf 92 78  |"..Ah.*>S..M...x|
> 04d09830  09 96 1e 05 dd 53 70 02  53 ef c8 99 81 bb db 08  |.....Sp.S.......|
> 07554c30  ad fb d5 76 b9 04 8b ab  53 ef 6d 9e 7d 92 61 2b  |...v....S.m.}.a+|
> 08100030  7c 6b 49 55 12 00 19 00  53 ef 00 00 01 20 76 ed  ||kIU....S.... v.|

Another possible backup superblock, written Wed, 06 May 2015 01:16:44 GMT.
With more like it below.

> 0f3e5830  1b 2b 97 41 57 15 59 12  53 ef 5f f9 72 45 d5 67  |.+.AW.Y.S._.rE.g|
> 10e04430  32 95 f4 68 40 8b e0 b4  53 ef c8 fe 68 e4 05 3f  |2..h@...S...h..?|
> 17fac430  cb de dc 31 a5 e4 56 b9  53 ef 76 e5 b9 6c cd 58  |...1..V.S.v..l.X|
> 18100030  7c 6b 49 55 12 00 19 00  53 ef 00 00 01 20 76 ed  ||kIU....S.... v.|
> 1f9a1030  f3 95 67 eb f4 fb cb 82  53 ef a4 47 b5 aa 8f ab  |..g.....S..G....|
> 21ecf830  af 55 bc 3f 03 10 fa c6  53 ef 27 50 7a a1 0b 7d  |.U.?....S.'Pz..}|
> 25a48030  f0 f4 9e 58 8e a8 dc e8  53 ef 8f ee f7 5f f2 96  |...X....S...._..|
> 2693e830  14 01 94 72 71 13 73 fd  53 ef 59 75 aa 11 9d 0a  |...rq.s.S.Yu....|
> 26daf430  a9 96 ae a0 5d 4a 71 ad  53 ef e2 64 ee d6 bc ec  |....]Jq.S..d....|
> 2c3e2830  b5 77 fe 66 e0 9a 65 94  53 ef 2e 6e 4e dc 3d 4c  |.w.f..e.S..nN.=L|
> 2d091030  a5 49 93 09 a1 21 16 11  53 ef a9 48 0a 30 43 9c  |.I...!..S..H.0C.|
> 2dc5a030  b7 fd b1 20 3e 74 8b d6  53 ef 4f 78 06 30 88 69  |... >t..S.Ox.0.i|
> 2e604430  89 32 cb a1 9e 8e 87 37  53 ef a8 74 92 be 8f 57  |.2.....7S..t...W|
> 2ea74430  86 8d 2e 0e 11 8f 26 74  53 ef a1 8b 25 ff fb e2  |......&tS...%...|
> 35fdb430  ff 6d 5c 78 cd 3a 8c c3  53 ef 0a ac 87 9f a4 97  |.m\x.:..S.......|
> 399efc30  63 35 60 c7 52 2d 42 8d  53 ef 13 bd 8b 89 df bd  |c5`.R-B.S.......|
> 43eaa030  5b 05 c1 f4 ae b1 b9 b3  53 ef 14 a5 8e 4a ce 1e  |[.......S....J..|
> 48100030  7c 6b 49 55 12 00 19 00  53 ef 00 00 01 20 76 ed  ||kIU....S.... v.|
> 4c538830  67 7e 80 bd 68 d0 d8 d4  53 ef 4d 53 20 e6 40 51  |g~..h...S.MS .@Q|
> 4f810c30  46 0f 08 65 ab e1 fe 6a  53 ef 9c 7b 26 64 bf ff  |F..e...jS..{&d..|
> 59cf1430  df 83 79 60 ff 96 08 6d  53 ef 37 ef 98 a6 b6 29  |..y`...mS.7....)|
> 5f865030  59 fc ab 10 94 83 66 55  53 ef 75 da 43 d0 e8 c1  |Y.....fUS.u.C...|
> 6d536030  59 84 da 0c d1 7b 07 47  53 ef 10 cf 28 ea 73 6d  |Y....{.GS...(.sm|
> 6df76430  d1 3e 2e 1f 15 0e b6 73  53 ef 44 16 7a e7 14 fa  |.>.....sS.D.z...|
> 715f0430  bc bf 2c 95 a3 0d cb 9d  53 ef 4a 32 2d 40 ff f3  |..,.....S.J2-@..|
> 721f5c30  cb 64 cb ea 0a 89 90 a7  53 ef 5e 8f ff fb b0 6c  |.d......S.^....l|
> 7a702c30  2b 84 11 5a 9a 9e 14 42  53 ef 0e ec d6 b5 02 c4  |+..Z...BS.......|
> 7fa5d430  93 0a 2d e1 20 b5 d6 b4  53 ef 07 46 95 9f cb 1c  |..-. ...S..F....|
> 889fcc30  f0 d1 61 a4 73 79 ab b3  53 ef 06 90 38 a1 2a 25  |..a.sy..S...8.*%|
> 89611030  8e bd c1 20 bc 77 91 e9  53 ef b3 73 89 dc 6c 4a  |... .w..S..s..lJ|
> 8e67cc30  43 11 37 a8 86 37 b2 66  53 ef 14 a4 a8 a3 91 15  |C.7..7.fS.......|
> a8029030  ae 74 9a f0 03 c7 66 80  53 ef 3f 30 4e 83 a4 c2  |.t....f.S.?0N...|
> a82ec030  ca 76 cc 64 79 6d 57 25  53 ef 46 65 e0 b7 08 7a  |.v.dymW%S.Fe...z|
> addb3430  ff e7 ee 6b 67 9d 9e d7  53 ef e2 da b9 cf 5b f6  |...kg...S.....[.|
> b9411430  4a 01 00 3f c9 e2 22 15  53 ef dd 6f 45 ad fb f7  |J..?..".S..oE...|
> baf98030  ff fe e7 41 03 36 f7 11  53 ef ed fc 14 02 34 f0  |...A.6..S.....4.|
> bb6f5830  84 75 62 8d 11 48 20 f4  53 ef 04 36 62 71 20 d2  |.ub..H .S..6bq .|
> bcc59830  b5 e4 fd f7 b2 fe a3 30  53 ef 7a 0a b1 2e a2 9a  |.......0S.z.....|
> c0e42030  6e d6 35 c8 53 64 55 a3  53 ef b1 39 d4 78 99 c2  |n.5.SdU.S..9.x..|
> c57a3c30  2f 51 ce a9 9a 5f c9 4d  53 ef 04 d4 eb 8f 52 e6  |/Q..._.MS.....R.|
> ccb2e030  12 df 4a ff a6 c6 37 96  53 ef a7 f6 1c d6 ad d1  |..J...7.S.......|
> cfef5030  59 5c 47 9d e3 5b c7 18  53 ef 6e 1a 61 99 95 fe  |Y\G..[..S.n.a...|
> d63c1030  6c 4a f5 0f 8f 97 17 91  53 ef d1 cf 87 65 42 74  |lJ......S....eBt|
> d8100030  7c 6b 49 55 12 00 19 00  53 ef 00 00 01 20 76 ed  ||kIU....S.... v.|

So, we now know your data offset == 2048, with pretty high confidence.
We know the possible order combinations:
  sdc1 sdb1 sdd1 sde1
  sdc1 sdd1 sdb1 sde1
  sde1 sdb1 sdd1 sdc1
  sde1 sdd1 sdb1 sdc1

We don't know the chunk size for sure.  I don't remember when the default
changed from 64 to 512.  I'd try 64 first.

It's possible you could map the standard locations of ext4 superblocks
versus the locations noted above, and work out the order and chunk
size.  I'll leave that as an exercise for you, if you don't want to
just try the various combinations.  :-)

Remember, "fsck -n" after each --create --assume-clean to see if it
works well.

Phil
