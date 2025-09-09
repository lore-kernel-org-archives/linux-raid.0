Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1AB27453;
	Tue,  9 Sep 2025 08:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757405449; cv=none; b=nj73Zv3qz8GRheXpFqub6nNS4BpRtuq4+klfz4cnwbiYVcMxZ/yXTko/5GreKxnqus3fCTSGbPMlAxUmDGTxGe8INtYGdc5VfKSFdU+bI4p2LL4j2LT9UXQyDr+wX55bbW+PkIIAQhY7IeLgm4nhpHJf9VOorhPtIecOZLtk2fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757405449; c=relaxed/simple;
	bh=wPMvSp7Ag31Vc3oLR/IdxfAPF//XPK1pSo0oDcof37o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gb35Djd/c8zUTPSbolF4js/vDVjEquHEZsYUYbqdSCT6s8DCa/FVFiBqMR+QgDX3IAn1n4vyIAzPJ0Yh4KB6a6tBmcgjE4dTdXpXjOaapv4Hu9vh15lFe6onOklOOf7hKzGISfLoZtfQDasppnbjuEAVvHtQDOaMwN4baWJOA1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4cLc2V3SpSzKHN8v;
	Tue,  9 Sep 2025 16:10:42 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A00841A0EA2;
	Tue,  9 Sep 2025 16:10:42 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCn8IwA4b9oQ7ieBw--.24199S4;
	Tue, 09 Sep 2025 16:10:42 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: mtkaczyk@kernel.org,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	xni@redhat.com,
	linan122@huawei.com
Cc: yukuai3@huawei.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH] mdadm: add support for new lockless bitmap
Date: Tue,  9 Sep 2025 16:01:20 +0800
Message-Id: <20250909080120.2826216-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCn8IwA4b9oQ7ieBw--.24199S4
X-Coremail-Antispam: 1UD129KBjvJXoW3KFyxWry7Jry7Cr4xKFWDXFb_yoWDXw17pF
	4jvrn5Cr4rGr4fWwnxtrWrZF4rtw1vkF9Fkr97Zw1akF1YqrnaqF1rGFyUA34fuFs5JFyf
	uFs8tw18u3yxZrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI
	7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxV
	Cjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY
	6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6x
	AIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY
	1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU17KsUUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

A new major number 6 is used for the new bitmap.

Noted that for the kernel that doesn't support lockless bitmap, create
such array will fail:

