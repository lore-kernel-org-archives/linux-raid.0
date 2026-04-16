Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5067A175A7D;
	Thu, 16 Apr 2026 03:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776311432; cv=none; b=sD/Mwyof3agmA7Foz15knPEMPE7S/wouIvgNPYZsB8W0nQb2Vl1rWLYZj53ACtdCprYuiBvuyxUrbxfkPfzz59zD+AkceQkIZemE/5wYYUqI9ks07u9Kp63TYOar7tiSLIII+FfSjaZAt+JXc8vSyd5qKja+OCJAvGx2FMGbUD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776311432; c=relaxed/simple;
	bh=Ihlw/i9iD0ZQTN20fni/qHfQvhR8nvpXGtPpUupHoEc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PGIlfIyIHGFNXNV4RrJAxNIzgUcVBH8aLbHkIglbAA7DlOfdKXwHKtb1RR7V5fZenkTNBdFquKfkKi638asH8lXxXjhEZAAKX1uvl7ZUNNoxATvb/egW8dJS6SmfcxoQYcrNNffCuCgAiNjvDrJVmc1ufFK3n6HdLsVHuyoZgXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fx3tD1YHlzYQth5;
	Thu, 16 Apr 2026 11:49:40 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 50B994056D;
	Thu, 16 Apr 2026 11:50:27 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP3 (Coremail) with SMTP id _Ch0CgCHM72BXOBpn95JAg--.61021S9;
	Thu, 16 Apr 2026 11:50:27 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH v3 5/8] md/raid10: use folio for tmppage
Date: Thu, 16 Apr 2026 11:37:58 +0800
Message-Id: <20260416033801.786415-6-linan666@huaweicloud.com>
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
X-CM-TRANSID:_Ch0CgCHM72BXOBpn95JAg--.61021S9
X-Coremail-Antispam: 1UD129KBjvJXoWxAr18Kr1xGF1fCw13Gr18uFg_yoWrJr15pa
	1DGasayrWUJw43Xw1DJFWDC3WrK34SkFWUtrZ7W3yfua1fKr95K3WUJ3yjgFyDXF98GF1x
	XFW5XrW5u3Z7tF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
	14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20x
	vaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8
	JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbItC3UUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

Convert tmppage to tmpfolio and use it throughout in raid10.

Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/raid10.h |  2 +-
 drivers/md/raid10.c | 37 +++++++++++++++++++------------------
 2 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/drivers/md/raid10.h b/drivers/md/raid10.h
index ec79d87fb92f..19f37439a4e2 100644
--- a/drivers/md/raid10.h
+++ b/drivers/md/raid10.h
@@ -89,7 +89,7 @@ struct r10conf {
 
 	mempool_t		r10bio_pool;
 	mempool_t		r10buf_pool;
-	struct page		*tmppage;
+	struct folio		*tmpfolio;
 	struct bio_set		bio_split;
 
 	/* When taking over an array from a different personality, we store
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 90c1036f6ec4..26f93040cd13 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2581,13 +2581,13 @@ static void recovery_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 	}
 }
 
-static int r10_sync_page_io(struct md_rdev *rdev, sector_t sector,
-			    int sectors, struct page *page, enum req_op op)
+static int r10_sync_folio_io(struct md_rdev *rdev, sector_t sector,
+			    int sectors, struct folio *folio, enum req_op op)
 {
 	if (rdev_has_badblock(rdev, sector, sectors) &&
 	    (op == REQ_OP_READ || test_bit(WriteErrorSeen, &rdev->flags)))
 		return -1;
-	if (sync_page_io(rdev, sector, sectors << 9, page, op, false))
+	if (sync_folio_io(rdev, sector, sectors << 9, 0, folio, op, false))
 		/* success */
 		return 1;
 	if (op == REQ_OP_WRITE) {
@@ -2650,12 +2650,13 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 					      r10_bio->devs[sl].addr + sect,
 					      s) == 0) {
 				atomic_inc(&rdev->nr_pending);
-				success = sync_page_io(rdev,
-						       r10_bio->devs[sl].addr +
-						       sect,
-						       s<<9,
-						       conf->tmppage,
-						       REQ_OP_READ, false);
+				success = sync_folio_io(rdev,
+							r10_bio->devs[sl].addr +
+							sect,
+							s<<9,
+							0,
+							conf->tmpfolio,
+							REQ_OP_READ, false);
 				rdev_dec_pending(rdev, mddev);
 				if (success)
 					break;
@@ -2698,10 +2699,10 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 				continue;
 
 			atomic_inc(&rdev->nr_pending);
-			if (r10_sync_page_io(rdev,
-					     r10_bio->devs[sl].addr +
-					     sect,
-					     s, conf->tmppage, REQ_OP_WRITE)
+			if (r10_sync_folio_io(rdev,
+					      r10_bio->devs[sl].addr +
+					      sect,
+					      s, conf->tmpfolio, REQ_OP_WRITE)
 			    == 0) {
 				/* Well, this device is dead */
 				pr_notice("md/raid10:%s: read correction write failed (%d sectors at %llu on %pg)\n",
@@ -2730,10 +2731,10 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 				continue;
 
 			atomic_inc(&rdev->nr_pending);
-			switch (r10_sync_page_io(rdev,
+			switch (r10_sync_folio_io(rdev,
 					     r10_bio->devs[sl].addr +
 					     sect,
-					     s, conf->tmppage, REQ_OP_READ)) {
+					     s, conf->tmpfolio, REQ_OP_READ)) {
 			case 0:
 				/* Well, this device is dead */
 				pr_notice("md/raid10:%s: unable to read back corrected sectors (%d sectors at %llu on %pg)\n",
@@ -3823,7 +3824,7 @@ static void raid10_free_conf(struct r10conf *conf)
 	kfree(conf->mirrors);
 	kfree(conf->mirrors_old);
 	kfree(conf->mirrors_new);
-	safe_put_page(conf->tmppage);
+	safe_folio_put(conf->tmpfolio);
 	bioset_exit(&conf->bio_split);
 	kfree(conf);
 }
@@ -3861,8 +3862,8 @@ static struct r10conf *setup_conf(struct mddev *mddev)
 	if (!conf->mirrors)
 		goto out;
 
-	conf->tmppage = alloc_page(GFP_KERNEL);
-	if (!conf->tmppage)
+	conf->tmpfolio = folio_alloc(GFP_KERNEL, 0);
+	if (!conf->tmpfolio)
 		goto out;
 
 	conf->geo = geo;
-- 
2.39.2

