From: Jon Hardcastle <jd_hardcastle@yahoo.com>
Subject: Is this likely to cause me problems?
Date: Tue, 21 Sep 2010 13:33:21 -0700 (PDT)
Message-ID: <965992.31969.qm@web51304.mail.re2.yahoo.com>
Reply-To: Jon@eHardcastle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I am finally replacing an old and now failed drive with a new one.

I normally create a partition the size of the entire disk and add that but whilst checking the sizes marry up i noticed that is an odity...

Below is an fdisk dump of all the drives in my RAID6 array

sdc---
/dev/sdc1            2048  1953525167   976761560   fd  Linux raid autodetect
---
Seems to be different to sda say which is also '1TB'

sda---
/dev/sda1              63  1953520064   976760001   fd  Linux raid autodetect
---

Now i read somewhere that the sizes flucuate but as some core value remains the same can anyone confirm if this is the case?

I am reluctant to add to my array until i know for sure...

Disk /dev/sda: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders, total 1953525168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0xabb7ea39

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1              63  1953520064   976760001   fd  Linux raid autodetect

Disk /dev/sdb: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders, total 976773168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1              63   976768064   488384001   fd  Linux raid autodetect

Disk /dev/sdc: 1000.2 GB, 1000204886016 bytes
81 heads, 63 sectors/track, 382818 cylinders, total 1953525168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0xc7314361

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1            2048  1953525167   976761560   fd  Linux raid autodetect

Disk /dev/sdd: 750.2 GB, 750156374016 bytes
255 heads, 63 sectors/track, 91201 cylinders, total 1465149168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

   Device Boot      Start         End      Blocks   Id  System
/dev/sdd1              63  1465144064   732572001   fd  Linux raid autodetect

Disk /dev/sde: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders, total 1953525168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

   Device Boot      Start         End      Blocks   Id  System
/dev/sde1              63  1953520064   976760001   fd  Linux raid autodetect

Disk /dev/sdf: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders, total 1953525168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x4d291cc0

   Device Boot      Start         End      Blocks   Id  System
/dev/sdf1              63  1953520064   976760001   fd  Linux raid autodetect

Disk /dev/sdg: 750.2 GB, 750156374016 bytes
255 heads, 63 sectors/track, 91201 cylinders, total 1465149168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

   Device Boot      Start         End      Blocks   Id  System
/dev/sdg1              63  1465144064   732572001   fd  Linux raid autodetect


-----------------------
N: Jon Hardcastle
E: Jon@eHardcastle.com
'There comes a time when you look into the mirror, and you realise that what you see is all that you will ever be. Then you accept it, or you kill yourself. Or you stop looking into mirrors... :)'

***********
Please note, I am phasing out jd_hardcastle AT yahoo.com and replacing it with jon AT eHardcastle.com
***********

-----------------------


      
