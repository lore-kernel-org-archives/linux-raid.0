From: NeilBrown <neilb@suse.de>
Subject: Re: Last working drive in RAID1
Date: Thu, 5 Mar 2015 08:46:34 +1100
Message-ID: <20150305084634.2d590fe4@notabene.brown>
References: <54F7633F.3020503@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/mKN7.AgX/UPC=hb/fjPzrIS"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54F7633F.3020503@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Eric Mei <meijia@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/mKN7.AgX/UPC=hb/fjPzrIS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 04 Mar 2015 12:55:43 -0700 Eric Mei <meijia@gmail.com> wrote:

> Hi,
>=20
> It is interesting to notice that RAID1 won't mark the last working drive=
=20
> as Faulty no matter what. The responsible code seems here:
>=20
> static void error(struct mddev *mddev, struct md_rdev *rdev)
> {
>          ...
>          /*
>           * If it is not operational, then we have already marked it as d=
ead
>           * else if it is the last working disks, ignore the error, let t=
he
>           * next level up know.
>           * else mark the drive as failed
>           */
>          if (test_bit(In_sync, &rdev->flags)
>              && (conf->raid_disks - mddev->degraded) =3D=3D 1) {
>                  /*
>                   * Don't fail the drive, act as though we were just a
>                   * normal single drive.
>                   * However don't try a recovery from this drive as
>                   * it is very likely to fail.
>                   */
>                  conf->recovery_disabled =3D mddev->recovery_disabled;
>                  return;
>          }
>          ...
> }
>=20
> The end result is that even if all the drives are physically gone, there=
=20
> still one drive remains in array forever, and mdadm continues to report=20
> the array is degraded instead of failed. RAID10 also has similar behavior.
>=20
> Is there any reason we absolutely don't want to fail the last drive of=20
> RAID1?
>=20

When a RAID1 only has one drive remaining, then it should act as much as
possible like a single plain ordinary drive.

How does /dev/sda behave when you physically remove the device?  md0 (as a
raid1 with one drive) should do the same.

NeilBrown

--Sig_/mKN7.AgX/UPC=hb/fjPzrIS
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVPd9Ojnsnt1WYoG5AQJd3w/9G0b6Jv54zA+P9Gw6z/GGNlBmldZ70Ojf
zxA4AxpKAQstg4a2bQ0r7IWex6SquvmTOC3gFjNHjeu+hhHwf7RYoIndplyDR1b3
yBRw5N3sHsXyha3XIA7INKawEu2f4K96ZqNVprldL+qK8DbmpzNvrzZK2YgVFVMn
wmGXDHFfVW3EhTmXtdBtkbZOSzNmzFX8bjcbhQ7sG2lTV1PZcfkbsGOv0IhxH8Mn
1zRHyRJ6Bpow3a+ZjV4BOcsz3KS1EmBFaEBRKS3w9EtNAb8e8ks+YA1cyLmR6gby
CT7HmtZGfc8fkHYxOyhPSDEBRfUVxIxeN6YYUG1zJLYH33eCwc0QxRQDGy9jxDNP
Nm8BkZ7V+LzDXnRgo3TuhfOS94jqeVlwto2hxJikut23op9w4BQpqe0Z8zVtsHOz
hMfwXOFdpezEoCEVCjIn98GnncDF1sKMcYPZrrGJU2zjsCAXETSo8zoWnzApajv1
Bc+xe8vzoea2xNeX4Q5QHvEiBXw8C+k/lquS94lNDL/U+QX7IAfk+UEGUMnQD0MG
JiG+E0nUiVM/D+RSwUVA86K0fD0jO4EUiljQ5b1/5+r8VZV1ky7+7p7jsmjaObNH
/0riFEvSQAWmUcs4o98MDBTbp1rxCCvIwLlPkapqEedGkqi3KY+o6t2uwHt8Ns24
2L9HhLtIrcw=
=ASUt
-----END PGP SIGNATURE-----

--Sig_/mKN7.AgX/UPC=hb/fjPzrIS--
