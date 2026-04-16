Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00D230AD1C;
	Thu, 16 Apr 2026 03:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776311444; cv=none; b=nbS9StsQFlA1+fjiE5n2KoGTD9evbpwWja0woSxKoiUnzKfecu5W2GZ+2ldR1QXy7yasEEyVydtFIBTpwlSQhdqD0TbJ28eyeraQqCuzSo3mwHZ6YINbdBasIebG56et6/usmqonHxm9q5sn419WqpHRTFjjzIVYqEKY2MMkQks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776311444; c=relaxed/simple;
	bh=/wu8bWGRbozzMd4UftiQBcMXd1RkCGBuzfwwZgotG5U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gTnoju7chJhCBnsX3IUlkdwzH09VnEbeg+/rm0ZEZljK/52mn9Hcl1peoF2m9YEX4RGiovXtuUXgSVdvVdCeY5SanB0wL5xhoyPFlfWKOzCYasQPXFB9UfimtRFeAMXm0Psv1pkYgME6zq5wgR0b8RV5gHT2cu12tC2ZwfJp8Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fx3tw5Ym4zKHMM6;
	Thu, 16 Apr 2026 11:50:16 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 74D7640590;
	Thu, 16 Apr 2026 11:50:27 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP3 (Coremail) with SMTP id _Ch0CgCHM72BXOBpn95JAg--.61021S11;
	Thu, 16 Apr 2026 11:50:27 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH v3 7/8] md/raid1: fix IO error at logical block size granularity
Date: Thu, 16 Apr 2026 11:38:00 +0800
Message-Id: <20260416033801.786415-8-linan666@huaweicloud.com>
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
X-CM-TRANSID:_Ch0CgCHM72BXOBpn95JAg--.61021S11
X-Coremail-Antispam: 1UD129KBjvJXoW7ur15uw13Cr48Cw18Jw18Zrb_yoW8ZF1xpa
	17C39Yvr4UGrWUZr4DAryqy3WFkaySyFWUGrs5G3y29ryDZ3sxWFWUKayYgFyvkr9ayayU
	WwnFyr48C3W7tF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUQ014x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0V
	AKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr1j6F4U
	JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20V
	AGYxC7M4kE6xkIj40Ew7xC0wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCF
	x2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14
	v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY
	67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI
	8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v2
	6r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUYVyIDUUUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

RAID1 currently fixes IO error at PAGE_SIZE granularity. Fix at smaller
granularity can handle more errors, and RAID will support logical block
sizes larger than PAGE_SIZE in the future, where PAGE_SIZE IO will fail.

Switch IO error fix granularity to logical block size.

Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/raid1.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 724fd4f2cc3a..de8c964ca11d 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2116,7 +2116,7 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 {
 	/* Try some synchronous reads of other devices to get
 	 * good data, much like with normal read errors.  Only
-	 * read into the pages we already have so we don't
+	 * read into the block we already have so we don't
 	 * need to re-issue the read request.
 	 * We don't need to freeze the array, because being in an
 	 * active sync request, there is no normal IO, and
@@ -2147,13 +2147,11 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 	}
 
 	while(sectors) {
-		int s = sectors;
+		int s = min_t(int, sectors, mddev->logical_block_size >> 9);
 		int d = r1_bio->read_disk;
 		int success = 0;
 		int start;
 
-		if (s > (PAGE_SIZE>>9))
-			s = PAGE_SIZE >> 9;
 		do {
 			if (r1_bio->bios[d]->bi_end_io == end_sync_read) {
 				/* No rcu protection needed here devices
@@ -2192,7 +2190,7 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 			if (abort)
 				return 0;
 
-			/* Try next page */
+			/* Try next block */
 			sectors -= s;
 			sect += s;
 			off += s << 9;
@@ -2390,14 +2388,11 @@ static void fix_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 	}
 
 	while(sectors) {
-		int s = sectors;
+		int s = min_t(int, sectors, mddev->logical_block_size >> 9);
 		int d = read_disk;
 		int success = 0;
 		int start;
 
-		if (s > (PAGE_SIZE>>9))
-			s = PAGE_SIZE >> 9;
-
 		do {
 			rdev = conf->mirrors[d].rdev;
 			if (rdev &&
-- 
2.39.2

