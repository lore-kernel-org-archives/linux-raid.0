From: Bryan Christ <bryan.christ@hp.com>
Subject: Re: Raid array is not automatically detected.
Date: Wed, 18 Jul 2007 09:39:34 -0500
Message-ID: <469E2626.30204@hp.com>
References: <4697E231.3070906@hp.com> <4698D4FC.2060100@tmr.com> <Pine.LNX.4.64.0707140952440.31528@p34.internal.lan> <469B7E75.3030907@hp.com> <469B8D05.1080003@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <469B8D05.1080003@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, Bill Davidsen <davidsen@tmr.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm now very confused...

When I run mdadm --examine /dev/md0 I get the error message:  No 
superblock detected on /dev/md0

However, when I run mdadm -D /dev/md0 the report clearly states 
"Superblock is persistent"

/dev/md0:
         Version : 00.90.03
   Creation Time : Tue Jul 17 10:17:37 2007
      Raid Level : raid5
      Array Size : 1953535744 (1863.04 GiB 2000.42 GB)
   Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
    Raid Devices : 5
   Total Devices : 5
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Wed Jul 18 10:17:34 2007
           State : clean
  Active Devices : 5
Working Devices : 5
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 64K

            UUID : ea6c5a9f:021b4ff8:fc5a08c4:23fc5c4b
          Events : 0.4

     Number   Major   Minor   RaidDevice State
        0       8        1        0      active sync   /dev/sda1
        1       8       17        1      active sync   /dev/sdb1
        2       8       33        2      active sync   /dev/sdc1
        3       8       49        3      active sync   /dev/sdd1
        4       8       65        4      active sync   /dev/sde1

David Greaves wrote:
> Bryan Christ wrote:
>> I do have the type set to 0xfd.  Others have said that auto-assemble 
>> only works on RAID 0 and 1, but just as Justin mentioned, I too have 
>> another box with RAID5 that gets auto assembled by the kernel (also no 
>> initrd).  I expected the same behavior when I built this array--again 
>> using mdadm instead of raidtools.
> 
> Any md arrays with partition type 0xfd using a 0.9 superblock should be 
> auto-assembled by a standard kernel.
> 
> If you want to boot from them you must ensure the kernel image is on a 
> partition that the bootloader can read - ie RAID 0. This is nothing to 
> do with auto-assembly.
> 
> So some questions:
> * are the partitions 0xfd ? yes.
> * is the kernel standard?
> * are the superblocks version 0.9? (mdadm --examine /dev/component)
> 
> David
> 
