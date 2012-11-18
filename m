From: Drew Reusser <dreusser@gmail.com>
Subject: Re: Issue with Raid 10 super block failing
Date: Sun, 18 Nov 2012 16:49:56 +0000
Message-ID: <CAPAnFc9_AqQCHnzpNukVJNuaAZ0k9+i0wEZn6SAX=ucF_X_k2g@mail.gmail.com>
References: <CAPAnFc_USC=a8S_0wcsK36Sx=HXgfVTQ4LPC=m9Y9mDFrYrepg@mail.gmail.com>
	<50A82267.9030802@turmel.org>
	<CAPAnFc_ZtiE_-6usMHZA56Vx9JOw=gT3O3ABdpb2kcqLV6hcBw@mail.gmail.com>
	<50A8F247.8060002@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50A8F247.8060002@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Nov 18, 2012 at 2:35 PM, Phil Turmel <philip@turmel.org> wrote:
> Good morning Drew,
>
>
> On 11/17/2012 10:07 PM, Drew Reusser wrote:
>
> [top-posting repaired.  Please don't do that on kernel.org lists.]
>
>> On Sat, Nov 17, 2012 at 11:48 PM, Phil Turmel <philip@turmel.org> wrote:
>
> [trim /]
>
>>> This isn't a complete report for four devices.  Please show the output
>>> of "blkid" and "cat /proc/partitions" so we can help you report the
>>> details needed.
>
>> C is the pen-drive I am booting from currently and F is the 2TB disk I
>> was using to backup to.
>>
>> mint dev # cat /proc/partitions
>> major minor  #blocks  name
>>
>>    7        0     939820 loop0
>>    8        0  976762584 sda
>>    8        1  976760832 sda1
>>    8       16  976762584 sdb
>>    8       17  976237568 sdb1
>>    8       32    1985024 sdc
>>    8       33    1984960 sdc1
>>    8       48  976762584 sdd
>>    8       49  976760832 sdd1
>>    8       64  976762584 sde
>>    8       65  976237568 sde1
>>   11        0    1048575 sr0
>>    8       80 1953514584 sdf
>>    8       81 1953512448 sdf1
>
> Ok.  This suggests that the array was originally built from partition #1
> on each drive, not the drive itself.
>
>> mint dev # blkid
>> /dev/loop0: TYPE="squashfs"
>> /dev/sda1: UUID="db9e3115-556a-49db-27c4-2d3002657472"
>> UUID_SUB="933ec5c0-d681-9e33-adb0-e6c890e337bd" LABEL="mint:0"
>> TYPE="linux_raid_member"
>> /dev/sdb1: UUID="db9e3115-556a-49db-27c4-2d3002657472"
>> UUID_SUB="9d6df7c7-ce40-1405-4ea1-8763a528ecc5" LABEL="mint:0"
>> TYPE="linux_raid_member"
>> /dev/sdc1: UUID="5860-2FA0" TYPE="vfat"
>> /dev/sdd1: UUID="db9e3115-556a-49db-27c4-2d3002657472"
>> UUID_SUB="fa1a1b82-989e-933a-95e4-d2495cee901d" LABEL="mint:0"
>> TYPE="linux_raid_member"
>> /dev/sde1: UUID="db9e3115-556a-49db-27c4-2d3002657472"
>> UUID_SUB="594ed481-471e-f11a-027f-1c246f9d057d" LABEL="mint:0"
>> TYPE="linux_raid_member"
>> /dev/sdf1: UUID="1C3C2B104A8445ED" TYPE="ntfs"
>
> As does this.  Somehow you ended up with a v1.2 superblock on /dev/sda.
>
> Please repeat the examines with "mdadm -E /dev/sd[abde]1"
>
> Phil
>
>

I originally started the disks at (block?) 2048 so there was a 2mb
partition to load the bootloader (grub) and mdadm.  Everything else
was on one partition as you observed.  I figured the simpler the
better for this configuration.

Here you go.


mint dev # mdadm -E /dev/sd[abde]1
/dev/sda1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : db9e3115:556a49db:27c42d30:02657472
           Name : mint:0  (local to host mint)
  Creation Time : Thu Nov 15 16:08:02 2012
     Raid Level : raid10
   Raid Devices : 4

 Avail Dev Size : 1953259520 (931.39 GiB 1000.07 GB)
     Array Size : 1952211968 (1861.77 GiB 1999.07 GB)
  Used Dev Size : 1952211968 (930.89 GiB 999.53 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 933ec5c0:d6819e33:adb0e6c8:90e337bd

    Update Time : Thu Nov 15 20:08:55 2012
       Checksum : b516984f - correct
         Events : 17

         Layout : near=2
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAA ('A' == active, '.' == missing)
/dev/sdb1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : db9e3115:556a49db:27c42d30:02657472
           Name : mint:0  (local to host mint)
  Creation Time : Thu Nov 15 16:08:02 2012
     Raid Level : raid10
   Raid Devices : 4

 Avail Dev Size : 1952212992 (930.89 GiB 999.53 GB)
     Array Size : 1952211968 (1861.77 GiB 1999.07 GB)
  Used Dev Size : 1952211968 (930.89 GiB 999.53 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 9d6df7c7:ce401405:4ea18763:a528ecc5

    Update Time : Thu Nov 15 20:08:55 2012
       Checksum : 3103c408 - correct
         Events : 17

         Layout : near=2
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAAA ('A' == active, '.' == missing)
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : db9e3115:556a49db:27c42d30:02657472
           Name : mint:0  (local to host mint)
  Creation Time : Thu Nov 15 16:08:02 2012
     Raid Level : raid10
   Raid Devices : 4

 Avail Dev Size : 1953259520 (931.39 GiB 1000.07 GB)
     Array Size : 1952211968 (1861.77 GiB 1999.07 GB)
  Used Dev Size : 1952211968 (930.89 GiB 999.53 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : fa1a1b82:989e933a:95e4d249:5cee901d

    Update Time : Thu Nov 15 20:08:55 2012
       Checksum : 5ea6d02d - correct
         Events : 17

         Layout : near=2
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAAA ('A' == active, '.' == missing)
/dev/sde1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : db9e3115:556a49db:27c42d30:02657472
           Name : mint:0  (local to host mint)
  Creation Time : Thu Nov 15 16:08:02 2012
     Raid Level : raid10
   Raid Devices : 4

 Avail Dev Size : 1952212992 (930.89 GiB 999.53 GB)
     Array Size : 1952211968 (1861.77 GiB 1999.07 GB)
  Used Dev Size : 1952211968 (930.89 GiB 999.53 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 594ed481:471ef11a:027f1c24:6f9d057d

    Update Time : Thu Nov 15 20:08:55 2012
       Checksum : 786bd4bc - correct
         Events : 17

         Layout : near=2
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AAAA ('A' == active, '.' == missing)
