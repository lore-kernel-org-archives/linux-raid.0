Received: from sg-1-19.ptr.blmpb.com (sg-1-19.ptr.blmpb.com [118.26.132.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8AC3364E9E
	for <linux-raid@vger.kernel.org>; Wed,  4 Mar 2026 03:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772594351; cv=none; b=NTGgJEnsRSrFeiowt9mzMwOdTILvU60cjGpFVFiBBXs5t6lzERK0kESr0d3VnejF6T9476I1F/aci3kJVfPwo8TtFNypZoadK/6Q4a+82oACCZ0walPQjiSCCs9kZHYWXA6L4trCdfSz6YW+W+bwbrn88a6tLjDHsm5V0uO5hp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772594351; c=relaxed/simple;
	bh=+Xu2zWEKZn5pch4XgGCYm5IEzzbD6o842rLodXYwo9I=;
	h=Date:Message-Id:Mime-Version:Cc:From:Content-Type:To:Subject; b=hJcBuva3L600nJuHUmhAd6bsiK/xbMpJ9M5zwe+sdTCYcSut/AwI8anIdbwshEYcTV4ovslHlSPmXSmuBCw1/vcu/XK7C1jD0ru2EEdhGDQOOsUWoT8mna/k/D5c0bPLu7hmsUGUnhVd7PgiAMW0cYFGJ2+SA8OK7E92IS7/B+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=BU3unSEQ; arc=none smtp.client-ip=118.26.132.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="BU3unSEQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1772594338;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=bHmwj0Yw3i/00/hdi3K5q5jaXZ5m88s4CbTUIvzN1+o=;
 b=BU3unSEQ56sGq/NrneMSt412hkcT0PXlJhOc1WuvGjieRn2oo6zHQP06KxwHZgCBVql/qv
 dQcrqCvmTxE1FGQ89OCaAoZFtkpuS7xmezfDfhu74UkVfx+3NwlHuRvvqzuXHcPEqRLCrD
 XM0Olu6lUPpagHgtqJa8/3t8flGym4cu1yd0kbadRksiP4vaVPY82zNbfb82nwjMxALE2N
 uhWlwSsxvnBPzd2vPgjoZFXYLqTvRMeYsTYVI+Rop5+ZAPdhl+x2uBN9w8jTFOk/Gcwrzi
 Lp+vkYyhZTs2EcinAkErXpIfTKzjCu1Zrezd/rWg17AF2OALHzS/WZGY1OvGPg==
Date: Wed,  4 Mar 2026 19:14:17 +0800
Message-Id: <20260304111417.20777-1-chencheng@fnnas.com>
X-Original-From: Chen Cheng <chencheng@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+269a7a4a0+07f776+vger.kernel.org+chencheng@fnnas.com>
Received: from c ([113.111.140.155]) by smtp.feishu.cn with ESMTPS; Wed, 04 Mar 2026 11:18:55 +0800
Cc: "Li Nan" <linan122@huawei.com>, <linux-raid@vger.kernel.org>, 
	"Chen Cheng" <chencheng@fnnas.com>
From: "Chen Cheng" <chencheng@fnnas.com>
Content-Type: text/plain; charset=UTF-8
To: "Song Liu" <song@kernel.org>, "Yu Kuai" <yukuai@fnnas.com>
Subject: [PATCH] md: remove unused mddev argument from export_rdev
X-Mailer: git-send-email 2.51.0
Content-Transfer-Encoding: 7bit

The mddev argument in export_rdev() is never used. Remove it to
simplify callers.

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/md.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c2cc2302d727..521d9b34cd9e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -98,7 +98,7 @@ static struct workqueue_struct *md_misc_wq;
 static int remove_and_add_spares(struct mddev *mddev,
 				 struct md_rdev *this);
 static void mddev_detach(struct mddev *mddev);
-static void export_rdev(struct md_rdev *rdev, struct mddev *mddev);
+static void export_rdev(struct md_rdev *rdev);
 static void md_wakeup_thread_directly(struct md_thread __rcu **thread);
 
 /*
@@ -959,7 +959,7 @@ void mddev_unlock(struct mddev *mddev)
 	list_for_each_entry_safe(rdev, tmp, &delete, same_set) {
 		list_del_init(&rdev->same_set);
 		kobject_del(&rdev->kobj);
-		export_rdev(rdev, mddev);
+		export_rdev(rdev);
 	}
 
 	if (!legacy_async_del_gendisk) {
@@ -2632,7 +2632,7 @@ void md_autodetect_dev(dev_t dev);
 /* just for claiming the bdev */
 static struct md_rdev claim_rdev;
 
-static void export_rdev(struct md_rdev *rdev, struct mddev *mddev)
+static void export_rdev(struct md_rdev *rdev)
 {
 	pr_debug("md: export_rdev(%pg)\n", rdev->bdev);
 	md_rdev_clear(rdev);
@@ -4850,7 +4850,7 @@ new_dev_store(struct mddev *mddev, const char *buf, size_t len)
 	err = bind_rdev_to_array(rdev, mddev);
  out:
 	if (err)
-		export_rdev(rdev, mddev);
+		export_rdev(rdev);
 	mddev_unlock_and_resume(mddev);
 	if (!err)
 		md_new_event();
@@ -7142,7 +7142,7 @@ static void autorun_devices(int part)
 			rdev_for_each_list(rdev, tmp, &candidates) {
 				list_del_init(&rdev->same_set);
 				if (bind_rdev_to_array(rdev, mddev))
-					export_rdev(rdev, mddev);
+					export_rdev(rdev);
 			}
 			autorun_array(mddev);
 			mddev_unlock_and_resume(mddev);
@@ -7152,7 +7152,7 @@ static void autorun_devices(int part)
 		 */
 		rdev_for_each_list(rdev, tmp, &candidates) {
 			list_del_init(&rdev->same_set);
-			export_rdev(rdev, mddev);
+			export_rdev(rdev);
 		}
 		mddev_put(mddev);
 	}
@@ -7340,13 +7340,13 @@ int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info)
 				pr_warn("md: %pg has different UUID to %pg\n",
 					rdev->bdev,
 					rdev0->bdev);
-				export_rdev(rdev, mddev);
+				export_rdev(rdev);
 				return -EINVAL;
 			}
 		}
 		err = bind_rdev_to_array(rdev, mddev);
 		if (err)
