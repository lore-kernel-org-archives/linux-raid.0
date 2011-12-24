From: Philip Hands <phil@hands.com>
Subject: Re: RAID1 seems not to be able to scrub pending sectors shown by smart
Date: Sat, 24 Dec 2011 10:07:48 +0000
Message-ID: <8762h62sgb.fsf@poker.hands.com>
References: <87hb0r2kvq.fsf@poker.hands.com> <CAAMCDedN7nBrt7nLoUq2v26ZoX21ab+htowc3r2A=nOAvfF42A@mail.gmail.com> <878vm32dan.fsf@poker.hands.com> <4EF5001F.8050409@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EF5001F.8050409@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roger Heflin <rogerheflin@gmail.com>
Cc: 'LinuxRaid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Fri, 23 Dec 2011 16:26:39 -0600, Roger Heflin <rogerheflin@gmail.com> wr=
ote:
> On 12/23/2011 03:22 PM, Philip Hands wrote:
> > On Fri, 23 Dec 2011 13:59:21 -0600, Roger Heflin<rogerheflin@gmail.com>=
  wrote:
> >> On Fri, Dec 23, 2011 at 12:39 PM, Philip Hands<phil@hands.com>  wrote:
> > ...
> >> I had 4 1.5tb seagate drives from 2009 (bought at different times in
> >> 2009) and 3 of those 4 started getting lots of bad sector all within a
> >> 2 month period and all 3 finally officially failed smart.and when the
> >> sectors (one after another...lucky they failed out aover 2-3 weeks so
> >> I had got the replacements in before I lost data-I was down to no
> >> redundancy for several days in the middle) were failing and being
> >> rewritten the performance was just ugly--so even if raid1 was
> >> rewriting the drives it does not do anything for performance when the
> >> drives are going bad...the only thing that solved my performance was
> >> getting all of the failing devices to finally fail smart so they could
> >> be RMAed and replaced at minimal cost..
> >
> > Well, I suppose that's to some extent the reason I mentioned this.
> >
> > It seems to me that if a disk is throwing _loads_ of read errors, and
> > running dreadfully slowly, one could react to that by favouring
> > different disk(s), and only occasionally throwing a read at the duff
> > disk, until it either sorts itself out or dies.
> >
> > My performance went from rubbish to fine simply by removing the
> > 360-pending-sector disk from the RAID.  OK, so if the problem is that
> > writes are being delayed by the dodgy disk, that's not easy to deal
> > with, but looking at the logs makes it look like the reads quite often
> > keep targeting the same disk even when several reads just failed and
> > got redirected.  This seems suboptimal to me.
> >
> > Cheers, Phil.
>=20
> In mine I am pretty sure the reads being delayed was causing issues.

Last night I started a check of the RAID that contained most of the errors =
on
that disk, and it's pretty much finished (81%), in which time the Pending
sector count is back up to 53. [Erm, 83% and 54 now -- while writing
this mail]

Clearly it's not a particularly happy drive, so I guess that smart will
eventually diagnose it as faulty, but in the mean time it may be a
useful test case for mdadm.

