From: Bruce Pinsky <bep@whack.org>
Subject: RAID strangeness
Date: Tue, 27 May 2003 00:36:43 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3ED3158B.3080200@whack.org>
Reply-To: bep@whack.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a four disk RAID 5 array running on my SPARC 10 running Debian 
3.0+ (2.4.20 kernel) and RAID raidtools-0.90 with this raidtab:

raiddev /dev/md0
         raid-level      5
         nr-raid-disks   4
         nr-spare-disks  0
         persistent-superblock 1
         parity-algorithm        left-symmetric
         chunk-size      32
         device          /dev/sdc1
         raid-disk       0
         device          /dev/sdd1
         raid-disk       1
         device          /dev/sde1
         raid-disk       2
         device          /dev/sdf1
         raid-disk       3

It was up and running for more than a month until this weekend.  My 
system rebooted unexpectedly (looks like a power failure at this point) 
and when it rebooted I got this message:

raid5: measuring checksumming speed
    8regs     :    60.000 MB/sec
    32regs    :    62.400 MB/sec
    SPARC     :    81.600 MB/sec
raid5: using function: SPARC (81.600 MB/sec)
md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
md: raid5 personality registered as nr 4
md: could not lock sdc1, zero-size? Marking faulty.
md: could not import sdc1!
md: autostart sdc1 failed!

Investigation has led me to think that my partition tables have 
disappeared based on this:

son-of-spike:/usr/share/doc/raidtools2#  fdisk -l

Disk /dev/sda (Sun disk label): 3 heads, 415 sectors, 14382 cylinders
Units = cylinders of 1245 * 512 bytes

    Device Flag    Start       End    Blocks   Id  System
/dev/sda1             1      7191   4475775   83  Linux native
/dev/sda2          7192     14382   4475775   83  Linux native
/dev/sda3             0     14382   8952795    5  Whole disk

Disk /dev/sdb (Sun disk label): 11 heads, 108 sectors, 3528 cylinders
Units = cylinders of 1188 * 512 bytes

    Device Flag    Start       End    Blocks   Id  System
/dev/sdb1             1       259    153252   83  Linux native
/dev/sdb2  u        260       701    261954   82  Linux swap
/dev/sdb3             0      3528   2095632    5  Whole disk
/dev/sdb7           702      3528   1678644   83  Linux native

Disk /dev/sdc: 64 heads, 32 sectors, 8683 cylinders
Units = cylinders of 2048 * 512 bytes

Disk /dev/sdc doesn't contain a valid partition table

Disk /dev/sdd: 64 heads, 32 sectors, 8683 cylinders
Units = cylinders of 2048 * 512 bytes

Disk /dev/sdd doesn't contain a valid partition table

Disk /dev/sde: 64 heads, 32 sectors, 8683 cylinders
Units = cylinders of 2048 * 512 bytes

Disk /dev/sde doesn't contain a valid partition table

Disk /dev/sdf: 64 heads, 32 sectors, 8683 cylinders
Units = cylinders of 2048 * 512 bytes

Disk /dev/sdf doesn't contain a valid partition table



Thankfully nothing too important on the array yet, but I'm concerned for 
when I do put stuff on it.  Anyone seen a situation where the array 
craps and the partition tables are missing?   Can it be recovered? 
Something wrong with my RAID setup?

Thanks for the help...

-- 
==========
bep

