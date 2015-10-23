From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 0/2] raid1/10: Handle write errors correctly in narrow_write_error()
Date: Fri, 23 Oct 2015 11:09:08 +1100
Message-ID: <87d1w6zbrv.fsf@notabene.neil.brown.name>
References: <1445357353-19906-1-git-send-email-Jes.Sorensen@redhat.com> <87pp092sid.fsf@notabene.neil.brown.name> <wrfjpp06lws6.fsf@redhat.com> <87r3kmziux.fsf@notabene.neil.brown.name> <56296510.4030702@stratus.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56296510.4030702@stratus.com>
Sender: linux-raid-owner@vger.kernel.org
To: Nate Dailey <nate.dailey@stratus.com>, Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-raid@vger.kernel.org, William.Kuzeja@stratus.com, xni@redhat.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Nate Dailey <nate.dailey@stratus.com> writes:

> The problem is that we aren't getting true write (medium) errors.
>
> In this case we're testing device removals. The write errors happen becau=
se the=20
> disk goes away. Narrow_write_error returns 1, the bitmap bit is cleared, =
and=20
> then when the device is re-added the resync might not include the sectors=
 in=20
> that chunk (there's some luck involved; if other writes to that chunk hap=
pen=20
> while the disk is removed, we're okay--bug is easier to hit with smaller =
bitmap=20
> chunks because of this).
>
>
OK, that makes sense.

The device removal will be noticed when the bad block log is written
out.
When a bad-block is recorded we make sure to write that out promptly
before bio_endio() gets called.  But not before close_write() has called
bitmap_end_write().

So I guess we need to delay the close_write() call until the
bad-block-log has been written.

I think this patch should do it.  Can you test?

Thanks,
NeilBrown

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index c1ad0b075807..1a1c5160c930 100644
=2D-- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2269,8 +2269,6 @@ static void handle_write_finished(struct r1conf *conf=
, struct r1bio *r1_bio)
 			rdev_dec_pending(conf->mirrors[m].rdev,
 					 conf->mddev);
 		}
=2D	if (test_bit(R1BIO_WriteError, &r1_bio->state))
=2D		close_write(r1_bio);
 	if (fail) {
 		spin_lock_irq(&conf->device_lock);
 		list_add(&r1_bio->retry_list, &conf->bio_end_io_list);
@@ -2396,6 +2394,9 @@ static void raid1d(struct md_thread *thread)
 			r1_bio =3D list_first_entry(&tmp, struct r1bio,
 						  retry_list);
 			list_del(&r1_bio->retry_list);
+			if (mddev->degraded)
+				set_bit(R1BIO_Degraded, &r1_bio->state);
+			close_write(r1_bio);
 			raid_end_bio_io(r1_bio);
 		}
 	}

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWKXqkAAoJEDnsnt1WYoG55voQALrpd9bFBVN4upz3vf+liEpa
pMB0YL51cjMOA+N9WxxnTYfKiWQao3AnhhkrGTNCNwaBDLLwpsyenTnqq1JL8PFG
px+wzENaTslTQ6DbzcZu3xS1Z1uga4FiLZgVs1c9aU1zv25wAWZNqYryn8tEYRPn
Cs6GGeVODhTIBh0txyZgNddFT/ZYoABcWCaHRARSatv3w9qYZ/HEOJmmAvoQE6lt
wSFY0tkgZjVxRe5AGqOLCxGARoBSa9e9y0vzN5IErSlOVHwfjn5xwY6KkRmkocPb
lzbwO60QYPCVXO2gIBCrqHKksylnkzTWlkIhnfQ5Us2/QfPfqF/WLEQWExRVwT35
Q5hGRC7jo1Cz5zjQ4sOHRarybHetGlgXU0WWb1Kz/UONVnlSOeWxouEJl6ziJsRk
oAdKNlWyRQ8mex8aJOkG32lgnvEFrWVHUErMhoA1DGle2ZlroZkipoH4oR16RCNY
z0XjMjkXpT1hPA9GCpt7GxY61aVF24m/29yqHfqGnVwG49jepcGQy8+yb1fCIuTy
+5Q3GrEvz2WNJL7kWuNb2jt8Jsqom8+9nwKyMxzXP03LQeJvnzaJo81hMxQk97Wl
gaGB9QFMK91f2eMUK431OOGkrYe/Ec8oJT2/KvkvHRmWUnvOQLj4ZMailxvPhpB8
S+9GjeoxM0nB6vKChUiN
=plKD
-----END PGP SIGNATURE-----
--=-=-=--
