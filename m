Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE632337BB5;
	Wed, 28 Jan 2026 08:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769587579; cv=none; b=iuNt2M5upefTi9M18fSS6zAnYcDSx4OnlHArbKtthRPdz5Gjt/ph9Sm19DYbtC7Rcwe50JpgG1F/vWpKYG1YqiQEfJ9i6GyG9FvQwsf1OlhsSunag7ivf+vJyfl5EFl0Nx19/qkpX8EA38Ksa4dSypES6Ju7kWlHF34IRi2yHx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769587579; c=relaxed/simple;
	bh=pAjD63mRAWWvzH6X+Se7BDY3sx5axMN3Xu035H+ssTA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=L6BqgPLKW4STYzy++Gpn1W4twnogVoAg8BJpC+5GgjaDlCpEjGOiRJJhrZLmHuSjmBVmUdZ9+iHVwXACA2lcUVphYW4VCw+nXwsadvRhfEMwNJtonQczsWsGjrlvW9+4uSVN4DV9gkwq2ynjc3U9FPvJlCwdOuS/Oni4ar1DwgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4f1FFY2WpRzYQv0Z;
	Wed, 28 Jan 2026 16:05:37 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 4C0A34056B;
	Wed, 28 Jan 2026 16:06:14 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgBnFvd1w3lpPgyWFQ--.43207S8;
	Wed, 28 Jan 2026 16:06:14 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai@fnnas.com
Cc: xni@redhat.com,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH v2 04/14] md/raid10: use folio for tmppage
Date: Wed, 28 Jan 2026 15:56:58 +0800
Message-Id: <20260128075708.2259525-5-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20260128075708.2259525-1-linan666@huaweicloud.com>
References: <20260128075708.2259525-1-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBnFvd1w3lpPgyWFQ--.43207S8
X-Coremail-Antispam: 1UD129KBjvJXoWxAr18Kr1xGF1fCw13Gr18uFg_yoW5Kw4fpa
	1DGasIyrWUJw43Xw1DJayDC3WrK34SkFWUtrZ7W3yfua1ftr95K3WUJ3yjgFyDXF98JF1x
	XFW5XrW3u3Z7tF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUQj14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0V
	AKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr1j6F4U
	JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20V
	AGYxC7M4kE6xkIj40Ew7xC0wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCF
	x2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14
	v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY
	67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2
	IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUvhFsUUUUU=
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
index 1e57d9ce98e7..09238dc9cde6 100644
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
@@ -3841,7 +3842,7 @@ static void raid10_free_conf(struct r10conf *conf)
 	kfree(conf->mirrors);
 	kfree(conf->mirrors_old);
 	kfree(conf->mirrors_new);
-	safe_put_page(conf->tmppage);
+	folio_put(conf->tmpfolio);
 	bioset_exit(&conf->bio_split);
 	kfree(conf);
 }
@@ -3879,8 +3880,8 @@ static struct r10conf *setup_conf(struct mddev *mddev)
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

