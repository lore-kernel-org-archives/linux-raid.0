From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 13/13] md: fix sync_completed reporting for very large
	drives (>2TB)
Date: Wed, 12 Jan 2011 09:12:47 +1100
Message-ID: <20110111221247.12732.59395.stgit@notabene.brown>
References: <20110111221050.12732.31647.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110111221050.12732.31647.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: =?utf-8?b?UsOpbWk=?= =?utf-8?q?R=C3=A9rolle?= <rrerolle@lacie.com>
List-Id: linux-raid.ids

=46rom: R=C3=A9mi R=C3=A9rolle <rrerolle@lacie.com>

The values exported in the sync_completed file are unsigned long, which
overflows with very large drives, resulting in wrong values reported.

Since sync_completed uses sectors as unit, we'll start getting wrong
values with components larger than 2TB.

This patch simply replaces the use of unsigned long by unsigned long lo=
ng.

Signed-off-by: R=C3=A9mi R=C3=A9rolle <rrerolle@lacie.com>
Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/md.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c0cba8d..126453f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3918,7 +3918,7 @@ static struct md_sysfs_entry md_sync_speed =3D __=
ATTR_RO(sync_speed);
 static ssize_t
 sync_completed_show(mddev_t *mddev, char *page)
 {
-	unsigned long max_sectors, resync;
+	unsigned long long max_sectors, resync;
=20
 	if (!test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
 		return sprintf(page, "none\n");
@@ -3929,7 +3929,7 @@ sync_completed_show(mddev_t *mddev, char *page)
 		max_sectors =3D mddev->dev_sectors;
=20
 	resync =3D mddev->curr_resync_completed;
-	return sprintf(page, "%lu / %lu\n", resync, max_sectors);
+	return sprintf(page, "%llu / %llu\n", resync, max_sectors);
 }
=20
 static struct md_sysfs_entry md_sync_completed =3D __ATTR_RO(sync_comp=
leted);


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
