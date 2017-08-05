From: Shaohua Li <shli@kernel.org>
Subject: [PATCH 5/5] testb: badblock support
Date: Sat,  5 Aug 2017 08:51:49 -0700
Message-ID: <76006963eb89552e91e3d6acf72199a75d45659a.1501945859.git.shli@fb.com>
References: <cover.1501945859.git.shli@fb.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <cover.1501945859.git.shli@fb.com>
In-Reply-To: <cover.1501945859.git.shli@fb.com>
References: <cover.1501945859.git.shli@fb.com>
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-raid@vger.kernel.org
Cc: kernel-team@fb.com, Kyungchan Koh <kyungchan.koh@gmail.com>, Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids

From: Shaohua Li <shli@fb.com>

Sometime disk could have tracks broken and data there is inaccessable,
but data in other parts can be accessed in normal way. MD RAID supports
such disks. But we don't have a good way to test it, because we can't
control which part of a physical disk is bad. For a virtual disk, this
can be easily controlled.

This patch adds a new 'badblock' attribute. Configure it in this way:
echo "+1-100" > xxx/badblock, this will make sector [1-100] as bad
blocks.
echo "-20-30" > xxx/badblock, this will make sector [20-30] good

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/block/test_blk.c | 206 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 200 insertions(+), 6 deletions(-)

diff --git a/drivers/block/test_blk.c b/drivers/block/test_blk.c
index 631dae4..54647e9 100644
--- a/drivers/block/test_blk.c
+++ b/drivers/block/test_blk.c
@@ -16,6 +16,7 @@
 #include <linux/hrtimer.h>
 #include <linux/radix-tree.h>
 #include <linux/idr.h>
+#include <linux/interval_tree_generic.h>
 
 #define SECTOR_SHIFT		9
 #define PAGE_SECTORS_SHIFT	(PAGE_SHIFT - SECTOR_SHIFT)
