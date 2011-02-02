From: hansbkk@gmail.com
Subject: Re: RAID 5 - One drive dropped while replacing another
Date: Thu, 3 Feb 2011 00:51:00 +0700
Message-ID: <AANLkTinjP3Gw-C+Ee_1YC-+Zo-5UZ53U9EJHDYqr3mbZ@mail.gmail.com>
References: <AANLkTi=XzwtUGYH_wz44LHTYpyQRqnSCk4MxWZiQqZ8Z@mail.gmail.com>
	<50.11.05134.7A3994D4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50.11.05134.7A3994D4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for your considered response Leslie

On Thu, Feb 3, 2011 at 12:25 AM, Leslie Rhorer <lrhorer@satx.rr.com> wr=
ote:
>> So keeping the drive size fixed at 2TB for the sake of argument, do
>> people agree with the following as a conservative rule of thumb?
>> Obviously adjustable depending on financial resources available and
>> the importance of keeping the data online, given the fact that
>> restoring this much data from backups would take a loooong time. Thi=
s
>> example is for a money-poor environment that could live with a day o=
r
>> two of downtime if necessary.
>>
>> less than 6 drives =3D> RAID5
>> 6-8 drives =3D=3D> RAID6
>> 9-12 drives =3D=3D> RAID6+spare
>> over 12 drives, start spanning multiple arrays (I use LVM in any cas=
e)
>
> =A0 =A0 =A0 =A0That's pretty conservative, yes, for middle of the roa=
d
> availability. =A0For a system whose necessary availability is not too=
 high, it
> is considerable overkill. =A0For a system whose availability is criti=
cal, it's
> not conservative enough.

So maybe for my "money-poor environment that could live with a day or
two of downtime" I'll add a drive or two as my own personal rule of
thumb. Thanks for the feedback.

> =A0 =A0 =A0 =A0That assumes the RAID1 array elements only have 2 memb=
ers. =A0With 3
> members, the reliability goes way up. =A0Of course, so does the cost.

Prohibitively so for my situation, at least for the large storage
volumes. My OS boot partitions are replicated on every drive, so some
of them have 20+ members, but at 10GB per 2TB, not expensive  8-)

>> depending on luck, whereas RAID6 would allow **any** two (and
>> RAID6+spare any *three*) drives to fail without my losing data. So I
>
> =A0 =A0 =A0 =A0That's specious. =A0RAID6 + spare only allows two over=
lapping failures.

Well yes, but my environment doesn't have pager notification to a
"hot-spare sysadmin" standing by ready to jump in. In fact the
replacement hardware would need to be requested/purchase-ordered etc,
so in that case the spare does make a difference to resilience doesn't
it. If I had the replacement drive handy I'd just make it a hot spare
rather than keeping it on the shelf anyway.

>> On my lower-end systems, a RAID6 over 2TB drives takes about 10-11
>> hours per failed disk to rebuild, and that's using embedded bitmaps
>> and with nothing else going on.
>
> =A0 =A0 =A0 =A0I've never had one rebuild from a bare drive that fast=
=2E

This wasn't a bare drive, but a re-add after I'd been doing some grub2
and maintenance work on another array from SystemRescueCD, not sure
why the member failed. It's not a particularly fast platform, consumer
SATA2 Hitachi drives attached to mobo Intel controller, ICH7 I
believe. cat /proc/mdstat was showing around 60k, while the RAID1s
rebuild at around double that.

Would the fact that it was at less than 30% capacity make a difference?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
