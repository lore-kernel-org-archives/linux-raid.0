Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3740F13B280;
	Thu, 31 Oct 2024 03:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730345671; cv=none; b=r/g3Yo+HvDXIyIujqbQBLinKGCsWq5QTXrFndqvps/gwe2YCLR5Ukq25mgUYVIykxU2ULfh1RbFptnxFVgGlMf+zTfE//HT3IY+4PtZr6zxYGpXBLvCpgwQCs2Va9suoeMiggoglNeyvCq0m2FS3rpfLoPv+XItNi5gbEqsjmVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730345671; c=relaxed/simple;
	bh=XW321pUn7ogiuEZuCNtcFkcsBPkQVNaxAtwi9UUOIbs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AUb2mpCdjLcjcFTaKaH+skyNBFp7onWJPVoBc14+1f97WVhKARtjQOWh+lQmSzd4+byioZYRKtB0yB/bQDdFeytmm/pFV+MPFQF9ojyPlH+eJv1KoO6Lhmx/FZkzGf1/y00DakxPpNdd0sUMjCdAYlQ3+9rX7Kzad57ukfO2BiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Xf8jr0R8Kz4f3jXc;
	Thu, 31 Oct 2024 11:34:08 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id C49CD1A058E;
	Thu, 31 Oct 2024 11:34:25 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCXcYW6+iJnhVy1AQ--.50328S10;
	Thu, 31 Oct 2024 11:34:25 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org,
	mariusz.tkaczyk@intel.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RESEND 6/7] md/raid10: don't wait for Faulty rdev in wait_blocked_rdev()
Date: Thu, 31 Oct 2024 11:31:13 +0800
Message-Id: <20241031033114.3845582-7-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241031033114.3845582-1-yukuai1@huaweicloud.com>
References: <20241031033114.3845582-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCXcYW6+iJnhVy1AQ--.50328S10
X-Coremail-Antispam: 1UD129KBjvJXoW7AFWDZF48uw13Aw45Gw1rJFb_yoW8KFW7pa
	9xGFySyFW8GF47WF1DJr4UG3WYv34xKrW2yrZrJ345X3y3Kr98GF48JryrJr95AFZxZrW3
	WF15GrW7CayjyFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPj14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUAV
	WUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v2
	6r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2
	Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
	Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8Jw
	CI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUYcTQUUUU
	U
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Faulty rdev should never be accessed anymore, hence there is no point to
wait for bad block to be acknowledged in this case while handling write
request.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Tested-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 drivers/md/raid10.c | 40 ++++++++++++++++++----------------------
 1 file changed, 18 insertions(+), 22 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index f3bf1116794a..ff73db2f6c41 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1285,9 +1285,9 @@ static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r10_bio,
 
 static void wait_blocked_dev(struct mddev *mddev, struct r10bio *r10_bio)
 {
-	int i;
 	struct r10conf *conf = mddev->private;
 	struct md_rdev *blocked_rdev;
+	int i;
 
 retry_wait:
 	blocked_rdev = NULL;
@@ -1295,40 +1295,36 @@ static void wait_blocked_dev(struct mddev *mddev, struct r10bio *r10_bio)
 		struct md_rdev *rdev, *rrdev;
 
 		rdev = conf->mirrors[i].rdev;
-		rrdev = conf->mirrors[i].replacement;
-		if (rdev && unlikely(test_bit(Blocked, &rdev->flags))) {
-			atomic_inc(&rdev->nr_pending);
-			blocked_rdev = rdev;
-			break;
-		}
-		if (rrdev && unlikely(test_bit(Blocked, &rrdev->flags))) {
-			atomic_inc(&rrdev->nr_pending);
-			blocked_rdev = rrdev;
-			break;
-		}
-
-		if (rdev && test_bit(WriteErrorSeen, &rdev->flags)) {
+		if (rdev) {
 			sector_t dev_sector = r10_bio->devs[i].addr;
 
 			/*
 			 * Discard request doesn't care the write result
 			 * so it doesn't need to wait blocked disk here.
 			 */
-			if (!r10_bio->sectors)
-				continue;
-
-			if (rdev_has_badblock(rdev, dev_sector,
-					      r10_bio->sectors) < 0) {
+			if (test_bit(WriteErrorSeen, &rdev->flags) &&
+			    r10_bio->sectors &&
+			    rdev_has_badblock(rdev, dev_sector,
+					      r10_bio->sectors) < 0)
 				/*
-				 * Mustn't write here until the bad block
-				 * is acknowledged
+				 * Mustn't write here until the bad
+				 * block is acknowledged
 				 */
-				atomic_inc(&rdev->nr_pending);
 				set_bit(BlockedBadBlocks, &rdev->flags);
+
+			if (rdev_blocked(rdev)) {
 				blocked_rdev = rdev;
+				atomic_inc(&rdev->nr_pending);
 				break;
 			}
 		}
+
+		rrdev = conf->mirrors[i].replacement;
+		if (rrdev && rdev_blocked(rrdev)) {
+			atomic_inc(&rrdev->nr_pending);
+			blocked_rdev = rrdev;
+			break;
+		}
 	}
 
 	if (unlikely(blocked_rdev)) {
-- 
2.39.2

