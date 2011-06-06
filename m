From: Durval Menezes <durval.menezes@gmail.com>
Subject: Re: Maximizing failed disk replacement on a RAID5 array
Date: Mon, 6 Jun 2011 15:06:23 -0300
Message-ID: <BANLkTikPxQvyDD3d_A6d3+GLKOLgqFJbFw@mail.gmail.com>
References: <BANLkTimBYFhjQ-sC9DhTMO+PG-Ox+A9S2Q@mail.gmail.com>
	<BANLkTimOxCF7diZfeFgtqCBWKZVF2pxyLg@mail.gmail.com>
	<BANLkTi=px08AWxfJJq+zNepCZM8aAsKECA@mail.gmail.com>
	<4DECF025.9040006@fnarfbargle.com>
	<BANLkTi=jPiXLySacVZqDkeThdG80K_HTxQ@mail.gmail.com>
	<4DECF841.1060906@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DECF841.1060906@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Brad Campbell <brad@fnarfbargle.com>, Drew <drew.kay@gmail.com>
List-Id: linux-raid.ids

Hello Brad, Drew,

Thanks for reminding me of the hammering a RAID level conversion would=A0=
 cause.
This is certainly a major=A0 reason to avoid the RAID5->RAID6->RAID5 ro=
ute.

The "repair" has been running here for a few days already, with the
server online, and ought to finish in 24 more hours. So far (thanks to
the automatic rewrite relocation) the number of=A0 uncorrectable sector=
s
being reported by SMART has dropped from 40 to 20 , so it seems the
repair is=A0 doing its job. Lets just hope the disk has enough=A0 spare
sectors=A0 to remap all the bad sectors; if it does, a simple "dd "from
the bad disk to=A0 its replacement ought to=A0 do the job=A0 (as you ha=
ve
indicated).

On the other hand, as this "dd" has to be done with the array offline,
it will entail in some downtime (although not as much as having to
restore the whole array from backups).... not ideal, but not too bad
either.

In case worst comes to worst, I have an up-to-date offline backup of
the contents of the whole array, so if something really bad happens, I
have something to restore from.

It would be great to have a
"duplicate-this-bad-old-disk-into-this-shiny-new-disk"=A0 functionality=
,
as it would enable=A0 an almost-no-downtime disk replacement with
minimum=A0 risk, but it seems we can't have everything... :-0 Maybe it'=
s
something for the wishlist?

About mishaps with "dd", I think everyone=A0 who ever dealt with a
system=A0 (not just Linux)=A0 on the level we do has sometime gone thro=
ugh
something similar... the last time I remember doing this was many
years ago, before=A0 Linux existed, when me and a few friends spent a
wonderful night installing=A0 William Jolitz ' then-new 386/BSD=A0 on a=
 HD
 (a process which *required*=A0 dd)=A0 and trashing its Windows partiti=
ons
(which contained the only copy of the graduation thesis of one of us,
due in a few days).

Thanks for all the help,
--
=A0=A0 Durval Menezes.

On Mon, Jun 6, 2011 at 12:54 PM, Brad Campbell <brad@fnarfbargle.com> w=
rote:
>
> On 06/06/11 23:37, Drew wrote:
>>>
>>> Now, if I'm off the wall and missing something blindingly obvious f=
eel free
>>> to thump me with a clue bat (it would not be the first time).
>>>
>>> I've lost 2 arrays recently. 8TB to a dodgy controller (thanks SIL)=
, and 2TB
>>> to complete idiocy on my part, so I know the sting of lost or corru=
pted
>>> data.
>>
>> I think you've covered the process in more detail, including pitfall=
s,
>> then I have. :-) Only catch is where would you find a cheap 2-3TB
>> drive right now?
>
> I bought 10 recently for about $90 each. It's all relative, but I con=
sider ~$45 / TB cheap.
>
>> I also know the sting of mixing stupidity and dd. ;-) A friend was
>> helping me do some complex rework with dd on one of my disks. Being
>> the n00b I followed his instructions exactly, and him being the expe=
rt
>> (and assuming I wasn't the n00b I was back then) didn't double check
>> my work. Net result was I backed the MBR/Partition Table up using dd=
,
>> but did so to a partition on the drive we were working on. There may
>> have been some alcohol involved (I was in University), the revised
>> data we inserted failed, and next thing you know I'm running Partiti=
on
>> Magic (the gnu tools circa 2005 failed to detect anything) to try an=
d
>> recover the partition table. No backups obviously. ;-)
>
> Similar to my
>
> dd if=3D/dev/zero of=3D/dev/sdb bs=3D1M count=3D100
>
> except instead of the target disk, it was to a raid array member that=
 was currently active. To its credit, ext3 and fsck managed to give me =
most of my data back, even if I had to spend months intermittently sort=
ing/renaming inode numbers from lost+found into files and directories.
>
> I'd like to claim Alcohol as a mitigating factor (hell, it gets peopl=
e off charges in our court system all the time) but unfortunately I was=
 just stupid.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
