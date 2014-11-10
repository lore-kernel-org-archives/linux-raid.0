From: "P. Gautschi" <linuxlist@gautschi.net>
Subject: Re: --no-degraded does not work
Date: Mon, 10 Nov 2014 04:13:00 +0100
Message-ID: <54602D3C.2070005@gautschi.net>
References: <545CF69B.6040307@gautschi.net> <20141108102247.687b8863@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141108102247.687b8863@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

 > Do you have a particular goal, or were you just making sure you understood?

Both. My goal is to keep my data a safe as possible in case of a 2 and more disk failure
for non permanent failures. During experiments I has problems with a power cable
and I was not able to recover from this situation. (3 Disk ok, 2 that failed after
each other)
I therefor would not like to start the array when not all disk are ok.
I created a script that checks in readonly mode first.

On 2014-11-08 00:22, NeilBrown wrote:
> On Fri, 07 Nov 2014 17:43:07 +0100 "P. Gautschi"<linuxlist@gautschi.net>
> wrote:
>
>> As far as I understand the documentation --assemble --no-degraded should not start a degraded array.
>> However on my system (kubuntu 14.10)
>>
>> # mdadm --assemble --no-degraded /dev/md0 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1
>> mdadm: /dev/md0 has been started with 4 drives (out of 5).
>>
>> # mdadm --detail /dev/md0
>> /dev/md0:
>>           Version : 1.2
>>     Creation Time : Tue Nov  4 15:26:46 2014
>>        Raid Level : raid5
>>        Array Size : 599469328 (571.70 GiB 613.86 GB)
>>     Used Dev Size : 149867332 (142.92 GiB 153.46 GB)
>>      Raid Devices : 5
>>     Total Devices : 4
>>       Persistence : Superblock is persistent
>>
>>     Intent Bitmap : Internal
>>
>>       Update Time : Fri Nov  7 17:22:53 2014
>>             State : clean, degraded
>>    Active Devices : 4
>> Working Devices : 4
>>    Failed Devices : 0
>>     Spare Devices : 0
>>
>>            Layout : left-symmetric
>>        Chunk Size : 4K
>>
>>              Name : 0
>>              UUID : c7465b19:c149b2d1:5b4d88ce:8c6ce432
>>            Events : 642
>>
>>       Number   Major   Minor   RaidDevice State
>>          0       0        0        0      removed
>>          1       8       33        1      active sync   /dev/sdc1
>>          2       8       49        2      active sync   /dev/sdd1
>>          3       8       65        3      active sync   /dev/sde1
>>          5       8       81        4      active sync   /dev/sdf1
>>
>> the array IS started when removing one disk, stopping it, reconnecting the disk and then assemble the array.
>> Is this the supposed behavior?
>
> Yes, that is the correct behaviour, though I admit that it is slightly
> unintuitive.
>
> --no-degraded will cause mdadm to refuse to assemble an array which is more
> degraded than it was last time it was active.
>
> So if you have an optimal array, stop it, then try to assemble with some
> devices missing, then --no-degraded will cause that to fail.
>
> If the array is already degraded, then there doesn't seem much point in
> stopping it from assembling.
>
> Do you have a particular goal, or were you just making sure you understood?
>
> Thanks,
> NeilBrown
