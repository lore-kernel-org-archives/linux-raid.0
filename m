Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA103B7B72;
	Mon, 21 Sep 2026 07:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789975426; cv=none; b=ssWdTWRiL4n8uw2jQUQq+fT2j5MhTpuOnfr6AqVUVWqM/ssgb7oFE9lJTNpD6DdD1kWtQoUYG9r7vJLkVZU38r96t/6J19BBifjAFER1f8LOmUzNCXm9Wso0gnH/YJUzc99pBDQ9BUk5f2ZSw33G/LRdCMWM6jLDpXbsYgmX6fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789975426; c=relaxed/simple;
	bh=m/FcvP9JTRB7MSj1gfb0AyIu76xSDhcIvTkTDEh7nag=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qPlE7/x4PLlyAuAEPsJf9lPYNgC8PtaS4X2Cg6tMRenY8FzSX+QV37Pjbg/NndwsVlArTr8PZ6d3SdQcm6HROX0BG6iBqJGINuOUBeKIH4yDuHukf9pkQ8qVbZT0r6CU4OEHCMbR+hTlV4DjnbKedMks1WBiK5ASb96AcD3DePs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=cVDgg1pP; arc=none smtp.client-ip=113.46.200.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="cVDgg1pP"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=GMeiLnjxKDXYCAdv/zIJZmZQqDB7+UsCszXD9zntC8k=;
	b=cVDgg1pPAyj1xw+zz99To8tIJMf6JiIPt3HBsmGbEw8y6CClXKFN+a0eRfcU7KZrGfTF7kKtj
	fqGBonkqUcA/AQ6tGPwqd3sG7X7tP5fOzH1tfLCNZx6IETFAPIkWJA+F7dJDDwQva9GLAuMGqy6
	49BZcK056rT8a1LDk0au1oQ=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4hpDtM22n5zRhQs;
	Mon, 21 Sep 2026 15:11:39 +0800 (CST)
Received: from whupemo200011.china.huawei.com (unknown [7.152.185.179])
	by mail.maildlp.com (Postfix) with ESMTPS id E7B824057F;
	Mon, 21 Sep 2026 15:23:39 +0800 (CST)
Received: from huawei.com (10.50.85.155) by whupemo200011.china.huawei.com
 (7.152.185.179) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 21 Sep
 2026 15:23:38 +0800
From: Zhihao Cheng <chengzhihao1@huawei.com>
To: <song@kernel.org>, <yukuai@fygo.io>, <neil@brown.name>
CC: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<chengzhihao1@huawei.com>, <yangerkun@huawei.com>, <yi.zhang@huawei.com>
Subject: [PATCH 1/3] md/raid5: Hide the origin mddev->thread before takeover
Date: Mon, 21 Sep 2026 15:15:34 +0800
Message-ID: <20260921071537.2902362-2-chengzhihao1@huawei.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260921071537.2902362-1-chengzhihao1@huawei.com>
References: <20260921071537.2902362-1-chengzhihao1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 whupemo200011.china.huawei.com (7.152.185.179)

The raid5 takeover invokes setup_conf and allocates strip heads, but
it wakes up the wrong thread, which lefts strip heads in the list
'conf->released_stripes' and not being processed. If raid5_run fails,
the strip heads won't be released, which triggers the following slab
warnings (CONFIG_SLUB_DEBUG):
 BUG raid5-md0 (Not tainted): Objects remaining on __kmem_cache_shutdown()
 Object 0x0000000062fad548 @offset=3968
 Object 0x000000007f74683c @offset=4960
 WARNING: mm/slub.c:1268 at __slab_err+0x31/0x40, CPU#0: bash/865
 RIP: 0010:__slab_err+0x31
 Call Trace:
  __kmem_cache_shutdown.cold+0x15b
  kmem_cache_destroy+0x71
  free_conf+0xf8
  raid5_run.cold+0x463
  level_store+0x64e
  md_attr_store+0xd7

The detailed triggering process is as follows:
 mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sda /dev/sdb
 --force --assume-clean # create raid1, mddev->thread is raid1d
 echo 5 > /sys/block/md0/md/level
  level_store
   raid5_takeover_raid1
     setup_conf
      grow_stripes
       grow_one_stripe
        sh = alloc_stripe
        raid5_release_stripe
          md_wakeup_thread(conf->mddev->thread) // wakeup raid1d
     raid5_run
      ENOMEM = raid5_create_ctx_pool
      free_conf
       shrink_stripes
        drop_one_stripe // no strips found from the conf->inactive_list
        kmem_cache_destroy(conf->slab_cache)
	 __kmem_cache_shutdown
	  free_partial
	   list_slab_objects // some entries are not released !

Fix it by hiding the origin mddev->thread before takeover, so that
new allocating strip heads can be put into 'conf->inactive_list',
which can be found by drop_one_stripe().

Fixes: 773ca82fa1ee ("raid5: make release_stripe lockless")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
---
 drivers/md/raid5.c | 37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index c091bba95c31..7e87e8a60f5f 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -9039,19 +9039,38 @@ static void *raid5_takeover(struct mddev *mddev)
 	 *  raid4 - trivial - just use a raid4 layout.
 	 *  raid6 - Providing it is a *_6 layout
 	 */
-	if (mddev->level == 0)
-		return raid45_takeover_raid0(mddev, 5);
-	if (mddev->level == 1)
-		return raid5_takeover_raid1(mddev);
-	if (mddev->level == 4) {
+	void *ret = ERR_PTR(-EINVAL);
+	struct md_thread *thread;
+
+	thread = rcu_dereference_protected(mddev->thread,
+				lockdep_is_held(&mddev->reconfig_mutex));
+	/*
+	 * Set mddev->thread to NULL before setup_conf() to avoid waking up
+	 * wrong thread(eg. raid1), which can prevent the strips from being
+	 * left unreleased in the error handling path(free_conf) of raid5_run.
+	 */
+	rcu_assign_pointer(mddev->thread, NULL);
+
+	switch (mddev->level) {
+	case 0:
+		ret = raid45_takeover_raid0(mddev, 5);
+		break;
+	case 1:
+		ret = raid5_takeover_raid1(mddev);
+		break;
+	case 4:
 		mddev->new_layout = ALGORITHM_PARITY_N;
 		mddev->new_level = 5;
-		return setup_conf(mddev);
+		ret = setup_conf(mddev);
+		break;
+	case 6:
+		ret = raid5_takeover_raid6(mddev);
+		break;
 	}
-	if (mddev->level == 6)
-		return raid5_takeover_raid6(mddev);
 
-	return ERR_PTR(-EINVAL);
+	rcu_assign_pointer(mddev->thread, thread);
+
+	return ret;
 }
 
 static void *raid4_takeover(struct mddev *mddev)
-- 
2.52.0

