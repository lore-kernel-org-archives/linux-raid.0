Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68ADA4B0C83;
	Wed, 16 Sep 2026 09:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789552771; cv=none; b=IUZD7/steQ62c/RKFegNoaR2JNUngVj+uYx+2UUyCdHQPVmt1WPVILH3tIu3xgB5bFzhV+Wy77BN5Rfz+jCrVE43NAushFgNt2Qc2XtsaGf13TyDsUnYcs1pegCVxVttR6lRPTL99ha4cff9Jht5xK+NNQtW49SUxwa6snfut20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789552771; c=relaxed/simple;
	bh=+TXRvxpFo83g7o5W+VY7kuHQYYo1oEJrBFeQuAdMvaU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=s73KNivMToTK0JdCYu3ZRJD3MkrRygmGGOLLJjMkXD9CSVgZ1OpSRYvPVfoQow0yg+0oi6llpouQSMoQJ0dsZjAJIRh51mJbn0HdW/kHTqm7eS4P6omt/0T7i77ecjfAKoCTTugo7dpbIUyYx7L8usF1sqqA6Ja7z7eEK3OFsio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hlDqs3GLJzKHLxM;
	Wed, 16 Sep 2026 17:59:05 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A4B6E4056E;
	Wed, 16 Sep 2026 17:59:19 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgBHFyp2aKpqAYEIAg--.795S4;
	Wed, 16 Sep 2026 17:59:19 +0800 (CST)
From: Zizhi Wo <wozizhi@huaweicloud.com>
To: song@kernel.org,
	yukuai@fygo.io,
	magiclinan@didiglobal.com,
	xiao@kernel.org,
	linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	yangerkun@huawei.com,
	chengzhihao1@huawei.com,
	wozizhi@huawei.com
Subject: [PATCH] md/raid5: reject a per-device size smaller than one chunk
Date: Wed, 16 Sep 2026 17:51:36 +0800
Message-ID: <20260916095137.1157801-1-wozizhi@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHFyp2aKpqAYEIAg--.795S4
X-Coremail-Antispam: 1UD129KBjvJXoWxGr1DJFWUZF1fCryUZw4ruFg_yoW5uFy3p3
	yfJF9Iqr18WFy5Jws5A3Z7KFWFy39xJr4DtFyfXay8X3WSgrWDJry5Gry5WFyUAwnYyrWr
	t3WDJrWqka4kK3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyCb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij
	64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
	xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF
	7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07UAwIDUUUUU=
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/

From: Zizhi Wo <wozizhi@huawei.com>

Both raid5_run() and raid5_resize() align the per-device size down to a
whole multiple of the chunk size:

	mddev->dev_sectors &= ~(chunk_sectors - 1);

Neither checks the result, so a size smaller than one chunk silently
becomes zero.

In raid5_run() that is harmless: the array size is derived from the same
zero, so the disk just ends up with no capacity.

In raid5_resize() it leaves the array inconsistent -- mddev->dev_sectors
becomes zero, while mddev->array_sectors and the gendisk capacity keep the
previous. A later raid4/raid5 -> raid0 takeover copies the zero into every
rdev->sectors (raid0_takeover_raid45()), so create_strip_zones() builds a
strip zone table whose zone_end is zero. Any read then passes
bio_check_eod() against the stale capacity and hits the BUG() in
find_zone():

 kernel BUG at drivers/md/raid0.c:318!
 Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
 CPU: 45 UID: 0 PID: 1300 Comm: mdadm Not tainted 7.3.0-rc3+ #106 PREEMPT(full)
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-4.fc41 04/01/2014
 RIP: 0010:raid0_make_request+0x10cb/0x16a0
 Call Trace:
   <TASK>
   md_handle_request+0x566/0xb40
   __submit_bio+0x2b2/0x600
   submit_bio_noacct_nocheck+0x509/0xb30
   block_read_full_folio+0x364/0x6d0
   filemap_read_folio+0xa2/0x200
   do_read_cache_folio+0x1b6/0x330
   read_part_sector+0xb6/0x2a0
   read_lba+0x17d/0x280
   efi_partition+0x2a6/0x2520
   bdev_disk_changed+0x6e0/0xfa0
   ......
   bdev_open+0x214/0xc40

Reject a size smaller than one chunk in both functions, so that a running
raid4/raid5 array always has mddev->dev_sectors >= one chunk.

The check is done where the value takes effect, not where it is assigned.
mddev->dev_sectors is written from several places, and none of them can
tell whether the value is usable: the chunk size may still change later.
raid5_run() and raid5_resize() are where every input is final, so one check
in each covers them all.

Fixes: eea136d69f9f ("md: fix buglet in RAID5 -> RAID0 conversion.")
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
---
 drivers/md/raid5.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b91545ce090d..e0f1a8e7bd3a 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8201,10 +8201,16 @@ static int raid5_run(struct mddev *mddev)
 		goto abort;
 	}
 
 	/* device size must be a multiple of chunk size */
 	mddev->dev_sectors &= ~((sector_t)mddev->chunk_sectors - 1);
+	if (!mddev->dev_sectors) {
+		pr_warn("md/raid:%s: device size is smaller than one chunk\n",
+			mdname(mddev));
+		ret = -EINVAL;
+		goto abort;
+	}
 	mddev->resync_max_sectors = mddev->dev_sectors;
 
 	if (mddev->degraded > dirty_parity_disks &&
 	    mddev->resync_offset != MaxSector) {
 		if (test_bit(MD_HAS_PPL, &mddev->flags))
@@ -8534,10 +8540,12 @@ static int raid5_resize(struct mddev *mddev, sector_t sectors)
 	struct r5conf *conf = mddev->private;
 
 	if (raid5_has_log(conf) || raid5_has_ppl(conf))
 		return -EINVAL;
 	sectors &= ~((sector_t)conf->chunk_sectors - 1);
+	if (!sectors)
+		return -EINVAL;
 	newsize = raid5_size(mddev, sectors, mddev->raid_disks);
 	if (mddev->external_size &&
 	    mddev->array_sectors > newsize)
 		return -EINVAL;
 
-- 
2.52.0

