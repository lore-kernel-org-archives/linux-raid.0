Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.226
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794193517;
	b=E7VemG6Oj2YiYPQPHYTzunQzKuI6+B7ZlFK1kvS7dooIzoK8r6FkFxtHgQXl9Mir2Cei
	 6WWDURJGF20iSkEPS8MShh7mG9VrtuTQ1+lJMl/+jNrwQbt6B4LsSqWjkY40p0pPcf9Dp
	 +WbUfrYVma4SBDi/o+kTqAKDDFIteZmBVCyM8Tx0yqQDSalSfh3vGdYghb3+zn2ruQQit
	 QeryjfVov3s6eo/h4ttR9gCW9o0Wahqw2DbZGlKK2ysf7ubpGmYrluZWAAxEZnv1ZJ5BA
	 o7xygs1ad+FsPNUyEMGJarHZhiCgbsNQV9nidA7QKX9gPdrA5jz1EIXzoH6ASjAhtRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794193517;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=jzgKfvc+gCMyeJegNnCCdCmwPfxrXP8BnCLwAgAaGdA=;
	b=UCyljvxRpryoW24xaUqTPxeadwePV2wCPT/S2nyn8qZsYGoyIdEFrjDp4iUtPJMRN/2j
	 +irS43iKnm0y21HpKXsVhxSvs6tECkZNb5GYzF+CNT1phJm+ZGmLmrYjBRbJOjA7U9mwP
	 1eQgOwV59h5bI0LFrKtHViRwaNb51tB7FTXAFrdyfrVarLjLuY6C1W1YxbHSMmET0vthP
	 5uTYsgcu/YxU79ix6eHHAby46yRTfzhVQViotqa/7TzGEkB1KanjMGYtYVd7er7luqEtz
	 vCvkNgtzUE4T6luKnVVwPa2ZX/lWvC6UUFiC6UHxAi26Q22Dq3pj0Q5Dd565uJQN51g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=Yiy20rE3;
	arc=none smtp.remote-ip=113.46.200.226
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D23606A321;
	Mon,  9 Nov 2026 03:05:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 48D23606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=Yiy20rE3
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=jzgKfvc+gCMyeJegNnCCdCmwPfxrXP8BnCLwAgAaGdA=;
	b=Yiy20rE3tUxvNjQUXWrkWgEM6W3ZOutKcLH5hrKwXqvKR23Spyf1RzTqdQOf4gvzCNQR7edm+
	B8gVqcwnVCC+u8GvcK7sX6dbCoxn2Eudx3PWzZw0f39jKptY1klaUKgNxQwH3iHmC0Kuget5fOO
	lXiPLyf4hNwQHgQDgzejRXM=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4jNF5629JpzKm8j;
	Mon,  9 Nov 2026 11:04:58 +0800 (CST)
Received: from dggpemr200001.china.huawei.com (unknown [7.185.36.96])
	by mail.maildlp.com (Postfix) with ESMTPS id E4EA940565;
	Mon,  9 Nov 2026 11:05:06 +0800 (CST)
Received: from huawei.com (10.50.85.155) by dggpemr200001.china.huawei.com
 (7.185.36.96) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Mon, 9 Nov
 2026 11:05:06 +0800
From: Ran Hongyun <ranhongyun1@huawei.com>
To: <agk@redhat.com>, <snitzer@kernel.org>, <mpatocka@redhat.com>,
	<bmarzins@redhat.com>, <song@kernel.org>, <yukuai@fygo.io>
CC: <dm-devel@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-raid@vger.kernel.org>, <ranhongyun1@huawei.com>,
	<chengzhihao1@huawei.com>, <yangerkun@huawei.com>, <yi.zhang@huawei.com>
Subject: [PATCH] md: validate raid_disks range before loading personality
Date: Mon, 9 Nov 2026 10:56:21 +0800
Message-ID: <20261109025621.2031722-1-ranhongyun1@huawei.com>
X-Mailer: git-send-email 2.52.0
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
Content-Type: text/plain
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemr200001.china.huawei.com (7.185.36.96)

md_set_array_info() accepts raid_disks from user space without any
range check. The value is stored directly into mddev->raid_disks and
flows unchecked into md_run(), which only tests for zero. A negative
or excessively large raid_disks then reaches the personality ->run()
callback, where it scales several allocations:

  raid0:  kvzalloc(array3_size(..., raid_disks)) in create_strip_zones
  raid1:  kzalloc(array3_size(..., raid_disks, 2)) for mirrors and
          mempool_create_kmalloc_pool(offsetof(r1bio, bios[raid_disks*2]))
  raid5:  kzalloc_objs(disk_info, max_disks) and alloc_page() loop
  raid10: kzalloc_objs(raid10_info, raid_disks + ...) for mirrors

cf5963d6781dd ("md/raid0: validate device count before allocating
devlist") already fixes the raid0 warning. However raid1/5/10 still
hit the MAX_PAGE_ORDER WARN, and simply switching their kzalloc_objs
calls to kvzalloc_objs does not help because kvmalloc_node rejects
sizes above INT_MAX. The proper fix is to validate raid_disks before
any allocation takes place.

Add a MAX_RAID_DEVICES (253) bounds check in md_run() before
pers->run. This is the single choke point covering ioctl RUN_ARRAY,
dm-raid ctr, and reshape paths. Move the existing dm-raid private
definition to md.h so both subsystems share the same limit.

Signed-off-by: Ran Hongyun <ranhongyun1@huawei.com>
---
 drivers/md/dm-raid.c | 1 -
 drivers/md/md.c      | 7 +++++++
 drivers/md/md.h      | 3 +++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index ac019a0f5a92..29c41a04773e 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -18,7 +18,6 @@
 #include <linux/device-mapper.h>
 
 #define DM_MSG_PREFIX "raid"
-#define	MAX_RAID_DEVICES	253 /* md-raid kernel limit */
 
 /*
  * Minimum sectors of free reshape space per raid device
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 03e35386a802..7b202b483e98 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6703,6 +6703,13 @@ int md_run(struct mddev *mddev)
 			return -EINVAL;
 	}
 
+	if (mddev->raid_disks <= 0 ||
+	    mddev->raid_disks > MAX_RAID_DEVICES) {
+		pr_warn("md: %s: raid_disks %d out of range [1, %d]\n",
+			mdname(mddev), mddev->raid_disks, MAX_RAID_DEVICES);
+		return -EINVAL;
+	}
+
 	if (mddev->level != LEVEL_NONE)
 		request_module("md-level-%d", mddev->level);
 	else if (mddev->clevel[0])
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 6440da292105..75d7f4b14d39 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -22,6 +22,9 @@
 #include <trace/events/block.h>
 
 #define MaxSector (~(sector_t)0)
+
+#define MAX_RAID_DEVICES	253 /* md-raid kernel limit */
+
 /*
  * Number of guaranteed raid bios in case of extreme VM load:
  */
-- 
2.52.0

