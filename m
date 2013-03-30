From: Sam Bingner <sam@bingner.com>
Subject: Re: Failing Reshape (SOLUTION)
Date: Sat, 30 Mar 2013 06:00:19 +0000
Message-ID: <60F75B1B-221A-47D8-A87C-951E0EC8B77D@bingner.com>
References: <630E2D12-3FFA-4E50-BEDB-777EA14F7F77@bingner.com>
 <361FDBD4-F48C-4CEF-93D0-F2892A2E8205@bingner.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <361FDBD4-F48C-4CEF-93D0-F2892A2E8205@bingner.com>
Content-Language: en-US
Content-ID: <92C3F9016C1B3541B240DD281AD6D083@ds.sbdhi.com>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Well, I found what happened and it is DEFINITELY a bug in the RAID code.  It allowed me to do something, then changed what it expected of what I did.  It should have either disallowed me from doing it or kept expecting what it started with.

What happened:
# mdadm --grow /dev/md128 --array-size=5872027136
     Array Size : 5872027136 (5600.00 GiB 6012.96 GB)
  Used Dev Size : 1953405952 (1862.91 GiB 2000.29 GB)

# mdadm --grow/dev/md128 --raid-devices=6 --backup-file=/boot/backup.md   --- THIS Step should have either A: failed because array-size was not a multiple of device size, or B: remembered what size the array was and only reshaped that amount
 
- Reboot for some reason before the reshape completes -- this causes the array size to increase to:
     Array Size : 7813623808 (7451.65 GiB 8001.15 GB)

- When mdadm gets to the critical section, it will now want 13107200 bytes rather than the original 10485760 bytes that it expected to need and backed up.  It will ZEROIZE the 10MB backup file, and completely fail saying it wants a backup that was never made at the correct size.

To fix this, and ensure I was correct in my assumption of what happened I made copies of all my array disks into lvm logical volumes.  I then made two sets of snapshots, and used my hacked up version of mdadm to modify one set to think it was a 7-disk raid6 (/dev/md7) and the second set of snapshots to think it was a 6-disk raid6 (/dev/md6) - neither copy thinking it was in the process of a reshape.  I then assembled these two arrays, and executed the following:

dd if=/dev/md7 of=/dev/md6 bs=1024 count=12800

After this point, md6 was completely valid and contained all my data.  fsck said my filesystem was clean, but I nevertheless forced a full check and it found zero errors.

v/r
Sam Bingner


On Mar 27, 2013, at 12:29 PM, Sam Bingner <sam@bingner.com> wrote:

