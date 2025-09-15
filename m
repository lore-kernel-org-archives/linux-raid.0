Received: from www5210.sakura.ne.jp (www5210.sakura.ne.jp [133.167.8.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C48826D4E5
	for <linux-raid@vger.kernel.org>; Mon, 15 Sep 2025 03:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=133.167.8.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757907829; cv=none; b=Fg2NH7PfOHpOH3W9T0M9CA5SgeDxY9KqJe/uwWBOIP/EvohglM152EOKiV33FGkhVBzU62hZN3HiDp+KF/e9GeapheWChf/2EOmc9vuQufBCO7nOiwgL4QJEdvY01Uz5cAFK9tm0JMlXP7I9hBo9+rOBXH0vOp52RtbwSDhD8Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757907829; c=relaxed/simple;
	bh=dA7iA4QdYV5OQXZnQTJvoO7SWvqCvNO2XgAU9+kXw9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tdX3zh9MAa/2cwpvF0O/ZQ9zxi1v/CDOXvykuXTMf7qaBSyAajjWtqYf7yPHgxG5EDUJmdv+1WeaIM9phNqHrMRPOl1bOJOGuuGQny+Ldu3XS5I/msQH3n6GroRZCMme1QkBjiZiHYcYrz7UFFDEwrK+WqDj/Yw6W1OROyFiUVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=mgml.me; dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b=cid15uYn; arc=none smtp.client-ip=133.167.8.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b="cid15uYn"
Received: from fedora (p4504123-ipxg00s01tokaisakaetozai.aichi.ocn.ne.jp [114.172.113.123])
	(authenticated bits=0)
	by www5210.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 58F3gpZm004256
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 15 Sep 2025 12:43:16 +0900 (JST)
	(envelope-from k@mgml.me)
DKIM-Signature: a=rsa-sha256; bh=66cadRtkt9WSztizM58z6M5q8HJ0282WWMYK0IH6Oy4=;
        c=relaxed/relaxed; d=mgml.me;
        h=From:To:Subject:Date:Message-ID;
        s=rs20250315; t=1757907796; v=1;
        b=cid15uYniIEHCPUNQNY9iMTPrtXl5hdOSrQQkQbZ065Ed44Z0B3ZdnAWvFBt0MWs
         IvUfzWX6dBgwHPX9FKMZVCd8t9I3YL7wlPFZilmwou+xZg+wOAwDhOZCb4RGrWIn
         601AUlip8+uecNAf7XkkYKd624ra2LlrAiUYYkOtoL8rML1CVsHWbUfhZNUTv3Qd
         yDvaMvM3unnJ7lacqFVpTXomB79He3EP1AHb/yGKjE4N7KvLiL4E/8yMyGpkmi5i
         0RPIFlUyGpOVmE6mSooGjqUNSyRaXWOEsfqHZKbzm75hV1Kk6mzU3hvPVujfgtsx
         odhbWhXb32U9hzuZ+J1tew==
From: Kenta Akagi <k@mgml.me>
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
        Mariusz Tkaczyk <mtkaczyk@kernel.org>, Shaohua Li <shli@fb.com>,
        Guoqing Jiang <jgq516@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kenta Akagi <k@mgml.me>
Subject: [PATCH v4 5/9] md/raid1,raid10: Set R{1,10}BIO_Uptodate when successful retry of a failed bio
Date: Mon, 15 Sep 2025 12:42:06 +0900
Message-ID: <20250915034210.8533-6-k@mgml.me>
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

In the current implementation, when a write bio fails, the retry flow
is as follows:
* In bi_end_io, e.g. raid1_end_write_request, R1BIO_WriteError is
  set on the r1bio.
* The md thread calls handle_write_finished corresponding to this r1bio.
* Inside handle_write_finished, narrow_write_error is invoked.
* narrow_write_error rewrites the r1bio on a per-sector basis, marking
  any failed sectors as badblocks. It returns true if all sectors succeed,
  or if failed sectors are successfully recorded via rdev_set_badblock.
  It returns false if rdev_set_badblock fails or if badblocks are disabled.
* handle_write_finished faults the rdev if it receives false from
  narrow_write_error. Otherwise, it does nothing.

This can cause a problem where an r1bio that succeeded on retry is
incorrectly reported as failed to the higher layer, for example in the
following case:
* Only one In_sync rdev exists, and
* The write bio initially failed but all retries in
  narrow_write_error succeed.

This commit ensures that if a write initially fails but all retries in
narrow_write_error succeed, R1BIO_Uptodate or R10BIO_Uptodate is set
and the higher layer receives a successful write status.

Signed-off-by: Kenta Akagi <k@mgml.me>
---
 drivers/md/raid1.c  | 32 ++++++++++++++++++++++++++------
 drivers/md/raid10.c | 21 +++++++++++++++++++++
 2 files changed, 47 insertions(+), 6 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 8fff9dacc6e0..806f5cb33a8e 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2517,6 +2517,21 @@ static void fix_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 	}
 }
 
