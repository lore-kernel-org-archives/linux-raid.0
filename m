From: Richard Ems <r.ems@gmx.net>
Subject: recovery not starting: wrong superblock? multipath instead of raid1
 !? (long!)
Date: Tue, 09 Sep 2003 19:35:10 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F5E0F4E.5090404@gmx.net>
Reply-To: r.ems@gmx.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi list!

I created on a new installation 2 raid devices, the first one for / and 
a second one for swap.

md0 (hda2, hdb2) mounted on /
md1 (hda1, hdb1) for swap

Everything went ok, until I simulated a disk failure.
I turned the PC off and took the power from one of the devices.
Then booted with only one disk and the system started.

I then switched off again and plugged the device again.

The problem is now that after starting the system again recovery doesn't 
start!

Distribution is SuSE 8.2.
Kernel is SuSE's k_deflt-2.4.21-64.

I tried with the mdadm 1.1 from the distro without success.

I read many mails from this mailing list and tried also Neil Brown's 
tips using "--update=summaries" after installing mdadm-1.3 + all 4 
patches from http://cgi.cse.unsw.edu.au/~neilb/source/mdadm/patch/applied/
Also everything without success.

I recreated the swap partition again, since there is no data to save or 
backup. So now md1 is running fine again.

But I can't get md0 to recover!

/proc/mdstat and mdadm --examine show that /dev/hdb2 is active, so I 
tried setting /dev/hda2 to faulty, remove it and add it back again, but 
no recovery was started.

Here the output from "mdadm --detail /dev/md0":


liv:~/mdadm-1.3.0 # ./mdadm --detail /dev/md0
/dev/md0:
         Version : 00.90.00
   Creation Time : Sat Sep  6 11:53:59 2003
      Raid Level : multipath
      Array Size : 77087808 (73.52 GiB 78.94 GB)
    Raid Devices : 2
   Total Devices : 2
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Tue Sep  9 18:43:30 2003
           State : dirty, no-errors
  Active Devices : 1
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 1


     Number   Major   Minor   RaidDevice State
        0       0        0        0      faulty removed
        1       3       66        1      active sync   /dev/hdb2
        2       3        2        2      spare   /dev/hda2


Why does it show "Raid Level : multipath" ???
I didn't configure it as such!
/dev/hda2 shows also "Raid Level : multipath" !!!
/dev/hdb2, the active one, shows the correct "Raid Level : raid1".
And why is /dev/hda2 showed as a spare device where it should become an 
active device?


liv:~/mdadm-1.3.0 # ./mdadm --examine /dev/hda2
/dev/hda2:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : a6682b0a:a73c6dd5:25ac81ea:19eb7783
   Creation Time : Sat Sep  6 11:53:59 2003
      Raid Level : multipath
     Device Size : 77087808 (73.52 GiB 78.94 GB)
    Raid Devices : 2
   Total Devices : 2
Preferred Minor : 0

     Update Time : Sat Sep  6 16:14:01 2003
           State : clean, no-errors
  Active Devices : 1
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 1
        Checksum : b9b3d127 - correct
          Events : 0.19


       Number   Major   Minor   RaidDevice State
this     0       3        2        0      active sync   /dev/hda2
    0     0       3        2        0      active sync   /dev/hda2
    1     1       0        0        1      faulty removed
    2     2       3       66        2      spare   /dev/hdb2


liv:~/mdadm-1.3.0 # ./mdadm --examine /dev/hdb2
/dev/hdb2:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : a6682b0a:a73c6dd5:25ac81ea:19eb7783
   Creation Time : Sat Sep  6 11:53:59 2003
      Raid Level : raid1
     Device Size : 77087808 (73.52 GiB 78.94 GB)
    Raid Devices : 2
   Total Devices : 1
Preferred Minor : 0

     Update Time : Tue Sep  9 15:46:04 2003
           State : dirty, no-errors
  Active Devices : 1
Working Devices : 1
  Failed Devices : 0
   Spare Devices : 0
        Checksum : b9b7bef7 - correct
          Events : 0.23


       Number   Major   Minor   RaidDevice State
this     1       3       66        1      active sync   /dev/hdb2
    0     0       0        0        0      faulty removed
    1     1       3       66        1      active sync   /dev/hdb2



Any help would be VERY appreciated!

What are "Raid Devices"? The ones defined in /etc/raidtab?
Why "Total Devices : 1"? Is this the same as "Working Devices"?
Could devices be working but not active?

Many thanks, Richard


-- 
    Richard Ems
    ... e-mail: r.ems@gmx.net
    ... Computer Science, University of Hamburg

    "Do or do not. There is no try" - Yoda
    Yoda never programmed in Java.

