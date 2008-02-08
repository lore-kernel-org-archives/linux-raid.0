From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Deleting mdadm RAID arrays
Date: Fri, 08 Feb 2008 07:44:18 -0500
Message-ID: <47AC4EA2.4010805@tmr.com>
References: <200802051142.19625.admin@domeny.pl> <200802071056.33221.admin@domeny.pl> <47AB79B1.6000503@tmr.com> <200802081035.25722.admin@domeny.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200802081035.25722.admin@domeny.pl>
Sender: linux-raid-owner@vger.kernel.org
To: Marcin Krol <admin@domeny.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Marcin Krol wrote:
> Thursday 07 February 2008 22:35:45 Bill Davidsen napisa=C5=82(a):
>  =20
>>> As you may remember, I have configured udev to associate /dev/d_* d=
evices with
>>> serial numbers (to keep them from changing depending on boot module=
 loading=20
>>> sequence).=20
>>>      =20
>
>  =20
>> Why do you care?=20
>>    =20
>
> Because /dev/sd* devices get swapped randomly depending on boot modul=
e insertion
> sequence, as I explained earlier.
>
>  =20
So there's no functional problem, just cosmetic?
>> If you are using UUID for all the arrays and mounts =20
>> does this buy you anything?=20
>>    =20
>
> This is exactly what is not clear for me: what is it that identifies =
drive/partition as part of=20
> the array? /dev/sd name? UUID as part of superblock? /dev/d_n?
>
> If it's UUID I should be safe regardless of /dev/sd* designation? Yes=
 or no?
>
>  =20
Yes, absolutely.
>> And more to the point, the first time a =20
>> drive fails and you replace it, will it cause you a problem? Require=
=20
>> maintaining the serial to name data manually?
>>    =20
>
> That's not the problem. I just want my array to be intact.
>
>  =20
>> I miss the benefit of forcing this instead of just building the=20
>> information at boot time and dropping it in a file.
>>    =20
>
> I would prefer that, too - if it worked. I was getting both arrays me=
ssed=20
> up randomly on boot. "messed up" in the sense of arrays being compose=
d
> of different /dev/sd devices.
>
>  =20
Different devices? Or just different names for the same devices? I=20
assume just the names change, and I still don't see why you care...=20
subtle beyond my understanding.
>  =20
>>> And I made *damn* sure I zeroed all the superblocks before reassemb=
ling=20
>>> the arrays. Yet it still shows the old partitions on those arrays!
>>>  =20
>>>      =20
>> As I noted before, you said you had these on whole devices before, d=
id=20
>> you zero the superblocks on the whole devices or the partitions? Fro=
m=20
>> what I read, it was the partitions.
>>    =20
>
> I tried it both ways actually (rebuilt arrays a few times, just udev =
didn't want
> to associate WD-serialnumber-part1 as /dev/d_1p1 as it was told, it s=
till claimed
> it was /dev/d_1).=20
>  =20

I'm not talking about building the array, but zeroing the superblocks.=20
Did you use the partition name, /dev/sdb1, when you ran mdadm with=20
"zero-super" or did you zero the whole device, /dev/sdb, which is what=20
you were using when you first built the array with whole devices. If yo=
u=20
didn't zero the superblock for the whole device it may explain why a=20
superblock is still found.

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
