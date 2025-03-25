Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B6CB666;
	Tue, 25 Mar 2025 02:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742868220; cv=none; b=M6D2lU1h9j4p4aWBaWORMg1c0BDA6modHzBhcSX2NdtkGQOFQ5kfXURICN1z6Bgt7hEQ5SuhMD5VdUN5+X/uPA3zb5OyKLMi8L8eVu1als/+ctsHNSSO7arE9JNAawawdHBXiIgKqqBc/gTfhegt2yTgb1D3riTiimUH2qgaAJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742868220; c=relaxed/simple;
	bh=WFE7MOFRJd0H1oOzfPjhras3v2n3Oy+pB4YlnYimc/A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VAVc/GzntiefezSWPR6oTKE7EpvPeFrXnwVJbmxe144n9pZBVkeW5zkPLpZyGj1GsTsBL+gL2qWdlSSCgVs/5FOQFBTHufQB4QehyH8EYzTo0kTOdiBJnnFpIfxSgjURwMHq3esD2S/SWNcgEs6CmItaPdCwhwvf69D+ld+Jovs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4ZMCqp3wF4z4f3kj8;
	Tue, 25 Mar 2025 10:03:02 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 67A851A0D4E;
	Tue, 25 Mar 2025 10:03:25 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDnSl_rDuJnainyHQ--.34151S4;
	Tue, 25 Mar 2025 10:03:25 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org,
	yukuai3@huawei.com,
	jgq516@gmail.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH] md/raid10: fix missing discard IO accounting
Date: Tue, 25 Mar 2025 09:57:46 +0800
Message-Id: <20250325015746.3195035-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDnSl_rDuJnainyHQ--.34151S4
X-Coremail-Antispam: 1UD129KBjvdXoWrKrWxAFWUXryDXrW7GFyrXrb_yoWkJrg_K3
	Z3WryxKr4fKrn3Kw1Fvr1Ivryj9w109FZ7WrWUWFWUZF98Wryjyry0gFWDtr15CF95Zr15
	A3WkWF1jvF1q9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbcAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
	Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r12
	6r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
	0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y
	0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
	WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1l
	IxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUYCJmUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

md_account_bio() is not called from raid10_handle_discard(), now that we
handle bitmap inside md_account_bio(), also fix missing
bitmap_startwrite for discard.

Test whole disk discard for 20G raid10:

Before:
Device   d/s     dMB/s   drqm/s  %drqm d_await dareq-sz
md0    48.00     16.00     0.00   0.00    5.42   341.33

After:
Device   d/s     dMB/s   drqm/s  %drqm d_await dareq-sz
md0    68.00  20462.00     0.00   0.00    2.65 308133.65

Fixes: 528bc2cf2fcc ("md/raid10: enable io accounting")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/raid10.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 9d8516acf2fd..6ef65b4d1093 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1735,6 +1735,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 	 * The discard bio returns only first r10bio finishes
 	 */
 	if (first_copy) {
+		md_account_bio(mddev, &bio);
 		r10_bio->master_bio = bio;
 		set_bit(R10BIO_Discard, &r10_bio->state);
 		first_copy = false;
-- 
2.39.2

