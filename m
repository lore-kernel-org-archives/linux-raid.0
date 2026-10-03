Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23CE392806;
	Sat,  3 Oct 2026 10:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791022841; cv=none; b=tcCZbbxOHDA9yONFnSvaQJFx3Z2aNcyvD/06n88YWhpU9I3JemxK8kNkMnOgX698GKOa/fgbW07ilHP79R1a90k2gIge7q1M62tIltQ30AgtFPutmjzSHL+hoxNTE/Y75Kdpx/QwaU5U+tfz2WMJwRg3vUOtWvsCnSltJON47BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791022841; c=relaxed/simple;
	bh=8C7vQGzDAjMbJIRvSMyXStnmuB9XlKvuAI6DxaKGsUI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=X6qKWAwWQEjf3f1depBzmX1OaX1aIlAkA0RR4YBdCq4TzyAtlCG6XGWlhydbjoXTH+VL7JeD5lRf4RppbyB70RVIeE5EfgvXyqbpy0obv1Rgs6e0LwW0GWsFdGjSMG89pFJgl8XGjqOkkKZy71BH0a9Rgm3hrGflOwqr1DGsGWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=AnFbkQsZ; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="AnFbkQsZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Dw
	QtR9NCNMdLIsCy0oeANhOBd/Rz++LDVaFmsqW6IJc=; b=AnFbkQsZat/ekUmOLE
	99lysrzE97g5grp0QuVzz30S2Gryk99L7Gt5wZ/eCd4DLKk9nqSuRmdKDasfmx+I
	POIiYkRdWBcgtMaLkCGXhk4kW5qKvFJPtRySah8mb9w8+PAm2aDYbu3MT0TVZ0W7
	dkz3EdWQUfT2ilmuMremXWJiI=
