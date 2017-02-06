From: NeilBrown <neilb@suse.com>
Subject: [PATCH] md: ensure md devices are freed before module is unloaded.
Date: Mon, 06 Feb 2017 13:41:39 +1100
Message-ID: <87r33cvy58.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: Guoqing Jiang <gqjiang@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable



Commit: cbd199837750 ("md: Fix unfortunate interaction with evms")
change mddev_put() so that it would not destroy an md device while
=2D>ctime was non-zero.

Unfortunately, we didn't make sure to clear ->ctime when unloading
the module, so it is possible for an md device to remain after
module unload.  An attempt to open such a device will trigger
an invalid memory reference in:
  get_gendisk -> kobj_lookup -> exact_lock -> get_disk

when tring to access disk->fops, which was in the module that has
been removed.

So ensure we clear ->ctime in md_exit(), and explain how that is useful,
as it isn't immediately obvious when looking at the code.

Fixes: cbd199837750 ("md: Fix unfortunate interaction with evms")
Tested-by: Guoqing Jiang <gqjiang@suse.com>
Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 drivers/md/md.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 01175dac0db6..8926fb781cdc 100644
=2D-- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8980,7 +8980,14 @@ static __exit void md_exit(void)
=20
 	for_each_mddev(mddev, tmp) {
 		export_array(mddev);
+		mddev->ctime =3D 0;
 		mddev->hold_active =3D 0;
+		/* for_each_mddev() will call mddev_put() at the
+		 * end of each iteration.  As the mddev is now
+		 * fully clear, this will schedule the mddev for destruction
+		 * by a workqueue, and the destroy_workqueue() below
+		 * will wait for that to complete.
+		 */
 	}
 	destroy_workqueue(md_misc_wq);
 	destroy_workqueue(md_wq);
=2D-=20
2.11.0


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAliX4mMACgkQOeye3VZi
gbkp8Q//Uup7lObC9D0L1oJ0boH6XaMNo38je0Bx7okr/Oha8ebmrxeWypNcH6AN
kc4BLy762nRt607WxuiHykxU/vm8tBmfyjKFCe3QIX2tYVjz6uxEDor+XAU+7meo
q7ElJVZEgsdiBt4tU1xbSHOq9yjVVa3DvANIECfKVsBR/G6c+hkEltaRqcPizsN7
JirPpL5OonqrHuIlOXcaP/in1vgm7Xowzx0EX4pYCYrFGkSddPEHMKGz1l0Rk3zb
sUMX2FKZK34w+u5D164TuKOvbvoDnrx5OpZhVh/ptryzi8O6ue8fTOdxdD3/EBM/
IX5AhLz/7UmN+9t9Ah7FJ07SNzcmjZLH5fcgDXSZ+yB/A7JFVZhV8aDUR5ylAuzl
9nbAFU5WQnq8nnvV2IB662LiuXvMkXKPqEL/5yToloLI3snQqf+R/YxbLxyt36BZ
95c/JzBv37YJsR0poF7ZnEtyBRHmSjjbyy38YKiMxMRFIAZ2QnOIZEDdKrPBtJ+S
AM4UU98hzirYh39ROxu4o+3/wnT6vueG98kMmQz5oyzLby53Zfkw9VbYPzZYA758
Iyh0hhL7eDAUHQ8Z7zsi9UdmaxaK5NRlMWGOaS2pvtWjFc7vk5eVZWYqPqvrggWk
e3v1768N+iAgsTYtx07Xw6HIlmUXWhlBBBoj9TFXV63pQxNHMpM=
=ft7p
-----END PGP SIGNATURE-----
--=-=-=--
