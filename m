Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE5B6337BB0;
	Wed, 28 Jan 2026 08:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769587580; cv=none; b=njThAt1WZjy3mCR/gYwSUhZCWFrwwQr5nsv0CyMNaYFJo5CvochwkSuCH9pmnf7cxCtAnd5orLfOR64VEA/OgwpxCkiD07GXR+oW3E2h7rcvv4kSM+oHNxUFOPofBh+aVYLpNaqA3+FepjXx3XhWf/neNF74fVnmT8LqoKjGaZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769587580; c=relaxed/simple;
	bh=uPbGkRkdQ/Qs9Cac59z9ZZlpwoX+7kYt4639x6+FwnY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jS/15ee+JGs0jFuwUu6p3ylHxbtdF2lViJAJjOMgN35xccQr6uPU5x1rUjcAsa0K0YBosxbbb4DDokEluQ80DfYvSbupEWINf+Ut2ABhCm/0r/1MMNaWkEqjjhtVvyU/HPMgf07VHLBW2M+pfehBPzeUt5qIBUFrN/nIrYXeBRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4f1FFY1md9zYQv07;
	Wed, 28 Jan 2026 16:05:37 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 33FE74058D;
	Wed, 28 Jan 2026 16:06:14 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgBnFvd1w3lpPgyWFQ--.43207S7;
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
Subject: [PATCH v2 03/14] md/raid1: use folio for tmppage
Date: Wed, 28 Jan 2026 15:56:57 +0800
Message-Id: <20260128075708.2259525-4-linan666@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgBnFvd1w3lpPgyWFQ--.43207S7
X-Coremail-Antispam: 1UD129KBjvJXoWxZF48CF1rKrW5Jw4fGFWfZrb_yoW5CFWUpa
	n8G3Z5tr4UJr98JryDJFWkua4Sgw1xKayjkFZrG3yS9FsaqF95ZayYk34jgr1DXF98Ja4x
	XFZ8trW3ZF1rtF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmC14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JrWl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAa
	c4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzV
	Aqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm
	72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYx
	C7M4kE6xkIj40Ew7xC0wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2Iq
	xVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r
	106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AK
	xVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7
	xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_
	Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUB89NUUUUU=
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
index 407925951299..43453f1a04f4 100644
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
@@ -3120,8 +3122,8 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 	if (!conf->mirrors)
 		goto abort;
 
-	conf->tmppage = alloc_page(GFP_KERNEL);
-	if (!conf->tmppage)
+	conf->tmpfolio = folio_alloc(GFP_KERNEL, 0);
+	if (!conf->tmpfolio)
 		goto abort;
 
 	r1bio_size = offsetof(struct r1bio, bios[mddev->raid_disks * 2]);
@@ -3196,7 +3198,7 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 	if (conf) {
 		mempool_destroy(conf->r1bio_pool);
 		kfree(conf->mirrors);
-		safe_put_page(conf->tmppage);
+		folio_put(conf->tmpfolio);
 		kfree(conf->nr_pending);
 		kfree(conf->nr_waiting);
 		kfree(conf->nr_queued);
@@ -3310,7 +3312,7 @@ static void raid1_free(struct mddev *mddev, void *priv)
 
 	mempool_destroy(conf->r1bio_pool);
 	kfree(conf->mirrors);
-	safe_put_page(conf->tmppage);
+	folio_put(conf->tmpfolio);
 	kfree(conf->nr_pending);
 	kfree(conf->nr_waiting);
 	kfree(conf->nr_queued);
-- 
2.39.2

