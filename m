From: NeilBrown <neilb@suse.de>
Subject: Re: md/raid5: fresh drive rebuild always requires a fullsync if
 interrupted
Date: Thu, 12 Sep 2013 15:52:28 +1000
Message-ID: <20130912155228.26476675@notabene.brown>
References: <CAGRgLy4+E46exJpSv-eaG6uZAOTQWCUpGjUbENjvvzG3LV8H3w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/KGwU8_eY7ZuCbioUx=8zcnh"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy4+E46exJpSv-eaG6uZAOTQWCUpGjUbENjvvzG3LV8H3w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/KGwU8_eY7ZuCbioUx=8zcnh
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 11 Sep 2013 21:08:11 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hi Neil,
>=20
> Please consider the following scenario:
> # degraded raid5 with 3 drives (A,B,C) and one missing
> # a fresh drive D is added and starts rebuilding
> # drive D fails
> # after some time drive D is re-added
>=20
> what happens is the following flow:
> # super_1_validate does not set In_sync flag, because
> MD_FEATURE_RECOVERY_OFFSET is set:
>     if ((le32_to_cpu(sb->feature_map) &
>          MD_FEATURE_RECOVERY_OFFSET))
>         rdev->recovery_offset =3D le64_to_cpu(sb->recovery_offset);
>     else
>         set_bit(In_sync, &rdev->flags);
>     rdev->raid_disk =3D role;
>=20
> # As a result, add_new_disk does not set saved_raid_disk:
>     if (test_bit(In_sync, &rdev->flags))
>         rdev->saved_raid_disk =3D rdev->raid_disk;
>     else
>         rdev->saved_raid_disk =3D -1;
>=20
> # then add_new_disk unconditionally does:
>     rdev->raid_disk =3D -1;
>=20
> # Later remove_and_add_spares() resets rdev->recovery_offset and calls
> the personality:
>     if (rdev->raid_disk < 0 && !test_bit(Faulty, &rdev->flags)) {
>         rdev->recovery_offset =3D 0;
>         if (mddev->pers->hot_add_disk(mddev, rdev) =3D=3D 0) {
>=20
> # And then raid5_add_disk does:
>         if (rdev->saved_raid_disk !=3D disk)
>             conf->fullsync =3D 1;
>=20
> which results in full sync.
> This is on kernel 3.8.13, but your current for-linus branch has the
> same issue, I believe.
>=20
> Is this a reasonable behavior?

Reasonable, but maybe not ideal.

>=20
> Also, I see that recovery_offset is basically not used at all during
> re-add flow: we cannot resume the rebuild from recovery_offset,
> because while the drive was out of the array, data may have been
> written before recovery_offset, correct? That's why it is not used?

I suspect it isn't used because I never thought to use it.
It is probably reasonable to set 'saved_raid_disk' if recovery_offset holds
and  interesting value.  You would need to make sure that that is preserved
by the code that uses 'saved_raid_disk'.

Patches welcome....

NeilBrown

--Sig_/KGwU8_eY7ZuCbioUx=8zcnh
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUjFWnDnsnt1WYoG5AQIugw//T9blEzh5sZqahvxi5BambWhqAxArFOqK
/woso49m2alrtzlkwKNMzgC37RgI4izrQH1WH6NN3AtFRnfTN3fiRyIkH+hWrZ3g
L1hr6+DnFN41VWid1ZXzqPOVSbQqTfW/1E5WZ90KAB1zz17i62YcWxTqcm9Mx/V9
MLtTbGG/KoSCJdQ3x9hk1jdwQTgk0EMfsBidB+4kHd459Z+2RODExmTjvAQvj+Fk
0hcH/vuCRZN3737tDkzQEZo8HRSlgeZ0r3R3RvrstVxiut77j4LP/cnUJ6/BYqgk
SHswcpiOj8yyIqzxqGposenGDbNOL+Sjg3UN9FSAgXYCRnuW/Wb72IcTFh9CLmE5
AZfN6kr/2ktu2bIEUMZGuAmgaxW9ztImYx3JidqfTLJzrvrJoyZ/drAqvHp4omKZ
dJdr5YrE5aam7wgCCQExBjwUPrWUeSc8jS/4a6SFq3jrFVBVx0EkOLspa6eU0Nit
AQrNwb6kba5UL+iVUYnhY3TEeXF0O9L3AJZk1ktcK7UXOM7sbDzInniAt0OdpN0s
tukeqilhtq1xBG6CDu2oE/sxi/HN+YgMx9lHw7tXAKf10RmhoubeVfLYO9bfU0hv
ajcxFmBccgJ/n8Mdf/RCeN66blrM0TnYOe6Xaxc4ZZ75jH8n1tqJRH3w9BkdYS4o
6D0wrJ/8pB0=
=kk2W
-----END PGP SIGNATURE-----

--Sig_/KGwU8_eY7ZuCbioUx=8zcnh--
