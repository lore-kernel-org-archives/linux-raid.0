From: Bernd Schubert <Bernd.Schubert@tc.pci.uni-heidelberg.de>
Subject: bug in mdadm?
Date: Sat, 29 May 2004 14:17:25 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040529121725.GA7259@fubini.pci.uni-heidelberg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

for one of our raid1 devices 'mdadm -D' reports 3 devices and 1
failed device, though I'm pretty sure that I specified
'--raid-devices=2' when I created that raid-array.
One another system, 'mdadm -D' reports the correct numbers.
The data from /proc/mdstat report the correct numbers.

Any ideas whats the reason for this? Is it a bug in mdadm or has the
superblock really wrong data?

debye:~# ./mdadm -D /dev/md0
/dev/md0:
        Version : 00.90.00
  Creation Time : Sun May 16 15:22:03 2004
     Raid Level : raid1
     Array Size : 2441728 (2.33 GiB 2.50 GB)
    Device Size : 2441728 (2.33 GiB 2.50 GB)
   Raid Devices : 2
  Total Devices : 3
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Mon May 24 20:41:17 2004
          State : dirty, no-errors
 Active Devices : 2
Working Devices : 2
 Failed Devices : 1
  Spare Devices : 0


    Number   Major   Minor   RaidDevice State
       0      22        1        0      active sync   /dev/hdc1
       1       3        1        1      active sync   /dev/hda1
           UUID : fb539f04:91afe349:3591ed8e:f46b8ef1
         Events : 0.26


Thanks,
	Bernd
