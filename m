From: "C.J. Adams-Collier KF7BMP" <cjac@colliertech.org>
Subject: Re-assembling faulty array
Date: Fri, 11 May 2012 12:41:16 -0700
Message-ID: <1336765276.10557.30.camel@foxtrot.cjac.ntr.f5net.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-sRr00COKVztbD0sGYUle"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-sRr00COKVztbD0sGYUle
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hey all,

I've got an array that seems to have failed while I was re-synchronizing
one of the disks.  sde fell out when I moved six disks from one chassis
to another.  I re-added it and it was 98.8% done with 300 minutes left
in the process when I went to sleep last night.  When I woke up, the
array was in a FAILED state, sdg was marked failed and sde was marked
spare.  I removed sdg from the array and re-booted and now the array
won't start.

Is there a way to re-add sdg back in to slot 5 rather than having it
added as a spare?  AFAICT, no writes have been made to sdg or md0 since
I removed it from the array, so it should be pretty close to its active
state.  sde must be nearly ready to be added in as an active participant
in the array, too.

Is there anything I can do to re-build the array at this point?

Cheers,

C.J.


--=-sRr00COKVztbD0sGYUle
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABCAAGBQJPrWtcAAoJEEyimPmPQm23//cH/3Yd12bSfbzb+du5dzvIR4wr
Ldz4S7qvWMiNsn5x0Pxb1BrOCZ3C6+vGVRGP8owWvUaXXjIeJsOF+dHPkStVhhsd
Jy4sSjxVld+9OPB6ilTKCDKRU7Rj0X/i6SrTQ27HdPR2pzTWBNkA4VtQhrIIorlJ
35ACiQi1Rpk8egdfoSdQVFq5PDe1YUuRSFjuVROFTWGCVzfBkVY1QcYMEtYB/BdS
QeVkXhnURP9woZo7MfaTCeSYpNgQ9+YgA2R5FLDybvKAOaEiDOkUXX0asH42GHu5
92alJXqlpyaMq9X01Jin1Xzyl1yvcLXktRv0M4yTw5aKVJBKj+ZU4B1YMnyvTqU=
=sZT+
-----END PGP SIGNATURE-----

--=-sRr00COKVztbD0sGYUle--

