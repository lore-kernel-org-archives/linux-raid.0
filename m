Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=162.62.57.210
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795601546;
	b=d04/ntPQRTldXF9nZLPZOQVwOigp3aVyCfgYKOUT8DOJDJGimX09lmEBES9t9tveSk/h
	 /8jJQ+eeSGTOypbeY12PNYg6OJriokP7gaCzgCUmVJFBhrpCRA8P4tMjGRdxvyIrGNG7T
	 WQRFkIp0QqdMVp4H0KVSHQW+RtJpySGaYK0EGGl/hX4haPyqsfgN/dInqTx+pqybj+NtQ
	 Kr7nClaaWdPqQd+d2zfkWi7vVlDEM8rCuLQFHxneCxPc/uxrwDkvEuVoV0M7cVOqrCjaA
	 3VXDlzs4oiN4OURh/DkJKrTJAojdi422jcN8a+w+ofmMDlEToSgI2cBTRCyrTqvf/lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795601546;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:Date:X-OQ-MSGID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=2mX9ihDMlJl52xt1g1QIufip43JLdoxN/JQUfY4xZWY=;
	b=FbHDqiWkt5FvF1DEGfyYds2zC1fkE8cpujRNvzraQT1it4nyLQHIpNJqX5WpJPQFD19v
	 CV7s5Q24XWasI8/sxznsafVC4ftD2Gtjcg/MPfPl/lowj4pv1sORG+K4AHzhABI1xUQhl
	 /t2rndj0CRcbe0jEk+0Yr234sSmHbhag023tF0I/IIi3fl7wqoKQfkOYtWxUHGNhiHnQg
	 HGcWmfbfDRYzxc9Em1NJ8rFNGWrOzlSbynCv6RV7pe8w969Sv03fp7l/f00xd8jkpTTL/
	 Y2UPUYxilbM8RvmGQTL8akeHOr/6zu4FoXeZxaFEztYG3K1Q6x80eHDfZRPIYwBRxtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=EsKTVtfB;
	arc=none smtp.remote-ip=162.62.57.210
Received: from out162-62-57-210.mail.qq.com (out162-62-57-210.mail.qq.com [162.62.57.210])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59685606A326
	for <linux-raid@vger.kernel.org>; Wed, 25 Nov 2026 10:12:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 59685606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=EsKTVtfB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1795601534; bh=2mX9ihDMlJl52xt1g1QIufip43JLdoxN/JQUfY4xZWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EsKTVtfB5892vv208t9deIB76fppH5JAl3qGco7BHl0QolBlb/UwCS3JwYAn0dwPu
	 JPEft8yDwG+I8YiRMJ31+4f0QhChBMEguFUSUlFfPgRNt+THT+XYblzprI0YLIHk//
	 vQtfLL3aE5zCNqEFeNiCnbfroQdMbnhKjArpnyXw=
Received: from shuai-VMware-Virtual-Platform.. ([117.158.156.199])
	by newxmesmtplogicsvrsza73-0.qq.com (NewEsmtp) with SMTP
	id 30C26296; Wed, 25 Nov 2026 18:12:12 +0800
