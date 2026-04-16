Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506C81B4138;
	Thu, 16 Apr 2026 03:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776311432; cv=none; b=HmOpDSYPme/dnKRsWWFgGBYlHy94XdpUM9edXhSUcZhzsWPdHiYl/ZAP6F44sgDogqmaT5EtCM9uiaTZFhF0o2TOCWrxF5oCZcu5y8M8p9Wvj7hoAPhtv04m6zx6khrfcVbfFWyhdx1buuV6kVvGJtKSenSHglaurZDdldazFAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776311432; c=relaxed/simple;
	bh=GoYuto8yVEQg3khDeSUdY0V8FzUWXhTPMFTzZkHi0Eg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rdxo5kgqVbhOpnxobFV/SMVmgX6WcqzELGC4T9AQU5gLfeeMzjuBo0u56/v9USoUDnkNsW1TkmUQyBuco9gtmtiwxzTRupj4TrP/0BY3aKZE28bNQnKBopAYr9GkFNSO7s8ehtNSJhcuU/qZwpUAaSQ9gLd4EDDr0LJn8/fhsuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fx3tD2pflzYQth7;
	Thu, 16 Apr 2026 11:49:40 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 7C1844056D;
	Thu, 16 Apr 2026 11:50:27 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP3 (Coremail) with SMTP id _Ch0CgCHM72BXOBpn95JAg--.61021S12;
	Thu, 16 Apr 2026 11:50:27 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH v3 8/8] md/raid10: fix IO error at logical block size granularity
Date: Thu, 16 Apr 2026 11:38:01 +0800
Message-Id: <20260416033801.786415-9-linan666@huaweicloud.com>
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
X-CM-TRANSID:_Ch0CgCHM72BXOBpn95JAg--.61021S12
X-Coremail-Antispam: 1UD129KBjvJXoW7Wry7KrWfAr1rCw4DCrWDXFb_yoW8KFy8pa
	9xCFnrZrWDG3WUZrnrAFWDZ3WFk3y5tFWUKry8Gw4IgF9xtr98KF45XFWYgryYkFWav3W0
	g3Wqkr48C3WkJF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

RAID10 currently fixes IO error at PAGE_SIZE granularity. Fix at smaller
granularity can handle more errors, and RAID will support logical block
sizes larger than PAGE_SIZE in the future, where PAGE_SIZE IO will fail.

Switch IO error fix granularity to logical block size.

Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Yu Kuai <yukuai@fnnas.com>
---
 drivers/md/raid10.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 3638e00fe420..5b4ffd23211a 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2454,7 +2454,7 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 static void fix_recovery_read_error(struct r10bio *r10_bio)
 {
 	/* We got a read error during recovery.
-	 * We repeat the read in smaller page-sized sections.
+	 * We repeat the read in smaller logical_block_sized sections.
 	 * If a read succeeds, write it to the new device or record
 	 * a bad block if we cannot.
 	 * If a read fails, record a bad block on both old and
@@ -2470,14 +2470,11 @@ static void fix_recovery_read_error(struct r10bio *r10_bio)
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
@@ -2621,14 +2618,11 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
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
@@ -4926,13 +4920,10 @@ static int handle_reshape_read_error(struct mddev *mddev,
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
-- 
2.39.2

