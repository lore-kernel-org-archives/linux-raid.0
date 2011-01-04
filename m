From: =?UTF-8?q?R=C3=A9mi=20R=C3=A9rolle?= <remi.rerolle@gmail.com>
Subject: [PATCH] md: fix sync_completed reporting for very large drives (>2TB)
Date: Tue,  4 Jan 2011 16:44:43 +0100
Message-ID: <1294155883-31421-1-git-send-email-remi.rerolle@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: =?UTF-8?q?R=C3=A9mi=20R=C3=A9rolle?= <rrerolle@lacie.com>
List-Id: linux-raid.ids

=46rom: R=C3=A9mi R=C3=A9rolle <rrerolle@lacie.com>

The values exported in the sync_completed file are unsigned long, which
overflows with very large drives, resulting in wrong values reported.

Since sync_completed uses sectors as unit, we'll start getting wrong
values with components larger than 2TB.

This patch simply replaces the use of unsigned long by unsigned long lo=
ng.

Signed-off-by: R=C3=A9mi R=C3=A9rolle <rrerolle@lacie.com>
---
 drivers/md/md.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 175c424..ea46b3b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3912,7 +3912,7 @@ static struct md_sysfs_entry md_sync_speed =3D __=
ATTR_RO(sync_speed);
 static ssize_t
 sync_completed_show(mddev_t *mddev, char *page)
 {
-	unsigned long max_sectors, resync;
+	unsigned long long max_sectors, resync;
=20
 	if (!test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
 		return sprintf(page, "none\n");
@@ -3923,7 +3923,7 @@ sync_completed_show(mddev_t *mddev, char *page)
 		max_sectors =3D mddev->dev_sectors;
=20
 	resync =3D mddev->curr_resync_completed;
-	return sprintf(page, "%lu / %lu\n", resync, max_sectors);
+	return sprintf(page, "%llu / %llu\n", resync, max_sectors);
 }
=20
 static struct md_sysfs_entry md_sync_completed =3D __ATTR_RO(sync_comp=
leted);
--=20
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