-			export_rdev(rdev, mddev);
+			export_rdev(rdev);
 		return err;
 	}
 
@@ -7389,7 +7389,7 @@ int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info)
 			/* This was a hot-add request, but events doesn't
 			 * match, so reject it.
 			 */
-			export_rdev(rdev, mddev);
+			export_rdev(rdev);
 			return -EINVAL;
 		}
 
@@ -7415,7 +7415,7 @@ int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info)
 				}
 			}
 			if (has_journal || mddev->bitmap) {
-				export_rdev(rdev, mddev);
+				export_rdev(rdev);
 				return -EBUSY;
 			}
 			set_bit(Journal, &rdev->flags);
@@ -7430,7 +7430,7 @@ int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info)
 				/* --add initiated by this node */
 				err = mddev->cluster_ops->add_new_disk(mddev, rdev);
 				if (err) {
-					export_rdev(rdev, mddev);
+					export_rdev(rdev);
 					return err;
 				}
 			}
@@ -7440,7 +7440,7 @@ int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info)
 		err = bind_rdev_to_array(rdev, mddev);
 
 		if (err)
-			export_rdev(rdev, mddev);
+			export_rdev(rdev);
 
 		if (mddev_is_clustered(mddev)) {
 			if (info->state & (1 << MD_DISK_CANDIDATE)) {
@@ -7503,7 +7503,7 @@ int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info)
 
 		err = bind_rdev_to_array(rdev, mddev);
 		if (err) {
-			export_rdev(rdev, mddev);
+			export_rdev(rdev);
 			return err;
 		}
 	}
@@ -7615,7 +7615,7 @@ static int hot_add_disk(struct mddev *mddev, dev_t dev)
 	return 0;
 
 abort_export:
-	export_rdev(rdev, mddev);
+	export_rdev(rdev);
 	return err;
 }
 
-- 
2.51.0
