Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 323EBEC2;
	Sat, 24 May 2025 03:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748056849; cv=none; b=PxS+/j3V2y+/0qMQAHLTU+TPfB2q2WrDg35rbQ6PBpzWrwmWq/lv5YOlTVODAVvic7ClFYMzHFIK3Q66zXky7Mq9Nwjh9BWq6VDyyANxYJPSCMl/zFnpROt1PU867o5HP9HTgsgRPNe77A4pcTrhis6BM3AVHs/rtzAp5AaXKxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748056849; c=relaxed/simple;
	bh=VNa9ZN87RK1pzHF7hLCH11WiFO3X66ze1SP7sqsJyjg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=A0OIVIOpOYosP1xeH2jAkk3FZ+/ryzArGSIpEzS1Ke+ZPVUs+zZmSZRN9uyj6dIy/bfkP+VrySEQ2wyrW7vw3VhA9tViovLUO2J6Iv4Q7RbK426UWABdF1Lg6xgPKXIIIFjlqctOZ/X4dB35DZuEnECVTOE8BNxh/FtgaLThGko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4b46hB1nXcztS0C;
	Sat, 24 May 2025 11:19:22 +0800 (CST)
Received: from kwepemk500007.china.huawei.com (unknown [7.202.194.92])
	by mail.maildlp.com (Postfix) with ESMTPS id 58C241402C1;
	Sat, 24 May 2025 11:20:37 +0800 (CST)
Received: from huawei.com (10.175.104.67) by kwepemk500007.china.huawei.com
 (7.202.194.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Sat, 24 May
 2025 11:20:36 +0800
From: Yu Kuai <yukuai3@huawei.com>
To: <mtkaczyk@kernel.org>, <linux-raid@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <yukuai3@huawei.com>,
	<yukuai1@huaweicloud.com>, <yi.zhang@huawei.com>, <yangerkun@huawei.com>,
	<johnny.chenyi@huawei.com>
Subject: [PATCH RFC v4] mdadm: add support for new lockless bitmap
Date: Sat, 24 May 2025 11:15:50 +0800
Message-ID: <20250524031550.3872185-1-yukuai3@huawei.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemk500007.china.huawei.com (7.202.194.92)

A new major number 6 is used for the new bitmap.

Noted that for the kernel that doesn't support lockless bitmap, create
such array will fail:

md0: invalid bitmap file superblock: unrecognized superblock version.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
Changes in v4:
 - use bitmap_type to replace bitmap_version
Changes in v3:
 - add support for --assume-clean
Changes in v2:
 - add support for Incremental mode;
 - use sysfs API bitmap_version to notify kernel to use llbitmap;

 Assemble.c    |  5 +++++
 Create.c      | 10 ++++++++--
 Grow.c        |  5 +++--
 Incremental.c | 34 ++++++++++++++++++++++++++++++++++
 bitmap.h      |  9 +++++++--
 mdadm.c       |  9 ++++++++-
 mdadm.h       |  4 +++-
 super-intel.c |  2 +-
 super0.c      |  2 +-
 super1.c      | 18 +++++++++++++++++-
 10 files changed, 87 insertions(+), 11 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index f8099cd3..62f0f368 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1029,6 +1029,11 @@ static int start_array(int mdfd,
 	int i;
 	unsigned int req_cnt;
 
+	if (st->ss->get_bitmap_type &&
+	    st->ss->get_bitmap_type(st) == BITMAP_MAJOR_LOCKLESS &&
+	    sysfs_set_str(content, NULL, "bitmap_type", "llbitmap"))
+		    return 1;
+
 	if (content->journal_device_required && (content->journal_clean == 0)) {
 		if (!c->force) {
 			pr_err("Not safe to assemble with missing or stale journal device, consider --force.\n");
diff --git a/Create.c b/Create.c
index fd6c9215..f85efbd0 100644
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
+		    sysfs_set_str(&info, NULL, "bitmap_type", "llbitmap") < 0)
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
index 228d2bdd..a9914831 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -552,6 +552,40 @@ int Incremental(struct mddev_dev *devlist, struct context *c,
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
index 7b1f80f2..ffa89989 100644
--- a/bitmap.h
+++ b/bitmap.h
@@ -13,6 +13,7 @@
 #define BITMAP_MAJOR_HI 4
 #define	BITMAP_MAJOR_HOSTENDIAN 3
 #define	BITMAP_MAJOR_CLUSTERED 5
+#define	BITMAP_MAJOR_LOCKLESS 6
 
 #define BITMAP_MINOR 39
 
@@ -139,8 +140,12 @@ typedef __u16 bitmap_counter_t;
 
 /* use these for bitmap->flags and bitmap->sb->state bit-fields */
 enum bitmap_state {
-	BITMAP_ACTIVE = 0x001, /* the bitmap is in use */
-	BITMAP_STALE  = 0x002  /* the bitmap file is out of date or had -EIO */
+        BITMAP_STALE       = 1,  /* the bitmap file is out of date or had -EIO */
+        BITMAP_WRITE_ERROR = 2, /* A write error has occurred */
+        BITMAP_FIRST_USE   = 3,
+		BITMAP_CLEAN	   = 4,
+        BITMAP_DAEMON_BUSY = 5,
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
index 77705b11..4173aec6 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -607,6 +607,7 @@ enum bitmap_type {
 	BitmapNone,
 	BitmapInternal,
 	BitmapCluster,
+	BitmapLockless,
 	BitmapUnknown,
 };
 
@@ -1201,7 +1202,8 @@ extern struct superswitch {
 	 */
 	int (*add_internal_bitmap)(struct supertype *st, int *chunkp,
 				   int delay, int write_behind,
-				   unsigned long long size, int may_change, int major);
+				   unsigned long long size, int may_change, int major, bool assume_clean);
+	int (*get_bitmap_type)(struct supertype *st);
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
index fe3c4c64..3c3738e3 100644
--- a/super1.c
+++ b/super1.c
@@ -2487,11 +2487,19 @@ static __u64 avail_size1(struct supertype *st, __u64 devsize,
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
+	.get_bitmap_type = get_bitmap_type1,
 	.write_bitmap = write_bitmap1,
 	.free_super = free_super1,
 #if __BYTE_ORDER == BIG_ENDIAN
-- 
2.39.2

