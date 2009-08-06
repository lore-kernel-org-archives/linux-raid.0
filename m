From: Andre Noll <maan@systemlinux.org>
Subject: Re: [PATCH/Resend] md: Push down data integrity code to personalities.
Date: Thu, 6 Aug 2009 10:37:10 +0200
Message-ID: <20090806083710.GJ5174@skl-net.de>
References: <20090701083802.GC9910@skl-net.de> <19026.50240.504728.428875@notabene.brown> <20090713085442.GJ9910@skl-net.de> <19058.31706.803177.77914@notabene.brown> <20090803164030.GI5174@skl-net.de> <yq163d4f8q6.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bgQAstJ9X1Eg13Dy"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <yq163d4f8q6.fsf@sermon.lab.mkp.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--bgQAstJ9X1Eg13Dy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 01:28, Martin K. Petersen wrote:
> >>>>> "Andre" =3D=3D Andre Noll <maan@systemlinux.org> writes:
>=20
> [Inlining blk_get_integrity]
>=20
> Andre> IMO this second alternative is be a bit cleaner and it might help
> Andre> other users of blk_get_integrity() as well. Martin, are you OK
> Andre> with this change to blkdev.h?
>=20
> Yeah, that's fine.

So here's a patch that replaces the dummy macros for data integrity
by inline functions. The patch is only compile-tesed, but that's
hopefully OK as the new functions are only used if data integrity is
not compiled in and are thrown away by gcc anyway.

Thanks
Andre

commit e550b6fe0850933d1be4c430a22d25f9040c7627
Author: Andre Noll <maan@systemlinux.org>
Date:   Thu Aug 6 10:32:37 2009 +0200

    [blkdev.h] Replace dummy macros by inline functions.
   =20
    This avoids complaints about unused variables and improves type checkin=
g.

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 69103e0..81d683f 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1191,14 +1191,47 @@ static inline int blk_integrity_rq(struct request *=
rq)
=20
 #else /* CONFIG_BLK_DEV_INTEGRITY */
=20
-#define blk_integrity_rq(rq)			(0)
-#define blk_rq_count_integrity_sg(a)		(0)
-#define blk_rq_map_integrity_sg(a, b)		(0)
-#define bdev_get_integrity(a)			(0)
-#define blk_get_integrity(a)			(0)
-#define blk_integrity_compare(a, b)		(0)
-#define blk_integrity_register(a, b)		(0)
-#define blk_integrity_unregister(a)		do { } while (0);
+static inline int blk_integrity_rq(struct request *rq)
+{
+	return 0;
+}
+
+static inline int blk_rq_count_integrity_sg(struct request *rq)
+{
+	return 0;
+}
+
+static inline
+int blk_rq_map_integrity_sg(struct request *rq, struct scatterlist *sglist)
+{
+	return 0;
+}
+
+static inline
+struct blk_integrity *bdev_get_integrity(struct block_device *bdev)
+{
+	return NULL;
+}
+
+static inline struct blk_integrity *blk_get_integrity(struct gendisk *disk)
+{
+	return NULL;
+}
+
+static inline int blk_integrity_compare(struct gendisk *gd1, struct gendis=
k *gd2)
+{
+	return 0;
+}
+
+static inline
+int blk_integrity_register(struct gendisk *disk, struct blk_integrity *tem=
plate)
+{
+	return 0;
+}
+
+static inline void blk_integrity_unregister(struct gendisk *disk)
+{
+}
=20
 #endif /* CONFIG_BLK_DEV_INTEGRITY */
=20
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--bgQAstJ9X1Eg13Dy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFKepY2Wto1QDEAkw8RAtvJAJ97JY2v2GFHcayB+TVrM5PDw4wz6QCfceMi
T+Cex3dKq05LTe24W4oaViA=
=IoTq
-----END PGP SIGNATURE-----

--bgQAstJ9X1Eg13Dy--
