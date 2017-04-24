From: =?UTF-8?Q?Patrik_Dahlstr=c3=b6m?= <risca@powerlamerz.org>
Subject: Re: Recover array after I panicked
Date: Tue, 25 Apr 2017 01:00:47 +0200
Message-ID: <727eeaf5-b856-305d-99b6-e42f3383b699@powerlamerz.org>
References: <20170423144835.GB12093@metamorpher.de>
 <f353b7fc-a63a-5503-5cda-6a62698f69ae@powerlamerz.org>
 <20170423154240.GA3494@metamorpher.de>
 <718f75d1-b74f-f788-783a-6ffbdff275a8@powerlamerz.org>
 <63d6d0f5-d9b1-1218-b98e-48f9cf21a8bc@fnarfbargle.com>
 <CAHKno4AZukKvOEkVXPYMtnu1nypXLi95HaiFw+WNhAKP4KoLkg@mail.gmail.com>
 <20170424110455.GA4949@metamorpher.de>
 <CAHKno4A12N6UGGtJQJRkY0aPbFBBf0Rek91th9Cnx6XWJGouWg@mail.gmail.com>
 <20170424123706.GA6798@metamorpher.de>
 <CAHKno4BR3kdsLU9AnNHvarc-e6UibNr7WQks2ssPX4pE1ZoUpA@mail.gmail.com>
 <20170424133946.GA7057@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170424133946.GA7057@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: Brad Campbell <lists2009@fnarfbargle.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 04/24/2017 03:39 PM, Andreas Klauer wrote:
> On Mon, Apr 24, 2017 at 02:54:50PM +0200, Patrik Dahlström wrote:
> Another thing you can check is, pick an arbitrary offset that does not 
> have zeroes on the disks, and see if the XOR matches for 5, or 6 disks.
> 
> It should match for 6 for however far the grow progressed, 
> and match for 5 afterwards.
I got some success!

