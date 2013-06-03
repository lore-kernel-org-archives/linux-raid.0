From: NeilBrown <neilb@suse.de>
Subject: Re: RAD1 doesn't fail WRITE that was written only on a rebuilding
 drive
Date: Tue, 4 Jun 2013 09:52:35 +1000
Message-ID: <20130604095235.16261243@notabene.brown>
References: <CAGRgLy6tHN7ZPwxxRM4pzVbKP5fS0PLeXrhKoeZ0XJqVrb0pVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/0iJJvCXnosnFbgihYhaH_DI"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy6tHN7ZPwxxRM4pzVbKP5fS0PLeXrhKoeZ0XJqVrb0pVQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/0iJJvCXnosnFbgihYhaH_DI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 28 May 2013 15:46:33 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hello Neil,
> we continue testing last-drive RAID1 failure cases.
> We see the following issue:
>=20
> # RAID1 with drives A and B; drive B was freshly-added and is rebuilding
> # Drive A fails
> # WRITE request arrives to the array. It is failed by drive A, so
> r1_bio is marked as R1BIO_WriteError, but the rebuilding drive B
> succeeds in writing it, so the same r1_bio is marked as
> R1BIO_Uptodate.
> # r1_bio arrives to handle_write_finished, badblocks are disabled,
> md_error()->error() does nothing because we don't fail the last drive
> of raid1
> # raid_end_bio_io()  calls call_bio_endio()
> # As a result, in call_bio_endio():
> 	if (!test_bit(R1BIO_Uptodate, &r1_bio->state))
> 		clear_bit(BIO_UPTODATE, &bio->bi_flags);
> this code doesn't clear the BIO_UPTODATE flag, and the whole master
> WRITE succeeds, back to the upper layer.
>=20
> # This keeps happening until rebuild aborts, and drive B is ejected
> from the array[1]. After that, there is only one drive (A), so after
> it fails a WRITE, the master WRITE also fails.
>=20
> It should be noted, that I test a WRITE that is way ahead of
> recovery_offset of drive B. So after such WRITE fails, subsequent READ
> to the same place would fail, because drive A will fail it, and drive
> B cannot be attempted to READ from there (rebuild has not reached
> there yet).
>=20
> My concrete suggestion is that this behavior is not reasonable, and we
> should only count a successful WRITE to a drive that is marked as
> InSync. Please let me know what do you think?

Sounds reasonable.  Could you make and test a patch?  Then I'll apply it.

Thanks,
NeilBrown

--Sig_/0iJJvCXnosnFbgihYhaH_DI
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUa0sQznsnt1WYoG5AQK4zg//eKMMn1nkjZUu+PNWJHnkSQeMenYIuVA1
JuhCAWrDasm1ng7Dnir1hSPMkc6Jt5qTjyLsNPXQZ5JMWocWR0OJ+QejHs1LD+vd
tRABNUTYyWKRXZnYLbigivvcYOIe4SKWo8vDCq1NwkG5P3i+O/I214WK3j+WleLh
7caM2it682gGCy4qNfpbQQhe/C3iSpZ8K8tx/KuYUxUPXZJILFout4RBb7oyuZSL
1Pqk2P2GxZj+TiQl67aofv3rIu6D1P+2odwjsFJHDodfOV+6hzOLls1ReMdqak9K
sHSxqMZ9neB4hDJbRUnNb6bffN7WoJzZZKFOUabgZhHL8juQYpDEjDLwrZZPxvZX
bYtgRXE9bxSZikgDq/Mh+9wh0stSLqL1FKLk+C7AiYO76FTDDaVCL6kkic3N+S2k
hr2MIWHnlBjZA3eOdM3zDB55hE8TVWsNmXwy1PH61S9DIsw7NPwwVivQ5y7kIvmx
RWtari7XmfixkIf0F87fgyjHkRL2xC5+3jLYX+hRp+OZJC4+ZRVykVuvU5SCueOy
wA4v+DFMS+CQF6P6wV1SaT6iGBhaQFi9OiwySBTazrPDA5IsojucT98OKgjw+ED3
9ZXZg0K8G6TxdMTXVMsHKUqC/gFBT4aIPcEz391pL0EdhnF+cMb5kYMJRCtCJSqP
6KRoUlsO8j8=
=vM46
-----END PGP SIGNATURE-----

--Sig_/0iJJvCXnosnFbgihYhaH_DI--
