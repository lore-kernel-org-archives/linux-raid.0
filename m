From: Gavin Whitehead <gavin@alabastercranium.demon.co.uk>
Subject: partition based raid1 and multi boot Ubuntu/Xubuntu
Date: Tue, 22 Nov 2011 22:23:00 +0000
Message-ID: <4ECC20C4.6050504@alabastercranium.demon.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm not sure if this is a GRUB2 problem or a RAID/MD issue but here goes...

I want to set up a machine that will boot two Linux installations using 
raid 1 partitions and Windows XP on a single partition.

I have two identical disks partitioned as follows

$ cat /proc/partitions
major minor  #blocks  name

    8        0  244198584 sda
    8        1   30720000 sda1
    8        2   30720000 sda2
    8        3   40960000 sda3
    8        4          1 sda4
    8        5    4194304 sda5
    8        6  137601024 sda6
    8       16  244198584 sdb
    8       17   30720000 sdb1
    8       18   30720000 sdb2
    8       19   40960000 sdb3
    8       20          1 sdb4
    8       21    4194304 sdb5
    8       22  137601024 sdb6

I installed WinXP first in sda3.

I then installed Ubuntu 11.04 from the Alternate CD and created some 
raid1 devices
     md0        sda1 sdb1    /
     md1        sda5 sdb5    swap
     md2        sda6 sdb6    /home

I set the boot flag on sda1 and sdb1.
This worked a treat.  I could boot in to either Ubuntu 11.04 to WinXP.  
I tested the RAID1 (power down, unplug a disk, power up, power down, 
replug the disk, power up,  use 'mdadm --add' to rebuild the array).  
Brilliant.

Then I installed Xubuntu 11.10 from the Alternate CD.  For this install 
I created one new raid1 device (md3) and reused md1 and md2
     md3        sda2 sdb2    /
     md1        sda5 sdb5    swap
     md2        sda6 sdb6    /home

I set the boot flag on sda2 and sdb2.

After the install had completed and grub2 had built the grub.cfg I only 
had my new Xubuntu 11.10 in the boot menu.  The Xubuntu 11.10 install 
works perfectly (and I can boot in to Win XP) but I can't boot in to the 
Ubuntu 11.04 installation.  I've re-run 'update-grub' but it doesn't 
find the other installation.

If I run 'sudo mount /dev/md0 /mnt' I can access the Ubuntu 11.04 files.

Is my intended configuration (tri-boot with two raid1, partition based, 
Linux installations and XP on a single parition) unachievable?

Gav
