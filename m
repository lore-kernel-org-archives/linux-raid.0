From: xar <xar@retard.io>
Subject: RAID 6 (containing LUKS dm-crypt) recovery help.
Date: Fri, 07 Nov 2014 00:46:05 -0500
Message-ID: <545C5C9D.9000309@retard.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greetings,

I have a RAID 6 (which contains a LUKS container) that I'm hoping to ge=
t=20
some help/insight in recovering. The server experienced some sort of=20
hardware event that resulted in a mandatory restart of the server.

=46or the record, after the server completed the restart, the array loo=
ked=20
like this, "all spares":

md6 : inactive sdl1[7](S) sdh1[13](S) sdg1[14](S) sdk1[11](S)=20
sdj1[10](S) sdi1[6](S) sdd1[2](S) sdf1[8](S) sdb1[12](S) sde1[3](S)=20
sdc1[15](S) 21488638704 blocks super 1.2

The server in question is Ubuntu ("Precise") 12.04.5 LTS with mdadm=20
version 3.2.5-1ubuntu0 installed.

The mdadm array has the following characteristics:

RAID level: 6
Chunk size: 256k
Version: 1.2
Number of devices: 11

All attempts to assemble the array continued to result in the "all=20
spare" condition (output above). Thinking that the metadata had been=20
corrupted somehow, I set out to recreate the array.

The following is the dev_number fields from the metadata, before I=20
attempted to recreate the array:

# for i in /dev/sd?1; do echo -n $i '' ; dd 2> /dev/null if=3D$i bs=3D1=
=20
count=3D4 skip=3D4256 | od -D | head -n1; done:

/dev/sdb1 0000000         12
/dev/sdc1 0000000         15
/dev/sdd1 0000000          2
/dev/sde1 0000000          3
/dev/sdf1 0000000          8
/dev/sdg1 0000000         14
/dev/sdh1 0000000         13
/dev/sdi1 0000000          6
/dev/sdj1 0000000         10
/dev/sdk1 0000000         11
/dev/sdl1 0000000          7

I used the following to extract the index position of each device on a=20
device I suspected wasn't corrupted (for the record, they all returned=20
the same data):

# dd 2> /dev/null if=3D/dev/sdc1 bs=3D2 count=3D6 skip=3D2176 | od -d

0000000 65534 65534     2 65534 65534 65534     4     5
0000020 65534 65534     7     8     0     9 65534
0000036

As you can see, there's already a visible mismatch between the=20
dev_number and the listed indexes. For instance, /dev/sdc1 returned a=20
device number of 15, but there's not a 15th position in the=20
corresponding list.

I pulled from log history, the last known working "layout", circa July=20
of this year:

# mdadm -D /dev/md6
/dev/md6:
         Version : 1.2
   Creation Time : Sat Apr 23 06:22:23 2011
      Raid Level : raid6
      Array Size : 17581609728 (16767.13 GiB 18003.57 GB)
   Used Dev Size : 1953512192 (1863.01 GiB 2000.40 GB)
    Raid Devices : 11
   Total Devices : 10
     Persistence : Superblock is persistent

     Update Time : Sat Jun 21 21:13:45 2014
           State : clean, degraded
  Active Devices : 10
Working Devices : 10
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 256K

            Name : server:6  (local to host server)
            UUID : 6958450b:e4dfa2f3:259ff733:f343a584
          Events : 390345

     Number   Major   Minor   RaidDevice State
       12       8       17        0      active sync   /dev/sdb1
        3       8       65        1      active sync   /dev/sde1
        2       8       49        2      active sync   /dev/sdd1
        8       8       81        3      active sync   /dev/sdf1
        6       8      129        4      active sync   /dev/sdi1
        7       8      177        5      active sync   /dev/sdl1
        6       0        0        6      removed
       10       8      145        7      active sync   /dev/sdj1
       11       8      161        8      active sync   /dev/sdk1
       13       8      113        9      active sync   /dev/sdh1
       14       8       97       10      active sync   /dev/sdg1

The dev_numbers and index position information in conjunction with the=20
historic data (directly above) seemed to indicate that the proper=20
recreation order and command would be the following:

