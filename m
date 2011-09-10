From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Bootable Raid-1
Date: Sat, 10 Sep 2011 12:56:00 -0500
Message-ID: <AB.31.01343.0B4AB6E4@cdptpa-omtalb.mail.rr.com>
References: <CAGqmV7qRQ-6-dpTt5pywugtchFF4NtA5sNvVhBCOirpGhdgWiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGqmV7qRQ-6-dpTt5pywugtchFF4NtA5sNvVhBCOirpGhdgWiQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'CoolCold' <coolthecold@gmail.com>
Cc: 'Roberto Spadim' <roberto@spadim.com.br>, hansbkk@gmail.com, naira@faccat.br, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



> -----Original Message-----
> From: CoolCold [mailto:coolthecold@gmail.com]
> Sent: Thursday, September 08, 2011 3:29 PM
> To: lrhorer@satx.rr.com
> Cc: Roberto Spadim; hansbkk@gmail.com; naira@faccat.br; linux-
> raid@vger.kernel.org
> Subject: Re: Bootable Raid-1
>=20
> On Wed, Feb 2, 2011 at 9:44 PM, Leslie Rhorer <lrhorer@satx.rr.com> w=
rote:
> <snip>
> >>
> >> grub2 work with raid1 boot partition and rootfs over mdadm raid1
> >> i tested today (03:00 AM) on my ubuntu desktop
> >
> > =A0 =A0 =A0 =A0There wasn't really any question about that. =A0I've=
 been running
> > RAID1 boots under GRUB2 for months. =A0Prior to that, it was RAID1 =
under
> GRUB
> > legacy. =A0RAID1 under GRUB legacy takes some finagling. =A0Under G=
RUB2 it
> > should be straightforward as long as the partitioning is correct an=
d one
> > employs a 0.90 superblock for the /boot array.
> >
> Guys, basing on your experience, can you tell us, how does Grub2 reac=
t
> on degraded raid? Does it respect md's point of view which disk is ba=
d
> and which is not? Does it cooperate well with mdadm in general?

	I can't say from experience.  Presumably it will.

> Grub legacy was way easy, just setup on disk & read that disk, no rai=
d
> knowledge, no problems. I guess grub2 can be configured in that manne=
r
> too, but as it has raid/lvm/whatever support, may be give it a try...
>=20
> I've got Debian Squeeze servers with grub2, without any mirroing, so
> converting them into RAID1 system, wanna make it right.

	That conversion shouldn't be difficult.  Going from legacy GRUB
RAID1 to GRUB2 RAID1 was a bit of a challenge.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
