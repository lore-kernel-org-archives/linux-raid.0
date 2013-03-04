From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/4] md/raid5: Reduce one write-operation when handle
 badsector
Date: Mon, 4 Mar 2013 13:25:33 +1100
Message-ID: <20130304132533.571e8070@notabene.brown>
References: <201302281550584027165@gmail.com>
	<20130304124330.7eb81dde@notabene.brown>
	<201303040952542954272@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/.m9KgXSzh4Omn3qmLfSZRPq"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201303040952542954272@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/.m9KgXSzh4Omn3qmLfSZRPq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 4 Mar 2013 09:52:57 +0800 majianpeng <majianpeng@gmail.com> wrote:

> >On Thu, 28 Feb 2013 15:51:01 +0800 majianpeng <majianpeng@gmail.com> wro=
te:
> >
> >> For badsector,it took two steps:rewrite and reread.So for
> >> write-operation,it make no sense to rewrite after write-operation.
> >
> >Please please please please please try to explain yourself better.
> >
> Sorry for that.=20
> >This patch doesn't make any sense.  The write succeeded.  We set the Mad=
eGood
> >flag so that later code will remove the block from the bad-block list.
> >There will be no re-read or re-write.
> >
> For a striep which contain badsector is doing write-operation.
> In analyse_stripe, it check badsector and set R5_ReadError.
>  write--->MadeGood->clear badblock log. But it can't clear R5_ReadError f=
lag.
> So it will exec those code in func handle_stripe:

After you wrote that, did you read it again to see if it makes any sense?  =
It
does but only just.

I'd rather have a good explanation in the code so it is clear what is going
on.

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 3e0ec16..277d9c2 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1911,8 +1911,15 @@ static void raid5_end_write_request(struct bio *bi, =
int error)
 					&rdev->mddev->recovery);
 		} else if (is_badblock(rdev, sh->sector,
 				       STRIPE_SECTORS,
-				       &first_bad, &bad_sectors))
+				       &first_bad, &bad_sectors)) {
 			set_bit(R5_MadeGood, &sh->dev[i].flags);
+			if (test_bit(R5_ReadError, &sh->dev[i].flags))
+				/* That was a successful write so make
+				 * sure it looks like we already did
+				 * a re-write.
+				 */
+				set_bit(R5_ReWrite, &sh->dev[i].flags);
+		}
 	}
 	rdev_dec_pending(rdev, conf->mddev);
=20
Thanks,
NeilBrown

--Sig_/.m9KgXSzh4Omn3qmLfSZRPq
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUTQGHTnsnt1WYoG5AQIyHA/+PXsuJEzWvA2eyUjFQh+yj5HB0C1j/8d8
I6c1i3Ngb/gT9OWk7iJfuGtn4stZ5A3H7c5NV5s9INu+UKABvQ+ZpTjeK2Bx+gjC
UMvr8byUAImfd6zrg9hdJ85dDz0W5WXN8hNvbckIqvjMG8XdA/lUItYvcPZSOHdq
8TnqH1A/7cSXhWkBEWqvMbpqoO6bVlx1y4Vyg8JyND0O2xgA4vwSZphCA+J3zIHk
8BOB87yF7WrxHxFDikMGiXDRX9uToFUXtvDHSBwC5xQjKWCk/MXZBfzYJtaYsUx+
iaJLu7qpWLrJNKOn92+ySiwTYQqb9lP7Ed0nFX5eO5AHi2O08lCvL8UGzfpZtrHg
UHQPeLWRz7JhopXNXl1RF6sbPAS8YYqHvleYqywmjEt4SoQABRZQWN/zkm3J0SrD
Ci0QpPDQJHvvxacQ6gGirTrsrufD578de4PLGndTkuG6bipLlYzSHBSperYYhS1G
YJpRFm/HJvsMInZlB5IcHucF3PySSt03EVxhtKo5yaKuVqyXBmmncBWU2Ai3b3t5
mTHotcPZniRCVVbXFYuEY7nPIULNPcaxyG/gDpkZfq/pxxednT54Wm5LhQdE9Rgl
1y6MUa4Iyl0w0ilm0vQ69A2DiulPlTfSw95rDUWyi7EuwKsmhFni5E6GYVwz4ERK
iQAH72VQ6Rc=
=R9va
-----END PGP SIGNATURE-----

--Sig_/.m9KgXSzh4Omn3qmLfSZRPq--
