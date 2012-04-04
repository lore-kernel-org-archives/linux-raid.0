From: Salatiel Filho <salatiel.filho@gmail.com>
Subject: Help to assemble raid5 - no superblock!
Date: Wed, 4 Apr 2012 08:15:57 -0300
Message-ID: <CAGmni9oPLr6xg07gn0kVpKM2ysOzM5x+Dx-kBTz2ZDdqV0-VOg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am having a big problem trying to assemble my raid.
I can assemble just fine in the old machine (LINUX ARM) where i built
the raid in the first place, but i am just unable to do in other
machine (Linux mips). I have no mdadm.conf in both machines.
I got the following error:

# mdadm  -A /dev/md0 /dev/sda2 /dev/sdb2 /dev/sdc2
mdadm: no recogniseable superblock on /dev/sda2
mdadm: /dev/sda2 has no superblock - assembly aborted

# cat /var/log/messages | tail

Apr  4 08:08:32 (none) kernel: [ 8577.010000] scsi_verify_blk_ioctl: 4
callbacks suppressed
Apr  4 08:08:32 (none) kernel: [ 8577.020000] mdadm: sending ioctl
400c0910 to a partition!
Apr  4 08:08:32 (none) kernel: [ 8577.020000] mdadm: sending ioctl
400c0910 to a partition!
Apr  4 08:08:32 (none) kernel: [ 8577.030000] mdadm: sending ioctl
20001261 to a partition!
Apr  4 08:08:32 (none) kernel: [ 8577.040000] mdadm: sending ioctl
20001261 to a partition!
Apr  4 08:08:32 (none) kernel: [ 8577.050000] mdadm: sending ioctl
20001261 to a partition!
Apr  4 08:08:32 (none) kernel: [ 8577.050000] mdadm: sending ioctl
20001261 to a partition!
Apr  4 08:08:32 (none) kernel: [ 8577.270000] mdadm: sending ioctl
20001261 to a partition!
Apr  4 08:08:32 (none) kernel: [ 8577.280000] mdadm: sending ioctl
20001261 to a partition!
Apr  4 08:08:33 (none) kernel: [ 8577.290000] mdadm: sending ioctl
20001261 to a partition!
Apr  4 08:08:33 (none) kernel: [ 8577.290000] mdadm: sending ioctl
20001261 to a partition!

# fdisk -l  /dev/sda

Disk /dev/sda: 1500.3 GB, 1500301910016 bytes
255 heads, 63 sectors/track, 182401 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks  Id System
/dev/sda1               1       13055   104857600  83 Linux
/dev/sda2           13055      182402  1360279960  fd Linux raid autodetect


# fdisk -l  /dev/sdb

Disk /dev/sdb: 1500.3 GB, 1500301910016 bytes
255 heads, 63 sectors/track, 182401 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks  Id System
/dev/sdb1               1       13055   104857600  83 Linux
Partition 1 does not end on cylinder boundary
/dev/sdb2           13055      182402  1360279960  fd Linux raid autodetect
Partition 2 does not end on cylinder boundary

# fdisk -l /dev/sdc

Disk /dev/sdc: 1500.3 GB, 1500301910016 bytes
255 heads, 63 sectors/track, 182401 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks  Id System
/dev/sdc1               1       13055   104857600  83 Linux
/dev/sdc2           13055      182402  1360279960  fd Linux raid autodetect


# cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
unused devices: <none>



# lsmod | grep -i 'md\|raid'
raid456                47584  0
async_raid6_recov        896  1 raid456
async_pq                1536  1 raid456
raid6_pq               74752  2 async_raid6_recov,async_pq
async_xor                976  2 raid456,async_pq
async_memcpy             560  1 raid456
async_tx                 832  5
raid456,async_raid6_recov,async_pq,async_xor,async_memcpy
raid1                  24304  0
md_mod                 88816  2 raid456,raid1
md5                     1424  0
crypto_hash             7888  3 dm_crypt,sha1_generic,md5



# uname -a

Linux router 3.2.9 #16 Sun Mar 25 16:31:49 BRT 2012 mips GNU/Linux


Any help ?


[]'s
Salatiel
