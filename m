From: Ben Edwards <ben@serverone.co.uk>
Subject: Trying to work out how to mount Highpoint RAID
Date: Sun, 23 May 2004 19:56:57 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40B0F3F9.7000601@serverone.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linux RAID List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Trying to work out how to mount highpoint RAID array.  It was set up 
under Windows 2000 and has an NT file system, so I know it should be 
mounted read only.  I enclose output from dmesg below whitch is kind of 
odd because it seems hde is recognised OK but hdf has an 'unknown 
partision table'.

I also get a 'No raid array found' in messages (also included below.  So 
has anyone got any ideas what I do next, please bear in mond this is my 
first adventure into Linux RAID so I am a newbee as far as this is 
conserved.

Regards,
Ben

dmesg output:

...
HPT370A: 100% native mode on irq 11
    ide2: BM-DMA at 0xa400-0xa407, BIOS settings: hde:DMA, hdf:DMA
    ide3: BM-DMA at 0xa408-0xa40f, BIOS settings: hdg:pio, hdh:pio
hda: ST320410A, ATA DISK drive
hdb: TOSHIBA ODD-DVD SD-M1802, ATAPI CD/DVD-ROM drive
hdd: LITE-ON DVDRW SOHW-812S, ATAPI CD/DVD-ROM drive
hde: IC35L090AVV207-0, ATA DISK drive
hdf: IC35L090AVV207-0, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
ide2 at 0x9400-0x9407,0x9802 on irq 11
hda: max request size: 128KiB
hda: 39102336 sectors (20020 MB) w/2048KiB Cache, CHS=38792/16/63
 hda: hda1 hda2
hde: max request size: 1024KiB
hde: 160836480 sectors (82348 MB) w/1821KiB Cache, CHS=16383/255/63
 hde: hde1
hdf: max request size: 1024KiB
hdf: 160836480 sectors (82348 MB) w/1821KiB Cache, CHS=16383/255/63
 hdf: unknown partition table
...

/var/log/messages:
...
May  6 18:54:41 blue kernel: Highpoint HPT370 Softwareraid driver for 
linux version 0.01
May  6 18:54:41 blue kernel: No raid array found
...

-- 
Ben Edwards - currently in Bournemouth
http://www.gurtlush.org.uk - weblog
http://www.cultureshop.org - buy alternative video

