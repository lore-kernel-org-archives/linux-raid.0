From: Mariusz Zalewski <mariusz@zalewscy.eu>
Subject: Re: Raid recovery - raid5 - one active, two spares
Date: Tue, 28 Jan 2014 22:22:31 +0100
Message-ID: <CAPZL0fqLEm=VTV2epVBD7hydBjgCtGS6B7rg-s1dL6=as9d1+A@mail.gmail.com>
References: <CAPZL0fpbkAy=L7i3RcTL_z0y2dQ5K00Y2Vnhss_agtCoZEur4Q@mail.gmail.com>
 <52DAA0D1.60005@turmel.org> <CAPZL0focNQC0FtfSSDx6mh=LJUVeDyc7ZO4A3D6QOn6d7MDffA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPZL0focNQC0FtfSSDx6mh=LJUVeDyc7ZO4A3D6QOn6d7MDffA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm back with good news.

[cut]
>>> LiveUSBmint ~ # cat /proc/mdstat
>>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
>>> [raid4] [raid10]
>>> md2 : inactive sdd1[1](S) sde1[3](S)
>>>       5859354352 blocks super 1.0
>>>
>>> unused devices: <none>
>>>
>>> LiveUSBmint ~ # mdadm --examine /dev/sd[bde]1
>>> /dev/sdb1:
>>>           Magic : a92b4efc
>>>         Version : 1.0
>>>     Feature Map : 0x0
>>>      Array UUID : e494f7d3:bef9154e:1de134d7:476ed4e0
>>>            Name : tobik:2
>>>   Creation Time : Wed May 23 00:05:55 2012
>>>      Raid Level : raid5
>>>    Raid Devices : 3
>>>
>>>  Avail Dev Size : 5859354352 (2793.96 GiB 2999.99 GB)
>>>      Array Size : 11718708480 (5587.92 GiB 5999.98 GB)
>>>   Used Dev Size : 5859354240 (2793.96 GiB 2999.99 GB)
>>>    Super Offset : 5859354608 sectors
>>>           State : clean
>>>     Device UUID : 8aa81e09:22237f15:0801f42d:95104515
>>>
>>>     Update Time : Fri Jan 17 18:32:50 2014
>>>        Checksum : 8454c6e - correct
>>>          Events : 91
>>>
>>>          Layout : left-symmetric
>>>      Chunk Size : 64K
>>>
>>>    Device Role : Active device 0
>>>    Array State : AAA ('A' == active, '.' == missing)
>>
>> This is good.
>>
>>> /dev/sdd1:
>>>           Magic : a92b4efc
>>>         Version : 1.0
>>>     Feature Map : 0x0
>>>      Array UUID : e494f7d3:bef9154e:1de134d7:476ed4e0
>>>            Name : tobik:2
>>>   Creation Time : Wed May 23 00:05:55 2012
>>>      Raid Level : -unknown-
>>>    Raid Devices : 0
>>>
>>>  Avail Dev Size : 5859354352 (2793.96 GiB 2999.99 GB)
>>>    Super Offset : 5859354608 sectors
>>>           State : active
>>>     Device UUID : ec85b3b8:30a31d27:6af31507:dcb4e8dc
>>>
>>>     Update Time : Fri Jan 17 20:07:12 2014
>>>        Checksum : 6a2b13f4 - correct
>>>          Events : 1
>>>
>>>
>>>    Device Role : spare
>>>    Array State :  ('A' == active, '.' == missing)
>>
>> This is bad.  Simply attempting to assemble an array will not change a
>> drive to a spare.

I've done some tests on virtual environment similar to my hardware
configuration (LinuxMint13@VirtualBox with RAID5@3HDs). Results: Every
time I've disconnect 2 of 3 hard drives (only one remained) and boot
system twice (doesn't matter mode - "normal" or "recovery") this one
connected drive is "flagged" as spare. I did not make further
investigations why it happens. I made 2 HDs as spares this way and try
to recreate array. It led me to success.

[cut]
>>> It is possible to recover Raid 5 from this disks? I consider
>>> "Restoring array by recreating..."
>>> <https://raid.wiki.kernel.org/index.php/RAID_Recovery#Restore_array_by_recreating_.28after_multiple_device_failure.29>
>>> but I would like to know Your opinion. According to wiki it should be
>>> considered as *last* resort.
>>
>> It is a last resort, but appears to be necessary in your case.  There's
>> only two possible device orders to choose from.  Your array has version
>> 1.0 metadata, so the data offset won't be a problem, but you must use
>> the --size option to make sure the new array has the same size as the
>> original:
>>
>> Try #1:
>>
>> mdadm --stop /dev/md2
>> mdadm --create --assume-clean --metadata=1.0 --size=2929677120 \
>>   --chunk=64 /dev/md2 /dev/sd{b,d,e}1
>>
>> Show "mdadm -E /dev/sdb1" and verify that all of the sizes & offsets
>> match the original.
>>
>> Do *not* mount the array! (Yet)
>>
>> Use "fsck -n" to see if the filesystem is reasonably consistent.  If
>> not, switch /dev/sdd1 and /dev/sde1 in try #2.
>>
>> When you are confortable with the device order based on "fsck -n"
>> output, perform a normal fsck, then mount.

My main (not virtual) array was recreated at "Try #1". Thank you.

Best regards,

-- 
Mariusz Zalewski
