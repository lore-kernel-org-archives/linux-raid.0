From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 12/13] md: allow suspend_lo and suspend_hi to decrease as
	well as increase.
Date: Wed, 12 Jan 2011 09:12:47 +1100
Message-ID: <20110111221247.12732.75960.stgit@notabene.brown>
References: <20110111221050.12732.31647.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110111221050.12732.31647.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The sysfs attributes 'suspend_lo' and 'suspend_hi' describe a region
to which read/writes are suspended so that the under lying data can be
manipulated without user-space noticing.
Currently the window they describe can only move forwards along the
device.  However this is an unnecessary restriction which will cause
problems with planned developments.
So relax this restriction and allow these endpoint to move
arbitrarily.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/md.c |   32 ++++++++++++++++++++------------
 1 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 42b1d9e..c0cba8d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4016,19 +4016,24 @@ suspend_lo_store(mddev_t *mddev, const char *buf, size_t len)
 {
 	char *e;
 	unsigned long long new = simple_strtoull(buf, &e, 10);
+	unsigned long long old = mddev->suspend_lo;
 
 	if (mddev->pers == NULL || 
 	    mddev->pers->quiesce == NULL)
 		return -EINVAL;
 	if (buf == e || (*e && *e != '\n'))
 		return -EINVAL;
-	if (new >= mddev->suspend_hi ||
-	    (new > mddev->suspend_lo && new < mddev->suspend_hi)) {
-		mddev->suspend_lo = new;
+
+	mddev->suspend_lo = new;
+	if (new >= old)
+		/* Shrinking suspended region */
 		mddev->pers->quiesce(mddev, 2);
-		return len;
-	} else
-		return -EINVAL;
+	else {
+		/* Expanding suspended region - need to wait */
+		mddev->pers->quiesce(mddev, 1);
+		mddev->pers->quiesce(mddev, 0);
+	}
+	return len;
 }
 static struct md_sysfs_entry md_suspend_lo =
 __ATTR(suspend_lo, S_IRUGO|S_IWUSR, suspend_lo_show, suspend_lo_store);
@@ -4045,20 +4050,23 @@ suspend_hi_store(mddev_t *mddev, const char *buf, size_t len)
 {
 	char *e;
 	unsigned long long new = simple_strtoull(buf, &e, 10);
+	unsigned long long old = mddev->suspend_hi;
 
 	if (mddev->pers == NULL ||
 	    mddev->pers->quiesce == NULL)
 		return -EINVAL;
 	if (buf == e || (*e && *e != '\n'))
 		return -EINVAL;
-	if ((new <= mddev->suspend_lo && mddev->suspend_lo >= mddev->suspend_hi) ||
-	    (new > mddev->suspend_lo && new > mddev->suspend_hi)) {
-		mddev->suspend_hi = new;
+
+	if (new <= old)
+		/* Shrinking suspended region */
+		mddev->pers->quiesce(mddev, 2);
+	else {
+		/* Expanding suspended region - need to wait */
 		mddev->pers->quiesce(mddev, 1);
 		mddev->pers->quiesce(mddev, 0);
-		return len;
-	} else
-		return -EINVAL;
+	}
+	return len;
 }
 static struct md_sysfs_entry md_suspend_hi =
 __ATTR(suspend_hi, S_IRUGO|S_IWUSR, suspend_hi_show, suspend_hi_store);


