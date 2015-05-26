From: Eddie Kovsky <ewk@edkovsky.org>
Subject: [PATCH] Fix reversed logic in drivers/md/md.c
Date: Mon, 25 May 2015 22:36:24 -0600
Message-ID: <20150526043624.GA24890@athena>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

=46ixes the following compiler warning in next-20150525 using gcc 5.1.0=
:

drivers/md/md.c: In function =E2=80=98update_array_info=E2=80=99:
drivers/md/md.c:6394:26: warning: logical not is only applied to the
left hand side of comparison [-Wlogical-not-parentheses]
      !mddev->persistent  !=3D info->not_persistent||

Signed-off-by: Eddie Kovsky <ewk@edkovsky.org>
---
 drivers/md/md.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index eb27b2a74492..b0f98b5b8985 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6391,7 +6391,7 @@ static int update_array_info(struct mddev *mddev,=
 mdu_array_info_t *info)
 	    mddev->ctime         !=3D info->ctime         ||
 	    mddev->level         !=3D info->level         ||
 /*	    mddev->layout        !=3D info->layout        || */
-	    !mddev->persistent	 !=3D info->not_persistent||
+	    mddev->persistent	 =3D=3D info->not_persistent||
 	    mddev->chunk_sectors !=3D info->chunk_size >> 9 ||
 	    /* ignore bottom 8 bits of state, and allow SB_BITMAP_PRESENT to =
change */
 	    ((state^info->state) & 0xfffffe00)
--=20
2.4.1

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
