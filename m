Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5074C253F05;
	Thu, 16 Apr 2026 03:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776311432; cv=none; b=gKaJXxx5B3lENBzjxzuyk3IDGEjVyIYpv3DMzR04nouv5vyCeG+XYIG+Mw9vQl7O9aKfNN8nAhQe7EX/kx0bKSCvh9+Mayq5rNnhSROP/TXhq1wq/1YnIXLnxRFu11zqxBKgIA7R0ijrK6akenjECGkQASWtjVa9Bg68rw2Oo1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776311432; c=relaxed/simple;
	bh=dLJsNXpq6hEI0nVEOJ2miYAwiIaawzWtZxf1Tp3N3A8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hUsf5ALUYBKrCEZoawkkdYTx22BF5fw26qHViJhZuCcSYmghM1nkZ6EFWfaD1rr3LbYwksGUWQnKwVg07o8s9FPoiSWFyJmTkWCjuy4K83CvTnmjqOZiARWjx/Y7Viu8h8MP1OH2G1nnhiVOnSjIBtASuRhun2pIwnAQpYjd5Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fx3tD11W6zYQtgH;
	Thu, 16 Apr 2026 11:49:40 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 3E42640562;
	Thu, 16 Apr 2026 11:50:27 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP3 (Coremail) with SMTP id _Ch0CgCHM72BXOBpn95JAg--.61021S8;
	Thu, 16 Apr 2026 11:50:27 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH v3 4/8] md/raid1: use folio for tmppage
Date: Thu, 16 Apr 2026 11:37:57 +0800
Message-Id: <20260416033801.786415-5-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20260416033801.786415-1-linan666@huaweicloud.com>
References: <20260416033801.786415-1-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgCHM72BXOBpn95JAg--.61021S8
X-Coremail-Antispam: 1UD129KBjvJXoWxZF48CF1rKrW5Jw4fGFWfZrb_yoW5Cw1Upa
	n8G3ZIqr4UJr98Jr1DJFWkua4aqw1xtayjkFsrG393uFsaqF95ZayYk34jgr1DXF98Ja4f
	XFW5KrW3ZF1rtF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmE14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr
	1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0D
	M2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64
	kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVW8Jr0_Cr1U
	McvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I64
	8v4I1lw4CEc2x0rVAKj4xxMxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMxC2
	0s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI
	0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE
	14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20x
	vaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8
	JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbItC3UUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

Convert tmppage to tmpfolio and use it throughout in raid1.

Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/raid1.h |  2 +-
 drivers/md/raid1.c | 18 ++++++++++--------
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
index c98d43a7ae99..d480b3a8c2c4 100644
--- a/drivers/md/raid1.h
+++ b/drivers/md/raid1.h
@@ -101,7 +101,7 @@ struct r1conf {
 	/* temporary buffer to synchronous IO when attempting to repair
 	 * a read error.
 	 */
-	struct page		*tmppage;
+	struct folio		*tmpfolio;
 
 	/* When taking over an array from a different personality, we store
 	 * the new thread here until we fully activate the array.
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 5a73a9f19e0e..a72abdc37a2d 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2417,8 +2417,8 @@ static void fix_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 			      rdev->recovery_offset >= sect + s)) &&
 			    rdev_has_badblock(rdev, sect, s) == 0) {
 				atomic_inc(&rdev->nr_pending);
-				if (sync_page_io(rdev, sect, s<<9,
-					 conf->tmppage, REQ_OP_READ, false))
+				if (sync_folio_io(rdev, sect, s<<9, 0,
+					 conf->tmpfolio, REQ_OP_READ, false))
 					success = 1;
 				rdev_dec_pending(rdev, mddev);
 				if (success)
@@ -2447,7 +2447,8 @@ static void fix_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 			    !test_bit(Faulty, &rdev->flags)) {
 				atomic_inc(&rdev->nr_pending);
 				r1_sync_page_io(rdev, sect, s,
-						conf->tmppage, REQ_OP_WRITE);
+						folio_page(conf->tmpfolio, 0),
+						REQ_OP_WRITE);
 				rdev_dec_pending(rdev, mddev);
 			}
 		}
@@ -2461,7 +2462,8 @@ static void fix_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 			    !test_bit(Faulty, &rdev->flags)) {
 				atomic_inc(&rdev->nr_pending);
 				if (r1_sync_page_io(rdev, sect, s,
-						conf->tmppage, REQ_OP_READ)) {
+						folio_page(conf->tmpfolio, 0),
+						REQ_OP_READ)) {
 					atomic_add(s, &rdev->corrected_errors);
 					pr_info("md/raid1:%s: read error corrected (%d sectors at %llu on %pg)\n",
 						mdname(mddev), s,
@@ -3099,8 +3101,8 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 	if (!conf->mirrors)
 		goto abort;
 
-	conf->tmppage = alloc_page(GFP_KERNEL);
-	if (!conf->tmppage)
+	conf->tmpfolio = folio_alloc(GFP_KERNEL, 0);
+	if (!conf->tmpfolio)
 		goto abort;
 
 	r1bio_size = offsetof(struct r1bio, bios[mddev->raid_disks * 2]);
@@ -3175,7 +3177,7 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 	if (conf) {
 		mempool_destroy(conf->r1bio_pool);
 		kfree(conf->mirrors);
-		safe_put_page(conf->tmppage);
+		safe_folio_put(conf->tmpfolio);
 		kfree(conf->nr_pending);
 		kfree(conf->nr_waiting);
 		kfree(conf->nr_queued);
@@ -3290,7 +3292,7 @@ static void raid1_free(struct mddev *mddev, void *priv)
 
 	mempool_destroy(conf->r1bio_pool);
 	kfree(conf->mirrors);
-	safe_put_page(conf->tmppage);
+	safe_folio_put(conf->tmpfolio);
 	kfree(conf->nr_pending);
 	kfree(conf->nr_waiting);
 	kfree(conf->nr_queued);
-- 
2.39.2

