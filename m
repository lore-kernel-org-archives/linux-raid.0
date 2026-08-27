Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2CE3A3826
	for <linux-raid@vger.kernel.org>; Thu, 27 Aug 2026 07:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787817414; cv=none; b=nAg2J8uJ1LSdej55SvnckyjsLqE/hiOb3JOf/JnKLpeHmBpxCJq+wbGtb1kPzG72JNIV/ZTyL0RkuLtHTSRmydwb2QCoqJqE28COqSZpPAzmw3vox8iuCcUWRboq2jcKAPZb/UyDxdqH2gNFjroLzSQedVb5kQSU9a9Df9zs+lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787817414; c=relaxed/simple;
	bh=ySR3CHAIpeOmx8SUSJygHCyrlSpv93buUG7wLC/rXQU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PDQmfa4eJ64PhDejcedO9QP9xa+rgl/ohiUjETrwfA+/7Mz4DGXxWaWPWelpABQvOyMuqzYWjaOFBgnj/2Y2wGlVytoSSXban6s3csz1io0P6/5yDea2uknjIpW7Xp6/AtyR3aB0yizVuiPZuhtdGM9apK89JzSTTLRWRv21RNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=FCmHH0IC; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="FCmHH0IC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=ug
	myJsQ2mt6Ydrmc4i38LcWUXVIAEhm96I3w95i1Ue4=; b=FCmHH0ICK1/eG4ucTt
	TFcP5huvK2O2Bx/y/u90vk+3drDwG74xjfVmdYAZb8wd1NGqMVuCVSwodFAdJjsg
	ODSCED6pLUfesH+QDvCIO0d0YNfe5EbqbEUQ75iwPAX1JLiutlfpIj2kTlTjStNR
	f4dtll2093hv7ILI8m6/W8wLo=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wDnY4im7Y9qjfSOSQ--.19943S5;
	Thu, 27 Aug 2026 15:56:28 +0800 (CST)
From: "Li Youhong" <dayou5941@163.com>
To: song@kernel.org,
	yukuai@fygo.io
Cc: magiclinan@didiglobal.com,
	xiao@kernel.org,
	linux-raid@vger.kernel.org,
	Li Youhong <liyouhong@kylinos.cn>
Subject: [PATCH 3/3] md/raid1-10: share flush_bio_list between raid1 and raid10
Date: Thu, 27 Aug 2026 15:56:20 +0800
Message-Id: <20260827075620.3599227-4-dayou5941@163.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260827075620.3599227-1-dayou5941@163.com>
References: <20260827075620.3599227-1-dayou5941@163.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnY4im7Y9qjfSOSQ--.19943S5
X-Coremail-Antispam: 1Uf129KBjvJXoWxXw4UAr1xZw1DJF1UtF4xJFb_yoWrWw4rp3
	yaqa4agr48JrWUtan8XFWUu3WSg3WIqFW2krZ8Cas5XF1jvFyrGa13Jry8WryDAryfGFyU
	Za1Yk3y7G3W7tFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jTOJ5UUUUU=
X-CM-SenderInfo: 5gd103ivzuiqqrwthudrp/xtbC+Qwl02qP7axYMgAA3N

From: Li Youhong <liyouhong@kylinos.cn>

raid1 already had flush_bio_list(); raid10 open-coded the same
prepare/wake/submit loop in flush_pending_writes() and
raid10_unplug(). Move a shared helper into raid1-10.c.

The shared helper uses wq_has_sleeper() before wake_up(), matching
raid1's wake_up_barrier() and raid10_unplug(). No intentional
functional change.

Signed-off-by: Li Youhong <liyouhong@kylinos.cn>
---
 drivers/md/raid1-10.c | 17 +++++++++++++++++
 drivers/md/raid1.c    | 19 ++-----------------
 drivers/md/raid10.c   | 22 ++--------------------
 3 files changed, 21 insertions(+), 37 deletions(-)

diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
index c7ddf136771d..476682110ea3 100644
--- a/drivers/md/raid1-10.c
+++ b/drivers/md/raid1-10.c
@@ -176,6 +176,23 @@ static inline void raid1_prepare_flush_writes(struct mddev *mddev)
 	mddev->bitmap_ops->unplug(mddev, current->bio_list == NULL);
 }
 
+static inline void flush_bio_list(struct mddev *mddev, struct bio *bio,
+				wait_queue_head_t *wait)
+{
+	/* flush any pending bitmap writes to disk before proceeding w/ I/O */
+	raid1_prepare_flush_writes(mddev);
+	if (wq_has_sleeper(wait))
+		wake_up(wait);
+
+	while (bio) { /* submit pending writes */
+		struct bio *next = bio->bi_next;
+
+		raid1_submit_write(bio);
+		bio = next;
+		cond_resched();
+	}
+}
+
 /*
  * Used by fix_read_error() to decay the per rdev read_errors.
  * We halve the read error count for every hour that has elapsed
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 8a40c69d70a3..894efb50c6d5 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -919,21 +919,6 @@ static void wake_up_barrier(struct r1conf *conf)
 		wake_up(&conf->wait_barrier);
 }
 
-static void flush_bio_list(struct r1conf *conf, struct bio *bio)
-{
-	/* flush any pending bitmap writes to disk before proceeding w/ I/O */
-	raid1_prepare_flush_writes(conf->mddev);
-	wake_up_barrier(conf);
-
-	while (bio) { /* submit pending writes */
-		struct bio *next = bio->bi_next;
-
-		raid1_submit_write(bio);
-		bio = next;
-		cond_resched();
-	}
-}
-
 static void flush_pending_writes(struct r1conf *conf)
 {
 	/* Any writes that have been queued but are awaiting
@@ -959,7 +944,7 @@ static void flush_pending_writes(struct r1conf *conf)
 		 */
 		__set_current_state(TASK_RUNNING);
 		blk_start_plug(&plug);
-		flush_bio_list(conf, bio);
+		flush_bio_list(conf->mddev, bio, &conf->wait_barrier);
 		blk_finish_plug(&plug);
 	} else
 		spin_unlock_irq(&conf->device_lock);
@@ -1289,7 +1274,7 @@ static void raid1_unplug(struct blk_plug_cb *cb, bool from_schedule)
 
 	/* we aren't scheduling, so we can do the write-out directly. */
 	bio = bio_list_get(&plug->pending);
-	flush_bio_list(conf, bio);
+	flush_bio_list(conf->mddev, bio, &conf->wait_barrier);
 	kfree(plug);
 }
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 5b1dbb0b7f5a..85d2c9364565 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -895,16 +895,7 @@ static void flush_pending_writes(struct r10conf *conf)
 		__set_current_state(TASK_RUNNING);
 
 		blk_start_plug(&plug);
-		raid1_prepare_flush_writes(conf->mddev);
-		wake_up(&conf->wait_barrier);
-
-		while (bio) { /* submit pending writes */
-			struct bio *next = bio->bi_next;
-
-			raid1_submit_write(bio);
-			bio = next;
-			cond_resched();
-		}
+		flush_bio_list(conf->mddev, bio, &conf->wait_barrier);
 		blk_finish_plug(&plug);
 	} else
 		spin_unlock_irq(&conf->device_lock);
@@ -1101,16 +1092,7 @@ static void raid10_unplug(struct blk_plug_cb *cb, bool from_schedule)
 
 	/* we aren't scheduling, so we can do the write-out directly. */
 	bio = bio_list_get(&plug->pending);
-	raid1_prepare_flush_writes(mddev);
-	wake_up_barrier(conf);
-
-	while (bio) { /* submit pending writes */
-		struct bio *next = bio->bi_next;
-
-		raid1_submit_write(bio);
-		bio = next;
-		cond_resched();
-	}
+	flush_bio_list(mddev, bio, &conf->wait_barrier);
 	kfree(plug);
 }
 
-- 
2.25.1

