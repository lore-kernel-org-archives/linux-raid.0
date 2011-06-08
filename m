From: Durval Menezes <durval.menezes@gmail.com>
Subject: Re: Maximizing failed disk replacement on a RAID5 array
Date: Wed, 8 Jun 2011 03:58:52 -0300
Message-ID: <BANLkTimxsT+htp82Us9uVgSdFNgb0m4vkQ@mail.gmail.com>
References: <BANLkTimBYFhjQ-sC9DhTMO+PG-Ox+A9S2Q@mail.gmail.com>
	<BANLkTimOxCF7diZfeFgtqCBWKZVF2pxyLg@mail.gmail.com>
	<BANLkTi=px08AWxfJJq+zNepCZM8aAsKECA@mail.gmail.com>
	<4DECF025.9040006@fnarfbargle.com>
	<BANLkTi=jPiXLySacVZqDkeThdG80K_HTxQ@mail.gmail.com>
	<4DECF841.1060906@fnarfbargle.com>
	<BANLkTikPxQvyDD3d_A6d3+GLKOLgqFJbFw@mail.gmail.com>
	<BANLkTi=+2GFWRFKT0SCXRtkdn71msgDY=g@mail.gmail.com>
	<4DEDB8B7.2070708@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DEDB8B7.2070708@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <brad@fnarfbargle.com>
Cc: linux-raid@vger.kernel.org, Drew <drew.kay@gmail.com>
List-Id: linux-raid.ids

Hello,

On Tue, Jun 7, 2011 at 2:35 AM, Brad Campbell <brad@fnarfbargle.com> wrote:
> On 07/06/11 13:03, Durval Menezes wrote:
>>
>> Hello Folks,
>>
>> Just finished the "repair". It completed OK, and over SMART the HD now
>> shows a "Reallocated_Sector_Ct" of 291 (which shows that many bad
>> sectors have been remapped), but it's also still reporting 4
>> "Current_Pending_Sector" and 4 "Offline_Uncorrectable"... which I
>> think means exactly the same thing, ie, that there are 4 "active"
>> (from the HD perspective) sectors on the drive still detected as bad
>> and not remapped.
>>
>> I've been thinking about exactly what that means, and I think that
>> these 4 sectors are either A) outside the RAID partition (not very
>> probable as this partition occupies more than 99.99% of the disk,
>> leaving just a small, less than 105MB area at the beginning), or B)
>> some kind of metadata or unused space that hasn't been read and
>> rewritten by the "repair" I've just completed. I've just done a "dd
>> bs=1024k count=105</dev/DISK>/dev/null" to account for the
>> hyphotesys A), and come out empty: no errors, and the drive still
>> shows 4 bad, unmapped sectors on SMART.
>>
>> So, by elimination, it must be either case B) above, or a bug in the
>> linux md code (which prevents it from hitting every needed block on
>> the disk), or a bug in SMART (which makes it report inexistent bad
>>
> Try running a SMART long test smartctl -t long and it will tell you whether
> the sectors are really bad or not.
> I've had instances where the firmware still thought that some previously
> pending sectors were still pending until I forced a test, at which time the
> drive came to its senses and they went away.
>
> I believe if you wait until the drive gets around to doing its periodic
> offline data collection you'll see the same thing, but a long test is nice
> as it will give you an actual block number for the first failure (if you
> have one)

I did it (smartctl -a long) and it completed (registering an error at
the very end of the disk):

     SMART Self-test log structure revision number 1
     Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
     # 1  Extended offline    Completed: read failure       10%
9942           2930273794

The SMART Attributes table still shows 4 pending/uncorrectable sectors:

    197 Current_Pending_Sector  0x0012   100   100   000    Old_age
Always       -
           4
    198 Offline_Uncorrectable   0x0010   100   100   000    Old_age
Offline      -
           4

Converting the above LBA to a block number, I find 2930273794/2=
1465136897; as this is a 1.5TB HD,
this first error (there are possibly 3 more) is right at the final
35GB of the media, so it's inside (near the
end) of the RAID partition:

     fdisk -l /dev/sdc
         Disk /dev/sdc: 1500.3 GB, 1500301910016 bytes
          255 heads, 63 sectors/track, 182401 cylinders
          Units = cylinders of 16065 * 512 = 8225280 bytes
          Sector size (logical/physical): 512 bytes / 512 bytes
          I/O size (minimum/optimal): 512 bytes / 512 bytes
          Disk identifier: 0x6be6057c
             Device Boot      Start         End      Blocks   Id  System
          /dev/sdc1               1           1        8001    4  FAT16 <32M
          /dev/sdc2   *           2          14      104422+  83  Linux
          /dev/sdc3              15      182401  1465023577+  fd
