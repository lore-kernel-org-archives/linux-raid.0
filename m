From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH 0/4] add --initrd argument to mdadm/mdmon
Date: Tue, 17 Jan 2012 14:57:16 -0500
Message-ID: <4F15D29C.7070504@redhat.com>
References: <1326797330-4488-1-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC32E5CE91F184A3A4255999F"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1326797330-4488-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: neilb@suse.de, linux-raid@vger.kernel.org, kay@redhat.com, harald@redhat.com, lpoetter@redhat.com, mschmidt@redhat.com
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC32E5CE91F184A3A4255999F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 01/17/2012 05:48 AM, Jes.Sorensen@redhat.com wrote:
> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>=20
> Hi,
>=20
> In order to resolve the problem with reboots hanging on systems with /
> on an IMSM RAID, systemd needs to be able to see that a given mdadm
> and mdmon process was launched from the initramfs, and allow it to
> survive until it gets back to there, so it can unmount the root
> filesystem safely.
>=20
> These patches introduces the --initrd argument to mdadm which makes it
> change the first character of argv[0] to '@' to match the convention
> set by systemd.
>=20
> In addition I also changed mdmon to use getopt_long to make it easier
> to add more command line arguments to it. Note that I went through
> great effort to preserve the behavior, even though the old code did
> some somewhat dodgy stuff using changing the arvg buffer pointing to
> the '--all' argument.
>=20
> Comments?
>=20
> Thanks,
> Jes
>=20
> Jes Sorensen (4):
>   mdmon: Use getopt_long() to parse command line options
>   Add --initrd argument to mdadm
>   Add --initrd argument to mdmon
>   Spawn mdmon with --initrd if mdadm was launched with --initrd
>=20
>  ReadMe.c |    3 ++
>  mdadm.c  |   11 ++++++++++
>  mdadm.h  |    3 ++
>  mdmon.c  |   64 +++++++++++++++++++++++++++++++++++++++++++++++++++---=
-------
>  util.c   |   17 ++++++++++++---
>  5 files changed, 83 insertions(+), 15 deletions(-)
>=20

Patch set looks reasonable to me, although you missed adding the new
option to the mdadm man page.

Do we have a specific systemd version for which we know that --initrd is
needed, or a version before which it is the wrong thing to do?

Ditto for dracut, do we know what the minimum version of dracut is
before it will use the --initrd parameter on its mdadm calls?


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford



--------------enigC32E5CE91F184A3A4255999F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPFdKcAAoJELgmozMOVy/db5sP/2+vU9zaiErBDuo9RF7g5sTw
8U9zAPMjlEMMWwzMKdtxn77Ie/T+vaS7wT1O2xl5jrnzX0qUt8FA7MZKVVOKYl6Q
8b8nwdVogxa8sDOYW1EB/pxc1u107OrWpkGM+EqbuSjpTKnGXek1ZRstROoLDflJ
HLw/J16I99z3yLa4a/78HaQl5saY4C1ua6sYZ2lW7z3io9nr0eoh1bAP1bY56VS/
LjcqocrtIIhyt6owa4gkGr5Fy6XLj6aYUT/bhfDspLwGFMKwIoyu2LL9HKUeLc3Y
nFbOcbl4ORa7fQT6ehz9g4nSc0hz0cEhvyPLbiLtH7pCQVJmjHoNTanZJmTGQ/xn
ijLgtXPi8FB0DCkGw3WtE1RjCPMxO6wP9xqtZylIxstm++6pu7PkGDiHJS5w/FpH
NLBOEkK/YRONRBeqysDKDTTStXxo5FiTL3cUYiHx2SCP41N6jSFDFU6V5dEUIxS/
iQnADQljNxodh3U6cmeQEuR9smjddA4hh6B+p8DWegm1jS63McQHh/zZin8YIVza
R+E6dBKfB0uMth676I4nWzO0rHaNVyPQA4sv0wkdjCOeIX9JTa1wOYC1RQxfX4dP
L1SiYInn9NH0VN3MyTqzgIno17Tet9bvfup1kvc8XDLf0FnVMlaDJQkgN1pCQHkV
oPbwRwq+5gtpNl7tMZUr
=MdHj
-----END PGP SIGNATURE-----

--------------enigC32E5CE91F184A3A4255999F--
