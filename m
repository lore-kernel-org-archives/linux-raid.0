From: NeilBrown <neilb@suse.com>
Subject: Re: [md PATCH 08/10] md/raid5: make chunk_aligned_read() split bios more cleanly.
Date: Thu, 06 Apr 2017 10:13:53 +1000
Message-ID: <87tw62gzpa.fsf@notabene.neil.brown.name>
References: <149136485390.25893.1797855041954158826.stgit@noble> <149136515124.25893.6650408840570246136.stgit@noble>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <149136515124.25893.6650408840570246136.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Missed a split->raid_bio conversion here

Signed-off-by: NeilBrown <neilb@suse.com>

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index c523fd69a7bc..683fbf7f22a8 100644
=2D-- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5247,7 +5247,7 @@ static struct bio *chunk_aligned_read(struct mddev *m=
ddev, struct bio *raid_bio)
 	}
=20
 	if (!raid5_read_one_chunk(mddev, raid_bio))
=2D		return split;
+		return raid_bio;
=20
 	return NULL;
 }

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljliEIACgkQOeye3VZi
gbkFzg//QfezRyyUkrmia5+ZgG/b4gOn+3D9qQX0b+2XBZdF8VG7s3cPVzecFuyA
K5VbBA9H1Z50XRhQltGwxP6NKdNwU0g1aiBuevTWuhbAFfDzRmTjhUvi+YuWQUGk
64WoBzrzQ0upgvXJCYqGhACsrCtsQbx7g2AVv8JVNdX6nwzoJqIgqrFaNOvmkrmr
PG05wdiZWCGnsqOfTMbgdr6o2WDLWuF5pYrBP7fgY5Or/0JrUCOxpLz+bbY8gf5D
350FRa5e6cdsIh7c60qChMlCi1m1auwk0tmipAUmLn+OEkD2sux5Z8dz9SGyDNPs
18K8RG0W/AAeWNH5/CzzPrUeUi7ri/jp1UuvugM/8FQyQRWY53RMLiH7Jruqeisx
PUFVNGM/ErFIsRlQzNjGQngjAGCbfrNjGtXXytPXD60opg+4O5Fe1fdsy7xJvMk2
tdbFGrxHXLuY67mR1BqGc7Ql4NaMlsk8jInslIQAdfla6E7MuBY6uBdy7uCGt14y
8ru/qU2bdPZbjIzspQvFH93QNhGn6zzhmjGapgPwwSsYCuPUBOLjHDQ/1JG3RC4i
u1uWxusR01t5KBLpjJkG3svU5Modoo9L1HPrbCGb4qqZ0ZpSoYzc5h50m6ZDoidX
SGkDaQro51sAY02XnWuU0XtvS7f1wnkqgd5PsHo89+tj9V0VCFs=
=LWe+
-----END PGP SIGNATURE-----
--=-=-=--
