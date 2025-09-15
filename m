Received: from www5210.sakura.ne.jp (www5210.sakura.ne.jp [133.167.8.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED6B2271454
	for <linux-raid@vger.kernel.org>; Mon, 15 Sep 2025 03:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=133.167.8.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757907832; cv=none; b=KsDI7CLkgsPCZ4oafD1U1EIty/qI1mx/UTOPPMBLdXMNpU01JtUlLcJGa6BjU2dqsVf8Iqu4Wp0mzdzFTnp7XY56I2YZ9tsNNqkail0ZxQEIWkrBx3eul0kygnvXIbAr62lWESe+96g+bGznSCBhnhW3KDoyJVYbAD5XqFxFbxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757907832; c=relaxed/simple;
	bh=E/8dlYZ6yejXTpFkv2sPwGGkGkBR++m6Bvl2O3N28ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VntlXhJVZwUDOBzm7bjryodWy/IMG3ead98B2jARWIEUYhCaVHJqIhR+V5jwUwd4fKLXovYyDvvTQs/TyE8MVtORqZfULIO1fv0ePTDXfVIf/YKHXapLMxECE4DukUy4EP6/yCZ69tvy/5LOpnrMcNwzGX6w89PlnppbtKQdWdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=mgml.me; dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b=N5t58CaZ; arc=none smtp.client-ip=133.167.8.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b="N5t58CaZ"
Received: from fedora (p4504123-ipxg00s01tokaisakaetozai.aichi.ocn.ne.jp [114.172.113.123])
	(authenticated bits=0)
	by www5210.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 58F3gpZk004256
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 15 Sep 2025 12:43:16 +0900 (JST)
	(envelope-from k@mgml.me)
DKIM-Signature: a=rsa-sha256; bh=1/ZEQgORDC2M93e8yJIurN5FVHbw5bJImDctzOv4h0Q=;
        c=relaxed/relaxed; d=mgml.me;
        h=From:To:Subject:Date:Message-ID;
        s=rs20250315; t=1757907796; v=1;
        b=N5t58CaZjqH3SnV0ypz/TiNA4FAv6ZuRRnrcRpAhbrtcANyc5gv+BX6hmCo/qFyM
         AhUdflyO9whoCzcc5H9rZ5H2Rc3JWqSM10dWKlnDSK7usKoIHRaNgAo8EVmMA8sh
         QdFNne0fnPmYr0oMuFguYoZ9y2ny814rzAKz/diBCV5i/ZYAQCh6D2KidbtjJDz2
         l6TXvpZnIlPnuimruhJbbAWoRrq5xNZpvJ0xwAnIOaDhDBxVRyBG8RnYtv7EggtH
         XkY9fTWtQDTQ2wkZMKfgQnghc0dZJvlLxfs4/7wteshtr5NjNn6OzxzxFz8hKdQP
         BxZbx0X/1gBGXJ1zfxDbsw==
From: Kenta Akagi <k@mgml.me>
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
        Mariusz Tkaczyk <mtkaczyk@kernel.org>, Shaohua Li <shli@fb.com>,
        Guoqing Jiang <jgq516@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kenta Akagi <k@mgml.me>
Subject: [PATCH v4 3/9] md: introduce md_bio_failure_error()
Date: Mon, 15 Sep 2025 12:42:04 +0900
Message-ID: <20250915034210.8533-4-k@mgml.me>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250915034210.8533-1-k@mgml.me>
References: <20250915034210.8533-1-k@mgml.me>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a new helper function md_bio_failure_error().
It is serialized with md_error() under the same lock and works
almost the same, but with two differences:

* Takes the failed bio as an argument
* If MD_FAILFAST is set in bi_opf and the target rdev is LastDev,
  it does not mark the rdev faulty

Failfast bios must not break the array, but in the current implementation
this can happen. This is because MD_BROKEN was introduced in RAID1/RAID10
and is set when md_error() is called on an rdev required for mddev
operation. At the time failfast was introduced, this was not the case.

Before this commit, md_error() has already been serialized, and
RAID1/RAID10 mark rdevs that must not be set Faulty by Failfast
with the LastDev flag.

The actual change in bio error handling will follow in a later commit.

Signed-off-by: Kenta Akagi <k@mgml.me>
---
 drivers/md/md.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 drivers/md/md.h |  4 +++-
 2 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 5607578a6db9..65fdd9bae8f4 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8297,6 +8297,48 @@ void md_error(struct mddev *mddev, struct md_rdev *rdev)
 }
 EXPORT_SYMBOL(md_error);
 
+/** md_bio_failure_error() - md error handler for MD_FAILFAST bios
+ * @mddev: affected md device.
+ * @rdev: member device to fail.
+ * @bio: bio whose triggered device failure.
+ *
+ * This is almost the same as md_error(). That is, it is serialized at
+ * the same level as md_error, marks the rdev as Faulty, and changes
+ * the mddev status.
+ * However, if all of the following conditions are met, it does nothing.
+ * This is because MD_FAILFAST bios must not stopping the array.
+ *  * RAID1 or RAID10
+ *  * LastDev - if rdev becomes Faulty, mddev will stop
+ *  * The failed bio has MD_FAILFAST set
+ *
+ * Returns: true if _md_error() was called, false if not.
+ */
+bool md_bio_failure_error(struct mddev *mddev, struct md_rdev *rdev, struct bio *bio)
+{
+	bool do_md_error = true;
+
+	spin_lock(&mddev->error_handle_lock);
+	if (mddev->pers) {
+		if (mddev->pers->head.id == ID_RAID1 ||
+		    mddev->pers->head.id == ID_RAID10) {
+			if (test_bit(LastDev, &rdev->flags) &&
+			    test_bit(FailFast, &rdev->flags) &&
+			    bio != NULL && (bio->bi_opf & MD_FAILFAST))
+				do_md_error = false;
+		}
+	}
+
+	if (do_md_error)
+		_md_error(mddev, rdev);
+	else
+		pr_warn_ratelimited("md: %s: %s didn't do anything for %pg\n",
+			mdname(mddev), __func__, rdev->bdev);
+
+	spin_unlock(&mddev->error_handle_lock);
+	return do_md_error;
+}
+EXPORT_SYMBOL(md_bio_failure_error);
+
 /* seq_file implementation /proc/mdstat */
 
 static void status_unused(struct seq_file *seq)
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 5177cb609e4b..11389ea58431 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -283,7 +283,8 @@ enum flag_bits {
 				 */
 	LastDev,		/* This is the last working rdev.
 				 * so don't use FailFast any more for
-				 * metadata.
+				 * metadata and don't Fail rdev
+				 * when FailFast bio failure.
 				 */
 	CollisionCheck,		/*
 				 * check if there is collision between raid1
@@ -906,6 +907,7 @@ extern void md_write_end(struct mddev *mddev);
 extern void md_done_sync(struct mddev *mddev, int blocks, int ok);
 void _md_error(struct mddev *mddev, struct md_rdev *rdev);
 extern void md_error(struct mddev *mddev, struct md_rdev *rdev);
+extern bool md_bio_failure_error(struct mddev *mddev, struct md_rdev *rdev, struct bio *bio);
 extern void md_finish_reshape(struct mddev *mddev);
 void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
 			struct bio *bio, sector_t start, sector_t size);
-- 
2.50.1

