From: NeilBrown <neilb@suse.de>
Subject: Re: RAD1 doesn't fail WRITE that was written only on a rebuilding
 drive
Date: Wed, 12 Jun 2013 10:26:45 +1000
Message-ID: <20130612102645.02794c8b@notabene.brown>
References: <CAGRgLy6tHN7ZPwxxRM4pzVbKP5fS0PLeXrhKoeZ0XJqVrb0pVQ@mail.gmail.com>
	<20130604095235.16261243@notabene.brown>
	<CAGRgLy4SQTvc15quiU_YJreqG2ODGey3iUrLJjhQL4EcMwJFMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/YnQopvq1bXX+ATHDojMIaxR"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy4SQTvc15quiU_YJreqG2ODGey3iUrLJjhQL4EcMwJFMA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/YnQopvq1bXX+ATHDojMIaxR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 4 Jun 2013 20:54:28 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hello Neil,
>=20
> On Tue, Jun 4, 2013 at 2:52 AM, NeilBrown <neilb@suse.de> wrote:
> > On Tue, 28 May 2013 15:46:33 +0300 Alexander Lyakas <alex.bolshoy@gmail=
.com>
> > wrote:
> >
> >> Hello Neil,
> >> we continue testing last-drive RAID1 failure cases.
> >> We see the following issue:
> >>
> >> # RAID1 with drives A and B; drive B was freshly-added and is rebuildi=
ng
> >> # Drive A fails
> >> # WRITE request arrives to the array. It is failed by drive A, so
> >> r1_bio is marked as R1BIO_WriteError, but the rebuilding drive B
> >> succeeds in writing it, so the same r1_bio is marked as
> >> R1BIO_Uptodate.
> >> # r1_bio arrives to handle_write_finished, badblocks are disabled,
> >> md_error()->error() does nothing because we don't fail the last drive
> >> of raid1
> >> # raid_end_bio_io()  calls call_bio_endio()
> >> # As a result, in call_bio_endio():
> >>       if (!test_bit(R1BIO_Uptodate, &r1_bio->state))
> >>               clear_bit(BIO_UPTODATE, &bio->bi_flags);
> >> this code doesn't clear the BIO_UPTODATE flag, and the whole master
> >> WRITE succeeds, back to the upper layer.
> >>
> >> # This keeps happening until rebuild aborts, and drive B is ejected
> >> from the array[1]. After that, there is only one drive (A), so after
> >> it fails a WRITE, the master WRITE also fails.
> >>
> >> It should be noted, that I test a WRITE that is way ahead of
> >> recovery_offset of drive B. So after such WRITE fails, subsequent READ
> >> to the same place would fail, because drive A will fail it, and drive
> >> B cannot be attempted to READ from there (rebuild has not reached
> >> there yet).
> >>
> >> My concrete suggestion is that this behavior is not reasonable, and we
> >> should only count a successful WRITE to a drive that is marked as
> >> InSync. Please let me know what do you think?
> >
> > Sounds reasonable.  Could you make and test a patch?  Then I'll apply i=
t.
>=20
> I read all the code of raid1.c, and it seems that we need to fix only
> one place. With this fix, I don't see corruption after I fail and then
> revive the last drive of raid1. I also attach the patch, in case Gmail
> wraps it.
>=20
> Also, with this fix, the rebuilding drive is ejected almost
> immediately, so the second part of the problem doesn't happen now.
> Although I will consider your suggestion for it later.
>=20
>=20
>=20
> >From 8d25ada35b5e1ec6ea4c6da6e571ec691b34086a Mon Sep 17 00:00:00 2001
> From: Alex Lyakas <alex@zadarastorage.com>
> Date: Tue, 4 Jun 2013 20:42:21 +0300
> Subject: [PATCH] md/raid1: consider WRITE as successful only if at least =
one
>  non-Faulty and non-rebuilding drive completed it.
>=20
> Without that fix, the following scenario could happen:
>=20
> - RAID1 with drives A and B; drive B was freshly-added and is rebuilding
> - Drive A fails
> - WRITE request arrives to the array. It is failed by drive A, so
> r1_bio is marked as R1BIO_WriteError, but the rebuilding drive B
> succeeds in writing it, so the same r1_bio is marked as
> R1BIO_Uptodate.
> - r1_bio arrives to handle_write_finished, badblocks are disabled,
> md_error()->error() does nothing because we don't fail the last drive
> of raid1
> - raid_end_bio_io()  calls call_bio_endio()
> - As a result, in call_bio_endio():
>         if (!test_bit(R1BIO_Uptodate, &r1_bio->state))
>                 clear_bit(BIO_UPTODATE, &bio->bi_flags);
> this code doesn't clear the BIO_UPTODATE flag, and the whole master
> WRITE succeeds, back to the upper layer.
>=20
> So we returned success to the upper layer, even though we had written
> the data onto the rebuilding drive only. But when we want to read the
> data back, we would not read from the rebuilding drive, so this data
> is lost.
>=20
> Signed-off-by: Alex Lyakas <alex@zadarastorage.com>
> ---
>  drivers/md/raid1.c |   12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 6af167f..d8d159e 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -427,7 +427,17 @@ static void raid1_end_write_request(struct bio
> *bio, int error)
>=20
>  		r1_bio->bios[mirror] =3D NULL;
>  		to_put =3D bio;
> -		set_bit(R1BIO_Uptodate, &r1_bio->state);
> +		/*
> +		 * Do not set R1BIO_Uptodate if the current device is
> +		 * rebuilding or Faulty. This is because we cannot use
> +		 * such device for properly reading the data back (we could
> +		 * potentially use it, if the current write would have felt
> +		 * before rdev->recovery_offset, but for simplicity we don't
> +		 * check this here.
> +		 */
> +		if (test_bit(In_sync, &conf->mirrors[mirror].rdev->flags) &&
> +			!test_bit(Faulty, &conf->mirrors[mirror].rdev->flags))
> +			set_bit(R1BIO_Uptodate, &r1_bio->state);
>=20
>  		/* Maybe we can clear some bad blocks. */
>  		if (is_badblock(conf->mirrors[mirror].rdev,


hi Alex,
 thanks for the excellent analysis and elegant patch.

I've applied it and create a similar patch for raid10 which has the same
problem.
I'll send them upstream sometime this week.

Thanks,
NeilBrown

--Sig_/YnQopvq1bXX+ATHDojMIaxR
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUbfARTnsnt1WYoG5AQKkpw//QAJZPnTQDtm9BFlRyQ06etpcQfCw+C+d
2qI2Cbv/eMQtXsg/vuq+8ElcZ74A/JXbLANOfYYpaMjw6tGnBbYeZNp/1nhOiJ4Q
5WzQkuQxcCsXrfeWkCBFkmsPD3mFylkAWfVHU94vb9kqF3ddLv2NxsHbyh6myq3R
JkaQoHpqxhHSYJQzF6xJu8sPTjJ8mv/jA1AUan8njnzhE+XqpSOrUtAFTfbIcA5e
WWXTNojYYwFzRoaITRg9J3B28VxJWT6Iqw5hiJmd5NoY7OcnK0wLmdmhkY2qYqa9
638JFgQi25PA930gu5pf0avhQ2deIUphtsSjT4H8TFPnTD9a3iyo8dTAgwNYKdmD
afEx7pvfE7z22PFi5i7gCTFky8KZuWOUM4H86+rA/zrCwYo2HTJMEnCdVBxK3nz4
98YjbXmYVMhHgmkkUywL1XM6+lZNI+3ABBInkhaY63rYgi4bsPcXwSeoj6TfAINW
PjWAkuus1uEMxmZiJGBpVjiThViORsbhktJCvZEa0Wm3VY14w4Ka6WEDjqmfgWUP
etsZ84y9qc6Qc0hvz5IjYx+IgRjz5lXmW++HXRpkli2n81ydLzGsH2FIoMpnERI5
eqGkNqm9WS0C+61GXJ7uyKuOEKviOHk9/pxboRJufQ7dnd87C3PMqCaVRddM3LjH
VsSiGNHOOeA=
=0ahO
-----END PGP SIGNATURE-----

--Sig_/YnQopvq1bXX+ATHDojMIaxR--