One of those newly pending sectors was found almost immediately, as I
was able to see from the logs, and while that was being dealt with, it
drove the system load up to about 18, and rendered the system
unresponsive for at least 10 seconds, probably more like 20 or 30 (the
normal load once it had chance to settle down again was about 2, on a 6
core CPU, so it wasn't really that busy).

[84% and 55 pending now -- with the first indication being a spike in
load, followed a minute or two later by mention of the read problems in
the logs, but apparently nothing logged by md, so presumably the read
eventually succeeded]

> I wonder if a patch might be possible that allows one to put an array=20
> into a mode (or go into said mode once a badblock condition has=20
> happened) that causes it to read from at least 2 possible data sources=20
> and return whichever gets there first...

Well, given that something appears to be blocking in a fairly
disastrous way on the read that's not coming back, I was wondering if
there might be some way of having a timeout on those reads that if one
gets no response for long enough (say 10 seconds) reacts by getting the
data from elsewhere, and overwriting the slow sector.

What I find rather interesting is that the sector that I witnessed
failing to read seems to have resulted in the Pending Sector count
increasing without the md code realising that it had a failed sector
that it needed to rewrite, so I'm guessing that the drive spent 30
seconds or so desperately trying to get a read to work, which eventually
happened, thus providing the md code with a successful read, while the
drive knows that that sector is pretty damaged, and marks it as pending.

Just a theory -- feel free to tell me how to test it (while I still have
a reliably broken disk in service).

Given that the disk now has 53 Pending sectors, it would be nice to know
a way of convincing md to rewrite those sectors.  Running checks seems
not to do the trick, because, as said, it will quite often manage to get
the data off the drive, so there's no reason to fix anything, and
meanwhile every time it hits one of these sectors system performance is
severely degraded.

So far, the only ways I've worked out of rewriting the blocks are:

  1) fail the partition out of the RAID, remove it, zero it's superblock
     to prevent a quick re-add, and then add it back in again.

  2) use hdparm --read-sector to find the faulty sector, use dd skip=3D
     to find the same sector in the partition, find the matching sector
     in one of it's mirror pairs, and then use dd skip=3Dx | dd seek=3Dx to
     overwrite the block (hoping that the system isn't touching that
     sector at the time) --- I'm not very happy with this option.

It would be nice to be able to say:  read block X from that md device,
and write it back to all the devices on which it resides, in a safe
manner.

What would be even better would be a way of saying:  Sector X on Disk Y
is duff, please work out which md device that is part of, and rewrite it
From=20other sources -- but that's probably asking a bit too much.

Cheers, Phil.
=2D-=20
|)|  Philip Hands [+44 (0)20 8530 9560]    http://www.hands.com/
|-|  HANDS.COM Ltd.                    http://www.uk.debian.org/
|(|  10 Onslow Gardens, South Woodford, London  E18 1NE  ENGLAND

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBCgAGBQJO9aR1AAoJENBLo6ABJdXA2NEQAIrOgf863jqk/xOAssIF5Q2F
iEXvlMLNdlhulAErw5hhPtrfiBwHIEnVI1uLo7Dih0Cd33g9SozMJ2wGjuhFTVZC
ovdTLhquTdJvQB9AtNQLR9U4VhYeFN8dns3RtBMFZGzO4MH5iujMyjJgUd1To3zZ
Ws0vo9nWx7fqFoB/hGuBzx5tisDbhamp24IbUqnJvlmLeLVzKTl27m/tCx14zidQ
oaekM47USAjYcXfQkwg+nxwkQwXhBSHqson0FPbYPL5UsbUYuml9/RMuyJgO3l+Q
CofgOGEhpxEvuEgbyVQ8WHMh/6XlrICzVgrOHzLeTeO1/gk1PtXAepF1dLPZbT5O
V1UHU7LltKy/f/pGe8vtF5iotnk7f/DdDwg+pXSdDHDr3UWyfc96oUc2700VgsGk
/8fuG5cGBeKrkQw66NCUU2mZ9XP504Uh/AjUFTOzZUSC1pu+2WTnfqSXOUCAVelr
Zp76/E1rwTbGOYz3FzRYPwk+zmvFiMO+b4BeQcY7/GbNu0g2Mnw+OPLZ5smIIyU0
Qtt1DMHVlihGdPRtBAQ9+tyTqNl/mnQ0v3KjHbrwaZDiEQhhFVvrxlQkUi2dblGA
m2BYrRfhDn6yjIwS/g8cBofAWP1QtevFDA8NEDUbsxvR61eIPWyncznEi4mOn/5k
YCSmCUHDaEd/Ucwdp+Yc
=r837
-----END PGP SIGNATURE-----
--=-=-=--
