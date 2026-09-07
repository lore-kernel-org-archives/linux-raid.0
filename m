Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484FF4AA008
	for <linux-raid@vger.kernel.org>; Mon,  7 Sep 2026 13:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788788382; cv=none; b=GlrKbbPXrOeBXFj9fyGtVLKYDrOS/EfqThK2exZDKobsOLXfpkFjfcJ2Xu770dE4WbTRUoE34S6uh5Czl9ADlFtq8J9XnsgmWMkPtwFM6gniuGoKVjufAYEe5Oozmjo3YEV/mdqr+j2cpFapqfkBlCnWlur/I4xw8N+QopHniAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788788382; c=relaxed/simple;
	bh=zJUqRL9W3/R0ReXwaP73o2dj1HwyvkU2Y6S839qUzJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C05VEo5JF9+pKusx+Dxba5+CZOeiUGp4Z5/w9+RY88nZJ+vqmeSIZOtZGmFNzYkgZ63sF0XJ7DmzACN4HBFfD7y01OI+G/6CeIi9KVc/8yEOzqSAEWg/9vTAocycZZ9TcuzApIPuZ48I6pctBNZdfH6n6HGXp1T4nEoek2kjUvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=Gq+8gsy3; arc=none smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="Gq+8gsy3"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c255a6e63c0so41613966b.3
        for <linux-raid@vger.kernel.org>; Mon, 07 Sep 2026 06:39:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1788788378; x=1789393178; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RAKy1kDMUiJWA7j+43pJzxB3UmH28Ke8hWAucy1J8NE=;
        b=Gq+8gsy3v6jWjrg4y2h9fVKNblJq9CyDW1WYt2AcgG807JWmnXVO4Wdl8AELj3EJDx
         xSkhJCly8h1ZSegI53lxVARdM6GrvgVUbrOlSS5GLTP6Cca9y1nhSRkTDo3zjpAjl98P
         sVCwEhfMgrWD4nBkispvcHKiqEHMt+ZtSU4HO7htuuGRkf5qt/OZimGrdV087VOh7iuU
         Nc1RaAR14D/4pPy6HVLsAtKCJ81NJ55tlxFaoty6D+QfK3YaSxbqv6AAadpP+4Mnd/bz
         bP/UYAEv35TjgoL+pQCQ5JHOv+ue2t19J3Rv7fx5soBeYyBRwYWssdOQqQFzgpaGfNw5
         uxug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788788378; x=1789393178;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RAKy1kDMUiJWA7j+43pJzxB3UmH28Ke8hWAucy1J8NE=;
        b=d4On0PzB0CT8iQPw+ytdCA+IpKypdz9noYHBS8ihpj8gxKxcWLupQmv1tA1L0JNneS
         11BWCiXdFTQvD+F7ozWhLJkPBIPxA+jd8oDhRyo0S4peflY8cKptNZjMxMlbG9lqWDA9
         g+d+M94aJ2Ym9wcuU0qewAdaty/CRxxbgz0SnIHevZqkkST3jmLIudcxk/zQVJ5w37r6
         Qol82xfP3YWsCbiO9SmbxzWv3hHAlELxcGnj6mYcFcs2OC3dIosu8KRGpTyye9DtYsEn
         mGRwSVPQWnH1XBOO2ih4vK6DiZ5KUB/wB5zuHjwcXC+KzswoZLWxjZCzuPnBZStKw1Gm
         7EPQ==
X-Gm-Message-State: AFuF++nFEDXG5tWscbbB5flqQGRILPC+ATMIqUtsjL1vGNK7Qy93qv1K
	tvVBCX7x6WLEultMpx/f6mQKtirFCK6tiEvowXIO13Xc3d8HTeDI8iUBbxfN6HWfxxY=
X-Gm-Gg: AYBFou1Sik/ZetkfxUaypI9zTYB3MU2qAKfzfJhT9jc08YSA5TO/GYIEyyhpt95iCu/
	M9lntRlJfZhD1M4F8X4hSvwa4rhv5gstlC6+Fi8lgo1NIfTk+hsxiRDqWQKkQjDj8V+Q3nn9dBA
	2h3HplUbnx2e10vdhhfcxc3lPnM9OjLU3fltZMa+Ph2LvD5GzfFEVXhjs1tDezSj8fzCyrutmA4
	+1JVkZl+cz6Q+MZ1JgwBwEsCFaCneWO5P3+0iEmQne6HopbPdoU/e7EL7XL7oQoh4PDCKOl4mnO
	bw9fMPFcBbCYrQ2YzMbowhU4YuajjCE/5ciog/k6/mAgBtFoNSDqW5rJJU8xfQZHS1EO/b4Lh+v
	FNEGcC4W+6aNPwIB5r5xRWdxVIrfHRNxWeRIS9xDYSaTkWn4KjTZNzJCdNLCbK3O2DiQydm8y0w
	Is1AiHxfofhKydzMiqJ5Y2FLO2N/ZcBwWUpKGMxGcTfenH2Wc/AWT5eztIEw0lGgosnqI9XyHcI
	UY7/e8q0Jp3WSUZ0rxb+yHJFAhHpQQXug==
