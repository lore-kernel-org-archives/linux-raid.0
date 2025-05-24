Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F8219E7D0;
	Sat, 24 May 2025 06:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748067499; cv=none; b=n6OY22368OkgYqheaNfznArFy6a8lYOir+xXf2KGiZLSrhprPJcpSPeXck4Vh3jZjYkup69T34CvrfkyvMUqeReHr2XMn42A64gMLQoPnZIbb2LxSoF8V16ODffzGE82QooJVoiBigeNTItnmYvG2goQH+19aasBnmMqFGd1Ts8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748067499; c=relaxed/simple;
	bh=ZiWFEOYZFpVvgNRZex2vijFl/l9+Bv2ok8oLbd8tYfw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jD9W26RUDhl+pRB8uDTzkCO0YgKhPTsEshMghHgMo40Dl7UF/GwbpOa5su+fEkZ6p4kqm1gavjRuMCvkYMcWpMeBgsjVlwNoXf2iJZHXhuHIsagqdAtwhWdyKa4S8F85YdF19Xb/86iXwiMEXvlVsBD+CwQ8cjxCVvddjbLleGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4b4Bfb24zxzYQtxb;
	Sat, 24 May 2025 14:18:15 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 712D11A018D;
	Sat, 24 May 2025 14:18:14 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCnCl+dZDFo3etkNQ--.42979S10;
	Sat, 24 May 2025 14:18:14 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: hch@lst.de,
	xni@redhat.com,
	colyli@kernel.org,
	song@kernel.org,
	yukuai3@huawei.com
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH 06/23] md/md-bitmap: add a new sysfs api bitmap_type
Date: Sat, 24 May 2025 14:13:03 +0800
Message-Id: <20250524061320.370630-7-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250524061320.370630-1-yukuai1@huaweicloud.com>
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnCl+dZDFo3etkNQ--.42979S10
X-Coremail-Antispam: 1UD129KBjvJXoWxKryDtFy5ZF1DJw48Xw1kZrb_yoW3Jryfpa
	y8tryayrZ5XrZaqr4xJa4q9F1Fqr1vya9Fq34Sg3s5Crn8WrsxGFWfK3WUtw1DCa4ruFnr
	Zr45tFWUWryjvF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmI14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCw
	CI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnI
	WIevJa73UjIFyTuYvjfUOyIUUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

The api will be used by mdadm to set bitmap_ops while creating new array
or assemble array, prepare to add a new bitmap.

Currently available options are:

cat /sys/block/md0/md/bitmap_type
none [bitmap]

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 Documentation/admin-guide/md.rst | 73 ++++++++++++++----------
 drivers/md/md.c                  | 96 ++++++++++++++++++++++++++++++--
 drivers/md/md.h                  |  2 +
 3 files changed, 135 insertions(+), 36 deletions(-)

diff --git a/Documentation/admin-guide/md.rst b/Documentation/admin-guide/md.rst
index 4ff2cc291d18..356d2a344f08 100644
--- a/Documentation/admin-guide/md.rst
+++ b/Documentation/admin-guide/md.rst
@@ -347,6 +347,49 @@ All md devices contain:
      active-idle
          like active, but no writes have been seen for a while (safe_mode_delay).
 
+  consistency_policy
+     This indicates how the array maintains consistency in case of unexpected
+     shutdown. It can be:
+
+     none
+       Array has no redundancy information, e.g. raid0, linear.
+
+     resync
+       Full resync is performed and all redundancy is regenerated when the
+       array is started after unclean shutdown.
+
+     bitmap
+       Resync assisted by a write-intent bitmap.
+
+     journal
+       For raid4/5/6, journal device is used to log transactions and replay
+       after unclean shutdown.
+
+     ppl
+       For raid5 only, Partial Parity Log is used to close the write hole and
+       eliminate resync.
+
+     The accepted values when writing to this file are ``ppl`` and ``resync``,
+     used to enable and disable PPL.
+
+  uuid
+     This indicates the UUID of the array in the following format:
+     xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
+
+  bitmap_type
+     [RW] When read, this file will display the current and available
+     bitmap for this array. The currently active bitmap will be enclosed
+     in [] brackets. Writing an bitmap name or ID to this file will switch
+     control of this array to that new bitmap. Note that writing a new
+     bitmap for created array is forbidden.
+
+     none
+         No bitmap
+     bitmap
+         The default internal bitmap
+
+If bitmap_type is bitmap, then the md device will also contain:
+
   bitmap/location
      This indicates where the write-intent bitmap for the array is
      stored.
@@ -401,36 +444,6 @@ All md devices contain:
      once the array becomes non-degraded, and this fact has been
      recorded in the metadata.
 
-  consistency_policy
-     This indicates how the array maintains consistency in case of unexpected
-     shutdown. It can be:
-
-     none
-       Array has no redundancy information, e.g. raid0, linear.
-
-     resync
-       Full resync is performed and all redundancy is regenerated when the
-       array is started after unclean shutdown.
-
-     bitmap
-       Resync assisted by a write-intent bitmap.
-
-     journal
-       For raid4/5/6, journal device is used to log transactions and replay
-       after unclean shutdown.
-
-     ppl
-       For raid5 only, Partial Parity Log is used to close the write hole and
-       eliminate resync.
-
-     The accepted values when writing to this file are ``ppl`` and ``resync``,
-     used to enable and disable PPL.
-
-  uuid
-     This indicates the UUID of the array in the following format:
-     xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
-
-
 As component devices are added to an md array, they appear in the ``md``
 directory as new directories named::
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 311e52d5173d..4eb0c6effd5b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -672,13 +672,18 @@ static void active_io_release(struct percpu_ref *ref)
 
 static void no_op(struct percpu_ref *r) {}
 
