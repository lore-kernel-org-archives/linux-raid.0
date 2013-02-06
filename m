From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: RAID5 made with assume-clean
Date: Wed, 6 Feb 2013 13:02:54 +0000
Message-ID: <20130206130254.GA12118@cthulhu.home.robinhill.me.uk>
References: <20130206115258.GA31466@animx.eu.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130206115258.GA31466@animx.eu.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Feb 06, 2013 at 06:52:58AM -0500, Wakko Warner wrote:

> I was testing different parameters with --assume-clean to avoid the initi=
al
> rebuild.  When I decided on the parameters I wanted, I forgot to create t=
he
> array without --assume-clean.  I have 3 disks in the array.
>=20
> I thought that I'd run a check on it by doing
> echo check > /sys/block/md0/md/sync_action
>=20
> /proc/mdstat is showing this:
> Personalities : [raid1] [raid6] [raid5] [raid4]=20
> md0 : active raid5 sda1[0] sdb1[1] sdc1[2]
>       488018688 blocks super 1.1 level 5, 64k chunk, algorithm 2 [3/3] [U=
UU]
>       [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>........]  check =3D 61.7% (1=
50688512/244009344) finish=3D7.1min speed=3D216592K/sec
>=20
> unused devices: <none>
>=20
> The thing is, the drives can only do ~60mb/sec and there is no disk
> activity.  The activity lights are not lit at all.  What would cause that?
>=20
What disks are they? I would expect a modern SATA disk to be able to
handle 120MB/s for sequential read, so 220 across the array would be
pretty normal.

> I was also wondering if the raid5 did RMW on the parity with 3 disks when
> the array is written to.
>=20
Not sure what the logic is on this. For a 3 disk array it'd need a
single read and 2 writes for a single chunk, whether it's doing RMW or
not. It will probably still do RMW though, as that avoids the
complication of special-casing things. I've had a quick look at the code
and I can't see any special casing (other than for a 2 disk array, where
the same data is written to both).

> I can rebuild the array without assume-clean if that's the only way I can
> get the parity to be correct, but I'd like to avoid doing that if possibl=
e.
>=20
That's definitely the safest option. If you can verify the data then you
could run a repair and a fsck before verifying/restoring the data, but
that'd take far longer than a simple rebuild and restore.

HTH,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlESVH4ACgkQShxCyD40xBIcWACdGhIh8KgrCpkI6HSiFJP6f04H
u+EAn07uN0/PfoTFfNrotgInu2KCVEBt
=+zdz
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
