From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Bad sequential performance of RAID5 with a lot of disk seeks
Date: Tue, 7 Oct 2014 08:43:47 +0100
Message-ID: <20141007074347.GA18786@cthulhu.home.robinhill.me.uk>
References: <54336FC1.6080306@gautschi.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54336FC1.6080306@gautschi.net>
Sender: linux-raid-owner@vger.kernel.org
To: "P. Gautschi" <linuxlist@gautschi.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Oct 07, 2014 at 06:44:49AM +0200, P. Gautschi wrote:

> I've created a RAID5 on 5 identical SATA disks. Doing some performance me=
asurements
> with dd I get a disappointing performance.
> A dd with bs=3D1M on a btrfs created on md0 transfers about 110 MB/s. (bo=
th read and write)
> A dd on md0 has the same write speed but only about 20 MB/s on read.
> In all of the tests I hear the disk constantly seeking. This was also the=
 case
> during creation of the array.
> I also created a RAID4 to make sure that I doesn't get fooled by the stri=
pe layout of RAID5.
> Now I get about 110 MB/s for write and 230 MB/s for read on md0. But the =
constant
> seeking is still present for both read and write and during creation of t=
he array.
>=20
> Why are the disk perform so many seek operations? I think a sequential ac=
cess on md0 should
> cause a sequential access on the individual disk.
>=20
> I have to add that I did something unusual: I created the RAID4/5 with a =
chunk size of 4KiB.
> The idea of this was that when I'm going to use btrfs with the default no=
desize of 16KiB
> all node write will fill a full stripe and there won't be any RMW at all.=
 (both fortunate
> for performance and integrity in a power loss situation.)
> Nevertheless I think a sequential access on the array should cause a sequ=
ential access on the
> disks for any chunk size if the read/write block size is a exact multiple=
 of
> the (numdisks-1)*chunk size.
>=20
> Is there any explanation for the seeks and how do I get rid of them?
>=20
After creating the arrays did you wait for them to finish syncing? The
array is created in degraded mode initially and then rebuilds onto the
additional disk (this is the fastest way to do things, unless you know
the disks are all zeroed initially). Until this rebuild is complete then
it'll be competing with any other disk activity.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--5vNYLRcllDrimb99
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlQzmbIACgkQShxCyD40xBKRPgCfRG9O3qdwP5TtTyLYMsQ3pgC1
ZwAAni+oFSvkX4tEKM1FDnXwFPkvDsPP
=ncZr
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
