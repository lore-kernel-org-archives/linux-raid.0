Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=162.62.58.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795602904;
	b=LHL2pnuKln9SD8osgDjZtSohrq0OUpKYBagMF+Sg/Rn/Gm1oPfP/loXMAr66kgJkneEC
	 SihOZBtEL3MsID/8v6C0fgUrxe4RavdN0g4Olx2IjG+1+nHzloxiUhbL6rRE8Dj7kVMo8
	 IzC4a+4kzfTvS6Z9q/5FXPSDPAUu1qbJFTvprfFKd8URg7A5l6I4jMFGAijkKAD/JqW1t
	 QGb0qq8a8tfdod3NS0MPYcfjxTumy0vCZ5zuZMkESZaMkR08qLfJMmy0t7nHRHo5EpFpc
	 cP/GRgXY2ylt1o8NIXHsPZd+gzS5hJZM54cY+6HFmNJ46/Go/mylDobx71sfrh7vF2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795602904;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:Date:X-OQ-MSGID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=ZZPJe+zQaDM43aFiitskEkJeWtXoM+RhzmlWX3J2fzs=;
	b=CiahhUgjbSG/EvWeFsJMhY9HL6rNyCSHaHSnXg+kQTUm77qucaQUAUyax4YuaaydeOgx
	 gA5OrIE3i4wbk6DBFtfHEzs/UDE+F7LkBG3KYmdMvckoZpBozPKG+dJORq/aArZ9h60y0
	 +5dhk93J16+2IHhkXEleO3T/lMCPbYOX9UxGAN9HXxYmRM5M8B6eilZ1uOMOqbmNrgNm0
	 I55nowSabbRtPlavCeGMK5y2J1DO0Sl7xsaSx0VlpUwQSkwRicM8vDdIhtIO0EChIZfzy
	 jSEukR7VNHvYyeycbmU7+L0GA8yU6iGHTygA+gITqg3GlrBvu9grNhe+OXXIs0n2+9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=XVKkgzPD;
	arc=none smtp.remote-ip=162.62.58.211
