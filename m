From: Aaron Greenspan <aarong@thinkcomputer.com>
Subject: mdadm --grow Hard Drive Size Puzzle
Date: Sat, 29 Sep 2012 19:19:34 -0700
Message-ID: <67FBE301-6EF3-4B0D-87FC-8A3C66473416@thinkcomputer.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

I found your personal web site by doing a Google search on mdadm, so I'm not sure if you are the right person to ask this of, or if it's a dumb question in the first place, but here's what I'm running into.

I had a RAID 1 array on CentOS 6 (which comes with mdadm 3.2.3) of two 250GB SATA Western Digital hard drives. It was finally time to upgrade their capacity, so I purchased two 2TB SATA Seagate hard drives. I replaced them one at a time, first by removing old drive B (slot 1), then copying over the partitions from old drive A (slot 0) to new drive C (slot 1), and then swapping the drives so that I could copy the partitions from new drive C (slot 0) to drive D (slot 1).

This generally worked fine, with one exception. As I said, the drives are 2TB each. Somehow I'm only being given 1TB to work with. Here's what mdadm reports for the first new drive:

[root@kermit plainsite]# mdadm --examine /dev/sda5
/dev/sda5:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x0
     Array UUID : 15f9c88e:502e7c20:cdceb61e:fa745c07
           Name : localhost.localdomain:3
  Creation Time : Tue Aug  9 13:31:58 2011
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 3462374884 (1650.99 GiB 1772.74 GB)
     Array Size : 1731187442 (825.49 GiB 886.37 GB)
  Used Dev Size : 1731187442 (825.49 GiB 886.37 GB)
    Data Offset : 2048 sectors
   Super Offset : 0 sectors
          State : clean
    Device UUID : bbe2518d:ccd383d3:476b9ab4:54f4f1f7

    Update Time : Sat Sep 29 20:09:12 2012
       Checksum : 725e9e7d - correct
         Events : 16261


   Device Role : Active device 1
   Array State : AA ('A' == active, '.' == missing)

...and the second...

[root@kermit plainsite]# mdadm --examine /dev/sdb5
/dev/sdb5:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x0
     Array UUID : 15f9c88e:502e7c20:cdceb61e:fa745c07
           Name : localhost.localdomain:3
  Creation Time : Tue Aug  9 13:31:58 2011
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 3462374884 (1650.99 GiB 1772.74 GB)
     Array Size : 1731187442 (825.49 GiB 886.37 GB)
  Used Dev Size : 1731187442 (825.49 GiB 886.37 GB)
    Data Offset : 2048 sectors
   Super Offset : 0 sectors
          State : clean
    Device UUID : dd133b6e:55cf2958:4b39275f:4f9d2cf3

    Update Time : Sat Sep 29 20:09:12 2012
       Checksum : 7db54225 - correct
         Events : 16261


   Device Role : Active device 0
   Array State : AA ('A' == active, '.' == missing)

The big question is why the "Avail Dev Size" is 1772.74 GB, but the "Array Size" is only 886.37 GB. When I run mdadm --grow /dev/md3 --size=max, I get this:

[root@kermit plainsite]# mdadm --grow /dev/md3 --size=max
mdadm: component size of /dev/md3 unchanged at 865593721K

If I try to force it, I get this:

[root@kermit plainsite]# mdadm --grow /dev/md3 --size=1731187442
mdadm: Cannot set device size for /dev/md3: No space left on device

The other partitions are not taking up the other 1TB; it definitely seems available. Just so you have more data, here's the output of some other commands:

---

[root@kermit plainsite]# more /proc/mdstat 
Personalities : [raid1] 
md2 : active raid1 sdb3[3] sda3[2]
      1020115 blocks super 1.2 [2/2] [UU]
      
md3 : active raid1 sdb5[2] sda5[3]
      865593721 blocks super 1.1 [2/2] [UU]
      
md1 : active raid1 sdb2[2] sda2[3]
      221182844 blocks super 1.1 [2/2] [UU]
      bitmap: 0/2 pages [0KB], 65536KB chunk

md0 : active raid1 sdb1[2] sda1[3]
      102388 blocks super 1.0 [2/2] [UU]
      
unused devices: <none>

---

[root@kermit etc]# hdparm -i /dev/sda

