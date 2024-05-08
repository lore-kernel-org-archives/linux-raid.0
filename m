Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6263D961;
	Wed,  8 May 2024 09:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715160662; cv=none; b=NTPJi9+CRJQjwVfDJ89K3nAwlM3/igTmykivmoAM5hhiH/tRa1NGYpo3j5Fz+GdFfb1zhrF/oSIwifYCpCt2jwcy/e/6P3WxFD9RF0wKUZpNM7TUDUd9KpdDjCBMZKFoPYYV5O4w5mQL5hQdW1J8smFV0zihnajDCV26rOtiTBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715160662; c=relaxed/simple;
	bh=+eHgcr2e3JuTlx7yzSK7Ri/f46kJbzU74BjCTSxabTA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Ib0+kPU4ImOtg6PUbPHj0K/EtX/TJqKWp45DbCeg5U4xQmIeUBhapEsjp+vjoFdZHeSKdaXWiT1jzViCWww4ZqMoWuIcmkVLj0jL5WHxXqR/LgUf7WhD/LVRShouu1Qnsfv2f4ujqj7keF/zH/erikyZmoHW5YiELmqVVW9EiaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4VZ8yd5Ngsz4f3kJr;
	Wed,  8 May 2024 17:30:49 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 154401A017D;
	Wed,  8 May 2024 17:30:55 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP1 (Coremail) with SMTP id cCh0CgDHlxBNRjtm_BpaMA--.32846S4;
	Wed, 08 May 2024 17:30:54 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linan666@huaweicloud.com,
	yukuai3@huawei.com,
	yi.zhang@huawei.com,
	houtao1@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH] md: do not delete safemode_timer in mddev_suspend
Date: Wed,  8 May 2024 17:20:53 +0800
Message-Id: <20240508092053.1447930-1-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgDHlxBNRjtm_BpaMA--.32846S4
X-Coremail-Antispam: 1UD129KBjvJXoWxJr1UJry8Kw1ruw47uw4DJwb_yoW8GF4fp3
	ySqw4agw1rXFWIyF4UAa1kWFy5Jwn3GrZFyFy7W395Za1Sqr18WF42gws0qFyUuF93Janr
	Jrs5C34rZa48GF7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvl14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r
	4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I
	648v4I1lw4CEc2x0rVAKj4xxMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r
	4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF
	67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2I
	x0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI42IY
	6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvj
	DU0xZFpf9x0JUBSoJUUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

The deletion of safemode_timer in mddev_suspend() is redundant and
potentially harmful now. If timer is about to be woken up but gets
deleted, 'in_sync' will remain 0 until the next write, causing array
to stay in the 'active' state instead of transitioning to 'clean'.

Commit 0d9f4f135eb6 ("MD: Add del_timer_sync to mddev_suspend (fix
nasty panic))" introduced this deletion for dm, because if timer fired
after dm is destroyed, the resource which the timer depends on might
have been freed.

However, commit 0dd84b319352 ("md: call __md_stop_writes in md_stop")
added __md_stop_writes() to md_stop(), which is called before freeing
resource. Timer is deleted in __md_stop_writes(), and the origin issue
is resolved. Therefore, delete safemode_timer can be removed safely now.

Signed-off-by: Li Nan <linan122@huawei.com>
---
 drivers/md/md.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index aff9118ff697..09c55d9a2c54 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -479,7 +479,6 @@ int mddev_suspend(struct mddev *mddev, bool interruptible)
 	 */
 	WRITE_ONCE(mddev->suspended, mddev->suspended + 1);
 
-	del_timer_sync(&mddev->safemode_timer);
 	/* restrict memory reclaim I/O during raid array is suspend */
 	mddev->noio_flag = memalloc_noio_save();
 
-- 
2.39.2

