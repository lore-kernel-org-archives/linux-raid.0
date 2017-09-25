From: NeilBrown <neilb@suse.com>
Subject: [mdadm PATCH] mdopen: call "modprobe md_mod" if it might be needed.
Date: Mon, 25 Sep 2017 15:52:19 +1000
Message-ID: <87y3p372b0.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "jes.sorensen@gmail.com" <jes.sorensen@gmail.com>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Creating an array by opening a block-device with major number of 9
will transparently load the md module if needed.
Creating an array by opening
   /sys/module/md_mod/parameters/new_array
and writing to it won't, it will just fail if md_mod isn't loaded.

So when opening that file fails with ENOENT, run "modprobe md_mod" and
try again.

This fixes a bug whereby if you have "CREATE names=3Dyes" in mdadm.conf,
and the md modules isn't loaded, then creating or assembling an
array will not honor the "names=3Dyes" configuration.

Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 mdopen.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mdopen.c b/mdopen.c
index 3c0052f2db23..dcdc6f23e6c1 100644
=2D-- a/mdopen.c
+++ b/mdopen.c
@@ -312,6 +312,10 @@ int create_mddev(char *dev, char *name, int autof, int=
 trustworthy,
 		if (block_udev)
 			udev_block(devnm);
 		fd =3D open("/sys/module/md_mod/parameters/new_array", O_WRONLY);
+		if (fd < 0 && errno =3D=3D ENOENT) {
+			system("modprobe md_mod");
+			fd =3D open("/sys/module/md_mod/parameters/new_array", O_WRONLY);
+		}
 		if (fd >=3D 0) {
 			n =3D write(fd, devnm, strlen(devnm));
 			close(fd);
=2D-=20
2.14.0.rc0.dirty


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlnImZUACgkQOeye3VZi
gbn+6hAAs3qoAdFjxpOyVK70dEe0M9sTlNfEmJx/xF/zA+1ldHRVSYJ9e5wNjPZ7
Gr8xcer/Um0QWwZpTq8ooO8CFAXYzriypdKDtIkjoGN2llUEmadQc1xnwFCrTNzR
N/dY9jXWxsKFxX7h8U0zP8Tr+3kkD7aJzAnY+zCS/JG436sKrlXXBQU2yXCISU7b
sv7BuP6Jw/mLe2an6IGJ+4FxQO8utC41xxU5GcEG97sy2pQnJvez7J+/QVgaYsHy
4mWUvUUKV4JB2Ca9O8YwMhjCWEdfgEbFvvgLU1vIHQ7nH4gNpPNfGCrGBC8/Rkpd
XH/y5/y1A4tJK2riCiJNnDz+qB0hE4CQ+pg49FERWJcV8cMU8fKFidrqjx3Q+FTS
HtND1w5LcFdQJplgClk1fDOx/mAYlN7EWm+JQpl465DNp7f6V3cBq6S1ru3O25KS
muhsHaeuhTkN2e1OgejYMSUx3Zoy2D8bgVo0iYaRjkj458xAkyDv78H/BdIspAE6
sTQJGCnvq+SeaOTQxGeJ3VZ8GdvTaX3iYLu8Sm6KWOjE1Fc808qiWoRUP+3DoBi+
0GLjjfHoewer0h/lLYBynbNunjjzT3pz+3JI6Jx+5h4ebRrhbt8TWSCOAUsG0ikH
LSLsnOGFzrS4wMR4meHz+75+C9GVOlRJqBmtpnOb4/jHp4slNAc=
=5gQc
-----END PGP SIGNATURE-----
--=-=-=--
