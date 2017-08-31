From: NeilBrown <neilb@suse.com>
Subject: [PATCH] md/bitmap: disable bitmap_resize for file-backed bitmaps.
Date: Thu, 31 Aug 2017 10:23:25 +1000
Message-ID: <87tw0ofuv6.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Zhilong Liu <zlliu@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


bitmap_resize() does not work for file-backed bitmaps.
The buffer_heads are allocated and initialized when
the bitmap is read from the file, but resize doesn't
read from the file, it loads from the internal bitmap.
When it comes time to write the new bitmap, the bh is
non-existent and we crash.

The common case when growing an array involves making the array larger,
and that normally means making the bitmap larger.  Doing
that inside the kernel is possible, but would need more code.
It is probably easier to require people who use file-backed
bitmaps to remove them and re-add after a reshape.

So this patch disables the resizing of arrays which have
file-backed bitmaps.  This is better than crashing.

Reported-by: Zhilong Liu <zlliu@suse.com>
Fixes: d60b479d177a ("md/bitmap: add bitmap_resize function to allow bitmap=
 resizing.")
Cc: stable@vger.kernel.org (v3.5+).
Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 drivers/md/bitmap.c | 5 +++++
 1 file changed, 5 insertions(+)

It might not be *too* hard to make this work for file-backed bitmaps,
but I'm not sure it is worth the effort, and this is certainly the best
patch to send to -stable.

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 40f3cd7eab0f..cae57b5be817 100644
=2D-- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -2058,6 +2058,11 @@ int bitmap_resize(struct bitmap *bitmap, sector_t bl=
ocks,
 	long pages;
 	struct bitmap_page *new_bp;
=20
+	if (bitmap->storage.file && !init) {
+		pr_info("md: cannot resize file-based bitmap\n");
+		return -EINVAL;
+	}
+
 	if (chunksize =3D=3D 0) {
 		/* If there is enough space, leave the chunk size unchanged,
 		 * else increase by factor of two until there is enough space.
=2D-=20
2.14.0.rc0.dirty


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlmnVv4ACgkQOeye3VZi
gbmu0Q/+IGjqSbgnS4g9I6u0SARfc4OsIAPbsYW2GXT/oZT9+EH5LMoq2ojOrXX3
UfvbiMjmiFVgO9ElVPMGi/lq39g4K2gqcbFh4pC2uiH0bTUsupUDaNkJUAegEjpj
CBDmoG/9QPGeHTMeqsyXFcNepe3CZc34E9gJCLW8dsBoLEQhKHnl/jyfmwDMRfEM
BT6mkqg0rLFaAv/s+Zchwvn5thDcVhL2NfNWAMld8BIVQZAqk1rXPftCjrix+83x
tb3U8eU5omAzFAji3GNkpy/4jHGtNYXp815kjiupVR26dOxp3gh9eVNkl5SgUg+/
UXf/s52tPwFezBZm0nEd/h8gEkshkaUcg+6cvneOVZ9C0l0rcOBkrO+EP/642sdP
TSET0IWEXD80QiuRdcosWwno2MHpMErR9yzSisZLOGG59UcLTL7mA61Zg8ox5RZh
kho6C6vRLrLq2CY5sSRg8VmAbXHMuIHy9kWAkuCoX8uNx2GfvDtxJJQE0VICWtjk
API0dPpcBOJp6LaQUHcJ9pxteEpj52jJF8dKk2IKNtYL62Z/ps3/d/zpRpsuJGBQ
7Rc/NY6rCenHl87vkBQSm4xEwWT9hWYG1QeFRgiW6QuY61SPiHqiJhXo4d7EP9Yx
Jl974z75R2vDxUbA8tK3pSoN7Shn/TAEA+sbIFXQ5L74qPMgKHc=
=u1qh
-----END PGP SIGNATURE-----
--=-=-=--
