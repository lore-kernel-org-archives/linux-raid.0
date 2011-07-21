From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 02/36] md/bad-block-log: add sysfs interface for accessing
 bad-block-log.
Date: Thu, 21 Jul 2011 12:58:47 +1000
Message-ID: <20110721025847.8422.8246.stgit@notabene.brown>
References: <20110721024556.8422.99443.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721024556.8422.99443.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This can show the log (providing it fits in one page) and
allows bad blocks to be 'acknowledged' meaning that they
have safely been recorded in metadata.

Clearing bad blocks is not allowed via sysfs (except for
code testing).  A bad block can only be cleared when
a write to the block succeeds.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/md.c |  127 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 127 insertions(+), 0 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 220fadb..9324635 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2712,6 +2712,35 @@ static ssize_t recovery_start_store(mdk_rdev_t *rdev, const char *buf, size_t le
 static struct rdev_sysfs_entry rdev_recovery_start =
 __ATTR(recovery_start, S_IRUGO|S_IWUSR, recovery_start_show, recovery_start_store);
 
+
+static ssize_t
+badblocks_show(struct badblocks *bb, char *page, int unack);
+static ssize_t
+badblocks_store(struct badblocks *bb, const char *page, size_t len, int unack);
+
+static ssize_t bb_show(mdk_rdev_t *rdev, char *page)
+{
+	return badblocks_show(&rdev->badblocks, page, 0);
+}
+static ssize_t bb_store(mdk_rdev_t *rdev, const char *page, size_t len)
+{
+	return badblocks_store(&rdev->badblocks, page, len, 0);
+}
+static struct rdev_sysfs_entry rdev_bad_blocks =
+__ATTR(bad_blocks, S_IRUGO|S_IWUSR, bb_show, bb_store);
+
+
+static ssize_t ubb_show(mdk_rdev_t *rdev, char *page)
+{
+	return badblocks_show(&rdev->badblocks, page, 1);
+}
+static ssize_t ubb_store(mdk_rdev_t *rdev, const char *page, size_t len)
+{
+	return badblocks_store(&rdev->badblocks, page, len, 1);
+}
+static struct rdev_sysfs_entry rdev_unack_bad_blocks =
+__ATTR(unacknowledged_bad_blocks, S_IRUGO|S_IWUSR, ubb_show, ubb_store);
+
 static struct attribute *rdev_default_attrs[] = {
 	&rdev_state.attr,
 	&rdev_errors.attr,
@@ -2719,6 +2748,8 @@ static struct attribute *rdev_default_attrs[] = {
 	&rdev_offset.attr,
 	&rdev_size.attr,
 	&rdev_recovery_start.attr,
+	&rdev_bad_blocks.attr,
+	&rdev_unack_bad_blocks.attr,
 	NULL,
 };
 static ssize_t
@@ -7775,6 +7806,102 @@ void md_ack_all_badblocks(struct badblocks *bb)
 }
 EXPORT_SYMBOL_GPL(md_ack_all_badblocks);
 
+/* sysfs access to bad-blocks list.
+ * We present two files.
+ * 'bad-blocks' lists sector numbers and lengths of ranges that
+ *    are recorded as bad.  The list is truncated to fit within
+ *    the one-page limit of sysfs.
+ *    Writing "sector length" to this file adds an acknowledged
+ *    bad block list.
+ * 'unacknowledged-bad-blocks' lists bad blocks that have not yet
+ *    been acknowledged.  Writing to this file adds bad blocks
+ *    without acknowledging them.  This is largely for testing.
+ *
+ */
+
+static ssize_t
+badblocks_show(struct badblocks *bb, char *page, int unack)
+{
+	size_t len = 0;
+	int i;
+	u64 *p;
+	int havelock = 0;
+
+	if (bb->shift < 0)
+		return 0;
+
+	rcu_read_lock();
+	p = rcu_dereference(bb->active_page);
+	if (!p) {
+		spin_lock_irq(&bb->lock);
+		p = bb->page;
+		havelock = 1;
+	}
+
+	i = 0;
+
+	while (len < PAGE_SIZE && i < bb->count) {
+		sector_t s = BB_OFFSET(p[i]);
+		unsigned int length = BB_LEN(p[i]);
+		int ack = BB_ACK(p[i]);
+		i++;
+
+		if (unack && ack)
+			continue;
+
+		len += snprintf(page+len, PAGE_SIZE-len, "%llu %u\n",
+				(unsigned long long)s << bb->shift,
+				length << bb->shift);
+	}
+
+	if (havelock)
+		spin_unlock_irq(&bb->lock);
+	rcu_read_unlock();
+
+	return len;
+}
+
+#define DO_DEBUG 1
+
+static ssize_t
+badblocks_store(struct badblocks *bb, const char *page, size_t len, int unack)
+{
+	unsigned long long sector;
+	int length;
+	char newline;
+#ifdef DO_DEBUG
+	/* Allow clearing via sysfs *only* for testing/debugging.
+	 * Normally only a successful write may clear a badblock
+	 */
+	int clear = 0;
+	if (page[0] == '-') {
+		clear = 1;
+		page++;
+	}
+#endif /* DO_DEBUG */
+
+	switch (sscanf(page, "%llu %d%c", &sector, &length, &newline)) {
+	case 3:
+		if (newline != '\n')
+			return -EINVAL;
+	case 2:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+#ifdef DO_DEBUG
+	if (clear) {
+		md_clear_badblocks(bb, sector, length);
+		return len;
+	}
+#endif /* DO_DEBUG */
+	if (md_set_badblocks(bb, sector, length, !unack))
+		return len;
+	else
+		return -ENOSPC;
+}
+
 static int md_notify_reboot(struct notifier_block *this,
 			    unsigned long code, void *x)
 {


