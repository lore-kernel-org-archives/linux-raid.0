From: Jivko Sabev <jsabev@nicmus.com>
Subject: Re: Cannot auto assemble a raid1 array on boot
Date: Tue, 23 Oct 2012 09:43:58 -0600
Message-ID: <CAG9W8wBgqitp48C2O+8YUHWMp_HPf9TtokOt_wMM9qJcq2KL3Q@mail.gmail.com>
References: <CAG9W8wBsh_i_jtqKFhEVywCk92hef41T0t+6J9saZD3CFT7V9A@mail.gmail.com>
	<507F7428.6030003@websitemanagers.com.au>
	<CAG9W8wCH9bfHou72_+t+JoCS3EA96opcpTOTzkc2E0oFkbX8zg@mail.gmail.com>
	<50808CB0.8020902@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50808CB0.8020902@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

Thank you for the suggestions. I have tried explicitly listing the
devices comprising the /dev/md1 array in mdadm.conf as follows:

[snip]
 # definitions of existing MD arrays
ARRAY /dev/md0 metadata=1.2 UUID=60ea870e:029dcf99:eaae356e:f1c12085
name=mercury:0
ARRAY /dev/md1 devices=/dev/md0,/dev/sde1
[snip]

but that has yielded no new results. Same issue of the /dev/md1 array
not being present at boot - dumped into initramfs shell. Below is the
relevent info from "dmesg" in the initramfs shell.

[snip]
[    2.934840] md: bind<sdc1>
[    2.936390] md: linear personality registered for level -1
[    2.936588] bio: create slab <bio-1> at 1
[    2.936698] md0: detected capacity change from 0 to 1000213030400
[    2.939927]  md0: unknown partition table
[    2.944653] md: bind<sde1>
[    4.181978] md: multipath personality registered for level -4
[    4.183187] md: raid0 personality registered for level 0
[    4.184479] md: raid1 personality registered for level 1
[    4.185683] async_tx: api initialized (async)
[    4.252024] raid6: int64x1   2581 MB/s
[    4.320019] raid6: int64x2   3726 MB/s
[    4.388028] raid6: int64x4   2713 MB/s
[    4.456033] raid6: int64x8   2406 MB/s
[    4.524023] raid6: sse2x1    3911 MB/s
[    4.592011] raid6: sse2x2    6382 MB/s
[    4.660027] raid6: sse2x4    7641 MB/s
[    4.660048] raid6: using algorithm sse2x4 (7641 MB/s)
[    4.660321] xor: automatically using best checksumming function: generic_sse
[    4.680016]    generic_sse: 12316.000 MB/sec
[    4.680040] xor: using function: generic_sse (12316.000 MB/sec)
[    4.680555] md: raid6 personality registered for level 6
[    4.680584] md: raid5 personality registered for level 5
[    4.680611] md: raid4 personality registered for level 4
[    4.684297] md: raid10 personality registered for level 10
[snip]


Looking at the log, /dev/md1 is not even mentioned. My suspicion is
that because /dev/md0 is of "unknown partition type" it cannot be used
for assembly.

Following the leads on the other suggestings, created a partion on md0
of type FD (Linux Raid auto detect). Reassembled the array, updated
the initrd image but the problem remains. That is the RAID array is
not auto-assembled on boot. Here is the dmesg log

[snip]
[    1.958921] md: bind<sdb1>
[    2.470635] md: bind<sdc1>
[    2.471928] md: linear personality registered for level -1
[    2.875391] md0: detected capacity change from 0 to 1000213030400
[    2.878472]  md0: p1
[    2.945002] md: bind<sde1>
[    4.397985] md: multipath personality registered for level -4
[    4.399191] md: raid0 personality registered for level 0
[    4.400490] md: raid1 personality registered for level 1
[    4.896552] md: raid6 personality registered for level 6
[    4.896580] md: raid5 personality registered for level 5
[    4.896607] md: raid4 personality registered for level 4
[    4.900306] md: raid10 personality registered for level 10
[   57.097141] md: md1 stopped.
[   57.097238] md: unbind<sde1>
[   57.100051] md: export_rdev(sde1)
[   75.147783] md: md1 stopped.
[   75.148555] md: bind<sde1>
[   75.148909] md: bind<md0>
[   75.149880] md/raid1:md1: active with 2 out of 2 mirrors
[   75.150003] md1: detected capacity change from 0 to 1000078639104
[   75.170616]  md1: unknown partition table
[snip]

Same problem. The system is in initramfs rescue shell. Array manually
reassembled after which everything works.

It is worth mentioning that /dev/md1 is listed in the /etc/crypttab
and is encrypted with dm-crypt luks extension.

Any one out there with similar setup?

Thanks again for you time.

Jivko

On Thu, Oct 18, 2012 at 5:11 PM, Adam Goryachev
<mailinglists@websitemanagers.com.au> wrote:
> On 19/10/12 02:19, Jivko Sabev wrote:
>> Hi,
>>
>> The mdadm.conf in the initrd image contains the correct devices. I.e.
>> the contents of mdadm.conf in initrd are the output of
>>
>> mdadm --detail --scan
>>
>> ARRAY /dev/md0 metadata=1.2 name=mercury:0
>> UUID=60ea870e:029dcf99:eaae356e:f1c12085
>> ARRAY /dev/md1 metadata=1.2 name=mercury:1
>> UUID=d89a52ed:0247f2e8:5edf5d09:21e7fa48
>>
>> Here are the contents of /proc/mdstat from the initrd shell before
>> reassembling the array.
>>
>> md1 : inactive sde1[2](S)
>>       976639672 blocks super 1.2
>>
>> md0 : active linear sdb1[0] sdc1[1]
>>       976770537 blocks super 1.2 0k rounding
>>
>> unused devices: <none>
>>
>> It just seems to me that it is not possible to mix md devices and sata
>> devices for new arrays.
>
> I know it is possible because I have done this before ...
>
> Try adding the device names to the mdadm.conf....
>
> An alternative would be to create a partition table on /dev/md0 of type
> fd, this way it should be handled properly by the rest of the MD auto
> assemble code.
>
> The other option might be to use a different superblock version between
> the two arrays...
>
> Other than that, I'm not too sure, maybe someone else could comment?
> Perhaps you could provide the logs generated during bootup in relation
> to the MD discovery etc
>
> Regards,
> Adam
>
> --
> Adam Goryachev
> Website Managers
> www.websitemanagers.com.au
