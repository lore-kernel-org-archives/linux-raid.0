From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Converting system to raid
Date: Tue, 14 Apr 2009 10:30:15 +0100
Message-ID: <20090414093015.GA19074@cthulhu.home.robinhill.me.uk>
References: <00cc01c9ba1d$3aefecf0$0a00a8c0@vorg> <20090410205942.GC21242@cthulhu.home.robinhill.me.uk> <00f301c9ba23$032025f0$0a00a8c0@vorg> <20090410215129.GD21242@cthulhu.home.robinhill.me.uk> <019701c9ba66$aeed5630$0a00a8c0@vorg> <f19d625d0904110729y30e8bc80m41fcd8f2c3298d49@mail.gmail.com> <007001c9bad6$2525c610$0a00a8c0@vorg> <001201c9bb09$3161e9d0$0a00a8c0@vorg> <20090412111107.GA19413@cthulhu.home.robinhill.me.uk> <000b01c9bba8$a5b08a40$0a00a8c0@vorg>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <000b01c9bba8$a5b08a40$0a00a8c0@vorg>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun Apr 12, 2009 at 12:55:33PM -0700, Timothy D. Lenz wrote:

> While booted on the array I renamed device.map and ran:
> sudo grub --no-floppy --device-map=3D/boot/grub/device.map
>=20
> But the new map is the same:
> (hd0) /dev/hda
> (hd1) /dev/sda
> (hd2) /dev/sdb
>=20
That's a little odd - it should be picking up the BIOS order (though it
may actually depend on what order the kernel picks up the devices).  You
can just edit the file manually anyway.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.10 (GNU/Linux)

iEYEARECAAYFAknkV6cACgkQShxCyD40xBKjOwCfb+cExv3n1UV4Sp29LSp8oLEt
sMQAn2SkPgbla5L+8/c7pXfffKIdsjfe
=hZvv
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
