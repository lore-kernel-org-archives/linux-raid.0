From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Best strategy to incrementally replace smaller HDDs
Date: Fri, 9 Sep 2011 14:13:51 +0100
Message-ID: <20110909131351.GA25347@cthulhu.home.robinhill.me.uk>
References: <1315565285.2291.25.camel@michal-laptop>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1315565285.2291.25.camel@michal-laptop>
Sender: linux-raid-owner@vger.kernel.org
To: =?utf-8?Q?Micha=C5=82?= Sawicz <michal@sawicz.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri Sep 09, 2011 at 12:48:01PM +0200, Micha=C5=82 Sawicz wrote:

> Hi all, given the configuration below:
>       * 8 x 1TB HDDs
>       * 2 x 2TB HDDs
>=20
=46rom what you cover below, it sounds like you're limited to 10 drives in
total. Is this the case?

> On which I currently have:
>       * (10 x 1TB) RAID6 - persistent storage
>       * (2 x 1TB) system / temporary storage etc.
>=20
> I want to replace the 1TB drives for 2TB ones on an as-needed basis,
> what strategy would you recommend?
>=20
>      1. If I moved to 2TB RAID6 members (using RAID0 on the 1TB drives),
>         I would need to replace two of the drives just to match current
>         capacity. Each next 2TB drive would get me 1TB additional
>         capacity (but actually I'd need to replace two to gain
>         anything). That sounds to be most future-proof, but most
>         expensive.
>      2. If I moved to 2TB RAID5 members, that would reduce redundancy
>         but replacing just two would gain me 2TB capacity. Most of the
>         above still applies.

So, for both of these, you're planning on changing to:
    * (2 x 1TB) system
    * (2 x 2TB) + (3 x 1+1TB) persistent storage

This gives you 6TB persistent storage in RAID6, or 8TB in RAID5. As you
say, replacing 2 1TB drives for 2TB drives (or adding a 2TB drive, if
possible) would give you 8TB in RAID6 again.

You'll also need to do a backup, rebuild & restore for either of these
solutions.

In either case, replacing a single drive (assuming you're limited in
total drive count) would not gain any capacity, whereas a pair of drive
replacements would give you a 2TB increase.

I'd steer clear of RAID5 with 2TB drives - rebuilding a 2TB drive will
present a very large window for total array failure.

>      3. If I kept to 1TB RAID6 (two on the 2TB drives), I would reduce
>         the redundancy to just one drive if it was the 2TB drive that
>         failed, but each new drive would gain me 1TB capacity and I only
>         need to replace one-by-one. This sounds like the cheapest, but
>         worst possible approach.
>=20
Losing a single 2TB drive would lose 2 partitions, wiping out all
redundancy. You're only needing to rebuild 1TB before you're back to
partial redundancy though, so you're less prone to read failures than
with RAID5 above. A second 2TB drive failure during recovery of either
partition will cause total array failure though.

Replacing a single 1TB drive would gain you 1TB in space.

There's also no need to do a complete wipe & restore - you can just
replace the drive and recover onto the new one.

Performance will be worse (particularly during recovery) as you're
always seeking between the two partitions.

Personally, I'd go with RAID6 on 2TB partitions. It is more expensive,
but I think the performance and redundancy benefits outweigh the costs.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk5qEQ8ACgkQShxCyD40xBLN5wCcCP8wce9XCISDBqz9mcnQeS2q
NAwAoLVOD0tkQzK9RZoiX8jYNqNchK1u
=NuYa
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--
