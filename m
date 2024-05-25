Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB121A2C04;
	Sat, 25 May 2024 11:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716635001; cv=none; b=HKON+DUF2epgF7IU2zCi98idg+eEPxJ9RlLU4sam745C2L8twmjq3hmtXfBOO8IzEwpV6Xet2LOX3C2yh7HpL3VhONU0PqrVAy7/WtgW1RjPHsFRv6002PhwR6xFdO7lqsEPhUjoLRo7VcZFOPG02wlKYdabA+gJ59m7rAW62+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716635001; c=relaxed/simple;
	bh=mou4fAjdh+yOsoWo0L90brn3S71ynw18k0dsVf4gNws=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fQg6z+vDLdEJupxL0s2ifRpddH1vXhe7TKQQauqQEvn1ngMUDAG9NohiRvKlRrz5sshm5FXEGEEuymXyAIXsxAVC5FTnnhhE4vBax1SFmQFmhOe0nKt2P4sq7cn9/JdJ53G51Qyca9Zv4IKZPfmYez3K/3v7Blklfpq5glr0FLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4VmfCF5Dvwz4f3mJB;
	Sat, 25 May 2024 19:03:05 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 598861A01A7;
	Sat, 25 May 2024 19:03:16 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP1 (Coremail) with SMTP id cCh0CgBnOBFzxVFmwOyJNg--.6823S4;
	Sat, 25 May 2024 19:03:16 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linan666@huaweicloud.com,
	yukuai3@huawei.com,
	yi.zhang@huawei.com,
	houtao1@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH] md: make md_flush_request() more readable
Date: Sun, 26 May 2024 02:56:22 +0800
Message-Id: <20240525185622.3896616-1-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgBnOBFzxVFmwOyJNg--.6823S4
X-Coremail-Antispam: 1UD129KBjvdXoWrKFy5Zr4UKryUCFWktw1DZFb_yoWDKrbEga
	ykZ34fGr42g34fKr1Uuw43A34Fya1Duw4DWF9Ig343Zry5A3y8KF95Wws8Zw18JFWxWr98
	K3yjqrWa9rn3KjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbf8FF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M280x2IEY4vEnII2IxkI6r1a6r45M28lY4IEw2IIxx
	k0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK
	6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7
	xvwVC2z280aVCY1x0267AKxVW0oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE
	52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUGV
	WUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAK
	I48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwAKzVCY07xG64k0F24l42xK82IYc2Ij64vIr4
	1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK
	67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI
	8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAv
	wI8IcIk0rVW3JVWrJr1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267
	AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7sRRrWrDUUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

Setting bio to NULL and checking 'if(!bio)' is redundant and looks strange,
just consolidate them into one condition. There are no functional changes.

Signed-off-by: Li Nan <linan122@huawei.com>
---
 drivers/md/md.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index aff9118ff697..509e5638cea1 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -654,15 +654,12 @@ bool md_flush_request(struct mddev *mddev, struct bio *bio)
 		WARN_ON(percpu_ref_is_zero(&mddev->active_io));
 		percpu_ref_get(&mddev->active_io);
 		mddev->flush_bio = bio;
-		bio = NULL;
-	}
-	spin_unlock_irq(&mddev->lock);
-
-	if (!bio) {
+		spin_unlock_irq(&mddev->lock);
 		INIT_WORK(&mddev->flush_work, submit_flushes);
 		queue_work(md_wq, &mddev->flush_work);
 	} else {
 		/* flush was performed for some other bio while we waited. */
+		spin_unlock_irq(&mddev->lock);
 		if (bio->bi_iter.bi_size == 0)
 			/* an empty barrier - all done */
 			bio_endio(bio);
-- 
2.39.2

