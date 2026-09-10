Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E32C4252B1
	for <linux-raid@vger.kernel.org>; Thu, 10 Sep 2026 08:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789027886; cv=none; b=RnjCC1paD5rWisFBmVYJaPkbtMqWVIdIdHjpIz4uB2yY41rcy3NGuibHoJ/KxkEIQ9pWRPseH3v1M8DThiS89o0xoiMy+tOQCLIL1iZgSdkZntMhAGiF5xsI1yu7saYEZKg3B13Vj+Ez9lLRVpuhij2cDlDk5dMUaAHU0nT79M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789027886; c=relaxed/simple;
	bh=SIwPKCSWNPT7kA5SO49gPlYWHhJgRQKntkekf3z0E/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VfYo5mgYH8kfLrNxs4nwAavWZqAz0KhiUE8derTpCZsTgKyNv+RiTUOo4OkfEtlgEIel9Xt++/WxFdcntGoyjLobP2CoqQcNo7SQes3c5eN6D5cZvYadkeBcdiaOTY41rtSaizOayxG625ycgt2jiDXDFcvsK1sH/BLIJCmcG+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=c8lOUu5/; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="c8lOUu5/"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-499de29beb7so1962715e9.1
        for <linux-raid@vger.kernel.org>; Thu, 10 Sep 2026 01:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1789027881; x=1789632681; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hIKqu2H5q6/v8mEseRX3ftASl1S+sA0hdu4/51URcsM=;
        b=c8lOUu5/1G67nuUz/+svYYor/KgjpMEzLrqJ/rNSwBk4Rb/pCBpX0tPq//iFs2Zd/m
         q4qXxCARcbjmvueVkmOhBuzWJzGbVisu81B3xB+sxExMlZac1xf2aPxms0VPQScEdGbP
         MjGt+yRUBEtoB9e1oZ+2g4veTM7Ey1zPCoT9Vy9MACByYlGVbWjERJMbftlnRtwOqPcT
         huT/nCaZ+ilzab+7lp7gFJNcz/nxi5CM3+vhZmv5wvkUKD8g6GR8KpmvAGWBO0KwYAx/
         eoNexRZoa4lvtat58+py50TMHLUtlw3IQld2JgO9hs31M59uNCu0LN1cvNNvvDEqLyLa
         7xCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789027881; x=1789632681;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hIKqu2H5q6/v8mEseRX3ftASl1S+sA0hdu4/51URcsM=;
        b=OtIHbbxlyYmEX71eQHvxr7oirHuw4Gtvwf0+w4fQt2LJWUd55xGURIch2w/CKB7Ecj
         jIoa3ZfwK7RXMTBwX8igT2rSd27daqumGvzyeMFIcGxPrqLq7W8PAqaApH/I8n3Tun+5
         r8bmf5WxwHnqq4CKKP1b0lq8QETfkROqa4qaYyUNPjffZ5B40DckJhAc479lBqpMETjp
         IUkiJMYVkY2L8ctDt8sre4+zn43xuhuYrL6cJhyz1e+gUUfrf5rCfsM8ZxUxhSQRYylW
         7CukrfykohTkt3hMBNOFEwI225rsNjEmrtNWO1Mw/3YjWV1OiEKStaqYUTEKAYdD0SRK
         KyDw==
X-Forwarded-Encrypted: i=1; AKwUvBwQhCCl8hbwasHbcyv3h1nOFYV9C2qdskWKsR7sDemVLKFumJ18XOaGsxUm9VoDCQ6x7VHWdSFxahMt@vger.kernel.org
X-Gm-Message-State: AFuF++kjaaYU9euiiehVGcRPjNeLzd1THwDEuGcwbemAa0fkW0/KdLn2
	2mJ8XbAqICHLYfjv/CUGmd/0ETW/D582cbyR0Vs9MxtNimWA4YHWvvgT3MrQN/IwILE=