I started experimenting with this and realised that about 1 TB into
/dev/sdf, I started getting all zeros from the disk. Incidentally this
will also make the xor pass for both 5 and 6 disk arrays. Here's some
examples:
# for f in /dev/sd{a,b,d,c,e,f}; do hexdump -C -n 16 -s 0x8000000000 "$f"; done
8000000000  96 6c 5d 2c a4 03 7a 62  9c 7d 67 b9 55 24 aa 84  |.l],..zb.}g.U$..|
8000000010
8000000000  59 10 a8 e9 a7 5e fa e9  cd 8c 16 a2 7c 06 60 f6  |Y....^......|.`.|
8000000010
8000000000  7d ca 8e ea cc fe 2a 36  be b8 a8 b6 77 f9 fa 87  |}.....*6....w...|
8000000010
8000000000  4d 42 49 1e 0b ae a7 3b  42 50 68 bb c1 d5 89 96  |MBI....;BPh.....|
8000000010
8000000000  fc 3d c7 b7 82 39 06 a7  ad fc 00 81 05 5b 52 e1  |.=...9.......[R.|
8000000010
8000000000  03 c9 f5 86 46 34 0b 21  00 e5 b1 97 9a 55 eb 82  |....F4.!.....U..|
8000000010
5 disk raid xor check: 84 ^ f6 ^ 87 ^ 96 ^ e1 == 82, NOK
6 disk raid xor check: 84 ^ f6 ^ 87 ^ 96 ^ e1 ^ 82 == 0, OK

# for f in /dev/sd{a,b,d,c,e,f}; do hexdump -C -n 16 -s 0x10000000000 "$f"; done
10000000000  03 33 0a 04 d9 7a 44 4b  dc 8f be 58 0b 80 8f 46  |.3...zDK...X...F|
10000000010
10000000000  79 5f 18 51 f7 44 03 59  7f aa ce 9d f1 a9 3d 73  |y_.Q.D.Y......=s|
10000000010
10000000000  67 f4 9e b2 34 b6 c2 43  b5 8d 2f 0d 5f 80 a4 6d  |g...4..C../._..m|
10000000010
10000000000  4f ec f4 c9 da 04 64 db  dc e9 e1 72 7f e4 74 06  |O.....d....r..t.|
10000000010
10000000000  52 74 78 2e c0 8c e1 8a  ca 41 be ba da 4d 62 5e  |Rtx......A...Mb^|
10000000010
10000000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
10000000010
5 disk raid xor check: 46 ^ 73 ^ 6d ^ 06 ^ 5e == 0, OK
6 disk raid xor check: 46 ^ 73 ^ 6d ^ 06 ^ 5e ^ 00 == 0, OK

So I did a binary search from 0x8000000000 to 0x10000000000 to see
where I start getting all zeros from the newest drive. I ended up at
offset 0xfaa2880000 (~0.98 TB or ~18 % into the disk). After that, it's
all zeros.

# for f in /dev/sd{a,b,d,c,e,f}; do hexdump -C -n 16 -s 0xfaa287fff8 "$f"; done
faa287fff8  e5 4d 6b e6 ef 7b 1f b0  2e 30 82 8e 5b 4b e0 30  |.Mk..{...0..[K.0|
faa2880008
faa287fff8  dd f7 ab 02 cf e8 a2 6d  93 a8 08 a7 d8 9e c7 b4  |.......m........|
faa2880008
faa287fff8  31 f8 7b d9 41 c7 72 13  f1 37 b6 4a 51 fc 46 74  |1.{.A.r..7.JQ.Ft|
faa2880008
faa287fff8  87 29 59 58 97 05 87 1b  1a 8d 83 84 83 b0 21 4a  |.)YX..........!J|
faa2880008
faa287fff8  04 2b 32 6d 0f ab fb b7  56 22 bf e7 51 99 40 ba  |.+2m....V"..Q.@.|
faa2880008
faa287fff8  f4 06 c8 81 00 00 03 ae  00 00 00 00 00 00 00 00  |................|
faa2880008

Now, at offset 0xfaa2880000 the 5 disk raid xor sums are OK:
0xfaa2880000: 2e ^ 93 ^ f1 ^ 1a ^ 56 = 0, OK

But immediately before that, I can't get the xor sums to line up:
0xfaa287ffff: b0 ^ 6d ^ 13 ^ 1b ^ b7 != ae (62 actually), NOK
This would mean that it's incorrect for both 5 and 6 disk raids.

So I did a binary search backwards to find out where the checksums match
again and came to offset 0xed90332000 (~0.93 TB or ~17 % into the disk).
# for f in /dev/sd{a,b,d,c,e,f}; do hexdump -C -n 16 -s 0xed90331ff8 "$f"; done
ed90331ff8  69 1a b1 fb 9f 80 cf fa  6f 97 dc b7 26 40 38 6f  |i.......o...&@8o|
ed90332008
ed90331ff8  e3 58 c4 e7 7a 9a b5 a4  74 37 5a de d8 24 a6 e5  |.X..z...t7Z..$..|
ed90332008
ed90331ff8  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |................|
ed90332008
ed90331ff8  53 0b 7c bb 49 d6 63 55  ff fb b2 40 35 00 03 39  |S.|.I.cU...@5..9|
ed90332008
ed90331ff8  9b 49 25 23 ec ad 89 0c  ce a0 29 29 a2 86 bc c2  |.I%#......))....|
ed90332008
ed90331ff8  bd ff d3 7b bf 9e 6f f8  17 bc f3 8d e7 9b d0 65  |...{..o........e|
ed90332008

0xed90331fff: fa ^ a4 ^ ff ^ 55 ^ 0c == f8, OK for 6 disk raid
0xed90332000: 6f ^ 74 ^ ff ^ ff ^ ce != 17 (d5 actually), NOK

That is a span of ~52 GB where I presumably can't get the checksums
right. What does all this mean? What am I missing?

Best regards
// Patrik
