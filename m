From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Problems with raid after reboot.
Date: Mon, 25 Jul 2011 22:21:07 +0100
Message-ID: <20110725212107.GA6422@cthulhu.home.robinhill.me.uk>
References: <CA+taBv-V7HasgHFFaLV+Ppbgv=b-6CvLLkGHh3oN+GAO0wFHxA@mail.gmail.com>
 <CA+taBv-3OxS52vLgOJiruqAnnOh8nsKtTFsPa20X1DEODdVSYA@mail.gmail.com>
 <CA+taBv_yfW_njVX4r7fpAT105fvBeVMBLbU4M+6tTDY7R1yndA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+taBv_yfW_njVX4r7fpAT105fvBeVMBLbU4M+6tTDY7R1yndA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Matthew Tice <mjtice@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon Jul 25, 2011 at 03:04:34PM -0600, Matthew Tice wrote:

> Well things are a lot different now - I'm unable to start the array
> successfully.  I removed an older non-relevant drive that was giving
> me smart errors - when I rebooted the drive assignments shifted (not
> sure this really matters, though).
>=20
> Now when I try to start the array I get:
>=20
> # mdadm -A -f /dev/md0
> mdadm: no devices found for /dev/md0
>=20
> I can nudge it slightly with auto-detect:
>=20
> # mdadm --auto-detect
>=20
> Then I try to assemble the array with:
>=20
> # mdadm -A -f /dev/md0 /dev/sd[bcde]
> mdadm: cannot open device /dev/sde: Device or resource busy
> mdadm: /dev/sde has no superblock - assembly aborted
>=20
<- SNIP ->
>  =E2=94=82  =E2=94=94=E2=94=80sde: [8:64] MD raid5 (none/4) 931.51g md_d0=
 inactive spare
<- SNIP ->
>=20
> I've looked but I'm unable to find where the drive is in use.

lsdrv shows that it's in use in array md_d0 - presumably this is a
part-assembled array (possibly auto-assembled by the kernel). Try
stopping that first, then doing the "mdadm -A -f /dev/md0 /dev/sd[bcde]"

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk4t3kIACgkQShxCyD40xBL/JACdGmCoX7kiuEetGVdsMJVzWA/G
oYcAoINEHoCOZgwnkZCxcHwS1RxiQpEJ
=sdkh
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
