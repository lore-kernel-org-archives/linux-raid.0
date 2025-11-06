Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0070D3254B0;
	Thu,  6 Nov 2025 12:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762430887; cv=none; b=MC9cv2Ns62IBwEn2Nw3/9vaeyT8ZEF67mKOHtnMlH+p9bLGGy+pCIk8cDsJlO7/RpxEGHlQ6ul7G3o3EemCwJFrsjcNDr7LhMrxAmNvTL9omQjds+ZT60tb6TdAqvNYnvJJOiuP8Pvg5K369XvH/hImOaPix53Vq4mJbIYy5dtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762430887; c=relaxed/simple;
	bh=qsztN/G2JU6gTcvqfrPQtK4Pg4W1AKhKd96jKu7Sf/M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Wt4ezFGI72M3gERrdvbwTlsnoCJQj1TgqyxCw4Wo2H7T2Hnt11hlrBnmFFeZK06pPovknR01iwbnSlBaltygOHzCr+TQpGgdGVhI0KVbYqdjTOYdbjoXv1ERDbk5TIKC+on6j3FKx7uhI4UnLuoboaLoMrQsWogoFtBK9Evu1CM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4d2LYC2zdjzYQtn9;
	Thu,  6 Nov 2025 20:07:43 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id B61781A1CE7;
	Thu,  6 Nov 2025 20:08:01 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP2 (Coremail) with SMTP id Syh0CgCH3UWfjwxpEbabCw--.33933S7;
	Thu, 06 Nov 2025 20:08:01 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai@fnnas.com,
	neil@brown.name,
	namhyung@gmail.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	xni@redhat.com,
	k@mgml.me,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH v2 03/11] md/raid1,raid10: return actual write status in narrow_write_error
Date: Thu,  6 Nov 2025 19:59:27 +0800
Message-Id: <20251106115935.2148714-4-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251106115935.2148714-1-linan666@huaweicloud.com>
References: <20251106115935.2148714-1-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgCH3UWfjwxpEbabCw--.33933S7
X-Coremail-Antispam: 1UD129KBjvJXoWxJw43uw4rJrWkZr45KryUWrg_yoW5XFW5pr
	ZrWasayryUXF1rXF4DZFW7WasYk3yxtFW2yrs3Gwsru34FyF95Ga1jqryjgFyUuF9Ig3Wj
	qr15WrZruFn8JFUanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUHY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JrWl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAa
	c4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzV
	Aqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm
	72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYx
	C7M4IIrI8v6xkF7I0E8cxan2IY04v7M4kE6xkIj40Ew7xC0wCY1x0262kKe7AKxVWUtVW8
	ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r
	1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij
	64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr
	0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF
	0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUd5rcUUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

narrow_write_error() currently returns true when setting badblocks fails.
Instead, return actual status of all retried writes, succeeding only when
all retried writes complete successfully. This gives upper layers accurate
information about write outcomes.

When setting badblocks fails, mark the device as faulty and return at once.
No need to continue processing remaining sections in such cases.

Signed-off-by: Li Nan <linan122@huawei.com>
---
 drivers/md/raid1.c  | 17 +++++++++--------
 drivers/md/raid10.c | 15 +++++++++------
 2 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index e65d104cb9c5..090fe8f71224 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2541,11 +2541,15 @@ static bool narrow_write_error(struct r1bio *r1_bio, int i)
 		bio_trim(wbio, sector - r1_bio->sector, sectors);
 		wbio->bi_iter.bi_sector += rdev->data_offset;
 
-		if (submit_bio_wait(wbio) < 0)
+		if (submit_bio_wait(wbio)) {
 			/* failure! */
-			ok = rdev_set_badblocks(rdev, sector,
-						sectors, 0)
-				&& ok;
+			ok = false;
+			if (!rdev_set_badblocks(rdev, sector, sectors, 0)) {
+				md_error(mddev, rdev);
+				bio_put(wbio);
+				break;
+			}
+		}
 
 		bio_put(wbio);
 		sect_to_write -= sectors;
@@ -2596,10 +2600,7 @@ static void handle_write_finished(struct r1conf *conf, struct r1bio *r1_bio)
 			 * errors.
 			 */
 			fail = true;
-			if (!narrow_write_error(r1_bio, m))
-				md_error(conf->mddev,
-					 conf->mirrors[m].rdev);
-				/* an I/O failed, we can't clear the bitmap */
+			narrow_write_error(r1_bio, m);
 			rdev_dec_pending(conf->mirrors[m].rdev,
 					 conf->mddev);
 		}
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 231177cee928..9c43c380d7e8 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2820,11 +2820,15 @@ static bool narrow_write_error(struct r10bio *r10_bio, int i)
 				   choose_data_offset(r10_bio, rdev);
 		wbio->bi_opf = REQ_OP_WRITE;
 
-		if (submit_bio_wait(wbio) < 0)
+		if (submit_bio_wait(wbio)) {
 			/* Failure! */
-			ok = rdev_set_badblocks(rdev, wsector,
-						sectors, 0)
-				&& ok;
+			ok = false;
+			if (!rdev_set_badblocks(rdev, wsector, sectors, 0)) {
+				md_error(mddev, rdev);
+				bio_put(wbio);
+				break;
+			}
+		}
 
 		bio_put(wbio);
 		sect_to_write -= sectors;
@@ -2936,8 +2940,7 @@ static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
 				rdev_dec_pending(rdev, conf->mddev);
 			} else if (bio != NULL && bio->bi_status) {
 				fail = true;
-				if (!narrow_write_error(r10_bio, m))
-					md_error(conf->mddev, rdev);
+				narrow_write_error(r10_bio, m);
 				rdev_dec_pending(rdev, conf->mddev);
 			}
 			bio = r10_bio->devs[m].repl_bio;
-- 
2.39.2

