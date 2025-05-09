Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D88728E57A;
	Fri,  9 May 2025 10:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746786161; cv=none; b=FQbuVGrRrrDmuEwhs2fO7Yn58V9yXZBNzMeSeVHWhZfOe2s2tMnK6RMIolQt3A+0WLBgSzJb4UkkVNhCPDZQ3ll/H4yIt9fo+vM93c/r1Bkcghl3eHa6gyxZHnZI9GTmOp8aD3eRcj/garI598X7u9Qf8FzvCGYSJvbgMdBOhmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746786161; c=relaxed/simple;
	bh=/WP4DrNHI624YiUw9Qrw3Ri2OKUhK+p/AT6nU4QBfuw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HEz4aERXSjG60PdfwrYGKo+v1aYnfbl6dhBoWS0SQHlsGIq2+qArHXvWYM0VIliWE6CS/XRGL6RH2WyO+59YEufBmN96Xs4XJFaROZ8jLdbZopYeLXgVatCEtVklhHYVsS65zNVGPXcvd0JwNaG4AHdudHHflRgrtFSpcj9UiNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Zv4n30Lwcz4f3jt8;
	Fri,  9 May 2025 18:22:15 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 68C1F1A07C0;
	Fri,  9 May 2025 18:22:34 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDHKl9o1x1onzmRLw--.15694S4;
	Fri, 09 May 2025 18:22:34 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: mtkaczyk@kernel.org,
	linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH RFC v3] mdadm: add support for new lockless bitmap
Date: Fri,  9 May 2025 18:14:11 +0800
Message-Id: <20250509101411.2093911-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHKl9o1x1onzmRLw--.15694S4
X-Coremail-Antispam: 1UD129KBjvJXoW3Jr18Aw45WryDZr1kGFykKrg_yoWfKry8pF
	4jvr95Cr4rGr4fWw17t3y8ZF1rtw1vyFn2krZ7Zw1akF1YqrnIqF18GFyUA34fWr4kJFy2
	9rs8Kw18u3yxXrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkG14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWU
	AVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4U
	MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUBVbkUUU
	UU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

A new major number 6 is used for the new bitmap.

Noted that for the kernel that doesn't support lockless bitmap, create
such array will fail:

md0: invalid bitmap file superblock: unrecognized superblock version.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
Changes in v3:
 - add support for --assume-clean
