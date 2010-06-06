From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID Configuration For New Home Server
Date: Sun, 6 Jun 2010 15:35:19 -0500
Message-ID: <45.52.03181.D860C0C4@cdptpa-omtalb.mail.rr.com>
References: <AANLkTinmatSeQLUi23R4l7icicHYqdE8Ae6M4zSHjf7H@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinmatSeQLUi23R4l7icicHYqdE8Ae6M4zSHjf7H@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Mark Knecht' <markknecht@gmail.com>
Cc: 'Mdadm' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> -----Original Message-----
> From: Mark Knecht [mailto:markknecht@gmail.com]
> Sent: Sunday, June 06, 2010 9:51 AM
> To: Leslie Rhorer
> Cc: Mdadm
> Subject: Re: RAID Configuration For New Home Server
>=20
> On Sat, Jun 5, 2010 at 10:19 PM, Leslie Rhorer <lrhorer@satx.rr.com>
> wrote:
> >> >> problem. This method does require that I update the two backups=
 by
> >> >> hand once in awhile. That's OK by me.
> >> >
> >> > =A0 =A0 =A0 =A0Define, "once in awhile [sic]".
> >>
> >> Every 2-3 months I make sure each drive is up to date.
> >
> > =A0 =A0 =A0 =A0I was having to update one server or the other every=
 week or so,
> > sometimes more than once a week. =A0I could have written scripts to=
 do it,
> or
> > used rsync, I suppose, but I opted for RAID1.
> >
>=20
> I can see that. My point of view was (I think) more in line with the
> OP's title of this thread, being a home server. I have only 1 home
> server. I suspect he does also as it's his first time doing RAID, as
> it was for me.

	Mine are home servers.  I don't run Linux on any of my servers at
work.  To be sure, there is always a first time for everything and ever=
yone,
and the novice may indeed (quite rightly) choose a different approach t=
han a
more seasoned individual.  Many times a choice may be between easier /
simpler setup and more protracted maintenance.  Indeed, even though I w=
as
not new to *nix, when I first built my (personal) servers, I opted for =
a
non-RAID boot.  It's only over time - about 3 years - I grew tired of
updating the contents of my offline drives.  That, and I had several un=
used
old 500G PATA drives laying around, so I figured I would create RAID sy=
stems
for booting, rather than simple partitions.

	To be sure, I won't think any less of the OP should he decide to opt
for a non-RAID boot solution.  I just think it is good he has the full
perspective of all his options before he makes a choice.

> Ah, OK. Well again, as I don't use an initrd or even know what it is =
I
> have a lot of learning to do in that area. I've just never bothered.

	An initial RAM Disk boots the basic operating system very quickly
and compactly.  Embedded systems and live CDs, as well as most installa=
tion
CDs employ a RAM disk permanently.  Most hard drive based systems overw=
rite
the RAM disk with a partition on the hard drive.

> I've run Linux as a desktop system for about 13 or 14 years now. Mayb=
e
> some other distros used initrd by default but Gentoo, which I've run
> since about 2000 or so, doesn't require it. For desktop systems based
> on lowest common denominator PC hardware it's never seemed to provide
> any real advantage. Certainly it does for bigger servers where you
> guys buy fancy hard drive controllers and the like.

	The initrd sees its greatest advantage on resource-thin systems.
Since the image is compressed, it is small and loads very quickly even =
from
a slow drive.  Floppy based boots are really only practical using an in=
itrd.
They also have the advantage of not being directly editable, which redu=
ces
the goof factor, and since the image is read-only, limits the exposure =
to
boot failure after a dirty shut-down.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
