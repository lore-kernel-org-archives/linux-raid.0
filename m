From: Janusz Zamecki <janusz@pipi.ma.cx>
Subject: RAID1 & 2.6.9 performance problem
Date: Mon, 17 Jan 2005 16:22:15 +0100
Message-ID: <41EBD827.80701@pipi.ma.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello!

After days of googling I've gave up and decided to ask for help.

The story is very simple: I have /dev/md6 raid1 array made of hdg and 
hde disks. The resulting array is as fast as 1 disk only.

Please check this out:

hdparm -t /dev/hdg /dev/hde /dev/md6

/dev/hdg:
  Timing buffered disk reads:  184 MB in  3.03 seconds =  60.76 MB/sec

/dev/hde:
  Timing buffered disk reads:  184 MB in  3.01 seconds =  61.08 MB/sec

/dev/md6:
  Timing buffered disk reads:  184 MB in  3.03 seconds =  60.74 MB/sec

I've expected much better /dev/md6 performance (at least 100MB/s).

It seems that md6 uses one drive only. This is the dstat output:

dstat -d -Dhdg,hde

--disk/hdg----disk/hde-
_read write _read write
    0     0 :   0     0
    0     0 :   0     0
    0     0 :52.5M    0
    0     0 :61.4M    0
    0     0 :62.5M    0
    0     0 :8064k    0
    0     0 :   0     0
    0     0 :   0     0
    0     0 :   0     0
23.9M    0 :   0     0
   62M    0 :   0     0
62.5M    0 :   0     0
33.9M    0 :   0     0
    0     0 :   0     0

In second terminal I've ran hdparm -t /dev/md6 twice (one by one).
As you can see the first hdparm reads from hde, while the second hdparm 
test reads from hdg. The next test reads from hde and so on.

I've tried to run small script, to run two hdparm tests simultanously:

hdparm -t /dev/md6 &
hdparm -t /dev/md6

This is the result:

--disk/hdg----disk/hde-
_read write _read write
    0     0 :   0     0
    0     0 :   0     0
  124k    0 :26.0M    0
  368k    0 :45.5M    0
    0     0 :   0     0
    0     0 : 896k    0
  124k    0 :1568k    0
    0     0 :   0     0

Strange, seems that hde is preferred.
If I run the same test again:

    0     0 :   0     0
30.6M    0 : 112k    0
41.1M    0 : 116k    0
    0     0 :   0     0
  360k    0 :   0     0
  124k    0 : 416k    0
    0     0 :   0     0

This time hdg is the preferred disk.

What is wrong? Is it possible to balance reads from both disks?

If you need more details I will more than happy to
send them to the list.

Best regards, Janusz

P.S.
More info:

cat /proc/mdstat
Personalities : [raid1]
md6 : active raid1 hdg[1] hde[0]
       195360896 blocks [2/2] [UU]



hdparm -i /dev/hdg /dev/hde

/dev/hdg:

  Model=ST3200822A, FwRev=3.01, SerialNo=***
  Config={ HardSect NotMFM HdSw>15uSec Fixed DTR>10Mbs RotSpdTol>.5% }
  RawCHS=16383/16/63, TrkSize=0, SectSize=0, ECCbytes=4
  BuffType=unknown, BuffSize=8192kB, MaxMultSect=16, MultSect=16
  CurCHS=65535/1/63, CurSects=4128705, LBA=yes, LBAsects=268435455
  IORDY=on/off, tPIO={min:240,w/IORDY:120}, tDMA={min:120,rec:120}
  PIO modes:  pio0 pio1 pio2 pio3 pio4
  DMA modes:  mdma0 mdma1 mdma2
  UDMA modes: udma0 udma1 udma2 udma3 udma4 *udma5
  AdvancedPM=no WriteCache=enabled
  Drive conforms to: ATA/ATAPI-6 T13 1410D revision 2:

/dev/hde:

  Model=ST3200822A, FwRev=3.01, SerialNo=***
  Config={ HardSect NotMFM HdSw>15uSec Fixed DTR>10Mbs RotSpdTol>.5% }
  RawCHS=16383/16/63, TrkSize=0, SectSize=0, ECCbytes=4
  BuffType=unknown, BuffSize=8192kB, MaxMultSect=16, MultSect=16
  CurCHS=65535/1/63, CurSects=4128705, LBA=yes, LBAsects=268435455
  IORDY=on/off, tPIO={min:240,w/IORDY:120}, tDMA={min:120,rec:120}
  PIO modes:  pio0 pio1 pio2 pio3 pio4
  DMA modes:  mdma0 mdma1 mdma2
  UDMA modes: udma0 udma1 udma2 udma3 udma4 *udma5
  AdvancedPM=no WriteCache=enabled
  Drive conforms to: ATA/ATAPI-6 T13 1410D revision 2:



hdparm  /dev/hdg /dev/hde

/dev/hdg:
  multcount    = 16 (on)
  IO_support   =  1 (32-bit)
  unmaskirq    =  1 (on)
  using_dma    =  1 (on)
  keepsettings =  0 (off)
  readonly     =  0 (off)
  readahead    = 512 (on)
  geometry     = 24321/255/63, sectors = 390721968, start = 0

/dev/hde:
  multcount    = 16 (on)
  IO_support   =  1 (32-bit)
  unmaskirq    =  1 (on)
  using_dma    =  1 (on)
  keepsettings =  0 (off)
  readonly     =  0 (off)
  readahead    = 512 (on)
  geometry     = 24321/255/63, sectors = 390721968, start = 0

from dmesg:
SiI680: IDE controller at PCI slot 0000:00:0b.0
SiI680: chipset revision 2
SiI680: BASE CLOCK == 133
SiI680: 100% native mode on irq 5
     ide2: MMIO-DMA , BIOS settings: hde:pio, hdf:pio
     ide3: MMIO-DMA , BIOS settings: hdg:pio, hdh:pio