Received: from localhost.localdomain (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgDXpxjF1sBqMjkECQ--.28727S2;
	Sat, 03 Oct 2026 18:19:50 +0800 (CST)
From: "Li Youhong" <dayou5941@163.com>
To: song@kernel.org,
	yukuai@fygo.io
Cc: magiclinan@didiglobal.com,
	xiao@kernel.org,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Li Youhong <liyouhong@kylinos.cn>,
	syzbot+89a9ab2a134d092fffae@syzkaller.appspotmail.com
Subject: [PATCH] md: drain active_io before clearing pers on stop
Date: Sat,  3 Oct 2026 18:19:48 +0800
Message-Id: <20261003101948.1690687-1-dayou5941@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PCgvCgDXpxjF1sBqMjkECQ--.28727S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3Gw4xGFWUXw4DAFWrJF1fJFb_yoW7ZF15p3
	y8tFZ8tr4DJ3y3ta1UJa4kWa45Xwn7KFWDtrZrW3yak3W3trs5GF1Fgw1UAryqkas5uw1D
	tws8Wa1UCF1UWFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jY89tUUUUU=
X-CM-SenderInfo: 5gd103ivzuiqqrwthudrp/xtbC3QexYGrA1sdQUAAA3w

From: Li Youhong <liyouhong@kylinos.cn>

STOP_ARRAY clears mddev->pers while a direct bio can already be in
md_handle_request(). fork() shares the block-device file, so openers
stays 1 and the stop is allowed, and sync_blockdev() does not wait for
O_DIRECT. The bio passes the pers check in md_submit_bio(), then pers
is cleared and md_handle_request() dereferences pers->make_request.

Suspend the array before __md_stop() so percpu_ref_kill(active_io) makes
later tryget_live fail and the wait runs until every make_request holder
has dropped the ref. The suspend taken here is resumed after pers is
cleared, which wakes bios blocked in md_handle_request(). They see
pers == NULL and complete with bio_io_error(). dm-raid already holds
its own suspend across md_stop() and that path is unchanged.

reconfig_mutex is dropped around mddev_suspend() and mddev_resume().
stop_draining is set across that window so mddev_lock() returns
-EBUSY.

Reported-by: syzbot+89a9ab2a134d092fffae@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=89a9ab2a134d092fffae
Fixes: 409c57f38017 ("md: enable suspend/resume of md devices.")
Signed-off-by: Li Youhong <liyouhong@kylinos.cn>
---
 drivers/md/md.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++---
 drivers/md/md.h |  7 ++++++
 2 files changed, 66 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 680b34a63cb3..85158a99277f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -395,6 +395,8 @@ static bool is_suspended(struct mddev *mddev, struct bio *bio)
 
 bool md_handle_request(struct mddev *mddev, struct bio *bio)
 {
+	struct md_personality *pers;
+
 check_suspended:
 	if (unlikely(md_cloned_bio(mddev, bio))) {
 		/*
@@ -402,6 +404,12 @@ bool md_handle_request(struct mddev *mddev, struct bio *bio)
 		 * active_io reference, so percpu_ref_get() is safe here.
 		 */
 		percpu_ref_get(&mddev->active_io);
+		pers = READ_ONCE(mddev->pers);
+		if (!pers) {
+			percpu_ref_put(&mddev->active_io);
+			bio_io_error(bio);
+			return true;
+		}
 	} else {
 		if (is_suspended(mddev, bio)) {
 			/* Bail out if REQ_NOWAIT is set for the bio */
@@ -409,14 +417,20 @@ bool md_handle_request(struct mddev *mddev, struct bio *bio)
 				bio_wouldblock_error(bio);
 				return true;
 			}
-			wait_event(mddev->sb_wait, !is_suspended(mddev, bio));
+			wait_event(mddev->sb_wait, !is_suspended(mddev, bio) ||
+				   !READ_ONCE(mddev->pers));
+		}
+		pers = READ_ONCE(mddev->pers);
+		if (!pers) {
+			bio_io_error(bio);
+			return true;
 		}
 		if (!percpu_ref_tryget_live(&mddev->active_io))
 			goto check_suspended;
 	}
-	if (!mddev->pers->make_request(mddev, bio)) {
+	if (!pers->make_request(mddev, bio)) {
 		percpu_ref_put(&mddev->active_io);
-		if (mddev_is_dm(mddev) && mddev->pers->prepare_suspend)
+		if (mddev_is_dm(mddev) && pers->prepare_suspend)
 			return false;
 		goto check_suspended;
 	}
@@ -7097,6 +7111,32 @@ static void __md_stop(struct mddev *mddev)
 	clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 }
 
+/* Drop reconfig_mutex around suspend so in-flight IO can update the superblock. */
+static int md_suspend_for_stop(struct mddev *mddev, bool interruptible)
+{
+	int err;
+
+	lockdep_assert_held(&mddev->reconfig_mutex);
+
+	WRITE_ONCE(mddev->stop_draining, 1);
+	mutex_unlock(&mddev->reconfig_mutex);
+	err = mddev_suspend(mddev, interruptible);
+	mddev_lock_nointr(mddev);
+	WRITE_ONCE(mddev->stop_draining, 0);
+	return err;
+}
+
+static void md_resume_for_stop(struct mddev *mddev)
+{
+	lockdep_assert_held(&mddev->reconfig_mutex);
+
+	WRITE_ONCE(mddev->stop_draining, 1);
+	mutex_unlock(&mddev->reconfig_mutex);
+	__mddev_resume(mddev, false);
+	mddev_lock_nointr(mddev);
+	WRITE_ONCE(mddev->stop_draining, 0);
+}
+
 void md_stop(struct mddev *mddev)
 {
 	lockdep_assert_held(&mddev->reconfig_mutex);
@@ -7164,6 +7204,8 @@ static int do_md_stop(struct mddev *mddev, int mode)
 	struct gendisk *disk = mddev->gendisk;
 	struct md_rdev *rdev;
 	int did_freeze = 0;
+	int err = 0;
+	int resume = 0;
 
 	if (!test_bit(MD_RECOVERY_FROZEN, &mddev->recovery)) {
 		did_freeze = 1;
@@ -7181,6 +7223,18 @@ static int do_md_stop(struct mddev *mddev, int mode)
 		}
 		return -EBUSY;
 	}
+
+	if (mddev->pers) {
+		err = md_suspend_for_stop(mddev, true);
+		if (err) {
+			if (did_freeze) {
+				clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+				set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+			}
+			return err;
+		}
+		resume = 1;
+	}
 	if (mddev->pers) {
 		if (!md_is_rdwr(mddev))
 			set_disk_ro(disk, 0);
@@ -7205,6 +7259,8 @@ static int do_md_stop(struct mddev *mddev, int mode)
 		if (!md_is_rdwr(mddev))
 			mddev->ro = MD_RDWR;
 	}
+	if (resume)
+		md_resume_for_stop(mddev);
 	/*
 	 * Free resources if final stop
 	 */
diff --git a/drivers/md/md.h b/drivers/md/md.h
index b6d2e8929a0f..745f0c57f669 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -414,6 +414,8 @@ struct mddev {
 	unsigned long			sb_flags;
 
 	int				suspended;
+	/* Set while do_md_stop() has dropped reconfig_mutex to drain IO. */
+	int				stop_draining;
 	struct mutex			suspend_mutex;
 	struct percpu_ref		active_io;
 	int				ro;
@@ -719,6 +721,11 @@ static inline int __must_check mddev_lock(struct mddev *mddev)
 		ret = -ENODEV;
 		mutex_unlock(&mddev->reconfig_mutex);
 	}
+	/* do_md_stop() is waiting for active_io with the mutex dropped. */
+	if (!ret && READ_ONCE(mddev->stop_draining)) {
+		ret = -EBUSY;
+		mutex_unlock(&mddev->reconfig_mutex);
+	}
 
 	return ret;
 }
-- 
2.25.1