> In addition to what I mentioned below, I found that if I recreate the array on my cloned devices I can't recreate it with the Data Offset that it was using before - 22528 sectors.  If I edit it to that and fix the checksum it makes mdadm --examine happy, but then the kernel gives invalid argument when I try to reassemble it.
> 
> Why would it have had this offset?  It doesn't seem to be any version of mdadm, perhaps due to reshape?
> 
> Sam
> 
> On Mar 26, 2013, at 6:07 PM, "Sam Bingner" <sam@bingner.com> wrote:
> 
>> I had a reshape that hung at 99% - I stupidly stopped it.  Now when I try to start it it says that it wants the critical-section-backup, which now contains all zeroes... 
>> 
>> I noted that the devices now say "Reshape pos'n : 10240 (10.00 MiB 10.49 MB)" when the mdstat said they were at (1953403392/1953405952) when the array was stopped.
>> 
>> I provided it with the backup-file that I used at the beginning, however as I said it has all zeroes and is of course unable to find anything in it.
>> 
>> I am currently making a mirror of all these devices, I'm thinking perhaps I need to convince it that the reshape position is not what it thinks it is?
>> 
>> 
>> Sam
>> ---------------------------
>> 
>> Current State:
>> 
>> # mdadm --assemble --scan --verbose
>> mdadm: /dev/sdh2 is identified as a member of /dev/md128, slot 5.
>> mdadm: /dev/sdg2 is identified as a member of /dev/md128, slot 4.
>> mdadm: /dev/sdf2 is identified as a member of /dev/md128, slot 0.
>> mdadm: /dev/sde2 is identified as a member of /dev/md128, slot -1.
>> mdadm: /dev/sdd2 is identified as a member of /dev/md128, slot 2.
>> mdadm: /dev/sdc2 is identified as a member of /dev/md128, slot -1.
>> mdadm: /dev/sdb2 is identified as a member of /dev/md128, slot 1.
>> mdadm: /dev/sda2 is identified as a member of /dev/md128, slot 3.
>> mdadm:/dev/md128 has an active reshape - checking if critical section needs to be restored
>> mdadm: No backup metadata on backup.md
>> mdadm: Failed to find backup of critical section
>> mdadm: Failed to restore critical section for reshape, sorry.
>> 
>> 
>> Details of the device and members below:
>> 
>> # mdadm --detail /dev/md128 
>> /dev/md128:
>>       Version : 1.2
>> Creation Time : Thu Jul 12 13:44:13 2012
>>    Raid Level : raid6
>>    Array Size : 7813623808 (7451.65 GiB 8001.15 GB)
>> Used Dev Size : 1953405952 (1862.91 GiB 2000.29 GB)
>>  Raid Devices : 6
>> Total Devices : 8
>>   Persistence : Superblock is persistent
>> 
>>   Update Time : Tue Mar 26 12:38:15 2013
>>         State : clean, reshaping 
>> Active Devices : 6
>> Working Devices : 8
>> Failed Devices : 0
>> Spare Devices : 2
>> 
>>        Layout : left-symmetric
>>    Chunk Size : 512K
>> 
>> Reshape Status : 99% complete
>> Delta Devices : -1, (7->6)
>> 
>>          Name : recluce:128  (local to host recluce)
>>          UUID : d4a9284d:11f43bc1:12fdb2d1:0c29bae3
>>        Events : 146126
>> 
>>   Number   Major   Minor   RaidDevice State
>>     10       8       82        0      active sync   /dev/sdf2
>>     12       8       18        1      active sync   /dev/sdb2
>>     11       8       50        2      active sync   /dev/sdd2
>>      9       8        2        3      active sync   /dev/sda2
>>      8       8       98        4      active sync   /dev/sdg2
>>      7       8      114        5      active sync   /dev/sdh2
>> 
>>     13       8       34        -      spare   /dev/sdc2
>>     14       8       66        -      spare   /dev/sde2
>> 
>> 
>> root@recluce:/mnt/data/www/html# cat /proc/mdstat 
>> Personalities : [raid6] [raid5] [raid4] 
>> md128 : active raid6 sdf2[10] sdc2[13](S) sde2[14](S) sdh2[7] sdg2[8] sda2[9] sdd2[11] sdb2[12]
>>     7813623808 blocks super 1.2 level 6, 512k chunk, algorithm 2 [6/5] [UUUUUU]
>>     [===================>.]  reshape = 99.9% (1953403392/1953405952) finish=0.0min speed=101K/sec
>> 
>> unused devices: <none>
>> 
>> /dev/sda2:
>>         Magic : a92b4efc
>>       Version : 1.2
>>   Feature Map : 0x4
>>    Array UUID : d4a9284d:11f43bc1:12fdb2d1:0c29bae3
>>          Name : recluce:128
>> Creation Time : Thu Jul 12 23:44:13 2012
>>    Raid Level : raid6
>>  Raid Devices : 6
>> 
>> Avail Dev Size : 3906811904 (1862.91 GiB 2000.29 GB)
>>    Array Size : 15627247616 (7451.65 GiB 8001.15 GB)
>>   Data Offset : 22528 sectors
>>  Super Offset : 8 sectors
>>         State : clean
>>   Device UUID : 63be576c:01364cdc:ed7b1b53:0e9d902b
>> 
>> Reshape pos'n : 10240 (10.00 MiB 10.49 MB)
>> Delta Devices : -1 (7->6)
>> 
>>   Update Time : Tue Mar 26 22:57:28 2013
>>      Checksum : 4dab014d - correct
>>        Events : 146349
>> 
>>        Layout : left-symmetric
>>    Chunk Size : 512K
>> 
>>  Device Role : Active device 3
>>  Array State : AAAAAA. ('A' == active, '.' == missing)
>> /dev/sdb2:
>>         Magic : a92b4efc
>>       Version : 1.2
>>   Feature Map : 0x4
>>    Array UUID : d4a9284d:11f43bc1:12fdb2d1:0c29bae3
>>          Name : recluce:128
>> Creation Time : Thu Jul 12 23:44:13 2012
>>    Raid Level : raid6
>>  Raid Devices : 6
>> 
>> Avail Dev Size : 3906811904 (1862.91 GiB 2000.29 GB)
>>    Array Size : 15627247616 (7451.65 GiB 8001.15 GB)
>>   Data Offset : 22528 sectors
>>  Super Offset : 8 sectors
>>         State : clean
>>   Device UUID : 839eaaeb:d1d895dc:6c9e8e69:dd16f396
>> 
>> Reshape pos'n : 10240 (10.00 MiB 10.49 MB)
>> Delta Devices : -1 (7->6)
>> 
>>   Update Time : Tue Mar 26 22:57:28 2013
>>      Checksum : 4f1d208f - correct
>>        Events : 146349
>> 
>>        Layout : left-symmetric
>>    Chunk Size : 512K
>> 
>>  Device Role : Active device 1
>>  Array State : AAAAAA. ('A' == active, '.' == missing)
>> /dev/sdc2:
>>         Magic : a92b4efc
>>       Version : 1.2
>>   Feature Map : 0x4
>>    Array UUID : d4a9284d:11f43bc1:12fdb2d1:0c29bae3
>>          Name : recluce:128
>> Creation Time : Thu Jul 12 23:44:13 2012
>>    Raid Level : raid6
>>  Raid Devices : 6
>> 
>> Avail Dev Size : 3906811904 (1862.91 GiB 2000.29 GB)
>>    Array Size : 15627247616 (7451.65 GiB 8001.15 GB)
>>   Data Offset : 22528 sectors
>>  Super Offset : 8 sectors
>>         State : clean
>>   Device UUID : 2ce8913a:96f4ab95:eee626a3:9f5b1a97
>> 
>> Reshape pos'n : 10240 (10.00 MiB 10.49 MB)
>> Delta Devices : -1 (7->6)
>> 
>>   Update Time : Tue Mar 26 22:57:28 2013
>>      Checksum : 90da1742 - correct
>>        Events : 146349
>> 
>>        Layout : left-symmetric
>>    Chunk Size : 512K
>> 
>>  Device Role : spare
>>  Array State : AAAAAA. ('A' == active, '.' == missing)
>> /dev/sdd2:
>>         Magic : a92b4efc
>>       Version : 1.2
>>   Feature Map : 0x4
>>    Array UUID : d4a9284d:11f43bc1:12fdb2d1:0c29bae3
>>          Name : recluce:128
>> Creation Time : Thu Jul 12 23:44:13 2012
>>    Raid Level : raid6
>>  Raid Devices : 6
>> 
>> Avail Dev Size : 3906811904 (1862.91 GiB 2000.29 GB)
>>    Array Size : 15627247616 (7451.65 GiB 8001.15 GB)
>>   Data Offset : 22528 sectors
>>  Super Offset : 8 sectors
>>         State : clean
>>   Device UUID : a0a2cc24:e0b17bd1:98d2a7af:c6c53ef6
>> 
>> Reshape pos'n : 10240 (10.00 MiB 10.49 MB)
>> Delta Devices : -1 (7->6)
>> 
>>   Update Time : Tue Mar 26 22:57:28 2013
>>      Checksum : 2289e0cf - correct
>>        Events : 146349
>> 
>>        Layout : left-symmetric
>>    Chunk Size : 512K
>> 
>>  Device Role : Active device 2
>>  Array State : AAAAAA. ('A' == active, '.' == missing)
>> /dev/sde2:
>>         Magic : a92b4efc
>>       Version : 1.2
>>   Feature Map : 0x4
>>    Array UUID : d4a9284d:11f43bc1:12fdb2d1:0c29bae3
>>          Name : recluce:128
>> Creation Time : Thu Jul 12 23:44:13 2012
>>    Raid Level : raid6
>>  Raid Devices : 6
>> 
>> Avail Dev Size : 3906811904 (1862.91 GiB 2000.29 GB)
>>    Array Size : 15627247616 (7451.65 GiB 8001.15 GB)
>>   Data Offset : 22528 sectors
>>  Super Offset : 8 sectors
>>         State : clean
>>   Device UUID : bb1e1921:f4e66269:988855d3:1a7d2534
>> 
>> Reshape pos'n : 10240 (10.00 MiB 10.49 MB)
>> Delta Devices : -1 (7->6)
>> 
>>   Update Time : Tue Mar 26 22:57:28 2013
>>      Checksum : 1851ff53 - correct
>>        Events : 146349
>> 
>>        Layout : left-symmetric
>>    Chunk Size : 512K
>> 
>>  Device Role : spare
>>  Array State : AAAAAA. ('A' == active, '.' == missing)
>> /dev/sdf2:
>>         Magic : a92b4efc
>>       Version : 1.2
>>   Feature Map : 0x4
>>    Array UUID : d4a9284d:11f43bc1:12fdb2d1:0c29bae3
>>          Name : recluce:128
>> Creation Time : Thu Jul 12 23:44:13 2012
>>    Raid Level : raid6
>>  Raid Devices : 6
>> 
>> Avail Dev Size : 3906811904 (1862.91 GiB 2000.29 GB)
>>    Array Size : 15627247616 (7451.65 GiB 8001.15 GB)
>>   Data Offset : 22528 sectors
>>  Super Offset : 8 sectors
>>         State : clean
>>   Device UUID : 624b425a:8a982e6a:5b5c3af3:a99358c4
>> 
>> Reshape pos'n : 10240 (10.00 MiB 10.49 MB)
>> Delta Devices : -1 (7->6)
>> 
>>   Update Time : Tue Mar 26 22:57:28 2013
>>      Checksum : 25ec7e0 - correct
>>        Events : 146349
>> 
>>        Layout : left-symmetric
>>    Chunk Size : 512K
>> 
>>  Device Role : Active device 0
>>  Array State : AAAAAA. ('A' == active, '.' == missing)
>> /dev/sdg2:
>>         Magic : a92b4efc
>>       Version : 1.2
>>   Feature Map : 0x4
>>    Array UUID : d4a9284d:11f43bc1:12fdb2d1:0c29bae3
>>          Name : recluce:128
>> Creation Time : Thu Jul 12 23:44:13 2012
>>    Raid Level : raid6
>>  Raid Devices : 6
>> 
>> Avail Dev Size : 3906813172 (1862.91 GiB 2000.29 GB)
>>    Array Size : 15627247616 (7451.65 GiB 8001.15 GB)
>> Used Dev Size : 3906811904 (1862.91 GiB 2000.29 GB)
>>   Data Offset : 2048 sectors
>>  Super Offset : 8 sectors
>>         State : clean
>>   Device UUID : 1b548d6a:26d2539a:ee7e1bab:eb2cb094
>> 
>> Reshape pos'n : 10240 (10.00 MiB 10.49 MB)
>> Delta Devices : -1 (7->6)
>> 
>>   Update Time : Tue Mar 26 22:57:28 2013
>>      Checksum : cb077b03 - correct
>>        Events : 146349
>> 
>>        Layout : left-symmetric
>>    Chunk Size : 512K
>> 
>>  Device Role : Active device 4
>>  Array State : AAAAAA. ('A' == active, '.' == missing)
>> /dev/sdh2:
>>         Magic : a92b4efc
>>       Version : 1.2
>>   Feature Map : 0x4
>>    Array UUID : d4a9284d:11f43bc1:12fdb2d1:0c29bae3
>>          Name : recluce:128
>> Creation Time : Thu Jul 12 23:44:13 2012
>>    Raid Level : raid6
>>  Raid Devices : 6
>> 
>> Avail Dev Size : 3906813172 (1862.91 GiB 2000.29 GB)
>>    Array Size : 15627247616 (7451.65 GiB 8001.15 GB)
>> Used Dev Size : 3906811904 (1862.91 GiB 2000.29 GB)
>>   Data Offset : 2048 sectors
>>  Super Offset : 8 sectors
>>         State : clean
>>   Device UUID : 0c9a9967:ac36641f:53c370b9:f68f7ef3
>> 
>> Reshape pos'n : 10240 (10.00 MiB 10.49 MB)
>> Delta Devices : -1 (7->6)
>> 
>>   Update Time : Tue Mar 26 22:57:28 2013
>>      Checksum : ba47d0e1 - correct
>>        Events : 146349
>> 
>>        Layout : left-symmetric
>>    Chunk Size : 512K
>> 
>>  Device Role : Active device 5
>>  Array State : AAAAAA. ('A' == active, '.' == missing)--
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

