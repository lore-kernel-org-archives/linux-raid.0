From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: --examine contradicts --create and --detail, again
Date: Wed, 11 Feb 2009 13:59:17 +0000
Message-ID: <20090211135917.GA7295@cthulhu.home.robinhill.me.uk>
References: <1234349289.21577.1299744243@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1234349289.21577.1299744243@webmail.messagingengine.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Feb 11, 2009 at 02:48:09AM -0800, whollygoat@letterboxes.org wrote:

> Either I am misunderstanding something, or I have
> a hardware issue I don't know how to diagnose.  Any=20
> suggestions on things to read or to try are welcome.
>=20
> # mdadm -D /dev/md/0
>    =20
>     Number   Major   Minor   RaidDevice State
>        0      33        1        0      active sync   /dev/hde1
>        1      34        1        1      active sync   /dev/hdg1
>        2      56        1        2      active sync   /dev/hdi1
>        3      57        1        3      active sync   /dev/hdk1
>        6      88        1        4      active sync   /dev/hdm1
>         =20
>        5      89        1        -      spare   /dev/hdo1
>=20
> So, then, why oh why oh why does --examine, on any of the=20
> component devices, show slots for  7 devices, one failed,=20
> one empty?  I have recently changed RAM, mobo, system disk
> and some IDE cables thinking each time that I had finally
> come to the end of this.
>=20
> # mdadm -E /dev/hde1
>=20
>     Array Slot : 0 (0, 1, 2, 3, failed, empty, 4)
>    Array State : Uuuuu 1 failed
>=20
> Sorry for bringing up this new instance of the same old=20
> problem yet one more time.
>
I'd say this is just an artifact of how the array creation works,
Because it starts as a degraded array, initially one of the RAID devices
is flagged as missing/faulty (so you have member numbers 0, 1, 2 and 3
in the array, 4 flagged as missing/faulty, and 5 & 6 as spares).  When
it does the initial build, it uses member number 6, leaving 5 as the
spare.  This leaves you with 1 "failed" member and one "empty" (the
spare - it's not part of the array so doesn't have a Device Number).

Unfortunately I don't have any RAID5 arrays around now to check whether
I see the same here.  However, if the system's working fine otherwise
then I certainly wouldn't worry about it.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkmS2bQACgkQShxCyD40xBJ2FQCfbLGdvjaFlbVqjsDaNg1gaGOv
Ak0An3wLBfnLAmF8tBkHcFYGJ2msL+sB
=S3Ic
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--
