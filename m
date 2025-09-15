Received: from www5210.sakura.ne.jp (www5210.sakura.ne.jp [133.167.8.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFACA26D4DA
	for <linux-raid@vger.kernel.org>; Mon, 15 Sep 2025 03:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=133.167.8.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757907827; cv=none; b=gN30TLsh8SjC9SA8qoXA37dyLu5fjSuwgggUElY+2JdXGS7h8S1EM1Utm//BqYQi/U7FLvjIJ3xb8+i/6Ik9vApEAs14L+lQxiasWc12jBu87w/1ddKBsbKmtd06k3+V1QEEYkot6JRGgaO66JjyTrcMxhjHw5tIvSITmI7GuTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757907827; c=relaxed/simple;
	bh=Ow9oem3bq54CCBwZqRu/jbUwDtw5qZJuTzGmkup7YS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PhtPYs1qxoCdQycw0p38XKPctxtRherV7+39fqhxR65q1Cv7uskkgMiSY3bLbHX96DBbJn/9aSHfTYbLReAdwRD+cmZ7NKrC18QbGdXOFrQB0fH2QeDGuzqZTwWm/lF34V7WW098lCFc2bLkk3t34JfrC1JwEfrDrW9DXSgzILo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=mgml.me; dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b=eXQ20g5H; arc=none smtp.client-ip=133.167.8.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b="eXQ20g5H"
Received: from fedora (p4504123-ipxg00s01tokaisakaetozai.aichi.ocn.ne.jp [114.172.113.123])
	(authenticated bits=0)
	by www5210.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 58F3gpZj004256
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 15 Sep 2025 12:43:16 +0900 (JST)
	(envelope-from k@mgml.me)
DKIM-Signature: a=rsa-sha256; bh=7DroO2tvGIKHGeZ7GHD8saOcIV9bJRQbhvjJqTkaPBg=;
        c=relaxed/relaxed; d=mgml.me;
        h=From:To:Subject:Date:Message-ID;
        s=rs20250315; t=1757907796; v=1;
        b=eXQ20g5HQRNIP3Yc/9UqawOPG+PzHH7/pnEV+j7HRuKO39u17Q/mlVIO176gSBun
         8HXCjrOUxvIwK9SGXYTvqR3oTMQaPT5uvLBwnylxJ3FmraOSEjs2O1urcuR73S+y
         TXPgzFjzFyiBL/mRKaao7/kXndaNaT9QJgyLvdx81V8Ob8JPN+IDiAbGYzzXvxtk
         H+2nOBax+7qK024Yr2r9qGtOtHkPYfOkw1B0l12oLT2G+9kJNf9i5YeXF/tECCEA
         rRTt8B/hBYNRNg+Bk4F5dSe2pTrLRCvjmZ9xPzuMOwRqcjhaT2DgYo1RsQ39dZpX
         ZWXXpnaOGwktw/e4TKBcnQ==
From: Kenta Akagi <k@mgml.me>
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
        Mariusz Tkaczyk <mtkaczyk@kernel.org>, Shaohua Li <shli@fb.com>,
        Guoqing Jiang <jgq516@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kenta Akagi <k@mgml.me>
Subject: [PATCH v4 2/9] md: serialize md_error()
Date: Mon, 15 Sep 2025 12:42:03 +0900
Message-ID: <20250915034210.8533-3-k@mgml.me>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250915034210.8533-1-k@mgml.me>
References: <20250915034210.8533-1-k@mgml.me>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

md_error is mainly called when a bio fails, so it can run in parallel.
Each personality’s error_handler locks with device_lock, so concurrent
calls are safe.

However, RAID1 and RAID10 require changes for Failfast bio error handling,
which needs a special helper for md_error. For that helper to work, the
regular md_error must also be serialized.

The helper function md_bio_failure_error for failfast will be introduced
in a subsequent commit.

This commit serializes md_error for all RAID personalities. While
unnecessary for RAID levels other than 1 and 10, it has no performance
impact as it is a cold path.

Signed-off-by: Kenta Akagi <k@mgml.me>
---
 drivers/md/md.c | 10 +++++++++-
 drivers/md/md.h |  4 ++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 268410b66b83..5607578a6db9 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -705,6 +705,7 @@ int mddev_init(struct mddev *mddev)
 	atomic_set(&mddev->openers, 0);
 	atomic_set(&mddev->sync_seq, 0);
 	spin_lock_init(&mddev->lock);
+	spin_lock_init(&mddev->error_handle_lock);
 	init_waitqueue_head(&mddev->sb_wait);
 	init_waitqueue_head(&mddev->recovery_wait);
 	mddev->reshape_position = MaxSector;
@@ -8262,7 +8263,7 @@ void md_unregister_thread(struct mddev *mddev, struct md_thread __rcu **threadp)
 }
 EXPORT_SYMBOL(md_unregister_thread);
 
-void md_error(struct mddev *mddev, struct md_rdev *rdev)
+void _md_error(struct mddev *mddev, struct md_rdev *rdev)
 {
 	if (!rdev || test_bit(Faulty, &rdev->flags))
 		return;
@@ -8287,6 +8288,13 @@ void md_error(struct mddev *mddev, struct md_rdev *rdev)
 		queue_work(md_misc_wq, &mddev->event_work);
 	md_new_event();
 }
+
+void md_error(struct mddev *mddev, struct md_rdev *rdev)
+{
+	spin_lock(&mddev->error_handle_lock);
+	_md_error(mddev, rdev);
+	spin_unlock(&mddev->error_handle_lock);
+}
 EXPORT_SYMBOL(md_error);
 
 /* seq_file implementation /proc/mdstat */
diff --git a/drivers/md/md.h b/drivers/md/md.h
index ec598f9a8381..5177cb609e4b 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -619,6 +619,9 @@ struct mddev {
 	/* The sequence number for sync thread */
 	atomic_t sync_seq;
 
+	/* Lock for serializing md_error */
+	spinlock_t			error_handle_lock;
+
 	bool	has_superblocks:1;
 	bool	fail_last_dev:1;
 	bool	serialize_policy:1;
@@ -901,6 +904,7 @@ extern void md_write_start(struct mddev *mddev, struct bio *bi);
 extern void md_write_inc(struct mddev *mddev, struct bio *bi);
 extern void md_write_end(struct mddev *mddev);
 extern void md_done_sync(struct mddev *mddev, int blocks, int ok);
+void _md_error(struct mddev *mddev, struct md_rdev *rdev);
 extern void md_error(struct mddev *mddev, struct md_rdev *rdev);
 extern void md_finish_reshape(struct mddev *mddev);
 void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
-- 
2.50.1

