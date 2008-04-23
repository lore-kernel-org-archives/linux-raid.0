From: "David Lethe" <david@santools.com>
Subject: RE: managing raid on Linux
Date: Wed, 23 Apr 2008 14:21:49 -0500
Message-ID: <A20315AE59B5C34585629E258D76A97C19652E@34093-C3-EVS3.exchange.rackspace.com>
References: <247041911@web.de> <480F4EF6.1000103@tmr.com> <480F5BE6.7070908@nrel.colostate.edu> <A20315AE59B5C34585629E258D76A97C1964CC@34093-C3-EVS3.exchange.rackspace.com> <20080423184722.GA4889@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <20080423184722.GA4889@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: =?iso-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: Ty! Boyack <ty@nrel.colostate.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----Original Message-----
=46rom: Keld J=F8rn Simonsen [mailto:keld@dkuug.dk]=20
Sent: Wednesday, April 23, 2008 1:47 PM
To: David Lethe
Cc: Ty! Boyack; linux-raid@vger.kernel.org
Subject: Re: managing raid on Linux

On Wed, Apr 23, 2008 at 01:17:19PM -0500, David Lethe wrote:
>=20
>    Well, this is the norm. While some APIs are well done, the other
> extreme is that vendor xyz farmed out the API/drivers to another
> company, and the hardware vendor doesn't have the resources, knowledg=
e
> or experience to provide the information necessary to bring a 3rd-par=
ty
> management tool to market.   I will certainly not reveal anything abo=
ut
> the companies that did farm out the software/firmware to 3rd parties,
> and will not tell you if their names were mentioned in this post.
> Suffice to say that this is a real problem with SOME controllers that
> people reading this post have installed in their computers.
>=20
>   - The economics of developing support for a particular controller i=
s a
> severe constraint.  Consider the reasons above, and then add simple
> equipment costs for development/testing, and then support.  I'm not
> going to add support for product xyz unless I know it will be
> profitable, and even a hundred end-user requests won't begin to pay f=
or
> such an effort.
>=20
>   - I for one certainly can't keep up with all the new things coming
> out, so we choose our battles wisely based on the market opportunity,
> longevity of the controller platform, safety/robustness of the API, a=
nd
> development/ongoing support expense.
>=20
> So there are the reasons why the OP can't find anything that supports
> everything he has.

David, thanks for your explanation of the current situation for making
an =FCbermanageri for HW RAID. The prospects seem dark indeed.=20

Are there then more future in doing it the SW RAID way, as the Linux
Kernel stuff we are discussion here on this mailing list?

Are there chances that this work om Linux RAID can match or be better
on the issues of performance, raid personality flavours and management,
compared to the best of the HW RAID manufacturers?=20

Best regards
keld
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Keld -=20

Well, I don't want to insult the outstanding work product that everybod=
y has put forth in LINUX, md/raid ... but from my perspective coming fr=
om the hardware RAID world, and software appliance perspective, then it=
 is a mixed bag.

Pure software RAID, as designed in the LINUX kernel is superior in term=
s of potential performance to many internal RAID controllers.  I break =
NDAs if I give specific reasons to explain this, but here is one reason=
 that is inherent to the differences in architectures.  =20

Consider that the fastest I/O is the one that doesn't have to be perfor=
med, and software-kernel-based RAID has the luxury of not having to per=
form an I/O if it knows the data exists somewhere in CPU cache, L1/L2 c=
ache, or even RAM.  Here I can "satisfy" an I/O in nanoseconds.
If I have to get an I/O from a card on a BUS, or external storage, then=
 it will take milliseconds, even if solid-state disk is attached.  Bus/=
protocol limitations for one, plus the speed of light is just too darne=
d slow.

But Hardware RAID has other things going for it in terms of snapshot, c=
ompression, and even performance depending on the I/O requirements.  Yo=
u can offload calculations and smooth and balance I/O easily in some co=
nfigs.=20

No architecture is "best" in all cases, even if price was taken out of =
the picture.

In terms of reliability, availability, and clustering capability, then =
LINUX need a major redesign in both architecture & design  philosophy. =
 Not trying to shove zfs down anybody's throat, but read up on the spec=
s and architecture and features and then decide for yourself.  There ar=
e GPL reasons why zfs isn't available today in the kernel, and philosop=
hical/legal/logistical (but non-technical) reasons holding software-bas=
ed RAID in LINUX back.

As for management, Sorry, the economics don't make it possible for LINU=
X to compete, except in point solutions  .. not when you have EMC, CA, =
HP, IBM, MSFT, and all the rest spending billions of dollars on program=
mers writing management software.=20

David @ SANtools ^ com



--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
