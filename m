Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40723E5A0B;
	Mon, 10 Aug 2026 14:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786370480; cv=none; b=PVGMOdDU7Z/CZPZhdUakAk2FIolYyg5eGSfZUQPv6uNU9y8ZNPf8wnQnURbkeTZlYsjQ4bf44Ux7Nm1GnlyAup2VhKx1UJEAE88PvvubR2xstSusEYdfaefWAHIbjOAcM7oMqofmp4RhEn0/0XDPu1wfwAfLuOsi+LbVI9rj0zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786370480; c=relaxed/simple;
	bh=6TsZSJgfIJI4bPmxqedoBMRx/bqKtcbposWoKAS6b3s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=c41+VrBUepwduSzFKC1qjes0B8Q0rc+fmC0l7cs39GOXMske4/M829maEyRGauFFe4Vp4uz9AHnoiZLYVsGu3eUeShigkFB/Rjuyhw1aHVfp6A5xmouqdm7gIDLf8USTaNqF7+eN+rLqmVA1d/SrtTAS12RYcplacFhWp50u7cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hJbxv16PFzKHMjn;
	Mon, 10 Aug 2026 22:00:51 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id A32664056D;
	Mon, 10 Aug 2026 22:01:05 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP3 (Coremail) with UTF8SMTPSA id _Ch0CgCnlkWg2XlqHlhCBw--.44643S4;
	Mon, 10 Aug 2026 22:01:05 +0800 (CST)
From: Zizhi Wo <wozizhi@huaweicloud.com>
To: song@kernel.org,
	yukuai@fygo.io,
	magiclinan@didiglobal.com,
	xiao@kernel.org,
	linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	yangerkun@huawei.com,
	chengzhihao1@huawei.com,
	wozizhi@huawei.com
Subject: [PATCH] md/raid10: fix missing wakeup in wait_barrier_nolock
Date: Mon, 10 Aug 2026 21:55:21 +0800
Message-ID: <20260810135521.3470422-1-wozizhi@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgCnlkWg2XlqHlhCBw--.44643S4
X-Coremail-Antispam: 1UD129KBjvJXoWxZry8uF1xWw4kGr18Wr4fGrg_yoW5Ww1Up3
	9Iqryvyr4Uuw15tw4DXa109ryrXw4kKay2krZ2934UZFnxtFWSyrW7Gryjgr1qvr93Aa4r
	XFZ8CFW3Aa4jyFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyKb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI
	7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxV
	Cjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY
	6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6x
	AIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY
	1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUF1v3UUUUU
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/

From: Zizhi Wo <wozizhi@huawei.com>

[Bug]
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

[Cause]
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

[Fix]
Referring to allow_barrier(), this issue can be fixed by adding a wake-up
condition for "conf->array_freeze_pending" in wait_barrier_nolock().

Fixes: b9b083f9044a ("md/raid10: convert resync_lock to use seqlock")
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
Signed-off-by: Zizhi Wo <wozizhi@huaweicloud.com>
---
 drivers/md/raid10.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 0a3cfdd3f5df..fad634a444f8 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -996,7 +996,8 @@ static bool wait_barrier_nolock(struct r10conf *conf)
 	if (!read_seqretry(&conf->resync_lock, seq))
 		return true;
 
-	if (atomic_dec_and_test(&conf->nr_pending))
+	if (atomic_dec_and_test(&conf->nr_pending) ||
+	    conf->array_freeze_pending)
 		wake_up_barrier(conf);
 
 	return false;
-- 
2.52.0

