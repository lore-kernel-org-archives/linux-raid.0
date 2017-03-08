From: Olivier Swinkels <olivier.swinkels@gmail.com>
Subject: Re: [RAID recovery] Unable to recover RAID5 array after disk failure
Date: Wed, 8 Mar 2017 20:01:35 +0100
Message-ID: <CAJ0Qwk+-Zz7RM8p7Ehy8aGuf+CQkPpbnBOaGNN77bP8cA5K9qg@mail.gmail.com>
References: <CAJ0QwkJqRbJtM9HiXL+cCj2TkQQRahGgWTwD9QKH_CBfbJeLKA@mail.gmail.com>
 <0a6e4a82-665c-6e62-293f-151e41c67842@turmel.org> <CAJ0QwkKAVLh7+kV_GsEL4O5hA+Pj=Y9sE_CBbWJJqDyA+gVqpA@mail.gmail.com>
 <CAJ0QwkKuSKzE7_4h1aUA4XMyNAAdmFR4J6z+Z_vW5nsW3OcZtw@mail.gmail.com>
 <c3ae0e4d-dccc-9cb4-72b0-28a1bde3c752@turmel.org> <CAJ0QwkKG8_dCzTBYEPm5CpqWMQwM=f8YBAYtatNh=9U_7ygdnA@mail.gmail.com>
 <f0536882-3a0b-b43c-317d-691d82c6923f@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f0536882-3a0b-b43c-317d-691d82c6923f@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Mar 7, 2017 at 3:52 PM, Phil Turmel <philip@turmel.org> wrote:
> On 03/07/2017 03:39 AM, Olivier Swinkels wrote:
>
>> After I used the pvcreate command to recreate pv the vgcfgrestore
>> command succeeds and the lvm is available (after activating).
>>
>> However when I try to mount it I get the following error: sudo mount
>> -t ext4 /dev/lvm-raid/lvm0 /mnt/raid mount: mount
>> /dev/mapper/lvm--raid-lvm0 on /mnt/raid failed: Structure needs
>> cleaning
>>
>> So I guess the underlying RAID array is still not ok...
>
> No, your underlying array is very likely correct.  But the intervening
> incorrect --create operation stomped on your filesystems.  Run fsck
> while unmounted to deal with the corruption and recover what you can.
>
> Run fsck with "-n" first, to see just how extensive the problems are,
> then with "-y" to actually fix things.  Based on your sequence of
> events, your corruptions should be at low sector addresses (first few
> Gigs) of your array.  If that's what appears with "-n", proceed.
>
> If you are unlucky, the stompage hit one or more of your filesystems'
> superblocks, requiring access to backup superblocks.  If you still see
> no progress with either of the above, you might need to search your
> array for ext2/3/4 superblocks.  This grep would help:
>
> dd if=/dev/md0 bs=1M count=16k 2>/dev/null |hexdump -C |grep '30  .\+  53 ef 0'
>
> (Not all hits from the grep will be superblocks, but they would be
> visually distinguishable, and would have decipherable timestamps.)
>
> Phil

Hi,

I ran fsck -n disk on the lvm and got the very large response below.
This didn't look promising, so I ran the ext2/3/4 superblock search.
I didn't recognize any obvious timestamps, but i'm not sure what to look for.
(I also pasted this output below)

Can you recommend any further action?

Olivier

===============================================================================
fsck /dev/lvm-raid/lvm0
fsck from util-linux 2.27.1
ext2fs_check_desc: Corrupt group descriptor: bad block for block bitmap
fsck.ext4: Group descriptors look bad... trying backup blocks...
Warning: skipping journal recovery because doing a read-only filesystem check.
/dev/mapper/lvm--raid-lvm0 has gone 1275 days without being checked,
check forced.
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Free blocks count wrong for group #0 (23513, counted=5372).
Fix? no
Free blocks count wrong for group #1 (980, counted=485).
Fix? no
Free blocks count wrong for group #3 (1023, counted=151).
Fix? no
Free blocks count wrong for group #5 (1022, counted=142).
Fix? no

<<TRIMMED ~200000 lines >>>

Free inodes count wrong for group #60160 (8192, counted=8163).
Fix? no
Directories count wrong for group #60160 (0, counted=1).
Fix? no
Free inodes count wrong for group #60161 (8192, counted=8191).
Fix? no
Directories count wrong for group #60161 (0, counted=1).
Fix? no
Free inodes count wrong (488172170, counted=609035768).
Fix? no

