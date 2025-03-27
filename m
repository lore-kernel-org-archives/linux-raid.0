Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A5EF20CCEA;
	Thu, 27 Mar 2025 13:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743083692; cv=none; b=FW7rWicCocFJNch8gY1793XtixMeO0SfvUrzEiZhe6ZfQ6xEal1LMY4VgYOOgl3YanRlSN0LRxhLnZ6FctPvgKyI8bBbTo0y+EBFa+UXs48ws2YgYUX0E6hIFUHF0bSbiFllGTBivEG0qnTl00sl0TSjoThkovCQfgdgSqimF7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743083692; c=relaxed/simple;
	bh=BxqCn8pY2A7yg8NNsx1eEw/G6X+czZQ/r8E3bVMCuow=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mlxylrV8GMSmPxEnOyp8Iwem7nJ4EaYUUpae9mK7vDILoVkUXcIjeeOk+jBJdFAbSP43bqdQAFZutw6zh5ifoCpqQdQMnoDe3dcRHOPhgpN87IWuPW8+/hQ09vPvZsaqxaaUhRcPBUTw8fcl0bQSgxVOJ6WGvGhj4eyNSl62Uvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4ZNlWZ4qxkz4f3kFW;
	Thu, 27 Mar 2025 21:54:18 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A0A861A0E9A;
	Thu, 27 Mar 2025 21:54:41 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCnCl+fWOVnR7LpHg--.9389S4;
	Thu, 27 Mar 2025 21:54:41 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: mtkaczyk@kernel.org,
	linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RFC v2] mdadm: add support for new lockless bitmap
Date: Thu, 27 Mar 2025 21:48:53 +0800
Message-Id: <20250327134853.1069356-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnCl+fWOVnR7LpHg--.9389S4
X-Coremail-Antispam: 1UD129KBjvJXoWxtFWfZFykGFyxZF1kZr15CFg_yoW3XF1DpF
	42vr95Cr1rGrs3Wwnrt34kuFWrtw1vyFnFkrZ7Zw4akF1FqrnIvF1rGF1UA3s3Wrs5Ja42
	9Fn8Kw18u3y7XrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkG14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_
	JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8
	JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JUBVbkUUU
	UU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

A new major number 6 is used for the new bitmap.

Noted that for the kernel that doesn't support lockless bitmap, create
such array will fail:

md0: invalid bitmap file superblock: unrecognized superblock version.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
Changes in v2:
 - add support for Incremental mode;
 - use sysfs API bitmap_version to notify kernel to use llbitmap;

 Assemble.c    |  5 +++++
 Create.c      |  8 +++++++-
 Grow.c        |  3 ++-
 Incremental.c | 34 ++++++++++++++++++++++++++++++++++
 bitmap.h      |  8 ++++++--
 mdadm.c       |  9 ++++++++-
 mdadm.h       |  2 ++
 super1.c      | 14 ++++++++++++++
 8 files changed, 78 insertions(+), 5 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index f8099cd3..5d46379d 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1029,6 +1029,11 @@ static int start_array(int mdfd,
 	int i;
 	unsigned int req_cnt;
 
+	if (st->ss->get_bitmap_version &&
+	    st->ss->get_bitmap_version(st) == BITMAP_MAJOR_LOCKLESS &&
+	    sysfs_set_str(content, NULL, "bitmap_version", "llbitmap"))
+		    return 1;
+
 	if (content->journal_device_required && (content->journal_clean == 0)) {
 		if (!c->force) {
 			pr_err("Not safe to assemble with missing or stale journal device, consider --force.\n");
diff --git a/Create.c b/Create.c
index fd6c9215..a85c0419 100644
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
@@ -1194,6 +1197,9 @@ int Create(struct supertype *st, struct mddev_ident *ident, int subdevs,
 			pr_err("Given bitmap chunk size not supported.\n");
 			goto abort_locked;
 		}
+		if (s->btype == BitmapLockless &&
+		    sysfs_set_str(&info, NULL, "bitmap_version", "llbitmap") < 0)
+			goto abort_locked;
 	}
 
 	if (sysfs_init(&info, mdfd, NULL)) {
diff --git a/Grow.c b/Grow.c
index cc1be6cc..3905f64c 100644
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
index 7b1f80f2..3a08cf60 100644
--- a/bitmap.h
+++ b/bitmap.h
@@ -13,6 +13,7 @@
 #define BITMAP_MAJOR_HI 4
 #define	BITMAP_MAJOR_HOSTENDIAN 3
 #define	BITMAP_MAJOR_CLUSTERED 5
+#define	BITMAP_MAJOR_LOCKLESS 6
 
 #define BITMAP_MINOR 39
 
@@ -139,8 +140,11 @@ typedef __u16 bitmap_counter_t;
 
 /* use these for bitmap->flags and bitmap->sb->state bit-fields */
 enum bitmap_state {
-	BITMAP_ACTIVE = 0x001, /* the bitmap is in use */
-	BITMAP_STALE  = 0x002  /* the bitmap file is out of date or had -EIO */
+        BITMAP_STALE       = 1,  /* the bitmap file is out of date or had -EIO */
+        BITMAP_WRITE_ERROR = 2, /* A write error has occurred */
+        BITMAP_FIRST_USE   = 3,
+        BITMAP_DAEMON_BUSY = 4,
+        BITMAP_HOSTENDIAN  =15,
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
index 77705b11..cc21e0d3 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -607,6 +607,7 @@ enum bitmap_type {
 	BitmapNone,
 	BitmapInternal,
 	BitmapCluster,
+	BitmapLockless,
 	BitmapUnknown,
 };
 
@@ -1202,6 +1203,7 @@ extern struct superswitch {
 	int (*add_internal_bitmap)(struct supertype *st, int *chunkp,
 				   int delay, int write_behind,
 				   unsigned long long size, int may_change, int major);
+	int (*get_bitmap_version)(struct supertype *st);
 	/* Perform additional setup required to activate a bitmap.
 	 */
 	int (*set_bitmap)(struct supertype *st, struct mdinfo *info);
diff --git a/super1.c b/super1.c
index fe3c4c64..caa2569d 100644
--- a/super1.c
+++ b/super1.c
@@ -2487,6 +2487,14 @@ static __u64 avail_size1(struct supertype *st, __u64 devsize,
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
@@ -2650,6 +2658,11 @@ add_internal_bitmap1(struct supertype *st,
 		bms->cluster_name[len - 1] = '\0';
 	}
 
+	/* kernel will initialize bitmap */
+	if (major == BITMAP_MAJOR_LOCKLESS) {
+		bms->state = __cpu_to_le32(1 << BITMAP_FIRST_USE);
+		bms->sectors_reserved = __le32_to_cpu(room);
+	}
 	*chunkp = chunk;
 	return 0;
 }
@@ -3025,6 +3038,7 @@ struct superswitch super1 = {
 	.avail_size = avail_size1,
 	.add_internal_bitmap = add_internal_bitmap1,
 	.locate_bitmap = locate_bitmap1,
+	.get_bitmap_version = get_bitmap_version1,
 	.write_bitmap = write_bitmap1,
 	.free_super = free_super1,
 #if __BYTE_ORDER == BIG_ENDIAN
-- 
2.39.2

