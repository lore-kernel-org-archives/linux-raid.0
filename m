Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6B24766BF;
	Tue, 15 Sep 2026 08:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789461284; cv=none; b=asYgtvxQFEKgqwV7KnTH3iYX0FN+c+ToOh1QqwEXzpQmesuEvddUZHyhulF20LRjbk2m+PtRCbgZt8RE0UDxK5PjjW+2QYtpE/cLmOfCc9ms7NxILzdKwFmqnuHr2lr4InP6IbVTT+DamH4eLGKEWzqBrkzavK+XNmwE7SCn7/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789461284; c=relaxed/simple;
	bh=6DLNcmtvRsehOtnn2S88NWmL6N3IMM5srCTOmr+cYhQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ObJtWebnBxJyVsyXLoaqz5nHqrBLZUoU3tcRwfRVoSOhAySaHXIsbjxhQubv03ZUv2OaNCbL371pV2LOlOGY1lkl4hbbIS9lN99t4BaAKgBe7JsnJJzH5CscF6uCnMgh8gOY/gBfPR0r+qkZmsq8vEUCYizVTrXUH/2kyupV4Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=peQmBNAP; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="peQmBNAP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=UU
	eT3fPjaKoDpC/6zpcrC4PUg2GLPa4VJpN10SVSjj0=; b=peQmBNAP/LBWc03Sx8
	doKnRsK69tihp8LHlLZAMrgjCVtvaGvBvHwJUELnUjxRGM9w1K7YYV/kffAoIXVh
	vmT8GRGfh53nHu0m4qZ6tEW3UefIe+YG+ky1Ifx+zykrDOLRbqEYTKmUKhXmmKlg
	lly+kRMiWzRyZgTOyX+jNvPmc=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wA3RXrzAqlqno1LAw--.39237S2;
	Tue, 15 Sep 2026 16:33:56 +0800 (CST)
From: "Li Youhong" <dayou5941@163.com>
To: song@kernel.org,
	yukuai@fygo.io
Cc: magiclinan@didiglobal.com,
	xiao@kernel.org,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Li Youhong <liyouhong@kylinos.cn>,
	syzbot+68e1f51046d68329940f@syzkaller.appspotmail.com
Subject: [PATCH] md: don't flush md_misc_wq from md_alloc()
Date: Tue, 15 Sep 2026 16:33:54 +0800
Message-Id: <20260915083354.1603416-1-dayou5941@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wA3RXrzAqlqno1LAw--.39237S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxZFy5ArW7Kr47JF1fArykGrg_yoWrXw18pr
	W5tF15trW8tr4jqayUKa1UWa45Kw1kKr9rXryIgw1SyFn5Xry8Wws7Ka48XFW5JFZ8XF45
	AFWrXFZxua4UtrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UlNt3UUUUU=
X-CM-SenderInfo: 5gd103ivzuiqqrwthudrp/xtbC+RXCcWqpAvXjOAAA3w

From: Li Youhong <liyouhong@kylinos.cn>

md_alloc() is called from md_probe(), while blk_probe_dev() still holds
major_names_lock. The flush of md_misc_wq in md_alloc() is only meant to
wait for the previous mddev_delayed_delete() to finish.

md_misc_wq also runs sync_work (md_start_sync), and md_start_sync takes
reconfig_mutex. On the other path, md_ioctl() already holds
reconfig_mutex when md_import_device() opens a bdev and takes
major_names_lock.

Flushing md_misc_wq under major_names_lock therefore creates a lockdep
cycle:

  major_names_lock -> md_misc_wq -> reconfig_mutex -> major_names_lock

Move del_work to a dedicated workqueue and flush only that queue from
md_alloc(). Leave sync_work on md_misc_wq.

Reported-by: syzbot+68e1f51046d68329940f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=68e1f51046d68329940f
Fixes: e804ac780e2f ("md: fix and update workqueue usage")
Signed-off-by: Li Youhong <liyouhong@kylinos.cn>
---
 drivers/md/md.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 680b34a63cb3..87a851466892 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -86,13 +86,16 @@ static const struct kobj_type md_ktype;
 static DECLARE_WAIT_QUEUE_HEAD(resync_wait);
 
 /*
- * This workqueue is used for sync_work to register new sync_thread, and for
- * del_work to remove rdev, and for event_work that is only set by dm-raid.
+ * md_misc_wq runs sync_work (new sync_thread) and event_work (dm-raid).
+ * sync_work grabs reconfig_mutex, so this queue must not be flushed while
+ * holding reconfig_mutex, nor while holding major_names_lock (md_probe /
+ * md_alloc is called from blk_probe_dev with that lock held).
  *
- * Noted that sync_work will grab reconfig_mutex, hence never flush this
- * workqueue whith reconfig_mutex grabbed.
+ * md_del_wq runs only del_work (mddev_delayed_delete). md_alloc() flushes
+ * this queue to wait for a previous instance of the same device to go away.
  */
 static struct workqueue_struct *md_misc_wq;
+static struct workqueue_struct *md_del_wq;
 
 static int remove_and_add_spares(struct mddev *mddev,
 				 struct md_rdev *this);
@@ -651,7 +654,7 @@ static void __mddev_put(struct mddev *mddev)
 	 * Call queue_work inside the spinlock so that flush_workqueue() after
 	 * mddev_find will succeed in waiting for the work to be done.
 	 */
-	queue_work(md_misc_wq, &mddev->del_work);
+	queue_work(md_del_wq, &mddev->del_work);
 }
 
 static void mddev_put_locked(struct mddev *mddev)
@@ -6329,9 +6332,12 @@ struct mddev *md_alloc(dev_t dev, char *name)
 
 	/*
 	 * Wait for any previous instance of this device to be completely
-	 * removed (mddev_delayed_delete).
+	 * removed (mddev_delayed_delete). Do not flush md_misc_wq: it also
+	 * runs sync_work, which takes reconfig_mutex and can take
+	 * major_names_lock via md_import_device(). md_alloc() is called from
+	 * md_probe() while blk_probe_dev() already holds major_names_lock.
 	 */
-	flush_workqueue(md_misc_wq);
+	flush_workqueue(md_del_wq);
 
 	mutex_lock(&disks_mutex);
 	mddev = mddev_alloc(dev);
@@ -10765,6 +10771,10 @@ static int __init md_init(void)
 	if (!md_misc_wq)
 		goto err_misc_wq;
 
+	md_del_wq = alloc_workqueue("md_del", WQ_PERCPU, 0);
+	if (!md_del_wq)
+		goto err_del_wq;
+
 	ret = __register_blkdev(MD_MAJOR, "md", md_probe);
 	if (ret < 0)
 		goto err_md;
@@ -10783,6 +10793,8 @@ static int __init md_init(void)
 err_mdp:
 	unregister_blkdev(MD_MAJOR, "md");
 err_md:
+	destroy_workqueue(md_del_wq);
+err_del_wq:
 	destroy_workqueue(md_misc_wq);
 err_misc_wq:
 	md_llbitmap_exit();
@@ -11093,6 +11105,7 @@ static __exit void md_exit(void)
 	spin_unlock(&all_mddevs_lock);
 
 	destroy_workqueue(md_misc_wq);
+	destroy_workqueue(md_del_wq);
 	md_bitmap_exit();
 }
 
-- 
2.43.0

