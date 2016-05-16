From: Wolfgang Denk <wd@denx.de>
Subject: Re: MD RAID6 corrupted by Avago 9260-4i controller [SOLVED]
Date: Mon, 16 May 2016 14:06:00 +0200
Message-ID: <20160516120600.5428910035C@atlas.denx.de>
References: <20160515124534.A42D0100879@atlas.denx.de> <20160515133740.85EC3100879@atlas.denx.de> <20160515153121.GA11365@EIS.leimen.priv> <20160515182524.7B12D100A8E@atlas.denx.de> <20160515183128.GA12823@EIS.leimen.priv> <20160515193516.2C457100879@atlas.denx.de> <20160515203446.GA13218@EIS.leimen.priv> <20160515231046.E3685100A8E@atlas.denx.de> <20160516083903.GA29380@EIS.leimen.priv>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20160516083903.GA29380@EIS.leimen.priv>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Andreas,

In message <20160516083903.GA29380@EIS.leimen.priv> you wrote:
>
> First, you can use hexdump after all to have a look at the first chunk 
> (assuming the 136KiB you found is actually the data offset).
> 
> dd bs=136K skip=1 if=/dev/mapper/sda | hexdump -C | less
> 
> (same for sd?)
> 
> LVM metadata is in plaintext, example:

Well, this does not look so bad:

00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000200  4c 41 42 45 4c 4f 4e 45  01 00 00 00 00 00 00 00  |LABELONE........|
00000210  3c fe 50 23 20 00 00 00  4c 56 4d 32 20 30 30 31  |<.P# ...LVM2 001|
00000220  34 79 78 49 78 69 48 73  6a 68 79 64 48 6f 76 58  |4yxIxiHsjhydHovX|
00000230  55 4f 30 48 47 31 5a 70  51 45 50 53 33 43 49 61  |UO0HG1ZpQEPS3CIa|
00000240  00 00 65 83 a3 03 00 00  00 00 03 00 00 00 00 00  |..e.............|
00000250  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00000260  00 00 00 00 00 00 00 00  00 10 00 00 00 00 00 00  |................|
00000270  00 f0 02 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00000280  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00001000  3a fe b8 5d 20 4c 56 4d  32 20 78 5b 35 41 25 72  |:..] LVM2 x[5A%r|
00001010  30 4e 2a 3e 01 00 00 00  00 10 00 00 00 00 00 00  |0N*>............|
00001020  00 f0 02 00 00 00 00 00  00 80 00 00 00 00 00 00  |................|
00001030  46 0b 00 00 00 00 00 00  65 8d d7 42 00 00 00 00  |F.......e..B....|
00001040  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00001200  63 61 73 74 6f 72 30 20  7b 0a 69 64 20 3d 20 22  |castor0 {.id = "|
00001210  56 33 52 6e 30 55 2d 47  4d 41 64 2d 34 55 73 4e  |V3Rn0U-GMAd-4UsN|
00001220  2d 61 6d 35 69 2d 66 50  59 50 2d 41 43 37 70 2d  |-am5i-fPYP-AC7p-|
00001230  66 4d 50 51 32 35 22 0a  73 65 71 6e 6f 20 3d 20  |fMPQ25".seqno = |
00001240  31 0a 73 74 61 74 75 73  20 3d 20 5b 22 52 45 53  |1.status = ["RES|
00001250  49 5a 45 41 42 4c 45 22  2c 20 22 52 45 41 44 22  |IZEABLE", "READ"|
00001260  2c 20 22 57 52 49 54 45  22 5d 0a 65 78 74 65 6e  |, "WRITE"].exten|
00001270  74 5f 73 69 7a 65 20 3d  20 38 31 39 32 0a 6d 61  |t_size = 8192.ma|
00001280  78 5f 6c 76 20 3d 20 30  0a 6d 61 78 5f 70 76 20  |x_lv = 0.max_pv |
00001290  3d 20 30 0a 0a 70 68 79  73 69 63 61 6c 5f 76 6f  |= 0..physical_vo|
000012a0  6c 75 6d 65 73 20 7b 0a  0a 70 76 30 20 7b 0a 69  |lumes {..pv0 {.i|
000012b0  64 20 3d 20 22 34 79 78  49 78 69 2d 48 73 6a 68  |d = "4yxIxi-Hsjh|
000012c0  2d 79 64 48 6f 2d 76 58  55 4f 2d 30 48 47 31 2d  |-ydHo-vXUO-0HG1-|
000012d0  5a 70 51 45 2d 50 53 33  43 49 61 22 0a 64 65 76  |ZpQE-PS3CIa".dev|
000012e0  69 63 65 20 3d 20 22 2f  64 65 76 2f 6d 64 32 22  |ice = "/dev/md2"|
000012f0  0a 0a 73 74 61 74 75 73  20 3d 20 5b 22 41 4c 4c  |..status = ["ALL|
00001300  4f 43 41 54 41 42 4c 45  22 5d 0a 64 65 76 5f 73  |OCATABLE"].dev_s|
00001310  69 7a 65 20 3d 20 37 38  31 34 30 39 39 35 38 34  |ize = 7814099584|
00001320  0a 70 65 5f 73 74 61 72  74 20 3d 20 33 38 34 0a  |.pe_start = 384.|
00001330  70 65 5f 63 6f 75 6e 74  20 3d 20 39 35 33 38 36  |pe_count = 95386|
00001340  39 0a 7d 0a 7d 0a 0a 7d  0a 23 20 47 65 6e 65 72  |9.}.}..}.# Gener|
00001350  61 74 65 64 20 62 79 20  4c 56 4d 32 20 76 65 72  |ated by LVM2 ver|
00001360  73 69 6f 6e 20 32 2e 30  32 2e 33 39 20 28 32 30  |sion 2.02.39 (20|
00001370  30 38 2d 30 36 2d 32 37  29 3a 20 54 75 65 20 4a  |08-06-27): Tue J|
00001380  61 6e 20 31 38 20 31 33  3a 30 31 3a 30 31 20 32  |an 18 13:01:01 2|
00001390  30 31 31 0a 0a 63 6f 6e  74 65 6e 74 73 20 3d 20  |011..contents = |
...

> For me this starts at offset 0x1200 (roughly 4K) should be well within 
> your 16K chunk. It should look similar for you on one of your disks if 
> the offset is correct.

Confirmed.  So we can assume the offset if OK...

> You are using your disks in alphabetical order, are you sure this is 
> the same order your RAID originally used? Maybe the drive letters 
> changed?

I rechecked again...

> You found LABELONE on sda, which is your first drive (Device Role 0) 
> in your RAID (see mdadm --examine after you create it), but when I 
> create a new RAID based on loop devices, pvcreate and vgcreate it, 
> the LABELONE actually appears on the 2nd drive (Device Role 1).

Confirmed. When I create a new array and pvcreate and vgcreate it, I
also see the LABELONE on /dev/mapper/sdb, at offset

	134218240 LABELONE

= 131072 kB.

OK, so I started playing around with the disk order - even though I
checked yet another time from the disk serial numbers that the drive
order "a b c d e f" is what was used when initially creating the
array. When swapping the first two disks (so sda where the LABELONE
is present) becomes the second disk (i. e. "b a c d e f"), then LVM
will recognize the volume group and volumes, but data are corrupted.

So I guess I have to try the possible permutations (probably with sda
being the second disk only).

Doing that now.  But I have no idea what could cause this...

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
Just because your doctor has a name for your condition  doesn't  mean
he knows what it is.
