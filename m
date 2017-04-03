From: NeilBrown <neilb@suse.com>
Subject: [PATCH] md/raid6: Fix anomily when recovering a single device in RAID6.
Date: Mon, 03 Apr 2017 12:11:32 +1000
Message-ID: <87r31adyuj.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Brad Campbell <lists2009@fnarfbargle.com>, Linux-RAID <linux-raid@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


When recoverying a single missing/failed device in a RAID6,
those stripes where the Q block is on the missing device are
handled a bit differently.  In these cases it is easy to
check that the P block is correct, so we do.  This results
in the P block be destroy.  Consequently the P block needs
to be read a second time in order to compute Q.  This causes
lots of seeks and hurts performance.

It shouldn't be necessary to re-read P as it can be computed
from the DATA.  But we only compute blocks on missing
devices, since c337869d9501 ("md: do not compute parity
unless it is on a failed drive").

So relax the change made in that commit to allow computing
of the P block in a RAID6 which it is the only missing that
block.

This makes RAID6 recovery run much faster as the disk just
"before" the recovering device is no longer seeking
back-and-forth.

Reported-by-tested-by: Brad Campbell <lists2009@fnarfbargle.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 drivers/md/raid5.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index c523fd69a7bc..aeb2e236a247 100644
=2D-- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3617,9 +3617,20 @@ static int fetch_block(struct stripe_head *sh, struc=
t stripe_head_state *s,
 		BUG_ON(test_bit(R5_Wantcompute, &dev->flags));
 		BUG_ON(test_bit(R5_Wantread, &dev->flags));
 		BUG_ON(sh->batch_head);
+
+		/*
+		 * In the raid6 case if the only non-uptodate disk is P
+		 * then we already trusted P to compute the other failed
+		 * drives. It is safe to compute rather than re-read P.
+		 * In other cases we only compute blocks from failed
+		 * devices, otherwise check/repair might fail to detect
+		 * a real inconsistency.
+		 */
+
 		if ((s->uptodate =3D=3D disks - 1) &&
+		    ((sh->qd_idx >=3D 0 && sh->pd_idx =3D=3D disk_idx) ||
 		    (s->failed && (disk_idx =3D=3D s->failed_num[0] ||
=2D				   disk_idx =3D=3D s->failed_num[1]))) {
+				   disk_idx =3D=3D s->failed_num[1])))) {
 			/* have disk failed, and we're requested to fetch it;
 			 * do compute it
 			 */
=2D-=20
2.12.0


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljhr1QACgkQOeye3VZi
gbm7qw/+K/kKD1UcY4W2I+1Gc5q6iRyWmCIQNNmwwuHv+n+2Htsp8MqLyESMvWB9
ItswE3kU+b1X1EkLXceN8bK2oPDnMXtIe8bCINpW4xeGQ49qP9URZqGHs/aqIBFk
BaFjXjTZpDBeEOKXe/1p1IlC4Iu71HrDiQlrFH8JiMtOt95+zsYCQ7PlowhpyOix
R5IIHo2emJe4bOFf9x0xf2ZIub3onX/IaH+wU+hjI4oBfFa5Fee1e79OEzI5L9cL
PHey1VIxF6k7dxbFYBDUrsTsn2Z2QLIfWBYhIHSibb/Clu+iREl6nFeyAdGSldE6
qd/7gpWluaOra8SprULxHNJFh+S78ag6ECR4n+Ht58UU0RdAKBKAKW7V2Q9ZUpDH
bvu/92EDEHWc4CJihLReq6fce4QGZilS6yeLguWu3vnWlayj1Teh6Gw9neSav+x8
TicVLZonwRbeWUQ0Bi7nMUKM5DiczGbspo+UKuXC/cbzpcQXUzmkjFS5AxEJXuuF
HCYUWqn+7XdZLXaOJxO/RxHvRROvAKtdf1mbo49XdEIzhYOc0z91Omnmb5N6Fb06
kdw4AC01USoeNfZmldR0sidzf0IGtgyg4SpMP+HXfa19nZI9E9EV97mz+rubchzY
HaTQMzhsk1/Thp9/C1D5H985yqurkhmx+HnXuj03MjGzZV2FA0Y=
=mQmz
-----END PGP SIGNATURE-----
--=-=-=--
