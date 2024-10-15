Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25F61C7B99;
	Tue, 15 Oct 2024 08:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728981500; cv=none; b=FnwQNalDh7d2J26LDFJ6VzTytsx8V31B6mPC/jE65jQUhMMGaWGx5AnfRP64AP4sT6TvUdxkB1YXGQ2P+zU7tnUaxVk+PloSNJ9Kl3NtwNtINgYTcbOITS8hOfKH8xS+X+mP0XsO/kp6gXKqSnMfmvasWpKadYrlcAfz9ZghzAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728981500; c=relaxed/simple;
	bh=0kodMt5KFIkyOdSxeUCAdg8gW7BihHuPveKiCyuWt0E=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=A9yF5ro/bEB+p1OcX1AA/Zyw9kFhoDAHSoGd2JddoEDlFRd8wTbfLRR2NwkvkqCtVWnPrXtVrFqxc32ULJCZ/KeRyp/Vq8kGQgrZ/yF5rXZMzHB1WJTebAs7/djBHm7FK1qRXiz1DMOblTbvBNFdJdQoIghoMi2VGjMYaR8qvzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4XSSCd6ZqMz4f3mJM;
	Tue, 15 Oct 2024 16:37:49 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id C21251A018D;
	Tue, 15 Oct 2024 16:38:07 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCHusbtKQ5n04WZEA--.35285S4;
	Tue, 15 Oct 2024 16:38:07 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RFC] md: lockless bitmap demo
Date: Tue, 15 Oct 2024 16:35:57 +0800
Message-Id: <20241015083557.4033741-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCHusbtKQ5n04WZEA--.35285S4
X-Coremail-Antispam: 1UD129KBjvAXoWfXr48KF1Dur4DXFy5Jw4xWFg_yoW5Zw13Xo
	WS9r9xXF4rWrn8WrWkAF1FyFy7W3yUKw1Yy34akFZxuF4UAF40qw47GrW3J3s0qFWYgr42
	vr97Xw4fXF48Gry7n29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UjIYCTnIWjp_UUUYr7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20EY4v20xva
	j40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2
	x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8
	Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26r
	xl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v2
	6r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrV
	AFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCI
	c40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267
	AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_
	Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUYCJmUU
	UUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Just implement very basic functions, there are lots of todos.

Very limited functional testing(mdadm tests and some manual tests), and
following performance test for raid10:

Test set up:
1) Four ramdisk:
modprobe brd rd_nr=4 rd_size=10485760

2) old bitmap:
echo 0 > /sys/module/md_mod/parameters/llbitmap
mdadm -Cv /dev/md0 -l 10 -n4 /dev/ram[0123] --assume-clean \
  --bitmap=internal

3) lockless bitmap:
echo 1 > /sys/module/md_mod/parameters/llbitmap
mdadm -Cv /dev/md0 -l 10 -n4 /dev/ram[0123] --assume-clean \
  --bitmap=internal

4) none bitmap:
echo 0 > /sys/module/md_mod/parameters/llbitmap
mdadm -Cv /dev/md0 -l 10 -n4 /dev/ram[0123] --assume-clean --bitmap=none

5) fio cmd:
fio -filename=/dev/ram0 -name=test -bs=4k -rw=randwrite -numjobs=64 \
  -iodepth=128 -ioengine=libaio -direct=1 -runtime=30 -group_report

Test result:

ram disk: 43.4GiB/s
old bitmap: 1786MiB/s
lockless bitmap: 6734MiB/s
none bitmap: 6893MiB/s

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/bdev.c             |  20 +-
 drivers/md/Makefile      |   2 +-
 drivers/md/md-bitmap.c   |  25 +-
 drivers/md/md-bitmap.h   |  42 +++
 drivers/md/md-llbitmap.c | 733 +++++++++++++++++++++++++++++++++++++++
 drivers/md/md-meta.h     |   4 +
 drivers/md/md.c          |  45 +--
 drivers/md/md.h          |   2 +-
 drivers/md/md_meta.c     | 142 ++++++++
 include/linux/blkdev.h   |   1 +
 10 files changed, 970 insertions(+), 46 deletions(-)
 create mode 100644 drivers/md/md-llbitmap.c
 create mode 100644 drivers/md/md-meta.h
 create mode 100644 drivers/md/md_meta.c

diff --git a/block/bdev.c b/block/bdev.c
index 738e3c8457e7..71ad7b866e6b 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -990,12 +990,25 @@ static unsigned blk_to_file_flags(blk_mode_t mode)
 	return flags;
 }
 
