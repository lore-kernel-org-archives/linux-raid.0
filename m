Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E9322DA1C
	for <linux-raid@vger.kernel.org>; Mon,  7 Jul 2025 16:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751907195; cv=none; b=gXQ/YC/YgKdTaBrep8mu++UdrSgi1HdeHc7/b6JZT1SV1udINzcz778NeGCBBarLUc++yoXOepuLWUVECiZFPBu4m9hHZ84XMp/bGuAcjStDHpQrs4/yr68a+U+BNAhT/Q6LIJGjqEQOPW9t8T44eMC6VGBqxixrhLVLcbwDfGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751907195; c=relaxed/simple;
	bh=n+LwsC63/e7sYkhBrS2nnWn0ZsgL9luKkjM2LLddFOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KtwvPxqNdhEzI9qdHfR/+QCDIhtIvrG3I/6ISvI2SO8JlC9S6Au3zTiOcIlGQctqUBbtOkFYNx1lhYcTPl3222cVf4Ap/sQx9RjdK5Ttfr3DXiuVXfzuLHNgPTpaTljRzCyhflfRQVkIZ8SKbFh9H+4cYqbkIU1wHcCzWgC1AlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KsAbpOHW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KsAbpOHW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E7E9C4CEF1;
	Mon,  7 Jul 2025 16:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751907194;
	bh=n+LwsC63/e7sYkhBrS2nnWn0ZsgL9luKkjM2LLddFOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KsAbpOHW7XgLUqCpPyGdsvZ2jJ8GJGXvH2q+bcmDeo6PVkdzkjYdYEDhGOnxzSrKp
	 cqlbwuKUiSwE4YscUXBdSWkD21CKl/3VrMWX6YiN0vkFC8gGZSPm1nr1YYRrb5gjTf
	 G0qgUQOUBA82zl3ls+8tJnHKZtjnfmOitEbZbNTFp3G9ehheO+KxU1eihZyCKDyiFj
	 6KqBBYYdIs1GrESkjRZVhSCeWfdWISqRbybOeAiX+PwZqjmG1u73eFgn/+CRHh2LUH
	 dOVKxjk+v5u/WsW7L0QIWoHnlp1xeMlLWpkN09n4uKEkzk/dgjNIgJ+7zXowKCXroT
	 UoMFYkemZYPqw==
From: Yu Kuai <yukuai@kernel.org>
To: hch@lst.de,
	hare@suse.de,
	xni@redhat.com,
	axboe@kernel.dk,
	linux-raid@vger.kernel.org,
	song@kernel.org
Cc: yukuai3@huawei.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH v2 05/11] md/md-bitmap: add a new sysfs api bitmap_type
Date: Tue,  8 Jul 2025 00:51:56 +0800
Message-ID: <20250707165202.11073-6-yukuai@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250707165202.11073-1-yukuai@kernel.org>
References: <20250707165202.11073-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai3@huawei.com>

The api will be used by mdadm to set bitmap_type while creating new array
or assembling array, prepare to add a new bitmap.

Currently available options are:

cat /sys/block/md0/md/bitmap_type
none [bitmap]

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 Documentation/admin-guide/md.rst | 73 ++++++++++++++++------------
 drivers/md/md.c                  | 81 ++++++++++++++++++++++++++++++++
 2 files changed, 124 insertions(+), 30 deletions(-)

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
index c0499bd8a2aa..41da352ccbde 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4197,6 +4197,86 @@ new_level_store(struct mddev *mddev, const char *buf, size_t len)
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
+	int err = 0;
+
+	xa_lock(&md_submodule);
+
+	if (mddev->bitmap_ops) {
+		err = -EBUSY;
+		goto out;
+	}
+
+	if (cmd_match(buf, "none")) {
+		mddev->bitmap_id = ID_BITMAP_NONE;
+		goto out;
+	}
+
+	xa_for_each(&md_submodule, i, head) {
+		if (head->type == MD_BITMAP && cmd_match(buf, head->name)) {
+			mddev->bitmap_id = head->id;
+			goto out;
+		}
+	}
+
+	err = kstrtoint(buf, 10, &id);
+	if (err)
+		goto out;
+
+	if (id == ID_BITMAP_NONE) {
+		mddev->bitmap_id = id;
+		goto out;
+	}
+
+	head = xa_load(&md_submodule, id);
+	if (head && head->type == MD_BITMAP) {
+		mddev->bitmap_id = id;
+		goto out;
+	}
+
+	err = -ENOENT;
+
+out:
+	xa_unlock(&md_submodule);
+	return err ? err : len;
+}
+
+static struct md_sysfs_entry md_bitmap_type =
+__ATTR(bitmap_type, 0664, bitmap_type_show, bitmap_type_store);
+
 static ssize_t
 layout_show(struct mddev *mddev, char *page)
 {
@@ -5761,6 +5841,7 @@ __ATTR(serialize_policy, S_IRUGO | S_IWUSR, serialize_policy_show,
 static struct attribute *md_default_attrs[] = {
 	&md_level.attr,
 	&md_new_level.attr,
+	&md_bitmap_type.attr,
 	&md_layout.attr,
 	&md_raid_disks.attr,
 	&md_uuid.attr,
-- 
2.43.0

