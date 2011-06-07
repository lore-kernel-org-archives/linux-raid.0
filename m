From: Durval Menezes <durval.menezes@gmail.com>
Subject: Re: Maximizing failed disk replacement on a RAID5 array
Date: Tue, 7 Jun 2011 02:03:17 -0300
Message-ID: <BANLkTi=+2GFWRFKT0SCXRtkdn71msgDY=g@mail.gmail.com>
References: <BANLkTimBYFhjQ-sC9DhTMO+PG-Ox+A9S2Q@mail.gmail.com>
	<BANLkTimOxCF7diZfeFgtqCBWKZVF2pxyLg@mail.gmail.com>
	<BANLkTi=px08AWxfJJq+zNepCZM8aAsKECA@mail.gmail.com>
	<4DECF025.9040006@fnarfbargle.com>
	<BANLkTi=jPiXLySacVZqDkeThdG80K_HTxQ@mail.gmail.com>
	<4DECF841.1060906@fnarfbargle.com>
	<BANLkTikPxQvyDD3d_A6d3+GLKOLgqFJbFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTikPxQvyDD3d_A6d3+GLKOLgqFJbFw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Brad Campbell <brad@fnarfbargle.com>, Drew <drew.kay@gmail.com>
List-Id: linux-raid.ids

Hello Folks,

Just finished the "repair". It completed OK, and over SMART the HD now
shows a "Reallocated_Sector_Ct" of 291 (which shows that many bad
sectors have been remapped), but it's also still reporting 4
"Current_Pending_Sector" and 4 "Offline_Uncorrectable"... which I
think means exactly the same thing, ie, that there are 4 "active"
(from the HD perspective) sectors on the drive still detected as bad
and not remapped.

I've been thinking about exactly what that means, and I think that
these 4 sectors are either A) outside the RAID partition (not very
probable as this partition occupies more than 99.99% of the disk,
leaving just a small, less than 105MB area at the beginning), or B)
some kind of metadata or unused space that hasn't been read and
rewritten by the "repair" I've just completed. I've just done a "dd
bs=3D1024k count=3D105 </dev/DISK >/dev/null" to account for the
hyphotesys A), and come out empty: no errors, and the drive still
shows 4 bad, unmapped sectors on SMART.

So, by elimination, it must be either case B) above, or a bug in the
linux md code (which prevents it from hitting every needed block on
the disk), or a bug in SMART (which makes it report inexistent bad
sectors). I've just started running a "smart long test" on the disk
(which will try to read all of its sectors, reporting the first error
by LBA) and see what happens. If it shows no errors, I will know it's
a SMART bug. If it shows errors, it must be in a unused/metadata block
or a bug in linux md.

Either way, my plan is then to try a  plain "dd" (no "dd_repair", at
least not now) of this failing disk to a new one; if it goes by
without any errors, I will know it's a bug in SMART. if it hits any
errors, I will have the first errors position (from "dd" point of
view) and then I will try and dump that specific sector with dd_repair
and examine it.

I will keep you posted.

Cheers,
--=20
   Durval Menezes.


On Mon, Jun 6, 2011 at 3:06 PM, Durval Menezes <durval.menezes@gmail.co=
m> wrote:
> Hello Brad, Drew,
>
> Thanks for reminding me of the hammering a RAID level conversion woul=
d=A0 cause.
> This is certainly a major=A0 reason to avoid the RAID5->RAID6->RAID5 =
route.
>
> The "repair" has been running here for a few days already, with the
> server online, and ought to finish in 24 more hours. So far (thanks t=
o
> the automatic rewrite relocation) the number of=A0 uncorrectable sect=
ors
> being reported by SMART has dropped from 40 to 20 , so it seems the
> repair is=A0 doing its job. Lets just hope the disk has enough=A0 spa=
re
> sectors=A0 to remap all the bad sectors; if it does, a simple "dd "fr=
om
> the bad disk to=A0 its replacement ought to=A0 do the job=A0 (as you =
have
> indicated).
>
> On the other hand, as this "dd" has to be done with the array offline=
,
> it will entail in some downtime (although not as much as having to
> restore the whole array from backups).... not ideal, but not too bad
> either.
>
> In case worst comes to worst, I have an up-to-date offline backup of
> the contents of the whole array, so if something really bad happens, =
I
> have something to restore from.
>
> It would be great to have a
> "duplicate-this-bad-old-disk-into-this-shiny-new-disk"=A0 functionali=
ty,
> as it would enable=A0 an almost-no-downtime disk replacement with
> minimum=A0 risk, but it seems we can't have everything... :-0 Maybe i=
t's
> something for the wishlist?
>
> About mishaps with "dd", I think everyone=A0 who ever dealt with a
> system=A0 (not just Linux)=A0 on the level we do has sometime gone th=
rough
> something similar... the last time I remember doing this was many
> years ago, before=A0 Linux existed, when me and a few friends spent a
> wonderful night installing=A0 William Jolitz ' then-new 386/BSD=A0 on=
 a HD
> =A0(a process which *required*=A0 dd)=A0 and trashing its Windows par=
titions
> (which contained the only copy of the graduation thesis of one of us,
> due in a few days).
>
> Thanks for all the help,
> --
> =A0=A0 Durval Menezes.
>
> On Mon, Jun 6, 2011 at 12:54 PM, Brad Campbell <brad@fnarfbargle.com>=
 wrote:
>>
>> On 06/06/11 23:37, Drew wrote:
>>>>
>>>> Now, if I'm off the wall and missing something blindingly obvious =
feel free
>>>> to thump me with a clue bat (it would not be the first time).
>>>>
>>>> I've lost 2 arrays recently. 8TB to a dodgy controller (thanks SIL=
), and 2TB
>>>> to complete idiocy on my part, so I know the sting of lost or corr=
upted
>>>> data.
>>>
>>> I think you've covered the process in more detail, including pitfal=
ls,
>>> then I have. :-) Only catch is where would you find a cheap 2-3TB
>>> drive right now?
>>
>> I bought 10 recently for about $90 each. It's all relative, but I co=
nsider ~$45 / TB cheap.
>>
>>> I also know the sting of mixing stupidity and dd. ;-) A friend was
>>> helping me do some complex rework with dd on one of my disks. Being
>>> the n00b I followed his instructions exactly, and him being the exp=
ert
>>> (and assuming I wasn't the n00b I was back then) didn't double chec=
k
>>> my work. Net result was I backed the MBR/Partition Table up using d=
d,
>>> but did so to a partition on the drive we were working on. There ma=
y
>>> have been some alcohol involved (I was in University), the revised
>>> data we inserted failed, and next thing you know I'm running Partit=
ion
>>> Magic (the gnu tools circa 2005 failed to detect anything) to try a=
nd
>>> recover the partition table. No backups obviously. ;-)
>>
>> Similar to my
>>
>> dd if=3D/dev/zero of=3D/dev/sdb bs=3D1M count=3D100
>>
>> except instead of the target disk, it was to a raid array member tha=
t was currently active. To its credit, ext3 and fsck managed to give me=
 most of my data back, even if I had to spend months intermittently sor=
ting/renaming inode numbers from lost+found into files and directories.
>>
>> I'd like to claim Alcohol as a mitigating factor (hell, it gets peop=
le off charges in our court system all the time) but unfortunately I wa=
s just stupid.
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