X-QQ-mid: xmsmtpt1795601532t46va9gsd
Message-ID: <tencent_FD9B3C56D33F6E8298C044857BB7342DCB06@qq.com>
X-QQ-XMAILINFO: NGbyafB8LluusTr9Kim79at49nIYAEbCQRkOih0+dxyG3c/XMseINZK1pAHaTJ
	 JPrnOviTR8RpEiSRjIrNqfPlU61s9PKCjU8au1pAUMp7Gs0AG9LLWu5YqMQb37PsWsd1sYtGTiC/
	 KVDdjuhL4XtoaGsMr9tlxgdnhC9K8pCeNze3IAGlwWRr/1GHc01aeTIR2I0HPYp7jSkQ+yg2oJOO
	 CDwWP8rZvmB7ZFbKMss0aKHX8Ao0LlyARUFRTaSpAyY4pXH+7uM5N+4tN247/ZuIackqH4/Oli3B
	 FIdOYqqd09ctCW6a0CV++QAzWj15ZjS8YX9gC0FfyOOqznNO+mqUSkN8PmCSKoWruu/aTqKPhQ4S
	 90vqOl+XozLGSFa691xec5nrDEydXihPNTVx2mZMej+GMjIOdKo0qjolC9lSZbDCcxbAGyiAXBUF
	 74//qcVMwGjhSd5CaHyHDQgsch8qLyCf7DMWanRxsi011Mvc0ASOHVUVi79kenXtoEiBO1k1Uyid
	 qPPXJKSIOfhmv6yGZ4j2Kz2rpdIvHJIWXWdt391wyji8k5NpgQHD64AIPkDAlFJ+TS9YyxVwm6Gv
	 qXNeVYsI0Cx7xSgvj02UVZEngfqKeZPD9LoUtGQbd+oGuXxvksM4iDl1MZVvDSfVyIM4CHUqKwdL
	 IGJy+F3aJdhihsjT6x2oEOp6pjmUsTwuogVxr2GMd8hdF/Mc/D8YYhJQxCWj9b0Zg/vVyyc4FE7f
	 tBtSwhi9hLXcHirvliXMqe5SuHDShmUFwf0RuQ0L2/AB9YAxM6tfhjIXmfzsH/I4xhL4obNE+iu7
	 ovJp+xTmh2hjHlzZDU/vGQ3uV7CY2GzfdDdKmOkoFtDttoWHDtqFIGC5YXGV0pGbUtfcU4q2GOcQ
	 6BMVx8+FWDw90VMuaVynXKXzQv96HSbVv9Mi+xDxW/KhwU2cPngVWZumBVzoQbYOVeKDIH9tW9sW
	 3jgcq686eTTBLXWjFQZ1z0dRoo0CqUb03O+QEUf324E4Xr4c2bCa0fyhhPooPau/A0WZMbO34x4g
	 lIDF9iwchwIh3G1KoI302CeW6FwxihgNqR/h1BzZD8rjP4F7Cf0aaj1D/n3wVN5uNwH9caxY/abu
	 5lDA6FW7wQGvAsQPo=
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
From: Shuai Liu <847807867@qq.com>
To: song@kernel.org,
	yukuai@fygo.io
Cc: magiclinan@didiglobal.com,
	xiao@kernel.org,
	syzbot+58beac388fb46ea52592@syzkaller.appspotmail.com,
	linux-raid@vger.kernel.org,
	Shuai Liu <847807867@qq.com>
Subject: [PATCH] md: fix use-after-free of mddev in md_start_sync workqueue
Date: Wed, 25 Nov 2026 18:12:12 +0800
X-OQ-MSGID: <20261125101212.2440528-1-847807867@qq.com>
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

Fix this by taking an mddev reference before queueing sync_work in
both md_check_recovery() paths that use it, and releasing that
reference at every return point inside md_start_sync().

Checkpatch: 0 errors, 0 warnings on drivers/md/md.c.
Kernel build: full make on top of Linux 7.4-rc5 succeeds
              (bzImage ready). A syzbot-supplied C reproducer for this
              issue is unavailable, so this patch is verified by code
              review of the reference-accounting pattern and the
              upstream build.

Fixes: db5e653d7c9f ("md: delay choosing sync action to md_start_sync()")
Reported-by: syzbot+58beac388fb46ea52592@syzkaller.appspotmail.com
Closes: https://syzbot.org/bug?extid=58beac388fb46ea52592
Signed-off-by: Shuai Liu <847807867@qq.com>
---
 drivers/md/md.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 03e35386a8028..4a40b4f358d84 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -10362,6 +10362,7 @@ static void md_start_sync(struct work_struct *ws)
 	md_wakeup_thread(mddev->sync_thread);
 	sysfs_notify_dirent_safe(mddev->sysfs_action);
 	md_new_event();
+	mddev_put(mddev);
 	return;
 
 not_running:
@@ -10386,6 +10387,7 @@ static void md_start_sync(struct work_struct *ws)
 	if (test_and_clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery) &&
 	    mddev->sysfs_action)
 		sysfs_notify_dirent_safe(mddev->sysfs_action);
+	mddev_put(mddev);
 }
 
 static void unregister_sync_thread(struct mddev *mddev)
@@ -10524,6 +10526,7 @@ void md_check_recovery(struct mddev *mddev)
 			 */
 			if (md_spares_need_change(mddev)) {
 				set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
+				atomic_inc(&mddev->active);
 				queue_work(md_misc_wq, &mddev->sync_work);
 			}
 
@@ -10580,6 +10583,7 @@ void md_check_recovery(struct mddev *mddev)
 
 		if (test_and_clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery) &&
 		    !test_bit(MD_RECOVERY_FROZEN, &mddev->recovery)) {
+			atomic_inc(&mddev->active);
 			queue_work(md_misc_wq, &mddev->sync_work);
 		} else {
 			clear_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
-- 
2.43.0

