Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=162.62.58.216
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795653960;
	b=rud86LFF6g69zgtY+FRj1BjQRsHqwwc2vcOq7U03BCzj+OVZyCEfiVgPZTpgMchk2pPm
	 Zm2UiJEAy2Ex+NDp4jklzVaal0EpnS/y2wd7M86NGrGA5IL5EuY85MuVKS7TIgRbiSMa1
	 /qkeKT9k2E1Zawyv7zllyDtcdF+29msG8ANtiVMc+1IbMwEuSISBuyeIeCqwhf80JT1LL
	 0cShQUBNLbnZcRViGRYRaoyaKodVr2K9XGrLuZxPF3CksK4cSSdk+hiVXMIvKj6UKolfv
	 CF06gLRCpE41h8Clm+PE5ApA+NnltPlP4Ha+LJqXudvmr0GKedLGTcqcfD662a3I1/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795653960;
	h=DMARC-Filter:DKIM-Signature:Received:X-QQ-mid:Message-ID:
	 X-QQ-XMAILINFO:X-QQ-XMRINFO:From:To:Cc:Subject:Date:X-OQ-MSGID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=X7wgyEBvNKNHFs2XEQ2QIntDmWd+F2tSnl7VfEit/Wg=;
	b=ve6v8tjUNo5OZkgSw2aFCwNioj17rVZ6BgoQ6ngDehrQjsyFyHHs2iaNm85J1Dv82zPM
	 /zjq3CFznMIbkKWN3mwcNf04/nrWCi5sBRkVvefiqa3eYouT4VyTN6ahZ2aMMdYBi0cjH
	 K2hdjKqhBT4DwOVmsoOoc/jzrs6W27jkaG1yA+LKIjRJsXzSl/SubtN49753YziRC/KVI
	 uTO23vH+WI3ktxph9Jlz4kf8yNGyMFq7IrvpgHXEe6df+XHYuc1DPnL7nP39KR/m/Dxns
	 LSKC0wgGuOpFSH9ZatPFguQ+tgFHoP/tOiu/LGgc8lz2qHUSnnU0Jdu6HDVoc0XUChA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=qq.com;
	spf=pass smtp.mailfrom=qq.com;
	dkim=pass header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=pX0cJLUB;
	arc=none smtp.remote-ip=162.62.58.216
Received: from out162-62-58-216.mail.qq.com (out162-62-58-216.mail.qq.com [162.62.58.216])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B31606A31E
	for <linux-raid@vger.kernel.org>; Thu, 26 Nov 2026 00:45:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 94B31606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=pX0cJLUB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1795653954; bh=X7wgyEBvNKNHFs2XEQ2QIntDmWd+F2tSnl7VfEit/Wg=;
	h=From:To:Cc:Subject:Date;
	b=pX0cJLUBuF4yOfKY9Rd781xI20uHtarnCC9jnEc5ai/QUswlwEnmvVjEVhLZXOo8b
	 5FD7kEMDzyhnazaJB3HFaVlqMFVh0V69I1TaWUMv8AVFSsx6v5rPhKjCoNi2qphT2I
	 e5zdG11rbrmIjv/Q/RftZyRitRAO84LoIwRJ5eYE=
Received: from shuai-VMware-Virtual-Platform.. ([117.158.156.198])
	by newxmesmtplogicsvrszc43-0.qq.com (NewEsmtp) with SMTP
	id B73BBC36; Thu, 26 Nov 2026 08:45:51 +0800
X-QQ-mid: xmsmtpt1795653951ted91rnrg
Message-ID: <tencent_B6137BEEFCD26A2CCBF27D4DF0B81D622608@qq.com>
X-QQ-XMAILINFO: MipYEBg1qKqIF7GB5FTNNcAT6f6qwOsDmEDTD9IGQge3hTZIuQ4YmiFEdw5+0k
	 CFAnJsrbDrBa9wW3y8P7VOtgGlaZt14GM7xuFD+Nhz5VpTEn/9lPHNpXrwR58rOq6GVQFFwlKn8R
	 ozFOTyESV0ykNXaTS+QyyAl4UxGxfVUzYN8AHr0kZJMVsyDpq7llqYKJpvZkZlRGTRtGHHyOL96x
	 zv7edko45YqxVkk7C2vxx72NSx++frxLEuZneFGz3i95EdPnWD+DEZIbQZHTH8HErikR2MKjpi34
	 UYf9x1j4ysRe7nW5k6isX+DaSmFyDs+qpoRdEElhgo/dmWDNFR85LlYBw7LeoOIyhARIhj8zzarq
	 Vo5TvTP8xNTo1vRUNlsPN38CDg1MTJqiAGZWlmExHytZwrWlXdZ1f5rii7FsLla3BZFMdKCiy9cA
	 B/42P4x9OBKbks577aQvkv5AFvWxIUkZqhpH9xmaJLKP19ZK/up5nH8smWHjpbgQDVA4KI/FHZpg
	 jYuzqU9eBb3L88ZfdNNnqCnTHnfkWHAmEo+iaME13HUChVX3u49wwkmbXlQqtdcAhYGh8MdC5nCP
	 /6oaGsKHgtOUgQUF3Cu7y+gGTJm7B2HSnhr6eCUq4vww9a/JScFTb5Y+dSwo2pJQy0rXKs2g/VPj
	 TgDJAM7UlEhxfn50i/OJN7k/RIx7OfFOtr7n6/Qhe5Mk7/BG1wt3Tlr1yXQ5SKG747FVIquA4HUu
	 17bpzqUBjppXg8ljwBv6aCe/Vd4nkHyceqUE+WSgTLZt/yHkVsUnH/JSCiEDcvDsb+gtWOtqiiEz
	 xa2FvEe4bTpNshIPwtjGNbbJhPnRLPjLT6d/xAucN8JhBCpGxiOWmtTiygyU4k0F3Y/oPDWgozxy
	 yVHf/P0McD4X9IGKr3jgmrePwzs4xbf3KMH0iQNxMnkUcLsx+1aF/sjmQiwkd4NqiH8+lVy4J+g+
	 JOcQukx3tH1R5C+/ACh9fhzPTx+GMY3jqmomChL0mtcL+gHpEFtHHe+7ZwlVZBVTUqc+42VUAFlZ
	 r5HUw2DZAQ2PoCbDDMTxV7dTJx6NemzyjIeNEW6ov64UkD3VTqtOO5oSFm2sOmtdeV3F+GM0sY5t
	 ErUds4CZBCb5h0kSU=
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
From: Shuai Liu <847807867@qq.com>
To: song@kernel.org,
	yukuai@fygo.io