/dev/mapper/lvm--raid-lvm0: ********** WARNING: Filesystem still has
errors **********
/dev/mapper/lvm--raid-lvm0: 122295670/610467840 files (0.0%
non-contiguous), 2291846165/2441871360 blocks
===============================================================================
dd if=/dev/md0 bs=1M count=16k 2>/dev/null |hexdump -C |grep '30  .\+  53 ef 0'
00040430  3a 3b ab 58 17 00 19 00  53 ef 01 00 01 00 00 00  |:;.X....S.......|
08040030  0c 58 34 52 02 00 19 00  53 ef 01 00 01 00 00 00  |.X4R....S.......|
18040030  0c 58 34 52 02 00 19 00  53 ef 01 00 01 00 00 00  |.X4R....S.......|
1d220e30  2e 93 9c 90 c1 89 27 62  53 ef 03 12 d4 82 36 76  |......'bS.....6v|
27340430  bb 78 c4 e3 9e 56 62 0f  53 ef 04 b9 38 0c d0 26  |.x...Vb.S...8..&|
28040030  0c 58 34 52 02 00 19 00  53 ef 01 00 01 00 00 00  |.X4R....S.......|
2f02ab30  5e d0 c9 98 83 ce 3b 92  53 ef 08 51 c4 4b dc af  |^.....;.S..Q.K..|
38040030  0c 58 34 52 02 00 19 00  53 ef 01 00 01 00 00 00  |.X4R....S.......|
44318c30  55 c1 19 f3 10 fb ab 2f  53 ef 04 0d fd c1 dc ed  |U....../S.......|
48040030  0c 58 34 52 02 00 19 00  53 ef 01 00 01 00 00 00  |.X4R....S.......|
50791730  6b 04 06 e8 97 88 9b 08  53 ef 0b 24 21 68 3d a5  |k.......S..$!h=.|
5aab3030  db 52 8d 5c 82 f4 80 cd  53 ef 08 4c f7 a7 c7 a9  |.R.\....S..L....|
98b69330  41 07 bb 64 c2 4a 00 5a  53 ef 08 71 88 d2 5a 42  |A..d.J.ZS..q..ZB|
c8040030  0c 58 34 52 02 00 19 00  53 ef 01 00 01 00 00 00  |.X4R....S.......|
cefc4130  14 37 b9 ef 1f 89 14 ab  53 ef 02 1c ca 88 f0 c4  |.7......S.......|
d8040030  0c 58 34 52 02 00 19 00  53 ef 01 00 01 00 00 00  |.X4R....S.......|
fe124d30  8a 6f 46 db 63 9b c5 9b  53 ef 07 97 74 24 2d e0  |.oF.c...S...t$-.|
106432f30  76 d0 fc 66 02 06 e9 50  53 ef 02 44 6c ab 89 ac  |v..f...PS..Dl...|
111e92630  f8 59 df b2 af 5d 6b 8b  53 ef 0d 65 c6 29 66 0c  |.Y...]k.S..e.)f.|
12883be30  88 63 b9 3a 6a 52 03 a6  53 ef 0c 12 67 dc ad 9e  |.c.:jR..S...g...|
14d315530  30 92 ef 27 a0 dc 46 dd  53 ef 09 d7 89 5a ba 95  |0..'..F.S....Z..|
17222e430  aa 7d 4f 4a c5 88 fa f0  53 ef 0c 08 04 10 9e ad  |.}OJ....S.......|
173717c30  3d fd 91 37 5a 0e 7b aa  53 ef 0b 08 d4 51 89 fa  |=..7Z.{.S....Q..|
17665ae30  c9 a8 24 d6 ba 0a 50 f7  53 ef 08 13 da d7 52 0a  |..$...P.S.....R.|
188040030  0c 58 34 52 02 00 19 00  53 ef 01 00 01 00 00 00  |.X4R....S.......|
18ef3be30  41 c3 91 02 65 af 8d 27  53 ef 0c 1f 4b 47 f5 97  |A...e..'S...KG..|
1943f1d30  d6 87 e0 d7 c1 3b e7 53  53 ef 08 a5 88 14 b6 c8  |.....;.SS.......|
19bfba930  c3 e4 07 04 b4 d1 05 4a  53 ef 02 c4 69 2f e2 d0  |.......JS...i/..|
1a807c530  a1 12 db b0 77 9d c5 6c  53 ef 0d 6e 37 05 74 61  |....w..lS..n7.ta|
1b1976330  1a 2b 57 56 46 96 c2 9b  53 ef 03 78 0d 9e 4a e0  |.+WVF...S..x..J.|
1ebf5db30  1e 76 bf 9d 25 8f fd 16  53 ef 04 ba 23 14 2f 8d  |.v..%...S...#./.|
1eec8b930  d5 dc 1e 90 b1 c8 f4 31  53 ef 06 10 3c 81 fb 37  |.......1S...<..7|
1f1392930  89 db 6c 92 6c 10 a5 f9  53 ef 05 31 0e 04 a2 d0  |..l.l...S..1....|
227cdff30  8d 8a 0a 61 91 04 c4 15  53 ef 03 5b 28 c4 52 59  |...a....S..[(.RY|
23000da30  1d e6 34 ca 2f 36 08 78  53 ef 0e 28 e4 94 5f 42  |..4./6.xS..(.._B|
245749e30  83 67 b7 d0 8b 40 0d f0  53 ef 0e ec 13 37 39 89  |.g...@..S....79.|
24f40e530  86 3b fc 43 ea ef 81 29  53 ef 09 6c fb 08 3b 6d  |.;.C...)S..l..;m|
25a473430  94 24 8d 8c 6b 15 7b 8b  53 ef 00 ae 43 b2 64 a4  |.$..k.{.S...C.d.|
288040030  0c 58 34 52 02 00 19 00  53 ef 01 00 01 00 00 00  |.X4R....S.......|
29966b530  00 ad 14 71 ea c5 c6 7a  53 ef 0c 11 d2 57 fb a0  |...q...zS....W..|
2a5924830  98 43 57 9b 2f 98 18 4f  53 ef 0d 27 72 c3 58 ba  |.CW./..OS..'r.X.|
2a7bf9b30  72 f2 a7 7c 73 4f 2f a6  53 ef 02 14 5b 7c 93 9e  |r..|sO/.S...[|..|
2aae14530  25 6b d5 ab b0 48 94 cd  53 ef 06 08 41 e0 0b ba  |%k...H..S...A...|
2ac470a30  a4 a6 cb a0 40 a2 8f cd  53 ef 06 47 3d d5 e0 38  |....@...S..G=..8|
2aca3fb30  99 e4 1a cd b1 a8 be 6c  53 ef 01 03 68 6f 4c f4  |.......lS...hoL.|
2b19b6030  30 64 6a d9 08 f0 46 c9  53 ef 07 95 b2 14 fb aa  |0dj...F.S.......|
2c53e0a30  59 1b 4b c8 25 a1 56 d9  53 ef 0b 26 3a 76 72 a5  |Y.K.%.V.S..&:vr.|
2cb48d730  0a d2 b4 d5 40 fc c5 d0  53 ef 0b 6d 90 9b db 22  |....@...S..m..."|
2dc925b30  16 18 5b 30 09 18 f8 2e  53 ef 0a d1 00 74 13 e7  |..[0....S....t..|
2dcc76230  e9 75 d0 2e 92 45 59 2c  53 ef 0e 84 63 9a aa b6  |.u...EY,S...c...|
2e6d28730  f4 81 47 6a 8f 9c ae 1a  53 ef 09 9d d2 5b e4 35  |..Gj....S....[.5|
2f9639f30  82 67 ae 49 2c a1 fc c0  53 ef 07 b1 1f 54 c5 c9  |.g.I,...S....T..|
2fa204230  78 42 16 12 e9 83 72 88  53 ef 00 08 df d9 8b 2a  |xB....r.S......*|
31b7c1030  99 f0 43 99 1f 52 77 17  53 ef 0c 5f b9 51 a1 42  |..C..Rw.S.._.Q.B|
321ad8a30  4e 9b 9e 2e c6 8e 19 8d  53 ef 0e 1d 5d 20 c0 9d  |N.......S...] ..|
32ff61630  72 9f 28 d2 9a 35 79 63  53 ef 09 e6 d6 e3 27 c5  |r.(..5ycS.....'.|
33a4b8230  58 9d 65 cb da 31 07 e7  53 ef 04 07 e2 4a 9b 17  |X.e..1..S....J..|
3472a7230  b4 a9 fa cf 3d 39 c3 95  53 ef 03 a4 07 2a ac 9a  |....=9..S....*..|
3534f5130  54 d2 19 77 a4 c2 4a 2f  53 ef 07 b3 0f 60 be ee  |T..w..J/S....`..|
356145130  df f7 f8 eb 6b 2a 8b fa  53 ef 09 cf 9d cd db 68  |....k*..S......h|
361b68830  53 ab 0c 7a 8e 4e 96 1b  53 ef 0f 3b 78 e9 d5 ce  |S..z.N..S..;x...|
37381e630  24 63 4a ce 1b eb b0 df  53 ef 02 68 54 7d 7a ad  |$cJ.....S..hT}z.|
375103330  3a 20 84 18 b6 6d f5 3b  53 ef 0a 86 8f ac b2 d8  |: ...m.;S.......|
37b3f7230  11 43 a4 46 fd c8 da ae  53 ef 04 f3 80 db 5c 4b  |.C.F....S.....\K|
3a5adf530  7f c1 e1 75 26 cf 25 b2  53 ef 01 4d 64 71 10 bf  |...u&.%.S..Mdq..|
3ccc7b830  55 cb 6f 68 e3 c0 0f 36  53 ef 06 00 85 8a 17 72  |U.oh...6S......r|
3d6743f30  fa ca 0e 36 a6 4e 02 6a  53 ef 05 6d 6f e5 31 78  |...6.N.jS..mo.1x|
3e8040030  0c 58 34 52 02 00 19 00  53 ef 01 00 01 00 00 00  |.X4R....S.......|

===============================================================================
