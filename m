From: Patrice <mailinglist@pboenig.de>
Subject: Re: I was dump, I need help.
Date: Thu, 5 May 2016 12:00:47 +0200
Message-ID: <572B19CF.3000002@pboenig.de>
References: <5725DCA9.9010901@pboenig.de>
 <20160501113034.GA24215@cthulhu.home.robinhill.me.uk>
 <5726128E.9090309@pboenig.de>
 <20160502124113.GA1973@cthulhu.home.robinhill.me.uk>
Reply-To: Patrice <mailinglist@pboenig.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160502124113.GA1973@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Hill <robin@robinhill.me.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi robin,

luckily someone managed to repair the RAID.
Now all works fine! :-)
I think he does it like you guessed it.
Here is his way:

Because the disks of NAS data volume did not synced, so it cannot be 
assemble, I used command to force it to be started.
$ start_raids
mdadm: /dev/md/0 has been started with 4 drives.
mdadm: /dev/md/1 has been started with 4 drives.
mdadm: NOT forcing event count in /dev/sda3(0) from 266 up to 273
mdadm: You can use --really-force to do that (DANGEROUS)
mdadm: failed to RUN_ARRAY /dev/md/data-0: Input/output error
mdadm: Not enough devices to start the array.
$ cat /proc/mdstat
Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md1 : active raid6 sda2[0] sdc2[3] sdb2[2] sdd2[1]
1046528 blocks super 1.2 level 6, 512k chunk, algorithm 2 [4/4] [UUUU]

md0 : active raid1 sda1[4] sdd1[3] sdc1[2] sdb1[5]
4190208 blocks super 1.2 [4/4] [UUUU]

unused devices: <none>
$ mdadm -S /dev/md127
mdadm: error opening /dev/md127: No such file or directory
$ mdadm -A /dev/md127 /dev/sd[a-d]3 --really-force
mdadm: forcing event count in /dev/sda3(0) from 266 upto 273
mdadm: forcing event count in /dev/sdb3(1) from 266 upto 273
mdadm: /dev/md127 has been started with 4 drives.

Then I can mount data volume and access shares.

root@4FH15855000E3:/# df -h
Filesystem Size Used Avail Use% Mounted on
/dev/md0 3.7G 1.1G 2.5G 30% /
tmpfs 10M 0 10M 0% /dev
/dev/md127 11T 882G 11T 8% /data


Thank you for your time and your help!

Best regards,
Patrice