X-Gm-Gg: AYBFou3Hpxp7ZvyDOI32xRzapd2+XsFwl/4sl60sEvrOwJoHvFdy/TZNyyV3Z7skUVs
	HwN6ZSkdYU55LMvYqBtvBakfVLDcyegodUyn4rBNdi8SJZEBIEnaG83CxGnbse1EWjppUqryz2K
	3jnIeJ2C2a/E3pPiJdO4rPUft2130IIah2v/iRcsc4JK4CWrEq1lQXBuMFte37vBvoZjnbR1wtS
	+7HFjEBzz6ywhhnoqMPB97JbkZrN8JBFuM8a9Vz2XbJi7MJ66cKwFdfSTmTiXXMuotQpUZ1pRw3
	n+UzUFIqcsAdVeoRVrkN34ws7w+9Rul8+s6Dqi+tBhu7YnJ3Vhn4V6K8C08Pj23fgix9BPHvNbM
	7Ikj72Jznx3Ho2XtLinmo2bRAD13LBTKCtXyIjAxlNoLKfX5mV3tMY0wCuZ+ZL37CusyPjDjqb5
	rF/jszjLwv5V/vLc6QqJ1P5QHiilAFwc9Gywxmx8d62LofBBvXFgAGoN7Zp4V8YpLtHvWWVi1MS
	KGM/qGbid0UvgpmtZxRKraphFU+xWrYf2GVuuXzRw6tOnwQ/MxA7wY=
X-Received: by 2002:a05:600c:8b2e:b0:49c:cbf4:572b with SMTP id 5b1f17b1804b1-49d01dcc1fdmr280205375e9.2.1789027881235;
        Thu, 10 Sep 2026 01:11:21 -0700 (PDT)