Cc: magiclinan@didiglobal.com,
	xiao@kernel.org,
	syzbot+58beac388fb46ea52592@syzkaller.appspotmail.com,
	linux-raid@vger.kernel.org,
	Shuai Liu <847807867@qq.com>
Subject: [PATCH v3] md: fix use-after-free of mddev in md_start_sync workqueue
Date: Thu, 26 Nov 2026 08:45:51 +0800
X-OQ-MSGID: <20261126004551.3116737-1-847807867@qq.com>
X-Mailer: git-send-email 2.43.0
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
a reference on mddev. mddev can be freed by another path that never
flushes sync_work, leading to use-after-free in md_start_sync().

KASAN reports:
  BUG: KASAN: slab-use-after-free Read in mddev_unlock+0x909/0x9e0
  Read of size 8 at addr ffff8880367b21e8
    (offset 488 inside kmalloc-4k)
  by task kworker/1:2/1568, workqueue md_misc md_start_sync

  Allocated by task 9718: md_alloc -> md_probe -> blkdev_open
  Freed by task 5627: disk_release -> mddev_free -> kfree(mddev)
  Last related work creation:
    md_check_recovery() queue_work(md_misc_wq, sync_work)

commit db5e653d7c9f ("md: delay choosing sync action to md_start_sync()")
moved md_choose_sync_action(), mddev_lock_nointr() and mddev_unlock()
into md_start_sync() so that array reconfiguration became independent of
the daemon thread. Prior to this the sync_work function barely touched
mddev and the missing reference was harmless.

Fix this by taking an mddev reference before queueing sync_work and
releasing it in md_start_sync(). Three complementary fixes close
remaining race windows:

 - stop_sync_thread(): remove work_pending() guard so that running
   sync_work is always flushed (workqueue core clears PENDING before
   invoking callbacks, so work_pending() is false for running work).
   The !MD_RECOVERY_RUNNING early return is preserved to avoid setting
   MD_RECOVERY_INTR on idle arrays and to handle locked=false correctly.

 - md_check_recovery(): add MD_RECOVERY_FROZEN guard to the read-only
   branch so it matches the main branch.

 - dm-raid raid_dtr(): flush mddev->sync_work before raid_set_free().
   dm-raid embeds mddev in raid_set and frees it directly, bypassing
   mddev_free()'s mddev->active accounting. raid_dtr also does not
   invoke stop_sync_thread() via md_stop(), so the original race
   is not protected by either mechanism.

Fixes: db5e653d7c9f ("md: delay choosing sync action to md_start_sync()")
Reported-by: syzbot+58beac388fb46ea52592@syzkaller.appspotmail.com
Closes: https://syzbot.org/bug?extid=58beac388fb46ea52592
Signed-off-by: Shuai Liu <847807867@qq.com>
---
 drivers/md/dm-raid.c |  1 +
 drivers/md/md.c      | 10 +++++++---
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index e44d92462affc..2b7cd9488eec0 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3336,6 +3336,7 @@ static void raid_dtr(struct dm_target *ti)
 
 	if (rs->md.event_work.func)
 		flush_work(&rs->md.event_work);
+	flush_work(&rs->md.sync_work);
 	raid_set_free(rs);
 }
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 03e35386a8028..28f436fb1bad7 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5213,8 +5213,7 @@ static void stop_sync_thread(struct mddev *mddev, bool locked)
 	 * never happen
 	 */
 	md_wakeup_thread_directly(&mddev->sync_thread);
-	if (work_pending(&mddev->sync_work))
-		flush_work(&mddev->sync_work);
+	flush_work(&mddev->sync_work);
 
 	wait_event(resync_wait,
 		   !test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
@@ -10362,6 +10361,7 @@ static void md_start_sync(struct work_struct *ws)
 	md_wakeup_thread(mddev->sync_thread);
 	sysfs_notify_dirent_safe(mddev->sysfs_action);
 	md_new_event();
+	mddev_put(mddev);
 	return;
 
 not_running:
@@ -10386,6 +10386,7 @@ static void md_start_sync(struct work_struct *ws)
 	if (test_and_clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery) &&
 	    mddev->sysfs_action)
 		sysfs_notify_dirent_safe(mddev->sysfs_action);
+	mddev_put(mddev);
 }
 
 static void unregister_sync_thread(struct mddev *mddev)
@@ -10522,8 +10523,10 @@ void md_check_recovery(struct mddev *mddev)
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
 
@@ -10580,6 +10583,7 @@ void md_check_recovery(struct mddev *mddev)
 
 		if (test_and_clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery) &&
 		    !test_bit(MD_RECOVERY_FROZEN, &mddev->recovery)) {
+			atomic_inc(&mddev->active);
 			queue_work(md_misc_wq, &mddev->sync_work);
 		} else {
 			clear_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
-- 
2.43.0

