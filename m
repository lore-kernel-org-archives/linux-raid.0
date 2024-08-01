Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE3B189B98;
	Thu,  1 Aug 2024 13:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722519221; cv=none; b=JKpa71ANMEW3rLl8hLWAP+EE2LYspXY9K3mXRTkA/KtS4IpY9Ay8xvWYxN5TZdcX+C7VuvYKyEcbiGtcwgMdS8ix62ZCgVnvz0JrSKE0LXGOffnk+8l1Gm24IWdRLTRNc9z4cWxxbDOVJSuuDJQEHO0PPhTeLHIodnM3augmsZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722519221; c=relaxed/simple;
	bh=YsPA/zYl43yEyjeCoFf0wufs3qZtM9pQBAPnjHUBL8k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=H4vO92a7ZKHG4OVtidk4+YYcDT4WqKo7BLGH4wAf3hDEc5HpSH1M9CdbYjDcnAmeQVbOIfaiB+MtoOdn7SfrECmsIe301fuXA8MnXSzNzAEnypSG0mcxsDrEIBo4qxn3lloRUYQzQaJQVkS/Ezm4QC67AsEEginC0OT7fGc54Yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WZVKD71S4z4f3nJY;
	Thu,  1 Aug 2024 21:33:20 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 00F421A06D7;
	Thu,  1 Aug 2024 21:33:34 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBXzIKtjqtmwADkAQ--.2343S4;
	Thu, 01 Aug 2024 21:33:34 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH -next] md/raid1: cleanup local variable 'b' from radi1_read_request()
Date: Thu,  1 Aug 2024 21:30:08 +0800
Message-Id: <20240801133008.459998-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXzIKtjqtmwADkAQ--.2343S4
X-Coremail-Antispam: 1UD129KBjvJXoW7KFWDtFWkJrWrWF1kWF1xXwb_yoW8uF17pa
	1aqayxWrWDX3yUA3WDtFWUCFyrtw1YqFWIyrWxXw1DX3ZFvrZxuFWUJFWxWry5ZFya9ayD
	trs5ArWDuFyxtFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_
	JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8
	JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUYCJmUU
	UUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

The local variable will only be used onced, in the error path that
read_balance() failed to find a valid rdev to read. Since now the rdev
is ensured can't be removed from conf while IO is still pending,
remove the local variable and dereference rdev directly.

Since we're here, also remove an extra empty line, and unnecessary
type conversion from sector_t(u64) to unsigned long long.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/raid1.c | 21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 7acfe7c9dc8d..531ddfc6efbd 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1317,7 +1317,6 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	int max_sectors;
 	int rdisk;
 	bool r1bio_existed = !!r1_bio;
-	char b[BDEVNAME_SIZE];
 
 	/*
 	 * If r1_bio is set, we are blocking the raid1d thread
@@ -1326,16 +1325,6 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	 */
 	gfp_t gfp = r1_bio ? (GFP_NOIO | __GFP_HIGH) : GFP_NOIO;
 
-	if (r1bio_existed) {
-		/* Need to get the block device name carefully */
-		struct md_rdev *rdev = conf->mirrors[r1_bio->read_disk].rdev;
-
-		if (rdev)
-			snprintf(b, sizeof(b), "%pg", rdev->bdev);
-		else
-			strcpy(b, "???");
-	}
-
 	/*
 	 * Still need barrier for READ in case that whole
 	 * array is frozen.
@@ -1357,15 +1346,13 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	 * used and no empty request is available.
 	 */
 	rdisk = read_balance(conf, r1_bio, &max_sectors);
-
 	if (rdisk < 0) {
 		/* couldn't find anywhere to read from */
-		if (r1bio_existed) {
-			pr_crit_ratelimited("md/raid1:%s: %s: unrecoverable I/O read error for block %llu\n",
+		if (r1bio_existed)
+			pr_crit_ratelimited("md/raid1:%s: %pg: unrecoverable I/O read error for block %llu\n",
 					    mdname(mddev),
-					    b,
-					    (unsigned long long)r1_bio->sector);
-		}
+					    conf->mirrors[r1_bio->read_disk].rdev->bdev,
+					    r1_bio->sector);
 		raid_end_bio_io(r1_bio);
 		return;
 	}
-- 
2.39.2