Linux raid autodetect

Confirming that this block is indeed returning read errors:

    dd count=1 bs=1024 skip=1465136897 if=/dev/sdc of=/dev/null
        [long delay]
        dd: reading `/dev/sdc': Input/output error
        0+0 records in
        0+0 records out
        0 bytes (0 B) copied, 45.1076 s, 0.0 kB/s

Examining one sector before:

    dd count=1 bs=1024 skip=146513686 if=/dev/sdc | hexdump -C
        00000000  92 e1 b4 d4 c6 cd 0f 33  db 7c ff a9 be c1 c1 8e
|.......3.|......|
        00000010  71 35 fc 55 16 c4 36 ef  59 10 db 20 22 f4 57 99
|q5.U..6.Y.. ".W.|
        00000020  31 61 2b 24 e0 98 3c 94  4b 8a 17 93 23 aa e9 96
|1a+$..<.K...#...|
        00000030  b0 47 7b 8f 12 c6 52 42  99 0d 72 b4 51 02 5a 8e
|.G{...RB..r.Q.Z.|
        00000040  c6 5a ac 86 0b a5 74 9b  13 e7 87 7a db 94 e2 7f
|.Z....t....z....|
        00000050  c6 42 75 ba 53 bf 7f 20  fc 9c ad 4b 8f 3c 85 64
|.Bu.S.. ...K.<.d|
        00000060  3a b0 ac 41 6e 41 fb 95  03 70 24 7e 2e d5 df 8a
|:..AnA...p$~....|
        00000070  f9 dc d1 7d 4a 1e e1 93  9d 39 18 83 6c 9f 9f 79
|...}J....9..l..y|
        00000080  53 a3 d1 fb 7f c6 bd 44  8d 0c 40 06 0a 92 f9 7e
|S......D..@....~|
        00000090  0c 0e 87 43 66 9d fc 12  2b 0d 7a 34 ba 84 cb 73
|...Cf...+.z4...s|
        000000a0  47 3b a4 fa c9 50 d9 96  f9 50 a2 60 17 eb 7c c8
|G;...P...P.`..|.|
        000000b0  42 76 59 d0 1e 06 10 a8  3b 89 74 8d b4 04 83 88
|BvY.....;.t.....|
        000000c0  d7 9d 3c 82 cf 8f 7d 6e  a2 b6 bf 56 06 c0 aa 7c
|..<...}n...V...||
        000000d0  7d 39 ae 0a 67 48 28 b5  07 fd fc ae 49 e4 7a 08
|}9..gH(.....I.z.|
        000000e0  8a 37 94 e0 d3 d7 f0 f4  4c 49 3a ed b7 f4 84 95
|.7......LI:.....|
        000000f0  3f 0a 4f 6c 47 62 1a f4  70 ca 14 8a 52 6d 4c 1e
|?.OlGb..p...RmL.|
        00000100  da 0c 29 17 c1 a4 e1 5c  cb 43 e0 01 45 9c 72 7f
|..)....\.C..E.r.|
        00000110  78 b8 19 3f dd 35 c5 50  ff 9b 42 fb 0b d8 61 5a
