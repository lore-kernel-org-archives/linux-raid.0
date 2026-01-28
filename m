Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE7703382FA;
	Wed, 28 Jan 2026 08:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769587580; cv=none; b=QIRfXzRjix5+Mc3lte4pBmjKmxMi5a2AiDR1fw36FGeP60iNl9P5IhkXhRype5+ozToi3I7BgNTBua8Opx/uabdBaKoIolyBqaVMTWOi4L8aR6NW7QxiGqnP1raUOms3ki+Yx1yT2JfPKpYetp1NvRrC/FaPWZEFQvuOX2Mp9oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769587580; c=relaxed/simple;
	bh=8NC2ehBTY8Bn/LphTnL1rwWQpfZKABThW9nZ4iBCfns=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lsI/1H8zZC0sXmZQJRbilhx4qgeSH1VCt5tigWtsPWMGnGx59kd2j5eF2PnnAoO0EhD5NkmArpzR/54PuxvUkzeSYVrzNOG45VfvwdVxxU75GiKinfr4uEwB+uJzQsDd2lBZV83DroG8cK/84rgeclgUkI3TMRDy3UaoetlclcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4f1FFY5CPtzYQv1X;
	Wed, 28 Jan 2026 16:05:37 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id AAE6040593;
	Wed, 28 Jan 2026 16:06:14 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgBnFvd1w3lpPgyWFQ--.43207S13;
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
Subject: [PATCH v2 09/14] md/raid10: fix IO error at logical block size granularity
Date: Wed, 28 Jan 2026 15:57:03 +0800
Message-Id: <20260128075708.2259525-10-linan666@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgBnFvd1w3lpPgyWFQ--.43207S13
X-Coremail-Antispam: 1UD129KBjvJXoW7Wry7KrWfWw4DGF43AryDtrb_yoW5Jr1xpa
	9IkF1a9rWDGa1UZrnrAFWDX3WFk3y5tFWUtry8Gw4IgF98tryDKF45XFWYgry5CFWfZw10
	gr1DKr4xAa4kJF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUQ014x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
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
	67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI
	8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v2
	6r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUYVyIDUUUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

RAID10 currently fixes IO error at PAGE_SIZE granularity. Fix at smaller
granularity can handle more errors, and RAID will support logical block
sizes larger than PAGE_SIZE in the future, where PAGE_SIZE IO will fail.

Switch IO error fix granularity to logical block size.

Signed-off-by: Li Nan <linan122@huawei.com>
---
 drivers/md/raid10.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 5c0975ec8809..06257eea97ed 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2452,7 +2452,7 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 static void fix_recovery_read_error(struct r10bio *r10_bio)
 {
 	/* We got a read error during recovery.
-	 * We repeat the read in smaller page-sized sections.
+	 * We repeat the read in smaller logical_block_sized sections.
 	 * If a read succeeds, write it to the new device or record
 	 * a bad block if we cannot.
 	 * If a read fails, record a bad block on both old and
@@ -2468,14 +2468,11 @@ static void fix_recovery_read_error(struct r10bio *r10_bio)
 	struct folio *folio = get_resync_folio(bio)->folio;
 
 	while (sectors) {
-		int s = sectors;
+		int s = min_t(int, sectors, mddev->logical_block_size >> 9);
 		struct md_rdev *rdev;
 		sector_t addr;
 		int ok;
 
-		if (s > (PAGE_SIZE>>9))
-			s = PAGE_SIZE >> 9;
-
 		rdev = conf->mirrors[dr].rdev;
 		addr = r10_bio->devs[0].addr + sect;
 		ok = sync_folio_io(rdev,
@@ -2619,14 +2616,11 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 	}
 
 	while(sectors) {
-		int s = sectors;
+		int s = min_t(int, sectors, mddev->logical_block_size >> 9);
 		int sl = slot;
 		int success = 0;
 		int start;
 
-		if (s > (PAGE_SIZE>>9))
-			s = PAGE_SIZE >> 9;
-
 		do {
 			d = r10_bio->devs[sl].devnum;
 			rdev = conf->mirrors[d].rdev;
@@ -4925,16 +4919,14 @@ static int handle_reshape_read_error(struct mddev *mddev,
 	__raid10_find_phys(&conf->prev, r10b);
 
 	while (sectors) {
-		int s = sectors;
+		int s = min_t(int, sectors, mddev->logical_block_size >> 9);
 		int success = 0;
 		int first_slot = slot;
 
-		if (s > (PAGE_SIZE >> 9))
-			s = PAGE_SIZE >> 9;
-
 		while (!success) {
 			int d = r10b->devs[slot].devnum;
 			struct md_rdev *rdev = conf->mirrors[d].rdev;
+
 			if (rdev == NULL ||
 			    test_bit(Faulty, &rdev->flags) ||
 			    !test_bit(In_sync, &rdev->flags))
-- 
2.39.2

