Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4911E318136;
	Mon, 15 Dec 2025 03:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765768547; cv=none; b=pKhz9sJAHNzsKTmqx9s+UX52EMryC6jGft0y16+fwqvfmS1d+lm7uEwIDztaY0tCIfaXlxmvauDynQzvj2RKWj59ECO1gx614fzHBQsUa43akOmmR/K9MYmW5J4GDJz6+oktkZXa5VDFw4B4LM8mVug+ohn0VNgFFURNDs86Qwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765768547; c=relaxed/simple;
	bh=ANgf1ON2d38lk0DGVyxDIbt555kkMunCAii5qM+cs54=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=N33gm0/9myHy38x0axk7EtvmPwOdUri5GXHB0muCj3ydUQlUmxVmUTwEzuOfTKpabkDQqe6kcxTi3u7PmCL49mvFGFAX7MMEii4D+DG7d/54gIyDLEzYSo3aththB+evXxhmk0m7xZ34Npdn5OlZksYWPdHpYeRd7OnS8FIhQFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dV4tn062BzYQtnc;
	Mon, 15 Dec 2025 11:15:13 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id D337A1A06D7;
	Mon, 15 Dec 2025 11:15:35 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP4 (Coremail) with SMTP id gCh0CgAXd_dUfT9p8AnuAA--.53622S8;
	Mon, 15 Dec 2025 11:15:35 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai@fnnas.com,
	neil@brown.name,
	namhyung@gmail.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	k@mgml.me,
	linan666@huaweicloud.com,
	yangerkun@huawei.com,
	yi.zhang@huawei.com
Subject: [PATCH v3 04/13] md/raid1,raid10: set Uptodate and clear badblocks if narrow_write_error success
Date: Mon, 15 Dec 2025 11:04:35 +0800
Message-Id: <20251215030444.1318434-5-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251215030444.1318434-1-linan666@huaweicloud.com>
References: <20251215030444.1318434-1-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXd_dUfT9p8AnuAA--.53622S8
X-Coremail-Antispam: 1UD129KBjvJXoWxGr4kJr1kuw1fKryftFWfGrg_yoW5XF15p3
	yDKFySy3yUJa43Zwn0yFWUuF9Ykw4IgFW7Ar4xC34DuasIqrWfGF48Xry3Wr1DAF9xu3W2
	qFn8G3yUGF47JFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUHI14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0V
	AKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr1j6F4U
	JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20V
	AGYxC7M4IIrI8v6xkF7I0E8cxan2IY04v7M4kE6xkIj40Ew7xC0wCY1x0262kKe7AKxVWU
	tVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4U
	MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUQqXLUUU
	UU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

narrow_write_error() returns true when all sectors are rewritten
successfully. In this case, set R1BIO_Uptodate to return success
to upper layers and clear correspondinga badblocks.

Signed-off-by: Li Nan <linan122@huawei.com>
---
 drivers/md/raid1.c  | 24 ++++++++++++++++++++----
 drivers/md/raid10.c | 17 +++++++++++++++--
 2 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 9ffa3ab0fdcc..bd63cf039381 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2587,9 +2587,10 @@ static void handle_write_finished(struct r1conf *conf, struct r1bio *r1_bio)
 	int m, idx;
 	bool fail = false;
 
-	for (m = 0; m < conf->raid_disks * 2 ; m++)
+	for (m = 0; m < conf->raid_disks * 2 ; m++) {
+		struct md_rdev *rdev = conf->mirrors[m].rdev;
+
 		if (r1_bio->bios[m] == IO_MADE_GOOD) {
-			struct md_rdev *rdev = conf->mirrors[m].rdev;
 			rdev_clear_badblocks(rdev,
 					     r1_bio->sector,
 					     r1_bio->sectors, 0);
@@ -2599,11 +2600,26 @@ static void handle_write_finished(struct r1conf *conf, struct r1bio *r1_bio)
 			 * narrow down and record precise write
 			 * errors.
 			 */
-			fail = true;
-			narrow_write_error(r1_bio, m);
+			if (narrow_write_error(r1_bio, m)) {
+				/* re-write success */
+				if (rdev_has_badblock(rdev,
+						      r1_bio->sector,
+						      r1_bio->sectors))
+					rdev_clear_badblocks(rdev,
+							     r1_bio->sector,
+							     r1_bio->sectors, 0);
+				if (test_bit(In_sync, &rdev->flags) &&
+				    !test_bit(Faulty, &rdev->flags))
+					set_bit(R1BIO_Uptodate,
+						&r1_bio->state);
+			} else {
+				fail = true;
+			}
+
 			rdev_dec_pending(conf->mirrors[m].rdev,
 					 conf->mddev);
 		}
+	}
 	if (fail) {
 		spin_lock_irq(&conf->device_lock);
 		list_add(&r1_bio->retry_list, &conf->bio_end_io_list);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 21a347c4829b..db6fbd423726 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2939,8 +2939,21 @@ static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
 					r10_bio->sectors, 0);
 				rdev_dec_pending(rdev, conf->mddev);
 			} else if (bio != NULL && bio->bi_status) {
-				fail = true;
-				narrow_write_error(r10_bio, m);
+				if (narrow_write_error(r10_bio, m)) {
+					/* re-write success */
+					if (rdev_has_badblock(rdev,
+							r10_bio->devs[m].addr,
+							r10_bio->sectors))
+						rdev_clear_badblocks(
+							rdev,
+							r10_bio->devs[m].addr,
+							r10_bio->sectors, 0);
+					if (test_bit(In_sync, &rdev->flags) &&
+					    !test_bit(Faulty, &rdev->flags))
+						set_bit(R10BIO_Uptodate, &r10_bio->state);
+				} else {
+					fail = true;
+				}
 				rdev_dec_pending(rdev, conf->mddev);
 			}
 			bio = r10_bio->devs[m].repl_bio;
-- 
2.39.2

