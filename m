From: Roman Mamedov <roman@rm.pp.ru>
Subject: Re: raid5 failed while rebuiling - classical problem
Date: Sat, 3 Jul 2010 03:36:59 +0600
Message-ID: <20100703033659.0cffc6ad@natsu>
References: <20100702163155.511919c1@atak.bl.pg.gda.pl>
	<20100702231854.105b8612@atak.bl.pg.gda.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Tl+CkDFR8h=pD.N0el=fbAM"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100702231854.105b8612@atak.bl.pg.gda.pl>
Sender: linux-raid-owner@vger.kernel.org
To: Janek Kozicki <janek_listy@wp.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Tl+CkDFR8h=pD.N0el=fbAM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 2 Jul 2010 23:18:54 +0200
Janek Kozicki <janek_listy@wp.pl> wrote:

> I need to overwrite the bad sector with zeros.

There isn't really a need to overwrite the whole drive for that -- you can
either get that block's address from the LBA number in dmesg errors, or by
running a read-only badblocks test. Then make sure it is really the sector =
you
want (try reading it with dd -- it will fail with an I/O Error), and overwr=
ite
using dd if=3D/dev/zero of=3D/dev/hda seek=3DNNNNNNNNN bs=3D512 count=3D1
Several times if needed, checking if the drive has remapped the sector alre=
ady
(instantly, or after some repeats it should become readable).

> I have a free hdc3, which I am going to use for that:
>=20
>   # dd bs=3D512 if=3D/dev/hda3 of=3D/dev/hdc3 conv=3Dnoerror,sync
>=20
> The noerror tells dd to continue, even if it cannot read, and sync
> tells to write zeros on hdc3 in that place (at least I hope that I
> got the manpage right).

There is the dd_rescue program, made specifically for that purpose:
http://www.garloff.de/kurt/linux/ddrescue/

> Then I will have an almost exact copy of bad hda3 on hdc3.=20
> <...> maybe I could just --add hdc3 in place of hda3 ?

Yes, you could, and that would be the most logical thing to do (as hda might
continue failing and developing more bad sectors).

--=20
With respect,
Roman

--Sig_/Tl+CkDFR8h=pD.N0el=fbAM
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwuW/sACgkQTLKSvz+PZwgSxACfWfdNLhvHBodv3CodN28w4zJ3
0hsAoIdUOZ+jjjKAX9zJ63eSR0kH82cH
=+jXo
-----END PGP SIGNATURE-----

--Sig_/Tl+CkDFR8h=pD.N0el=fbAM--