|x..?.5.P..B...aZ|
        00000120  24 2b ae c9 45 e6 e5 e9  04 00 93 bb 53 c0 fd d6
|$+..E.......S...|
        00000130  9c ab 69 98 50 f0 5e 98  0d 0b b3 dc cb cb d0 7d
|..i.P.^........}|
        00000140  21 70 68 e8 fb 3c 55 fd  2d c6 6c 25 86 dd 9a 4a
|!ph..<U.-.l%...J|
        00000150  fc e2 24 a9 fb 9a 6b be  d5 e2 3b e9 a0 b1 61 ad
|..$...k...;...a.|
        00000160  1f 9a c8 31 86 91 c6 1f  86 9e 17 35 25 7e 77 42
|...1.......5%~wB|
        00000170  37 86 b2 17 08 8e c4 cf  4e e2 64 7d 83 11 05 1e
|7.......N.d}....|
        00000180  6b c1 e7 5d 0f e2 c9 f9  0a 0a b1 2b 83 a1 2a a4
|k..].......+..*.|
        00000190  1d f8 a6 13 2f e9 45 bb  b7 e2 71 e9 69 ad 3c 47
|..../.E...q.i.<G|
        000001a0  3f fa 39 7f 1e 93 0e d2  89 09 dc d2 b3 3b f8 6f
|?.9..........;.o|
        000001b0  21 21 72 b6 9e 9d 42 79  fb 78 3c 02 85 7b 1f 4f
|!!r...By.x<..{.O|
        000001c0  8b 3c 26 62 8a 58 38 a7  48 31 b9 e2 0c 0d 41 d6
|.<&b.X8.H1....A.|
        000001d0  8f 43 95 f0 1f 52 3e 0e  55 8d c0 93 f7 e3 c8 79
|.C...R>.U......y|
        000001e0  a2 bc 51 72 87 3c 16 c3  d0 f3 57 a8 e4 48 51 32
|..Qr.<....W..HQ2|
        000001f0  00 99 3e 0e 88 a3 fa e3  00 a4 c2 cb 28 7a a1 00
|..>.........(z..|
        00000200  a0 b4 1b 6d c4 2a 15 75  a3 f0 24 47 5a d6 54 74
|...m.*.u..$GZ.Tt|
        00000210  d0 ad e4 92 b1 99 5d 7a  62 47 b9 54 8f 9e 15 ca
|......]zbG.T....|
        00000220  65 09 9e d0 d3 61 51 93  88 4a 46 1e 5c 15 07 ef
|e....aQ..JF.\...|
        00000230  b0 92 fa a7 e7 3d e5 36  20 67 d2 24 b7 59 ae f4
|.....=.6 g.$.Y..|
        00000240  7c 26 57 90 e1 69 b5 f3  b4 1b 8e e6 07 2e 46 84
||&W..i........F.|
        1+0 records in
        1+0 records out
        1024 bytes (1.0 kB) copied, 5.0224e-05 s, 20.4 MB/s

Looking at one sector after the error returns similar results.

So, I don't know about you, but the above seems pretty much like data
to me (although it could also be parity).

So I have two questions:

1) can I simply skip over these sectors (using dd_rescue or multiple
dd invocations) when off-line copying the old disk to the new one,
trusting the RAID5 to reconstruct the data correctly from the other 2
disks? Or is it better to simply do the recover the "traditional" way
(ie, "fail" the old disk, "add" the new one, and run the risk of a
possible bad sector on one of the two remaining old disks ruining the
show completely and forcing me to recover from backups [I *do* have
up-to-date backups on this array])?

2) Is there a formula, a program or anything that can tell me exactly
what is located at the above sector (ie, whether it's RAID parity or a
data sector)?

Thanks,
-- 
   Durval Menezes.




Ditto, one sector after:



So, when I "dd" this partition to a new one, I think



>
>
