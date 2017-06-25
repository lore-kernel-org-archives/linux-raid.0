From: Hubert Reevez <hubereevez@gmail.com>
Subject: Re: can't add a larger spare for a failed smaller disk
Date: Sun, 25 Jun 2017 12:10:28 +0200
Message-ID: <CAAK+==YioRVH4LAYVHmfuF41+T-emBwoMawp4xBPyowYTp9_tA@mail.gmail.com>
References: <CAAK+==bmLQ6EGm806+feV=PGp1xB7vMwtEXXD3dJZA8fHn-osQ@mail.gmail.com>
 <CAFCYAsePbzqj7=0BORYGSvQFAOY9SCDAfX1hQmj-8gH2dFj3WA@mail.gmail.com>
 <CAAK+==YbNyjFryhDmJe2Y67rcGzZKvaKX2BaEJzZTuMTN98jRw@mail.gmail.com>
 <CAFCYAsexbWzffTdouwjQQf0=ZrSx+67c3rWtHcTX9K0nZ5Uuxw@mail.gmail.com>
 <CAAK+==Y1h9GPw-5jmtnXKNPP6aYz3ezKre-MKSPvW9Sbjv7hdQ@mail.gmail.com> <CAFCYAsdDdBVxFuj1S_5vOTNO3KN0mqA+hjbD99Ea53AadXuMFA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFCYAsdDdBVxFuj1S_5vOTNO3KN0mqA+hjbD99Ea53AadXuMFA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Johnson <jeff.johnson@aeoncomputing.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

root@Zetta:~# blockdev --getpbsz /dev/sdc
4096

Idid
mdadm -E /dev/sd[abcefg]
here
https://pastebin.com/zzz3jFvP

the disk was blank