# mdadm --create /dev/md6 --assume-clean --level=3D6 --raid-devices=3D1=
1=20
--metadata=3D1.2 --chunk=3D256 /dev/sdb1 /dev/sde1 /dev/sdd1 /dev/sdf1=20
/dev/sdi1 /dev/sdl1 /dev/sdc1 /dev/sdj1 /dev/sdk1 /dev/sdh1 /dev/sdg1

I ran this above command.

Here is the current output of "lsdrv" which I observed several people=20
found to be relevant on this list, from creator 'pturmel' on github:

PCI [ahci] 00:11.0 SATA controller: Advanced Micro Devices, Inc.=20
[AMD/ATI] SB7x0/SB8x0/SB9x0 SATA Controller [AHCI mode] (rev 40)
=E2scsi 0:0:0:0 ATA      ST31500541AS     {6XW03WTD}
=E2=E2sda 1.36t [8:0] Partitioned (dos)
=E2 =E2sda1 109.79m [8:1] ext4 {07f99e8c-95d2-483d-9850-05f04820c3f6}
=E2 =E2=E2Mounted as /dev/sda1 @ /boot
=E2 =E2sda2 2.01g [8:2] swap {d137430d-815a-4c45-a394-9bece3aa7136}
=E2 =E2sda3 7.01g [8:3] ext4 {8db73200-8d9d-4991-9802-b13f1550a9d9}
=E2 =E2=E2Mounted as /dev/disk/by-uuid/8db73200-8d9d-4991-9802-b13f1550=
a9d9 @ /
=E2 =E2sda4 1.36t [8:4] Empty/Unknown
=E2  =E2dm-0 1.36t [252:0] xfs {db7ddb53-080c-45ba-ab4d-e45d35eb451c}
=E2   =E2Mounted as /dev/mapper/enc @ /encrypted
=E2scsi 1:0:0:0 ATA      ST2000DL003-9VT1 {5YD4VZLV}
=E2=E2sdb 1.82t [8:16] Partitioned (gpt)
=E2 =E2sdb1 1.82t [8:17] MD raid6 (11) inactive 'server:6'=20
{c88f3b40-c7d4-a33a-5007-ab8ef784c0c2}
=E2scsi 2:0:0:0 ATA      ST2000DM001-1CH1 {Z1E8GNFQ}
=E2=E2sdc 1.82t [8:32] Partitioned (gpt)
=E2 =E2sdc1 1.82t [8:33] MD raid6 (11) inactive 'server:6'=20
{c88f3b40-c7d4-a33a-5007-ab8ef784c0c2}
=E2scsi 3:0:0:0 ATA      ST2000DL003-9VT1 {5YD2PZM3}
=E2=E2sdd 1.82t [8:48] Partitioned (gpt)
=E2 =E2sdd1 1.82t [8:49] MD raid6 (11) inactive 'server:6'=20
{c88f3b40-c7d4-a33a-5007-ab8ef784c0c2}
=E2scsi 4:0:0:0 ATA      ST2000DL003-9VT1 {5YD2J0XD}
=E2=E2sde 1.82t [8:64] Partitioned (gpt)
=E2 =E2sde1 1.82t [8:65] MD raid6 (11) inactive 'server:6'=20
{c88f3b40-c7d4-a33a-5007-ab8ef784c0c2}
=E2scsi 5:0:0:0 ATA      ST2000DL003-9VT1 {5YD3XE9M}
  =E2sdf 1.82t [8:80] Partitioned (gpt)
   =E2sdf1 1.82t [8:81] MD raid6 (11) inactive 'server:6'=20
{c88f3b40-c7d4-a33a-5007-ab8ef784c0c2}
PCI [sata_sil24] 04:04.0 RAID bus controller: Silicon Image, Inc. SiI=20
3124 PCI-X Serial ATA Controller (rev 02)
=E2scsi 6:0:0:0 ATA      ST2000DL003-9VT1 {5YD6JW2L}
=E2=E2sdg 1.82t [8:96] Partitioned (gpt)
=E2 =E2sdg1 1.82t [8:97] MD raid6 (11) inactive 'server:6'=20
{65daae65-118b-896a-6205-0f2c4dacb4de}
=E2scsi 7:0:0:0 ATA      ST2000DL003-9VT1 {6YD05E5Y}
=E2=E2sdh 1.82t [8:112] Partitioned (gpt)
=E2 =E2sdh1 1.82t [8:113] MD raid6 (11) inactive 'server:6'=20
{c88f3b40-c7d4-a33a-5007-ab8ef784c0c2}
=E2scsi 8:x:x:x [Empty]
=E2scsi 9:x:x:x [Empty]
PCI [sata_sil24] 06:04.0 RAID bus controller: Silicon Image, Inc. SiI=20
3124 PCI-X Serial ATA Controller (rev 02)
=E2scsi 10:0:0:0 ATA      ST32000542AS     {5XW1PVCZ}
=E2=E2sdi 1.82t [8:128] Partitioned (gpt)
=E2 =E2sdi1 1.82t [8:129] MD raid6 (11) inactive 'server:6'=20
{c88f3b40-c7d4-a33a-5007-ab8ef784c0c2}
=E2scsi 11:0:0:0 ATA      ST2000DL003-9VT1 {5YD2SND2}
=E2=E2sdj 1.82t [8:144] Partitioned (gpt)
=E2 =E2sdj1 1.82t [8:145] MD raid6 (11) inactive 'server:6'=20
{c88f3b40-c7d4-a33a-5007-ab8ef784c0c2}
=E2scsi 12:0:0:0 ATA      ST2000DL003-9VT1 {5YD4JTZP}
=E2=E2sdk 1.82t [8:160] Partitioned (gpt)
=E2 =E2sdk1 1.82t [8:161] MD raid6 (11) inactive 'server:6'=20
{c88f3b40-c7d4-a33a-5007-ab8ef784c0c2}
=E2scsi 13:0:0:0 ATA      ST32000542AS     {5XW1KAEA}
  =E2sdl 1.82t [8:176] Partitioned (gpt)
   =E2sdl1 1.82t [8:177] MD raid6 (11) inactive 'server:6'=20
{c88f3b40-c7d4-a33a-5007-ab8ef784c0c2}
Other Block Devices
=E2loop0 0.00k [7:0] Empty/Unknown
=E2loop1 0.00k [7:1] Empty/Unknown
=E2loop2 0.00k [7:2] Empty/Unknown
=E2loop3 0.00k [7:3] Empty/Unknown
=E2loop4 0.00k [7:4] Empty/Unknown
=E2loop5 0.00k [7:5] Empty/Unknown
=E2loop6 0.00k [7:6] Empty/Unknown
=E2loop7 0.00k [7:7] Empty/Unknown
=E2ram0 64.00m [1:0] Empty/Unknown
=E2ram1 64.00m [1:1] Empty/Unknown
=E2ram2 64.00m [1:2] Empty/Unknown
=E2ram3 64.00m [1:3] Empty/Unknown
=E2ram4 64.00m [1:4] Empty/Unknown
=E2ram5 64.00m [1:5] Empty/Unknown
=E2ram6 64.00m [1:6] Empty/Unknown
=E2ram7 64.00m [1:7] Empty/Unknown
=E2ram8 64.00m [1:8] Empty/Unknown
=E2ram9 64.00m [1:9] Empty/Unknown
=E2ram10 64.00m [1:10] Empty/Unknown
=E2ram11 64.00m [1:11] Empty/Unknown
=E2ram12 64.00m [1:12] Empty/Unknown
=E2ram13 64.00m [1:13] Empty/Unknown
=E2ram14 64.00m [1:14] Empty/Unknown
=E2ram15 64.00m [1:15] Empty/Unknown

