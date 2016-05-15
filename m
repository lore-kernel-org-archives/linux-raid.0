From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: MD RAID6 corrupted by Avago 9260-4i controller [SOLVED]
Date: Sun, 15 May 2016 22:34:46 +0200
Message-ID: <20160515203446.GA13218@EIS.leimen.priv>
References: <20160515124534.A42D0100879@atlas.denx.de>
 <20160515133740.85EC3100879@atlas.denx.de>
 <20160515153121.GA11365@EIS.leimen.priv>
 <20160515182524.7B12D100A8E@atlas.denx.de>
 <20160515183128.GA12823@EIS.leimen.priv>
 <20160515193516.2C457100879@atlas.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160515193516.2C457100879@atlas.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, May 15, 2016 at 09:35:16PM +0200, Wolfgang Denk wrote:
> So I tried to repeat the same procedure, but it does not work any
> more:  after erasing the superblocks my attempts to assemble the array
> now give only:

That's strange, if it worked once, it should work twice (if no changes 
were made outside of the overlays). If you have created the udev rules 
file, just in case there is a side effect, remove it again ...

> 	#  mdadm --assemble  /dev/md2 --metadata=1.2  $overlays
> 	mdadm: no RAID superblock on /dev/mapper/sda
> 	mdadm: /dev/mapper/sda has no superblock - assembly aborted

What does mdadm --examine /dev/mapper/sda say before and after
you --zero-superblock? (is it the same for the other disks?)
 
> OK, I can recreate the array, but LVM does not recognize it.
> 
> You mentioned I had to play around with the offsets - do you have any
> idea which values would be reasonable to try out?

If it's LVM, you could search the first few hundred megs of your devices for
the LVM header, that should be the data offset you're looking for.

    hexdump -C -n $((1024*1024*1024)) /dev/mapper/sda | less

and then search for LABELONE

    /LABELONE

| 00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
| *
| 00000200  4c 41 42 45 4c 4f 4e 45  01 00 00 00 00 00 00 00  |LABELONE........|
| 00000210  c1 11 05 3d 20 00 00 00  4c 56 4d 32 20 30 30 31  |...= ...LVM2 001|
| 00000220  36 46 41 75 32 49 70 65  38 62 75 50 31 46 32 75  |6FAu2Ipe8buP1F2u|
| 00000230  38 4a 41 34 41 45 64 51  54 49 49 6b 4f 76 45 35  |8JA4AEdQTIIkOvE5|

That's LABELONE at offset 0x200 and you have to substract 512 bytes from it, 
so this is actually what it would look like for offset 0.

Alternatively this can also be done using

    dd bs=1M count=1024 if=... | strings -t d -n 8 | grep LABELONE
    512 LABELONE

if your version of strings supports this option.

Regards
Andreas Klauer
