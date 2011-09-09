From: =?UTF-8?Q?Micha=C5=82?= Sawicz <michal@sawicz.net>
Subject: Re: Best strategy to incrementally replace smaller HDDs
Date: Fri, 09 Sep 2011 16:20:20 +0200
Message-ID: <1315578025.14468.18.camel@michal-laptop>
References: <1315565285.2291.25.camel@michal-laptop>
	 <20110909131351.GA25347@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-mH7/mfCPlN9BsdfrxIC7"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110909131351.GA25347@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Hill <robin@robinhill.me.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-mH7/mfCPlN9BsdfrxIC7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dnia 2011-09-09, pi=C4=85 o godzinie 14:13 +0100, Robin Hill pisze:
> On Fri Sep 09, 2011 at 12:48:01PM +0200, Micha=C5=82 Sawicz wrote:
>=20
> > Hi all, given the configuration below:
> >       * 8 x 1TB HDDs
> >       * 2 x 2TB HDDs
> >=20
> From what you cover below, it sounds like you're limited to 10 drives in
> total. Is this the case?
In the long run - yes, but I can have more temporarily. It's just a
physical issue, not controller issue.

> > On which I currently have:
> >       * (10 x 1TB) RAID6 - persistent storage
> >       * (2 x 1TB) system / temporary storage etc.
> >=20
> > I want to replace the 1TB drives for 2TB ones on an as-needed basis,
> > what strategy would you recommend?
> >=20
> >      1. If I moved to 2TB RAID6 members (using RAID0 on the 1TB drives)=
,
> >         I would need to replace two of the drives just to match current
> >         capacity. Each next 2TB drive would get me 1TB additional
> >         capacity (but actually I'd need to replace two to gain
> >         anything). That sounds to be most future-proof, but most
> >         expensive.
> >      2. If I moved to 2TB RAID5 members, that would reduce redundancy
> >         but replacing just two would gain me 2TB capacity. Most of the
> >         above still applies.
>=20
> So, for both of these, you're planning on changing to:
>     * (2 x 1TB) system
>     * (2 x 2TB) + (3 x 1+1TB) persistent storage
Actually no, currently I'm planning to go:
      * (2 x 1TB) system,
      * (4 x 2TB) + (2 x 1+1TB)

So that's 8TB in RAID6, 10TB in RAID5. I already have 8TB and the only
way is up. With RAID6 I'd have to replace at least 4x1TB for 3x2TB
initially (one less drive total).

> This gives you 6TB persistent storage in RAID6, or 8TB in RAID5. As you
> say, replacing 2 1TB drives for 2TB drives (or adding a 2TB drive, if
> possible) would give you 8TB in RAID6 again.
>=20
> You'll also need to do a backup, rebuild & restore for either of these
> solutions.
As I mentioned in my previous reply to David, I'm planning to
shrink/grow as needed.

> In either case, replacing a single drive (assuming you're limited in
> total drive count) would not gain any capacity, whereas a pair of drive
> replacements would give you a 2TB increase.
>=20
> I'd steer clear of RAID5 with 2TB drives - rebuilding a 2TB drive will
> present a very large window for total array failure.
Yeah, that's why I switched to RAID6 in the first place...

> >      3. If I kept to 1TB RAID6 (two on the 2TB drives), I would reduce
> >         the redundancy to just one drive if it was the 2TB drive that
> >         failed, but each new drive would gain me 1TB capacity and I onl=
y
> >         need to replace one-by-one. This sounds like the cheapest, but
> >         worst possible approach.
> >=20
> Losing a single 2TB drive would lose 2 partitions, wiping out all
> redundancy. You're only needing to rebuild 1TB before you're back to
> partial redundancy though, so you're less prone to read failures than
> with RAID5 above. A second 2TB drive failure during recovery of either
> partition will cause total array failure though.
>=20
> Replacing a single 1TB drive would gain you 1TB in space.
>=20
> There's also no need to do a complete wipe & restore - you can just
> replace the drive and recover onto the new one.
>=20
> Performance will be worse (particularly during recovery) as you're
> always seeking between the two partitions.
>=20
> Personally, I'd go with RAID6 on 2TB partitions. It is more expensive,
> but I think the performance and redundancy benefits outweigh the costs.
That's the direction I'm leaning to as well.

Thanks a lot for the comments!
--=20
Micha=C5=82 (Saviq) Sawicz <michal@sawicz.net>

--=-mH7/mfCPlN9BsdfrxIC7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOaiCkAAoJEGnv7NPGHSZFNOAQAK0ON40k6dADMoYxdAnXuW8v
aAqYuZAi1+nGdHTWdIO38/VOUkcGViVGVKyGehPBZvg5g+8jYI2Q5++ETcRfid/7
lEVrSNno3AxeBTqPtv8u+tfhuPBOZ+Y4NVD8+Z5pW2RhVKZw25PSul+EpsczC/Y4
KCmCKQK7CiGhH1KF8OHa8h+rYwTVZuyH/IR6pnq4R6kyf6Nj50ez2OXdXwfdekL/
6hCUSeSMNpB1z/yF5gUOzAiLzmiAg5UDG8Zf5xbzmKLBPsS5GBRl6hv/VOszpOaI
RjLlsN9qOLUGhG1UBwF/clUkkULixegJKbBKD3He4j/LzD0+ThqFcZZQpBOaiPUj
nXG3fRTm+ldIQvFCAgLUNl0kplZZK4j499sD/8O6uNZhMoafBcxB6Z5LWluPgu+3
gBNIPMYxOc834h00rRdOh39/DVfcOtqSPPXE+FQE0vpbCXT5nI4EWSATZQDWN+65
WPGNEn23ilAKb7mQh30XvEfHd9VGOt0843UmeOcKdiaiUgH4qxn81vZD4y8F1pft
MrjGa+6qWYqn+52kGCCwvx8KpaQpjwFsGKoF9zkOidrwtzwpcVuPY316tpUysRME
MSt24nccxoCxX2XqKd2kT1W3wiG1lXmXjRcqJUdiXPA+M2vZnwkByMZKAXrbvugF
rq6rOqy0drycVL+Jsi+z
=+mGN
-----END PGP SIGNATURE-----

--=-mH7/mfCPlN9BsdfrxIC7--