=46ollowing the recreation, the array now looks like this:

# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]=20
[raid4] [raid10]
md6 : active raid6 sdh1[9] sdk1[8] sdj1[7] sdc1[6] sdl1[5] sdi1[4]=20
sdf1[3] sdd1[2] sde1[1] sdb1[0]
       17580439296 blocks super 1.2 level 6, 256k chunk, algorithm 2=20
[11/10] [UUUUUUUUUUU]

# mdadm -D /dev/md6
/dev/md6:
         Version : 1.2
   Creation Time : Fri Nov  7 05:40:16 2014
      Raid Level : raid6
      Array Size : 17580439296 (16766.01 GiB 18002.37 GB)
   Used Dev Size : 1953382144 (1862.89 GiB 2000.26 GB)
    Raid Devices : 11
   Total Devices : 11
     Persistence : Superblock is persistent

     Update Time : Fri Nov  7 05:40:16 2014
           State : clean
  Active Devices : 11
Working Devices : 11
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 256K

            Name : server:6  (local to host server)
            UUID : b306872f:5ef902a8:76f5e233:f220f4d4
          Events : 0

     Number   Major   Minor   RaidDevice State
        0       8       17        0      active sync   /dev/sdb1
        1       8       65        1      active sync   /dev/sde1
        2       8       49        2      active sync   /dev/sdd1
        3       8       81        3      active sync   /dev/sdf1
        4       8      129        4      active sync   /dev/sdi1
        5       8      177        5      active sync   /dev/sdl1
        6       8       33        6      active sync   /dev/sdc1
        7       8      145        7      active sync   /dev/sdj1
        8       8      161        8      active sync   /dev/sdk1
        9       8      113        9      active sync   /dev/sdh1
       10       8       97       10      active sync   /dev/sdg1

