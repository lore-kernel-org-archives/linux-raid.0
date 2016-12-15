From: NeilBrown <neilb@suse.com>
Subject: Re: [BUG] MD/RAID1 hung forever on freeze_array
Date: Thu, 15 Dec 2016 14:20:00 +1100
Message-ID: <87fulpyj33.fsf@notabene.neil.brown.name>
References: <CAMGffE=1kp7gMhG+dFxTvhD6VkRuSfbuXbf9vYSWwGG+=vvhDA@mail.gmail.com> <87a8c20xpg.fsf@notabene.neil.brown.name> <CAMGffEkQ5puQEE0FVfLMV1of1OYOhLMhHdUTAy-YLYPkzBzjDg@mail.gmail.com> <87oa0gzuej.fsf@notabene.neil.brown.name> <CAMGffEm4BDhKJSiDt=2WmxrpRutg862at7JP221gMi6_SpPomQ@mail.gmail.com> <877f73zd5d.fsf@notabene.neil.brown.name> <CAMGffEnCesgUp4gBsPN2L9qg3WSxNXsCcYEPWH-BaeEEktaqcw@mail.gmail.com> <CAMGffE=KoVdoYRzkHdRMuCopjmUdcrP9-woFFr-4-VszGsSHRQ@mail.gmail.com> <CAMGffEnvn4YQ5ADFXrOm2vOeEwApo38V84wB7VF3D1eZihF-Zw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAMGffEnvn4YQ5ADFXrOm2vOeEwApo38V84wB7VF3D1eZihF-Zw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jinpu Wang <jinpu.wang@profitbricks.com>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, Nate Dailey <nate.dailey@stratus.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Hi Neil,
>
> I found a old mail thread below
> http://www.spinics.net/lists/raid/msg52792.html
>
> Likely Alex is trying to fix same bug, right?
> in one reply you suggested to modify the call in make_request
>
> @@ -1207,7 +1207,8 @@ read_again:
>                                 sectors_handled;
>                         goto read_again;
>                 } else
> -                       generic_make_request(read_bio);
> +                       reschedule_retry(r1_bio);
>                 return;
>         }
>
>
> I append above change, it looks fix the bug, I've run same tests over
> one hour,  no hung task anymore.
>
> Do you think this is right fix? Do we still need the change you
> suggested with punt_bios_to_rescuer?

I don't really like that fix.  I suspect it would probably hurt
performance.

I'd prefer to fix generic_make_request() to process queued requests in a
more sensible order.
Can you please try the following (with all other patches removed)?
Thanks,
NeilBrown

diff --git a/block/blk-core.c b/block/blk-core.c
index 14d7c0740dc0..3436b6fc3ef8 100644
=2D-- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2036,10 +2036,31 @@ blk_qc_t generic_make_request(struct bio *bio)
 		struct request_queue *q =3D bdev_get_queue(bio->bi_bdev);
=20
 		if (likely(blk_queue_enter(q, false) =3D=3D 0)) {
+			struct bio_list hold;
+			struct bio_list lower, same;
+
+			/* Create a fresh bio_list for all subordinate requests */
+			bio_list_merge(&hold, &bio_list_on_stack);
+			bio_list_init(&bio_list_on_stack);
 			ret =3D q->make_request_fn(q, bio);
=20
 			blk_queue_exit(q);
=20
+			/* sort new bios into those for a lower level
+			 * and those for the same level
+			 */
+			bio_list_init(&lower);
+			bio_list_init(&same);
+			while ((bio =3D bio_list_pop(&bio_list_on_stack)) !=3D NULL)
+				if (q =3D=3D bdev_get_queue(bio->bi_bdev))
+					bio_list_add(&same, bio);
+				else
+					bio_list_add(&lower, bio);
+			/* now assemble so we handle the lowest level first */
+			bio_list_merge(&bio_list_on_stack, &lower);
+			bio_list_merge(&bio_list_on_stack, &same);
+			bio_list_merge(&bio_list_on_stack, &hold);
+
 			bio =3D bio_list_pop(current->bio_list);
 		} else {
 			struct bio *bio_next =3D bio_list_pop(current->bio_list);

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhSC+MACgkQOeye3VZi
gbmsMw//bGCJA85ZKfK3Z9nC/Nk4hEUfqibXelxJs4bvjwUF74ENPDeo4HCeyUvU
POEVm9rFKyG+Jo0qLguj3tsKu7N7dkpzoM2sUcXKYfSVzkfkdLu4QX94R3J+ahIB
fEpl5i6Tn2VeaRkU7ECe+iQATX8DAR6fp2nfkvumN9D3/WbeiuCxethYMOtB5OOe
/QCKpvYrp7MQZ4tz5K/lIIvBaQiEQozcTgw419C4IHdsQyb5sAJJam/208XIQPoO
WM1DoIHMUIT+J78GLfCbxrNxtykhLgX43XMI9opu7+nAeFImX3UjhSnXj/wBZdpw
6TIyj3l8NPIT0P4gCruWFi+ePOE2+h95rmN4OeiYsuxyJI+QG4M5yirbRkE3iPNa
4I1iWlsZi1nXCLVohDexFNlvTOLHnLxFb8CjINQX/WpYq8gX+y621qzU9N1TlA4Q
jmiMW1suD5HdgN2bdSjOgv13lIF1svdwYrA2qPefctIZoppeF3jn+Rx0TpeljCiV
dR6L4xv9yDmKEmVH6TUyxjX0brvRJ6Ah04OgvtOhzqr9GkfKGGNx8oiEfYQdkcca
zVjke1G6iCwZZ4UHJZNbU2SiOhs3Ax3Yylz5+8/86Y9CaWxV2bm7C9hU5gCnVaTW
ZgzE13DurQKxdd6UwHYLBafn8NZYbZRaMm6fOrLTe4e1QzGSIDo=
=MleK
-----END PGP SIGNATURE-----
--=-=-=--
