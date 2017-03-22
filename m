From: NeilBrown <neilb@suse.com>
Subject: Fix bug in [md PATCH 02/15] md/raid5: simplfy delaying of writes while metadata is updated.
Date: Wed, 22 Mar 2017 12:40:44 +1100
Message-ID: <87tw6may1v.fsf@notabene.neil.brown.name>
References: <148954692173.18641.1294690639716682540.stgit@noble> <148954711228.18641.2048575896322496918.stgit@noble>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <148954711228.18641.2048575896322496918.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, hch@lst.de
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Like all other MD_SB_CHANGE_* flags used in this patch, this should
be MD_SB_CHANGE_PENDING.

Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 drivers/md/raid5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index f990f74901d2..8c5365d7f470 100644
=2D-- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6241,7 +6241,7 @@ static void raid5_do_work(struct work_struct *work)
 			break;
 		handled +=3D batch_size;
 		wait_event_lock_irq(mddev->sb_wait,
=2D				    !test_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags),
+				    !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags),
 				    conf->device_lock);
 	}
 	pr_debug("%d stripes handled\n", handled);
=2D-=20
2.12.0


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljR1hwACgkQOeye3VZi
gblWqw//RNv+qpnvIp5qqIAWArHVSHj4NtPaIhj55die6O6iKL4+QaXEblpPo92V
VdtdISxE2nZGRxo5neoxJuAOrsv+O+TTIa4WuB5ibbbPqlZsgsojrf1jfXxBMBdw
iiJmHxaRf9vTywuATfG4NIkx1e402y7b1z3IjM9j4ComBzqi7pzvULexnXD/AHZH
SscSv4BBhYxEU88bQCthRC7XXJkCdz7SXuhO7tEdaeD6g5piYY/C6Qe8AeWKDFJz
JGAInUNl18kGjgVhifOqdye7y/IQBDwJkmGOGKd2FOAS+uSgUSpStRDH+wrjVJFd
NHwWIdMvhZvYVBSUdJefLgcKodm0AxukVxpPZnE15uSh4JFZUdR5yZOFVU4eJskA
5XIg6GE4HFKWHGKPOhOT6wtr78yjbHWRlt1iwb3OnvbQfvG/7FpVWGf/xluvDc6g
Bz1YBfhaoit8e91VXHB7jTTBU4ZtxI9vXEeHddRdHlFObH8/qPA0QszgspOl8x6I
Xvx+d3hRkQaknv246YPsf4/82byNZ+ythyHtKe6J5/oneQm/Ry3yjsOY67xid/4O
gfCfYRNkqQgb5PtIDEMI96loWDcZ5koIu2pWs9JWtH058paHB/fmdL5Bv2/6z26w
oJ90FVRFItWb2kj9xl+9nTF35+gFnYpg5eugN2gATlld4WzddpE=
=kYoU
-----END PGP SIGNATURE-----
--=-=-=--
