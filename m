From: "Steven Rose [DATACOM]" <Steven.Rose@datacom.co.nz>
Subject: mdadm: "reshape: not enough stripes. Needed 65536"
Date: Mon, 18 Nov 2013 13:38:39 +1300
Message-ID: <C057AC9B02D06A49810E9597C11F55BF1CD7694012@dnzwgex2.datacom.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi! I can't find any mention of this problem, which I suspect is self-inflicted by using a stupid chunk size of 65536 (64MB).

My raid 5 array has 4 devices. 3 are active and 1 is a spare. I want to grow it to use all 4. Array details are below.
I removed the write-intent bitmap and used:
  mdadm --grow --raid-devices=4 /dev/md5

and got the error "mdadm: failed to set raid disks" and
syslog: "md/raid:md5: reshape: not enough stripes.  Needed 65536".

The max value of stripe_cache_size is half of this so I can't increase it enough although I have 8GB RAM.

I realised that the chunk size is huge and is probably causing a stripe-width that's too large, and tried to reduce the chunk size to 128K with:
  mdadm --grow -c 128 /dev/md5 --backup-file=/mnt/backup/chunks.bak

and got:
"mdadm: Cannot set device shape for /dev/md5" and
syslog message "md/raid:md5: reshape: not enough stripes.  Needed 65536".

Is there anything else I could try? I can recreate the array from the backup if necessary.


Version and array info:
mdadm version is 3.2.5-lubuntu0.3, kernel is 3.2.0-32-generic. I have 8GB of RAM, running Mint 13 (Maya) for now.

Array details:
/dev/md5:
        Version : 1.2
  Creation Time : Sun Oct 21 22:05:44 2012
     Raid Level : raid5
     Array Size : 1904607232 (1816.38 GiB 1950.32 GB)
  Used Dev Size : 952303616 (908.19 GiB 975.16 GB)
   Raid Devices : 3
  Total Devices : 4
    Persistence : Superblock is persistent

    Update Time : Sun Nov 17 16:09:40 2013
          State : clean
 Active Devices : 3
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 65536K

           Name : blackbox:md5  (local to host blackbox)
           UUID : 72ffa5b6:601c3c8f:cf7d0771:bb9536a5
         Events : 17268

    Number   Major   Minor   RaidDevice State
       0       8        2        0      active sync   /dev/sda2
       3       8       53        1      active sync   /dev/sdd5
       2       8       34        2      active sync   /dev/sdc2

       5       8       66        -      spare   /dev/sde2

This is formatted with EXT4.


Thanks for any help.
Steven Rose