Received: from out162-62-58-211.mail.qq.com (out162-62-58-211.mail.qq.com [162.62.58.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0BC606A693
	for <linux-raid@vger.kernel.org>; Wed, 25 Nov 2026 10:35:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2B0BC606A693
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=XVKkgzPD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1795602899; bh=ZZPJe+zQaDM43aFiitskEkJeWtXoM+RhzmlWX3J2fzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XVKkgzPDVsR90j0wQOGOaGMEUwL+u5QGYoFlk1J9qqjOaZ7MuTwXA9BF71HWXp3zg
	 8kYnbRvtoZGKHdVrjDuOSxZhJARSAV89txUJdOh9AIBbZyCj5EHGK5DYeC37SsUuBm
	 yj0Bli+RfaeUMZ4L6dLn+lnWCzd/6VH6rRV6ymDk=
Received: from shuai-VMware-Virtual-Platform.. ([117.158.156.199])
	by newxmesmtplogicsvrszb51-0.qq.com (NewEsmtp) with SMTP
	id 8B89C037; Wed, 25 Nov 2026 18:34:56 +0800
X-QQ-mid: xmsmtpt1795602896t9kyrej4s
Message-ID: <tencent_72E3228BE54C78B91F4B5BB1A4C84B34090A@qq.com>
X-QQ-XMAILINFO: NLIE/45Aq5Wik8L+RsjcQUgawFeMiA1o3R24V1hHYkWmlNQxHBM8n2qqAq5k9R
	 iOpLw3yU/GEf4P/RF+RRwBoEiVc24tO0oPmLVQY8RGfHDgBIZJMZeOrim8NZuYFED9nXDtrSvvNZ
	 YOp/D0QwgpLyg/ajDh8Ghi2aBJGnCdFv8Qfn1u9i3FbzeGTYQdqW86zCdq05o6apALYAGZqiXrml
	 g7MwB+XMleyU/c1yP/OivYtGDjMdqGDqDKcwNe1EIh2NB7sCp1yeDLYzrX7SyMxGLc7JcuRfJ7SP
	 22pvgHbNLX9F5oSHBEwaHSDg7sno64f6XoB6+ZrsGcAZBkx0qJJtrn8Ad8mOb3Ib3eGLYZjiBr/w
	 BpuqKPaQHg7ByJuGdmIMpmEqsYXn7IhqXVsp9MqiNN1qJoXaZuMoCmwcNYuEf+HhGqqcPrGgBOlE
	 8HEUqiUASYSLVXfgLznh3Vl8I6yhwyaTNnjlBxjpa0xUTX1sd2hP9tpNhoyp8DPdYs5Ble4MbhSk
	 vyXu7kD9D91Ta+XSAiqxYugPhjoEEoUcvFnlf/0aIroKBsp4Cu8H5b0xhZamsUa0sH63tWI0Sc00
	 wm1msOS1YHPuk3I4hYJXMTzm+uH4QviwfIA1zX1IE1bqbCvjlqRMSApxnyU0w/Hh5nDH4NcHh3NV
	 NzmUcP+Ll7fCbA+mqLUcn4i+ICxgYpeAunISIHo+MH1VCPTQYeMOZ3Ae70vAvIaxWiwOi9SuQ522
	 ts6G7btPfkVuT6he1P9uR+K9W3aYK/t6zzkd2k/mguHRIBss5nw8vda8wS+g1YHC11Rq6xUNW9Lq
	 9LJtwbNsQLQluNb1uMZrOgMqD4O7jVBQe0nP3o49qV5YsbwUn1WxCVkwHU4kMGJIauQYXvSMbPtp
	 cc3lJUYU7Q/ZdKwpO4ndvBa71iXtXUNeMtY1bEU/OuENOPen7qYJDhxBGqp8l3nFUZ4pmMSB8+Zj
	 KNb9K2Rrq+syX3JajLO8Z6AWGy52suruBhudTu3ykkRDE5qWhhNNHIlWHxj3hBvxwU+OgV1/5V6C
	 dBYyxGsVUza3xUEp1yKIeG2dDKBNHmiOgtu1BivnSCS+TlJQettwwOgLKvbjnqqRvuSBGWR7r2YN
	 cAlHzYZqnGLwlBucPtHp9KfrU6TFTMi9QYyy3xiUt/vrNu7wo=
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
From: Shuai Liu <847807867@qq.com>
To: song@kernel.org,
	yukuai@fygo.io
Cc: magiclinan@didiglobal.com,
	xiao@kernel.org,
	syzbot+58beac388fb46ea52592@syzkaller.appspotmail.com,
	linux-raid@vger.kernel.org,
	Shuai Liu <847807867@qq.com>
Subject: [PATCH v2] md: fix use-after-free of mddev in md_start_sync workqueue
Date: Wed, 25 Nov 2026 18:34:56 +0800
X-OQ-MSGID: <20261125103456.2702777-1-847807867@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <6b04e83f.9a2182b0.37b108.0036.GAE@google.com>
References: <6b04e83f.9a2182b0.37b108.0036.GAE@google.com>
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

md_check_recovery() queues mddev->sync_work on md_misc_wq without taking
a reference on mddev. The mddev can be freed by another path that does
not go through do_md_stop() -> stop_sync_thread() and therefore never
flushes sync_work.

KASAN reports:
  BUG: KASAN: slab-use-after-free Read in mddev_unlock+0x909/0x9e0
  Read of size 8 at addr ffff8880367b21e8
    (offset 488 inside kmalloc-4k)
  by task kworker/1:2/1568, workqueue md_misc md_start_sync

  Allocated by task 9718:
    md_alloc -> md_probe -> blkdev_open (open /dev/mdX)
  Freed by task 5627:
    disk_release -> kobject_put -> mddev_free -> kfree(mddev)
  Last related work creation:
    md_check_recovery() queue_work(md_misc_wq, sync_work)

The UAF happens because the mddev-free path does not serialize with
sync_work. md_release() calls mddev_put() which may queue
mddev->del_work when mddev->active hits zero. del_work runs on
md_misc_wq and proceeds via
  kobject_release -> disk_release -> mddev_free -> kfree(mddev)
Meanwhile md_start_sync() computes mddev via container_of() on the
work_struct it was handed, and after mddev_unlock() returns it still
dereferences mddev members such as mddev->thread.

Crucially, mddev_delayed_delete() does not wait for md_misc_wq work
to drain: __mddev_put() just queues del_work with queue_work(). The
only place that flushes sync_work is stop_sync_thread(), which is
only invoked from do_md_stop() and the md_idle/md_frozen_sync_thread
helpers - all of which require holding reconfig_mutex. md_release()
does not take reconfig_mutex at all, so it can race with an
in-flight sync_work.

commit db5e653d7c9fae8ed61da58ab5e9a8db2cd61a2b
  ("md: delay choosing sync action to md_start_sync()")
moved md_choose_sync_action(), mddev_lock_nointr() and
mddev_unlock() into md_start_sync() so that array reconfiguration
became independent of the daemon thread. This change caused
md_start_sync() to actually dereference mddev members after
acquiring the lock. Prior to that commit the sync_work function
barely touched mddev and the lack of a bump was harmless.

The core fix: take an mddev reference before queueing sync_work and
release it at every return point in md_start_sync().

Two additional races surfaced when this patch was reviewed. They are
addressed in this same revision:

 1. stop_sync_thread() short-circuits on !MD_RECOVERY_RUNNING and
    on !work_pending(&mddev->sync_work). But the workqueue core
    clears WORK_STRUCT_PENDING_BIT before invoking the callback,
    so work_pending() is false while the work is running. And
    md_start_sync() used to clear MD_RECOVERY_RUNNING in the
    not_running path before mddev_unlock() completed, meaning
    stop_sync_thread() could observe !RUNNING and return while
    md_start_sync() was still mid-execution. Fix by removing the
    early return, making flush_work() unconditional, and moving
    clear_bit(MD_RECOVERY_RUNNING) + wake_up(&resync_wait) to the
    very end of md_start_sync() (immediately before mddev_put).

 2. The read-only branch of md_check_recovery() queued sync_work
    without checking MD_RECOVERY_FROZEN, unlike the main branch.
    Add the matching frozen guard.

Together these changes eliminate the original KASAN UAF and close
two remaining race windows that could otherwise be exploited via
do_md_stop(), raid_dtr (dm-raid uses raid_set which embeds mddev),
or md_stop_writes.

Checkpatch: 0 errors, 0 warnings on the diff.
Kernel build: make drivers/md/md.o succeeds on top of Linux 7.4-rc5.
A syzbot-supplied C reproducer is unavailable; this patch is
verified by the reference-accounting fix pattern and by the
compiler.

v2 changes since v1:
 - unconditional flush_work() in stop_sync_thread() instead of
   !RUNNING early return + work_pending() guard
 - move clear_bit(MD_RECOVERY_RUNNING) + wake_up into
   md_start_sync()'s not_running tail
 - add MD_RECOVERY_FROZEN guard to md_check_recovery's read-only
   branch

Fixes: db5e653d7c9f ("md: delay choosing sync action to md_start_sync()")
Reported-by: syzbot+58beac388fb46ea52592@syzkaller.appspotmail.com
Closes: https://syzbot.org/bug?extid=58beac388fb46ea52592
Signed-off-by: Shuai Liu <847807867@qq.com>
---
 drivers/md/md.c | 45 +++++++++++++++++++++++++++++++++------------
 1 file changed, 33 insertions(+), 12 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 03e35386a8028..d64aacbe51773 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5199,13 +5199,13 @@ static void stop_sync_thread(struct mddev *mddev, bool locked)
 {
 	int sync_seq = atomic_read(&mddev->sync_seq);
 
-	if (!test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
-		if (!locked)
-			mddev_unlock(mddev);
-		return;
-	}
-
-	mddev_unlock(mddev);
+	/*
+	 * Release reconfig_mutex before flushing sync_work or waiting on
+	 * resync_wait. md_start_sync() needs reconfig_mutex via
+	 * mddev_lock_nointr(), so holding it here would deadlock.
+	 */
+	if (locked)
+		mddev_unlock(mddev);
 
 	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 	/*
@@ -5213,8 +5213,18 @@ static void stop_sync_thread(struct mddev *mddev, bool locked)
 	 * never happen
 	 */
 	md_wakeup_thread_directly(&mddev->sync_thread);
-	if (work_pending(&mddev->sync_work))
-		flush_work(&mddev->sync_work);
+	/*
+	 * Always flush sync_work so that even an in-flight invocation
+	 * (already removed from the workqueue's pending list but not yet
+	 * returned from md_start_sync()) is drained. Previously this was
+	 * gated on work_pending() which is false for running work, and the
+	 * whole path could be short-circuited by MD_RECOVERY_RUNNING being
+	 * already clear — but md_start_sync() now only clears RUNNING after
+	 * its full tail, and unconditionally flushing handles any remaining
+	 * race where stop_sync_thread() was entered while sync_work was
+	 * already in flight.
+	 */
+	flush_work(&mddev->sync_work);
 
 	wait_event(resync_wait,
 		   !test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
@@ -10362,6 +10372,7 @@ static void md_start_sync(struct work_struct *ws)
 	md_wakeup_thread(mddev->sync_thread);
 	sysfs_notify_dirent_safe(mddev->sysfs_action);
 	md_new_event();
+	mddev_put(mddev);
 	return;
 
 not_running:
@@ -10369,7 +10380,6 @@ static void md_start_sync(struct work_struct *ws)
 	clear_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
 	clear_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
 	clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
-	clear_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
 	mddev_unlock(mddev);
 	/*
 	 * md_start_sync was triggered by MD_RECOVERY_NEEDED, so we should
@@ -10382,10 +10392,18 @@ static void md_start_sync(struct work_struct *ws)
 		__mddev_resume(mddev, false);
 	}
 
-	wake_up(&resync_wait);
 	if (test_and_clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery) &&
 	    mddev->sysfs_action)
 		sysfs_notify_dirent_safe(mddev->sysfs_action);
+	/*
+	 * Drop RUNNING only after the full tail of md_start_sync()
+	 * completes so that stop_sync_thread() can't observe !RUNNING and
+	 * return while md_start_sync() is still mid-execution. The put
+	 * follows so mddev remains alive while the flag is cleared.
+	 */
+	clear_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
+	wake_up(&resync_wait);
+	mddev_put(mddev);
 }
 
 static void unregister_sync_thread(struct mddev *mddev)
@@ -10522,8 +10540,10 @@ void md_check_recovery(struct mddev *mddev)
 			 * Let md_start_sync() to remove and add rdevs to the
 			 * array.
 			 */
-			if (md_spares_need_change(mddev)) {
+			if (!test_bit(MD_RECOVERY_FROZEN, &mddev->recovery) &&
+			    md_spares_need_change(mddev)) {
 				set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
+				atomic_inc(&mddev->active);
 				queue_work(md_misc_wq, &mddev->sync_work);
 			}
 
@@ -10580,6 +10600,7 @@ void md_check_recovery(struct mddev *mddev)
 
 		if (test_and_clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery) &&
 		    !test_bit(MD_RECOVERY_FROZEN, &mddev->recovery)) {
+			atomic_inc(&mddev->active);
 			queue_work(md_misc_wq, &mddev->sync_work);
 		} else {
 			clear_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
-- 
2.43.0

