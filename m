Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A021E487
	for <linux-raid@vger.kernel.org>; Sun, 26 Jan 2025 08:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737880401; cv=none; b=hTfIuZcc0PM+MrolOd1///br6YwK7KL6haJznbb4AbH0F8DK5wrjRj1msSft4rt3rmr9oxQcDAin7Mx3gEP3L5xmkXN9KebSciiKKa+IvX8cnXdCoy0Hbp1uqUp2LzhZw9yUMwTHiv/4xX/8hojNlkzFjugDZVzC05Md4TRcGuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737880401; c=relaxed/simple;
	bh=WHXcf8dRPmimI9C7Nger338iBfVihNTHL8TzJ+kRkIY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=KpviOMf4Nl4EDjxu8qHb22BXffSR9ykLDdQTgiAuwJi3qo8TURyJZ1/ykiV/GMPoCfWvPmlmi6Fv+C57AIariZ6l4gtYojPHmfXkYw87lslWkVbEZ6reJj5fn700K01+YhMheGfRBBvuhN/pep2kNhEGpKvKifsKFZ4/M0EqUM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4YglDN3rFdz4f3jXJ
	for <linux-raid@vger.kernel.org>; Sun, 26 Jan 2025 16:32:52 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 501131A17E5
	for <linux-raid@vger.kernel.org>; Sun, 26 Jan 2025 16:33:13 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgA3m19H85VnfSIdCA--.39932S4;
	Sun, 26 Jan 2025 16:33:13 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: mtkaczyk@kernel.org
Cc: linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RFC mdadm/master] mdadm: add support for new lockless bitmap
Date: Sun, 26 Jan 2025 16:27:14 +0800
Message-Id: <20250126082714.1588025-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgA3m19H85VnfSIdCA--.39932S4
X-Coremail-Antispam: 1UD129KBjvJXoWxZF4fJF4rWryDWF1fXF13Jwb_yoWrXFy5pF
	42vr9Ykr13Grs8W3W7ta4kuFZ5tw1vyFsFkrWkZa13KFnYgrnavF1rWFyUX34fWw48Jay7
	XFn8Kw1Uu3y3JrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUgGb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Y
	z7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zV
	AF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4l
	IxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCw
	CI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnI
	WIevJa73UjIFyTuYvjxUzsqWUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

A new major number 6 is used for the new bitmap.

Noted that for the kernel that doesn't support lockless bitmap, create
such array will fail:

md0: invalid bitmap file superblock: unrecognized superblock version.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 Create.c | 5 ++++-
 Grow.c   | 3 ++-
 bitmap.h | 1 +
 mdadm.c  | 9 ++++++++-
 mdadm.h  | 1 +
 super1.c | 9 +++++++++
 6 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/Create.c b/Create.c
index fd6c9215..105d15e0 100644
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
diff --git a/bitmap.h b/bitmap.h
index 7b1f80f2..4b5d2d93 100644
--- a/bitmap.h
+++ b/bitmap.h
@@ -13,6 +13,7 @@
 #define BITMAP_MAJOR_HI 4
 #define	BITMAP_MAJOR_HOSTENDIAN 3
 #define	BITMAP_MAJOR_CLUSTERED 5
+#define	BITMAP_MAJOR_LOCKLESS 6
 
 #define BITMAP_MINOR 39
 
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
index 77705b11..5985a5bd 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -607,6 +607,7 @@ enum bitmap_type {
 	BitmapNone,
 	BitmapInternal,
 	BitmapCluster,
+	BitmapLockless,
 	BitmapUnknown,
 };
 
diff --git a/super1.c b/super1.c
index fe3c4c64..016ce36c 100644
--- a/super1.c
+++ b/super1.c
@@ -2487,6 +2487,12 @@ static __u64 avail_size1(struct supertype *st, __u64 devsize,
 	return 0;
 }
 
+enum llbitmap_flags {
+	LLB_STALE = 0,
+	LLB_ERROR,
+	LLB_FIRST_USE,
+};
+
 static int
 add_internal_bitmap1(struct supertype *st,
 		     int *chunkp, int delay, int write_behind,
@@ -2650,6 +2656,9 @@ add_internal_bitmap1(struct supertype *st,
 		bms->cluster_name[len - 1] = '\0';
 	}
 
+	/* kernel will initialize bitmap */
+	if (major == BITMAP_MAJOR_LOCKLESS)
+		bms->state = __cpu_to_le32(1 << LLB_FIRST_USE);
 	*chunkp = chunk;
 	return 0;
 }
-- 
2.39.2

