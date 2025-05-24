Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5720225D7;
	Sat, 24 May 2025 06:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748067498; cv=none; b=Tm5CpkEsoZhkwLDF57jJOwMoc/opRnn0hOhp1kRM2enrgnEX8/jQto1pDI+gHU3xmY6pSsl2xhEh9iGhegllRgUOl9d7lh/0FC5RJrvj/teEy8Y+8qwYMXlOqanX0lTWwWc8Cjt+p3/ko+zT71wdFUj9/q3lHZVjbWlxNJjiOMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748067498; c=relaxed/simple;
	bh=6+ppI451X7aexKeFug6HrwsE1h5+ujY5PnqHzKrKlKc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=O6bqnjZzGmkbo/D6n/ZNPMwCfVEEC17lwuj/Q2ESDpnGiscnfLm09JLWGF2/skiqDW5XjZpfYaK/FIXNR+lReLPuMGShsFwj3z0m9umNpidP1mV9J5PBzFIDz1BjBGcHZShlopUCefqJkSFnyfiUWgdxZVO1Z5N91bHZm5FbMDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4b4BfY22QlzYQtvn;
	Sat, 24 May 2025 14:18:13 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 725ED1A0A65;
	Sat, 24 May 2025 14:18:12 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCnCl+dZDFo3etkNQ--.42979S6;
	Sat, 24 May 2025 14:18:12 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: hch@lst.de,
	xni@redhat.com,
	colyli@kernel.org,
	song@kernel.org,
	yukuai3@huawei.com
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH 02/23] md: factor out a helper raid_is_456()
Date: Sat, 24 May 2025 14:12:59 +0800
Message-Id: <20250524061320.370630-3-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250524061320.370630-1-yukuai1@huaweicloud.com>
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnCl+dZDFo3etkNQ--.42979S6
X-Coremail-Antispam: 1UD129KBjvJXoW7Kr47Kr4xtrWxWFy7GF1fXrb_yoW8XFyxpa
	yxXFyfArWUZFW3tw4DJrykua4Fgw13tryqyrWxu3yrXF15Xr1DGFyFqFZrZFyDWayfZrsI
	q3WUtr4Du3W09w7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUm014x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67
	kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY
	6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0x
	vEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVj
	vjDU0xZFpf9x0JUQXo7UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

There are no functional changes, the helper will be used by llbitmap in
following patches.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 9 +--------
 drivers/md/md.h | 6 ++++++
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 18e03f651f6b..b0468e795d94 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9037,19 +9037,12 @@ static sector_t md_sync_position(struct mddev *mddev, enum sync_action action)
 
 static bool sync_io_within_limit(struct mddev *mddev)
 {
-	int io_sectors;
-
 	/*
 	 * For raid456, sync IO is stripe(4k) per IO, for other levels, it's
 	 * RESYNC_PAGES(64k) per IO.
 	 */
-	if (mddev->level == 4 || mddev->level == 5 || mddev->level == 6)
-		io_sectors = 8;
-	else
-		io_sectors = 128;
-
 	return atomic_read(&mddev->recovery_active) <
-		io_sectors * sync_io_depth(mddev);
+	       (raid_is_456(mddev) ? 8 : 128) * sync_io_depth(mddev);
 }
 
 #define SYNC_MARKS	10
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 5ba4a9093a92..c241119e6ef3 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -1011,6 +1011,12 @@ static inline bool mddev_is_dm(struct mddev *mddev)
 	return !mddev->gendisk;
 }
 
+static inline bool raid_is_456(struct mddev *mddev)
+{
+	return mddev->level == ID_RAID4 || mddev->level == ID_RAID5 ||
+	       mddev->level == ID_RAID6;
+}
+
 static inline void mddev_trace_remap(struct mddev *mddev, struct bio *bio,
 		sector_t sector)
 {
-- 
2.39.2

