From: Phil Turmel <philip@turmel.org>
Subject: Re: help please, can't mount/recover raid 5 array
Date: Sun, 10 Feb 2013 16:05:26 -0500
Message-ID: <51180B96.9020500@turmel.org>
References: <CAHscji2-8KaKOA041VykHeA+jCEka5afgEoH=EHVGDak-D4UFg@mail.gmail.com> <alpine.DEB.2.00.1302100728130.32644@uplift.swm.pp.se> <CAHscji0h5nHUssKi23BMfR=Ek+jSH+vK0odYNWkzrVDf6t18mw@mail.gmail.com> <CAHscji1enS+Crp23kMX_6pX-bhrDNZ3-7Lbg2dAOPRtJc_nEhw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHscji1enS+Crp23kMX_6pX-bhrDNZ3-7Lbg2dAOPRtJc_nEhw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Sanabria <sanabria.d@gmail.com>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Daniel,

On 02/10/2013 04:36 AM, Daniel Sanabria wrote:
> On 10 February 2013 09:17, Daniel Sanabria <sanabria.d@gmail.com> wrote:
>> Hi Mikael,
>>
>> Yes I did. Here it is:

[trim /]

>> /dev/sda3:
>>           Magic : a92b4efc
>>         Version : 0.90.00

=====================^^^^^^^

>>            UUID : 0deb6f79:aec7ed69:bfe78010:bc810f04
>>   Creation Time : Thu Dec  3 22:12:24 2009
>>      Raid Level : raid5
>>   Used Dev Size : 255999936 (244.14 GiB 262.14 GB)
>>      Array Size : 511999872 (488.28 GiB 524.29 GB)
>>    Raid Devices : 3
>>   Total Devices : 3
>> Preferred Minor : 2
>>
>>     Update Time : Sat Feb  9 16:09:20 2013
>>           State : clean
>>  Active Devices : 3
>> Working Devices : 3
>>  Failed Devices : 0
>>   Spare Devices : 0
>>        Checksum : 8dd157e5 - correct
>>          Events : 792552
>>
>>          Layout : left-symmetric
>>      Chunk Size : 64K

=====================^^^

>>
>>       Number   Major   Minor   RaidDevice State
>> this     0       8        3        0      active sync   /dev/sda3
>>
>>    0     0       8        3        0      active sync   /dev/sda3
>>    1     1       8       18        1      active sync   /dev/sdb2
>>    2     2       8       34        2      active sync   /dev/sdc2

From your original post:

> /dev/md2:
>         Version : 1.2

====================^^^

>   Creation Time : Sat Feb  9 17:30:32 2013
>      Raid Level : raid5
>      Array Size : 511996928 (488.28 GiB 524.28 GB)
>   Used Dev Size : 255998464 (244.14 GiB 262.14 GB)
>    Raid Devices : 3
>   Total Devices : 3
>     Persistence : Superblock is persistent
> 
>     Update Time : Sat Feb  9 20:47:46 2013
>           State : clean
>  Active Devices : 3
> Working Devices : 3
>  Failed Devices : 0
>   Spare Devices : 0
> 
>          Layout : left-symmetric
>      Chunk Size : 512K

====================^^^^

> 
>            Name : lamachine:2  (local to host lamachine)
>            UUID : 48be851b:f0210b64:e9fbefdf:24c84c5f
>          Events : 2
> 
>     Number   Major   Minor   RaidDevice State
>        0       8        3        0      active sync   /dev/sda3
>        1       8       18        1      active sync   /dev/sdb2
>        2       8       34        2      active sync   /dev/sdc2

I don't know what possessed you to use "mdadm --create" to try to fix
your system, but it is almost always the wrong first step.  But since
you scrambled it with "mdadm --create", you'll have to fix it with
"mdadm --create".

mdadm --stop /dev/md2

mdadm --create --assume-clean /dev/md2 --metadata=0.90 \
	--level=5 --raid-devices=3 --chunk=64 \
	/dev/sda3 /dev/sdb2 /dev/sdc2

Then, you will have to reconstruct the beginning of the array, as much
as 3MB worth, that was replaced with v1.2 metadata.  (The used dev size
differs by 1472kB, suggesting that the new mdadm gave you a new data
offset of 2048, and the rest is the difference in the chunk size.)

Your original report and follow-ups have not clearly indicated what is
on this 524GB array, so I can't be more specific.  If it is a
filesystem, an fsck may fix it with modest losses.

If it is another LVM PV, you may be able to do a vgrestore to reset the
1st megabyte.  You didn't activate a bitmap on the array, so the
remainder of the new metadata space was probably untouched.

HTH,

Phil
