Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6245198A1A
	for <linux-raid@vger.kernel.org>; Thu,  7 Nov 2024 08:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730967444; cv=none; b=L0XVerTsGEHPTKpa3cbTwOSj4LIzI+BBRB2T06XOOhWZEP377RDXOjOG+g3j0qW9EkyJWzWG2ojptvdaI4Md/cPBLGGMG2/UKo117rplWeF9Mz6t32c1lTk5q5I6kTuq3qD27tYoxzN7/O+ncrH3yORfSJQ70Mqg8TErTcov+w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730967444; c=relaxed/simple;
	bh=ls/rx1Ml4ziZcMhrI+Yv6BSiQ+KxmHN/MftLl+rMP8c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GNlKXFHKYA8+fGwT+Gkffp0nLH/Rd9y+HaB2rrDPZGJXMQwH4Ysef00BNg/biBDwHtkFnOov7FJcJgW41eMlKF+PnGOivuvXI+pQJZFv7HbNmwIcBLuZ0x10SIYktMI6PdV3EdbC8xlnyOMCsQ5iMaBjUoYpRrAuwDpekEtU+sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4XkZg06bp8z4f3nbD
	for <linux-raid@vger.kernel.org>; Thu,  7 Nov 2024 16:17:00 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id C95711A0359
	for <linux-raid@vger.kernel.org>; Thu,  7 Nov 2024 16:17:19 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBHI4eMdyxnL91fBA--.3434S8;
	Thu, 07 Nov 2024 16:17:19 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: mariusz.tkaczyk@linux.intel.com,
	linux-raid@vger.kernel.org
Cc: yukuai3@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH mdadm/master v2 4/4] mdadm: add support for new lockless bitmap
Date: Thu,  7 Nov 2024 16:13:47 +0800
Message-Id: <20241107081347.1947132-5-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241107081347.1947132-1-yukuai1@huaweicloud.com>
References: <20241107081347.1947132-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHI4eMdyxnL91fBA--.3434S8
X-Coremail-Antispam: 1UD129KBjvJXoWxZF47tF1UZFy7Jw17urWDCFg_yoW5ur1DpF
	42vr95Cr13GF4kW3W7ta4kuFZ5Jr1vyFnFkrWkZa1agr1Sgrn3ZF15GF1UXa4fGw48Jayx
	Xrn8tw1Uu3yayrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9jb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAV
	Cq3wA2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0
	rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267
	AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E
	14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7
	xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Y
	z7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7
	v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF
	1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIx
	AIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI
	42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvf
	C2KfnxnUUI43ZEXa7IU8SfO7UUUUU==
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
 5 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/Create.c b/Create.c
index 29858483..3637af01 100644
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
@@ -1195,7 +1197,8 @@ int Create(struct supertype *st, struct mddev_ident *ident, int subdevs,
 	 * to stop another mdadm from finding and using those devices.
 	 */
 
-	if (s->btype == BitmapInternal || s->btype == BitmapCluster) {
+	if (s->btype == BitmapInternal || s->btype == BitmapCluster ||
+	    s->btype == BitmapLockless) {
 		if (!st->ss->add_internal_bitmap) {
 			pr_err("internal bitmaps not supported with %s metadata\n",
 				st->ss->name);
diff --git a/Grow.c b/Grow.c
index fae5b8a7..95a8da5e 100644
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
index 82a48722..314a5923 100644
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
index af54a6ab..5e35d78c 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -607,6 +607,7 @@ enum bitmap_type {
 	BitmapNone,
 	BitmapInternal,
 	BitmapCluster,
+	BitmapLockless,
 	BitmapUnknown,
 };
 
-- 
2.39.2

