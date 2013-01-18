From: John Gehring <john.gehring@gmail.com>
Subject: mdadm - assemble error - 'not enough to start the array while not clean'
Date: Thu, 17 Jan 2013 19:43:11 -0700
Message-ID: <CALwOXvLW=fQjBmsHZy9WzqkXJj8pDDX=nOU=GF=8mqMK_H3XJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I am receiving the following error when trying to assemble a raid set:

mdadm: /dev/md1 assembled from 7 drives - not enough to start the
array while not clean - consider --force.

My machine environment and the steps are listed below. I'm happy to
provide additional information.

I have used the following steps to reliably reproduce the problem:

1 - echo "AUTO -all" >> /etc/mdadm.conf     : Do this in order to
prevent auto assembly in a later step.

2 - mdadm --create /dev/md1 --level=6 --chunk=256 --raid-devices=8
--uuid=0100e727:8d91a5d9:67f0be9e:26be5623 /dev/sdb /dev/sdc /dev/sdd
/dev/sde /dev/sdf /dev/sdg /dev/sdh /dev/sdm
   -  I originally detected this problem on a system with a 16 drive
LSI sas back plane, but found I could create a similar 8-device array
with a couple of 4-port USB hubs.

3 - Pull a drive from the raid set. This should be done prior to raid
finishing the resync process. If you're using > 1 G USB devices, there
should be ample time.
   - sudo bash -c "/bin/echo -n 1 > /sys/block/sdf/device/delete"

4 - Inspect the raid status to be sure that the device is now marked as faulty.
   - mdadm -D /dev/md1

5 - Remove the 'faulty' device from the raid set. Note that upon
inspection of the raid data in the last step, you can see that the
device name of the faulty device is not given.
   - mdadm --manage /dev/md1 --remove faulty

6 - Stop the raid device.
   - mdadm -S /dev/md1

7 - Rediscover the 'pulled' USB device. Note that I'm doing a virtual
pull and insert of the USB device because I don't have to run the risk
of bumping/reseating other USB devices on the same HUB.
   - sudo bash -c "/bin/echo -n \"- - -\" > /sys/class/scsi_host/host23/scan"
   - This step can be a little tricky because there are a good number
of hostx devices in the /sys/class/scsi_host directory. You have to
know how they are mapped or keep trying the command with different
hostx dirs specified until your USB device shows back up in the /dev/
directory.

8 - 'zero' the superblock on the newly discovered device.
   - mdadm --zero-superblock /dev/sdf

9 - Try to assemble the raid set.
  - mdadm --assemble /dev/md1 --uuid=0100e727:8d91a5d9:67f0be9e:26be5623

results in =>  mdadm: /dev/md1 assembled from 7 drives - not enough to
start the array while not clean - consider --force.

Using the --force switch works, but I'm not confident that the
integrity of the raid array has been maintained.

My system:

HP EliteBook 8740w
~$ cat /etc/issue
Ubuntu 11.04 \n \l

~$ uname -a
Linux JLG 2.6.38-16-generic #67-Ubuntu SMP Thu Sep 6 17:58:38 UTC 2012
x86_64 x86_64 x86_64 GNU/Linux

~$ mdadm --version
mdadm - v3.2.6 - 25th October 2012

~$ modinfo raid456
filename:       /lib/modules/2.6.38-16-generic/kernel/drivers/md/raid456.ko
alias:          raid6
alias:          raid5
alias:          md-level-6
alias:          md-raid6
alias:          md-personality-8
alias:          md-level-4
alias:          md-level-5
alias:          md-raid4
alias:          md-raid5
alias:          md-personality-4
description:    RAID4/5/6 (striping with parity) personality for MD
license:        GPL
srcversion:     2A567A4740BF3F0C5D13267
depends:        async_raid6_recov,async_pq,async_tx,async_memcpy,async_xor
vermagic:       2.6.38-16-generic SMP mod_unload modversions

The raid set when it's happy:

mdadm-3.2.6$ sudo mdadm -D /dev/md1
/dev/md1:
        Version : 1.2
  Creation Time : Thu Jan 17 19:34:51 2013
     Raid Level : raid6
     Array Size : 1503744 (1468.75 MiB 1539.83 MB)
  Used Dev Size : 250624 (244.79 MiB 256.64 MB)
   Raid Devices : 8
  Total Devices : 8
    Persistence : Superblock is persistent

    Update Time : Thu Jan 17 19:35:02 2013
          State : active, resyncing
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 256K

  Resync Status : 13% complete

           Name : JLG:1  (local to host JLG)
           UUID : 0100e727:8d91a5d9:67f0be9e:26be5623
         Events : 3

    Number   Major   Minor   RaidDevice State
       0       8       16        0      active sync   /dev/sdb
       1       8       32        1      active sync   /dev/sdc
       2       8       48        2      active sync   /dev/sdd
       3       8       64        3      active sync   /dev/sde
       4       8       80        4      active sync   /dev/sdf
       5       8       96        5      active sync   /dev/sdg
       6       8      112        6      active sync   /dev/sdh
       7       8      192        7      active sync   /dev/sdm


Thank you to anyone who's taking the time to look at this.

Cheers,

John Gehring
