From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: MD RAID6 corrupted by Avago 9260-4i controller [SOLVED]
Date: Mon, 16 May 2016 10:39:03 +0200
Message-ID: <20160516083903.GA29380@EIS.leimen.priv>
References: <20160515124534.A42D0100879@atlas.denx.de>
 <20160515133740.85EC3100879@atlas.denx.de>
 <20160515153121.GA11365@EIS.leimen.priv>
 <20160515182524.7B12D100A8E@atlas.denx.de>
 <20160515183128.GA12823@EIS.leimen.priv>
 <20160515193516.2C457100879@atlas.denx.de>
 <20160515203446.GA13218@EIS.leimen.priv>
 <20160515231046.E3685100A8E@atlas.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160515231046.E3685100A8E@atlas.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, May 16, 2016 at 01:10:46AM +0200, Wolfgang Denk wrote:
> NO, I think it's me to blame.  If I read the bash history correctly,
> I made a mistake (confusing $DEVICES and $devices and $overlays)
> and ran the --zero-superblock on the real disk devices, not the overlays.

Ooh. :(
 
> On the other hand, that should not make a real difference if it worked
> for the overlays.  Well, it does...

About that, I don't know either.

> That would be the --data-offset= parameter?

Yes.

> It does - but I'm confused as I get a number of different values from
> the devices:

You can ignore those that don't even align to 512 bytes.

> So I have 5 numbers; minus 512 and converted to kB gives:
> 
> Of these, only 136 appears to make sense.  But running
> 
> # mdadm --create --verbose /dev/md2 --metadata=1.2 --level=6 --raid-devices=6 --chunk=16 --assume-clean --data-offset=136 /dev/mapper/sd?
> 
> ...creates an array, but LVM does not recognise it.

So, now here's a puzzle.

First, you can use hexdump after all to have a look at the first chunk 
(assuming the 136KiB you found is actually the data offset).

dd bs=136K skip=1 if=/dev/mapper/sda | hexdump -C | less

(same for sd?)

LVM metadata is in plaintext, example:

| 00001200  53 53 44 20 7b 0a 69 64  20 3d 20 22 74 58 4a 43  |SSD {.id = "tXJC|
| 00001210  77 31 2d 71 51 69 6e 2d  4b 78 31 6b 2d 30 65 78  |w1-qQin-Kx1k-0ex|
| 00001220  79 2d 32 6e 4d 76 2d 6a  63 57 78 2d 4f 48 70 76  |y-2nMv-jcWx-OHpv|
| 00001230  76 69 22 0a 73 65 71 6e  6f 20 3d 20 36 38 0a 66  |vi".seqno = 68.f|
| 00001240  6f 72 6d 61 74 20 3d 20  22 6c 76 6d 32 22 0a 73  |ormat = "lvm2".s|
| 00001250  74 61 74 75 73 20 3d 20  5b 22 52 45 53 49 5a 45  |tatus = ["RESIZE|
| 00001260  41 42 4c 45 22 2c 20 22  52 45 41 44 22 2c 20 22  |ABLE", "READ", "|
| 00001270  57 52 49 54 45 22 5d 0a  66 6c 61 67 73 20 3d 20  |WRITE"].flags = |

For me this starts at offset 0x1200 (roughly 4K) should be well within 
your 16K chunk. It should look similar for you on one of your disks if 
the offset is correct.

You are using your disks in alphabetical order, are you sure this is 
the same order your RAID originally used? Maybe the drive letters 
changed?

You found LABELONE on sda, which is your first drive (Device Role 0) 
in your RAID (see mdadm --examine after you create it), but when I 
create a new RAID based on loop devices, pvcreate and vgcreate it, 
the LABELONE actually appears on the 2nd drive (Device Role 1).

| # cat /proc/mdstat 
| Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4] 
| md42 : active raid6 loop5[5] loop4[4] loop3[3] loop2[2] loop1[1] loop0[0]
|       64960 blocks super 1.2 level 6, 16k chunk, algorithm 2 [6/6] [UUUUUU]

| # strings -t d -n 8 /dev/loop0 | grep LABELONE
| # strings -t d -n 8 /dev/loop1 | grep LABELONE
|  139776 LABELONE

| # dd bs=136K skip=1 if=/dev/loop1 | hexdump -C -n $((16*1024)) | head
| 00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
| *
| 00000200  4c 41 42 45 4c 4f 4e 45  01 00 00 00 00 00 00 00  |LABELONE........|
| 00000210  e0 3d e7 de 20 00 00 00  4c 56 4d 32 20 30 30 31  |.=.. ...LVM2 001|
| 00000220  58 48 67 41 68 45 70 76  4c 53 36 61 41 62 4d 77  |XHgAhEpvLS6aAbMw|
| 00000230  50 6e 4c 57 4c 64 4a 46  6d 36 30 54 48 66 6d 75  |PnLWLdJFm60THfmu|

So I assume in the default left-symmetric layout in RAID6, the first chunk 
of the first disk actually ends up being a parity chunk...? I'm not too 
sure about this either right now. ;)

Regards
Andreas Klauer
