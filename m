From: Jim Schatzman <james.schatzman@futurelabusa.com>
Subject: Re: Help! I killed my mdadm raid 5
Date: Thu, 02 Dec 2010 09:38:18 -0700
Message-ID: <20101202163903.4B6B0E30990@mail.futurelabusa.com>
References: <20101118195109.1GA4L.64443.root@cdptpa-web04-z02>
 <20101119185823.4828f555@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101119185823.4828f555@notabene.brown>
References: <20101118195109.1GA4L.64443.root@cdptpa-web04-z02>
 <20101119185823.4828f555@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, p3-500@roadrunner.com
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I hate to sound like a broken record, but it would be very helpful if mdadm was a bit smarter about handling the case where a drive is removed and then re-added with no data changes. This has happened to me several times when external cables have gotten loose.  Mdadm automatically fails the disconnected drives. Then, when the drives show up again, it will not automatically put them back in the array.  Even though so many drives get offlined that the raid cannot be started, and therefore no filesystem data could possibly be changed, mdadm acts as if the data on the temporarily-removed drives is suspect. Apparently, it changes the RAID metadata while the RAID is stopped. (more precisely, when mdadm attempts to assemble/start a RAID array that is missing too many drives). I really wish that i
 t wouldn't change the metadata in this circumstance.

This may be the result of an interaction between the filesystem drive, Linux, and Mdadm. Nevertheless, the result is unpleasant and annoying.

The best solution I have come up with is

1) Prevent the kernel from seeing your RAID arrays so they don't get started during boot  (unfortunately, this won't work if we are talking about the boot or system arrays).  In particular, remove any arrays you want to not start from the mdadm.conf file when mkinitrd is run (in fact, just be careful never to populate mdadm.conf for these RAIDs - the next time you run mkinitrd either explicitly or when a new kernel gets installed, the new kernel will stop assembling the arrays).

2) Use a cron.reboot script (or similar mechanism) to assemble and start the RAID with --no-degraded. I use commands similar to

mdadm -A --no-degraded /dev/mdXXX --uuid XXXXXXX
mount -t ext4 -o noatime,nodiratime /dev/raidVGXXX/LVXXX  /export/mntptXXX

(I am using LVM over RAID).

It may be possible, but I have no idea how, to get the kernel to assemble RAIDs using "--no-degraded" during boot. Apparently, you have to do something special with dracut/mkinitrd. I may be stupid, but I have found the dracut documentation to be very poor, to the point of uselessness. If someone could explain this I would be grateful.

The behavior I am trying to achieve is, 

1) If the RAID can be assembled with all drives present, do so.

2) Otherwise, give up, change no metadata, and let the operator fix it manually.

3) If the RAID loses drives while running but is still able to run, then keep running.

4) If the RAID loses drives while running and can no longer run, then give up, offline the RAID devices, but change no metadata. Wait for the operator to fix the problem. I realize that data may be lost. However, at worst, I would expect to be able to reassemble the drives and run fsck to repair the damage (as best it can).  Yes - I know that you can accomplish this result now -- but you have to re-create the array, instead of being able to just assemble it.

We can make the current behavior match #2 by assembling with --no-degraded. However, I don't know how to make the kernel do this doing boot. Making #4 work (being able to assemble the array instead of re-creating it), would seem to be a mdadm issue.  Until that happy day arrives, the best that you can do appears to be to keep a record of the important metadata information (-e, --chunk, -level), and be prepared to re-create the array carefully.

Aside from having to know the important metata parameters, the other issue relates to the Linux kernel's tendency to enumerate drives apparently randomly from boot to boot. It would be helpful if you could do something like "create", but re-creating an array based on the existing UUID metadata, or otherwise specify the drives in random order, and have Mdadm figure out the appropriate drive ordering. Like p3-500, I at first assumed that "assemble" would do this, but "assemble" doesn't work as we naive mdadm users would have expected, once a drive is theoretically failed.

Thanks!

Jim





