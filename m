From: Daniel Sanabria <sanabria.d@gmail.com>
Subject: Re: help please, can't mount/recover raid 5 array
Date: Mon, 11 Feb 2013 12:49:04 +0000
Message-ID: <CAHscji0+gvKgWGynAS4XhVeSpJ8AdR95ezLHvcP-wTacce=OXQ@mail.gmail.com>
References: <CAHscji2-8KaKOA041VykHeA+jCEka5afgEoH=EHVGDak-D4UFg@mail.gmail.com>
	<alpine.DEB.2.00.1302100728130.32644@uplift.swm.pp.se>
	<CAHscji0h5nHUssKi23BMfR=Ek+jSH+vK0odYNWkzrVDf6t18mw@mail.gmail.com>
	<CAHscji1enS+Crp23kMX_6pX-bhrDNZ3-7Lbg2dAOPRtJc_nEhw@mail.gmail.com>
	<51180B96.9020500@turmel.org>
	<CAKHEz2ZKL54iuiDiJiVG8Ec-cJGRnjO_qYM7nF13KQPdKUYikQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKHEz2ZKL54iuiDiJiVG8Ec-cJGRnjO_qYM7nF13KQPdKUYikQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dave Cundiff <syshackmin@gmail.com>
Cc: Phil Turmel <philip@turmel.org>, Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks a million Guys !!! I re-created the RAID and fsck it and it's
mounting fine now. The array is my /home partition and I can't see any
significant losses. But I'm still not sure what happened, I mean what
consideration should I take next time I upgrade?

Thanks again,

Daniel

On 10 February 2013 22:01, Dave Cundiff <syshackmin@gmail.com> wrote:
> On Sun, Feb 10, 2013 at 4:05 PM, Phil Turmel <philip@turmel.org> wrote:
>> Hi Daniel,
>>
>> On 02/10/2013 04:36 AM, Daniel Sanabria wrote:
>>> On 10 February 2013 09:17, Daniel Sanabria <sanabria.d@gmail.com> wrote:
>>>> Hi Mikael,
>>>>
>>>> Yes I did. Here it is:
>>
>> [trim /]
>>
>>>> /dev/sda3:
>>>>           Magic : a92b4efc
>>>>         Version : 0.90.00
>>
>> =====================^^^^^^^
>>
>>>>            UUID : 0deb6f79:aec7ed69:bfe78010:bc810f04
>>>>   Creation Time : Thu Dec  3 22:12:24 2009
>>>>      Raid Level : raid5
>>>>   Used Dev Size : 255999936 (244.14 GiB 262.14 GB)
>>>>      Array Size : 511999872 (488.28 GiB 524.29 GB)
>>>>    Raid Devices : 3
>>>>   Total Devices : 3
>>>> Preferred Minor : 2
>>>>
>>>>     Update Time : Sat Feb  9 16:09:20 2013
>>>>           State : clean
>>>>  Active Devices : 3
>>>> Working Devices : 3
>>>>  Failed Devices : 0
>>>>   Spare Devices : 0
>>>>        Checksum : 8dd157e5 - correct
>>>>          Events : 792552
>>>>
>>>>          Layout : left-symmetric
>>>>      Chunk Size : 64K
>>
>> =====================^^^
>>
>>>>
>>>>       Number   Major   Minor   RaidDevice State
>>>> this     0       8        3        0      active sync   /dev/sda3
>>>>
>>>>    0     0       8        3        0      active sync   /dev/sda3
>>>>    1     1       8       18        1      active sync   /dev/sdb2
>>>>    2     2       8       34        2      active sync   /dev/sdc2
>>
>> From your original post:
>>
>>> /dev/md2:
>>>         Version : 1.2
>>
>> ====================^^^
>>
>>>   Creation Time : Sat Feb  9 17:30:32 2013
>>>      Raid Level : raid5
>>>      Array Size : 511996928 (488.28 GiB 524.28 GB)
>>>   Used Dev Size : 255998464 (244.14 GiB 262.14 GB)
>>>    Raid Devices : 3
>>>   Total Devices : 3
>>>     Persistence : Superblock is persistent
>>>
>>>     Update Time : Sat Feb  9 20:47:46 2013
>>>           State : clean
>>>  Active Devices : 3
>>> Working Devices : 3
>>>  Failed Devices : 0
>>>   Spare Devices : 0
>>>
>>>          Layout : left-symmetric
>>>      Chunk Size : 512K
>>
>> ====================^^^^
>>
>>>
>>>            Name : lamachine:2  (local to host lamachine)
>>>            UUID : 48be851b:f0210b64:e9fbefdf:24c84c5f
>>>          Events : 2
>>>
>>>     Number   Major   Minor   RaidDevice State
>>>        0       8        3        0      active sync   /dev/sda3
>>>        1       8       18        1      active sync   /dev/sdb2
>>>        2       8       34        2      active sync   /dev/sdc2
>>
>> I don't know what possessed you to use "mdadm --create" to try to fix
>> your system, but it is almost always the wrong first step.  But since
>> you scrambled it with "mdadm --create", you'll have to fix it with
>> "mdadm --create".
>>
>> mdadm --stop /dev/md2
>>
>> mdadm --create --assume-clean /dev/md2 --metadata=0.90 \
>>         --level=5 --raid-devices=3 --chunk=64 \
>>         /dev/sda3 /dev/sdb2 /dev/sdc2
>>
>
> It looks like your using a dracut based boot system. Once you get the
> array created and mounting you'll need to update /etc/mdadm.conf with
> the new array information and run dracut to update your initrd with
> the new configuration. If not problems could crop up down the road.
>
>> Then, you will have to reconstruct the beginning of the array, as much
>> as 3MB worth, that was replaced with v1.2 metadata.  (The used dev size
>> differs by 1472kB, suggesting that the new mdadm gave you a new data
>> offset of 2048, and the rest is the difference in the chunk size.)
>>
>> Your original report and follow-ups have not clearly indicated what is
>> on this 524GB array, so I can't be more specific.  If it is a
>> filesystem, an fsck may fix it with modest losses.
>>
>> If it is another LVM PV, you may be able to do a vgrestore to reset the
>> 1st megabyte.  You didn't activate a bitmap on the array, so the
>> remainder of the new metadata space was probably untouched.
>>
>
> If the data on this array is important and without backups it would be
> a good idea to image the drives before you start doing anything else.
> Most of your data can likely be recovered but you can easily destroy
> it beyond conventional repair if your not very careful at this point.
>
> According to the fstab in the original post it looks like its just an
> ext4 filesystem on top of the md. If that is the case an fsck should
> get you going again after creating the array. You can try a regular
> fsck but your superblock is most likely gone. A backup superblock if
> needed is generally accessible by adding -b 32768 to the fsck.
> Hopefully you didn't have many files in the root of that filesystem.
> They are all most likely going to end up as random numbered files and
> directories in lost+found.
>
>
> --
> Dave Cundiff
> System Administrator
> A2Hosting, Inc
> http://www.a2hosting.com
