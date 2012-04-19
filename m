From: Bill Davidsen <davidsen@tmr.com>
Subject: Removing a failing drive from multiple arrays
Date: Thu, 19 Apr 2012 14:54:30 -0400
Message-ID: <4F905F66.6070803@tmr.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090100000606050902030103"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------090100000606050902030103
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I have a failing drive, and partitions are in multiple arrays. I'm 
looking for the least painful and most reliable way to replace it. It's 
internal, I have a twin in an external box, and can create all the parts 
now and then swap the drive physically. The layout is complex, here's 
what blkdevtra tells me about this device, the full trace is attached.

Block device sdd, logical device 8:48
Model Family:     Seagate Barracuda 7200.10
Device Model:     ST3750640AS
Serial Number:    5QD330ZW
     Device size   732.575 GB
            sdd1     0.201 GB
            sdd2     3.912 GB
            sdd3    24.419 GB
            sdd4     0.000 GB
            sdd5    48.838 GB [md123] /mnt/workspace
            sdd6     0.498 GB
            sdd7    19.543 GB [md125]
            sdd8    29.303 GB [md126]
            sdd9   605.859 GB [md127] /exports/common
   Unpartitioned     0.003 GB

I think what I want to do is to partition the new drive, then one array 
at a time fail and remove the partition on the bad drive, and add a 
partition on the new good drive. Then repeat for each array until all 
are complete and on a new drive. Then I should be able to power off, 
remove the failed drive, put the good drive in the case, and the arrays 
should reassemble by UUID.

Does that sound right? Is there an easier way?

-- 
Bill Davidsen <davidsen@tmr.com>


--------------090100000606050902030103
Content-Type: text/plain;
 name="blkdevtrc.out"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="blkdevtrc.out"

block device trace for host pixels.tmr.com 2012-04-19 14:26

Block device sda, logical device 8:0
Device Model:     Patriot Pyro
Serial Number:    PT1210A00076662
    Device size    58.616 GB
           sda1     0.001 GB 
           sda2     0.512 GB /boot
           sda3    58.101 GB 
  Unpartitioned     0.002 GB
======
Block device sdb, logical device 8:16
Model Family:     Seagate Barracuda 7200.10
Device Model:     ST3750640AS
Serial Number:    5QD58GM2
    Device size   732.575 GB
           sdb1     0.201 GB [md121] 
           sdb2     3.912 GB [md120] SWAP
           sdb3    24.419 GB [md122] /mnt/root-fc9
           sdb4     0.000 GB 
           sdb5    48.838 GB [md123] /mnt/workspace
           sdb6     0.498 GB [md124] 
           sdb7    19.543 GB [md125] 
           sdb8    29.303 GB [md126] 
           sdb9   605.859 GB [md127] /exports/common
  Unpartitioned     0.003 GB
======
Block device sdc, logical device 8:32
Model Family:     Western Digital Caviar Green
Device Model:     WDC WD10EACS-00D6B1
Serial Number:    WD-WCAU44201083
    Device size   976.763 GB
           sdc1   976.760 GB /mnt/local
  Unpartitioned     0.003 GB
======
Block device sdd, logical device 8:48
Model Family:     Seagate Barracuda 7200.10
Device Model:     ST3750640AS
Serial Number:    5QD330ZW
    Device size   732.575 GB
           sdd1     0.201 GB 
           sdd2     3.912 GB 
           sdd3    24.419 GB 
           sdd4     0.000 GB 
           sdd5    48.838 GB [md123] /mnt/workspace
           sdd6     0.498 GB 
           sdd7    19.543 GB [md125] 
           sdd8    29.303 GB [md126] 
           sdd9   605.859 GB [md127] /exports/common
  Unpartitioned     0.003 GB
======
Block device sde, logical device 8:64
Model Family:     Seagate Barracuda 7200.10
Device Model:     ST3750640AS
Serial Number:    5QD5ABN1
    Device size   732.575 GB
           sde1     0.201 GB [md121] 
           sde2     3.912 GB [md120] SWAP
           sde3    24.419 GB [md122] /mnt/root-fc9
           sde4     0.000 GB 
           sde5    48.838 GB [md123] /mnt/workspace
           sde6     0.498 GB [md124] 
           sde7    19.543 GB [md125] 
           sde8    29.303 GB [md126] 
           sde9   605.859 GB [md127] /exports/common
  Unpartitioned     0.003 GB
======
Block device sdf, logical device 8:80
       No media (USB SD Reader)
======
Block device sdg, logical device 8:96
       No media (USB CF Reader)
======
Block device sdh, logical device 8:112
       No media (USB SM Reader)
======
Block device sdi, logical device 8:128
       No media (USB MS Reader)
======
Block device sdj, logical device 8:144
Model Family:     Western Digital Caviar Blue Serial ATA
    Device size   976.763 GB
           sdj1   976.762 GB /mnt/backup
  Unpartitioned     0.001 GB

blkdevtrc 1.16 (Stable) 2010-02-26 13:24:07-05 davidsen@tmr.com

--------------090100000606050902030103--
