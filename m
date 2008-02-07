From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Deleting mdadm RAID arrays
Date: Thu, 07 Feb 2008 16:35:45 -0500
Message-ID: <47AB79B1.6000503@tmr.com>
References: <200802051142.19625.admin@domeny.pl> <200802061303.50017.admin@domeny.pl> <18346.28335.256479.27397@notabene.brown> <200802071056.33221.admin@domeny.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200802071056.33221.admin@domeny.pl>
Sender: linux-raid-owner@vger.kernel.org
To: Marcin Krol <admin@domeny.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Marcin Krol wrote:
> Thursday 07 February 2008 03:36:31 Neil Brown napisa=C5=82(a):
>
>  =20
>>>    8     0  390711384 sda
>>>    8     1  390708801 sda1
>>>    8    16  390711384 sdb
>>>    8    17  390708801 sdb1
>>>    8    32  390711384 sdc
>>>    8    33  390708801 sdc1
>>>    8    48  390710327 sdd
>>>    8    49  390708801 sdd1
>>>    8    64  390711384 sde
>>>    8    65  390708801 sde1
>>>    8    80  390711384 sdf
>>>    8    81  390708801 sdf1
>>>    3    64   78150744 hdb
>>>    3    65    1951866 hdb1
>>>    3    66    7815622 hdb2
>>>    3    67    4883760 hdb3
>>>    3    68          1 hdb4
>>>    3    69     979933 hdb5
>>>    3    70     979933 hdb6
>>>    3    71   61536951 hdb7
>>>    9     1  781417472 md1
>>>    9     0  781417472 md0
>>>      =20
>> So all the expected partitions are known to the kernel - good.
>>    =20
>
> It 's not good really!!
>
> I can't trust /dev/sd* devices - they get swapped randomly depending=20
> on sequence of module loading!! I have two drivers, ahci for onboard
> SATA controllers and sata_sil for additional controller.
>
> Sometimes the system boots ahci first and sata_sil later, sometimes=20
> in reverse sequence.=20
>
> Then, sda becomes sdc, sdb becomes sdd, etc.=20
>
> It is exactly the problem that I cannot rely on kernel's information =
which
> physical drive is which logical drive!
>
>  =20
>> Then
>>   mdadm /dev/md0 -f /dev/d_1
>>
>> will fail d_1, abort the recovery, and release d_1.
>>
>> Then
>>   mdadm --zero-superblock /dev/d_1
>>
>> should work.
>>    =20
>
> Thanks, though I managed to fail the drives, remove them, zero superb=
locks=20
> and reassemble the arrays anyway.=20
>
> The problem I have now is that mdadm seems to be of 'two minds' when =
it comes=20
> to where it gets the info on which disk is what part of the array.=20
>
> As you may remember, I have configured udev to associate /dev/d_* dev=
ices with
> serial numbers (to keep them from changing depending on boot module l=
oading=20
> sequence).=20
>
>  =20
Why do you care? If you are using UUID for all the arrays and mounts=20
does this buy you anything? And more to the point, the first time a=20
drive fails and you replace it, will it cause you a problem? Require=20
maintaining the serial to name data manually?

I miss the benefit of forcing this instead of just building the=20
information at boot time and dropping it in a file.

> Now, when I swap two (random) drives in order to test if it keeps dev=
ice names=20
> associated with serial numbers I get the following effect:
>
> 1. mdadm -Q --detail /dev/md* gives correct results before *and* afte=
r the swapping:
>
> % mdadm -Q --detail /dev/md0
> /dev/md0:
> [...]
>     Number   Major   Minor   RaidDevice State
>        0       8        1        0      active sync   /dev/d_1
>        1       8       17        1      active sync   /dev/d_2
>        2       8       81        2      active sync   /dev/d_3
>
> % mdadm -Q --detail /dev/md1
> /dev/md1:
> [...]
>     Number   Major   Minor   RaidDevice State
>        0       8       49        0      active sync   /dev/d_4
>        1       8       65        1      active sync   /dev/d_5
>        2       8       33        2      active sync   /dev/d_6
>
>
> 2. However, cat /proc/mdstat gives shows different layout of the arra=
ys!
>
> BEFORE the swap:
>
> % cat mdstat-16_51
> Personalities : [raid6] [raid5] [raid4]
> md1 : active raid5 sdb1[2] sdf1[0] sda1[1]
>       781417472 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
>
> md0 : active raid5 sde1[2] sdc1[0] sdd1[1]
>       781417472 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
>
> unused devices: <none>
>
>
> AFTER the swap:
>
> % cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md1 : active(auto-read-only) raid5 sdd1[0] sdc1[2] sde1[1]
>       781417472 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
>
> md0 : active(auto-read-only) raid5 sda1[0] sdf1[2] sdb1[1]
>       781417472 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
>
> unused devices: <none>
>
> I have no idea now if the array is functioning (it keeps the drives
> according to /dev/d_* devices and superblock info is unimportant)
> or if my arrays fell apart because of that swapping.=20
>
> And I made *damn* sure I zeroed all the superblocks before reassembli=
ng=20
> the arrays. Yet it still shows the old partitions on those arrays!
>  =20
As I noted before, you said you had these on whole devices before, did=20
you zero the superblocks on the whole devices or the partitions? From=20
what I read, it was the partitions.

--=20
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will stil=
l
  be valid when the war is over..." Otto von Bismark=20



-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
