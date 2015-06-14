From: tlknv <tlknv@yandex.ru>
Subject: mismatch_cnt constantly goes up on ssd+hdd raid1
Date: Sun, 14 Jun 2015 20:13:16 +0300
Message-ID: <3700381434301996@web21o.yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,
I have raid 1 which mirrors a root/boot partition on 1SSD and 2HDD (write-mostly). mismatch_cnt goes up even when there are very few writes to the partition as /var is mounted separatly. After I update several packages I typically see mismatch_cnt somewhere between 500,000 and 2,000,000. I have read a number of threads in this DL but could not find an explanation of what could cause mismatch_cnt to grow that much. I checked md5 sums using /var/lib/dpkg/info/*.md5sums, and didn't see many errors, even though there are few, mostly in text files which look ok to me. I guess when I check, all reads go to SSD (as both HDDs in this raid are write-mostly), and thus md5sum only shows no problem on SSD. Note, this partition is used as both boot and root and just in case here is some more info about
  my system:
root@tbeh:~# uname -a
Linux tbeh 3.16.0-4-amd64 #1 SMP Debian 3.16.7-ckt11-1 (2015-05-24) x86_64 GNU/Linux
root@tbeh:~# mdadm -D /dev/md0
/dev/md0:
        Version : 1.2
  Creation Time : Sun Jun  7 18:38:51 2015
     Raid Level : raid1
     Array Size : 13442048 (12.82 GiB 13.76 GB)
  Used Dev Size : 13442048 (12.82 GiB 13.76 GB)
   Raid Devices : 3
  Total Devices : 3
    Persistence : Superblock is persistent

    Update Time : Sun Jun 14 08:12:28 2015
          State : clean 
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

           Name : tbeh:0  (local to host tbeh)
           UUID : c50d3fbf:5da849fc:9a6872ae:6905e381
         Events : 213

    Number   Major   Minor   RaidDevice State
       0       8       34        0      active sync   /dev/sdc2
       2       8       18        1      active sync writemostly   /dev/sdb2
       1       8        2        2      active sync writemostly   /dev/sda2

root@tbeh:~# fdisk -l /dev/sdc

Disk /dev/sdc: 111.8 GiB, 120034123776 bytes, 234441648 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x858bea60

Device     Boot    Start      End  Sectors  Size Id Type
/dev/sdc1  *        2048 50333695 50331648   24G 83 Linux
/dev/sdc2       50333696 77234175 26900480 12.8G da Non-FS data

root@tbeh:~# fdisk -l /dev/sda

Disk /dev/sda: 596.2 GiB, 640135028736 bytes, 1250263728 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x0f06bf61

Device     Boot     Start        End    Sectors   Size Id Type
/dev/sda1              63     498014     497952 243.1M da Non-FS data
/dev/sda2          498015   27856709   27358695    13G da Non-FS data
/dev/sda3        27856710   35889209    8032500   3.9G da Non-FS data
/dev/sda4        35889210 1250258624 1214369415 579.1G  5 Extended
/dev/sda5        35889273   82782944   46893672  22.4G da Non-FS data
/dev/sda6        82783008  976768064  893985057 426.3G da Non-FS data
/dev/sda7       976768128 1250258624  273490497 130.4G 83 Linux

root@tbeh:~# fdisk -l /dev/sdb

Disk /dev/sdb: 465.8 GiB, 500107862016 bytes, 976773168 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x99a9f6d9

Device     Boot    Start       End   Sectors   Size Id Type
/dev/sdb1             63    498014    497952 243.1M da Non-FS data
/dev/sdb2         498015  27856709  27358695    13G da Non-FS data
/dev/sdb3       27856710  35889209   8032500   3.9G da Non-FS data
/dev/sdb4       35889210 976768064 940878855 448.7G  5 Extended
/dev/sdb5       35889273  82782944  46893672  22.4G da Non-FS data
/dev/sdb6       82783008 976768064 893985057 426.3G da Non-FS data

Just to minize the damage, now I mount / as read only, and remount as rw as necessary. Unfortunatelly right now I don't have anything to update but AFAIR right after package update (and running echo check > /sys/block/md0/md/sync_action) mismatch_cnt wasn't too high, but it went up after I reboot the system (and ran echo check > /sys/block/md0/md/sync_action).

The following may have nothing to do with mismatch_cnt as it's observed even when mismatch_cnt is 0 (after checking of ro partition) but I want to undestand how it's possible.
Cmp of SSD and HDD partitions shows lots of differences
root@tbeh:~# sync; cmp -l /dev/sdc2 /dev/sda2|wc -l
cmp: EOF on /dev/sdc2
1903215

BTW, only first few hundren bytes (at most) have non-zero value on SSD, the rest of differences has 0 bytes on SSD.
               4233   0 347
               4234  70  65
               4235 232 241
               4257   0   1
               4265  51 264
               4266 271 260
               4267  14 301
               4268 116 317
               4269 353 326
               4270  21 221
               4271 360 176
               4272 133 265
               4273 154 262
               4274  56 120
               4275 116 370
               4276 304  72
               4277 233  62
               4278 241   4
               4279 161 243
               4280 363 353
               4281   0   1
               4313  31 125
               4314 201 173
               4315  34 102
               4316  15 127
               4609   0 376
               4610   0 377
               4611   0 376
               4612   0 377
               4613   0 376
               4614   0 377
               4615   0 376
               4616   0 377
               4617   0 376
               4618   0 377
               4619   0 376
               4620   0 377
               4621   0 376
               4622   0 377
               4623   0 376
               4624   0 377
               4625   0 376
               4626   0 377
               4627   0 376
               4628   0 377
               4629   0 376
...

I don't see any differences between 2 HDD partitions though.

Does anyone have any idea what could be wrong with my system or what could I try to localize the problem?

Thanks,
Boris
