Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C1828376;
	Sat,  3 Aug 2024 09:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722676527; cv=none; b=W/qDmCFnlybNB0PHTghZwzMssQQ71bzVGxY3W9LiqRTsShN4JYW0tYIwa6pk9+bsTIzfP1tLtZAHgFY89E5QDPy3zl41GACq51Yt6W3sguw20PepmtJC9WSiows9kfzvyYLg0k00q/0uAdnUcN9b0u6ejH0fZW9JB1T6eYV5wUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722676527; c=relaxed/simple;
	bh=tGIpLpaEhgijv8f8RvvxxyicyjNb1txa1fMQhYsjRYk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=pQNv6hF0GK91dnDsPU6TMgawfR2XQasBWGD282Q/F9QBtkkTC5CUXvRef+26VFpiW3JvEiR3XK0DEwIGf/mnygWC210W1vSj22O+gK76kg7Fi/VWWHvu1hpaIGG+suibiE/J79+qq6n8SgEARbbc7crYiC89M146gvLXVyJGotM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WbcVK2ctLz4f3jM1;
	Sat,  3 Aug 2024 17:15:05 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 303681A0359;
	Sat,  3 Aug 2024 17:15:14 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBXzIIc9a1msJmRAg--.16758S4;
	Sat, 03 Aug 2024 17:15:10 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org,
	mat.jonczyk@o2.pl,
	yukuai3@huawei.com,
	xni@redhat.com,
	paul.e.luse@linux.intel.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH -next] md/raid1: fix data corruption for degraded array with slow disk
Date: Sat,  3 Aug 2024 17:11:37 +0800
Message-Id: <20240803091137.3197008-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXzIIc9a1msJmRAg--.16758S4
X-Coremail-Antispam: 1UD129KBjvJXoWxArWrCrW5AFy7Zw4DCry3urg_yoW5XFyfpw
	4UWFyF934UJry7Wr1Dtw45CrWF9w45KFW8ArykG3yxZwn8trZ0gay8G345Gr98AFZ09w1I
	vwn8GrW7ZF1UJFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9014x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
	Y2ka0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIda
	VFxhVjvjDU0xZFpf9x0JUd-B_UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

read_balance() will avoid reading from slow disks as much as possible,
however, if valid data only lands in slow disks, and a new normal disk
is still in recovery, unrecovered data can be read:

raid1_read_request
 read_balance
  raid1_should_read_first
  -> return false
  choose_best_rdev
  -> normal disk is not recovered, return -1
  choose_bb_rdev
  -> missing the checking of recovery, return the normal disk
 -> read unrecovered data

Root cause is that the checking of recovery is missing in
choose_bb_rdev(). Hence add such checking to fix the problem.

Also fix similar problem in choose_slow_rdev().

Fixes: 9f3ced792203 ("md/raid1: factor out choose_bb_rdev() from read_balance()")
Fixes: dfa8ecd167c1 ("md/raid1: factor out choose_slow_rdev() from read_balance()")
Reported-and-tested-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
Closes: https://lore.kernel.org/all/9952f532-2554-44bf-b906-4880b2e88e3a@o2.pl/
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/raid1.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 531ddfc6efbd..1a45003ea7ee 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -617,6 +617,12 @@ static int choose_first_rdev(struct r1conf *conf, struct r1bio *r1_bio,
 	return -1;
 }
 
+static bool rdev_in_recovery(struct md_rdev *rdev, struct r1bio *r1_bio)
+{
+	return !test_bit(In_sync, &rdev->flags) &&
+	       rdev->recovery_offset < r1_bio->sector + r1_bio->sectors;
+}
+
 static int choose_bb_rdev(struct r1conf *conf, struct r1bio *r1_bio,
 			  int *max_sectors)
 {
@@ -635,6 +641,7 @@ static int choose_bb_rdev(struct r1conf *conf, struct r1bio *r1_bio,
 
 		rdev = conf->mirrors[disk].rdev;
 		if (!rdev || test_bit(Faulty, &rdev->flags) ||
+		    rdev_in_recovery(rdev, r1_bio) ||
 		    test_bit(WriteMostly, &rdev->flags))
 			continue;
 
@@ -673,7 +680,8 @@ static int choose_slow_rdev(struct r1conf *conf, struct r1bio *r1_bio,
 
 		rdev = conf->mirrors[disk].rdev;
 		if (!rdev || test_bit(Faulty, &rdev->flags) ||
-		    !test_bit(WriteMostly, &rdev->flags))
+		    !test_bit(WriteMostly, &rdev->flags) ||
+		    rdev_in_recovery(rdev, r1_bio))
 			continue;
 
 		/* there are no bad blocks, we can use this disk */
@@ -733,9 +741,7 @@ static bool rdev_readable(struct md_rdev *rdev, struct r1bio *r1_bio)
 	if (!rdev || test_bit(Faulty, &rdev->flags))
 		return false;
 
-	/* still in recovery */
-	if (!test_bit(In_sync, &rdev->flags) &&
-	    rdev->recovery_offset < r1_bio->sector + r1_bio->sectors)
+	if (rdev_in_recovery(rdev, r1_bio))
 		return false;
 
 	/* don't read from slow disk unless have to */
-- 
2.39.2