/dev/sda:

 Model=ST2000DM001-9YN164, FwRev=CC46, SerialNo=W2F02P7Y
 Config={ HardSect NotMFM HdSw>15uSec Fixed DTR>10Mbs RotSpdTol>.5% }
 RawCHS=16383/16/63, TrkSize=0, SectSize=0, ECCbytes=4
 BuffType=unknown, BuffSize=unknown, MaxMultSect=16, MultSect=16
 CurCHS=16383/16/63, CurSects=16514064, LBA=yes, LBAsects=3907029168
 IORDY=on/off, tPIO={min:120,w/IORDY:120}, tDMA={min:120,rec:120}
 PIO modes:  pio0 pio1 pio2 pio3 pio4 
 DMA modes:  mdma0 mdma1 mdma2 
 UDMA modes: udma0 udma1 udma2 udma3 udma4 udma5 *udma6 
 AdvancedPM=yes: unknown setting WriteCache=enabled
 Drive conforms to: unknown:  ATA/ATAPI-4,5,6,7

 * signifies the current active mode

---

[root@kermit etc]# hdparm -i /dev/sdb

/dev/sdb:

 Model=ST2000DM001-9YN164, FwRev=CC46, SerialNo=W2F02PE2
 Config={ HardSect NotMFM HdSw>15uSec Fixed DTR>10Mbs RotSpdTol>.5% }
 RawCHS=16383/16/63, TrkSize=0, SectSize=0, ECCbytes=4
 BuffType=unknown, BuffSize=unknown, MaxMultSect=16, MultSect=16
 CurCHS=16383/16/63, CurSects=16514064, LBA=yes, LBAsects=3907029168
 IORDY=on/off, tPIO={min:120,w/IORDY:120}, tDMA={min:120,rec:120}
 PIO modes:  pio0 pio1 pio2 pio3 pio4 
 DMA modes:  mdma0 mdma1 mdma2 
 UDMA modes: udma0 udma1 udma2 udma3 udma4 udma5 *udma6 
 AdvancedPM=yes: unknown setting WriteCache=enabled
 Drive conforms to: unknown:  ATA/ATAPI-4,5,6,7

 * signifies the current active mode

---

[root@kermit /]# df
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/md3             852011868 730683448  78060472  91% /
tmpfs                  2010380         0   2010380   0% /dev/shm
/dev/md0                 99138     90797      3222  97% /boot
/dev/md1             217711416 104934568 101717708  51% /home

---

[root@kermit etc]# more mdadm.conf 
# mdadm.conf written out by anaconda
MAILADDR root
AUTO +imsm +1.x -all
ARRAY /dev/md0 level=raid1 num-devices=2 UUID=1871a7f9:dcb6f1e0:53fc2afe:edc5ea24
ARRAY /dev/md1 level=raid1 num-devices=2 UUID=96b2d1ae:401c7fd8:da33bdac:4a5c1252
ARRAY /dev/md2 level=raid1 num-devices=2 UUID=6f6eecca:718bd092:ddf96dca:18317b4c
ARRAY /dev/md3 level=raid1 num-devices=2 UUID=15f9c88e:502e7c20:cdceb61e:fa745c07

---

[root@kermit etc]# mdadm --detail /dev/md3
/dev/md3:
        Version : 1.1
  Creation Time : Tue Aug  9 13:31:58 2011
     Raid Level : raid1
     Array Size : 865593721 (825.49 GiB 886.37 GB)
  Used Dev Size : 865593721 (825.49 GiB 886.37 GB)
   Raid Devices : 2
  Total Devices : 2
    Persistence : Superblock is persistent

    Update Time : Sat Sep 29 17:49:37 2012
          State : active 
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           Name : localhost.localdomain:3
           UUID : 15f9c88e:502e7c20:cdceb61e:fa745c07
         Events : 15287

    Number   Major   Minor   RaidDevice State
       2       8       21        0      active sync   /dev/sdb5
       3       8        5        1      active sync   /dev/sda5

---

Any thoughts?

Thanks,

Aaron
	
Aaron Greenspan
President & CEO
Think Computer Corporation

telephone +1 415 670 9350
toll free +1 888 815 8599
fax +1 415 373 3959
e-mail aarong@thinkcomputer.com
web http://www.thinkcomputer.com