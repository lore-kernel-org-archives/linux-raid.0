Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE322575A;
	Sat, 15 Jun 2024 08:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718441552; cv=none; b=rjrQkllW1cTboVITBqfCSvp9ZGZijPJsHypYw5i6bFZIEzk+TreSWuRd32z6ZcUce2fiumKqo0jCnKkXjJbOjKmteW7nMeIyN8BJPfixFvwn5Uhvl5YTD0wtuZSYjEEtGyPUAdnMNgN94ruK+GcIQXXjjVoyVFnXDCv6sFN1khg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718441552; c=relaxed/simple;
	bh=swQ2Tm1tNIfEE87pE5WaaCMNbRke/wggnc6gseFfg9Q=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=cam8YJMqoYtVbeVctmv8tfrXnao99+nFQDiMA3OU2lNtCkjMe/Lk96QrtKL5qOQrV5jfcj+AMzF38KcPxIaY9EWDJqBByGUsk1/tZ0M9p3qb0Ks/JWQlicC6dDHwsek+ObNlTgsNbxq4/bQaT4jCJ8psE1l6EYxL95zLGniBMmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4W1VJZ0X0lz4f3jLL;
	Sat, 15 Jun 2024 16:52:14 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id BD17D1A08FC;
	Sat, 15 Jun 2024 16:52:20 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP1 (Coremail) with SMTP id cCh0CgCXaBFCVm1mxCEqPg--.28885S4;
	Sat, 15 Jun 2024 16:52:20 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH -next] md/raid5: fix spares errors about rcu usage
Date: Sat, 15 Jun 2024 16:51:43 +0800
Message-Id: <20240615085143.1648223-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgCXaBFCVm1mxCEqPg--.28885S4
X-Coremail-Antispam: 1UD129KBjvJXoWxGw43JF1rur4rJr4UAF15XFb_yoW5XFyDpa
	n0ya4Uua1Uur45ZFWDJayDC3Wak3WxGayxArWI939YvasYqFZ5Ja18Ja4Fvry5JFyrtay8
	AFy5Kr4DJF18KFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyl14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCF04k20xvY0x0EwIxG
	rwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4
	vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IY
	x2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26c
	xKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
	67AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUoOJ5UUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

As commit ad8606702f26 ("md/raid5: remove rcu protection to access rdev
from conf") explains, rcu protection can be removed, however, there are
three places left, there won't be any real problems.

drivers/md/raid5.c:8071:24: error: incompatible types in comparison expression (different address spaces):
drivers/md/raid5.c:8071:24:    struct md_rdev [noderef] __rcu *
drivers/md/raid5.c:8071:24:    struct md_rdev *
drivers/md/raid5.c:7569:25: error: incompatible types in comparison expression (different address spaces):
drivers/md/raid5.c:7569:25:    struct md_rdev [noderef] __rcu *
drivers/md/raid5.c:7569:25:    struct md_rdev *
drivers/md/raid5.c:7573:25: error: incompatible types in comparison expression (different address spaces):
drivers/md/raid5.c:7573:25:    struct md_rdev [noderef] __rcu *
drivers/md/raid5.c:7573:25:    struct md_rdev *

Fixes: ad8606702f26 ("md/raid5: remove rcu protection to access rdev from conf")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/raid5.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 547fd15115cd..3827f7df6b9a 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -155,7 +155,7 @@ static int raid6_idx_to_slot(int idx, struct stripe_head *sh,
 	return slot;
 }
 
-static void print_raid5_conf (struct r5conf *conf);
+static void print_raid5_conf(struct r5conf *conf);
 
 static int stripe_operations_active(struct stripe_head *sh)
 {
@@ -7566,11 +7566,11 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 		if (test_bit(Replacement, &rdev->flags)) {
 			if (disk->replacement)
 				goto abort;
-			RCU_INIT_POINTER(disk->replacement, rdev);
+			disk->replacement = rdev;
 		} else {
 			if (disk->rdev)
 				goto abort;
-			RCU_INIT_POINTER(disk->rdev, rdev);
+			disk->rdev = rdev;
 		}
 
 		if (test_bit(In_sync, &rdev->flags)) {
@@ -8052,7 +8052,7 @@ static void raid5_status(struct seq_file *seq, struct mddev *mddev)
 	seq_printf (seq, "]");
 }
 
-static void print_raid5_conf (struct r5conf *conf)
+static void print_raid5_conf(struct r5conf *conf)
 {
 	struct md_rdev *rdev;
 	int i;
@@ -8066,15 +8066,13 @@ static void print_raid5_conf (struct r5conf *conf)
 	       conf->raid_disks,
 	       conf->raid_disks - conf->mddev->degraded);
 
-	rcu_read_lock();
 	for (i = 0; i < conf->raid_disks; i++) {
-		rdev = rcu_dereference(conf->disks[i].rdev);
+		rdev = conf->disks[i].rdev;
 		if (rdev)
 			pr_debug(" disk %d, o:%d, dev:%pg\n",
 			       i, !test_bit(Faulty, &rdev->flags),
 			       rdev->bdev);
 	}
-	rcu_read_unlock();
 }
 
 static int raid5_spare_active(struct mddev *mddev)
-- 
2.39.2

