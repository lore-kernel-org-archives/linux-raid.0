From: Drew Reusser <dreusser@gmail.com>
Subject: Re: Issue with Raid 10 super block failing
Date: Sun, 18 Nov 2012 03:07:13 +0000
Message-ID: <CAPAnFc_ZtiE_-6usMHZA56Vx9JOw=gT3O3ABdpb2kcqLV6hcBw@mail.gmail.com>
References: <CAPAnFc_USC=a8S_0wcsK36Sx=HXgfVTQ4LPC=m9Y9mDFrYrepg@mail.gmail.com>
	<50A82267.9030802@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50A82267.9030802@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

C is the pen-drive I am booting from currently and F is the 2TB disk I
was using to backup to.

mint dev # cat /proc/partitions
major minor  #blocks  name

   7        0     939820 loop0
   8        0  976762584 sda
   8        1  976760832 sda1
   8       16  976762584 sdb
   8       17  976237568 sdb1
   8       32    1985024 sdc
   8       33    1984960 sdc1
   8       48  976762584 sdd
   8       49  976760832 sdd1
   8       64  976762584 sde
   8       65  976237568 sde1
  11        0    1048575 sr0
   8       80 1953514584 sdf
   8       81 1953512448 sdf1
mint dev # blkid
/dev/loop0: TYPE="squashfs"
/dev/sda1: UUID="db9e3115-556a-49db-27c4-2d3002657472"
UUID_SUB="933ec5c0-d681-9e33-adb0-e6c890e337bd" LABEL="mint:0"
TYPE="linux_raid_member"
/dev/sdb1: UUID="db9e3115-556a-49db-27c4-2d3002657472"
UUID_SUB="9d6df7c7-ce40-1405-4ea1-8763a528ecc5" LABEL="mint:0"
TYPE="linux_raid_member"
/dev/sdc1: UUID="5860-2FA0" TYPE="vfat"
/dev/sdd1: UUID="db9e3115-556a-49db-27c4-2d3002657472"
UUID_SUB="fa1a1b82-989e-933a-95e4-d2495cee901d" LABEL="mint:0"
TYPE="linux_raid_member"
/dev/sde1: UUID="db9e3115-556a-49db-27c4-2d3002657472"
UUID_SUB="594ed481-471e-f11a-027f-1c246f9d057d" LABEL="mint:0"
TYPE="linux_raid_member"
/dev/sdf1: UUID="1C3C2B104A8445ED" TYPE="ntfs"


On Sat, Nov 17, 2012 at 11:48 PM, Phil Turmel <philip@turmel.org> wrote:
> Hi Drew,
>
> On 11/17/2012 01:06 PM, Drew Reusser wrote:
>> I hate to be a newbie on this list, and ask a question but I am really at a
>> loss.  I have a raid 10 that I have had working and was throwing no errors,
>> and I rebooted and now I cannot get it to come back.  I am running a live
>> CD and trying to get it to mount, and I am getting errors about bad
>> superblocks, invalid bitmaps, and invalid partition tables.  I have been
>> scouring the interwebs for the last few days and ran across the archive on
>> http://www.spinics.net but cannot find anything that has worked there for
>> me so I figured I would join and at least hope.  Last chance for me to take
>> it to a data retrieval office which I really don't want to do.
>>
>> Here is my setup.  4x1tb disks in raid 10.  I can get the array to mount -
>> but it tells me the file system is invalid.  I have the following from
>> commands I have seen people ask below.  The devices are currently sitting
>> unmounted and not in an array until I can go forward with some confidence I
>> am not going to loose my data.
>>
>>
>>
>>
>> mint dev # mdadm --examine /dev/sd[abde]
>> /dev/sda:
>>    MBR Magic : aa55
>> Partition[0] :   1953521664 sectors at         2048 (type 83)
>> /dev/sdb:
>>           Magic : a92b4efc
>>         Version : 1.2
>>     Feature Map : 0x0
>>      Array UUID : 5a2570f4:0bbaf2d4:8a3cc761:
>> 69b655ba
>>            Name : mint:0  (local to host mint)
>>   Creation Time : Wed Nov 14 20:55:09 2012
>>      Raid Level : raid10
>>    Raid Devices : 4
>>
>>  Avail Dev Size : 1953263024 (931.39 GiB 1000.07 GB)
>>      Array Size : 1953262592 (1862.78 GiB 2000.14 GB)
>>   Used Dev Size : 1953262592 (931.39 GiB 1000.07 GB)
>>     Data Offset : 262144 sectors
>>    Super Offset : 8 sectors
>>           State : clean
>>     Device UUID : e955cd6f:96e08ba2:c40bddae:ac633f0d
>>
>>     Update Time : Wed Nov 14 21:15:27 2012
>>        Checksum : 5b7c4f1e - correct
>>          Events : 9
>>
>>          Layout : near=2
>>      Chunk Size : 512K
>>
>>    Device Role : Active device 1
>>    Array State : .A.A ('A' == active, '.' == missing)
>> /dev/sdd:
>>           Magic : a92b4efc
>>         Version : 1.2
>
> This isn't a complete report for four devices.  Please show the output
> of "blkid" and "cat /proc/partitions" so we can help you report the
> details needed.
>
> Phil
>
>
