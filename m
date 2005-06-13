From: Dan Stromberg <strombrg@dcs.nac.uci.edu>
Subject: Re: RAID 5 of RAID 5's?
Date: Mon, 13 Jun 2005 10:55:44 -0700
Message-ID: <1118685345.25437.12.camel@seki.nac.uci.edu>
References: <1118187572.15459.96.camel@seki.nac.uci.edu>
	 <42A93D30.6080900@apartia.fr> <1118436219.25226.252.camel@seki.nac.uci.edu>
	 <20050612004523.GJ750@strugglers.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-88HvNUE8kovGPIp9Xn4X"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050612004523.GJ750@strugglers.net>
Sender: linux-raid-owner@vger.kernel.org
To: Andy Smith <andy@lug.org.uk>
Cc: strombrg@dcs.nac.uci.edu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-88HvNUE8kovGPIp9Xn4X
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2005-06-12 at 00:45 +0000, Andy Smith wrote:
> On Fri, Jun 10, 2005 at 01:43:39PM -0700, Dan Stromberg wrote:
> > Consider:
> >=20
> > You have a bunch of "bricks" that can shuffle data between a NAS head
> > and a bunch of disks.
> >=20
> > The disks are RAID'd (through the "bricks"), but if one of the bricks
> > themselves dies, you're kinda stuck.
> >=20
> > But if you RAID 5 the RAID 5's, then you don't end up with massive
> > parity pounding, and your bricks aren't a single point of failure, and
> > you don't lose as much space as if you mirrored.
>=20
> Off the top of my head, this is what I am thinking, but I could well
> have missed something...
>=20
> Assume you have 50 disks.

I guess we're talking about 200 or so, but the ideas are pretty similar
in either case I imagine.

> If you organise them as 10 five disk RAID 5s and then RAID 5 the
> RAID 5s you end up with the capacity of (5-1)*(10-1)=3D36 disks.
> Depending on your RAID technology, reads may be as fast as a 10-way
> stripe.  As far as I can see though, a write would have to be
> striped to 10 RAID 5s, which would itself be striped to 5 disks
> each, so it would be a 50-way write.

Well...  Does RAID not usually read from n-1 disks, and write to 2, in a
typical RAID 5 config when writing a single block?



> So, unless I have misunderstood, depending on how you split the RAID
> 5s you'll get about 75% of the disk as opposed to 50% for RAID 10,
> but the write performance and the reliability seem much worse.

Hmmmmmm...  What about these forms of RAID that are supposed to be able
to say, lose n-4 disks for an up-to-4-disk failure?  What would they be
like on a 200 disk RAID array?



--=-88HvNUE8kovGPIp9Xn4X
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQBCrcigo0feVm00f/8RAmoCAJ4pNp6dgqcWfMHFeVzOR4I2ko0pJgCglaJn
9X+FpFBAJZ2vpYhtP9NaV2A=
=ixbF
-----END PGP SIGNATURE-----

--=-88HvNUE8kovGPIp9Xn4X--

