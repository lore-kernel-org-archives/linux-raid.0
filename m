From: NeilBrown <neilb@suse.de>
Subject: Re: [md PATCH] md/raid1: round up to bdev_logical_block_size in
 narrow_write_error
Date: Mon, 16 Feb 2015 14:54:26 +1100
Message-ID: <20150216145426.3bfe9b8f@notabene.brown>
References: <54DCDC91.6010808@stratus.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/KYAON=lB+RBrTybo.O1Gnlr"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54DCDC91.6010808@stratus.com>
Sender: linux-raid-owner@vger.kernel.org
To: Nate Dailey <nate.dailey@stratus.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/KYAON=lB+RBrTybo.O1Gnlr
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 12 Feb 2015 12:02:09 -0500 Nate Dailey <nate.dailey@stratus.com>
wrote:

> This modifies raid1's narrow_write_error to round up block_sectors to the
> device's logical block size.
>=20
> This prevents sd complaining about "Bad block number requested" for non-5=
12-byte
> sector disks.
>=20
> Signed-off-by: Nate Dailey <nate.dailey@stratus.com>
> ---
>=20
> diff -Nupr a/drivers/md/raid1.c b/drivers/md/raid1.c
> --- a/drivers/md/raid1.c        2015-02-10 15:29:02.000000000 -0500
> +++ b/drivers/md/raid1.c        2015-02-10 15:29:45.000000000 -0500
> @@ -2206,7 +2206,8 @@ static int narrow_write_error(struct r1b
>         if (rdev->badblocks.shift < 0)
>                 return 0;
>=20
> -       block_sectors =3D 1 << rdev->badblocks.shift;
> +       block_sectors =3D roundup(1 << rdev->badblocks.shift,
> +                               bdev_logical_block_size(rdev->bdev) >> 9);
>         sector =3D r1_bio->sector;
>         sectors =3D ((sector + block_sectors)
>                    & ~(sector_t)(block_sectors - 1))
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Thanks.  I've applied this patch and a similar one for RAID10.

This patch had spaces where it should have had tabs (and had no space at all
on one line which should have had a space).
I've fixed all that up, but if you find yourself submitting more patches in
future it would be worth working out how to convince your mailer to send the
patches cleanly with no TAB->space conversions.

Thanks,
NeilBrown

--Sig_/KYAON=lB+RBrTybo.O1Gnlr
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVOFp8jnsnt1WYoG5AQJfeg//YM+1NVhXdTWREf6b85l+jJqSjydadesx
OsywiNOxzn2syVMuPMUdf2Wr9OJjUstXfsN4wo7bYMHucelUeAMAPmgyWFxVHmJX
aXcsItqXaYYIWlYI9e3rZ31vi6KLL8fhjcUkdtJfqRW3GmtzUl4aUv1uNc0I48kA
OpJLgn2MbdSkbQc+d9PvmtoUXh0vP42yucyrDjV0xf2V/HlusN2nE2BtlEEgaW9X
xtk/Fj8f/T57IgAjm9Mff3Bt45bBmJ+M22Kps9ysPNQyxFjLpDGaS+fG5x3ftEkT
wud/6bAL/WAxT9gJ5qeP1MiJICKPheI7Cti4p7rAyc8ai+HZFNTSxHaw1TJLgfHB
4+rUdu/OLI1zMAKNo5VzN9r57o6lt4AOWsdUYHiXoe4zudIQtOVnBM24RO6zgtg+
DTxnpZ90h7+5lZHjfJLAHBHwhjY0+B0W/7jDAsyCsQ4Aw1ZPfoZpvovNHxGkpchd
mlQ9alhh/hctYhBMGTPsEBt/QqsnyjwDYTf1ePcIZhwCP3cXCAs3gS+vyICTIqzE
YAIULY1qv3tfJ2APLe5AQ0qxcqCbkYd5j07QqVxXjJPrGRrHdKFVvE5/vpK0aR9K
aHUoBZ2Kj1oi3c5gWeJtRQJihvNTZNlHQUZ5O12jdic7glngfjNVPza6WbIX3MD2
OQbiJoBTVO4=
=vylH
-----END PGP SIGNATURE-----

--Sig_/KYAON=lB+RBrTybo.O1Gnlr--