-static void mddev_set_bitmap_ops(struct mddev *mddev, enum md_submodule_id id)
+static bool mddev_set_bitmap_ops(struct mddev *mddev)
 {
 	xa_lock(&md_submodule);
-	mddev->bitmap_ops = xa_load(&md_submodule, id);
+	mddev->bitmap_ops = xa_load(&md_submodule, mddev->bitmap_id);
 	xa_unlock(&md_submodule);
-	if (!mddev->bitmap_ops)
-		pr_warn_once("md: can't find bitmap id %d\n", id);
+
+	if (!mddev->bitmap_ops) {
+		pr_warn_once("md: can't find bitmap id %d\n", mddev->bitmap_id);
+		return false;
+	}
+
+	return true;
 }
 
 static void mddev_clear_bitmap_ops(struct mddev *mddev)
@@ -688,8 +693,10 @@ static void mddev_clear_bitmap_ops(struct mddev *mddev)
 
 int mddev_init(struct mddev *mddev)
 {
-	/* TODO: support more versions */
-	mddev_set_bitmap_ops(mddev, ID_BITMAP);
+	mddev->bitmap_id = ID_BITMAP;
+
+	if (!mddev_set_bitmap_ops(mddev))
+		return -EINVAL;
 
 	if (percpu_ref_init(&mddev->active_io, active_io_release,
 			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
@@ -4155,6 +4162,82 @@ new_level_store(struct mddev *mddev, const char *buf, size_t len)
 static struct md_sysfs_entry md_new_level =
 __ATTR(new_level, 0664, new_level_show, new_level_store);
 
+static ssize_t
+bitmap_type_show(struct mddev *mddev, char *page)
+{
+	struct md_submodule_head *head;
+	unsigned long i;
+	ssize_t len = 0;
+
+	if (mddev->bitmap_id == ID_BITMAP_NONE)
+		len += sprintf(page + len, "[none] ");
+	else
+		len += sprintf(page + len, "none ");
+
+	xa_lock(&md_submodule);
+	xa_for_each(&md_submodule, i, head) {
+		if (head->type != MD_BITMAP)
+			continue;
+
+		if (mddev->bitmap_id == head->id)
+			len += sprintf(page + len, "[%s] ", head->name);
+		else
+			len += sprintf(page + len, "%s ", head->name);
+	}
+	xa_unlock(&md_submodule);
+
+	len += sprintf(page + len, "\n");
+	return len;
+}
+
+static ssize_t
+bitmap_type_store(struct mddev *mddev, const char *buf, size_t len)
+{
+	struct md_submodule_head *head;
+	enum md_submodule_id id;
+	unsigned long i;
+	int err;
+
+	if (mddev->bitmap_ops)
+		return -EBUSY;
+
+	err = kstrtoint(buf, 10, &id);
+	if (!err) {
+		if (id == ID_BITMAP_NONE) {
+			mddev->bitmap_id = id;
+			return len;
+		}
+
+		xa_lock(&md_submodule);
+		head = xa_load(&md_submodule, id);
+		xa_unlock(&md_submodule);
+
+		if (head && head->type == MD_BITMAP) {
+			mddev->bitmap_id = id;
+			return len;
+		}
+	}
+
+	if (cmd_match(buf, "none")) {
+		mddev->bitmap_id = ID_BITMAP_NONE;
+		return len;
+	}
+
+	xa_lock(&md_submodule);
+	xa_for_each(&md_submodule, i, head) {
+		if (head->type == MD_BITMAP && cmd_match(buf, head->name)) {
+			mddev->bitmap_id = head->id;
+			xa_unlock(&md_submodule);
+			return len;
+		}
+	}
+	xa_unlock(&md_submodule);
+	return -ENOENT;
+}
+
+static struct md_sysfs_entry md_bitmap_type =
+__ATTR(bitmap_type, 0664, bitmap_type_show, bitmap_type_store);
+
 static ssize_t
 layout_show(struct mddev *mddev, char *page)
 {
@@ -5719,6 +5802,7 @@ __ATTR(serialize_policy, S_IRUGO | S_IWUSR, serialize_policy_show,
 static struct attribute *md_default_attrs[] = {
 	&md_level.attr,
 	&md_new_level.attr,
+	&md_bitmap_type.attr,
 	&md_layout.attr,
 	&md_raid_disks.attr,
 	&md_uuid.attr,
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 13e3f9ce1b79..bf34c0a36551 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -40,6 +40,7 @@ enum md_submodule_id {
 	ID_CLUSTER,
 	ID_BITMAP,
 	ID_LLBITMAP,	/* TODO */
+	ID_BITMAP_NONE,
 };
 
 struct md_submodule_head {
@@ -565,6 +566,7 @@ struct mddev {
 	struct percpu_ref		writes_pending;
 	int				sync_checkers;	/* # of threads checking writes_pending */
 
+	enum md_submodule_id		bitmap_id;
 	void				*bitmap; /* the bitmap for the device */
 	struct bitmap_operations	*bitmap_ops;
 	struct {
-- 
2.39.2

