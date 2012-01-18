From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: RAID6, failed device, unresponsive system?
Date: Wed, 18 Jan 2012 09:22:31 +0000
Message-ID: <CADNH=7EWNXxVLakG_toa8HYe8VNUHPa=FR8Y4E98x7qAUwciVA@mail.gmail.com>
References: <CADNH=7FyxQ=C=gdirjpTsc5q0tJ2=SSXtryRM36icTH=ncC_0A@mail.gmail.com>
	<CADNH=7GrCN5ec5YahZvAGiHTW65eiptE74KN=F1oe_gGQpHTow@mail.gmail.com>
	<20245.25412.868844.285385@tree.ty.sabi.co.UK>
	<CADNH=7G1ezaAXtthpXOQzUA+iMr0Cby-1W0ZwOWpkgM6PEDk_Q@mail.gmail.com>
	<4F166CC0.6020407@stud.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F166CC0.6020407@stud.tu-ilmenau.de>
Sender: linux-raid-owner@vger.kernel.org
To: stefan.huebner@stud.tu-ilmenau.de
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 18 January 2012 06:54, Stefan /*St0fF*/ H=C3=BCbner
<stefan.huebner@stud.tu-ilmenau.de> wrote:
> Hi
>
> Am 17.01.2012 13:33, schrieb Mathias Bur=C3=A9n:
>> On 17 January 2012 12:02, Peter Grandi <pg@lxra2.for.sabi.co.uk> wro=
te:
>>> [ ... ]
>>>
>>>>> Why is the system unresponsive, shouldn't it still be OK
>>>>> after a drive failure?
>>>
>>> There is a bit of a difference between a "drive failure" and
>>> some/several bad sectors on a drive.
>>>
>>> It is also to wonder whether the partially defective drive has
>>> been "failed" and "removed" from the MD set and perhaps
>>> "deleted" using '/sys/block/sdb/device/delete'.
>>>
>>>> Hm, I'm seeing this in dmesg, could it be related? (ioctl lock)
>>>
>>>> [425480.928740] md/raid:md0: read error corrected (8 sectors at
>>>> 223617240 on sdb1)
>>>
>>> Note the "read error corrected" (*corrected*) and that is is "8
>>> sectors" may indicate it is one of the drives with 4096B sectors
>>> that is configured as if it has 512B ones.
>>>
>
> Right, that is how WD20EARS react.
>
>>> [ ... ]
>>>
>>> Overall it is likely that you have just implicitly discovered
>>> how important short settings for Error Recovery Control are, and
>>> to choose drives that allow you to set them:
>>>
>>> =C2=A0http://www.sabi.co.uk/blog/1103Mar.html#110331
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.=
html
>>
>> =C2=A0$ sudo smartctl -l scterc,20,20 /dev/sdb
>> smartctl 5.42 2011-10-20 r3458 [x86_64-linux-3.2.0-2-ARCH] (local bu=
ild)
>> Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourcefor=
ge.net
>>
>> Warning: device does not support SCT Error Recovery Control command
>>
>> :-/ and yes it's a "4KB" drive, a WD20EARS. It failed after almost
>> 11000 hours. Thanks, now I know the reason for the system hang.
>
> Those are not very suited for RAID. =C2=A0They were the cheapest WD 2=
TB
> drives in the consumer segment, they don't support TLER/ERC. =C2=A0An=
d from
> my experience the replacement drives won't last very long, either. =C2=
=A0At
> least you have raid6 there...
>

I know. I picked them because they were cheap, I got 5 of them new for
about 380 USD.

> Is the drive that corrects its sectors still in the array (I'd guess
> that)? =C2=A0If yes, just issue the next rma, error is "drive reacts =
very
> slowly". =C2=A0I fear you have to wait for the first resync or do a d=
drescue
> with the disk that is still in the array while the array is taken
> offline (that way you don't take the chance of another drive failing
> while resyncing).
>
> All the best,
> Stefan
>>

(cc Linux RAID)
The drive is now out of the array. I had to pull the power to the
system, physically pull the disk, then boot into single user mode.
There I had to do a force assemble (because the array wouldn't
assemble in a not-clean state automatically). That worked fine, so I
did an fsck which turned out OK, and now it's "checking" the array. I
should've probably checked the array before the fsck, but oh well.
Check still in progress.

Thanks,
M
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
