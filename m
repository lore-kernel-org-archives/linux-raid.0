From: Andy Smith <andy@lug.org.uk>
Subject: Re: RAID 5 of RAID 5's?
Date: Sun, 12 Jun 2005 00:45:23 +0000
Message-ID: <20050612004523.GJ750@strugglers.net>
References: <1118187572.15459.96.camel@seki.nac.uci.edu> <42A93D30.6080900@apartia.fr> <1118436219.25226.252.camel@seki.nac.uci.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eci7kgoNre1oTc2t"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1118436219.25226.252.camel@seki.nac.uci.edu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--eci7kgoNre1oTc2t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 10, 2005 at 01:43:39PM -0700, Dan Stromberg wrote:
> Consider:
>=20
> You have a bunch of "bricks" that can shuffle data between a NAS head
> and a bunch of disks.
>=20
> The disks are RAID'd (through the "bricks"), but if one of the bricks
> themselves dies, you're kinda stuck.
>=20
> But if you RAID 5 the RAID 5's, then you don't end up with massive
> parity pounding, and your bricks aren't a single point of failure, and
> you don't lose as much space as if you mirrored.

Off the top of my head, this is what I am thinking, but I could well
have missed something...

Assume you have 50 disks.

If you organise them as 25 two disk RAID 1s and then RAID 0 the RAID
1s you end up with the capacity of 25 disks.  Any given read will
benefit from a 25-way stripe; any given write suffers a 2-way
mirror.

If a disk dies then it alone will be rebuilt from its single mirror
pair.  You can lose up to 25 disks and still not lose any data, as
long as no more than 1 disk from each pair survives.

If you organise them as 10 five disk RAID 5s and then RAID 5 the
RAID 5s you end up with the capacity of (5-1)*(10-1)=3D36 disks.
Depending on your RAID technology, reads may be as fast as a 10-way
stripe.  As far as I can see though, a write would have to be
striped to 10 RAID 5s, which would itself be striped to 5 disks
each, so it would be a 50-way write.

You could stand to lose a maximum of 1 disk in each of the low-level
RAID 5s, plus one of the top-level RAID 5s, so I suppose the maximum
you could get away with would be 10 (one from each low-level) plus
the other 4 from a single low-level, for a total of 14.  If you lose
a single disk then you'll need a parity rebuild from 4 disks.  If
you lost a low-level RAID 5 then I'm not sure how that would work;
it would be reading to rebuild from parity so presumably it would
take advantage of the stripe and be like only reading from 9 disks?

With 20 disks, the RAID 10 scenario ends up with 10 disks of
capacity, maximum 10 disks can fail, reads are as a 10-way stripe,
writes are as a 2-way mirror.  The RAID 55 scenario assuming 4-disk
low-level RAID 5s would be 15 disks of capacity, could theoretically
have 8 disks fail and still run degraded.  I think reads would be as
=66rom a 5-way stripe, with writes striped across 20 disks.

So, unless I have misunderstood, depending on how you split the RAID
5s you'll get about 75% of the disk as opposed to 50% for RAID 10,
but the write performance and the reliability seem much worse.

--eci7kgoNre1oTc2t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCq4WjIJm2TL8VSQsRArJ7AJwLIubWlxZ6jNwgzZZvfRa3+ekGmACg7aL3
AZb4ggO8zla6M34HpbnxrDc=
=Pg/k
-----END PGP SIGNATURE-----

--eci7kgoNre1oTc2t--