X-Received: by 2002:a17:906:4fd0:b0:c21:6f8c:231f with SMTP id a640c23a62f3a-c26115f07b2mr765198366b.1.1788788378410;
        Mon, 07 Sep 2026 06:39:38 -0700 (PDT)
Received: from jwang-ThinkPad-T14-Gen-6.fkb.profitbricks.net ([212.227.34.98])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c262c770678sm314301866b.53.2026.09.07.06.39.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 06:39:38 -0700 (PDT)
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
Subject: [PATCH 5/6] md: don't wait for q->limits_lock in mddev_update_io_opt()
Date: Mon,  7 Sep 2026 15:39:28 +0200
Message-ID: <20260907133929.1081540-6-jinpu.wang@ionos.com>
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

end_reshape() calls this from the sync thread, and
md_reap_sync_thread() waits for that thread with reconfig_mutex held.
Waiting for q->limits_lock here hangs a finishing reshape when the
lock's holder is waiting for I/O that only md_check_recovery() can
complete.

Use the trylock and skip the change on a contended pass; io_opt is a
hint.  Callers that own an update pass it in and have it changed in
place.

Only the lock leg is addressed; the same cycle also runs through the
mddev_suspend() below, which this function has always done from the
sync thread.

Assisted-by: Claude:claude-opus-5
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/md/md.c     | 33 +++++++++++++++++++++++++++------
 drivers/md/md.h     |  3 ++-
 drivers/md/raid10.c |  2 +-
 drivers/md/raid5.c  |  2 +-
 4 files changed, 31 insertions(+), 9 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 8ad6fe178e96..6af11a74db57 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6344,19 +6344,40 @@ static bool mddev_stack_limits_trylock(struct mddev *mddev,
 }
 
 /* update the optimal I/O size after a reshape */
-void mddev_update_io_opt(struct mddev *mddev, unsigned int nr_stripes)
+void mddev_update_io_opt(struct mddev *mddev, unsigned int nr_stripes,
+			 struct queue_limits *lim)
 {
-	struct queue_limits lim;
+	struct queue_limits own;
 
 	if (mddev_is_dm(mddev))
 		return;
 
+	/*
+	 * With an update owned by the caller just change it in place; it is
+	 * committed, and the array resumed, by whoever started it.  Taking
+	 * q->limits_lock here would nest it inside reconfig_mutex and the
+	 * suspend, which deadlocks, see md_start_sync().
+	 */
+	if (lim) {
+		lim->io_opt = lim->io_min * nr_stripes;
+		return;
+	}
+
+	/*
+	 * Called from the sync thread, which md_reap_sync_thread() waits for
+	 * with reconfig_mutex held, so don't wait for q->limits_lock here.
+	 * io_opt is a hint, skipping it on a contended pass is fine.
+	 */
+	if (!mddev_stack_limits_trylock(mddev, &own))
+		return;
+
 	/* don't bother updating io_opt if we can't suspend the array */
-	if (mddev_suspend(mddev, false) < 0)
+	if (mddev_suspend(mddev, false) < 0) {
+		queue_limits_cancel_update(mddev->gendisk->queue);
 		return;
-	lim = queue_limits_start_update(mddev->gendisk->queue);
-	lim.io_opt = lim.io_min * nr_stripes;
-	queue_limits_commit_update(mddev->gendisk->queue, &lim);
+	}
+	own.io_opt = own.io_min * nr_stripes;
+	queue_limits_commit_update(mddev->gendisk->queue, &own);
 	mddev_resume(mddev);
 }
 EXPORT_SYMBOL_GPL(mddev_update_io_opt);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 39b95951cc17..9e3bd5ab5519 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -1050,7 +1050,8 @@ int mddev_stack_rdev_limits(struct mddev *mddev, struct queue_limits *lim,
 int mddev_stack_new_rdev(struct mddev *mddev, struct md_rdev *rdev);
 int mddev_stack_rdev_into(struct mddev *mddev, struct md_rdev *rdev,
 			  struct queue_limits *lim);
-void mddev_update_io_opt(struct mddev *mddev, unsigned int nr_stripes);
+void mddev_update_io_opt(struct mddev *mddev, unsigned int nr_stripes,
+			 struct queue_limits *lim);
 
 extern const struct block_device_operations md_fops;
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index a5b65f377d04..641619328a6c 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4928,7 +4928,7 @@ static void end_reshape(struct r10conf *conf)
 	conf->reshape_safe = MaxSector;
 	spin_unlock_irq(&conf->device_lock);
 
-	mddev_update_io_opt(conf->mddev, raid10_nr_stripes(conf));
+	mddev_update_io_opt(conf->mddev, raid10_nr_stripes(conf), NULL);
 	conf->fullsync = 0;
 }
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 0ec555ada64a..3faa2a94c03b 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8800,7 +8800,7 @@ static void end_reshape(struct r5conf *conf)
 		wake_up(&conf->wait_for_reshape);
 
 		mddev_update_io_opt(conf->mddev,
-			conf->raid_disks - conf->max_degraded);
+			conf->raid_disks - conf->max_degraded, NULL);
 	}
 }
 
-- 
2.43.0

