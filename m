From: David Liontooth <lionteeth@cogweb.net>
Subject: Add a spare to a poorly defined raid1
Date: Wed, 15 Feb 2012 17:51:12 +0530
Message-ID: <4F3BA338.6030204@cogweb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Not knowing what I was doing, I created a RAID1 with a single drive and 
a spare, as below.

I'd like to add the spare to the array. How do I do this without rebooting?

Cheers,
Dave


# definitions of existing MD arrays
ARRAY /dev/md0 level=raid1 num-devices=1 
UUID=9921faab:5d93510e:0db287f1:dc103b07
    spares=1

# mdadm --detail /dev/md0
/dev/md0:
         Version : 0.90
   Creation Time : Fri Jul 18 14:57:40 2008
      Raid Level : raid1
      Array Size : 104320 (101.89 MiB 106.82 MB)
   Used Dev Size : 104320 (101.89 MiB 106.82 MB)
    Raid Devices : 1
   Total Devices : 2
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Wed Feb 15 03:37:11 2012
           State : clean
  Active Devices : 1
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 1

            UUID : 9921faab:5d93510e:0db287f1:dc103b07
          Events : 0.218

     Number   Major   Minor   RaidDevice State
        0       8        1        0      active sync   /dev/sda1

        1       8       17        -      spare   /dev/sdb1
