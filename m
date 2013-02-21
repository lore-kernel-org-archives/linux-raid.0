From: Stone <stone@heisl.org>
Subject: Re: Brocken Raid & LUKS
Date: Thu, 21 Feb 2013 20:29:42 +0100
Message-ID: <512675A6.1000801@heisl.org>
References: <5123A1CC.2000003@heisl.org> <5123EB92.5090505@turmel.org> <5123EF45.6080405@heisl.org> <5123F7C7.7000406@turmel.org> <5123FB71.3060509@heisl.org> <5124196F.6090000@turmel.org> <512516C2.3010105@heisl.org> <5125184A.6040707@turmel.org> <5125C6E9.4050802@heisl.org> <5125EBFD.3050802@heisl.org> <51262137.3040609@turmel.org> <51262CE0.3000809@heisl.org> <51263785.2010001@turmel.org> <51263D9D.1080002@heisl.org> <51263F7E.7040207@turmel.org> <5126421E.3040702@turmel.org> <51264C18.8000201@heisl.org> <51264E26.9050100@turmel.org> <51264EBF.9090000@heisl.org> <51264F7F.3020508@turmel.org> <512650A1.7070103@heisl.org> <51265132.7070706@turmel.org> <512656B5.4090505@heisl.org> <51265824.4030407@heisl.org> <51265B0B.9020108@turmel.org> <51265DA7.2030209@heisl.org> <512660B9.8090609@turm
 el.org> <5126629A.1090002@heisl.org> <51266360.9030402@turmel.org> <5126678D.9030101@heisl.org> <51266D73.5020700@turmel.org> <51267192.6090205@heisl.org> <51267467.9040603@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51267467.9040603@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Am 21.02.2013 20:24, schrieb Phil Turmel:
> On 02/21/2013 02:12 PM, Stone wrote:
>
>>>> ok. with --chunk=64 i cannot open the luks.
>>>> in witch steps (chunk) should i continue?
>>> That is a big surprise.  The luks signature should not move with chunk
>>> size.  Please use "mdadm -E /dev/sdc1" to recheck your data offset.
>>>
>>> If that wasn't it, please show the hexdump for the entire luks
>>> signature.  I'd like to see its payload offset.
>>>
>>> Also, if you go back to --chunk=512, open the luks, you could run the
>>> following command to find possible superblock locations:
>>>
>>> hexdump -C /dev/mapper/md2_nas |egrep '^[0-9a-f]+30  .+  53 ef' >sb.lst
>>>
>>> (May take a long time to read the whole array)
>>>
>>> Phil
>> with --chunk=512 i can open the luks but i cannot found a good superblock.
>> yes i can run the hexdump but i think this runs 8 hours or longer.
>> start the hexdump?
>> can i try more today?
> Run the hexdump for half an hour or so.  If it doesn't find some
> candidates in that timeframe, it probably won't.
>
> I've never crashed a luks partition like this, so I'm feeling around a
> bit.  You should understand that luks normally uses "cipher block
> chaining" salted with the sector number.  If you get the blocks out of
> order (wrong chunk size or offset or layout), those sectors won't
> decrypt correctly.  luksOpen won't detect this.
>
> You may have to try many chunk sizes, verifying the data offset every
> time, trying to find the one that will work.
>
> Phil
ok i let the hexdump running for 30-60 min and then i check mehr chunk.
if i can open the luks i should check again the superblocks?
fsck.ext4 -n -b <superblock> /dev/mapper/md2_nas ?

but i see there is a result from hex:

cat sb.lst
011e0830  17 0d bb 6e b2 37 9f f8  53 ef 5b 62 6d ab 0f b8 
|...n.7..S.[bm...|
02a1c830  91 31 32 1a 35 c9 96 ab  53 ef 02 93 05 f2 b7 65 
|.12.5...S......e|
03c48e30  dc 46 07 a9 2d ac 96 36  53 ef 61 48 d1 c7 63 05 
|.F..-..6S.aH..c.|
04c28830  7f 36 db 0a 5a 65 6c 78  53 ef 3a 31 41 83 da c2 
|.6..ZelxS.:1A...|
04c60830  9f 32 a6 e1 1a cc ef dc  53 ef 59 bd 51 ac d0 01 
|.2......S.Y.Q...|
055be030  4b ee f1 d0 8e 36 15 67  53 ef 45 75 a9 cd 3c b5 
|K....6.gS.Eu..<.|
058aa530  82 91 1f 13 6f fa 60 2f  53 ef 1a 68 80 bc a5 0c 
|....o.`/S..h....|
05def830  db fc 8d a1 f3 49 c9 a6  53 ef cf 03 f9 e3 18 00 
|.....I..S.......|
06016630  5c 9b 31 ed 40 74 ad a5  53 ef c3 a8 b5 74 e2 25 
|\.1.@t..S....t.%|
060caf30  b5 aa cd 06 57 d3 22 6c  53 ef 04 54 d6 2a 74 3f 
|....W."lS..T.*t?|
071f0530  cb 6b 07 74 60 37 e9 34  53 ef ba fa cf 2d 69 58 
|.k.t`7.4S....-iX|
087f8c30  95 57 29 2c ca d8 02 0b  53 ef 05 c4 44 17 50 1c 
|.W),....S...D.P.|
0977ac30  32 61 7d 49 fc dc 61 a0  53 ef 53 95 96 88 25 65 
|2a}I..a.S.S...%e|
0be5a330  3f 05 57 2e 8e fd 55 44  53 ef 20 0f f1 a0 5b a0 |?.W...UDS. 
...[.|
0c5de030  65 2e 3a 18 44 b3 65 37  53 ef 24 f2 96 f9 99 dc 
|e.:.D.e7S.$.....|
0d3b8230  2f eb a0 08 d3 3e 32 70  53 ef 3b 5a 0c 7f c3 51 
|/....>2pS.;Z...Q|
0d46b930  d6 e2 c5 23 61 8c b5 26  53 ef 71 3f f3 36 df f6 
|...#a..&S.q?.6..|
0da68330  2a f2 24 fd df 4d 10 71  53 ef 8c b7 da fe 28 b3 
|*.$..M.qS.....(.|
0dfb9730  cc 4a a3 7f 99 d0 9c 59  53 ef f6 78 c4 5e 7c fd 
|.J.....YS..x.^|.|
0e6be030  ae 13 5f 1a 79 e6 a1 33  53 ef 7f e3 07 ef 6e 38 
|.._.y..3S.....n8|
0ee9e130  78 2a b9 8c 17 e8 0b b8  53 ef ad c8 d8 4b 3a 1d 
|x*......S....K:.|
0fe93130  f3 1f 02 69 6f f8 a9 f7  53 ef ee 2a 31 7f da f8 
|...io...S..*1...|
128c7130  45 5b 93 6e 5f 64 26 3c  53 ef 6c 1e be d0 f1 9b 
|E[.n_d&<S.l.....|
12ad4430  94 c0 9b e8 ff 6a 6e 63  53 ef 2d d3 95 f9 3a 64 
|.....jncS.-...:d|
13c76d30  ac 31 88 2b 08 ba 34 6b  53 ef 46 c3 3e 9b c5 05 
|.1.+..4kS.F.>...|
150ef030  1e 63 6d 93 c4 57 50 ac  53 ef 72 a4 62 98 9f f7 
|.cm..WP.S.r.b...|
166ec830  ef 91 29 77 c3 a6 8a 61  53 ef 86 15 8f 2d a9 38 
|..)w...aS....-.8|
16f96d30  1f 05 08 5a 64 df fa 09  53 ef b9 bc 21 85 c4 ff 
|...Zd...S...!...|
19c0b430  e4 a4 fd 26 10 90 ae 00  53 ef 3d b2 06 44 77 2a 
|...&....S.=..Dw*|
19c11d30  83 fd 70 6e 84 5e e9 42  53 ef b5 f2 34 02 e6 76 
|..pn.^.BS...4..v|
1b13d030  9c 1d 5e 72 ff 07 04 0c  53 ef 80 6f eb 9d 68 33 
|..^r....S..o..h3|
1b39f330  bf 1a 86 a0 43 fb c7 fd  53 ef 8f 55 7f 9f bf 46 
|....C...S..U...F|
1c2a9c30  a0 8d 51 34 d0 f6 21 6f  53 ef f4 5a 1f a1 03 9f 
|..Q4..!oS..Z....|
1c8d1630  e9 f3 f3 4b 3e dc 13 cc  53 ef 4b 75 a9 1e fb 74 
|...K>...S.Ku...t|
1e361d30  b8 c9 1a 14 16 c5 ba da  53 ef 22 fd 79 bd da 13 
|........S.".y...|
1f628330  22 b7 78 3b 71 94 67 38  53 ef a7 1a 5d 1c 0c 11 
|".x;q.g8S...]...|
21e76230  40 b9 f7 74 93 7a db 99  53 ef 67 fd 9a f2 38 4d 
|@..t.z..S.g...8M|
237eaf30  20 81 19 51 bc 80 2a 92  53 ef 02 c9 c0 6e a4 39  | 
..Q..*.S....n.9|
27f80030  80 91 df 4d 0d 00 22 00  53 ef 00 00 01 00 00 00 
|...M..".S.......|
2aa58330  c7 ba 01 74 ae 83 a9 5c  53 ef 33 50 73 b4 80 67 
|...t...\S.3Ps..g|
2fe5fa30  65 e8 32 40 7d 63 ce d2  53 ef e3 14 29 4b bf eb 
|e.2@}c..S...)K..|
3021a330  c8 52 86 6a c4 83 4b 4f  53 ef f0 48 27 8c e4 6b 
|.R.j..KOS..H'..k|
30bf6e30  66 64 fb 7c 6d 67 e1 ef  53 ef 9d e4 88 ab 7c 28 
|fd.|mg..S.....|(|
32d58f30  ce 79 84 2c 41 54 b7 c7  53 ef c7 c9 b8 7a a9 55 
|.y.,AT..S....z.U|
3456cc30  63 55 26 a5 8d 2d e7 b5  53 ef 6e c2 15 ea 2c de 
|cU&..-..S.n...,.|
36108630  ba 36 3b 45 89 e4 f8 dd  53 ef fc 17 8f 8c 7d f6 
|.6;E....S.....}.|
36c1fe30  36 0a 62 79 11 78 cd a3  53 ef 93 a3 ac 71 fe 2f 
|6.by.x..S....q./|
37601c30  f8 51 e8 5b 4b a9 33 df  53 ef e7 59 b7 15 d4 8e 
|.Q.[K.3.S..Y....|
37f80030  80 91 df 4d 0d 00 22 00  53 ef 00 00 01 00 00 00 
|...M..".S.......|
3a0be530  c5 2a 5a 11 34 a3 5e 3d  53 ef d2 98 85 cb 9c 60 
|.*Z.4.^=S......`|
3c7bcb30  a8 32 d6 84 10 24 a9 92  53 ef 53 ce c5 17 46 a1 
|.2...$..S.S...F.|
3e763830  d0 2e e5 e4 5d 12 50 ff  53 ef 2a 3f 54 89 66 b9 
|....].P.S.*?T.f.|
40eb1830  82 45 f5 29 50 11 40 27  53 ef 81 97 c0 d2 40 09 
|.E.)P.@'S.....@.|
42d6bb30  9f 97 47 d4 27 d1 0a 5b  53 ef 5d 98 12 20 2e 79 
|..G.'..[S.].. .y|
44dc8b30  50 57 55 89 43 04 e8 95  53 ef ff 8b 43 04 8d 14 
|PWU.C...S...C...|
4af7d430  54 67 6d 65 f2 54 4c e4  53 ef 42 8a 57 73 f2 7b 
|Tgme.TL.S.B.Ws.{|
4b49b130  f4 d6 92 45 61 fa f4 c5  53 ef be 9d 89 f5 cd 99 
|...Ea...S.......|
4b4d6230  ae 93 05 cc 3c 7d fe 6e  53 ef 66 10 ff 30 b9 24 
|....<}.nS.f..0.$|
4bd02830  35 5c 44 a7 4e 15 b5 87  53 ef 7b 3f 9b 75 6d ab 
|5\D.N...S.{?.um.|
4cf5ad30  08 fc 34 b1 00 1e e0 af  53 ef 8b 7b 18 99 73 1a 
|..4.....S..{..s.|
4d31e130  e8 d9 ef 6a a2 ba d6 d5  53 ef f5 92 f2 55 4c ca 
|...j....S....UL.|
4e887930  7b a0 ce fa fe 6d ad a1  53 ef 3a b5 5f f0 07 da 
|{....m..S.:._...|
50687b30  7b 98 1c d3 49 59 e4 ca  53 ef 46 69 0b 3e ee c3 
|{...IY..S.Fi.>..|
5083e630  53 8c 5e 60 0e 93 e3 94  53 ef d6 e0 85 06 26 d1 
|S.^`....S.....&.|
50dd0b30  f4 8d 43 b9 91 74 a6 de  53 ef c9 a7 d6 79 d6 e5 
|..C..t..S....y..|
50efa530  2d af 75 74 96 f0 29 f7  53 ef 5f 40 94 9d d7 31 
|-.ut..).S._@...1|
519ed830  4b 5b 76 50 fb 5a e7 f8  53 ef 79 ad 17 0c 41 d7 
|K[vP.Z..S.y...A.|
52968e30  16 27 4a af 10 70 b9 a7  53 ef fc 76 4d e1 a5 d3 
|.'J..p..S..vM...|
53df7430  4a 34 16 33 78 40 16 07  53 ef 87 80 14 ad 03 be 
|J4.3x@..S.......|
545b3e30  38 d4 7c f7 52 62 0d a4  53 ef 9e 0d f4 f8 3e 4c 
|8.|.Rb..S.....>L|
550dda30  4e 80 ee c9 75 5a bd 8d  53 ef c5 1d 9e 51 ad 70 
|N...uZ..S....Q.p|
55afb530  a9 de 66 d9 a6 ee 35 a8  53 ef 36 61 69 c1 6a c4 
|..f...5.S.6ai.j.|
55baf430  ad 20 92 a6 f7 f1 fb 43  53 ef 10 03 07 9e ba 38  |. 
.....CS......8|
55ca7c30  9c 00 6c 6a 69 29 ae cc  53 ef a0 6e 2e 2c 48 67 
|..lji)..S..n.,Hg|
56203730  6d ef f0 ae 12 61 9e 7f  53 ef e6 cf 79 a9 e6 a2 
|m....a..S...y...|
567d3030  37 83 4d f6 fa 79 2d f1  53 ef b4 19 dc 31 41 ee 
|7.M..y-.S....1A.|
5939bf30  91 7f f7 ed 44 4b f1 f9  53 ef fc f3 44 fd 7f 65 
|....DK..S...D..e|
5a600030  39 3b 64 91 2a 62 4f 62  53 ef 54 e2 0b 9f 77 04 
|9;d.*bObS.T...w.|
5bffaa30  54 6d 0f 30 16 20 71 88  53 ef 72 2a 89 bb e9 d8  |Tm.0. 
q.S.r*....|
5cd40e30  60 dc 99 6c d2 f7 4e da  53 ef 27 7f 15 e1 6a 6b 
|`..l..N.S.'...jk|
5ce11c30  5d 97 d8 49 a9 c8 ea bc  53 ef c1 ac b2 5c 3c 58 
|]..I....S....\<X|
5d8f6d30  c3 bc 16 0b 85 f8 89 37  53 ef 60 be 22 23 95 01 
|.......7S.`."#..|
5e3b9630  4b 49 18 a9 32 b5 c7 2b  53 ef 0e 43 e3 d3 7f 1c 
|KI..2..+S..C....|
5e950430  f2 f7 b9 3b 9c 1f 8b 69  53 ef af d6 c2 31 6b 0e 
|...;...iS....1k.|
5ea3e030  66 2e f7 40 61 41 50 de  53 ef 56 01 9a 21 a0 33 
|f..@aAP.S.V..!.3|
5f638d30  42 b1 ec 8a cc 57 8b c9  53 ef df 41 d5 9d 9d 6d 
|B....W..S..A...m|
6a241830  16 e8 c4 39 bb 50 96 f8  53 ef 60 62 90 e6 4e b3 
|...9.P..S.`b..N.|
6a249f30  17 d6 77 d3 62 b2 c3 83  53 ef b4 9d ff d7 07 15 
|..w.b...S.......|
6a8e6230  3e 78 55 da 76 e1 55 51  53 ef 2b 21 79 fc 75 cd 
|>xU.v.UQS.+!y.u.|
6b166730  07 db 8d 18 b8 69 cc 22  53 ef 2b 4f dd df b8 56 
|.....i."S.+O...V|
6b82f830  61 45 5f 5a bf cb 25 10  53 ef b9 e3 11 2a e4 a5 
|aE_Z..%.S....*..|
6c3f3d30  d3 a4 cc a5 fd bd d4 dd  53 ef 5e eb 26 ff 39 6e 
|........S.^.&.9n|
6cd42f30  4f c5 1f 2b 13 3a 19 b8  53 ef 67 59 70 1b 11 65 
|O..+.:..S.gYp..e|
6d40f130  76 99 1f 14 1a 8a 33 58  53 ef c0 3b de 8e 97 0f 
|v.....3XS..;....|
6d6cbb30  82 6a 37 4b 34 59 64 1c  53 ef 64 c2 29 88 50 31 
|.j7K4Yd.S.d.).P1|
6e606730  dc 4d 43 71 ff 2b 71 68  53 ef 9d 41 16 0f 91 10 
|.MCq.+qhS..A....|
6e909e30  96 0c 7c be 2a f3 a4 e9  53 ef fc 00 20 2f 32 32 |..|.*...S... 
/22|
72d0df30  1b b5 d0 79 e3 33 76 22  53 ef 4e d9 14 3b 17 93 
|...y.3v"S.N..;..|
74a44b30  03 87 a4 b2 3a 73 22 03  53 ef 54 6b 4d ed 9d a8 
|....:s".S.TkM...|
7582bc30  2d 50 cb 49 10 c8 c8 4e  53 ef 04 79 4a 8a d1 9c 
|-P.I...NS..yJ...|
7599fa30  1a 25 29 c3 32 6c 30 55  53 ef 99 cf 29 20 e5 81 
|.%).2l0US...) ..|
76a0ed30  86 4f 8d 18 da fc af f1  53 ef c3 c1 93 c4 a5 fa 
|.O......S.......|
76b63f30  e1 9d e8 e4 0b 1e 14 80  53 ef 11 99 e7 58 37 b9 
|........S....X7.|
79eec330  a2 5e 93 f9 db f3 f1 85  53 ef bf fd 36 13 b1