@@ -112,6 +113,7 @@ struct testb_device {
 	struct testb *testb;
 	struct radix_tree_root pages;
 	struct radix_tree_root cache;
+	struct rb_root badblock_tree;
 	unsigned long flags;
 	unsigned int curr_cache;
 
@@ -238,6 +240,185 @@ static ssize_t testb_device_power_store(struct config_item *item,
 
 CONFIGFS_ATTR(testb_device_, power);
 
+struct testb_bb_range {
+	struct rb_node rb;
+	sector_t start;
+	sector_t end;
+	sector_t __subtree_last;
+};
+#define START(node) ((node)->start)
+#define LAST(node) ((node)->end)
+
+INTERVAL_TREE_DEFINE(struct testb_bb_range, rb, sector_t, __subtree_last,
+		START, LAST, static, testb_bb);
+
+static void testb_bb_adjust_range(struct rb_root *root,
+	struct testb_bb_range *range, sector_t start, sector_t end)
+{
+	testb_bb_remove(range, root);
+	range->start = start;
+	range->end = end;
+	testb_bb_insert(range, root);
+}
+
+static int testb_bb_insert_range(struct testb_device *dev, sector_t start,
+	sector_t end)
+{
+	struct rb_root *root = &dev->badblock_tree;
+	struct testb_bb_range *first, *next;
+	sector_t nstart, nend;
+
+	first = testb_bb_iter_first(root, start, end);
+	if (!first) {
+		first = kmalloc(sizeof(*first), GFP_ATOMIC);
+		if (!first)
+			return  -ENOMEM;
+		first->start = start;
+		first->end = end;
+		testb_bb_insert(first, root);
+		return 0;
+	}
+
+	nstart = min(start, first->start);
+	nend = max(first->end, end);
+	while (true) {
+		next = testb_bb_iter_next(first, start, end);
+		if (!next)
+			break;
+		nend = max(nend, next->end);
+		testb_bb_remove(next, root);
+		kfree(next);
+	}
+	testb_bb_adjust_range(root, first, nstart, nend);
+	return 0;
+}
+
+static int testb_bb_remove_range(struct testb_device *dev, sector_t start,
+	sector_t end)
+{
+	struct testb_bb_range *first;
+	struct rb_root *root = &dev->badblock_tree;
+
+	first = testb_bb_iter_first(root, start, end);
+	while (first) {
+		if (first->start < start && first->end > end) {
+			sector_t tmp = first->end;
+
+			testb_bb_adjust_range(root, first, first->start,
+				start - 1);
+			return testb_bb_insert_range(dev, end + 1, tmp);
+		}
+
+		if (first->start >= start && first->end <= end) {
+			testb_bb_remove(first, root);
+			kfree(first);
+			first = testb_bb_iter_first(root, start, end);
+			continue;
+		}
+
+		if (first->start < start) {
+			testb_bb_adjust_range(root, first, first->start,
+				start - 1);
+			first = testb_bb_iter_first(root, start, end);
+			continue;
+		}
+
+		WARN_ON(first->end <= end);
+		testb_bb_adjust_range(root, first, end + 1, first->end);
+		return 0;
+	}
+	return 0;
+}
+
+static bool testb_bb_in_range(struct testb_device *dev, sector_t start,
+	sector_t end)
+{
+	assert_spin_locked(&dev->lock);
+	return testb_bb_iter_first(&dev->badblock_tree, start, end) != NULL;
+}
+
+static void testb_bb_clear_all(struct testb_device *dev)
+{
+	struct testb_bb_range *iter;
+
+	while ((iter = testb_bb_iter_first(&dev->badblock_tree, 0,
+						~(sector_t)0))) {
+		testb_bb_remove(iter, &dev->badblock_tree);
+		kfree(iter);
+	}
+}
+
+static ssize_t testb_device_badblock_show(struct config_item *item, char *page)
+{
+	struct testb_device *t_dev = to_testb_device(item);
+	ssize_t count = 0, left = PAGE_SIZE;
+	struct testb_bb_range *node;
+	bool first = true;
+
+	spin_lock_irq(&t_dev->lock);
+	for (node = testb_bb_iter_first(&t_dev->badblock_tree, 0, ~(sector_t)0);
+		node; node = testb_bb_iter_next(node, 0, ~(sector_t)0)) {
+		ssize_t ret;
+
+		ret = snprintf(page + count, left, "%s%llu-%llu",
+			first ? "":",", (u64)node->start, (u64)node->end);
+		if (ret < 0)
+			break;
+		count += ret;
+		left -= ret;
+		first = false;
+		/* don't output truncated range */
+		if (left < 50)
+			break;
+	}
+	spin_unlock_irq(&t_dev->lock);
+	return count + sprintf(page + count, "\n");
+}
+
+static ssize_t testb_device_badblock_store(struct config_item *item,
+				     const char *page, size_t count)
+{
+	struct testb_device *t_dev = to_testb_device(item);
+	char *orig, *buf, *tmp;
+	u64 start, end;
+	int ret;
+
+	orig = kstrndup(page, count, GFP_KERNEL);
+	if (!orig)
+		return -ENOMEM;
+
+	buf = strstrip(orig);
+
+	ret = -EINVAL;
+	if (buf[0] != '+' && buf[0] != '-')
+		goto out;
+	tmp = strchr(&buf[1], '-');
+	if (!tmp)
+		goto out;
+	*tmp = '\0';
+	ret = kstrtoull(buf + 1, 0, &start);
+	if (ret)
+		goto out;
+	ret = kstrtoull(tmp + 1, 0, &end);
+	if (ret)
+		goto out;
+	ret = -EINVAL;
+	if (start > end)
+		goto out;
+	spin_lock_irq(&t_dev->lock);
+	if (buf[0] == '+')
+		ret = testb_bb_insert_range(t_dev, start, end);
+	else
+		ret = testb_bb_remove_range(t_dev, start, end);
+	spin_unlock_irq(&t_dev->lock);
+	if (ret == 0)
+		ret = count;
+out:
+	kfree(orig);
+	return ret;
+}
+CONFIGFS_ATTR(testb_device_, badblock);
+
 static struct configfs_attribute *testb_device_attrs[] = {
 	&testb_device_attr_power,
 	&testb_device_attr_size,
@@ -247,6 +428,7 @@ static struct configfs_attribute *testb_device_attrs[] = {
 	&testb_device_attr_discard,
 	&testb_device_attr_mbps,
 	&testb_device_attr_cache_size,
+	&testb_device_attr_badblock,
 	NULL,
 };
 
@@ -254,6 +436,7 @@ static void testb_device_release(struct config_item *item)
 {
 	struct testb_device *t_dev = to_testb_device(item);
 
+	testb_bb_clear_all(t_dev);
 	testb_free_device_storage(t_dev, false);
 	kfree(t_dev);
 }
@@ -308,7 +491,7 @@ testb_group_drop_item(struct config_group *group, struct config_item *item)
 
 static ssize_t memb_group_features_show(struct config_item *item, char *page)
 {
-	return snprintf(page, PAGE_SIZE, "bandwidth,cache\n");
+	return snprintf(page, PAGE_SIZE, "bandwidth,cache,badblock\n");
 }
 
 CONFIGFS_ATTR_RO(memb_group_, features);
@@ -711,12 +894,18 @@ static int copy_from_testb(struct testb *testb, struct page *dest,
 	return 0;
 }
 
-static void testb_handle_discard(struct testb *testb, sector_t sector, size_t n)
+static int testb_handle_discard(struct testb *testb, sector_t sector, size_t n)
 {
 	size_t temp;
 	unsigned long lock_flag;
 
 	spin_lock_irqsave(&testb->t_dev->lock, lock_flag);
+	if (testb_bb_in_range(testb->t_dev, sector,
+				sector + (n >> SECTOR_SHIFT) - 1)) {
+		spin_unlock_irqrestore(&testb->t_dev->lock, lock_flag);
+		return -EIO;
+	}
+
 	while (n > 0) {
 		temp = min_t(size_t, n, testb->t_dev->blocksize);
 		testb_free_sector(testb, sector, false);
@@ -726,6 +915,7 @@ static void testb_handle_discard(struct testb *testb, sector_t sector, size_t n)
 		n -= temp;
 	}
 	spin_unlock_irqrestore(&testb->t_dev->lock, lock_flag);
+	return 0;
 }
 
 static int testb_handle_flush(struct testb *testb)
@@ -780,10 +970,9 @@ static int testb_handle_rq(struct request *rq)
 
 	sector = blk_rq_pos(rq);
 
-	if (req_op(rq) == REQ_OP_DISCARD) {
-		testb_handle_discard(testb, sector, blk_rq_bytes(rq));
-		return 0;
-	} else if (req_op(rq) == REQ_OP_FLUSH)
+	if (req_op(rq) == REQ_OP_DISCARD)
+		return testb_handle_discard(testb, sector, blk_rq_bytes(rq));
+	else if (req_op(rq) == REQ_OP_FLUSH)
 		return testb_handle_flush(testb);
 
 	len = blk_rq_bytes(rq);
@@ -825,6 +1014,11 @@ static int testb_handle_rq(struct request *rq)
 	}
 
 	spin_lock_irqsave(&testb->t_dev->lock, lock_flag);
+	if (testb_bb_in_range(testb->t_dev, sector,
+				sector + blk_rq_sectors(rq) - 1)) {
+		spin_unlock_irqrestore(&testb->t_dev->lock, lock_flag);
+		return -EIO;
+	}
 	rq_for_each_segment(bvec, rq, iter) {
 		len = bvec.bv_len;
 		err = testb_transfer(testb, bvec.bv_page, len, bvec.bv_offset,
-- 
2.9.3
