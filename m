From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 0/2] raid1/10: Handle write errors correctly in narrow_write_error()
Date: Wed, 21 Oct 2015 07:29:30 +1100
Message-ID: <87pp092sid.fsf@notabene.neil.brown.name>
References: <1445357353-19906-1-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1445357353-19906-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: linux-raid@vger.kernel.org, kent.overstreet@gmail.com, William.Kuzeja@stratus.com, xni@redhat.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Jes.Sorensen@redhat.com writes:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>
> Hi,
>
> Bill Kuzeja reported a problem to me about data corruption when
> repeatedly removing and re-adding devices in raid1 arrays. It showed
> up to be caused by the return value of submit_bio_wait() being handled
> incorrectly. Tracking this down is credit of Bill!
>
> Looks like commit 9e882242c6193ae6f416f2d8d8db0d9126bd996b changed the
> return of submit_bio_wait() to return !=3D 0 on error, whereas before it
> returned 0 on error.
>
> This fix should be suitable for -stable as far back as 3.9

3.10?

Thanks to both of you!

I took the liberty of changing the patches a little so they are now:

=2D               if (submit_bio_wait(WRITE, wbio) =3D=3D 0)
+               if (submit_bio_wait(WRITE, wbio) < 0)

because when there is no explicit test I tend to expect a Bool but these
values are not Bool.

Patches are in my for-linus branch and will be forwarded sometime this
week.

This bug only causes a problem when bad-block logs are active, so
hopefully it won't have caused too much corruption yet -- you would need
to be using a newish mdadm.

Thanks,
NeilBrown

>
> Cheers,
> Jes
>
> Jes Sorensen (2):
>   md/raid1: submit_bio_wait() returns 0 on success
>   md/raid10: submit_bio_wait() returns 0 on success
>
>  drivers/md/raid1.c  | 2 +-
>  drivers/md/raid10.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> --=20
> 2.4.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWJqQqAAoJEDnsnt1WYoG5TocQAKcs3cLJtiz5X2Ffu1FAxryf
YenDll0VtjsldmHgBvDJQVyHhjKp0KnIusQzVrIm5iYJJQosz+6PYZplkk/wLZXs
huJZW4tUN74Z1G0m+HOEa7ZmPHY+axvA9f5Z/81OGCnypm4CjoD87IQFhJjQC7mL
fkoxvK7beEFsKi16CH/cUjPiWyDPlvky6wuPf6S3ouKljrbpeOyEYGJ1mauNmcCi
RW40cup6LL/zRiAK+O2v9HwIEpD3lItdJXn5PcXf5UMavrhoHKrb2weMYN4R0bLH
KOtV0aP4ZLOwTKRGTrw8GUietMV3HA8dTTmJY96sGgI5QuDjznvM9oTSSJ5OovLF
K2en8ftwtBW61y3m2w7JBiZSUI8McbenGxvx+HqIALBOKFarju52GJU6TbOgV7H1
XVqO/u3E6BJ8egpdlH4INgf0x5ldbbqjvRhR13NbY63KEEyzHbftQwCd9q336VtM
99OUivQuNRtewxUfNPEiQjwdf5PVrS2xkoCCap/2ylDtnLLbYOL0hLziIMm1O36r
qqdDhWJcWBrAmo28qK0kou4di5RT/tyJ9q7+iMUvCVxoG/s+CfiIze4w2v5SZnnX
XkQNq/481sFUpdJrG/o5TKY+KRlemXf459SlvitrzeBq91Yy2LduR+7F8VTOBQDM
PTfaFh7Bgcp8y5hrM0VG
=PFGB
-----END PGP SIGNATURE-----
--=-=-=--
