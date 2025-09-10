Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF84930FC23;
	Wed, 10 Sep 2025 08:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757493314; cv=none; b=aHSoyCJVHTWqU0St2ytezCyc441Fj+H2f4PItSyw/DLyQKd4f1yCxwYC3PPdpaCG5g2gh17FKfowa8LGMoMei/rRSf+qjHaojtHrsDUP+XeDzB8/2Kzwu1ObDAd+FSVZA4ejMVgR951BILA9Gi/bixrv+5DLdoCXHa8wohmT5M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757493314; c=relaxed/simple;
	bh=m0Zq0J9d8JUHm+mszd/pi8DixLe/wemrJV20dZtZ2SY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=RIft5YsR5ZIJIC6cnmstCDp5VKiAoyhE//GdUIcSa1fWE0xLOMJjsrgKaT2vtQle5axdGPnWQaDbTv/VJfkJxfAhL1vSIln0xdOEMvtAuYgnmmtF/27xIdLDCltgy24akI2tE5r4J2zE7N3qwf5yDVG6IFOUVWw80GasFsYhZ7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4cMDXG2np8zKHN9V;
	Wed, 10 Sep 2025 16:35:10 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 9621C1A084F;
	Wed, 10 Sep 2025 16:35:10 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgB3wY08OMFo7LgSCA--.53934S4;
	Wed, 10 Sep 2025 16:35:10 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH] md/raid1: skip recovery of already synced areas
Date: Wed, 10 Sep 2025 16:25:44 +0800
Message-Id: <20250910082544.271923-1-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB3wY08OMFo7LgSCA--.53934S4
X-Coremail-Antispam: 1UD129KBjvJXoW7WFW3JryDXFy3uryDtr13Arb_yoW8Cr15pa
	13Ja4ag347Ja13JayDZryUGayFya4xGrWxGF17W343Z3sYkFyDWaykXay5WFyDJF4fZw1Y
	q3ykZ3y3u3W5GaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9G14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r
	4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I
	648v4I1lw4CEc2x0rVAKj4xxMxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMx
	C20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAF
	wI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20x
	vE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v2
	0xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxV
	W8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUb5ku7UUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

When a new disk is added during running recovery, the kernel may
restart recovery from the beginning of the device and submit write
io to ranges that have already been synchronized.

Reproduce:
  mdadm -CR /dev/md0 -l1 -n3 /dev/sda missing missing
  mdadm --add /dev/md0 /dev/sdb
  sleep 10
  cat /proc/mdstat	# partially synchronized
  mdadm --add /dev/md0 /dev/sdc
  cat /proc/mdstat	# start from 0
  iostat 1 sdb sdc	# sdb has io, too

If 'rdev->recovery_offset' is ahead of the current recovery sector,
read from that device instead of issuing a write. It prevents
unnecessary writes while still preserving the chance to back up data
if it is the last copy.

Signed-off-by: Li Nan <linan122@huawei.com>
---
 drivers/md/raid1.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 3e422854cafb..ac5a9b73157a 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2894,7 +2894,8 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 		    test_bit(Faulty, &rdev->flags)) {
 			if (i < conf->raid_disks)
 				still_degraded = true;
-		} else if (!test_bit(In_sync, &rdev->flags)) {
+		} else if (!test_bit(In_sync, &rdev->flags) &&
+			   rdev->recovery_offset <= sector_nr) {
 			bio->bi_opf = REQ_OP_WRITE;
 			bio->bi_end_io = end_sync_write;
 			write_targets ++;
@@ -2903,6 +2904,9 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 			sector_t first_bad = MaxSector;
 			sector_t bad_sectors;
 
+			if (!test_bit(In_sync, &rdev->flags))
+				good_sectors = min(rdev->recovery_offset - sector_nr,
+						   (u64)good_sectors);
 			if (is_badblock(rdev, sector_nr, good_sectors,
 					&first_bad, &bad_sectors)) {
 				if (first_bad > sector_nr)
-- 
2.39.2

