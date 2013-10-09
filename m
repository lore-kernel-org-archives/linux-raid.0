From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: RAID 5 : recovery after failure
Date: Wed, 9 Oct 2013 10:14:48 +0100
Message-ID: <20131009091448.GA13760@cthulhu.home.robinhill.me.uk>
References: <CAPbD+Repm2SDpCGsR35QbW9Zq-MiCu1Fsdh4jjP_yESE3E3Exg@mail.gmail.com>
 <20131008210603.GA22876@cthulhu.home.robinhill.me.uk>
 <CAPbD+Re5TogdCTWabxoch77zzSRFfZhzuxAF=+UVn_ND2+R-3w@mail.gmail.com>
 <alpine.DEB.2.02.1310090853060.20065@uplift.swm.pp.se>
 <CAPbD+Rd2Ouvh0crZgujrkqTr2kCNPkQ25D3f7q96eQFDb__ddw@mail.gmail.com>
 <alpine.DEB.2.02.1310091022560.20065@uplift.swm.pp.se>
 <CAPbD+Ret3-2M1ir=0G5YP9VdGBptMAPLzCZRFga0jjv0Y6aEhQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPbD+Ret3-2M1ir=0G5YP9VdGBptMAPLzCZRFga0jjv0Y6aEhQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guillaume Betous <guillaume.betous@gmail.com>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Oct 09, 2013 at 10:54:09AM +0200, Guillaume Betous wrote:

> I don't know if /dev/sdb is still usable, or if this was only a
> desynchro failure.
> How to know ?
>=20
As sdb1 has already been marked spare, it'll need rebuilding anyway, so
it doesn't really matter. If there's a real issue with it then it'll
fail during the recovery process anyway. You can do a full read test on
it (either a long SMART test, a simple dd from it, or a read-only
badblocks test) if you want to check for issues though.

> P.S. The /proc/mdstat file currently contains the following:
>=20
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
> md127 : active raid5 sde1[2] sdb1[5](F) sdc1[0](F) sdd1[6] sdf1[4]
>       5860535808 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/2] =
[__UU]
>       [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>........]  recovery =3D 62.0%
> (1212358192/1953511936) finish=3D854.7min speed=3D14451K/sec
>=20
It looks like recovery was kicked off onto sde1, but sdc has failed
again during the rebuild. This would suggest a read error on sdc1
somewhere - dmesg should show some indication of what's happened.

You'll need to stop the array and sort out sdc before you can get it
going again. Use GNU ddrescue to image it onto another disk (preferably
one that wasn't originally a member of the array) - it may be able to
get all the data read (it tries somewhat harder than normal processes),
or you'll at least see how much is unreadable.

If it's all read okay then you can just re-run the force assembly using
that disk instead of sdc (make sure you explicitly list the devices to
use in the assembly command). Then add one of the other disks and wait
for the rebuild to complete (there may be no real issue with sdc - you
do sometimes get read errors on disks which are solved by simply
rewriting the data).

If not then you have to make a decision about whether there's few enough
unreadable blocks to continue with assembly (as above) and possibly end
up with some corrupt files, or whether you want to risk re-creating the
array using the other original member (I'd suggest doing a full read
test on that disk first though, as it may be in the same state).

If you're wanting to do a re-create then we'll need to revisit your
original array details to see parameters would be needed (and which
mdadm version you'll need to get the correct data offsets).

Once everything's back up and running, you really need to:
 - make sure the timeouts/ERC are set correctly at every boot
 - schedule array checks on a regular basis to pick up any read errors
   while they can still be corrected

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlJVHogACgkQShxCyD40xBKNSwCgrzOpbR5LDjzfPQ20Tf5gN7TD
aWAAn2gYzC4rlyHttZqDqyHzOWIRJWtc
=tlqw
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
