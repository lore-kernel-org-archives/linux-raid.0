From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Which raid card to buy for Sarge
Date: Wed, 31 Mar 2004 16:39:41 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200403312139.i2VLdkW20296@dns1.watkins-home.com>
References: <200403312242.49462.ralph@debianbase.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200403312242.49462.ralph@debianbase.de>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have not seen a hardware RAID that is faster than md (software RAID).
I also have not used any hardware RAID within the last 3 years.
On my P3-500 SMP system, the CPU usage of MD is less than 5% during a
re-build.  Re-builds at about 5M/s on 14 disks.

So, when you say HW RAID is faster, I disagree. But, I admit some HW RA=
ID
may be faster than some software RAID.  Depends on the hardware!

Also, from what I have seen a HW RAID system is limited to the SCSI bus=
ses
on the RAID card.  You can't RAID drives on other cards/busses.  md can=
 use
any disk on any buss.  You can even mix SCSI, SATA and IDE with md.

Guy

-----Original Message-----
=46rom: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Ralph Pa=DFgang
Sent: Wednesday, March 31, 2004 3:43 PM
To: linux-raid@vger.kernel.org
Subject: Re: Which raid card to buy for Sarge

Am Mittwoch 31 M=E4rz 2004 21:50 schrieben Sie:
> > If would not use the "raid" feature of the Highpoint cards, because=
 it
is
> > only software raid and not so performant as a hardware raid. If you
don't
> > need a

Oh, my sentence should have started with: "I would not use ..." not wit=
h:=20
"If.." :)

> please don't say things like this.  HW raid is *NOT* generally
> faster or better than software raid.=20

I never said that it is "better" than software raid, because I don't th=
ink
so.=20
I am using mdadm myself and I think it is great software (together with=
 the=20
kernel code). But normaly a real hardware raid is without a doubt faste=
r
than=20
a software raid. But the most servers/computers don't really need hardw=
are=20
raid, because the don't produce this huge amount of data.

With the sentence you quoted from me, I only wanted to say, that I woul=
dn't=20
use the software of the highpoint card to build a software raid, becaus=
e
it's=20
closed software (if I remeber right) and it is only there to fake the
people,=20
because highpoint doesn't say clearly (on the product box for example) =
that=20
it is a "software" raid IDE100/133 Card (so it should be called: IDE Ad=
apter

with software raid tools). If you are not so familiar with this kind of
stuff=20
you maybe even think years later that this is a real hardware raid=20
(espacially under windows).

I would use the HPT Adapter only as normal ide adapter and build a soft=
ware=20
raid, or if I need the performace I would use a hardware raid, but only
then.=20
I don't have to much money, like the most peole, so I don't buy useless=
=20
stuff. (in my private I still use a pentium 60 as gateway with firewall=
, ntp

server, some other small thinks)

But you are right, only a few servers really need a hardware raid. The =
most=20
are idleing the most time :) But many customers (and I am working for a=
 isp)

wants a hardware raid (even if they haven't good a clou of such stuff a=
nd=20
doesn't really need this for their server). The words: "hardware raid" =
are=20
good for marketing... Its like ide and scsi drives :) And if a customer
wants=20
something it not always a good idea trying to convert him to another=20
solution.

> yes, if you're building a=20
> quad-gigabit fileserver out of an old P5/100 you had sitting around,
> you're not even going to start looking at sw raid.
>
> but for a normal FS config (dual opteron or xeon, >1GB ram,
> 2-400 MB/s sustained disk throughput), software raid is The Right Cho=
ice.

i never said that software raid is slow! I just said that hardware raid=
 is=20
faster... That's a difference :) I never would say that a amd athlon xp=
 is=20
slow, but without a doubt a amd athlon 64 is faster :)

> - speed: it's easy to do hundreds of MB/s with sw raid.  it's surpris=
ingly
> hard to break even 100 MB/s using sw raid.
>
> - you don't pay through the nose for a crappy embedded processor
> to do your parity calculations
>
> - hw raid *does* reduce the amount of PCI-X traffic you generate,
> but do you really care, at 1 GB/s?

it's not about me and if I care... I only tried to help Jay choosing th=
e
right=20
solution for his raid setup... I only said that I think the hpt adapter=
s are

fakes raid adapters, because it's software raid, and that if HE wants=20
hardware raid, he should take another adapter.

> - sw raid *does* consume some host CPU cycles, but do you care,
> given that this is a fileserver?
>
> - give me mdadm and normal userspace tools over some wheel-reinventin=
g
> hw raid configurator.
>
> - you've probably got the hardware to fix an exploded sw-raid server
> already in your office (other computers, normal disk controllers, etc=
).
> replacing that hw raid card WILL take more than 30 minutes, obviously=
 will
> take money, and will eventually become impossible.

I also said this... I had some broken disks in hardware raids and in
software=20
raids in the last 2 years. Both solutions have advantages and disadvant=
ages=20
again:

- Advantage: its faster to fix a broken sw raid setup. It's only a shut=
down,

change disk, restart, rebuild the array in the background. In the hardw=
are=20
raid you normaly have to rebuild the array in the bios and so the compu=
ter
is=20
offline for at least that time.

- Disadvanage: Sometime linux crashes if a hard disk in an array broke.=
 I=20
don't know for sure why this happens, but I guess it has something to d=
o
with=20
the ide channel which is marked as busy and never gets useable again. A
crash=20
after a disk broke down never happend to me on a hardware raid.

I know that this a kernel ml for the software raid in linux, but hey,  =
I
only=20
told jay what are advantages and disadvantaged in the hpt software raid=
, the

linux mdadm software raid and a a hardware raid is. I think there was
nothing=20
wrong about it and I even think that we have more or less the same opti=
nion=20
in sw/hw raids.

Once again: i am using mdadm myself and think that the linux software r=
aid
is=20
great, no question... I never wanted to say something else. So don't=20
understand this wrong, but _even_ hardware raid has the right to life .=
))

--Ralph
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
