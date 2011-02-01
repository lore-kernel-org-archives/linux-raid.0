From: David Brown <david@westcontrol.com>
Subject: Re: What's the typical RAID10 setup?
Date: Tue, 01 Feb 2011 15:48:28 +0100
Message-ID: <ii96gl$vrl$1@dough.gmane.org>
References: <AANLkTikvXk0gyXz6MBvhyzxXatk0FVeASPr8R8+74c_i@mail.gmail.com>	<AANLkTinGSNmp6yUNfb9thnr3zKFTzw=fUFm+Gef3DAHw@mail.gmail.com>	<AANLkTim_uQ7AQs_ZSyeYPJPYSLCJd6ChzzTBwBNk2qA9@mail.gmail.com>	<20110131192858.GD27952@www2.open-std.org>	<4D4718E1.9040607@hardwarefreak.com>	<20110131203725.GB2283@www2.open-std.org>	<AANLkTimxCkxkg6xuz8FgFf0=u4KY=0M=6+afnxLzT+Tu@mail.gmail.com>	<AANLkTi=+rPzaNTKAjB=QUEGsbUcwfN8uijm96DoY_4FA@mail.gmail.com>	<AANLkTinM6FkJtxL8dNpoy-haGqNsZVfLDwmvZcshTEYQ@mail.gmail.com>	<AANLkTi=kUGc8bjisn69BEEkZr6kcHUyfKnVZzNtgaJf3@mail.gmail.com>	<20110131225235.GA11775@www2.open-std.org>	<ii8lcv$3jg$1@dough.gmane.org> <AANLkTin1MPYZGMuL75c=_q+ndeiz0F5+eCRudpDdTwu9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTin1MPYZGMuL75c=_q+ndeiz0F5+eCRudpDdTwu9@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/02/2011 14:50, Jon Nelson wrote:
> On Tue, Feb 1, 2011 at 4:01 AM, David Brown<david@westcontrol.com>  w=
rote:
>> On 31/01/2011 23:52, Keld J=C3=B8rn Simonsen wrote:
>>>
>>> raid1+0 and Linux MD raid10 are similar, but significantly differen=
t
>>> in a number of ways. Linux MD raid10 can run on only 2 drives.
>>> Linux raid10,f2 has almost RAID0 striping performance in sequential=
 read.
>>> You can have an odd number of drives in raid10.
>>> And you can have as many copies as you like in raid10,
>>>
>>
>> You can make raid10,f2 functionality from raid1+0 by using partition=
s. For
>> example, to get a raid10,f2 equivalent on two drives, partition them=
 into
>> equal halves.  Then make md0 a raid1 mirror of sda1 and sdb2, and md=
1 a
>> raid1 mirror of sdb1 and sda2.  Finally, make md2 a raid0 stripe set=
 of md0
>> and md1.
>>
>> If you have three disks, you can do that too:
>>
>> md0 =3D raid1(sda1, sdb2)
>> md1 =3D raid1(sdb1, sdc2)
>> md2 =3D raid1(sdc1, sda2)
>> md3 =3D raid0(md0, md1, md2)
>>
>> As far as I can figure out, the performance should be pretty much th=
e same
>> (although wrapping everything in a single raid10,f2 is more convenie=
nt).
>
> The performance will not be the same because. Whenever possible, md
> reads from the outermost portion of the disk -- theoretically the
> fastest portion of the disk (by 2 or 3 times as much as the inner
> tracks) -- and in this way raid10,f2 can actually be faster than
> raid0.
>

This would presumably apply to all raid1 arrangements, not just raid10 =
-=20
when md has a choice to read from more than one place it will prefer th=
e=20
outermost place.  In the arrangement I described above, the raid pairs=20
such as md0 each have one have on an inner partition, and one half on a=
n=20
outer partition.  /If/ md is smart enough, then it will do the same her=
e=20
and read from the outer partition by preference.

The question is, does md determine the "outermost" copy by track number=
=20
relative to the partition, or by absolute track number on the disk?  If=
=20
it is the former, then I see your point - with my raid 1 + 0 arrangemen=
t=20
the innermost and outermost partitions will be viewed the same.  If it=20
is the later, then my arrangement will work equally well.

On a related note, if you mix an SSD and a HD (partition) in a mirror,=20
will md prefer to read from the SSD first?  I know it is possible to us=
e=20
the "write-mostly" flag to force all reads to come from the SSD=20
(assuming it hasn't failed), but it would be nice to get parallel reads=
=20
from the HD as well whenever the read is large enough or when there are=
=20
multiple reads in parallel.


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
