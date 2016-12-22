From: NeilBrown <neilb@suse.com>
Subject: [mdadm PATCH] Make get_component_size() work with named array.
Date: Thu, 22 Dec 2016 13:14:59 +1100
Message-ID: <87wpespv4s.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Robert LeBlanc <robert@leblancnet.us>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


get_component_size() still assumes that all array are
 /sys/block/md%d or /sys/block/md_d%d
and so doesn't work with e.g. /sys/block/md_foo.

This cause "mdadm --detail" to report
   Used Dev Size : unknown
and causes problems when added spares and in other circumstances.

So change it to use stat2devnm() which does the right thing with all
types of array names.

Reported-and-tested-by: Robert LeBlanc <robert@leblancnet.us>
Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 sysfs.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/sysfs.c b/sysfs.c
index 84c7348526c9..b0657a04b3a3 100644
=2D-- a/sysfs.c
+++ b/sysfs.c
@@ -400,14 +400,8 @@ unsigned long long get_component_size(int fd)
 	int n;
 	if (fstat(fd, &stb))
 		return 0;
=2D	if (major(stb.st_rdev) !=3D (unsigned)get_mdp_major())
=2D		snprintf(fname, MAX_SYSFS_PATH_LEN,
=2D			"/sys/block/md%d/md/component_size",
=2D			(int)minor(stb.st_rdev));
=2D	else
=2D		snprintf(fname, MAX_SYSFS_PATH_LEN,
=2D			"/sys/block/md_d%d/md/component_size",
=2D			(int)minor(stb.st_rdev)>>MdpMinorShift);
+	snprintf(fname, MAX_SYSFS_PATH_LEN,
+		 "/sys/block/%s/md/component_size", stat2devnm(&stb));
 	fd =3D open(fname, O_RDONLY);
 	if (fd < 0)
 		return 0;
=2D-=20
2.11.0


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhbNyMACgkQOeye3VZi
gbk6Tg//Y7q6CpjzSRdTvuWyMYQYk/irOkunTd5uDtgdpXBCWBRLkkIW9D14PLiB
gT4FxMU2WtFDg/0CRGDM5JaLZXfmBwZ9MRqcMbjGFWheT9MMh/GD6cWDJkAOE+ca
dfTXPPhSUUEB2qJSFf0mUr2zpFoOi5exZYZPKCzgPgeUNM9WpNv5phJ1dm4pd456
ydLjuXnT72yozeeTUtruz6BclkxX7rdgBnzrUTHho96UKO6X5Ohm1rlajlBEdHaQ
QFUgprVWfT++L36O+YmPABsgiKjoc/n7XbPbDCVcbdWXhvnCYRtA8KYUrPdYoMwi
hkHj2aeE65Rr06ZHqVH+BjVzRsTBgHiqv24U5xqTXvWYXOTRfSVDa5GKRAJ849UN
/15mH4j8CQ9X0R6YByO9JUy8v6y6fpu+l/2gQTIP3eQoy8o7V4uH2OHh57wbgmTh
dFum4+nzDNxmQaT9q9aJm2aA/u9RJ/7LPidhfxnfGj6zEFs69Eqdd9aCFLQZ84Ui
/g+9UO0QVebFBKQAP1k4DWpC+e+ZOkor1qpba+w8IGjWOB3QJx6d+8PYvnfRcOEh
Wm7Ek4w6QjPRZM5UEsajAyp2QruuVfUahSbbKZK2QhO3G7crHr2384JgUVRrLDWB
NZVbZ+uFES8XazGfpLR4W5chl+9A5pBhTiGKuw0lNHakmiHjuew=
=ojFj
-----END PGP SIGNATURE-----
--=-=-=--