+/**
+ * narrow_write_error() - Retry write and set badblock
+ * @r1_bio:	the r1bio containing the write error
+ * @i:		which device to retry
+ *
+ * Rewrites the bio, splitting it at the least common multiple of the logical
+ * block size and the badblock size. Blocks that fail to be written are marked
+ * as bad. If badblocks are disabled, no write is attempted and false is
+ * returned immediately.
+ *
+ * Return:
+ * * %true	- all blocks were written or marked bad successfully
+ * * %false	- bbl disabled or
+ *		  one or more blocks write failed and could not be marked bad
+ */
 static bool narrow_write_error(struct r1bio *r1_bio, int i)
 {
 	struct mddev *mddev = r1_bio->mddev;
@@ -2614,9 +2629,9 @@ static void handle_write_finished(struct r1conf *conf, struct r1bio *r1_bio)
 	int m, idx;
 	bool fail = false;
 
-	for (m = 0; m < conf->raid_disks * 2 ; m++)
+	for (m = 0; m < conf->raid_disks * 2 ; m++) {
+		struct md_rdev *rdev = conf->mirrors[m].rdev;
 		if (r1_bio->bios[m] == IO_MADE_GOOD) {
-			struct md_rdev *rdev = conf->mirrors[m].rdev;
 			rdev_clear_badblocks(rdev,
 					     r1_bio->sector,
 					     r1_bio->sectors, 0);
@@ -2628,12 +2643,17 @@ static void handle_write_finished(struct r1conf *conf, struct r1bio *r1_bio)
 			 */
 			fail = true;
 			if (!narrow_write_error(r1_bio, m))
-				md_error(conf->mddev,
-					 conf->mirrors[m].rdev);
+				md_error(conf->mddev, rdev);
 				/* an I/O failed, we can't clear the bitmap */
-			rdev_dec_pending(conf->mirrors[m].rdev,
-					 conf->mddev);
+			else if (test_bit(In_sync, &rdev->flags) &&
+				 !test_bit(Faulty, &rdev->flags) &&
+				 rdev_has_badblock(rdev,
+						   r1_bio->sector,
+						   r1_bio->sectors) == 0)
+				set_bit(R1BIO_Uptodate, &r1_bio->state);
+			rdev_dec_pending(rdev, conf->mddev);
 		}
+	}
 	if (fail) {
 		spin_lock_irq(&conf->device_lock);
 		list_add(&r1_bio->retry_list, &conf->bio_end_io_list);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index b73af94a88b0..21c2821453e1 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2809,6 +2809,21 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 	}
 }
 
+/**
+ * narrow_write_error() - Retry write and set badblock
+ * @r10_bio:	the r10bio containing the write error
+ * @i:		which device to retry
+ *
+ * Rewrites the bio, splitting it at the least common multiple of the logical
+ * block size and the badblock size. Blocks that fail to be written are marked
+ * as bad. If badblocks are disabled, no write is attempted and false is
+ * returned immediately.
+ *
+ * Return:
+ * * %true	- all blocks were written or marked bad successfully
+ * * %false	- bbl disabled or
+ *		  one or more blocks write failed and could not be marked bad
+ */
 static bool narrow_write_error(struct r10bio *r10_bio, int i)
 {
 	struct bio *bio = r10_bio->master_bio;
@@ -2975,6 +2990,12 @@ static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
 				fail = true;
 				if (!narrow_write_error(r10_bio, m))
 					md_error(conf->mddev, rdev);
+				else if (test_bit(In_sync, &rdev->flags) &&
+					 !test_bit(Faulty, &rdev->flags) &&
+					 rdev_has_badblock(rdev,
+							   r10_bio->devs[m].addr,
+							   r10_bio->sectors) == 0)
+					set_bit(R10BIO_Uptodate, &r10_bio->state);
 				rdev_dec_pending(rdev, conf->mddev);
 			}
 			bio = r10_bio->devs[m].repl_bio;
-- 
2.50.1

