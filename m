Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774804E80BD
	for <linux-raid@vger.kernel.org>; Mon,  7 Sep 2026 13:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788788379; cv=none; b=nxZX97ov5l5g6p7vKNarG7gdOrL4HVfBfLY9cp1rd2QIHqExfVHRLFrwGNFx3M6BUoEuc0VFKJpD24TnQDHUXfvvkez0eVTyRFooasAkrChjabHYdzYpoYhzzpykLLIfDiVKMLSFdY0BSwq2pgdwUl8KzB2vdYJ6wsA9APBWmyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788788379; c=relaxed/simple;
	bh=prXCmebQaCdjvFRyVULFNIUZsB2Io5vL9bOuq7Cyvzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uK77udJEoVNE/kQSwB5qzZa/NPU0f6DChhHbJKU8U1I9kedytq+qiea27uq1TfCKAUuEfpUXcoHWvEBZalrYILT6aYhRefYM7HK5uYF2o79d3nwTCf4vpQ/4d6ZYMzDyG3CVZiEnyPwbjTP+o05Ryz7uMrISdAhkYQb0rkDZW5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=XZEC4oMM; arc=none smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="XZEC4oMM"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c25085f2426so34397566b.3
        for <linux-raid@vger.kernel.org>; Mon, 07 Sep 2026 06:39:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1788788376; x=1789393176; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=C6b6jYO/XjuLk8J/F6waPCNC7mnrRvLEmjN6AteE2ZA=;
        b=XZEC4oMMHB3ZzqsIhxtD9p4xUgLagfX/efUa6fj9gpTzcAGig2jtji4ZgRR8j1onVH
         dA5Pq4vm1KRRRuWlsOMaUsEDz4dzZkeoUQJ8er7Q5nI8uqHO1r7y4wmPenBLVyWNQkjp
         zHbH/7OwBMQ1b4IJ3MhAkuzxf/UUpNbc0RQleWQLtrVmmxI/H/T3gbFi7z4X77Z8kiCI
         0T45JHaLApiepKpW7KMWxh467VjW3VqJ3d3oCAMWnrjiJf0f+CxTIpjsUNuWlgwgvhHM
         99wHM3nxSTbReurHNrIV04QP0i8RISewAk2nl+5l6FzaoI7Q1sUwTDgCGmcn2vFxAIoJ
         6jyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788788376; x=1789393176;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=C6b6jYO/XjuLk8J/F6waPCNC7mnrRvLEmjN6AteE2ZA=;
        b=h7hVez/CKKaDZn7PYtEc51fJ+sXP7NzuF2Ekx1OWnY6vC6jiIKu/wQfn+tFSOzjPQh
         xl7MNer4UR91IAGF7SFCWBNhzPZvaCfzJ5mepYVrTNmWI+0RBZepyYXLmeqczCQms8Hk
         BBvi/ck1cNQ7nTZ5gc4cmfFV6pZ7Tm87toTC/KJ+N5bUBUmnZcSc+08MTJJWHwPH4B/W
         ahWmMdbdSclohrFF1pV2j04qQBVGxG1w00XDePcUso5ilgkKJoaj16pQiEHgbmCUJ+Cu
         9wKDjFQQJ14VmwH5D8iC62Bub+l7XTgdSKdb8z7qwGRgo58vyc8NxmE58liBhZbIGTVd
         7Jow==
X-Gm-Message-State: AFuF++lqwlqe62vHnXbxJea+q5o+B7PbU5JIcHtFTgt96U9WYerDKArR
	TGOlWu6ujjZBCDvHAQrB5BYR/QEAPsCaKxavAlE3vwdjFzVXF9aHTODmTHN19M3XPrw=
X-Gm-Gg: AYBFou1Crc9iIDh0Ifjb4NHBhRXjyQspRNeihyCaFtQoruzT/JwgIveE3CWIH1BBYfW
	WwX6s7u1Nh8pKzMZDP1HvOyZxYDduzsvp5GSJsvjc6WdKYnfwumlXxcIxHNvQyD4TvNBw+5tsoh
	i4wb4Og6Ma7crjmEpUn0c3hYXQV+dsyG7yKdlkhNsOkLpAr4c1BZFbYLCo0cL+M9bltlBCEWho7
	J7WQ5MwqLwN2oeuaFR3OXlbTSd+dCytM1nz6ZaxKPuadufKz1QVraj3XqR+VJp4/TE/F/fl0pzV
	h+SL3Rw8ET5IFrR5ZDE1y+8DbtfnbWlaCUloI4Lz9h7gHbJUeeynz6hn0Rno0pQJHcE+BjA0AXM
	dz7Sr/GilKyNlh8y87M+8z5VgY0LG/09E1KZ/Ww6cHSZD/T07NmgQqT/JBuOXZCiLjO1Sm8gFJn
	TgnIANbiytTj1sitLPVa8n6eQ1VHBwFxAr70Y1aBwaXHb0zM73XLaMNSuh7WFUCSu9/3IR7Eysq
	rlN4lqfOYdgz9eJeSz5a9kFcbgdyPZJTt8=