+struct file *bdev_file_alloc(struct block_device *bdev, blk_mode_t mode)
+{
+	unsigned int flags = blk_to_file_flags(mode);
+
+	struct file *bdev_file = alloc_file_pseudo_noaccount(BD_INODE(bdev),
+			blockdev_mnt, "", flags | O_LARGEFILE, &def_blk_fops);
+
+	if (!IS_ERR(bdev_file))
+		ihold(BD_INODE(bdev));
+
+	return bdev_file;
+}
+EXPORT_SYMBOL_GPL(bdev_file_alloc);
+
 struct file *bdev_file_open_by_dev(dev_t dev, blk_mode_t mode, void *holder,
 				   const struct blk_holder_ops *hops)
 {
 	struct file *bdev_file;
 	struct block_device *bdev;
-	unsigned int flags;
 	int ret;
 
 	ret = bdev_permission(dev, mode, holder);
@@ -1006,14 +1019,11 @@ struct file *bdev_file_open_by_dev(dev_t dev, blk_mode_t mode, void *holder,
 	if (!bdev)
 		return ERR_PTR(-ENXIO);
 
-	flags = blk_to_file_flags(mode);
-	bdev_file = alloc_file_pseudo_noaccount(BD_INODE(bdev),
-			blockdev_mnt, "", flags | O_LARGEFILE, &def_blk_fops);
+	bdev_file = bdev_file_alloc(bdev, mode);
 	if (IS_ERR(bdev_file)) {
 		blkdev_put_no_open(bdev);
 		return bdev_file;
 	}
-	ihold(BD_INODE(bdev));
 
 	ret = bdev_open(bdev, mode, holder, hops, bdev_file);
 	if (ret) {
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 476a214e4bdc..b20b1ba73189 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -27,7 +27,7 @@ dm-clone-y	+= dm-clone-target.o dm-clone-metadata.o
 dm-verity-y	+= dm-verity-target.o
 dm-zoned-y	+= dm-zoned-target.o dm-zoned-metadata.o dm-zoned-reclaim.o
 
-md-mod-y	+= md.o md-bitmap.o
+md-mod-y	+= md.o md_meta.o md-bitmap.o md-llbitmap.o
 raid456-y	+= raid5.o raid5-cache.o raid5-ppl.o
 
 # Note: link order is important.  All raid personalities
diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 29da10e6f703..39ec094449b0 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1476,24 +1476,6 @@ static bitmap_counter_t *md_bitmap_get_counter(struct bitmap_counts *bitmap,
 					       sector_t offset, sector_t *blocks,
 					       int create);
 
-static void mddev_set_timeout(struct mddev *mddev, unsigned long timeout,
-			      bool force)
-{
-	struct md_thread *thread;
-
-	rcu_read_lock();
-	thread = rcu_dereference(mddev->thread);
-
-	if (!thread)
-		goto out;
-
-	if (force || thread->timeout < MAX_SCHEDULE_TIMEOUT)
-		thread->timeout = timeout;
-
-out:
-	rcu_read_unlock();
-}
-
 /*
  * bitmap daemon -- periodically wakes up to clean bits and flush pages
  *			out to disk
@@ -2964,12 +2946,15 @@ static struct attribute *md_bitmap_attrs[] = {
 	&max_backlog_used.attr,
 	NULL
 };
-const struct attribute_group md_bitmap_group = {
+
+static struct attribute_group md_bitmap_group = {
 	.name = "bitmap",
 	.attrs = md_bitmap_attrs,
 };
 
 static struct bitmap_operations bitmap_ops = {
+	.version		= 1,
+
 	.enabled		= bitmap_enabled,
 	.create			= bitmap_create,
 	.resize			= bitmap_resize,
@@ -2997,6 +2982,8 @@ static struct bitmap_operations bitmap_ops = {
 	.copy_from_slot		= bitmap_copy_from_slot,
 	.set_pages		= bitmap_set_pages,
 	.free			= md_bitmap_free,
+
+	.group			= &md_bitmap_group,
 };
 
 void mddev_set_bitmap_ops(struct mddev *mddev)
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 662e6fc141a7..7d6285398bf1 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -8,6 +8,7 @@
 #define BITMAP_H 1
 
 #define BITMAP_MAGIC 0x6d746962
+#define LLBITMAP_MAGIC 0x6d746963
 
 typedef __u16 bitmap_counter_t;
 #define COUNTER_BITS 16
@@ -71,6 +72,8 @@ struct md_bitmap_stats {
 };
 
 struct bitmap_operations {
+	int version;
+
 	bool (*enabled)(struct mddev *mddev);
 	int (*create)(struct mddev *mddev, int slot);
 	int (*resize)(struct mddev *mddev, sector_t blocks, int chunksize,
@@ -107,9 +110,48 @@ struct bitmap_operations {
 			      sector_t *hi, bool clear_bits);
 	void (*set_pages)(void *data, unsigned long pages);
 	void (*free)(void *data);
+
+	struct attribute_group *group;
 };
 
 /* the bitmap API */
 void mddev_set_bitmap_ops(struct mddev *mddev);
+void mddev_set_llbitmap_ops(struct mddev *mddev);
+
+static inline void mddev_set_timeout(struct mddev *mddev, unsigned long timeout,
+				     bool force)
+{
+	struct md_thread *thread;
+
+	rcu_read_lock();
+	thread = rcu_dereference(mddev->thread);
+
+	if (!thread)
+		goto out;
+
+	if (force || thread->timeout < MAX_SCHEDULE_TIMEOUT)
+		thread->timeout = timeout;
+
+out:
+	rcu_read_unlock();
+}
+
+static inline sector_t super_1_choose_bm_space(sector_t dev_size)
+{
+	sector_t bm_space;
+
+	/* if the device is bigger than 8Gig, save 64k for bitmap
+	 * usage, if bigger than 200Gig, save 128k
+	 */
+	if (dev_size < 64*2)
+		bm_space = 0;
+	else if (dev_size - 64*2 >= 200*1024*1024*2)
+		bm_space = 128*2;
+	else if (dev_size - 4*2 > 8*1024*1024*2)
+		bm_space = 64*2;
+	else
+		bm_space = 4*2;
+	return bm_space;
+}
 
 #endif
diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
new file mode 100644
index 000000000000..b998b9c785a4
--- /dev/null
+++ b/drivers/md/md-llbitmap.c
@@ -0,0 +1,733 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include "md.h"
+#include "md-bitmap.h"
+
+static char bits[3] = {0, 1, 2};
+
+#define LLBITMAP_MAJOR_HI 6
+
+#define BIT_CLEAN bits[0]
+#define BIT_DIRTY bits[1]
+#define BIT_RESYNC bits[2]
+
+struct llbitmap {
+	struct mddev *mddev;
+
+	/* chunksize by sector */
+	unsigned long chunksize;
+	/* chunksize in shift */
+	unsigned long chunkshift;
+	/* total number of bits */
+	unsigned long chunks;
+
+	atomic_t behind_writes;
+	wait_queue_head_t behind_wait;
+
+	unsigned long daemon_lastrun;
+	struct work_struct daemon_work;
+
+	/* bitmap IO from all underlying disks failed */
+	bool io_error;
+};
+
+static bool llbitmap_enabled(struct mddev *mddev)
+{
+	return mddev->bitmap != NULL;
+}
+
+static void daemon_work_fn(struct work_struct *work)
+{
+	struct llbitmap *llbitmap = container_of(work, struct llbitmap, daemon_work);
+	struct mddev *mddev = llbitmap->mddev;
+	struct file *meta_file = mddev->meta_file;
+	loff_t pos = PAGE_SIZE;
+	char c;
+
+	if (!meta_file || !llbitmap || llbitmap->io_error)
+		return;
+
+	/* wait for writes to be done, and clear all bits */
+	mddev_suspend(mddev, false);
+
+	while (pos < llbitmap->chunks + PAGE_SIZE) {
+		ssize_t ret = kernel_read(meta_file, &c, 1, &pos);
+
+		if (ret != 1) {
+			llbitmap->io_error = true;
+			goto out;
+		}
+
+		if (c == BIT_DIRTY) {
+			ret = kernel_write(meta_file, &BIT_CLEAN, 1, &pos);
+			if (ret != 1) {
+				llbitmap->io_error = true;
+				goto out;
+			}
+		}
+
+		pos++;
+	}
+
+	filemap_write_and_wait_range(meta_file->f_mapping, PAGE_SIZE, LLONG_MAX);
+
+out:
+	mddev_resume(mddev);
+}
+
+static int llbitmap_resize(struct mddev *mddev, sector_t blocks, int chunksize,
+			   bool init)
+{
+	struct llbitmap *llbitmap = mddev->bitmap;
+	unsigned long chunks;
+
+	if (!llbitmap)
+		return 0;
+
+	if (mddev->bitmap_info.file) {
+		pr_err("md: doesn't support file-based llbitmap\n");
+		return -EINVAL;
+	}
+
+	if (mddev->bitmap_info.external) {
+		pr_err("md: doesn't support external llbitmap\n");
+		return -EINVAL;
+	}
+
+	if (mddev->bitmap_info.space == 0) {
+		pr_err("md: no space for llbitmap\n");
+		return -EINVAL;
+	}
+
+	if (chunksize != 0) {
+		pr_err("md: todo: set chunksize for llbitmap\n");
+		return -EINVAL;
+	}
+
+	/* make sure all bits are clean before resize */
+	if (!init) {
+		flush_work(&llbitmap->daemon_work);
+		queue_work(md_bitmap_wq, &llbitmap->daemon_work);
+		flush_work(&llbitmap->daemon_work);
+	}
+
+	blocks = roundup_pow_of_two(blocks);
+	chunks = rounddown_pow_of_two(mddev->bitmap_info.space << SECTOR_SHIFT);
+
+	llbitmap->chunks = chunks;
+	do_div(blocks, chunks);
+	llbitmap->chunksize = blocks;
+	if (llbitmap->chunksize == 0) {
+		pr_err("md: blocks less than chunks\n");
+		return -EINVAL;
+	}
+
+	llbitmap->chunkshift = ilog2(llbitmap->chunksize);
+	mddev->bitmap_info.chunksize = llbitmap->chunksize;
+	mddev->bitmap_info.daemon_sleep = 30 * HZ;
+	mddev->bitmap_info.max_write_behind = COUNTER_MAX / 2;
+
+	return 0;
+}
+
+static void llbitmap_dirty_bits(struct mddev *mddev, unsigned long s,
+				unsigned long e)
+{
+	struct file *meta_file = mddev->meta_file;
+	struct llbitmap *llbitmap = mddev->bitmap;
+	loff_t pos = s + PAGE_SIZE;
+	char c;
+
+	if (!meta_file || !llbitmap || llbitmap->io_error)
+		return;
+
+	while (pos <= e + PAGE_SIZE) {
+		ssize_t ret = kernel_read(meta_file, &c, 1, &pos);
+
+		if (ret != 1) {
+			llbitmap->io_error = true;
+			return;
+		}
+
+		if (c != BIT_DIRTY && c != BIT_RESYNC) {
+			ret = kernel_write(meta_file, &BIT_DIRTY, 1, &pos);
+			if (ret != 1) {
+				llbitmap->io_error = true;
+				break;
+			}
+		}
+
+		pos++;
+	}
+}
+
+static int llbitmap_new_sb(struct llbitmap *llbitmap)
+{
+	struct mddev *mddev = llbitmap->mddev;
+	struct file *meta_file = mddev->meta_file;
+	struct page *sb_page;
+	bitmap_super_t *sb;
+	int ret;
+
+	mddev->bitmap_info.space = super_1_choose_bm_space(mddev->resync_max_sectors);
+	ret = llbitmap_resize(mddev, mddev->resync_max_sectors, 0, true);
+	if (ret)
+		return ret;
+
+	sb_page = pagecache_get_page(meta_file->f_mapping, 0,
+				     FGP_LOCK | FGP_CREAT | FGP_WRITE,
+				     GFP_KERNEL);
+	sb = kmap_local_page(sb_page);
+
+	memset(sb, 0, PAGE_SIZE);
+
+	sb->magic = cpu_to_le32(LLBITMAP_MAGIC);
+	sb->version = cpu_to_le32(LLBITMAP_MAJOR_HI);
+	sb->chunksize = cpu_to_le32(llbitmap->chunksize);
+
+	sb->daemon_sleep = cpu_to_le32(mddev->bitmap_info.daemon_sleep);
+	sb->write_behind = cpu_to_le32(mddev->bitmap_info.max_write_behind);
+	sb->sync_size = cpu_to_le64(mddev->resync_max_sectors);
+	sb->events_cleared = cpu_to_le64(mddev->events);
+
+	memcpy(sb->uuid, mddev->uuid, 16);
+
+	kunmap_local(sb);
+	set_page_dirty(sb_page);
+	put_page(sb_page);
+	unlock_page(sb_page);
+
+	/* set all bits for new bitmap. */
+	llbitmap_dirty_bits(mddev, 0, llbitmap->chunks);
+	return filemap_write_and_wait_range(meta_file->f_mapping, 0, LLONG_MAX);
+}
+
+static int llbitmap_read_sb(struct llbitmap *llbitmap)
+{
+	struct mddev *mddev = llbitmap->mddev;
+	struct page *sb_page;
+	bitmap_super_t *sb;
+
+	sb_page = read_mapping_page(mddev->meta_file->f_mapping, 0, NULL);
+	sb = kmap_local_page(sb_page);
+
+	if (sb->magic != cpu_to_le32(LLBITMAP_MAGIC)) {
+		pr_err("%s: %s: bad magic %x\n", __func__, mdname(mddev), le32_to_cpu(sb->magic));
+		goto err_out;
+	}
+
+	if (sb->version != cpu_to_le32(LLBITMAP_MAJOR_HI)) {
+		pr_err("%s: %s: bad version\n", __func__, mdname(mddev));
+		goto err_out;
+	}
+
+	if (sb->sync_size != cpu_to_le64(mddev->resync_max_sectors)) {
+		pr_err("%s: %s: bad size\n", __func__, mdname(mddev));
+		goto err_out;
+	}
+
+	kunmap_local(sb);
+	put_page(sb_page);
+	mddev->bitmap_info.space = super_1_choose_bm_space(mddev->resync_max_sectors);
+	return llbitmap_resize(mddev, mddev->resync_max_sectors, 0, true);
+
+err_out:
+	kunmap_local(sb);
+	put_page(sb_page);
+	return -EINVAL;
+}
+
+static int llbitmap_init_sb(struct llbitmap *llbitmap)
+{
+	int ret;
+
+	ret = llbitmap_read_sb(llbitmap);
+	if (ret != 0)
+		ret = llbitmap_new_sb(llbitmap);
+
+	return ret;
+}
+
+static int llbitmap_create(struct mddev *mddev, int slot)
+{
+	int ret;
+	struct llbitmap *llbitmap;
+
+	/* don't support md-cluster yet */
+	if (slot != -1)
+		return -EOPNOTSUPP;
+
+	llbitmap = kzalloc(sizeof(*llbitmap), GFP_KERNEL);
+	if (!llbitmap)
+		return -ENOMEM;
+
+	atomic_set(&llbitmap->behind_writes, 0);
+	init_waitqueue_head(&llbitmap->behind_wait);
+	INIT_WORK(&llbitmap->daemon_work, daemon_work_fn);
+	llbitmap->mddev = mddev;
+	mddev->bitmap = llbitmap;
+
+	ret = llbitmap_init_sb(llbitmap);
+	if (ret) {
+		mddev->bitmap = NULL;
+		kfree(llbitmap);
+		return ret;
+	}
+
+	mddev_set_timeout(mddev, 30, false);
+
+	return 0;
+}
+
+static int llbitmap_load(struct mddev *mddev)
+{
+	struct file *meta_file = mddev->meta_file;
+	struct llbitmap *llbitmap = mddev->bitmap;
+	loff_t pos = PAGE_SIZE;
+	char c;
+
+	if (!meta_file || !llbitmap || llbitmap->io_error)
+		return 0;
+
+	while (pos < llbitmap->chunks + PAGE_SIZE) {
+		ssize_t ret = kernel_read(meta_file, &c, 1, &pos);
+
+		if (ret != 1) {
+			llbitmap->io_error = true;
+			return -EIO;
+		}
+
+		/* mark dirty bits as need resync. */
+		if (c == BIT_DIRTY) {
+			ret = kernel_write(meta_file, &BIT_RESYNC, 1, &pos);
+			if (ret != 1) {
+				llbitmap->io_error = true;
+				return -EIO;
+			}
+		}
+
+		pos++;
+	}
+
+	return 0;
+}
+
+static void llbitmap_wait_behind_writes(struct mddev *mddev)
+{
+	struct llbitmap *llbitmap = mddev->bitmap;
+
+	if (!llbitmap || !atomic_read(&llbitmap->behind_writes))
+		return;
+
+	wait_event(llbitmap->behind_wait, !atomic_read(&llbitmap->behind_writes));
+}
+
+static void llbitmap_destroy(struct mddev *mddev)
+{
+	struct llbitmap *llbitmap = mddev->bitmap;
+
+	if (!llbitmap)
+		return;
+
+	llbitmap_wait_behind_writes(mddev);
+
+	mutex_lock(&mddev->bitmap_info.mutex);
+
+	/* no new daemon work */
+	mddev->bitmap = NULL;
+	mddev_set_timeout(mddev, MAX_SCHEDULE_TIMEOUT, true);
+
+	/* wait for pending work to be done */
+	flush_work(&llbitmap->daemon_work);
+
+	mutex_unlock(&mddev->bitmap_info.mutex);
+
+	kfree(llbitmap);
+}
+
+static void llbitmap_flush(struct mddev *mddev)
+{
+	struct file *meta_file = mddev->meta_file;
+
+	if (!meta_file)
+		return;
+
+	filemap_write_and_wait_range(meta_file->f_mapping, 0, LLONG_MAX);
+}
+
+/*
+ * This is used to mark pages in memory as needing writeback for md-bitmap.c,
+ * nothing to do here
+ */
+static void llbitmap_write_all(struct mddev *mddev)
+{
+
+}
+
+static void llbitmap_unplug(struct mddev *mddev, bool sync)
+{
+	struct llbitmap *llbitmap = mddev->bitmap;
+	struct file *meta_file = mddev->meta_file;
+
+	if (!llbitmap || llbitmap->io_error || !meta_file)
+		return;
+
+	/* TODO: plug level: file_write_and_wait_range() */
+	filemap_write_and_wait_range(meta_file->f_mapping, PAGE_SIZE, LLONG_MAX);
+}
+
+static void llbitmap_daemon_work(struct mddev *mddev)
+{
+	struct llbitmap *llbitmap = mddev->bitmap;
+
+	if (!llbitmap || llbitmap->io_error || !mddev->meta_file)
+		return;
+
+	mutex_lock(&mddev->bitmap_info.mutex);
+
+	if (time_before(jiffies, llbitmap->daemon_lastrun +
+				 mddev->bitmap_info.daemon_sleep))
+		goto done;
+
+	if (work_busy(&llbitmap->daemon_work))
+		goto done;
+
+	llbitmap->daemon_lastrun = jiffies;
+	queue_work(md_bitmap_wq, &llbitmap->daemon_work);
+
+done:
+	mutex_unlock(&mddev->bitmap_info.mutex);
+}
+
+static int llbitmap_startwrite(struct mddev *mddev, sector_t offset,
+			       unsigned long sectors, bool behind)
+{
+	struct llbitmap *llbitmap = mddev->bitmap;
+	unsigned long start;
+	unsigned long end;
+
+	if (!llbitmap || mddev->meta_file)
+		return 0;
+
+	if (behind)
+		atomic_inc(&llbitmap->behind_writes);
+
+	start = offset >> llbitmap->chunkshift;
+	end = (offset + sectors) >> llbitmap->chunkshift;
+	llbitmap_dirty_bits(mddev, start, end);
+
+	return 0;
+}
+
+static void llbitmap_endwrite(struct mddev *mddev, sector_t offset,
+			      unsigned long sectors, bool success, bool behind)
+{
+	struct llbitmap *llbitmap = mddev->bitmap;
+
+	if (behind && llbitmap && atomic_dec_and_test(&llbitmap->behind_writes))
+		wake_up(&llbitmap->behind_wait);
+}
+
+static bool llbitmap_start_sync(struct mddev *mddev, sector_t offset,
+				sector_t *blocks, bool degraded)
+{
+	struct llbitmap *llbitmap = mddev->bitmap;
+	struct file *meta_file = mddev->meta_file;
+	bool rv = false;
+	loff_t pos;
+	*blocks = 0;
+
+	/* sync all blocks */
+	if (!llbitmap || !meta_file || llbitmap->io_error) {
+		*blocks = 1024;
+		return true;
+	}
+
+	pos = (offset >> llbitmap->chunkshift) + PAGE_SIZE;
+	while (*blocks < PAGE_SIZE >> SECTOR_SHIFT &&
+	       pos < llbitmap->chunks + PAGE_SIZE) {
+		char c;
+		ssize_t ret = kernel_read(meta_file, &c, 1, &pos);
+
+		if (ret != 1) {
+			llbitmap->io_error = true;
+			*blocks = 1024;
+			return true;
+		}
+
+		if (c == BIT_RESYNC)
+			rv = true;
+
+		*blocks += llbitmap->chunksize;
+		pos++;
+	}
+
+	return rv;
+}
+
+static void llbitmap_end_sync(struct mddev *mddev, sector_t offset,
+			      sector_t *blocks)
+{
+	struct llbitmap *llbitmap = mddev->bitmap;
+	struct file *meta_file = mddev->meta_file;
+	loff_t pos = PAGE_SIZE;
+	loff_t end;
+
+	/* sync all blocks */
+	if (!llbitmap || !meta_file || llbitmap->io_error) {
+		*blocks = 1024;
+		return;
+	}
+
+	end = (offset >> llbitmap->chunkshift) + PAGE_SIZE;
+	while (pos <= end) {
+		char c;
+		ssize_t ret = kernel_read(meta_file, &c, 1, &pos);
+
+		if (ret != 1) {
+			llbitmap->io_error = true;
+			*blocks = 1024;
+			return;
+		}
+
+		if (c == BIT_RESYNC) {
+			/* daemon is responsible to clear the bit. */
+			ret = kernel_write(meta_file, &BIT_DIRTY, 1, &pos);
+
+			if (ret != 1) {
+				llbitmap->io_error = true;
+				*blocks = 1024;
+				return;
+			}
+		}
+
+		*blocks += llbitmap->chunksize;
+		pos++;
+	}
+}
+
+static void llbitmap_close_sync(struct mddev *mddev)
+{
+	struct llbitmap *llbitmap = mddev->bitmap;
+	struct file *meta_file = mddev->meta_file;
+	loff_t pos = PAGE_SIZE;
+
+	if (!llbitmap || !meta_file || llbitmap->io_error)
+		return;
+
+	while (pos < llbitmap->chunks + PAGE_SIZE) {
+		char c;
+		ssize_t ret = kernel_read(meta_file, &c, 1, &pos);
+
+		if (ret != 1) {
+			llbitmap->io_error = true;
+			return;
+		}
+
+		if (c == BIT_RESYNC) {
+			ret = kernel_write(meta_file, &BIT_DIRTY, 1, &pos);
+
+			if (ret != 1) {
+				llbitmap->io_error = true;
+				return;
+			}
+		}
+
+		pos++;
+	}
+}
+
+static void llbitmap_cond_end_sync(struct mddev *mddev, sector_t sector,
+				   bool force)
+{
+	sector_t blocks;
+	struct llbitmap *llbitmap = mddev->bitmap;
+	struct file *meta_file = mddev->meta_file;
+
+	if (!llbitmap || !meta_file || llbitmap->io_error)
+		return;
+
+	if (sector == 0 || !force)
+		return;
+
+	wait_event(mddev->recovery_wait,
+		   atomic_read(&mddev->recovery_active) == 0);
+
+	llbitmap_end_sync(mddev, sector, &blocks);
+	mddev->curr_resync_completed = sector;
+	set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
+	sysfs_notify_dirent_safe(mddev->sysfs_completed);
+}
+
+static void llbitmap_update_sb(void *data)
+{
+	bitmap_super_t *sb;
+	struct mddev *mddev;
+	struct page *sb_page;
+	struct llbitmap *llbitmap = data;
+
+	if (!llbitmap || llbitmap->io_error)
+		return;
+
+	mddev = llbitmap->mddev;
+	if (!mddev || !mddev->meta_file)
+		return;
+
+retry:
+	sb_page = read_mapping_page(mddev->meta_file->f_mapping, 0, NULL);
+	if (IS_ERR(sb_page)) {
+		/* other better solution? */
+		if (PTR_ERR(sb_page) == -ENOMEM)
+			goto retry;
+
+		llbitmap->io_error = true;
+		return;
+	}
+
+	sb = kmap_local_page(sb_page);
+
+	sb->chunksize = cpu_to_le32(llbitmap->chunksize);
+	sb->daemon_sleep = cpu_to_le32(mddev->bitmap_info.daemon_sleep);
+	sb->write_behind = cpu_to_le32(mddev->bitmap_info.max_write_behind);
+	sb->sync_size = cpu_to_le64(mddev->resync_max_sectors);
+	sb->events_cleared = cpu_to_le64(mddev->events);
+
+	kunmap_local(sb);
+	set_page_dirty(sb_page);
+	put_page(sb_page);
+
+	if (filemap_write_and_wait_range(mddev->meta_file->f_mapping,
+					 0, PAGE_SIZE) != 0)
+		llbitmap->io_error = true;
+}
+
+static int llbitmap_get_stats(void *data, struct md_bitmap_stats *stats)
+{
+	struct llbitmap *llbitmap = data;
+
+	if (!llbitmap)
+		return -ENOENT;
+
+	memset(stats, 0, sizeof(*stats));
+	stats->behind_writes = atomic_read(&llbitmap->behind_writes);
+	return 0;
+}
+
+static void llbitmap_sync_with_cluster(struct mddev *mddev,
+				       sector_t old_lo, sector_t old_hi,
+				       sector_t new_lo, sector_t new_hi)
+{
+}
+
+static void *llbitmap_get_from_slot(struct mddev *mddev, int slot)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
+static int llbitmap_copy_from_slot(struct mddev *mddev, int slot, sector_t *low,
+				   sector_t *high, bool clear_bits)
+{
+	return -EOPNOTSUPP;
+}
+
+static void llbitmap_set_pages(void *data, unsigned long pages)
+{
+}
+
+static void md_llbitmap_free(void *data)
+{
+}
+
+static ssize_t
+timeout_show(struct mddev *mddev, char *page)
+{
+	ssize_t len;
+	unsigned long secs = mddev->bitmap_info.daemon_sleep / HZ;
+	unsigned long jifs = mddev->bitmap_info.daemon_sleep % HZ;
+
+	len = sprintf(page, "%lu", secs);
+	if (jifs)
+		len += sprintf(page+len, ".%03u", jiffies_to_msecs(jifs));
+	len += sprintf(page+len, "\n");
+	return len;
+}
+
+static ssize_t
+timeout_store(struct mddev *mddev, const char *buf, size_t len)
+{
+	/* timeout can be set at any time */
+	unsigned long timeout;
+	int rv = strict_strtoul_scaled(buf, &timeout, 4);
+
+	if (rv)
+		return rv;
+
+	/* just to make sure we don't overflow... */
+	if (timeout >= LONG_MAX / HZ)
+		return -EINVAL;
+
+	timeout = timeout * HZ / 10000;
+
+	if (timeout >= MAX_SCHEDULE_TIMEOUT)
+		timeout = MAX_SCHEDULE_TIMEOUT-1;
+	if (timeout < 1)
+		timeout = 1;
+
+	mddev->bitmap_info.daemon_sleep = timeout;
+	mddev_set_timeout(mddev, timeout, false);
+	md_wakeup_thread(mddev->thread);
+
+	return len;
+}
+
+static struct md_sysfs_entry llbitmap_timeout =
+__ATTR(time_base, 0644, timeout_show, timeout_store);
+
+static struct attribute *md_llbitmap_attrs[] = {
+	&llbitmap_timeout.attr,
+	NULL
+};
+
+static struct attribute_group md_llbitmap_group = {
+	.name = "llbitmap",
+	.attrs = md_llbitmap_attrs,
+};
+
+static struct bitmap_operations llbitmap_ops = {
+	.version		= 2,
+
+	.enabled		= llbitmap_enabled,
+	.create			= llbitmap_create,
+	.resize			= llbitmap_resize,
+	.load			= llbitmap_load,
+	.destroy		= llbitmap_destroy,
+	.flush			= llbitmap_flush,
+	.write_all		= llbitmap_write_all,
+	.dirty_bits		= llbitmap_dirty_bits,
+	.unplug			= llbitmap_unplug,
+	.daemon_work		= llbitmap_daemon_work,
+	.wait_behind_writes	= llbitmap_wait_behind_writes,
+
+	.startwrite		= llbitmap_startwrite,
+	.endwrite		= llbitmap_endwrite,
+	.start_sync		= llbitmap_start_sync,
+	.end_sync		= llbitmap_end_sync,
+	.cond_end_sync		= llbitmap_cond_end_sync,
+	.close_sync		= llbitmap_close_sync,
+
+	.update_sb		= llbitmap_update_sb,
+	.get_stats		= llbitmap_get_stats,
+
+	.sync_with_cluster	= llbitmap_sync_with_cluster,
+	.get_from_slot		= llbitmap_get_from_slot,
+	.copy_from_slot		= llbitmap_copy_from_slot,
+	.set_pages		= llbitmap_set_pages,
+	.free			= md_llbitmap_free,
+
+	.group			= &md_llbitmap_group,
+};
+
+void mddev_set_llbitmap_ops(struct mddev *mddev)
+{
+	mddev->bitmap_ops = &llbitmap_ops;
+}
diff --git a/drivers/md/md-meta.h b/drivers/md/md-meta.h
new file mode 100644
index 000000000000..fff56499fd10
--- /dev/null
+++ b/drivers/md/md-meta.h
@@ -0,0 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+int md_alloc_meta_file(struct mddev *mddev);
+void md_free_meta_file(struct mddev *mddev);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 35c2e1e761aa..680050dbab31 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -66,6 +66,7 @@
 #include <linux/part_stat.h>
 
 #include "md.h"
+#include "md-meta.h"
 #include "md-bitmap.h"
 #include "md-cluster.h"
 
@@ -102,6 +103,10 @@ static struct workqueue_struct *md_wq;
 static struct workqueue_struct *md_misc_wq;
 struct workqueue_struct *md_bitmap_wq;
 
+static bool llbitmap;
+module_param_named(llbitmap, llbitmap, bool, 0644);
+MODULE_PARM_DESC(llbitmap, "Use experimental lockless bitmap");
+
 static int remove_and_add_spares(struct mddev *mddev,
 				 struct md_rdev *this);
 static void mddev_detach(struct mddev *mddev);
@@ -664,7 +669,10 @@ int mddev_init(struct mddev *mddev)
 	mddev->resync_min = 0;
 	mddev->resync_max = MaxSector;
 	mddev->level = LEVEL_NONE;
-	mddev_set_bitmap_ops(mddev);
+	if (llbitmap)
+		mddev_set_llbitmap_ops(mddev);
+	else
+		mddev_set_bitmap_ops(mddev);
 
 	INIT_WORK(&mddev->sync_work, md_start_sync);
 	INIT_WORK(&mddev->del_work, mddev_delayed_delete);
@@ -2156,24 +2164,6 @@ static void super_1_sync(struct mddev *mddev, struct md_rdev *rdev)
 	sb->sb_csum = calc_sb_1_csum(sb);
 }
 
-static sector_t super_1_choose_bm_space(sector_t dev_size)
-{
-	sector_t bm_space;
-
-	/* if the device is bigger than 8Gig, save 64k for bitmap
-	 * usage, if bigger than 200Gig, save 128k
-	 */
-	if (dev_size < 64*2)
-		bm_space = 0;
-	else if (dev_size - 64*2 >= 200*1024*1024*2)
-		bm_space = 128*2;
-	else if (dev_size - 4*2 > 8*1024*1024*2)
-		bm_space = 64*2;
-	else
-		bm_space = 4*2;
-	return bm_space;
-}
-
 static unsigned long long
 super_1_rdev_size_change(struct md_rdev *rdev, sector_t num_sectors)
 {
@@ -5660,7 +5650,6 @@ static const struct attribute_group md_redundancy_group = {
 
 static const struct attribute_group *md_attr_groups[] = {
 	&md_default_group,
-	&md_bitmap_group,
 	NULL,
 };
 
@@ -5717,6 +5706,7 @@ static void md_kobj_release(struct kobject *ko)
 	if (mddev->sysfs_level)
 		sysfs_put(mddev->sysfs_level);
 
+	md_free_meta_file(mddev);
 	del_gendisk(mddev->gendisk);
 	put_disk(mddev->gendisk);
 }
@@ -5902,10 +5892,25 @@ struct mddev *md_alloc(dev_t dev, char *name)
 		return ERR_PTR(error);
 	}
 
+	if (mddev->bitmap_ops->group)
+		if (sysfs_create_group(&mddev->kobj, mddev->bitmap_ops->group))
+			pr_warn("md: cannot register extra bitmap attributes for %s\n",
+				mdname(mddev));
+
 	kobject_uevent(&mddev->kobj, KOBJ_ADD);
 	mddev->sysfs_state = sysfs_get_dirent_safe(mddev->kobj.sd, "array_state");
 	mddev->sysfs_level = sysfs_get_dirent_safe(mddev->kobj.sd, "level");
 	mutex_unlock(&disks_mutex);
+
+	if (!mddev_is_dm(mddev) && llbitmap) {
+		error = md_alloc_meta_file(mddev);
+		if (error) {
+			mddev->hold_active = 0;
+			mddev_put(mddev);
+			return ERR_PTR(error);
+		}
+	}
+
 	return mddev;
 
 out_put_disk:
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 4ba93af36126..6f96bceca3fc 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -378,6 +378,7 @@ struct mddev {
 						       * takeover/stop are not safe
 						       */
 	struct gendisk			*gendisk;
+	struct file			*meta_file;
 
 	struct kobject			kobj;
 	int				hold_active;
@@ -753,7 +754,6 @@ struct md_sysfs_entry {
 	ssize_t (*show)(struct mddev *, char *);
 	ssize_t (*store)(struct mddev *, const char *, size_t);
 };
-extern const struct attribute_group md_bitmap_group;
 
 static inline struct kernfs_node *sysfs_get_dirent_safe(struct kernfs_node *sd, char *name)
 {
diff --git a/drivers/md/md_meta.c b/drivers/md/md_meta.c
new file mode 100644
index 000000000000..e458a02e20a4
--- /dev/null
+++ b/drivers/md/md_meta.c
@@ -0,0 +1,142 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#include "md.h"
+#include "md-meta.h"
+
+static void meta_end_write(struct bio *bio)
+{
+	struct bio *parent = bio->bi_private;
+
+	if (!bio->bi_status)
+		WRITE_ONCE(parent->bi_status, BLK_STS_OK);
+	else
+		pr_err("TODO: md_error\n");
+
+	bio_put(bio);
+	bio_endio(parent);
+}
+
+static void meta_end_read(struct bio *bio)
+{
+	struct bio *parent = bio->bi_private;
+
+	if (!bio->bi_status)
+		WRITE_ONCE(parent->bi_status, BLK_STS_OK);
+	else
+		pr_err("TODO: try other rdev\n");
+
+	bio_put(bio);
+	bio_endio(parent);
+}
+
+static void md_submit_meta_bio(struct bio *bio)
+{
+	struct bio *new;
+	struct md_rdev *rdev;
+	struct mddev *mddev = bio->bi_bdev->bd_disk->private_data;
+
+	if (unlikely(bio->bi_opf & REQ_PREFLUSH))
+		bio->bi_opf &= ~REQ_PREFLUSH;
+
+	if (!bio_sectors(bio)) {
+		bio_endio(bio);
+		return;
+	}
+
+	/* status will be cleared if any member disk IO succeed */
+	bio->bi_status = BLK_STS_IOERR;
+
+	rdev_for_each(rdev, mddev) {
+		if (rdev->raid_disk < 0 || test_bit(Faulty, &rdev->flags))
+			continue;
+
+		new = bio_alloc_clone(rdev->bdev, bio, GFP_NOIO, &mddev->sync_set);
+		new->bi_iter.bi_sector = bio->bi_iter.bi_sector +
+					 mddev->bitmap_info.offset +
+					 rdev->sb_start;
+		new->bi_opf |= REQ_SYNC | REQ_IDLE | REQ_META;
+		bio_inc_remaining(bio);
+		new->bi_private = bio;
+
+		if (bio_data_dir(bio) == WRITE) {
+			new->bi_end_io = meta_end_write;
+			new->bi_opf |= REQ_FUA;
+			submit_bio_noacct(new);
+		} else {
+			new->bi_end_io = meta_end_read;
+			submit_bio_noacct(new);
+			break;
+		}
+	}
+
+	bio_endio(bio);
+}
+
+const struct block_device_operations md_meta_fops = {
+	.owner		= THIS_MODULE,
+	.submit_bio	= md_submit_meta_bio,
+};
+
+int md_alloc_meta_file(struct mddev *mddev)
+{
+	int ret;
+	struct file *bdev_file;
+	struct gendisk *disk = blk_alloc_disk(&mddev->gendisk->queue->limits,
+					      NUMA_NO_NODE);
+
+	if (!disk)
+		return -ENOMEM;
+
+	sprintf(disk->disk_name, "%s_meta", mdname(mddev));
+	disk->flags |= GENHD_FL_HIDDEN;
+	disk->fops = &md_meta_fops;
+
+	ret = add_disk(disk);
+	if (ret) {
+		put_disk(disk);
+		return ret;
+	}
+
+	/*
+	 * Currently is only used for bitmap IO, so disk size is bitmap size, at
+	 * most 64KB + super block.
+	 */
+	set_capacity(disk, 64 * 2 + (PAGE_SIZE >> SECTOR_SHIFT));
+	bdev_file = bdev_file_alloc(disk->part0, BLK_OPEN_READ | BLK_OPEN_WRITE);
+	if (IS_ERR(bdev_file)) {
+		del_gendisk(disk);
+		put_disk(disk);
+		return PTR_ERR(bdev_file);
+	}
+
+	disk->private_data = mddev;
+	mddev->meta_file = bdev_file;
+
+	/* corresponding to the blkdev_put_no_open() from blkdev_release() */
+	get_device(disk_to_dev(disk));
+
+	bdev_file->f_flags |= O_LARGEFILE;
+	bdev_file->f_mode |= FMODE_CAN_ODIRECT;
+	bdev_file->f_mapping = disk->part0->bd_mapping;
+	bdev_file->f_wb_err = filemap_sample_wb_err(bdev_file->f_mapping);
+
+	/* not actually opened */
+	bdev_file->private_data = ERR_PTR(-ENODEV);
+
+	return 0;
+}
+
+void md_free_meta_file(struct mddev *mddev)
+{
+	struct gendisk *disk;
+	struct file *bdev_file = mddev->meta_file;
+
+	if (!bdev_file)
+		return;
+
+	mddev->meta_file = NULL;
+	disk = file_bdev(bdev_file)->bd_disk;
+
+	fput(bdev_file);
+	del_gendisk(disk);
+	put_disk(disk);
+}
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 6b78a68e0bd9..3b589cb09655 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1597,6 +1597,7 @@ extern const struct blk_holder_ops fs_holder_ops;
 	(BLK_OPEN_READ | BLK_OPEN_RESTRICT_WRITES | \
 	 (((flags) & SB_RDONLY) ? 0 : BLK_OPEN_WRITE))
 
+struct file *bdev_file_alloc(struct block_device *bdev, blk_mode_t mode);
 struct file *bdev_file_open_by_dev(dev_t dev, blk_mode_t mode, void *holder,
 		const struct blk_holder_ops *hops);
 struct file *bdev_file_open_by_path(const char *path, blk_mode_t mode,
-- 
2.39.2

