Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D1982EF67F;
	Mon, 24 Nov 2025 08:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763974538; cv=none; b=rGeW+JjMKv/QzxEfM/LugyJ+ApYO6md55Slk2oSdvJIhZbSYkP7iwP6RNViBa2SjyOCrcVjVagzcdb1ksJPghvzm2UAvIBK62a3n2st1zELdVDxHexF0h600KLidRRgLYmkDyVZ3Zjj4+cdbWHifo+tqG8iDDHXIYm00PnezwPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763974538; c=relaxed/simple;
	bh=B8nk0JWwloBe66wUe1mpvJ63xaw67qpKrnnX4O5OM8s=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=IbgIcAs1lgZNYwPtHRFYR2UDUYGgz7FlGIbQTW+u6IvBAhyXJIvLgH0RU1b0K/CmN8LpAatX4w1hxLftZLKAXRNQQxfi5NpSQDiRK0CzggK6cX+Gts0B5lEDGbebdNiCLT2mZ2R12htfvaSjVoiqHZQDwuQGQ47J9X6+qgm6Clc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dFKQC4DchzYQtLb;
	Mon, 24 Nov 2025 16:54:43 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id D614F1A1353;
	Mon, 24 Nov 2025 16:55:31 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP2 (Coremail) with SMTP id Syh0CgBnxHqCHSRpjE9fBw--.19114S4;
	Mon, 24 Nov 2025 16:55:31 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH] md/raid5: Fix a deadlock of reshape and suspend
Date: Mon, 24 Nov 2025 16:45:59 +0800
Message-Id: <20251124084559.4097567-1-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBnxHqCHSRpjE9fBw--.19114S4
X-Coremail-Antispam: 1UD129KBjvJXoW7Cr1rGrykCrWDZrW7Jr47urg_yoW8XF13pa
	yvkasIvr45WryjyF4DZ3Wv9FyrGa1DXrWfuwsrJ3yIva4DXFWkGFW7WFZIqr98urWrt3yr
	Zw4UXrya9a4jvFJanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9K14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r4UJV
	WxJr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8v
	x2IErcIFxwAKzVCY07xG64k0F24lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr4
	1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK
	67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI
	8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAv
	wI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14
	v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUooGQDUUUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

Commit 868bba54a3bc ("md/raid5: fix a deadlock in the case that reshape is
interrupted") fixed a raid deadlock of reshape, but a similar issue is hit
by mdadm test 25raid456-reshape-deadlock.

  INFO: task (udev-worker):63822 blocked for more than 122 seconds.
        Not tainted 6.18.0-rc2-g0555b5424915-dirty #153
  "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
  __schedule
  schedule
  schedule_timeout
  wait_woken
  raid5_make_request
  md_handle_request
  md_submit_bio
  [...]
  blkdev_read_iter
  vfs_read
  ksys_read
  __x64_sys_read

It is triggered by:
1) normal IO waits for reshape to progress
2) user sets ACTION_FROZEN via ioctl
3) reshape is interrupted and cannot restart
4) users try to suspend array while active IO waits reshape

Following Kuai's previous fix, such IOs should fail in
make_stripe_request(). Thus, set a timeout for wait_woken() to fix
the deadlock, and blocked IO will fail in the next cycle.

Signed-off-by: Li Nan <linan122@huawei.com>
---
 drivers/md/raid5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index cdbc7eba5c54..957e712d2be9 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6185,7 +6185,7 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 			}
 
 			wait_woken(&wait, TASK_UNINTERRUPTIBLE,
-				   MAX_SCHEDULE_TIMEOUT);
+				   msecs_to_jiffies(10000));
 			continue;
 		}
 
-- 
2.39.2

