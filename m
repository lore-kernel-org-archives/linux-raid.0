Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E6C12F585;
	Mon, 17 Aug 2026 03:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786937993; cv=none; b=Rtx69pF93KATAPtRDWj2S1ROfYQpr6DW2rGz3f4v4BNFo5qs3tlop8hAvH9hzz2jDZOdfPGWegmbAXgQil/22bmO2m2HyjfbX94t+jiVRDw096VEU2+ubH7xfahPa2oRDz0RG87PDgnTG/M+b1aZea0tNXH5sh0Ha0/lq1umGt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786937993; c=relaxed/simple;
	bh=IwVjahjJn+ZdvHfTf+caZIi2uaS64c7NgcNAx/8Sdd4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jukhS9V1op3nAYQdX6HtRtPy/5N6uYFpdfMOxwdc/eH/+cgk+mbu01zggHcB/bgTpWRAvrpHmaNcEmuIutZgIVo2PzwXhMXlVshvkPQ+wFXUAmGRam/afvcJIH2wYXd/XveUnLS9pXA9rjCv5LwykEks4ut/UQ9Qcb8fZRLK7p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=Nt+eXoSX; arc=none smtp.client-ip=113.46.200.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="Nt+eXoSX"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=yAjtlREqtUzi3zeRO7aDhDF+AxGZlDKRCOfVsKUr7J4=;
	b=Nt+eXoSXmVd9Cew4LGZTwt8d4oPdOGzFwOeHS6rFoqTwBlfheGguPSVViZXivB9ZTktQfNb2q
	DlJYoY8k6TAiygIZxMxdAtguk1j57GTq8hM55pangmOf+fy0+3GZ7CDZ4EPmcsozTHw7ROd05ml
	A7mx9pYqkowUzVISdguvjU8=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4hNdbl6nLPzRhQt;
	Mon, 17 Aug 2026 11:29:07 +0800 (CST)
Received: from kwepemf100017.china.huawei.com (unknown [7.202.181.16])
	by mail.maildlp.com (Postfix) with ESMTPS id 111EE40561;
	Mon, 17 Aug 2026 11:39:46 +0800 (CST)
Received: from localhost.localdomain (10.50.85.155) by
 kwepemf100017.china.huawei.com (7.202.181.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Mon, 17 Aug 2026 11:39:45 +0800
From: Zizhi Wo <wozizhi@huawei.com>
To: <song@kernel.org>, <yukuai@fygo.io>, <magiclinan@didiglobal.com>,
	<xiao@kernel.org>, <linux-raid@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <yangerkun@huawei.com>,
	<chengzhihao1@huawei.com>, <wozizhi@huawei.com>
Subject: [PATCH V2 2/2] md/raid10: fix missing wakeup in wait_barrier_nolock
Date: Mon, 17 Aug 2026 11:33:40 +0800
Message-ID: <20260817033340.418119-3-wozizhi@huawei.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260817033340.418119-1-wozizhi@huawei.com>
References: <20260817033340.418119-1-wozizhi@huawei.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemf100017.china.huawei.com (7.202.181.16)

[BUG]
Recently, our fuzz testing triggered a hungtask issue in RAID10:

INFO: task md0_raid10:1273 blocked for more than 120 seconds.
      Not tainted 7.2.0-rc6+ #94
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:md0_raid10      state:D stack:0     pid:1273  tgid:1273  ppid:2
Call Trace:
 <TASK>
 __schedule+0xdf9/0x5c90
 ? _raw_spin_unlock_irqrestore+0xe/0x40
 schedule+0x74/0x1f0
 raid10d.cold+0x7db/0x1992
 md_thread+0x1ce/0x3e0
 kthread+0x327/0x410
 ......

[CAUSE]
The root cause of the issue is as follows:
[read process1]			[read process2]			[raid10d]
raid10_make_request
...
 // nr_pending == 1
 atomic_inc(&conf->nr_pending)
...
raid10_end_read_request
 reschedule_retry
  md_wakeup_thread(mddev->thread)
				raid10_read_request
				 regular_request_wait
				  wait_barrier
				   wait_barrier_nolock
				    seq = read_seqbegin(&conf->resync_lock)
				    // nr_pending == 2
				    atomic_inc(&conf->nr_pending)
								raid10d
								 handle_read_error
								  freeze_array
								   write_seqlock_irq(&conf->resync_lock)
								   conf->array_freeze_pending++
								   WRITE_ONCE(conf->barrier, conf->barrier + 1)
								   conf->nr_waiting++
								   // nr_pending == 2, nr_queued == 0
								   wait_event_barrier_cmd
								    write_sequnlock_irq(&(conf)->resync_lock)
								    schedule	// hungtask!!
				    read_seqretry(&conf->resync_lock, seq)
				    // not wakeup because conf->nr_pending == 1
				    atomic_dec_and_test(&conf->nr_pending)
				   /* Hungtask will also occur here: since the barrier is non-zero,
				    * this I/O can never complete, so it can't call allow_barrier()
				    * to wake up the pending freeze_array(). */
				   wait_event_barrier(conf, stop_waiting_barrier(conf))

wait_barrier_nolock() speculatively increments nr_pending and, on a seqlock
retry, rolls it back with atomic_dec_and_test(). The wake fires only when
nr_pending reaches 0. This causes the freeze_array() in the aforementioned
raid10d flow to never be woken up.

[FIX]
Referring to allow_barrier(), this issue can be fixed by adding a wake-up
condition for "conf->array_freeze_pending" in wait_barrier_nolock().

Fixes: b9b083f9044a ("md/raid10: convert resync_lock to use seqlock")
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
---
 drivers/md/raid10.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index dc40110a6736..8dadf13c2b4d 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -994,11 +994,12 @@ static bool wait_barrier_nolock(struct r10conf *conf)
 
 	atomic_inc(&conf->nr_pending);
 	if (!read_seqretry(&conf->resync_lock, seq))
 		return true;
 
-	if (atomic_dec_and_test(&conf->nr_pending))
+	if (atomic_dec_and_test(&conf->nr_pending) ||
+	    READ_ONCE(conf->array_freeze_pending))
 		wake_up_barrier(conf);
 
 	return false;
 }
 
-- 
2.52.0