2017-06-25 10:22 GMT+02:00 Jeff Johnson <jeff.johnson@aeoncomputing.com>:
> blockdev --getpbsz /dev/sdc
>
> It looks like you're using 512e drives (4KB w/ 512b emulation)
>
> If sdc won't sync because it's busy something else has control of it.
>
> Is it a blank drive? If there's an old LVM2 vg on it the LVM drivers may be
> reserving the disk. Is device-mapper-multipath running? If so it'll reserve
> the drive and expect you to use whichever /dev/dm* device represents it.
>
> You could also run lsof to see what process has it open.
>
>
>
> On Sun, Jun 25, 2017 at 01:11 Hubert Reevez <hubereevez@gmail.com> wrote:
>>
>> I did add before assemble ! But mdadm always gave me the same answer.
>>
>> Could you send me more help to check the block ?
>>
>> In my previous email I wrote my fdisk -l here :
>>
>> Disk /dev/sdb: 2000.4 GB, 2000398934016 bytes
>> 255 heads, 63 sectors/track, 243201 cylinders, total 3907029168 sectors
>> Units = sectors of 1 * 512 = 512 bytes
>> Sector size (logical/physical): 512 bytes / 4096 bytes
>> I/O size (minimum/optimal): 4096 bytes / 4096 bytes
>> Disk identifier: 0x00000000
>>
>> Disk /dev/sdb doesn't contain a valid partition table
>>
>> Disk /dev/sdc: 2000.4 GB, 2000398934016 bytes
>> 255 heads, 63 sectors/track, 243201 cylinders, total 3907029168 sectors
>> Units = sectors of 1 * 512 = 512 bytes
>> Sector size (logical/physical): 512 bytes / 4096 bytes
>> I/O size (minimum/optimal): 4096 bytes / 4096 bytes
>> Disk identifier: 0x00000000
>>
>> Disk /dev/sdc doesn't contain a valid partition table
>>
>> Is it not the answer you look at to help me ?
>>
>> thanks again...
>>
>> 2017-06-25 1:40 GMT+02:00 Jeff Johnson <jeff.johnson@aeoncomputing.com>:
>> > I've added/replaced with larger drives several times, no problem. Just
>> > did
>> > it on Thursday.
>> >
>> > Check your new drive to make sure the block size specs are the same.
>> > 512b
>> > blocks versus 4K or 520b if it's SAS with crc block T10 formatting. Use
>> > the
>> > blockdev command or  sysfs to check.
>> >
>> > On Sat, Jun 24, 2017 at 16:15 Hubert Reevez <hubereevez@gmail.com>
>> > wrote:
>> >>
>> >> thanks for your answer !!!
>> >>
>> >> tried to zero superblock sdc : went ok.
>> >> mdadm --add /dev/md0 --verbose /dev/sdc mdadm: add new device failed
>> >> for /dev/sdc as 7: Invalid argument
>> >>
>> >> I really think it's because of this larger disk for what I red on
>> >> http://www.linuxquestions.org :(
>> >>
>> >>
>> >>
>> >> 2017-06-25 0:37 GMT+02:00 Jeff Johnson
>> >> <jeff.johnson@aeoncomputing.com>:
>> >> > Did you actually add it? (--add /dev/mdX /dev/sdc)
>> >> >
>> >> > Did a resync occur, observable via `cat /proc/mdstat`?
>> >> >
>> >> >
>> >> >
>> >> > On Sat, Jun 24, 2017 at 15:21 Hubert Reevez <hubereevez@gmail.com>
>> >> > wrote:
>> >> >>
>> >> >> Hi,
>> >> >>
>> >> >> I'm trying to add a larger spare in replacement to a smaller one.
>> >> >> I'm
>> >> >> really stuck here.... ;(
>> >> >>
>> >> >> Here is what I did : --fail /dev/sdc then --remove /dev/sdc
>> >> >>
>> >> >> Added the new one (which is also sdc now) can't assemble the new one
>> >> >> !
>> >> >>
>> >> >> If I try to assemble here is what it comes :
>> >> >> ---------------------------------------------------------
>> >> >> root@Zetta:~# mdadm --assemble /dev/md0 --verbose /dev/sdc
>> >> >> mdadm: looking for devices for /dev/md0
>> >> >> mdadm: /dev/sdc is busy - skipping
>> >> >> -------------------------------------------------------
>> >> >>
>> >> >>
>> >> >> If I tried to stop the array and assemble, here is what it comes :
>> >> >>
>> >> >> --------------------------------
>> >> >>
>> >> >> root@Zetta:~# mdadm --assemble /dev/md0 --verbose /dev/sdc
>> >> >> mdadm: looking for devices for /dev/md0
>> >> >> mdadm: /dev/sdc is identified as a member of /dev/md0, slot -1.
>> >> >> mdadm: no uptodate device for slot 0 of /dev/md0
>> >> >> mdadm: no uptodate device for slot 1 of /dev/md0
>> >> >> mdadm: no uptodate device for slot 2 of /dev/md0
>> >> >> mdadm: no uptodate device for slot 3 of /dev/md0
>> >> >> mdadm: no uptodate device for slot 4 of /dev/md0
>> >> >> mdadm: no uptodate device for slot 5 of /dev/md0
>> >> >> mdadm: added /dev/sdc to /dev/md0 as -1
>> >> >> mdadm: /dev/md0 assembled from 0 drives and 1 spare - not enough to
>> >> >> start the array
>> >> >>
>> >> >> -------------------------------------------------
>> >> >>
>> >> >> Thanks for your help !!!!!
>> >> >>
>> >> >>
>> >> >> Here some infos (I had a sdg larger than 1,5 to)
>> >> >>
>> >> >> ------------------------------------
>> >> >> root@Zetta:~# blockdev --getsize64 /dev/sd[abcefg] 1500301910016
>> >> >> 2000398934016 2000398934016 1500301910016 1500301910016
>> >> >> 2000398934016
>> >> >>
>> >> >>
>> >> >>
>> >> >>
>> >> >> ---------------------------------------------------------------------------------------------
>> >> >> root@Zetta:~# cat /proc/mdstat
>> >> >> Personalities : [raid6] [raid5] [raid4]
>> >> >> md0 : inactive sdf[0] sdc[7](S) sdg[6] sdb[4] sde[3] sda[2]
>> >> >>       10255693264 blocks super 1.2
>> >> >>
>> >> >> unused devices: <none>
>> >> >>
>> >> >>
>> >> >>
>> >> >> ---------------------------------------------------------------------------------------------
>> >> >>
>> >> >> root@Zetta:~# mdadm --detail /dev/md0
>> >> >> /dev/md0:
>> >> >>         Version : 1.2
>> >> >>   Creation Time : Sat Aug 31 01:10:06 2013
>> >> >>      Raid Level : raid6
>> >> >>   Used Dev Size : 1465137152 (1397.26 GiB 1500.30 GB)
>> >> >>    Raid Devices : 6
>> >> >>   Total Devices : 6
>> >> >>     Persistence : Superblock is persistent
>> >> >>
>> >> >>     Update Time : Fri Jun 23 15:43:33 2017
>> >> >>           State : active, degraded, Not Started
>> >> >>  Active Devices : 5
>> >> >> Working Devices : 6
>> >> >>  Failed Devices : 0
>> >> >>   Spare Devices : 1
>> >> >>
>> >> >>          Layout : left-symmetric
>> >> >>      Chunk Size : 512K
>> >> >>
>> >> >>            Name : zetta:0
>> >> >>            UUID : 96b0e7b7:83aa203f:1545031b:43caaa85
>> >> >>          Events : 54841
>> >> >>
>> >> >>     Number   Major   Minor   RaidDevice State
>> >> >>        0       8       80        0      active sync   /dev/sdf
>> >> >>        1       0        0        1      removed
>> >> >>        2       8        0        2      active sync   /dev/sda
>> >> >>        3       8       64        3      active sync   /dev/sde
>> >> >>        4       8       16        4      active sync   /dev/sdb
>> >> >>        6       8       96        5      active sync   /dev/sdg
>> >> >>
>> >> >>        7       8       32        -      spare   /dev/sdc
>> >> >>
>> >> >>
>> >> >>
>> >> >> --------------------------------------------------------------------------------------------------------------------
>> >> >>
>> >> >> root@Zetta:~# fdisk -l
>> >> >>
>> >> >> Disk /dev/sda: 1500.3 GB, 1500301910016 bytes
>> >> >> 255 heads, 63 sectors/track, 182401 cylinders, total 2930277168
>> >> >> sectors
>> >> >> Units = sectors of 1 * 512 = 512 bytes
>> >> >> Sector size (logical/physical): 512 bytes / 512 bytes
>> >> >> I/O size (minimum/optimal): 512 bytes / 512 bytes
>> >> >> Disk identifier: 0x00000000
>> >> >>
>> >> >> Disk /dev/sda doesn't contain a valid partition table
>> >> >>
>> >> >> Disk /dev/sdb: 2000.4 GB, 2000398934016 bytes
>> >> >> 255 heads, 63 sectors/track, 243201 cylinders, total 3907029168
>> >> >> sectors
>> >> >> Units = sectors of 1 * 512 = 512 bytes
>> >> >> Sector size (logical/physical): 512 bytes / 4096 bytes
>> >> >> I/O size (minimum/optimal): 4096 bytes / 4096 bytes
>> >> >> Disk identifier: 0x00000000
>> >> >>
>> >> >> Disk /dev/sdb doesn't contain a valid partition table
>> >> >>
>> >> >> Disk /dev/sdc: 2000.4 GB, 2000398934016 bytes
>> >> >> 255 heads, 63 sectors/track, 243201 cylinders, total 3907029168
>> >> >> sectors
>> >> >> Units = sectors of 1 * 512 = 512 bytes
>> >> >> Sector size (logical/physical): 512 bytes / 4096 bytes
>> >> >> I/O size (minimum/optimal): 4096 bytes / 4096 bytes
>> >> >> Disk identifier: 0x00000000
>> >> >>
>> >> >> Disk /dev/sdc doesn't contain a valid partition table
>> >> >>
>> >> >> Disk /dev/sdd: 100.0 GB, 100030242816 bytes
>> >> >> 255 heads, 63 sectors/track, 12161 cylinders, total 195371568
>> >> >> sectors
>> >> >> Units = sectors of 1 * 512 = 512 bytes
>> >> >> Sector size (logical/physical): 512 bytes / 512 bytes
>> >> >> I/O size (minimum/optimal): 512 bytes / 512 bytes
>> >> >> Disk identifier: 0x0008101c
>> >> >>
>> >> >>    Device Boot      Start         End      Blocks   Id  System
>> >> >> /dev/sdd1   *        2048   187367423    93682688   83  Linux
>> >> >> /dev/sdd2       187369470   195371007     4000769    5  Extended
>> >> >> /dev/sdd5       187369472   195371007     4000768   82  Linux swap /
>> >> >> Solaris
>> >> >>
>> >> >> Disk /dev/sde: 1500.3 GB, 1500301910016 bytes
>> >> >> 255 heads, 63 sectors/track, 182401 cylinders, total 2930277168
>> >> >> sectors
>> >> >> Units = sectors of 1 * 512 = 512 bytes
>> >> >> Sector size (logical/physical): 512 bytes / 4096 bytes
>> >> >> I/O size (minimum/optimal): 4096 bytes / 4096 bytes
>> >> >> Disk identifier: 0x00000000
>> >> >>
>> >> >> Disk /dev/sde doesn't contain a valid partition table
>> >> >>
>> >> >> Disk /dev/sdf: 1500.3 GB, 1500301910016 bytes
>> >> >> 255 heads, 63 sectors/track, 182401 cylinders, total 2930277168
>> >> >> sectors
>> >> >> Units = sectors of 1 * 512 = 512 bytes
>> >> >> Sector size (logical/physical): 512 bytes / 4096 bytes
>> >> >> I/O size (minimum/optimal): 4096 bytes / 4096 bytes
>> >> >> Disk identifier: 0x00000000
>> >> >>
>> >> >> Disk /dev/sdf doesn't contain a valid partition table
>> >> >>
>> >> >> Disk /dev/sdg: 2000.4 GB, 2000398934016 bytes
>> >> >> 255 heads, 63 sectors/track, 243201 cylinders, total 3907029168
>> >> >> sectors
>> >> >> Units = sectors of 1 * 512 = 512 bytes
>> >> >> Sector size (logical/physical): 512 bytes / 4096 bytes
>> >> >> I/O size (minimum/optimal): 4096 bytes / 4096 bytes
>> >> >> Disk identifier: 0x00000000
>> >> >>
>> >> >> Disk /dev/sdg doesn't contain a valid partition table
>> >> >>
>> >> >>
>> >> >>
>> >> >> ------------------------------------------------------------------------------------------
>> >> >>
>> >> >> root@Zetta:~# blkid
>> >> >> /dev/sda: UUID="96b0e7b7-83aa-203f-1545-031b43caaa85"
>> >> >> UUID_SUB="70983681-b5c2-9f70-1801-948b1b7c97d1" LABEL="zetta:0"
>> >> >> TYPE="linux_raid_member"
>> >> >> /dev/sdb: UUID="96b0e7b7-83aa-203f-1545-031b43caaa85"
>> >> >> UUID_SUB="66843575-1a9c-30a6-8172-29f3ded468dc" LABEL="zetta:0"
>> >> >> TYPE="linux_raid_member"
>> >> >> /dev/sde: UUID="96b0e7b7-83aa-203f-1545-031b43caaa85"
>> >> >> UUID_SUB="ee7eab8f-dc90-e3be-146d-a4e09d104418" LABEL="zetta:0"
>> >> >> TYPE="linux_raid_member"
>> >> >> /dev/sdf: UUID="96b0e7b7-83aa-203f-1545-031b43caaa85"
>> >> >> UUID_SUB="b2460066-00b1-5070-cfe3-7ac67aae96c1" LABEL="zetta:0"
>> >> >> TYPE="linux_raid_member"
>> >> >> /dev/sdc: UUID="96b0e7b7-83aa-203f-1545-031b43caaa85"
>> >> >> UUID_SUB="06bd9fd3-7b1a-b0e0-b9f0-029882f39624" LABEL="zetta:0"
>> >> >> TYPE="linux_raid_member"
>> >> >> /dev/sdd1: UUID="b364f189-c9af-4774-92ba-a49307966cf7" TYPE="ext4"
>> >> >> /dev/sdd5: UUID="c78b6a64-1caa-4290-bc1a-eebe67731ca5" TYPE="swap"
>> >> >> /dev/sdg: UUID="96b0e7b7-83aa-203f-1545-031b43caaa85"
>> >> >> UUID_SUB="440f9a88-1d42-020c-ba4d-d303afb76c7c" LABEL="zetta:0"
>> >> >> TYPE="linux_raid_member"
>> >> >>
>> >> >>
>> >> >>
>> >> >> ------------------------------------------------------------------------------------------------------------
>> >> >> mdadm -E /dev/sd[abcefg]
>> >> >>
>> >> >> https://pastebin.com/zzz3jFvP
>> >> >>
>> >> >>
>> >> >>
>> >> >>
>> >> >> -------------------------------------------------------------------------------------------------------------------
>> >> >>
>> >> >> mdadm.conf :
>> >> >> DEVICE partitions CREATE owner=root group=disk mode=0660 auto=yes
>> >> >> HOMEHOST <system>  ARRAY /dev/md/zetta:0 metadata=1.2 name=zetta:0
>> >> >> UUID=96b0e7b7:83aa203f:1545031b:43caaa85
>> >> >> --
>> >> >> To unsubscribe from this list: send the line "unsubscribe
>> >> >> linux-raid"
>> >> >> in
>> >> >> the body of a message to majordomo@vger.kernel.org
>> >> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >> >
>> >> > --
>> >> > ------------------------------
>> >> > Jeff Johnson
>> >> > Co-Founder
>> >> > Aeon Computing
>> >> >
>> >> > jeff.johnson@aeoncomputing.com
>> >> > www.aeoncomputing.com
>> >> > t: 858-412-3810 x1001   f: 858-412-3845
>> >> > m: 619-204-9061
>> >> >
>> >> > 4170 Morena Boulevard, Suite D - San Diego, CA 92117
>> >> >
>> >> > High-Performance Computing / Lustre Filesystems / Scale-out Storage
>> >
>> > --
>> > ------------------------------
>> > Jeff Johnson
>> > Co-Founder
>> > Aeon Computing
>> >
>> > jeff.johnson@aeoncomputing.com
>> > www.aeoncomputing.com
>> > t: 858-412-3810 x1001   f: 858-412-3845
>> > m: 619-204-9061
>> >
>> > 4170 Morena Boulevard, Suite D - San Diego, CA 92117
>> >
>> > High-Performance Computing / Lustre Filesystems / Scale-out Storage
>
> --
> ------------------------------
> Jeff Johnson
> Co-Founder
> Aeon Computing
>
> jeff.johnson@aeoncomputing.com
> www.aeoncomputing.com
> t: 858-412-3810 x1001   f: 858-412-3845
> m: 619-204-9061
>
> 4170 Morena Boulevard, Suite D - San Diego, CA 92117
>
> High-Performance Computing / Lustre Filesystems / Scale-out Storage
