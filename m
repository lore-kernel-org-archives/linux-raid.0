From: NeilBrown <neilb@suse.de>
Subject: Re: RFC: use TRIM data from filesystems to speed up array rebuild?
Date: Wed, 5 Sep 2012 06:21:13 +1000
Message-ID: <20120905062113.05e4f0f4@notabene.brown>
References: <50464322.3010509@genband.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/WBgFr9tySyvFbenJACp_3UV"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50464322.3010509@genband.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Friesen <chris.friesen@genband.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/WBgFr9tySyvFbenJACp_3UV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 04 Sep 2012 12:06:26 -0600 Chris Friesen <chris.friesen@genband.com>
wrote:

>=20
> Hi,
>=20
> I'm not really a filesystem guy so this may be a really dumb question.
>=20
> We currently have an issue where we have a ~1TB RAID1 array that is=20
> mostly given over to LVM.  If we swap one of the disks it will rebuild=20
> everything, even though we may only be using a small fraction of the spac=
e.
>=20
> This got me thinking.  Has anyone given thought to using the TRIM=20
> information from filesystems to allow the RAID code to maintain a=20
> bitmask of used disk blocks and only sync the ones that are actually used?
>=20
> Presumably this bitmask would itself need to be stored on the disk.
>=20
> Thanks,
> Chris
>=20
>=20

Something like this?
  http://neil.brown.name/blog/20110216044002#5

NeilBrown

--Sig_/WBgFr9tySyvFbenJACp_3UV
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUEZiuTnsnt1WYoG5AQJl/BAAkzAPR7ET8V88fd1kKLK2mijNOGO11uRP
gG7XLWkrMg//84EGSYrYc5BLvXwO/WitD3XMw8A+EZvtwVvj4OH218V9iL3IsPWW
k3XBqYKBJ+HCuGxOv06T5FyNZTE1lAV0yTWKYLtOPurfzittuSwLDaF02uTX0Fja
LpIPyfr7PMSIr4YbJb5VsNbltQiMKyemQ87qOvM4NEPL7ejTI5LTfA7UrYdCQHrY
DR2u99xRsrgnwFQOcaaV4nQOi+LyUw+hSkrcVY4M3t3pQt2xoOVMk1RCU30w3lQE
dUbZ0F8LBgCpnFibv0S3htVkeNKOZSg0MlKLmPP3zPJ4ck0WKoGk1bZUviK/1gIz
hv8HjlDKex+GTSlx0MfFRZwAdTzfufIr+JKZgsBfVEPV/vUwvdoozBoKglGk0kHc
GTu8sjnsF3dhzPhOW8w9JlpSLuQmD4GL4TkaHNOi9hnE49EXQIRAYBUldFhPuCcX
Am7r+ccOVxBfcZBnfvm6yuizNgFfAwD6nQR98aXcMiAHfxQECBmFXnSlgqpB5Xej
Q690/lgYHmyQpfPf4rAp8rCB6J1Y+ccBoPLY6JrVnb+ED/+Es5JgbmKvzTQDVqw3
i6z+YOGbcujIqqEIDxjj7VsA/fIs69lY2dZBLr1r+VpQI0H96x9Hx0wj1ssWmznt
xZrFAXBIk5k=
=8E/S
-----END PGP SIGNATURE-----

--Sig_/WBgFr9tySyvFbenJACp_3UV--