On 02.05.2016 14:41, Robin Hill wrote:
> On Sun May 01, 2016 at 04:28:30PM +0200, Patrice wrote:
>
>> Hi Robin,
>>
>> thank you for your reply.
>> Ok, I try not to panic but in my opinion that sounds bad. It seems to me
>> like a mess.
>> Why is there a RAID 1 und 6? I need a RAID 5.
>>
> It looks like you have a RAID1, a RAID6 and a RAID5. I'd guess that the
> RAID1 and RAID6 store the OS for the NAS system, and the RAID5 is the
> data.
>
>>   > are there any others which should be being
>>   > assembled into another array?
>>
>> There are no others. At least there should be only one partition on each
>> HDD. I didn`t do partitioning.
>>
>>
>> fdisk -l output:
>> ------------------
>>
>> Disk /dev/sda: 4000.8 GB, 4000787030016 bytes
>> 256 heads, 63 sectors/track, 484501 cylinders, total 7814037168 sectors
>> Units = sectors of 1 * 512 = 512 bytes
>> Sector size (logical/physical): 512 bytes / 4096 bytes
>> I/O size (minimum/optimal): 4096 bytes / 4096 bytes
>> Disk identifier: 0x00000000
>>
>>      Device Boot      Start         End      Blocks   Id  System
>> /dev/sda1               1  4294967295  2147483647+  ee  GPT
>> Partition 1 does not start on physical sector boundary.
>>
>> WARNING: GPT (GUID Partition Table) detected on '/dev/sdb'! The util
>> fdisk doesn't support GPT. Use GNU Parted.
>>
>>
>> Disk /dev/sdb: 4000.8 GB, 4000787030016 bytes
>> 256 heads, 63 sectors/track, 484501 cylinders, total 7814037168 sectors
>> Units = sectors of 1 * 512 = 512 bytes
>> Sector size (logical/physical): 512 bytes / 4096 bytes
>> I/O size (minimum/optimal): 4096 bytes / 4096 bytes
>> Disk identifier: 0x00000000
>>
>>      Device Boot      Start         End      Blocks   Id  System
>> /dev/sdb1               1  4294967295  2147483647+  ee  GPT
>> Partition 1 does not start on physical sector boundary.
>>
>> WARNING: GPT (GUID Partition Table) detected on '/dev/sdc'! The util
>> fdisk doesn't support GPT. Use GNU Parted.
>>
>>
>> Disk /dev/sdc: 4000.8 GB, 4000787030016 bytes
>> 256 heads, 63 sectors/track, 484501 cylinders, total 7814037168 sectors
>> Units = sectors of 1 * 512 = 512 bytes
>> Sector size (logical/physical): 512 bytes / 4096 bytes
>> I/O size (minimum/optimal): 4096 bytes / 4096 bytes
>> Disk identifier: 0x00000000
>>
>>      Device Boot      Start         End      Blocks   Id  System
>> /dev/sdc1               1  4294967295  2147483647+  ee  GPT
>> Partition 1 does not start on physical sector boundary.
>>
>> WARNING: GPT (GUID Partition Table) detected on '/dev/sdd'! The util
>> fdisk doesn't support GPT. Use GNU Parted.
>>
>>
>> Disk /dev/sdd: 4000.8 GB, 4000787030016 bytes
>> 256 heads, 63 sectors/track, 484501 cylinders, total 7814037168 sectors
>> Units = sectors of 1 * 512 = 512 bytes
>> Sector size (logical/physical): 512 bytes / 4096 bytes
>> I/O size (minimum/optimal): 4096 bytes / 4096 bytes
>> Disk identifier: 0x00000000
>>
>>      Device Boot      Start         End      Blocks   Id  System
>> /dev/sdd1               1  4294967295  2147483647+  ee  GPT
>> Partition 1 does not start on physical sector boundary.
>>
>> -------------------------------------------------------------------------
>>
> Okay, so there's 4 4TB drives - they're using GPT partitions so fdisk
> doesn't report anything useful here.
>
>> mdadm -E /dev/sd* output:
>> --------------------------
>>
>> /dev/sda3:
>>             Magic : a92b4efc
>>           Version : 1.2
>>       Feature Map : 0x0
>>        Array UUID : 632ff5fd:65342524:9c9798d7:80e47e94
>>              Name : 119c1bce:data-0  (local to host 119c1bce)
>>     Creation Time : Sun Apr  3 06:27:49 2016
>>        Raid Level : raid5
>>      Raid Devices : 4
>>
>>    Avail Dev Size : 7804333680 (3721.40 GiB 3995.82 GB)
>>        Array Size : 11706500352 (11164.19 GiB 11987.46 GB)
>>     Used Dev Size : 7804333568 (3721.40 GiB 3995.82 GB)
>>       Data Offset : 262144 sectors
>>      Super Offset : 8 sectors
>>      Unused Space : before=262056 sectors, after=112 sectors
>>             State : clean
>>       Device UUID : 38adc372:3e0eba36:0f819758:950a0411
>>
>>       Update Time : Sat Apr 30 23:03:32 2016
>>     Bad Block Log : 512 entries available at offset 72 sectors
>>          Checksum : d7f5b303 - correct
>>            Events : 266
>>
>>            Layout : left-symmetric
>>        Chunk Size : 64K
>>
>>      Device Role : Active device 0
>>      Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)
>>
>>
>> /dev/sdb3:
>>             Magic : a92b4efc
>>           Version : 1.2
>>       Feature Map : 0x0
>>        Array UUID : 632ff5fd:65342524:9c9798d7:80e47e94
>>              Name : 119c1bce:data-0  (local to host 119c1bce)
>>     Creation Time : Sun Apr  3 06:27:49 2016
>>        Raid Level : raid5
>>      Raid Devices : 4
>>
>>    Avail Dev Size : 7804333680 (3721.40 GiB 3995.82 GB)
>>        Array Size : 11706500352 (11164.19 GiB 11987.46 GB)
>>     Used Dev Size : 7804333568 (3721.40 GiB 3995.82 GB)
>>       Data Offset : 262144 sectors
>>      Super Offset : 8 sectors
>>      Unused Space : before=262056 sectors, after=112 sectors
>>             State : clean
>>       Device UUID : 655ee144:43c43771:0d8a6157:9b556584
>>
>>       Update Time : Sat Apr 30 23:03:32 2016
>>     Bad Block Log : 512 entries available at offset 72 sectors
>>          Checksum : 56bc6e3b - correct
>>            Events : 266
>>
>>            Layout : left-symmetric
>>        Chunk Size : 64K
>>
>>      Device Role : Active device 1
>>      Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)
>>
>>
>> /dev/sdc3:
>>             Magic : a92b4efc
>>           Version : 1.2
>>       Feature Map : 0x0
>>        Array UUID : 632ff5fd:65342524:9c9798d7:80e47e94
>>              Name : 119c1bce:data-0  (local to host 119c1bce)
>>     Creation Time : Sun Apr  3 06:27:49 2016
>>        Raid Level : raid5
>>      Raid Devices : 4
>>
>>    Avail Dev Size : 7804333680 (3721.40 GiB 3995.82 GB)
>>        Array Size : 11706500352 (11164.19 GiB 11987.46 GB)
>>     Used Dev Size : 7804333568 (3721.40 GiB 3995.82 GB)
>>       Data Offset : 262144 sectors
>>      Super Offset : 8 sectors
>>      Unused Space : before=262056 sectors, after=112 sectors
>>             State : clean
>>       Device UUID : d066d1aa:ffd1e432:e9ecdd9d:08540efa
>>
>>       Update Time : Sat Apr 30 23:17:27 2016
>>     Bad Block Log : 512 entries available at offset 72 sectors
>>          Checksum : 3a7ce8f6 - correct
>>            Events : 273
>>
>>            Layout : left-symmetric
>>        Chunk Size : 64K
>>
>>      Device Role : Active device 2
>>      Array State : ..AA ('A' == active, '.' == missing, 'R' == replacing)
>>
>>
>> /dev/sdd3:
>>             Magic : a92b4efc
>>           Version : 1.2
>>       Feature Map : 0x0
>>        Array UUID : 632ff5fd:65342524:9c9798d7:80e47e94
>>              Name : 119c1bce:data-0  (local to host 119c1bce)
>>     Creation Time : Sun Apr  3 06:27:49 2016
>>        Raid Level : raid5
>>      Raid Devices : 4
>>
>>    Avail Dev Size : 7804333680 (3721.40 GiB 3995.82 GB)
>>        Array Size : 11706500352 (11164.19 GiB 11987.46 GB)
>>     Used Dev Size : 7804333568 (3721.40 GiB 3995.82 GB)
>>       Data Offset : 262144 sectors
>>      Super Offset : 8 sectors
>>      Unused Space : before=262056 sectors, after=112 sectors
>>             State : clean
>>       Device UUID : b8a43a56:2f833e72:7dd9f166:6f80b5a2
>>
>>       Update Time : Sat Apr 30 23:17:27 2016
>>     Bad Block Log : 512 entries available at offset 72 sectors
>>          Checksum : 96faf109 - correct
>>            Events : 273
>>
>>            Layout : left-symmetric
>>        Chunk Size : 64K
>>
>>      Device Role : Active device 3
>>      Array State : ..AA ('A' == active, '.' == missing, 'R' == replacing)
>>
> I've removed the info for the first two partitions on each disk as those
> arrays are assembling fine. The third partitions look to contain your
> data array - the events for sda3 and sdb3 match at 266, and sdc3 and
> sdd3 are on 273 (and show sda3 & sdb3 missing). A forced assembly should
> work without any issues here - the array name would look to be
> /dev/md/data-0, so:
>    mdadm -Af /dev/md/data-0 /dev/sd[abcd]3
>
> That should assemble the array from 3 of the disks (probably sda3, sdc3
> and sdd3) - you'll then need to add the other one back in and allow the
> rebuild to complete. You should also do a check on the filesystem to
> ensure there's no corruption.
>
> Cheers,
>      Robin

