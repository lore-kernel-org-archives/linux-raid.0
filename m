Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423A032E6BC;
	Tue, 22 Sep 2026 14:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790086992; cv=none; b=BrlcHAOASXuLmc8kaqHLAOkZcOREc58VZapP4bfH8WlPATBrMnWUfkBApAHWblWHkn+3pGuXpOXfo84rpTQqailwT9SR7BobVrNJr8rI4UMCkwCbz3g6KruHnYACC3GDDV9QjOvmmbraaVcEzZxS/Xx7Y2+kvWdDW2rWQOUce7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790086992; c=relaxed/simple;
	bh=f4ZuN7YIVBmjIlvAV+syE5QTTYZbpG8kweTNE3cGB7M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X5RIiFlIhwPpeRuRxT0pWyLWuVL/ItbMmAMyy+HM3IvyjcWeGB85J/0etH8tqrHretIQF09ShpAYglR+dpxYIdtbqHkTaaEmqRIWXFoCz0GWchHeJb1GxPAQhpNWAXR7aAQyjMZgbVphCdKiZM2loESfktwmPoCSTAulaIdKMCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=Ky2GfRSW; arc=none smtp.client-ip=113.46.200.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="Ky2GfRSW"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=fWxJnnxB42hu8FmbVxkpGBN6x581Psd4IIki4Vpp8BE=;
	b=Ky2GfRSWQQuEFSYRPyL7Wm/V0cJm4HJjpWW00uEcUg91TjNp9wJY26r1vVf7v42C1MdBbCJyJ
	FN8Ts+Tat9qb+US1opkG+HRaj7JoALSTBY5q7coDDpfXdKJh9tfqCwQ51DddZPx7EHftSGKvpnD
	Mnh7gofgDY8DX0qGIxJITiA=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4hq28z5yQzzLlSh;
	Tue, 22 Sep 2026 22:12:03 +0800 (CST)
Received: from whupemo200011.china.huawei.com (unknown [7.152.185.179])
	by mail.maildlp.com (Postfix) with ESMTPS id 5745B40563;
	Tue, 22 Sep 2026 22:23:06 +0800 (CST)
Received: from huawei.com (10.50.85.155) by whupemo200011.china.huawei.com
 (7.152.185.179) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 22 Sep
 2026 22:23:05 +0800
From: Zhihao Cheng <chengzhihao1@huawei.com>
To: <song@kernel.org>, <yukuai@fygo.io>, <shli@kernel.org>, <neil@brown.name>
CC: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<chengzhihao1@huawei.com>, <yangerkun@huawei.com>, <yi.zhang@huawei.com>
Subject: [PATCH v2 4/4] md/raid10: Don't free conf on raid10_run failure
Date: Tue, 22 Sep 2026 22:14:56 +0800
Message-ID: <20260922141456.738937-5-chengzhihao1@huawei.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260922141456.738937-1-chengzhihao1@huawei.com>
References: <20260922141456.738937-1-chengzhihao1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 whupemo200011.china.huawei.com (7.152.185.179)

Since all pers->run() callers handle the error case, no need to free
conf when raid10_run() fails.

Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
---
 drivers/md/raid10.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 1093c798d9dd..9e4d4202f35c 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3972,7 +3972,7 @@ static int raid10_run(struct mddev *mddev)
 		if (fc > 1 || fo > 0) {
 			pr_err("only near layout is supported by clustered"
 				" raid10\n");
-			goto out_free_conf;
+			goto out_unregister_thread;
 		}
 	}
 
@@ -3989,11 +3989,11 @@ static int raid10_run(struct mddev *mddev)
 
 		if (test_bit(Replacement, &rdev->flags)) {
 			if (disk->replacement)
-				goto out_free_conf;
+				goto out_unregister_thread;
 			disk->replacement = rdev;
 		} else {
 			if (disk->rdev)
-				goto out_free_conf;
+				goto out_unregister_thread;
 			disk->rdev = rdev;
 		}
 		diff = (rdev->new_data_offset - rdev->data_offset);
@@ -4013,7 +4013,7 @@ static int raid10_run(struct mddev *mddev)
 
 		if (err) {
 			ret = err;
-			goto out_free_conf;
+			goto out_unregister_thread;
 		}
 	}
 
@@ -4021,17 +4021,17 @@ static int raid10_run(struct mddev *mddev)
 	if (!enough(conf, -1)) {
 		pr_err("md/raid10:%s: not enough operational mirrors.\n",
 		       mdname(mddev));
-		goto out_free_conf;
+		goto out_unregister_thread;
 	}
 
 	if (conf->reshape_progress != MaxSector) {
 		/* must ensure that shape change is supported */
 		if (conf->geo.far_copies != 1 &&
 		    conf->geo.far_offset == 0)
-			goto out_free_conf;
+			goto out_unregister_thread;
 		if (conf->prev.far_copies != 1 &&
 		    conf->prev.far_offset == 0)
-			goto out_free_conf;
+			goto out_unregister_thread;
 	}
 
 	mddev->degraded = 0;
@@ -4081,7 +4081,7 @@ static int raid10_run(struct mddev *mddev)
 	set_bit(MD_FAILFAST_SUPPORTED, &mddev->flags);
 
 	if (md_integrity_register(mddev))
-		goto out_free_conf;
+		goto out_unregister_thread;
 
 	if (conf->reshape_progress != MaxSector) {
 		unsigned long before_length, after_length;
@@ -4094,7 +4094,7 @@ static int raid10_run(struct mddev *mddev)
 		if (max(before_length, after_length) > min_offset_diff) {
 			/* This cannot work */
 			pr_warn("md/raid10: offset difference not enough to continue reshape\n");
-			goto out_free_conf;
+			goto out_unregister_thread;
 		}
 		conf->offset_diff = min_offset_diff;
 
@@ -4106,10 +4106,8 @@ static int raid10_run(struct mddev *mddev)
 
 	return 0;
 
-out_free_conf:
+out_unregister_thread:
 	md_unregister_thread(mddev, &mddev->thread);
-	raid10_free_conf(conf);
-	mddev->private = NULL;
 out:
 	return ret;
 }
-- 
2.52.0

