From: Stone <stone@heisl.org>
Subject: Re: Brocken Raid & LUKS
Date: Thu, 21 Feb 2013 20:46:04 +0100
Message-ID: <5126797C.8090105@heisl.org>
References: <5123A1CC.2000003@heisl.org> <5123EF45.6080405@heisl.org> <5123F7C7.7000406@turmel.org> <5123FB71.3060509@heisl.org> <5124196F.6090000@turmel.org> <512516C2.3010105@heisl.org> <5125184A.6040707@turmel.org> <5125C6E9.4050802@heisl.org> <5125EBFD.3050802@heisl.org> <51262137.3040609@turmel.org> <51262CE0.3000809@heisl.org> <51263785.2010001@turmel.org> <51263D9D.1080002@heisl.org> <51263F7E.7040207@turmel.org> <5126421E.3040702@turmel.org> <51264C18.8000201@heisl.org> <51264E26.9050100@turmel.org> <51264EBF.9090000@heisl.org> <51264F7F.3020508@turmel.org> <512650A1.7070103@heisl.org> <51265132.7070706@turmel.org> <512656B5.4090505@heisl.org> <51265824.4030407@heisl.org> <51265B0B.9020108@turmel.org> <51265DA7.2030209@heisl.org> <512660B9.8090609@turmel.org> <5126629A.1090002@heis
 l.org> <51266360.9030402@turmel.org> <5126678D.9030101@heisl.org> <51266D73.5020700@turmel.org> <51267192.6090205@heisl.org> <51267467.9040603@turmel.org> <512675A6.1000801@heisl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <512675A6.1000801@heisl.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Am 21.02.2013 20:29, schrieb Stone:
> Am 21.02.2013 20:24, schrieb Phil Turmel:
>> On 02/21/2013 02:12 PM, Stone wrote:
>>
>>>>> ok. with --chunk=64 i cannot open the luks.
>>>>> in witch steps (chunk) should i continue?
>>>> That is a big surprise.  The luks signature should not move with chunk
>>>> size.  Please use "mdadm -E /dev/sdc1" to recheck your data offset.
>>>>
>>>> If that wasn't it, please show the hexdump for the entire luks
>>>> signature.  I'd like to see its payload offset.
>>>>
>>>> Also, if you go back to --chunk=512, open the luks, you could run the
>>>> following command to find possible superblock locations:
>>>>
>>>> hexdump -C /dev/mapper/md2_nas |egrep '^[0-9a-f]+30  .+  53 ef' 
>>>> >sb.lst
>>>>
>>>> (May take a long time to read the whole array)
>>>>
>>>> Phil
>>> with --chunk=512 i can open the luks but i cannot found a good 
>>> superblock.
>>> yes i can run the hexdump but i think this runs 8 hours or longer.
>>> start the hexdump?
>>> can i try more today?
>> Run the hexdump for half an hour or so.  If it doesn't find some
>> candidates in that timeframe, it probably won't.
>>
>> I've never crashed a luks partition like this, so I'm feeling around a
>> bit.  You should understand that luks normally uses "cipher block
>> chaining" salted with the sector number.  If you get the blocks out of
>> order (wrong chunk size or offset or layout), those sectors won't
>> decrypt correctly.  luksOpen won't detect this.
>>
>> You may have to try many chunk sizes, verifying the data offset every
>> time, trying to find the one that will work.
>>
>> Phil
> ok i let the hexdump running for 30-60 min and then i check mehr chunk.
> if i can open the luks i should check again the superblocks?
> fsck.ext4 -n -b <superblock> /dev/mapper/md2_nas ?
>
> but i see there is a result from hex:
>
> cat sb.lst
> 011e0830  17 0d bb 6e b2 37 9f f8  53 ef 5b 62 6d ab 0f b8 
> |...n.7..S.[bm...|
> 02a1c830  91 31 32 1a 35 c9 96 ab  53 ef 02 93 05 f2 b7 65 
> |.12.5...S......e|
> 03c48e30  dc 46 07 a9 2d ac 96 36  53 ef 61 48 d1 c7 63 05 
> |.F..-..6S.aH..c.|
> 04c28830  7f 36 db 0a 5a 65 6c 78  53 ef 3a 31 41 83 da c2 
> |.6..ZelxS.:1A...|
> 04c60830  9f 32 a6 e1 1a cc ef dc  53 ef 59 bd 51 ac d0 01 
> |.2......S.Y.Q...|
> 055be030  4b ee f1 d0 8e 36 15 67  53 ef 45 75 a9 cd 3c b5 
> |K....6.gS.Eu..<.|
> 058aa530  82 91 1f 13 6f fa 60 2f  53 ef 1a 68 80 bc a5 0c 
> |....o.`/S..h....|
> 05def830  db fc 8d a1 f3 49 c9 a6  53 ef cf 03 f9 e3 18 00 
> |.....I..S.......|
> 06016630  5c 9b 31 ed 40 74 ad a5  53 ef c3 a8 b5 74 e2 25 
> |\.1.@t..S....t.%|
> 060caf30  b5 aa cd 06 57 d3 22 6c  53 ef 04 54 d6 2a 74 3f 
> |....W."lS..T.*t?|
> 071f0530  cb 6b 07 74 60 37 e9 34  53 ef ba fa cf 2d 69 58 
> |.k.t`7.4S....-iX|
> 087f8c30  95 57 29 2c ca d8 02 0b  53 ef 05 c4 44 17 50 1c 
> |.W),....S...D.P.|
> 0977ac30  32 61 7d 49 fc dc 61 a0  53 ef 53 95 96 88 25 65 
> |2a}I..a.S.S...%e|
> 0be5a330  3f 05 57 2e 8e fd 55 44  53 ef 20 0f f1 a0 5b a0 |?.W...UDS. 
> ...[.|
> 0c5de030  65 2e 3a 18 44 b3 65 37  53 ef 24 f2 96 f9 99 dc 
> |e.:.D.e7S.$.....|
> 0d3b8230  2f eb a0 08 d3 3e 32 70  53 ef 3b 5a 0c 7f c3 51 
> |/....>2pS.;Z...Q|
> 0d46b930  d6 e2 c5 23 61 8c b5 26  53 ef 71 3f f3 36 df f6 
> |...#a..&S.q?.6..|
> 0da68330  2a f2 24 fd df 4d 10 71  53 ef 8c b7 da fe 28 b3 
> |*.$..M.qS.....(.|
> 0dfb9730  cc 4a a3 7f 99 d0 9c 59  53 ef f6 78 c4 5e 7c fd 
> |.J.....YS..x.^|.|
> 0e6be030  ae 13 5f 1a 79 e6 a1 33  53 ef 7f e3 07 ef 6e 38 
> |.._.y..3S.....n8|
> 0ee9e130  78 2a b9 8c 17 e8 0b b8  53 ef ad c8 d8 4b 3a 1d 
> |x*......S....K:.|
> 0fe93130  f3 1f 02 69 6f f8 a9 f7  53 ef ee 2a 31 7f da f8 
> |...io...S..*1...|
> 128c7130  45 5b 93 6e 5f 64 26 3c  53 ef 6c 1e be d0 f1 9b 
> |E[.n_d&<S.l.....|
> 12ad4430  94 c0 9b e8 ff 6a 6e 63  53 ef 2d d3 95 f9 3a 64 
> |.....jncS.-...:d|
> 13c76d30  ac 31 88 2b 08 ba 34 6b  53 ef 46 c3 3e 9b c5 05 
> |.1.+..4kS.F.>...|
> 150ef030  1e 63 6d 93 c4 57 50 ac  53 ef 72 a4 62 98 9f f7 
> |.cm..WP.S.r.b...|
> 166ec830  ef 91 29 77 c3 a6 8a 61  53 ef 86 15 8f 2d a9 38 
> |..)w...aS....-.8|
> 16f96d30  1f 05 08 5a 64 df fa 09  53 ef b9 bc 21 85 c4 ff 
> |...Zd...S...!...|
> 19c0b430  e4 a4 fd 26 10 90 ae 00  53 ef 3d b2 06 44 77 2a 
> |...&....S.=..Dw*|
> 19c11d30  83 fd 70 6e 84 5e e9 42  53 ef b5 f2 34 02 e6 76 
> |..pn.^.BS...4..v|
> 1b13d030  9c 1d 5e 72 ff 07 04 0c  53 ef 80 6f eb 9d 68 33 
> |..^r....S..o..h3|
> 1b39f330  bf 1a 86 a0 43 fb c7 fd  53 ef 8f 55 7f 9f bf 46 
> |....C...S..U...F|
> 1c2a9c30  a0 8d 51 34 d0 f6 21 6f  53 ef f4 5a 1f a1 03 9f 
> |..Q4..!oS..Z....|
> 1c8d1630  e9 f3 f3 4b 3e dc 13 cc  53 ef 4b 75 a9 1e fb 74 
> |...K>...S.Ku...t|
> 1e361d30  b8 c9 1a 14 16 c5 ba da  53 ef 22 fd 79 bd da 13 
> |........S.".y...|
> 1f628330  22 b7 78 3b 71 94 67 38  53 ef a7 1a 5d 1c 0c 11 
> |".x;q.g8S...]...|
> 21e76230  40 b9 f7 74 93 7a db 99  53 ef 67 fd 9a f2 38 4d 
> |@..t.z..S.g...8M|
> 237eaf30  20 81 19 51 bc 80 2a 92  53 ef 02 c9 c0 6e a4 39  | 
> ..Q..*.S....n.9|
> 27f80030  80 91 df 4d 0d 00 22 00  53 ef 00 00 01 00 00 00 
> |...M..".S.......|
> 2aa58330  c7 ba 01 74 ae 83 a9 5c  53 ef 33 50 73 b4 80 67 
> |...t...\S.3Ps..g|
> 2fe5fa30  65 e8 32 40 7d 63 ce d2  53 ef e3 14 29 4b bf eb 
> |e.2@}c..S...)K..|
> 3021a330  c8 52 86 6a c4 83 4b 4f  53 ef f0 48 27 8c e4 6b 
> |.R.j..KOS..H'..k|
> 30bf6e30  66 64 fb 7c 6d 67 e1 ef  53 ef 9d e4 88 ab 7c 28 
> |fd.|mg..S.....|(|
> 32d58f30  ce 79 84 2c 41 54 b7 c7  53 ef c7 c9 b8 7a a9 55 
> |.y.,AT..S....z.U|
> 3456cc30  63 55 26 a5 8d 2d e7 b5  53 ef 6e c2 15 ea 2c de 
> |cU&..-..S.n...,.|
> 36108630  ba 36 3b 45 89 e4 f8 dd  53 ef fc 17 8f 8c 7d f6 
> |.6;E....S.....}.|
> 36c1fe30  36 0a 62 79 11 78 cd a3  53 ef 93 a3 ac 71 fe 2f 
> |6.by.x..S....q./|
> 37601c30  f8 51 e8 5b 4b a9 33 df  53 ef e7 59 b7 15 d4 8e 
> |.Q.[K.3.S..Y....|
> 37f80030  80 91 df 4d 0d 00 22 00  53 ef 00 00 01 00 00 00 
> |...M..".S.......|
> 3a0be530  c5 2a 5a 11 34 a3 5e 3d  53 ef d2 98 85 cb 9c 60 
> |.*Z.4.^=S......`|
> 3c7bcb30  a8 32 d6 84 10 24 a9 92  53 ef 53 ce c5 17 46 a1 
> |.2...$..S.S...F.|
> 3e763830  d0 2e e5 e4 5d 12 50 ff  53 ef 2a 3f 54 89 66 b9 
> |....].P.S.*?T.f.|
> 40eb1830  82 45 f5 29 50 11 40 27  53 ef 81 97 c0 d2 40 09 
> |.E.)P.@'S.....@.|
> 42d6bb30  9f 97 47 d4 27 d1 0a 5b  53 ef 5d 98 12 20 2e 79 
> |..G.'..[S.].. .y|
> 44dc8b30  50 57 55 89 43 04 e8 95  53 ef ff 8b 43 04 8d 14 
> |PWU.C...S...C...|
> 4af7d430  54 67 6d 65 f2 54 4c e4  53 ef 42 8a 57 73 f2 7b 
> |Tgme.TL.S.B.Ws.{|
> 4b49b130  f4 d6 92 45 61 fa f4 c5  53 ef be 9d 89 f5 cd 99 
> |...Ea...S.......|
> 4b4d6230  ae 93 05 cc 3c 7d fe 6e  53 ef 66 10 ff 30 b9 24 
> |....<}.nS.f..0.$|
> 4bd02830  35 5c 44 a7 4e 15 b5 87  53 ef 7b 3f 9b 75 6d ab 
> |5\D.N...S.{?.um.|
> 4cf5ad30  08 fc 34 b1 00 1e e0 af  53 ef 8b 7b 18 99 73 1a 
> |..4.....S..{..s.|
> 4d31e130  e8 d9 ef 6a a2 ba d6 d5  53 ef f5 92 f2 55 4c ca 
> |...j....S....UL.|
> 4e887930  7b a0 ce fa fe 6d ad a1  53 ef 3a b5 5f f0 07 da 
> |{....m..S.:._...|
> 50687b30  7b 98 1c d3 49 59 e4 ca  53 ef 46 69 0b 3e ee c3 
> |{...IY..S.Fi.>..|
> 5083e630  53 8c 5e 60 0e 93 e3 94  53 ef d6 e0 85 06 26 d1 
> |S.^`....S.....&.|
> 50dd0b30  f4 8d 43 b9 91 74 a6 de  53 ef c9 a7 d6 79 d6 e5 
> |..C..t..S....y..|
> 50efa530  2d af 75 74 96 f0 29 f7  53 ef 5f 40 94 9d d7 31 
> |-.ut..).S._@...1|
> 519ed830  4b 5b 76 50 fb 5a e7 f8  53 ef 79 ad 17 0c 41 d7 
> |K[vP.Z..S.y...A.|
> 52968e30  16 27 4a af 10 70 b9 a7  53 ef fc 76 4d e1 a5 d3 
> |.'J..p..S..vM...|
> 53df7430  4a 34 16 33 78 40 16 07  53 ef 87 80 14 ad 03 be 
> |J4.3x@..S.......|
> 545b3e30  38 d4 7c f7 52 62 0d a4  53 ef 9e 0d f4 f8 3e 4c 
> |8.|.Rb..S.....>L|
> 550dda30  4e 80 ee c9 75 5a bd 8d  53 ef c5 1d 9e 51 ad 70 
> |N...uZ..S....Q.p|
> 55afb530  a9 de 66 d9 a6 ee 35 a8  53 ef 36 61 69 c1 6a c4 
> |..f...5.S.6ai.j.|
> 55baf430  ad 20 92 a6 f7 f1 fb 43  53 ef 10 03 07 9e ba 38  |. 
> .....CS......8|
> 55ca7c30  9c 00 6c 6a 69 29 ae cc  53 ef a0 6e 2e 2c 48 67 
> |..lji)..S..n.,Hg|
> 56203730  6d ef f0 ae 12 61 9e 7f  53 ef e6 cf 79 a9 e6 a2 
> |m....a..S...y...|
> 567d3030  37 83 4d f6 fa 79 2d f1  53 ef b4 19 dc 31 41 ee 
> |7.M..y-.S....1A.|
> 5939bf30  91 7f f7 ed 44 4b f1 f9  53 ef fc f3 44 fd 7f 65 
> |....DK..S...D..e|
> 5a600030  39 3b 64 91 2a 62 4f 62  53 ef 54 e2 0b 9f 77 04 
> |9;d.*bObS.T...w.|
> 5bffaa30  54 6d 0f 30 16 20 71 88  53 ef 72 2a 89 bb e9 d8  |Tm.0. 
> q.S.r*....|
> 5cd40e30  60 dc 99 6c d2 f7 4e da  53 ef 27 7f 15 e1 6a 6b 
> |`..l..N.S.'...jk|
> 5ce11c30  5d 97 d8 49 a9 c8 ea bc  53 ef c1 ac b2 5c 3c 58 
> |]..I....S....\<X|
> 5d8f6d30  c3 bc 16 0b 85 f8 89 37  53 ef 60 be 22 23 95 01 
> |.......7S.`."#..|
> 5e3b9630  4b 49 18 a9 32 b5 c7 2b  53 ef 0e 43 e3 d3 7f 1c 
> |KI..2..+S..C....|
> 5e950430  f2 f7 b9 3b 9c 1f 8b 69  53 ef af d6 c2 31 6b 0e 
> |...;...iS....1k.|
> 5ea3e030  66 2e f7 40 61 41 50 de  53 ef 56 01 9a 21 a0 33 
> |f..@aAP.S.V..!.3|
> 5f638d30  42 b1 ec 8a cc 57 8b c9  53 ef df 41 d5 9d 9d 6d 
> |B....W..S..A...m|
> 6a241830  16 e8 c4 39 bb 50 96 f8  53 ef 60 62 90 e6 4e b3 
> |...9.P..S.`b..N.|
> 6a249f30  17 d6 77 d3 62 b2 c3 83  53 ef b4 9d ff d7 07 15 
> |..w.b...S.......|
> 6a8e6230  3e 78 55 da 76 e1 55 51  53 ef 2b 21 79 fc 75 cd 
> |>xU.v.UQS.+!y.u.|
> 6b166730  07 db 8d 18 b8 69 cc 22  53 ef 2b 4f dd df b8 56 
> |.....i."S.+O...V|
> 6b82f830  61 45 5f 5a bf cb 25 10  53 ef b9 e3 11 2a e4 a5 
> |aE_Z..%.S....*..|
> 6c3f3d30  d3 a4 cc a5 fd bd d4 dd  53 ef 5e eb 26 ff 39 6e 
> |........S.^.&.9n|
> 6cd42f30  4f c5 1f 2b 13 3a 19 b8  53 ef 67 59 70 1b 11 65 
> |O..+.:..S.gYp..e|
> 6d40f130  76 99 1f 14 1a 8a 33 58  53 ef c0 3b de 8e 97 0f 
> |v.....3XS..;....|
> 6d6cbb30  82 6a 37 4b 34 59 64 1c  53 ef 64 c2 29 88 50 31 
> |.j7K4Yd.S.d.).P1|
> 6e606730  dc 4d 43 71 ff 2b 71 68  53 ef 9d 41 16 0f 91 10 
> |.MCq.+qhS..A....|
> 6e909e30  96 0c 7c be 2a f3 a4 e9  53 ef fc 00 20 2f 32 32 
> |..|.*...S... /22|
> 72d0df30  1b b5 d0 79 e3 33 76 22  53 ef 4e d9 14 3b 17 93 
> |...y.3v"S.N..;..|
> 74a44b30  03 87 a4 b2 3a 73 22 03  53 ef 54 6b 4d ed 9d a8 
> |....:s".S.TkM...|
> 7582bc30  2d 50 cb 49 10 c8 c8 4e  53 ef 04 79 4a 8a d1 9c 
> |-P.I...NS..yJ...|
> 7599fa30  1a 25 29 c3 32 6c 30 55  53 ef 99 cf 29 20 e5 81 
> |.%).2l0US...) ..|
> 76a0ed30  86 4f 8d 18 da fc af f1  53 ef c3 c1 93 c4 a5 fa 
> |.O......S.......|
> 76b63f30  e1 9d e8 e4 0b 1e 14 80  53 ef 11 99 e7 58 37 b9 
> |........S....X7.|
> 79eec330  a2 5e 93 f9 db f3 f1 85  53 ef bf fd 36 13 b1


more results for you:
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
79eec330  a2 5e 93 f9 db f3 f1 85  53 ef bf fd 36 13 b1 95 
|.^......S...6...|
7abefc30  27 17 0b c0 75 49 05 4e  53 ef 04 da 53 8c f4 37 
|'...uI.NS...S..7|
7b577e30  81 e7 c1 79 bf 07 af d9  53 ef 23 ea 2d 53 cc 16 
|...y....S.#.-S..|
7c305930  62 a2 b8 3c 5d 73 e7 a7  53 ef b9 18 7f 69 ff 5a 
|b..<]s..S....i.Z|
7d8fae30  69 eb 56 75 90 f4 2b cb  53 ef 82 dc bb 78 71 a2 
|i.Vu..+.S....xq.|
7dc68f30  f0 3b ef 35 e4 0a 98 05  53 ef 36 e4 34 89 67 3e 
|.;.5....S.6.4.g>|
7e410930  37 a4 5e f6 f7 25 56 22  53 ef 10 b3 0c 4a a5 74 
|7.^..%V"S....J.t|
7ee45330  03 1c 5a ce 92 8a 2b 1a  53 ef a1 59 95 6e 21 bf 
|..Z...+.S..Y.n!.|
88374d30  f3 df 14 71 dc b8 56 8d  53 ef ff 45 32 27 18 cc 
|...q..V.S..E2'..|
8d2c6030  93 e8 83 49 db ab 1d 99  53 ef a8 d3 f5 29 3e 26 
|...I....S....)>&|
8f347130  49 83 05 84 55 83 1e 41  53 ef 4b ca 99 99 80 d8 
|I...U..AS.K.....|
8ffb7a30  8e 2a 3b f9 42 71 cb c4  53 ef 07 dd 03 bb 9f ee 
|.*;.Bq..S.......|
90766730  47 f5 39 0c 1b 65 e6 5a  53 ef c0 42 41 66 65 43 
|G.9..e.ZS..BAfeC|
91f75b30  2f 58 d0 27 71 6d c2 ae  53 ef 90 f1 94 ad 65 f9 
|/X.'qm..S.....e.|
9235ff30  9e fc 72 a4 af 56 2a 03  53 ef 9c aa 4d a1 99 a7 
|..r..V*.S...M...|
93deff30  b7 4a f2 7f 51 0e 0c 91  53 ef 46 80 18 dc 08 22 
|.J..Q...S.F...."|
943ed730  f2 ef 37 8d f6 ac 34 c0  53 ef 32 11 83 6b 97 36 
|..7...4.S.2..k.6|
94a02630  06 4f ce 49 12 23 fc 44  53 ef 84 60 e2 39 8e 40 
|.O.I.#.DS..`.9.@|
9579e330  c0 67 4d 93 05 88 03 32  53 ef eb 0a a8 3f f1 77 
|.gM....2S....?.w|
95ad5f30  81 31 73 e5 83 38 c4 fe  53 ef e7 dd 40 24 d3 bd 
|.1s..8..S...@$..|
95f39e30  7d d2 5d 06 23 a3 23 aa  53 ef 31 05 4e 68 85 5b 
|}.].#.#.S.1.Nh.[|
9742c030  6d 9c 14 d4 c5 50 d1 71  53 ef 88 e3 14 80 74 66 
|m....P.qS.....tf|
98fd2030  fb db 10 a8 59 48 23 30  53 ef 6b 9d 6c bc 71 02 
|....YH#0S.k.l.q.|
99642330  16 ad d4 36 f7 6d e4 be  53 ef 83 93 4a 95 06 69 
|...6.m..S...J..i|
99c28130  44 f8 f1 f0 82 a4 c2 3d  53 ef 19 65 0c 1f 25 b6 
|D......=S..e..%.|
9ab08730  67 ba 40 3c d8 9e 6f 97  53 ef 26 87 5c fe cd 38 
|g.@<..o.S.&.\..8|
9aeb8130  62 64 7e 4c ba ba 87 f3  53 ef 35 99 d9 d5 53 37 
|bd~L....S.5...S7|
9b4d2e30  19 ad fa 0c e9 3f fe 1f  53 ef 18 1e d9 f6 fc f1 
|.....?..S.......|
9beeba30  3e b0 a0 53 8d e5 16 c8  53 ef 7a 0e ba 44 ac 4a 
|>..S....S.z..D.J|
9c041b30  4b 27 8a bf 1a 34 34 16  53 ef 31 b5 12 61 b0 0c 
|K'...44.S.1..a..|
9d3ee730  68 ad a4 26 80 ed e5 dd  53 ef 4f 98 57 f0 25 6a 
|h..&....S.O.W.%j|
9d7e4430  5e 4c c3 75 17 cf 01 72  53 ef 72 3f 6c b2 63 2d 
|^L.u...rS.r?l.c-|
9e0dc430  f2 8b db 49 e3 b1 4c 76  53 ef ae 76 7b 36 d8 f4 
|...I..LvS..v{6..|
9efa9a30  d3 89 6a 50 d2 64 c2 9b  53 ef d1 36 d4 eb 89 0b 
|..jP.d..S..6....|
a0aeda30  62 ea 4e 94 e8 f3 3f 65  53 ef 5a e6 32 47 b9 b9 
|b.N...?eS.Z.2G..|
a0d9b330  45 bb 87 5c d5 e5 b8 aa  53 ef 0f 13 fc 40 a0 37 
|E..\....S....@.7|
a0dd7230  dc 66 d1 f3 69 21 c5 f0  53 ef d1 5b a1 80 6a 15 
|.f..i!..S..[..j.|
a184e930  8a 2e 6a d1 18 59 62 aa  53 ef 83 fa 2e 1f f0 08 
|..j..Yb.S.......|
a1a78830  6b 7f de 6c b5 ea 5b 2a  53 ef 53 53 1d 8f 02 ca 
|k..l..[*S.SS....|
a20c8630  d0 e5 3e 7d ed b2 38 eb  53 ef b4 1e 9f f5 58 56 
|..>}..8.S.....XV|
a2520430  9e d0 c8 13 c0 ad 57 f3  53 ef 95 cb 73 c9 bf 3c 
|......W.S...s..<|
a279f230  5c 92 0b 13 37 25 c9 43  53 ef ce 12 4b 2c e6 09 
|\...7%.CS...K,..|
a29b6930  fd c1 60 3f f0 bd 40 b6  53 ef af 1c a0 74 1a 93 
|..`?..@.S....t..|
a2a47e30  44 b3 e8 4f 46 30 1e d7  53 ef 86 3d 87 f9 8f cb 
|D..OF0..S..=....|
a31a7030  65 5b 40 9c fd 3e 87 5a  53 ef 07 49 ee 8f 76 84 
|e[@..>.ZS..I..v.|
a4b94130  57 d4 4a fb a7 8d d3 6e  53 ef 1c 15 0a 96 57 7d 
|W.J....nS.....W}|
a5d74730  a5 e9 a3 5c ca 06 e0 f4  53 ef ea b5 86 8e 85 81 
|...\....S.......|
a5e5be30  81 33 1e e9 36 bf d3 7e  53 ef ee 33 2e de 16 e5 
|.3..6..~S..3....|
a6a5f930  4e ff b4 4c 0d b8 43 26  53 ef 43 1f 9b 1b 65 b2 
|N..L..C&S.C...e.|
a8240c30  b3 e1 8d 98 de 92 dd b9  53 ef 6b 66 b3 5b 7a 9f 
|........S.kf.[z.|
a86e3d30  40 3c d6 fa cb 3a a1 f9  53 ef 36 d2 74 80 f0 e6 
|@<...:..S.6.t...|
aa3bf130  d8 d0 91 39 64 ce 52 e8  53 ef 22 24 fa 0d 6a af 
|...9d.R.S."$..j.|
aa73bd30  c3 25 aa a1 a2 49 95 95  53 ef b0 2f 28 3e 7c 73 
|.%...I..S../(>|s|
ab485730  3a c0 03 be 90 b2 f1 db  53 ef a5 2e 81 81 cf 2b 
|:.......S......+|
ab868830  67 05 12 2a e6 df 34 f8  53 ef 74 b2 3a 81 30 47 
|g..*..4.S.t.:.0G|
abb86130  83 38 19 e3 8c a4 73 a4  53 ef b1 b1 c3 7a f4 f9 
|.8....s.S....z..|
acbbc930  08 b9 77 60 dc d9 97 f4  53 ef a9 ce 0e c0 01 19 
|..w`....S.......|
acfa7c30  3e b3 43 52 a9 56 e5 06  53 ef ed ee e2 ad 3d 1f 
|>.CR.V..S.....=.|
b0209830  22 65 5b f4 a2 aa 24 3b  53 ef 68 bf 1a ca ca 7d 
|"e[...$;S.h....}|
b0a47930  a7 66 91 4b b9 7e 1a 7a  53 ef 85 dd d8 2a f3 a6 
|.f.K.~.zS....*..|
b34b7d30  f9 62 8a f8 21 76 f5 39  53 ef 36 bd 1b dd f5 22 
|.b..!v.9S.6...."|
b3909a30  c6 95 cb a9 19 95 de 47  53 ef 70 c7 e3 82 7f ee 
|.......GS.p.....|
b4a87f30  3e 90 55 7d 54 92 77 d6  53 ef ac 7b 32 39 24 89 
|>.U}T.w.S..{29$.|
b4b71c30  09 9f 15 fa ff e0 90 16  53 ef 1c 22 91 b4 17 6d 
|........S.."...m|
b63bc330  15 47 d0 bd b8 96 95 b5  53 ef 78 74 62 15 34 fe 
|.G......S.xtb.4.|
b745f730  fd e5 98 49 b2 3d dd 6d  53 ef d5 3f d5 4b ea d3 
|...I.=.mS..?.K..|
b9a57030  13 b3 b2 96 92 73 22 ce  53 ef 0c 69 26 a2 2a 15 
|.....s".S..i&.*.|
ba500930  a8 7b 65 24 6d 7b 81 f6  53 ef 0e ad a0 e4 1a 17 
|.{e$m{..S.......|
bbe98330  ba 86 c2 77 19 48 44 00  53 ef ac 40 53 78 1e 72 
|...w.HD.S..@Sx.r|
bfe6a430  d3 3e 3d 66 79 ab 35 6b  53 ef 6f b7 dc 2d b3 fc 
|.>=fy.5kS.o..-..|
c1824c30  81 c3 b3 c1 75 ab 23 04  53 ef 6f 81 17 ca 5b 82 
|....u.#.S.o...[.|
c325a130  10 36 f1 ad 93 fd ee 1e  53 ef 01 19 35 94 4b d5 
|.6......S...5.K.|
c3705e30  78 6d d9 68 67 ab 53 57  53 ef ab ae 9b 82 97 ca 
|xm.hg.SWS.......|
c4cea430  c6 3a 25 c2 3a e5 36 ac  53 ef 1b eb d4 08 eb d4 
|.:%.:.6.S.......|
c5431d30  a7 89 0d 3a fd 9d 66 3a  53 ef 72 82 23 d9 8d 8b 
|...:..f:S.r.#...|
c7255e30  7f 2b ec 92 a8 07 5a 2c  53 ef 97 63 c4 80 49 98 
|.+....Z,S..c..I.|
c7619530  6a a5 26 33 06 34 33 e4  53 ef 3d b2 3a 4a 7f 48 
|j.&3.43.S.=.:J.H|
c7bc1f30  11 5d 5f c9 fe c1 5f 17  53 ef ee c0 ba dd 3e 3d 
|.]_..._.S.....>=|
c7f80030  80 91 df 4d 0d 00 22 00  53 ef 00 00 01 00 00 00 
|...M..".S.......|
c8869c30  4c fa ca af fd 51 e5 69  53 ef 04 2f cb 82 71 61 
|L....Q.iS../..qa|
c94c1230  77 64 99 88 b4 84 26 31  53 ef 94 fc 3f b5 a6 3f 
|wd....&1S...?..?|
c97f7030  b5 be 30 f0 a1 fe 61 65  53 ef f9 a8 3b bc c8 3f 
|..0...aeS...;..?|
ca4fe330  c5 6f ab 07 b5 9b d6 11  53 ef ab 07 71 6a bd a1 
|.o......S...qj..|
cbd31930  c7 be bf de 65 51 be b8  53 ef 8e 85 52 48 d3 d5 
|....eQ..S...RH..|
cbebb530  9c 11 35 f5 ce c5 bf 7d  53 ef 1c 1c a9 6d ac 9a 
|..5....}S....m..|
cc0de830  08 59 49 8f 9c c1 e9 b7  53 ef 1c 23 d2 0d ce 32 
|.YI.....S..#...2|
cc1e3430  7a 94 26 3e c3 a7 10 f5  53 ef f3 3c d6 3d 3d 91 
|z.&>....S..<.==.|
cc3be130  3e a4 2c 3a ad 8f 5a f7  53 ef c0 d7 9b 99 8f 8f 
|>.,:..Z.S.......|
cc4db430  3b fb a9 d6 b8 63 a7 5d  53 ef 31 92 de 66 ba a0 
|;....c.]S.1..f..|
cc4f6c30  a4 c2 df 3e f2 be 93 73  53 ef d9 31 b8 a6 06 8c 
|...>...sS..1....|
ccf28130  20 57 6f 7e bd fc 98 49  53 ef ef a0 dd be 29 0f  | 
Wo~...IS.....).|
d2a85630  af f3 73 10 32 6c f0 80  53 ef f7 1c 29 50 10 54 
|..s.2l..S...)P.T|
d39ccb30  b5 4f 92 3b fd 5c c0 2b  53 ef 66 bd c1 74 54 ba 
|.O.;.\.+S.f..tT.|
d4caaa30  b1 e6 0a 05 00 28 b2 29  53 ef 96 de 96 7d 91 a2 
|.....(.)S....}..|
d626ad30  68 9d 34 9d 36 ad d7 89  53 ef 4a 55 e6 98 e3 7c 
|h.4.6...S.JU...||
d83b5830  50 22 f9 de d8 70 46 3b  53 ef 19 ff ad 1e 54 5c 
|P"...pF;S.....T\|
d8f74030  8b 03 45 51 25 42 81 8f  53 ef 3c 6d fb c3 62 3e 
|..EQ%B..S.<m..b>|
db58ab30  6c 72 61 ae 1d 1a be 66  53 ef a2 3e 48 c8 13 5e 
|lra....fS..>H..^|
dc59b030  7e 13 9e 8f 4c 3a f7 3b  53 ef f2 f6 6c 2f fb 08 
|~...L:.;S...l/..|
dfc68330  78 74 25 46 c9 e5 79 46  53 ef bc 62 f9 71 75 ea 
|xt%F..yFS..b.qu.|
dfe9c530  77 f7 0f f8 cc 40 e7 22  53 ef a3 a9 92 71 c4 1c 
|w....@."S....q..|
e0644b30  b1 56 a8 48 36 09 f3 73  53 ef f9 29 f2 05 f6 fb 
|.V.H6..sS..)....|
e16f7130  be 95 6d e6 52 ef 06 9a  53 ef 06 5c f9 9c fc 41 
|..m.R...S..\...A|
e22c3530  66 14 f3 b2 43 88 be 61  53 ef f6 14 10 ec 6c d2 
|f...C..aS.....l.|
e2939830  a0 00 4b 86 9e a8 3f