md0: invalid bitmap file superblock: unrecognized superblock version.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 Assemble.c    |  5 +++++
 Create.c      | 10 ++++++++--
 Grow.c        |  5 +++--
 Incremental.c | 34 ++++++++++++++++++++++++++++++++++
 bitmap.h      |  9 +++++++--
 mdadm.c       |  9 ++++++++-
 mdadm.h       |  5 ++++-
 super-intel.c |  2 +-
 super0.c      |  2 +-
 super1.c      | 35 +++++++++++++++++++++++++++++++++--
 10 files changed, 104 insertions(+), 12 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 1949bf96..098771e6 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1029,6 +1029,11 @@ static int start_array(int mdfd,
 	int i;
 	unsigned int req_cnt;
 
+	if (st->ss->get_bitmap_type &&
+	    st->ss->get_bitmap_type(st) == BITMAP_MAJOR_LOCKLESS &&
+	    sysfs_set_str(content, NULL, "bitmap_type", "llbitmap"))
+		return 1;
+
 	if (content->journal_device_required && (content->journal_clean == 0)) {
 		if (!c->force) {
 			pr_err("Not safe to assemble with missing or stale journal device, consider --force.\n");
diff --git a/Create.c b/Create.c
index 420b9136..ed43872f 100644
--- a/Create.c
+++ b/Create.c
@@ -539,6 +539,8 @@ int Create(struct supertype *st, struct mddev_ident *ident, int subdevs,
 			pr_err("At least 2 nodes are needed for cluster-md\n");
 			return 1;
 		}
+	} else if (s->btype == BitmapLockless) {
+		major_num = BITMAP_MAJOR_LOCKLESS;
 	}
 
 	memset(&info, 0, sizeof(info));
@@ -1180,7 +1182,8 @@ int Create(struct supertype *st, struct mddev_ident *ident, int subdevs,
 	 * to stop another mdadm from finding and using those devices.
 	 */
 
-	if (s->btype == BitmapInternal || s->btype == BitmapCluster) {
+	if (s->btype == BitmapInternal || s->btype == BitmapCluster ||
+	    s->btype == BitmapLockless) {
 		if (!st->ss->add_internal_bitmap) {
 			pr_err("internal bitmaps not supported with %s metadata\n",
 				st->ss->name);
@@ -1188,10 +1191,13 @@ int Create(struct supertype *st, struct mddev_ident *ident, int subdevs,
 		}
 		if (st->ss->add_internal_bitmap(st, &s->bitmap_chunk,
 						c->delay, s->write_behind,
-						bitmapsize, 1, major_num)) {
+						bitmapsize, 1, major_num, s->assume_clean)) {
 			pr_err("Given bitmap chunk size not supported.\n");
 			goto abort_locked;
 		}
+		if (s->btype == BitmapLockless &&
+		    sysfs_set_str(&info, NULL, "bitmap_type", "llbitmap") < 0)
+			goto abort_locked;
 	}
 
 	if (sysfs_init(&info, mdfd, NULL)) {
diff --git a/Grow.c b/Grow.c
index fbf56156..b2cdd893 100644
--- a/Grow.c
+++ b/Grow.c
@@ -377,7 +377,8 @@ int Grow_addbitmap(char *devname, int fd, struct context *c, struct shape *s)
 		free(mdi);
 	}
 
-	if (s->btype == BitmapInternal || s->btype == BitmapCluster) {
+	if (s->btype == BitmapInternal || s->btype == BitmapCluster ||
+	    s->btype == BitmapLockless) {
 		int rv;
 		int d;
 		int offset_setable = 0;
@@ -419,7 +420,7 @@ int Grow_addbitmap(char *devname, int fd, struct context *c, struct shape *s)
 				rv = st->ss->add_internal_bitmap(
 					st, &s->bitmap_chunk, c->delay,
 					s->write_behind, bitmapsize,
-					offset_setable, major);
+					offset_setable, major, 0);
 				if (!rv) {
 					st->ss->write_bitmap(st, fd2,
 							     NodeNumUpdate);
diff --git a/Incremental.c b/Incremental.c
index ba3810e6..ce3f97db 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -554,6 +554,40 @@ int Incremental(struct mddev_dev *devlist, struct context *c,
 			if (d->disk.state & (1<<MD_DISK_REMOVED))
 				remove_disk(mdfd, st, sra, d);
 
+		if (st->ss->get_bitmap_type) {
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
+			if (st->ss->get_bitmap_type(st) == BITMAP_MAJOR_LOCKLESS) {
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
+				rv = sysfs_set_str(sra, NULL, "bitmap_type", "llbitmap");
+				if (rv)
+					goto out;
+			}
+		}
+
 		if ((sra == NULL || active_disks >= info.array.working_disks) &&
 		    trustworthy != FOREIGN)
 			rv = ioctl(mdfd, RUN_ARRAY, NULL);
diff --git a/bitmap.h b/bitmap.h
index 9f3d4f3e..098e5841 100644
--- a/bitmap.h
+++ b/bitmap.h
@@ -14,12 +14,17 @@
 #define BITMAP_MAJOR_LO 3
 #define BITMAP_MAJOR_HI 4
 #define	BITMAP_MAJOR_CLUSTERED 5
+#define BITMAP_MAJOR_LOCKLESS 6
 #define BITMAP_MAGIC 0x6d746962
 
 /* use these for bitmap->flags and bitmap->sb->state bit-fields */
 enum bitmap_state {
-	BITMAP_ACTIVE = 0x001, /* the bitmap is in use */
-	BITMAP_STALE  = 0x002  /* the bitmap file is out of date or had -EIO */
+	BITMAP_STALE		= 1,  /* the bitmap file is out of date or had -EIO */
+	BITMAP_WRITE_ERROR	= 2, /* A write error has occurred */
+	BITMAP_FIRST_USE	= 3,
+	BITMAP_CLEAN		= 4,
+	BITMAP_DAEMON_BUSY	= 5,
+	BITMAP_HOSTENDIAN	= 15,
 };
 
 /* the superblock at the front of the bitmap file -- little endian */
diff --git a/mdadm.c b/mdadm.c
index 14649a40..41811cd8 100644
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
@@ -1245,7 +1251,8 @@ int main(int argc, char *argv[])
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
index 84bd2c91..dcddd9a4 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -558,6 +558,7 @@ enum bitmap_type {
 	BitmapNone,
 	BitmapInternal,
 	BitmapCluster,
+	BitmapLockless,
 	BitmapUnknown,
 };
 
@@ -1151,7 +1152,9 @@ extern struct superswitch {
 	 */
 	int (*add_internal_bitmap)(struct supertype *st, int *chunkp,
 				   int delay, int write_behind,
-				   unsigned long long size, int may_change, int major);
+				   unsigned long long size, int may_change,
+				   int major, bool assume_clean);
+	int (*get_bitmap_type)(struct supertype *st);
 	/* Perform additional setup required to activate a bitmap.
 	 */
 	int (*set_bitmap)(struct supertype *st, struct mdinfo *info);
diff --git a/super-intel.c b/super-intel.c
index 7162327e..b0984235 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -13011,7 +13011,7 @@ static int validate_internal_bitmap_imsm(struct supertype *st)
 static int add_internal_bitmap_imsm(struct supertype *st, int *chunkp,
 				    int delay, int write_behind,
 				    unsigned long long size, int may_change,
-				    int amajor)
+				    int amajor, bool assume_clean)
 {
 	struct intel_super *super = st->sb;
 	int vol_idx = super->current_vol;
diff --git a/super0.c b/super0.c
index def553c6..bd7ad18e 100644
--- a/super0.c
+++ b/super0.c
@@ -1185,7 +1185,7 @@ static __u64 avail_size0(struct supertype *st, __u64 devsize,
 static int add_internal_bitmap0(struct supertype *st, int *chunkp,
 				int delay, int write_behind,
 				unsigned long long size, int may_change,
-				int major)
+				int major, bool assume_clean)
 {
 	/*
 	 * The bitmap comes immediately after the superblock and must be 60K in size
diff --git a/super1.c b/super1.c
index a8081a44..61378e37 100644
--- a/super1.c
+++ b/super1.c
@@ -2374,11 +2374,19 @@ static __u64 avail_size1(struct supertype *st, __u64 devsize,
 	return 0;
 }
 
+static int get_bitmap_type1(struct supertype *st)
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
@@ -2408,6 +2416,14 @@ add_internal_bitmap1(struct supertype *st,
 		 * would be non-zero
 		 */
 		creating = 1;
+
+	if (major == BITMAP_MAJOR_LOCKLESS) {
+		if (!creating || st->minor_version != 2) {
+			pr_err("lockless bitmap is only supported with creating the array with 1.2 metadata\n");
+			return -EINVAL;
+		}
+	}
+
 	switch(st->minor_version) {
 	case 0:
 		/*
@@ -2476,9 +2492,16 @@ add_internal_bitmap1(struct supertype *st,
 	}
 
 	room -= bbl_size;
-	if (chunk == UnSet && room > 128*2)
+	if (major == BITMAP_MAJOR_LOCKLESS) {
+		if (chunk != UnSet) {
+			pr_err("lockless bitmap doesn't support chunksize\n");
+			return -EINVAL;
+		}
+		room = 128*2;
+	} else if (chunk == UnSet && room > 128*2) {
 		/* Limit to 128K of bitmap when chunk size not requested */
 		room = 128*2;
+	}
 
 	if (room <= 1)
 		/* No room for a bitmap */
@@ -2537,6 +2560,13 @@ add_internal_bitmap1(struct supertype *st,
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
@@ -2912,6 +2942,7 @@ struct superswitch super1 = {
 	.avail_size = avail_size1,
 	.add_internal_bitmap = add_internal_bitmap1,
 	.locate_bitmap = locate_bitmap1,
+	.get_bitmap_type = get_bitmap_type1,
 	.write_bitmap = write_bitmap1,
 	.free_super = free_super1,
 #if __BYTE_ORDER == BIG_ENDIAN
-- 
2.39.2

