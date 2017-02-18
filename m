From: "Boylan, Ross" <Ross.Boylan@ucsf.edu>
Subject: mdadm: can only add devices to linear arrays
Date: Sat, 18 Feb 2017 02:33:29 +0000
Message-ID: <dffb96dc-ee78-4bad-82a8-7f9cfdeb80cd@EXHT01.net.ucsf.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I got "mdadm: can only add devices to linear arrays" when I did not expect it.  Can anyone explain what's  going on, and what the right way to handle the situation is?

In brief, I had a raid1 set for 2 devices, but with only 1.  I tried adding a 2nd.

root@tempserver:/var/log# mdadm -D /dev/md/media4
/dev/md/media4:
        Version : 1.2
  Creation Time : Thu Feb 18 14:09:00 2016
     Raid Level : raid1
     Array Size : 1953376064 (1862.88 GiB 2000.26 GB)
  Used Dev Size : 1953376064 (1862.88 GiB 2000.26 GB)
   Raid Devices : 2
  Total Devices : 1
    Persistence : Superblock is persistent

    Update Time : Fri Feb 17 17:59:40 2017
          State : clean, degraded 
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

           Name : tempserver:media4  (local to host tempserver)
           UUID : 69440821:e9aa9259:ab2b06ce:d09bedc7
         Events : 555297

    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed
       2       8       34        1      active sync   /dev/sdc2
root@tempserver:/var/log# mdadm --grow /dev/md/media4 --add /dev/sda2
mdadm: can only add devices to linear arrays
# I figured since it was raid1 with a missing device it would use the one I added
root@tempserver:/var/log# mdadm --grow /dev/md/media4 --add /dev/sda2 -n 2
mdadm: /dev/md/media4: no change requested
root@tempserver:/var/log# date; mdadm --grow /dev/md/media4 -n 1
# so I reduced the size of the array.  I was a little worried this would kick sdc2 out of the array.
#  It did not.  I then was able to add
# the new partition in  what I think is the usual way.
root@tempserver:/var/log# date; mdadm --grow /dev/md/media4 --force -n 1
Fri Feb 17 18:18:28 PST 2017
raid_disks for /dev/md/media4 set to 1
root@tempserver:/var/log# mdadm -D /dev/md/media4
/dev/md/media4:
        Version : 1.2
  Creation Time : Thu Feb 18 14:09:00 2016
     Raid Level : raid1
     Array Size : 1953376064 (1862.88 GiB 2000.26 GB)
  Used Dev Size : 1953376064 (1862.88 GiB 2000.26 GB)
   Raid Devices : 1
  Total Devices : 1
    Persistence : Superblock is persistent

    Update Time : Fri Feb 17 18:18:41 2017
          State : clean 
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

           Name : tempserver:media4  (local to host tempserver)
           UUID : 69440821:e9aa9259:ab2b06ce:d09bedc7
         Events : 557442

    Number   Major   Minor   RaidDevice State
       2       8       34        0      active sync   /dev/sdc2

root@tempserver:/var/log# date; mdadm --grow /dev/md/media4 --add /dev/sda2 -n 2
Fri Feb 17 18:19:24 PST 2017
mdadm: added /dev/sda2
raid_disks for /dev/md/media4 set to 2
# and mdadm -D shows the array rebuilding with sda2 being rebuilt.

Thanks.
Ross Boylan