Changes in v2:
 - add support for Incremental mode;
 - use sysfs API bitmap_version to notify kernel to use llbitmap;

 Assemble.c    |  5 +++++
 Create.c      | 10 ++++++++--
 Grow.c        |  5 +++--
 Incremental.c | 34 ++++++++++++++++++++++++++++++++++
 bitmap.h      | 14 ++++++++++++--
 mdadm.c       |  9 ++++++++-
 mdadm.h       |  5 ++++-
 super-intel.c |  2 +-
 super0.c      |  2 +-
 super1.c      | 18 +++++++++++++++++-
 10 files changed, 93 insertions(+), 11 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index f8099cd3..3af36260 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1029,6 +1029,11 @@ static int start_array(int mdfd,
 	int i;
 	unsigned int req_cnt;
 
+	if (st->ss->get_bitmap_version &&
+	    st->ss->get_bitmap_version(st) == BITMAP_MAJOR_LOCKLESS &&
+	    sysfs_set_str(content, NULL, "bitmap_version", "llbitmap"))
+		return 1;
+
 	if (content->journal_device_required && (content->journal_clean == 0)) {
 		if (!c->force) {
 			pr_err("Not safe to assemble with missing or stale journal device, consider --force.\n");
diff --git a/Create.c b/Create.c
index fd6c9215..1537526a 100644
--- a/Create.c
+++ b/Create.c
@@ -541,6 +541,8 @@ int Create(struct supertype *st, struct mddev_ident *ident, int subdevs,
 			pr_err("At least 2 nodes are needed for cluster-md\n");
 			return 1;
 		}
+	} else if (s->btype == BitmapLockless) {
+		major_num = BITMAP_MAJOR_LOCKLESS;
 	}
 
 	memset(&info, 0, sizeof(info));
@@ -1182,7 +1184,8 @@ int Create(struct supertype *st, struct mddev_ident *ident, int subdevs,
 	 * to stop another mdadm from finding and using those devices.
 	 */
 
-	if (s->btype == BitmapInternal || s->btype == BitmapCluster) {
+	if (s->btype == BitmapInternal || s->btype == BitmapCluster ||
+	    s->btype == BitmapLockless) {
 		if (!st->ss->add_internal_bitmap) {
 			pr_err("internal bitmaps not supported with %s metadata\n",
 				st->ss->name);
@@ -1190,10 +1193,13 @@ int Create(struct supertype *st, struct mddev_ident *ident, int subdevs,
 		}
 		if (st->ss->add_internal_bitmap(st, &s->bitmap_chunk,
 						c->delay, s->write_behind,
-						bitmapsize, 1, major_num)) {
+						bitmapsize, 1, major_num, s->assume_clean)) {
 			pr_err("Given bitmap chunk size not supported.\n");
 			goto abort_locked;
 		}
+		if (s->btype == BitmapLockless &&
+		    sysfs_set_str(&info, NULL, "bitmap_version", "llbitmap") < 0)
+			goto abort_locked;
 	}
 
 	if (sysfs_init(&info, mdfd, NULL)) {
diff --git a/Grow.c b/Grow.c
index cc1be6cc..4422fa09 100644
--- a/Grow.c
+++ b/Grow.c
@@ -383,7 +383,8 @@ int Grow_addbitmap(char *devname, int fd, struct context *c, struct shape *s)
 		free(mdi);
 	}
 
-	if (s->btype == BitmapInternal || s->btype == BitmapCluster) {
+	if (s->btype == BitmapInternal || s->btype == BitmapCluster ||
+	    s->btype == BitmapLockless) {
 		int rv;
 		int d;
 		int offset_setable = 0;
@@ -425,7 +426,7 @@ int Grow_addbitmap(char *devname, int fd, struct context *c, struct shape *s)
 				rv = st->ss->add_internal_bitmap(
 					st, &s->bitmap_chunk, c->delay,
 					s->write_behind, bitmapsize,
-					offset_setable, major);
+					offset_setable, major, 0);
 				if (!rv) {
 					st->ss->write_bitmap(st, fd2,
 							     NodeNumUpdate);
diff --git a/Incremental.c b/Incremental.c
index 228d2bdd..de2edecb 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -552,6 +552,40 @@ int Incremental(struct mddev_dev *devlist, struct context *c,
 			if (d->disk.state & (1<<MD_DISK_REMOVED))
 				remove_disk(mdfd, st, sra, d);
 
+		if (st->ss->get_bitmap_version) {
+			if (st->sb == NULL) {
+				dfd = dev_open(devname, O_RDONLY);
+				if (dfd < 0) {
+					rv = 1;
+					goto out;
+				}
+
+				rv = st->ss->load_super(st, dfd, NULL);
+				close(dfd);
+				dfd = -1;
+				if (rv) {
+					pr_err("load super failed %d\n", rv);
+					goto out;
+				}
+			}
+
+			if (st->ss->get_bitmap_version(st) == BITMAP_MAJOR_LOCKLESS) {
+				if (sra == NULL) {
+					sra = sysfs_read(mdfd, NULL, (GET_DEVS | GET_STATE |
+								    GET_OFFSET | GET_SIZE));
+					if (!sra) {
+						pr_err("can't read mdinfo\n");
+						rv = 1;
+						goto out;
+					}
+				}
+
+				rv = sysfs_set_str(sra, NULL, "bitmap_version", "llbitmap");
+				if (rv)
+					goto out;
+			}
+		}
+
 		if ((sra == NULL || active_disks >= info.array.working_disks) &&
 		    trustworthy != FOREIGN)
 			rv = ioctl(mdfd, RUN_ARRAY, NULL);
diff --git a/bitmap.h b/bitmap.h
index 7b1f80f2..cefad194 100644
--- a/bitmap.h
+++ b/bitmap.h
@@ -13,6 +13,7 @@
 #define BITMAP_MAJOR_HI 4
 #define	BITMAP_MAJOR_HOSTENDIAN 3
 #define	BITMAP_MAJOR_CLUSTERED 5
+#define	BITMAP_MAJOR_LOCKLESS 6
 
 #define BITMAP_MINOR 39
 
@@ -139,8 +140,17 @@ typedef __u16 bitmap_counter_t;
 
 /* use these for bitmap->flags and bitmap->sb->state bit-fields */
 enum bitmap_state {
-	BITMAP_ACTIVE = 0x001, /* the bitmap is in use */
-	BITMAP_STALE  = 0x002  /* the bitmap file is out of date or had -EIO */
+	/* the bitmap file is out of date or had -EIO */
+	BITMAP_STALE		= 1,
+	/* A write error has occurred */
+	BITMAP_WRITE_ERROR	= 2,
+	/* llbitmap is just created */
+	BITMAP_FIRST_USE	= 3,
+	/* assume-clean is set while creating new llbitmap */
+	BITMAP_CLEAN		= 4,
+	/* used by kernel */
+	BITMAP_DAEMON_BUSY	= 5,
+	BITMAP_HOSTENDIAN	= 15,
 };
 
 /* the superblock at the front of the bitmap file -- little endian */
diff --git a/mdadm.c b/mdadm.c
index 1fd4dcba..7a64fba2 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -56,6 +56,12 @@ static mdadm_status_t set_bitmap_value(struct shape *s, struct context *c, char
 		return MDADM_STATUS_SUCCESS;
 	}
 
+	if (strcmp(val, "lockless") == 0) {
+		s->btype = BitmapLockless;
+		pr_info("Experimental lockless bitmap, use at your own disk!\n");
+		return MDADM_STATUS_SUCCESS;
+	}
+
 	if (strcmp(val, "clustered") == 0) {
 		s->btype = BitmapCluster;
 		/* Set the default number of cluster nodes
@@ -1251,7 +1257,8 @@ int main(int argc, char *argv[])
 			pr_err("--bitmap is required for consistency policy: %s\n",
 			       map_num_s(consistency_policies, s.consistency_policy));
 			exit(2);
-		} else if ((s.btype == BitmapInternal || s.btype == BitmapCluster) &&
+		} else if ((s.btype == BitmapInternal || s.btype == BitmapCluster ||
+			    s.btype == BitmapLockless) &&
 			   s.consistency_policy != CONSISTENCY_POLICY_BITMAP &&
 			   s.consistency_policy != CONSISTENCY_POLICY_JOURNAL) {
 			pr_err("--bitmap is not compatible with consistency policy: %s\n",
diff --git a/mdadm.h b/mdadm.h
index 77705b11..af97481b 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -607,6 +607,7 @@ enum bitmap_type {
 	BitmapNone,
 	BitmapInternal,
 	BitmapCluster,
+	BitmapLockless,
 	BitmapUnknown,
 };
 
@@ -1201,7 +1202,9 @@ extern struct superswitch {
 	 */
 	int (*add_internal_bitmap)(struct supertype *st, int *chunkp,
 				   int delay, int write_behind,
-				   unsigned long long size, int may_change, int major);
+				   unsigned long long size, int may_change,
+				   int major, bool assume_clean);
+	int (*get_bitmap_version)(struct supertype *st);
 	/* Perform additional setup required to activate a bitmap.
 	 */
 	int (*set_bitmap)(struct supertype *st, struct mdinfo *info);
diff --git a/super-intel.c b/super-intel.c
index 7e3c5f2b..08215271 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -12977,7 +12977,7 @@ static int validate_internal_bitmap_imsm(struct supertype *st)
 static int add_internal_bitmap_imsm(struct supertype *st, int *chunkp,
 				    int delay, int write_behind,
 				    unsigned long long size, int may_change,
-				    int amajor)
+				    int amajor, bool assume_clean)
 {
 	struct intel_super *super = st->sb;
 	int vol_idx = super->current_vol;
diff --git a/super0.c b/super0.c
index ff4905b9..07723658 100644
--- a/super0.c
+++ b/super0.c
@@ -1153,7 +1153,7 @@ static __u64 avail_size0(struct supertype *st, __u64 devsize,
 static int add_internal_bitmap0(struct supertype *st, int *chunkp,
 				int delay, int write_behind,
 				unsigned long long size, int may_change,
-				int major)
+				int major, bool assume_clean)
 {
 	/*
 	 * The bitmap comes immediately after the superblock and must be 60K in size
diff --git a/super1.c b/super1.c
index fe3c4c64..22659e50 100644
--- a/super1.c
+++ b/super1.c
@@ -2487,11 +2487,19 @@ static __u64 avail_size1(struct supertype *st, __u64 devsize,
 	return 0;
 }
 
+static int get_bitmap_version1(struct supertype *st)
+{
+	struct mdp_superblock_1 *sb = st->sb;
+	bitmap_super_t *bms = (bitmap_super_t *)(((char *)sb) + MAX_SB_SIZE);
+
+	return __le32_to_cpu(bms->version);
+}
+
 static int
 add_internal_bitmap1(struct supertype *st,
 		     int *chunkp, int delay, int write_behind,
 		     unsigned long long size,
-		     int may_change, int major)
+		     int may_change, int major, bool assume_clean)
 {
 	/*
 	 * If not may_change, then this is a 'Grow' without sysfs support for
@@ -2650,6 +2658,13 @@ add_internal_bitmap1(struct supertype *st,
 		bms->cluster_name[len - 1] = '\0';
 	}
 
+	/* kernel will initialize bitmap */
+	if (major == BITMAP_MAJOR_LOCKLESS) {
+		bms->state = __cpu_to_le32(1 << BITMAP_FIRST_USE);
+		if (assume_clean)
+			bms->state |= __cpu_to_le32(1 << BITMAP_CLEAN);
+		bms->sectors_reserved = __le32_to_cpu(room);
+	}
 	*chunkp = chunk;
 	return 0;
 }
@@ -3025,6 +3040,7 @@ struct superswitch super1 = {
 	.avail_size = avail_size1,
 	.add_internal_bitmap = add_internal_bitmap1,
 	.locate_bitmap = locate_bitmap1,
+	.get_bitmap_version = get_bitmap_version1,
 	.write_bitmap = write_bitmap1,
 	.free_super = free_super1,
 #if __BYTE_ORDER == BIG_ENDIAN
-- 
2.39.2