This array should contain a LUKS container, however, it's missing. If I=
=20
hexdump the first 20 lines, the LUKS header is completely missing:

# cryptsetup luksOpen /dev/md6 luks
Device /dev/md6 is not a valid LUKS device.

# hexdump -C /dev/md6 | head -n16
00000000  0b 37 89 e0 66 96 7a d4  6c 5b 57 09 a5 8d 6a c5=20
|.7..f.z.l[W...j.|
00000010  a7 65 20 6e f0 db 74 db  03 d8 e9 2b 39 05 37 a4  |.e=20
n..t....+9.7.|
00000020  cb 25 d7 7b fd cf b5 b4  12 ad e2 24 24 de 66 42=20
|.%.{.......$$.fB|
00000030  61 a2 1b ea 8b 5c 04 38  7e 5e 61 11 3d ba 99 35=20
|a....\.8~^a.=3D..5|
00000040  b7 e9 e6 76 72 18 d2 d5  bd cd 1b ed 59 15 fb 83=20
|...vr.......Y...|
00000050  bc 57 94 85 31 c1 3e af  51 f1 25 50 db 57 d3 cd=20
|.W..1.>.Q.%P.W..|
00000060  69 d5 31 23 df 01 ef 03  e3 92 66 c6 1f 38 3f 57=20
|i.1#......f..8?W|
00000070  67 20 38 8c c2 ec 25 dc  59 42 b4 5d 9d 9e c1 79  |g=20
8...%.YB.]...y|
00000080  4a f5 e1 ad f8 08 16 d5  37 3f f6 83 62 f2 6f f5=20
|J.......7?..b.o.|
00000090  53 95 4f 69 ce 7c ba 4c  86 ef a1 1c 04 d7 b3 17=20
|S.Oi.|.L........|
000000a0  cd ea 5f 25 56 a4 0d 6f  64 e9 51 b5 71 b3 18 7f=20
|.._%V..od.Q.q...|
000000b0  46 e7 8b ab 08 ae f5 ed  65 0d 8f 3e 8b 03 25 5c=20
|F.......e..>..%\|
000000c0  bb 50 dc e6 31 33 4a 88  8e 22 20 72 f0 11 71 d0 |.P..13J.."=20
r..q.|
000000d0  59 c7 9d 20 f8 e2 f0 f8  75 5f ea 4a 57 d7 d7 9e  |Y..=20
=2E...u_.JW...|
000000e0  c8 05 85 9d d7 cf c9 ab  53 de 11 6f bf d4 e3 b2=20
|........S..o....|
000000f0  f6 5e 1e 46 5c 16 ae 46  a3 b5 9b f4 b9 ff ca 0c=20
|.^.F\..F........|

Is the "mdadm --create" operation that I issued, incorrect? Have I done=
=20
anything in error?

Unfortunately, I do not have a backup of the LUKS header, as I've=20
personally never encountered a situation like this, nor was I privy to=20
the knowledge that LUKS headers should be backed up at all.

If relevant, I did observe that /dev/sdb1 and /dev/sdg1 were showing=20
"Offline_Uncorrectable" errors via SMART, but nothing that I could=20
imagine would have contributed to this current predicament.

Is my data gone? Any and all insight are extremly welcomed and apprecia=
ted.

Warm regards,

-xar
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
