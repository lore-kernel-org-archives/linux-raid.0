From: Joe Landman <joe.landman@gmail.com>
Subject: Definitely seeing linux OS RAID device failure on reboot for 3.x
 (x >= 5) kernels
Date: Sun, 02 Dec 2012 13:22:23 -0500
Message-ID: <50BB9C5F.4010402@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi folks

   At first I thought this might have been a flaky motherboard.  But now 
I can confirm I am definitely seeing this on 5 different units, 3 
different motherboards, 3 different types of OS drives (all SSD).

What am I seeing:

Upon reboot after first boot installing the updated kernel (3.5.x and 
3.6.x) atop CentOS 6.x, the OS RAID (/dev/md0) has an inactive member. 
Moreover, changes since the first reboot with the new kernel, are not 
actually incorporated into the booting drive.  The mounted file system 
appears intact, but is missing any additional bits (drivers/etc) that 
were added.

The RAID MD0 shows up as partial, with other assembled RAIDs showing up 
as inactive

[root@jr4-1-1g ~]# cat /proc/mdstat
Personalities : [raid1]
md126 : inactive sdb1[1](S)
       12686336 blocks super 1.2

md127 : inactive sda1[0](S)
       12686336 blocks super 1.2

md0 : active raid1 sdc1[0]
       46890936 blocks super 1.0 [2/1] [U_]
       bitmap: 1/1 pages [4KB], 65536KB chunk

unused devices: <none>

[root@jr4-1-1g ~]# mdadm --detail /dev/md0
/dev/md0:
         Version : 1.0
   Creation Time : Fri Nov 30 22:27:01 2012
      Raid Level : raid1
      Array Size : 46890936 (44.72 GiB 48.02 GB)
   Used Dev Size : 46890936 (44.72 GiB 48.02 GB)
    Raid Devices : 2
   Total Devices : 1
     Persistence : Superblock is persistent

   Intent Bitmap : Internal

     Update Time : Sun Dec  2 07:17:42 2012
           State : active, degraded
  Active Devices : 1
Working Devices : 1
  Failed Devices : 0
   Spare Devices : 0

            Name : jr4-1-1g.sicluster:0  (local to host jr4-1-1g.sicluster)
            UUID : ac8b4268:13c54f3d:40d41df8:dec79e31
          Events : 398

     Number   Major   Minor   RaidDevice State
        0       8       33        0      active sync   /dev/sdc1
        1       0        0        1      removed



How repeatable is it:

I have a 100% success rate in repeating it when installing 3.5.x and 
3.6.x kernels.

This is independent of motherboard, OS drive type, etc.


Whats the impact:

Fairly annoying.  Not a full show stopper, but its making me strongly 
consider going back to the 3.2.x kernels that were pretty stable for us 
(but missing some xfs/btrfs fixes and tuning).  We did not see this 
problem in 3.2.28+.



What kernel:

3.5 and 3.6 + patches that bump to .x, SCST, as well as some performance 
tuning patches of ours.  Problem exists in pure vanilla kernels (e.g. 
without these patches, this was one of the first tests we did).


Can I bisect:

Probably not for another 3 weeks due to scheduling.



Which mdadm version am I using:

[root@jr4-1-1g ~]# mdadm -V
mdadm - v3.2.6 - 25th October 2012


Note:  this *could* also be in the way dracut/grub does MD assembly.  We 
did add in the dracut md module, and included options to force it to 
assemble (due to profound bugs in the default Red Hat/CentOS dracut 
implementation which seems to not know how to properly assemble MD RAIDs 
built with non-distro kernels)

But dracut sits atop mdadm for assembly, and we are using the 3.2.6 
version there as well (we rebuilt the initramfs using the mdadm.static 
binary).

-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics Inc.
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
        http://scalableinformatics.com/sicluster
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615