X-Received: by 2002:a17:907:3f8d:b0:c25:ca8a:8e25 with SMTP id a640c23a62f3a-c2624eef698mr544864766b.1.1788788375696;
        Mon, 07 Sep 2026 06:39:35 -0700 (PDT)
Received: from jwang-ThinkPad-T14-Gen-6.fkb.profitbricks.net ([212.227.34.98])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c262c770678sm314301866b.53.2026.09.07.06.39.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 06:39:35 -0700 (PDT)
From: Jack Wang <jinpu.wang@ionos.com>
To: Nilay Shroff <nilay@linux.ibm.com>,
	abd.masalkhi@gmail.com
Cc: linux-raid <linux-raid@vger.kernel.org>,
	linux-block <linux-block@vger.kernel.org>,
	Song Liu <song@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	tom.leiming@gmail.com,
	Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH 3/6] md: don't wait for q->limits_lock in check_sb_changes()
Date: Mon,  7 Sep 2026 15:39:26 +0200
Message-ID: <20260907133929.1081540-4-jinpu.wang@ionos.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260907133929.1081540-1-jinpu.wang@ionos.com>
References: <20260907133929.1081540-1-jinpu.wang@ionos.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jack Wang <jinpu.wang@cloud.ionos.com>

check_sb_changes() activates a spare added by another node, with
reconfig_mutex held, from md_reload_sb().  Stacking that leg's limits
waits for q->limits_lock while holding the mutex, and the lock's holder
waits for I/O that can be waiting for a superblock update needing the
same mutex.

Take the update without blocking and keep the activation inline.  On a
contended pass only remove; MD_RECOVERY_NEEDED is set below, so
md_start_sync() does the add.

Assisted-by: Claude:claude-opus-5
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/md/md.c | 34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 28fc903ffeea..c7d1f9813f5d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6310,6 +6310,20 @@ int mddev_stack_rdev_into(struct mddev *mddev, struct md_rdev *rdev,
 }
 EXPORT_SYMBOL_GPL(mddev_stack_rdev_into);
 
+/* for callers that must not wait for q->limits_lock, see md_start_sync() */
+static bool mddev_stack_limits_trylock(struct mddev *mddev,
+				       struct queue_limits *lim)
+{
+	struct request_queue *q;
+
+	if (mddev_is_dm(mddev))
+		return false;
+
+	q = mddev->gendisk->queue;
+
+	return queue_limits_start_update_trylock(q, lim);
+}
+
 /* update the optimal I/O size after a reshape */
 void mddev_update_io_opt(struct mddev *mddev, unsigned int nr_stripes)
 {
@@ -10829,6 +10843,7 @@ static int __init md_init(void)
 
 static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
 {
+	struct queue_limits lim;
 	struct mdp_superblock_1 *sb = page_address(rdev->sb_page);
 	struct md_rdev *rdev2, *tmp;
 	int role, ret;
@@ -10885,7 +10900,24 @@ static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
 					rdev2->saved_raid_disk = -1;
 				else
 					rdev2->saved_raid_disk = role;
-				ret = remove_and_add_spares(mddev, rdev2, NULL);
+				/*
+				 * reconfig_mutex is held, so don't wait for
+				 * q->limits_lock; MD_RECOVERY_NEEDED below
+				 * leaves a skipped add to md_start_sync().
+				 */
+				if (mddev_stack_limits_trylock(mddev, &lim)) {
+					struct request_queue *q =
+						mddev->gendisk->queue;
+
+					ret = remove_and_add_spares(mddev,
+								    rdev2, &lim);
+					queue_limits_commit_update(q, &lim);
+				} else if (mddev_is_dm(mddev)) {
+					ret = remove_and_add_spares(mddev,
+								    rdev2, NULL);
+				} else {
+					ret = remove_spares(mddev, rdev2);
+				}
 				pr_info("Activated spare: %pg\n",
 					rdev2->bdev);
 				/* wakeup mddev->thread here, so array could
-- 
2.43.0

