From: Farkas Levente <lfarkas@bppiac.hu>
Subject: mdadm always report SparesMissing
Date: Wed, 05 May 2004 12:22:07 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4098C04F.1050204@bppiac.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
Cc: Neil Brown <neilb@cse.unsw.edu.au>
List-Id: linux-raid.ids

hi,
all the time we restart a server or restart mdadm monitor i.e.:
/sbin/mdadm --monitor --scan --daemonise
we'got the SparesMissing event. the intersting is that we got this event 
only on the last raid device (ie/ if we have md0 and md1 than on md1, if 
we got md0, md1 and md2 then on md2). we don't have spare device. 
another intersting thing is that, mdadm report as we has many spare 
devices. how can I remove them if I don't has device for them?
thanks in advance.
eg:
# mdadm --detail /dev/md0 /dev/md1
/dev/md0:
         Version : 00.90.00
   Creation Time : Mon Jun  2 15:26:34 2003
      Raid Level : raid1
      Array Size : 38049856 (36.29 GiB 38.96 GB)
     Device Size : 38049856 (36.29 GiB 38.96 GB)
    Raid Devices : 2
   Total Devices : 2
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Mon May  3 15:05:21 2004
           State : dirty, no-errors
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 3


     Number   Major   Minor   RaidDevice State
        0       3        1        0      active sync   /dev/hda1
        1      22        1        1      active sync   /dev/hdc1
            UUID : 885724e5:551dfc30:647f21ae:df0f7d18
          Events : 0.512
/dev/md1:
         Version : 00.90.00
   Creation Time : Mon Jun  2 13:44:46 2003
      Raid Level : raid1
      Array Size : 2056256 (2008.06 MiB 2105.61 MB)
     Device Size : 2056256 (2008.06 MiB 2105.61 MB)
    Raid Devices : 2
   Total Devices : 2
Preferred Minor : 1
     Persistence : Superblock is persistent

     Update Time : Mon May  3 15:05:21 2004
           State : dirty, no-errors
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 1


     Number   Major   Minor   RaidDevice State
        0       3        2        0      active sync   /dev/hda2
        1      22        2        1      active sync   /dev/hdc2
            UUID : 02e61e78:27cbd5fd:4f33d278:c026581f
          Events : 0.304


-- 
   Levente                               "Si vis pacem para bellum!"

