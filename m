From: "Ben Edwards (lists)" <lists@videonetwork.org>
Subject: Mounting NT Highpoint RAID disk
Date: Wed, 12 May 2004 22:03:54 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40A2913A.6070500@videonetwork.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linux RAID List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have a Hidhpoint RAID array in my PC whitch is accesable from XP.  I
am trying to work out how to mount it with kernel 2.6.3.

in /var/log/messages i haveApr 25 16:44:14
blue kernel: Highpoint HPT370 Softwareraid driver for linux version 0.01
Apr 25 16:44:14 blue kernel:
No raid array found

But there is a raid array.

I have also included dmesg output below whitch lists ide3/4 and hde/f
whitch I asume are the reaid drives.  Any ideas?

Regards,
Ben

ben@blue:~$ dmesg | grep hd
    ide0: BM-DMA at 0xf000-0xf007, BIOS settings: hda:DMA, hdb:DMA
    ide1: BM-DMA at 0xf008-0xf00f, BIOS settings: hdc:pio, hdd:DMA
    ide2: BM-DMA at 0xa400-0xa407, BIOS settings: hde:DMA, hdf:DMA
    ide3: BM-DMA at 0xa408-0xa40f, BIOS settings: hdg:pio, hdh:pio
hda: ST320410A, ATA DISK drive
hdb: TOSHIBA ODD-DVD SD-M1802, ATAPI CD/DVD-ROM drive
hdd: LITE-ON LTR-52327S, ATAPI CD/DVD-ROM drive
hde: IC35L090AVV207-0, ATA DISK drive
hdf: IC35L090AVV207-0, ATA DISK drive
hda: max request size: 128KiB
hda: 39102336 sectors (20020 MB) w/2048KiB Cache, CHS=38792/16/63
hda: hda1 hda2
hde: max request size: 1024KiB
hde: 160836480 sectors (82348 MB) w/1821KiB Cache, CHS=16383/255/63
hde: hde1
hdf: max request size: 1024KiB
hdf: 160836480 sectors (82348 MB) w/1821KiB Cache, CHS=16383/255/63
hdf: unknown partition table
hdb: ATAPI 48X DVD-ROM drive, 512kB Cache
hdd: ATAPI 52X CD-ROM CD-R/RW CD-MRW drive, 2048kB Cache
Adding 730916k swap on /dev/hda1.  Priority:-1 extents:1
EXT3 FS on hda2, internal journal