Received: from jwang-ThinkPad-T14-Gen-6.fkb.profitbricks.net ([212.227.34.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d20fc1be3sm55261135e9.4.2026.09.10.01.11.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 01:11:20 -0700 (PDT)
From: Jack Wang <jinpu.wang@ionos.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	linux-raid@vger.kernel.org,
	Nilay Shroff <nilay@linux.ibm.com>,
	abd.masalkhi@gmail.com
Cc: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Ming Lei <tom.leiming@gmail.com>,
	Xiao Ni <xiao@kernel.org>,
	Li Nan <magiclinan@didiglobal.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH v2 4/8] md: defer the io_opt update out of the sync thread
Date: Thu, 10 Sep 2026 10:11:09 +0200
Message-ID: <20260910081114.1605746-5-jinpu.wang@ionos.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260910081114.1605746-1-jinpu.wang@ionos.com>
References: <20260910081114.1605746-1-jinpu.wang@ionos.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jack Wang <jinpu.wang@cloud.ionos.com>

mddev_update_io_opt() runs from end_reshape() in the sync thread, and
md_reap_sync_thread() waits for that thread with reconfig_mutex held.
Taking q->limits_lock there hangs a finishing reshape whenever the
lock's holder waits for I/O that only md_check_recovery() can let
complete, and no ordering avoids it: the sync thread is what lets that
I/O finish.

Hand the update to a work item, which holds neither reconfig_mutex nor
the suspend and so takes q->limits_lock in the order the rest of md
uses, before suspending.  __md_stop() flushes it, as it suspends the
array.

Also give the function a queue_limits argument, so a caller that already
owns an update has it changed in place; the users of that path follow.

Assisted-by: LLM
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 drivers/md/md.c     | 49 ++++++++++++++++++++++++++++++++++++++-------
 drivers/md/md.h     |  7 ++++++-
 drivers/md/raid10.c |  2 +-
 drivers/md/raid5.c  |  2 +-
 4 files changed, 50 insertions(+), 10 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 3067ea05ba27..87e17ba86d93 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -671,6 +671,7 @@ void mddev_put(struct mddev *mddev)
 
 static void md_safemode_timeout(struct timer_list *t);
 static void md_start_sync(struct work_struct *ws);
+static void md_io_opt_work(struct work_struct *ws);
 
 static void active_io_release(struct percpu_ref *ref)
 {
@@ -794,6 +795,7 @@ int mddev_init(struct mddev *mddev)
 	mddev->level = LEVEL_NONE;
 
 	INIT_WORK(&mddev->sync_work, md_start_sync);
+	INIT_WORK(&mddev->io_opt_work, md_io_opt_work);
 	INIT_WORK(&mddev->del_work, mddev_delayed_delete);
 
 	return 0;
@@ -6330,20 +6332,51 @@ int mddev_stack_rdev_into(struct mddev *mddev, struct md_rdev *rdev,
 EXPORT_SYMBOL_GPL(mddev_stack_rdev_into);
 
 /* update the optimal I/O size after a reshape */
-void mddev_update_io_opt(struct mddev *mddev, unsigned int nr_stripes)
+static void md_io_opt_work(struct work_struct *ws)
 {
+	struct mddev *mddev = container_of(ws, struct mddev, io_opt_work);
+	struct request_queue *q = mddev->gendisk->queue;
 	struct queue_limits lim;
 
+	/*
+	 * Nothing is held here, so take q->limits_lock in the order the rest
+	 * of md uses: before the suspend, see md_start_sync().
+	 */
+	lim = queue_limits_start_update(q);
+	if (mddev_suspend(mddev, false) < 0) {
+		queue_limits_cancel_update(q);
+		return;
+	}
+	lim.io_opt = lim.io_min * READ_ONCE(mddev->io_opt_nr_stripes);
+	if (queue_limits_commit_update(q, &lim))
+		pr_err("%s: could not apply queue limits\n", mdname(mddev));
+	mddev_resume(mddev);
+}
+
+void mddev_update_io_opt(struct mddev *mddev, unsigned int nr_stripes,
+			 struct queue_limits *lim)
+{
 	if (mddev_is_dm(mddev))
 		return;
 
-	/* don't bother updating io_opt if we can't suspend the array */
-	if (mddev_suspend(mddev, false) < 0)
+	/*
+	 * With an update owned by the caller just change it in place; it is
+	 * committed, and the array resumed, by whoever started it.  Taking
+	 * q->limits_lock here would nest it inside reconfig_mutex and the
+	 * suspend, which deadlocks, see md_start_sync().
+	 */
+	if (lim) {
+		lim->io_opt = lim->io_min * nr_stripes;
 		return;
-	lim = queue_limits_start_update(mddev->gendisk->queue);
-	lim.io_opt = lim.io_min * nr_stripes;
-	queue_limits_commit_update(mddev->gendisk->queue, &lim);
-	mddev_resume(mddev);
+	}
+
+	/*
+	 * Called from the sync thread, which md_reap_sync_thread() waits for
+	 * with reconfig_mutex held, so q->limits_lock cannot be taken here
+	 * either.  Hand it to a work item that holds neither.
+	 */
+	WRITE_ONCE(mddev->io_opt_nr_stripes, nr_stripes);
+	queue_work(md_misc_wq, &mddev->io_opt_work);
 }
 EXPORT_SYMBOL_GPL(mddev_update_io_opt);
 
@@ -7139,6 +7172,8 @@ static void __md_stop(struct mddev *mddev)
 {
 	struct md_personality *pers = mddev->pers;
 
+	/* the deferred io_opt update suspends the array, so let it finish */
+	flush_work(&mddev->io_opt_work);
 	mddev_detach(mddev);
 	md_bitmap_destroy(mddev);
 	spin_lock(&mddev->lock);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index ebdd57677062..1b2e8720f0d1 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -554,6 +554,10 @@ struct mddev {
 	/* used for register new sync thread */
 	struct work_struct sync_work;
 
+	/* deferred io_opt update, see mddev_update_io_opt() */
+	struct work_struct	io_opt_work;
+	unsigned int		io_opt_nr_stripes;
+
 	/* "lock" protects:
 	 *   flush_bio transition from NULL to !NULL
 	 *   rdev superblocks, events
@@ -1056,7 +1060,8 @@ int mddev_stack_rdev_into(struct mddev *mddev, struct md_rdev *rdev,
  * is added with the array's current limits.
  */
 #define MDDEV_STACK_SKIP	((struct queue_limits *)ERR_PTR(-EAGAIN))
-void mddev_update_io_opt(struct mddev *mddev, unsigned int nr_stripes);
+void mddev_update_io_opt(struct mddev *mddev, unsigned int nr_stripes,
+			 struct queue_limits *lim);
 
 extern const struct block_device_operations md_fops;
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 222bd7badcff..5580ca77ef1e 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4932,7 +4932,7 @@ static void end_reshape(struct r10conf *conf)
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

