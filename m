From: Philipp Wendler <ml@philippwendler.de>
Subject: Yet another corrupt raid5
Date: Sat, 05 May 2012 14:42:25 +0200
Message-ID: <4FA52031.2040608@philippwendler.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

sorry, but here's yet another guy asking for some help on fixing his
RAID5. I have read the other threads, but please help me to make sure
that I am doing the correct things.

I have a RAID5 with 3 devices and a write intent bitmap, created with
Ubuntu 11.10 (Kernel 3.0, mdadm 3.1) and I upgraded to Ubuntu 12.04
(Kernel 3.2, mdadm 3.2.3). No hardware failure happened.

Since the first boot with the new system, all 3 devices are marked as
spares and --assemble refuses to run the raid because of this:

# mdadm --assemble -vv /dev/md0 /dev/sdb1 /dev/sdc1 /dev/sdd1
mdadm: looking for devices for /dev/md0
mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot -1.
mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot -1.
mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot -1.
mdadm: added /dev/sdc1 to /dev/md0 as -1
mdadm: added /dev/sdd1 to /dev/md0 as -1
mdadm: added /dev/sdb1 to /dev/md0 as -1
mdadm: /dev/md0 assembled from 0 drives and 3 spares - not enough to
start the array.

# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md0 : inactive sdc1[0](S) sdb1[1](S) sdd1[3](S)
      5860537344 blocks super 1.2

# --examine /dev/sdb1
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : c37dda6d:b10ef0c4:c304569f:1db0fd44
           Name : server:0  (local to host server)
  Creation Time : Thu Jun 30 12:15:27 2011
     Raid Level : -unknown-
   Raid Devices : 0

 Avail Dev Size : 3907024896 (1863.01 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 4635f495:15c062a3:33a2fe5c:2c4e0d6d

    Update Time : Sat May  5 13:06:49 2012
       Checksum : d8fe5afe - correct
         Events : 1

   Device Role : spare
   Array State :  ('A' == active, '.' == missing)


I did not write on the disks, and did not execute any other commands
than --assemble, so from the other threads I guess that I can recreate
my raid with the data?

My questions:
Do I need to upgrade mdadm, for example to avoid the bitmap problem?

How I can I backup the superblocks before?
(I'm not sure where they are on disk).

Is the following command right:
mdadm -C -e 1.2 -5 -n 3 --assume-clean \
  -b /boot/md0_write_intent_map \
  /dev/sdb1 /dev/sdc1 /dev/sdd1

Do I need to specify the chunk-size?
If so, how can I find it out?
I think I might have used a custom chunk size back then.
-X on my bitmap says Chunksize is 2MB, is this the right chunk size?

Is it a problem that there is a write intent map?
-X says there are 1375 dirty chunks.
Will mdadm be able to use this information, or are the dirty chunks just
lost?

Is the order of the devices on the --create command line important?
I am not 100% sure about the original order.

Am I correct that, if I have backuped the three superblocks, execute the
command above and do not write on the created array, I am not in danger
of risking anything?
I could always just reset the superblocks and then I am exactly in the
situation that I am now, so I have multiple tries, for example if chunk
size or order are wrong?
Or will mdadm do something else do my raid in the process?

Should I take any other precautions except stopping my raid before
shutting down?

Thank you very much in advance for your help.

Greetings, Philipp
