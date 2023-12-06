Received: from esa10.hc1455-7.c3s2.iphmx.com (esa10.hc1455-7.c3s2.iphmx.com [139.138.36.225])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9429D4F
	for <linux-raid@vger.kernel.org>; Wed,  6 Dec 2023 00:37:49 -0800 (PST)
X-IronPort-AV: E=McAfee;i="6600,9927,10915"; a="129888723"
X-IronPort-AV: E=Sophos;i="6.04,254,1695654000"; 
   d="scan'208";a="129888723"
Received: from unknown (HELO yto-r2.gw.nic.fujitsu.com) ([218.44.52.218])
  by esa10.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2023 17:37:47 +0900
Received: from yto-m1.gw.nic.fujitsu.com (yto-nat-yto-m1.gw.nic.fujitsu.com [192.168.83.64])
	by yto-r2.gw.nic.fujitsu.com (Postfix) with ESMTP id 6E91DD6187
	for <linux-raid@vger.kernel.org>; Wed,  6 Dec 2023 17:37:45 +0900 (JST)
Received: from m3002.s.css.fujitsu.com (msm3.b.css.fujitsu.com [10.128.233.104])
	by yto-m1.gw.nic.fujitsu.com (Postfix) with ESMTP id C3208D296D
	for <linux-raid@vger.kernel.org>; Wed,  6 Dec 2023 17:37:44 +0900 (JST)
Received: from localhost.localdomain (unknown [10.125.14.207])
	by m3002.s.css.fujitsu.com (Postfix) with ESMTP id 96C5D200B2AB;
	Wed,  6 Dec 2023 17:37:44 +0900 (JST)
From: Yuya Fujita <fujita.yuya-00@fujitsu.com>
To: song@kernel.org,
	yukuai3@huawei.com,
	mariusz.tkaczyk@linux.intel.com
Cc: linux-raid@vger.kernel.org,
	Yuya Fujita <fujita.yuya-00@fujitsu.com>
Subject: [PATCH] md: Do not unlock all_mddevs_lock in md_seq_show()
Date: Wed,  6 Dec 2023 03:33:58 -0500
Message-Id: <20231206083356.9796-1-fujita.yuya-00@fujitsu.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00

Do not unlock all_mddevs_lock in md_seq_show() and keep the lock until
md_seq_stop().

The list of all_mddevs may be deleted in md_seq_show() because
all_mddevs_lock is temporarily unlocked.
The list should not be deleted while iterating over all_mddevs.
(Just as the list should not be deleted during list_for_each_entry().)

Fixes: cf1b6d4441ff ("md: simplify md_seq_ops")
Signed-off-by: Yuya Fujita <fujita.yuya-00@fujitsu.com>
---
 drivers/md/md.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c94373d64f2c..97ef08608848 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8293,7 +8293,6 @@ static int md_seq_show(struct seq_file *seq, void *v)
 	if (!mddev_get(mddev))
 		return 0;
 
-	spin_unlock(&all_mddevs_lock);
 	spin_lock(&mddev->lock);
 	if (mddev->pers || mddev->raid_disks || !list_empty(&mddev->disks)) {
 		seq_printf(seq, "%s : %sactive", mdname(mddev),
@@ -8364,7 +8363,6 @@ static int md_seq_show(struct seq_file *seq, void *v)
 		seq_printf(seq, "\n");
 	}
 	spin_unlock(&mddev->lock);
-	spin_lock(&all_mddevs_lock);
 	if (atomic_dec_and_test(&mddev->active))
 		__mddev_put(mddev);
 
-- 
2.31.1

