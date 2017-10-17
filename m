From: NeilBrown <neilb@suse.com>
Subject: [PATCH] md: forbid a RAID5 from having both a bitmap and a journal.
Date: Tue, 17 Oct 2017 14:24:09 +1100
Message-ID: <87sheijw2u.fsf@notabene.neil.brown.name>
References: <a9a406f5f751d39620d5e4907992ccb1bdbfb5a7.1507670143.git.shli@fb.com> <87bmldnjtq.fsf@notabene.neil.brown.name> <20171012173019.c2bbfyz3hgudjbhz@kernel.org> <ED3BAA5A-9A7B-4FA1-BC4E-299F1A69D9E7@fb.com> <87wp3zlj9q.fsf@notabene.neil.brown.name> <20171013195122.mi7gr4xxm77odx7t@kernel.org> <608CE47A-1C46-4087-B7D3-6FA5936C1DAF@fb.com> <877evulrpm.fsf@notabene.neil.brown.name> <20171016235609.mmo3vbqiekr4li5c@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20171016235609.mmo3vbqiekr4li5c@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Song Liu <songliubraving@fb.com>, linux-raid <linux-raid@vger.kernel.org>, "kumba@gentoo.org" <kumba@gentoo.org>, Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Having both a bitmap and a journal is pointless.
Attempting to do so can corrupt the bitmap if the journal
replay happens before the bitmap is initialized.
Rather than try to avoid this corruption, simply
refuse to allow arrays with both a bitmap and a journal.
So:
 - if raid5_run sees both are present, fail.
 - if adding a bitmap finds a journal is present, fail
 - if adding a journal finds a bitmap is present, fail.

Cc: stable@vger.kernel.org (4.10+)
Signed-off-by: NeilBrown <neilb@suse.com>
=2D--

This patch should replace 8031c3ddc70ab, which should be reverted.

Thanks,
NeilBrown


 drivers/md/bitmap.c | 6 ++++++
 drivers/md/md.c     | 2 +-
 drivers/md/raid5.c  | 7 +++++++
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index cae57b5be817..f425905c97fa 100644
=2D-- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1816,6 +1816,12 @@ struct bitmap *bitmap_create(struct mddev *mddev, in=
t slot)
=20
 	BUG_ON(file && mddev->bitmap_info.offset);
=20
+	if (test_bit(MD_HAS_JOURNAL, &mddev->flags)) {
+		pr_notice("md/raid:%s: array with journal cannot have bitmap\n",
+			  mdname(mddev));
+		return ERR_PTR(-EBUSY);
+	}
+
 	bitmap =3D kzalloc(sizeof(*bitmap), GFP_KERNEL);
 	if (!bitmap)
 		return ERR_PTR(-ENOMEM);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 63ecfb063b76..bf06ff017eda 100644
=2D-- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6384,7 +6384,7 @@ static int add_new_disk(struct mddev *mddev, mdu_disk=
_info_t *info)
 					break;
 				}
 			}
=2D			if (has_journal) {
+			if (has_journal || mddev->bitmap) {
 				export_rdev(rdev);
 				return -EBUSY;
 			}
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 4f40ccd21cbb..e070e5c68801 100644
=2D-- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7134,6 +7134,13 @@ static int raid5_run(struct mddev *mddev)
 			min_offset_diff =3D diff;
 	}
=20
+	if ((test_bit(MD_HAS_JOURNAL, &mddev->flags) || journal_dev) &&
+	    (mddev->bitmap_info.offset || mddev->bitmap_info.file)) {
+		pr_notice("md/raid:%s: array cannot have both journal and bitmap\n",
+			  mdname(mddev));
+		return -EINVAL;
+	}
+
 	if (mddev->reshape_position !=3D MaxSector) {
 		/* Check that we can continue the reshape.
 		 * Difficulties arise if the stripe we would write to
=2D-=20
2.14.0.rc0.dirty


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlnld9sACgkQOeye3VZi
gbl/bg/+M+OFA6EmRANUc7NuD5Kt0rdZXDiAL4Ct1aMtH+3rU1W0UUOHWMiAw8/y
eLokZD99lXnS4/Cu91ywNuWJoTnWBWRFORQ4ooA2VjiF0IOOXPIomLtEQyozaJ81
hCBbUtZ1OZnr0kUeRmBIdwpXGUakFqiafHx6EmkpLrTOAqoyJZMcRrDY+hLet2wV
0vLZj1H9qut8zuHtOMgVfeVL8rJd3NxmNpKufY2XLmo2t82OvRHWnBiUyXYuwh8E
effbZAYzX3123UhkG3l25GEnhNBss9/J9GVhWoDk3wdQd4FFqgZ/GvXGURHIKwSq
wgEVirrL2A+RHf3kkP7TNCQITavE3SVFj6tD02e06ygCopgj0Nm7hc3T30DYdhJc
5OR/M6kuF/QWWt6mrtWN7Hg64P3Pi0xJS9m7ouOVdkGNFVSiCCUEPv8VFtGHIDzf
82BKGEseAucQlpFSRa287f9SBffa+mPzaiy6mr6THZcxnOUfkUmNDx3kads8HEyT
BlZFzHFgI4w5smi+vb8P0mv/2GuuzmBtDhUgMDZvMlRH2ryEmqltB6Z2+eWSXmGf
RkHgzy8ULDralfmeeJyArvO/Wp/srAduw2Leuk6awOL9PlVSdBE7FTD6SlGKkVcY
ytSWrXOI+SvKb5SjGrjiumAjcGdXRwBBQYx9tr0BW2XwH02gsdU=
=s6Eq
-----END PGP SIGNATURE-----
--=-=-=--
