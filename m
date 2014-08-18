From: NeilBrown <neilb@suse.de>
Subject: Re: memory leak with linux-3.14.16
Date: Mon, 18 Aug 2014 15:01:57 +1000
Message-ID: <20140818150157.3ef9c9e0@notabene.brown>
References: <201408170855.s7H8t420028767@portal.naev.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_//ljOw7SoPMf2f2RytbOJ=T3"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201408170855.s7H8t420028767@portal.naev.de>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Koch <mdraid.pkoch@dfgh.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_//ljOw7SoPMf2f2RytbOJ=T3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 17 Aug 2014 10:55:04 +0200 mdraid.pkoch@dfgh.net (Peter Koch) wrote:

> Dear Neil,
>=20
> > That won't help.  Data stored in kmalloc-256 won't get swapped out - it=
 stays
> > in RAM.  So unless you can hot-plus 20Gig of RAM ....
>=20
> Thanks for the info. I read it when almost all my memory were in
> kmalloc-256. Half an hour later my machine would have crashed despite
> the increased swapspace. So I could do a graceful reboot and the reshape
> has sucessfully finished in the meantime.
>=20
> Now I'm going to add those three drives to my array one by one. I'm doing
> this because I cannot physically swap drive 13 and 14 (the next maintenan=
ce
> window for such an operation would be in october). I will grow the array
> to 14 drives today since my main concern is to put the data on an even
> number of disks where the mirrors are separated correctly.
>=20
> Then I will add drive 14 and 15 in one step.
>=20
> By the way: Will a raid10 array with an even number of drives survife
> if one half of the drives go offline during a reshape operation that
> adds an even number of drives?

Should do, yes.

>=20
> Should I download linux 3.14.17 sources and wait for a patch? If only
> a missing kfree() has to be added somewhere I can do that by hand and
> recompile 3.14.16.

The following pair of patches should fix your problems.  Should be easy to
apply by hand to whatever kernel you want to use.

>=20
> Would it help you if I setup another machine and try to reproduce the
> problem with linux 3.15.x, 3.16.x and 3.17.x?

No thanks.  memory leaks are quite easy to find - just enable
CONFIG_DEBUG_KMEMLEAK and there they are....
I found about 4 but these are the only important ones.  The second one might
not seem so important from the description, but it is.  Not freeing that
memory causes it to be re-used in a slightly incorrect way.

Thanks for the report.

NeilBrown


=46rom 83a1ebfa292042b11b1e173b3fc50f243cb01c8b Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Mon, 18 Aug 2014 13:56:38 +1000
Subject: [PATCH] md/raid10: fix memory leak when reshaping a RAID10.

raid10 reshape clears unwanted bits from a bio->bi_flags using
a method which, while clumsy, worked until 3.10 when BIO_OWNS_VEC
was added.
Since then it clears that bit but shouldn't.  This results in a
memory leak.

So change to used the approved method of clearing unwanted bits.

As this causes a memory leak which can consume all of memory
the fix is suitable for -stable.

Fixes: a38352e0ac02dbbd4fa464dc22d1352b5fbd06fd
Cc: stable@vger.kernel.org (v3.10+)
Reported-by: mdraid.pkoch@dfgh.net (Peter Koch)
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index b08c18871323..d9073a10f2f2 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4410,7 +4410,7 @@ read_more:
 	read_bio->bi_private =3D r10_bio;
 	read_bio->bi_end_io =3D end_sync_read;
 	read_bio->bi_rw =3D READ;
-	read_bio->bi_flags &=3D ~(BIO_POOL_MASK - 1);
+	read_bio->bi_flags &=3D (~0UL << BIO_RESET_BITS);
 	read_bio->bi_flags |=3D 1 << BIO_UPTODATE;
 	read_bio->bi_vcnt =3D 0;
 	read_bio->bi_iter.bi_size =3D 0;
=46rom afad1968a35676fa39ebe64603ffd7fbf4ceea10 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Mon, 18 Aug 2014 13:59:50 +1000
Subject: [PATCH] md/raid10: Fix memory leak when raid10 reshape completes.

When a raid10 commences a resync/recovery/reshape it allocates
some buffer space.
When a resync/recovery completes the buffer space is freed.  But not
when the reshape completes.
This can result in a small memory leak.

Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index d9073a10f2f2..a46124ecafc7 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2953,6 +2953,7 @@ static sector_t sync_request(struct mddev *mddev, sec=
tor_t sector_nr,
 		 */
 		if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery)) {
 			end_reshape(conf);
+			close_sync(conf);
 			return 0;
 		}
=20

--Sig_//ljOw7SoPMf2f2RytbOJ=T3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU/GIxTnsnt1WYoG5AQJvRg//XcA0bC9VCPnBM73+Pw5ayPHaiQx4sAHN
8gUSjCl0n9PDeI82Prsl5qjE8ggdFRwV/f9cksTXR5w45uV3IaTob+0rgPEfvTzT
Opj8UjR5PlBC+SPizqEXNSbPQbhf+JsFf92b+9VX8DmQXooe6cQnjl8zmc0jdZ8a
ExXZIr76f4vYhoXdIZmsQ22MUxXvRbCiYYWpClI9FpJrwINf0n+UhC4LswOtxXBT
/lZAxYOFoLWH2PTNigECACpC0w/AElH86LKNlEfdLDgfIJjgkaBJ+y2rx7AjMfjk
5fJz1o2S9O0t2VzZnkodmqpghqwhIu2oNBvrEAnilGPxNyUtwfexefbrTrdWVVbU
9wHxr5R2ymCOvjNKY6I5SgOJkLPC5nQwwjhVpJSc2pdDwktGBhHsVRRymZsQs56h
JDOt5oJS+vARnJQ+7KsXhZNldwVoIF1fCpXXR0Y5Jkfc0ErKL3xvW4tsxTI1vXMw
j/3iZAXodCOhkZxDwJDh8H1rzH8mwmPCb8PU54fUmchlXoJux6pSi9v28GiV2XtF
/X3a36vq4vHsEshXBbeXk0rt3zpsgkWlFyViAxXBXvqwUhgAxFbjIOl1ovbqkavO
jpZYjtX+koRoVUnHQZIQETCcZ/LCvMb8G96a0ge9i9VstRky/FOYoM1NkEMGZAWS
l/KOCdffa1A=
=nckP
-----END PGP SIGNATURE-----

--Sig_//ljOw7SoPMf2f2RytbOJ=T3--