At 12:58 AM 11/19/2010, Neil Brown wrote:
>On Thu, 18 Nov 2010 14:51:09 -0500
><p3-500@roadrunner.com> wrote:
>
>> Arrg, Major goof. I managed to kill my raid 5 through my own stupidity. Here is the chain of events, Your help is greatly appreciated.
>> 
>> I added disk #6 to my working 5 disk array, after about 24 hours it was done but i did not see the extra space (I now know all I needed to do was fsck and resize).
>> 
>> I failed and removed the new disk from the array then somehow also failed and removed drive # 5 from the array. At this point the array was still running so I added drive #5 & 6 back to the array but they got added as spares instead of active components. next I rebooted and could not assemble the array.
>> 
>> I tried --assemble and --assemble --force which results with "mdadm: /dev/md0 assembled from 4 drives and 1 spare - not enough to start the array". I am naming all 6 drives on the command line.
>> 
>> Several posts have suggested I --create the array again but I am hesitant to do this as I do not want to lose my data. The wiki suggests mkraid --force but I believe this is deprecated? It also requires an up to date /etc/raidtab which I do not have. Before I mess it up any more here's where I am.
>
>Yes, forget mkraid.
>
>mdadm --create is fairly safe as long as you think about what you are doing.
>In particular, make sure the same metadata type is used and importantly use
>--assume-clean.
>
>
>so something like
>
> mdadm --create /dev/md0 -e 0.90 --assume-clean --level=5 --n=6 \
> --chunk=64 /dev/sda2 /dev/sdb2 /dev/sdc2 /dev/sdd2 /dev/sdd /dev/sdf
>
>may well work.  Use 'fsck -n' and the 'mount -o ro' to check.
>All it will do is update the metadat.  If you have the devices in the wrong
>order, then simple
>   mdadm -Ss
>and try again.  The data wont be changed until you trigger a resync, or mount
>the filesystem read-write.
>
>And next time, think before you fail a drive in an array !!!
>
>NeilBrown
>
>
>> 
>> mdadam --examine /dev/sda2,b2,c2,d2,e,f
>> server2@server2:~$ sudo mdadm --examine /dev/sda2
>> [sudo] password for server2: 
>> /dev/sda2:
>>           Magic : a92b4efc
>>         Version : 00.90.00
>>            UUID : b7390ef0:9c9ecbe0:abcb3798:f53e3ccc
>>   Creation Time : Sat Feb  6 17:37:20 2010
>>      Raid Level : raid5
>>   Used Dev Size : 1952537920 (1862.09 GiB 1999.40 GB)
>>      Array Size : 9762689600 (9310.43 GiB 9996.99 GB)
>>    Raid Devices : 6
>>   Total Devices : 4
>> Preferred Minor : 0
>> 
>>     Update Time : Tue Nov 16 14:29:15 2010
>>           State : clean
>>  Active Devices : 4
>> Working Devices : 4
>>  Failed Devices : 2
>>   Spare Devices : 0
>>        Checksum : aacb71b5 - correct
>>          Events : 382240
>> 
>>          Layout : left-symmetric
>>      Chunk Size : 64K
>> 
>>       Number   Major   Minor   RaidDevice State
>> this     0       8        2        0      active sync   /dev/sda2
>> 
>>    0     0       8        2        0      active sync   /dev/sda2
>>    1     1       8       18        1      active sync   /dev/sdb2
>>    2     2       8       34        2      active sync   /dev/sdc2
>>    3     3       8       50        3      active sync   /dev/sdd2
>>    4     4       0        0        4      faulty removed
>>    5     5       0        0        5      faulty removed
>> server2@server2:~$ sudo mdadm --examine /dev/sdb2
>> /dev/sdb2:
>>           Magic : a92b4efc
>>         Version : 00.90.00
>>            UUID : b7390ef0:9c9ecbe0:abcb3798:f53e3ccc
>>   Creation Time : Sat Feb  6 17:37:20 2010
>>      Raid Level : raid5
>>   Used Dev Size : 1952537920 (1862.09 GiB 1999.40 GB)
>>      Array Size : 9762689600 (9310.43 GiB 9996.99 GB)
>>    Raid Devices : 6
>>   Total Devices : 4
>> Preferred Minor : 0
>> 
>>     Update Time : Tue Nov 16 14:29:15 2010
>>           State : clean
>>  Active Devices : 4
>> Working Devices : 4
>>  Failed Devices : 2
>>   Spare Devices : 0
>>        Checksum : aacb71c7 - correct
>>          Events : 382240
>> 
>>          Layout : left-symmetric
>>      Chunk Size : 64K
>> 
>>       Number   Major   Minor   RaidDevice State
>> this     1       8       18        1      active sync   /dev/sdb2
>> 
>>    0     0       8        2        0      active sync   /dev/sda2
>>    1     1       8       18        1      active sync   /dev/sdb2
>>    2     2       8       34        2      active sync   /dev/sdc2
>>    3     3       8       50        3      active sync   /dev/sdd2
>>    4     4       0        0        4      faulty removed
>>    5     5       0        0        5      faulty removed
>> server2@server2:~$ sudo mdadm --examine /dev/sdc2
>> /dev/sdc2:
>>           Magic : a92b4efc
>>         Version : 00.90.00
>>            UUID : b7390ef0:9c9ecbe0:abcb3798:f53e3ccc
>>   Creation Time : Sat Feb  6 17:37:20 2010
>>      Raid Level : raid5
>>   Used Dev Size : 1952537920 (1862.09 GiB 1999.40 GB)
>>      Array Size : 9762689600 (9310.43 GiB 9996.99 GB)
>>    Raid Devices : 6
>>   Total Devices : 4
>> Preferred Minor : 0
>> 
>>     Update Time : Tue Nov 16 14:29:15 2010
>>           State : clean
>>  Active Devices : 4
>> Working Devices : 4
>>  Failed Devices : 2
>>   Spare Devices : 0
>>        Checksum : aacb71d9 - correct
>>          Events : 382240
>> 
>>          Layout : left-symmetric
>>      Chunk Size : 64K
>> 
>>       Number   Major   Minor   RaidDevice State
>> this     2       8       34        2      active sync   /dev/sdc2
>> 
>>    0     0       8        2        0      active sync   /dev/sda2
>>    1     1       8       18        1      active sync   /dev/sdb2
>>    2     2       8       34        2      active sync   /dev/sdc2
>>    3     3       8       50        3      active sync   /dev/sdd2
>>    4     4       0        0        4      faulty removed
>>    5     5       0        0        5      faulty removed
>> server2@server2:~$ sudo mdadm --examine /dev/sdd2
>> /dev/sdd2:
>>           Magic : a92b4efc
>>         Version : 00.90.00
>>            UUID : b7390ef0:9c9ecbe0:abcb3798:f53e3ccc
>>   Creation Time : Sat Feb  6 17:37:20 2010
>>      Raid Level : raid5
>>   Used Dev Size : 1952537920 (1862.09 GiB 1999.40 GB)
>>      Array Size : 9762689600 (9310.43 GiB 9996.99 GB)
>>    Raid Devices : 6
>>   Total Devices : 4
>> Preferred Minor : 0
>> 
>>     Update Time : Tue Nov 16 14:29:15 2010
>>           State : clean
>>  Active Devices : 4
>> Working Devices : 4
>>  Failed Devices : 2
>>   Spare Devices : 0
>>        Checksum : aacb71eb - correct
>>          Events : 382240
>> 
>>          Layout : left-symmetric
>>      Chunk Size : 64K
>> 
>>       Number   Major   Minor   RaidDevice State
>> this     3       8       50        3      active sync   /dev/sdd2
>> 
>>    0     0       8        2        0      active sync   /dev/sda2
>>    1     1       8       18        1      active sync   /dev/sdb2
>>    2     2       8       34        2      active sync   /dev/sdc2
>>    3     3       8       50        3      active sync   /dev/sdd2
>>    4     4       0        0        4      faulty removed
>>    5     5       0        0        5      faulty removed
>> server2@server2:~$ sudo mdadm --examine /dev/sde
>> /dev/sde:
>>           Magic : a92b4efc
>>         Version : 00.90.00
>>            UUID : b7390ef0:9c9ecbe0:abcb3798:f53e3ccc
>>   Creation Time : Sat Feb  6 17:37:20 2010
>>      Raid Level : raid5
>>   Used Dev Size : 1952537920 (1862.09 GiB 1999.40 GB)
>>      Array Size : 9762689600 (9310.43 GiB 9996.99 GB)
>>    Raid Devices : 6
>>   Total Devices : 5
>> Preferred Minor : 0
>> 
>>     Update Time : Tue Nov 16 14:22:42 2010
>>           State : clean
>>  Active Devices : 4
>> Working Devices : 5
>>  Failed Devices : 2
>>   Spare Devices : 1
>>        Checksum : aacb70b7 - correct
>>          Events : 382232
>> 
>>          Layout : left-symmetric
>>      Chunk Size : 64K
>> 
>>       Number   Major   Minor   RaidDevice State
>> this     6       8       64        6      spare   /dev/sde
>> 
>>    0     0       8        2        0      active sync   /dev/sda2
>>    1     1       8       18        1      active sync   /dev/sdb2
>>    2     2       8       34        2      active sync   /dev/sdc2
>>    3     3       8       50        3      active sync   /dev/sdd2
>>    4     4       0        0        4      faulty removed
>>    5     5       0        0        5      faulty removed
>>    6     6       8       64        6      spare   /dev/sde
>> server2@server2:~$ sudo mdadm --examine /dev/sdf
>> /dev/sdf:
>>           Magic : a92b4efc
>>         Version : 00.90.00
>>            UUID : b7390ef0:9c9ecbe0:abcb3798:f53e3ccc
>>   Creation Time : Sat Feb  6 17:37:20 2010
>>      Raid Level : raid5
>>   Used Dev Size : 1952537920 (1862.09 GiB 1999.40 GB)
>>      Array Size : 9762689600 (9310.43 GiB 9996.99 GB)
>>    Raid Devices : 6
>>   Total Devices : 6
>> Preferred Minor : 0
>> 
>>     Update Time : Tue Nov 16 14:20:02 2010
>>           State : clean
>>  Active Devices : 4
>> Working Devices : 6
>>  Failed Devices : 2
>>   Spare Devices : 2
>>        Checksum : aacb7088 - correct
>>          Events : 382228
>> 
>>          Layout : left-symmetric
>>      Chunk Size : 64K
>> 
>>       Number   Major   Minor   RaidDevice State
>> this     6       8       80        6      spare   /dev/sdf
>> 
>>    0     0       8        2        0      active sync   /dev/sda2
>>    1     1       8       18        1      active sync   /dev/sdb2
>>    2     2       8       34        2      active sync   /dev/sdc2
>>    3     3       8       50        3      active sync   /dev/sdd2
>>    4     4       0        0        4      faulty removed
>>    5     5       0        0        5      faulty removed
>>    6     6       8       80        6      spare   /dev/sdf
>>    7     7       8       64        7      spare   /dev/sde
>> server2@server2:~$
>> 
>> # mdadm.conf
>> #
>> # Please refer to mdadm.conf(5) for information about this file.
>> #
>> 
>> # by default, scan all partitions (/proc/partitions) for MD superblocks.
>> # alternatively, specify devices to scan, using wildcards if desired.
>> DEVICE partitions
>> 
>> # auto-create devices with Debian standard permissions
>> CREATE owner=root group=disk mode=0660 auto=yes
>> 
>> # automatically tag new arrays as belonging to the local system
>> HOMEHOST <system>
>> 
>> # instruct the monitoring daemon where to send mail alerts
>> MAILADDR xxxxxxxxxxxx
>> # definitions of existing MD arrays
>> #ARRAY /dev/md0 level=raid5 num-devices=5 UUID=b7390ef0:9c9ecbe0:abcb3798:f53e3ccc
>> ARRAY /dev/md1 level=raid0 num-devices=2 UUID=559552c6:b54f0dff:0dc726d6:bae63db2
>> 
>> # This file was auto-generated on Mon, 15 Mar 2010 22:25:29 -0400
>> # by mkconf $Id$
>> MAILFROM xxxxxxxxxxx
>> 
>> fdisk -l
>> WARNING: GPT (GUID Partition Table) detected on '/dev/sda'! The util fdisk doesn't support GPT. Use GNU Parted.
>> 
>> 
>> Disk /dev/sda: 2000.4 GB, 2000398934016 bytes
>> 255 heads, 63 sectors/track, 243201 cylinders
>> Units = cylinders of 16065 * 512 = 8225280 bytes
>> Sector size (logical/physical): 512 bytes / 512 bytes
>> I/O size (minimum/optimal): 512 bytes / 512 bytes
>> Disk identifier: 0x00000000
>> 
>>    Device Boot      Start         End      Blocks   Id  System
>> /dev/sda1   *           1      243202  1953514583+  ee  GPT
>> 
>> WARNING: GPT (GUID Partition Table) detected on '/dev/sdc'! The util fdisk doesn't support GPT. Use GNU Parted.
>> 
>> 
>> Disk /dev/sdc: 2000.4 GB, 2000398934016 bytes
>> 255 heads, 63 sectors/track, 243201 cylinders
>> Units = cylinders of 16065 * 512 = 8225280 bytes
>> Sector size (logical/physical): 512 bytes / 512 bytes
>> I/O size (minimum/optimal): 512 bytes / 512 bytes
>> Disk identifier: 0x00000000
>> 
>>    Device Boot      Start         End      Blocks   Id  System
>> /dev/sdc1               1      243202  1953514583+  ee  GPT
>> 
>> Disk /dev/sde: 2000.4 GB, 2000398934016 bytes
>> 255 heads, 63 sectors/track, 243201 cylinders
>> Units = cylinders of 16065 * 512 = 8225280 bytes
>> Sector size (logical/physical): 512 bytes / 512 bytes
>> I/O size (minimum/optimal): 512 bytes / 512 bytes
>> Disk identifier: 0x0009e37a
>> 
>>    Device Boot      Start         End      Blocks   Id  System
>> 
>> Disk /dev/sdf: 2000.4 GB, 2000398934016 bytes
>> 255 heads, 63 sectors/track, 243201 cylinders
>> Units = cylinders of 16065 * 512 = 8225280 bytes
>> Sector size (logical/physical): 512 bytes / 512 bytes
>> I/O size (minimum/optimal): 512 bytes / 512 bytes
>> Disk identifier: 0x00048a02
>> 
>>    Device Boot      Start         End      Blocks   Id  System
>> 
>> WARNING: GPT (GUID Partition Table) detected on '/dev/sdb'! The util fdisk doesn't support GPT. Use GNU Parted.
>> 
>> 
>> Disk /dev/sdb: 2000.4 GB, 2000398934016 bytes
>> 255 heads, 63 sectors/track, 243201 cylinders
>> Units = cylinders of 16065 * 512 = 8225280 bytes
>> Sector size (logical/physical): 512 bytes / 512 bytes
>> I/O size (minimum/optimal): 512 bytes / 512 bytes
>> Disk identifier: 0x00000000
>> 
>>    Device Boot      Start         End      Blocks   Id  System
>> /dev/sdb1               1      243202  1953514583+  ee  GPT
>> 
>> WARNING: GPT (GUID Partition Table) detected on '/dev/sdd'! The util fdisk doesn't support GPT. Use GNU Parted.
>> 
>> 
>> Disk /dev/sdd: 2000.4 GB, 2000398934016 bytes
>> 255 heads, 63 sectors/track, 243201 cylinders
>> Units = cylinders of 16065 * 512 = 8225280 bytes
>> Sector size (logical/physical): 512 bytes / 512 bytes
>> I/O size (minimum/optimal): 512 bytes / 512 bytes
>> Disk identifier: 0x00000000
>> 
>>    Device Boot      Start         End      Blocks   Id  System
>> /dev/sdd1               1      243202  1953514583+  ee  GPT
>> 
>> Disk /dev/sdg: 250.1 GB, 250059350016 bytes
>> 255 heads, 63 sectors/track, 30401 cylinders
>> Units = cylinders of 16065 * 512 = 8225280 bytes
>> Sector size (logical/physical): 512 bytes / 512 bytes
>> I/O size (minimum/optimal): 512 bytes / 512 bytes
>> Disk identifier: 0x5b4a57df
>> 
>>    Device Boot      Start         End      Blocks   Id  System
>> /dev/sdg1   *           1       30401   244196001   fd  Linux raid autodetect
>> 
>> Disk /dev/sdh: 250.1 GB, 250059350016 bytes
>> 255 heads, 63 sectors/track, 30401 cylinders
>> Units = cylinders of 16065 * 512 = 8225280 bytes
>> Sector size (logical/physical): 512 bytes / 512 bytes
>> I/O size (minimum/optimal): 512 bytes / 512 bytes
>> Disk identifier: 0x174b0f87
>> 
>>    Device Boot      Start         End      Blocks   Id  System
>> /dev/sdh1               1       30401   244196001   fd  Linux raid autodetect
>> 
>> Disk /dev/md1: 500.1 GB, 500113211392 bytes
>> 2 heads, 4 sectors/track, 122097952 cylinders
>> Units = cylinders of 8 * 512 = 4096 bytes
>> Sector size (logical/physical): 512 bytes / 512 bytes
>> I/O size (minimum/optimal): 65536 bytes / 131072 bytes
>> Disk identifier: 0x00000000
>> 
>> Disk /dev/md1 doesn't contain a valid partition table
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

