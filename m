Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938AF432BD5
	for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 13:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783689834; cv=none; b=sbOoIHlKd0cqTydOqCersBeneWE0wpWPk5apWL9sphqGg4pjnFm6vIUAKTRCfUUjMki4q9svE3AlFVzF+nRvnBNIWT6I9KtIM09cBlPGn2oU2j0lbOA6ExVyPwOP/B6ZA/6LsA8sxyReEmo9FWeMEUKTwo2qcUQrOshNjmdIiYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783689834; c=relaxed/simple;
	bh=ROxI8I56kgfmTN4J4BZy2V7chA2+oyHggossUsMnPoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qdoV/4/iBMpyMYc1CMai+yHi5aou3KUu7a15CzhHZwVDqpu56gmvY4ZGW94F3lMCmkhTCCG0ZiBpaQE8ktBpYvoM+DAoAzp1wfYxdztMMARVubTROi/Hh+ICHihevu/ux5FkDF8QBEz+ctFkHfCVOQ2/6GikyfxJRQ6gd1TtqFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UwhDZecj; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UwhDZecj"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-c96b08cdd1cso608319a12.0
        for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 06:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783689832; x=1784294632; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=z1ptaSjjmJUeSpstZTVLuscns/xpL1khD7u065BJaVM=;
        b=UwhDZecjx/s9srJmWVSfX9ZTUDWZsrNTxI59YZ4sxQgCsPLkI7jVHoCqL6aSTA+aA3
         pgyn1qy51shf79LpkI86VqYQM8SRAPfCc/qWcUK0UhxRhqs8I5yYh4eMHjMW/1Bjoe7P
         bFGZOrnX9sYeQYcI2MnVN273esc1gKmTFdKHrcIFOfaZlrzZhN8+9zI6q61OPT4LzJcS
         AgWW06qxYcJCo98X1KM4xm96ibw2z5zXKotltWDKCBVRNWHNRTtTItKHSE06B2GZRztj
         YrH6e0zcCh7jJWTk+N56LRJcQ+LOz63Ia5/0PYTlSavRszXhUoTjt5taRY5SqgoWRq9x
         qOsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783689832; x=1784294632;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=z1ptaSjjmJUeSpstZTVLuscns/xpL1khD7u065BJaVM=;
        b=Z6Y2gKABSaCTULDT/aWdCn1jOJjRed6u0PpjEZoVO+mnN5p9MJvKk2GJvU2jAmt8IA
         tk6+zfCt+kbnV47bpDMObDXXdJhfNySCoOY481f0Q7Prscpj3pNa7m1LupjhuA13VCj+
         Up3QFDeDDyKdqrlQbo9J9dOLxz266E55FqkVzNkeVYnANnnqV3DrcVUVQ8KuH6xWHIQF
         3rS4UxzhYA5L5n+y9HKLeyHxkNaNaBvxismCEwJAseIBPeoInCj03xO88Cjl4gm7nAVT
         6k/3NLQXkKNZTXLQzCnMoJvpILh4KbGMxnoKnxZS40NxP4TYg3GT07RwQOTps/UlGsDz
         kZNQ==
X-Forwarded-Encrypted: i=1; AHgh+RoK3G6WZ7J8vr+aiecpDnXA7PWquRK2+XBnSJS2fNyKFIRIRPYryHmc1DlUrMiQKWIkJJH+K96BO+8G@vger.kernel.org
X-Gm-Message-State: AOJu0YztgShxQrV+gt7+XfxHBwJvBy4vCTJBrueJWsjw2TX1F/emKaEi
	P8G1h3R1RHwoZ05w72LB8V0MT9nNIgtKzuI8nYyV5WikYisDS//SyTA7
X-Gm-Gg: AfdE7cnTkA8kwo2sGSQt+bDlUQVSi0gsVtSEq3Qp3D3asr1lEOv1XujEkNlsDDhK6CP
	PyvYS99k5NyjyCFAHv2fRqMNu3wpNYUUmqpaI3R7MYnwMy5mEm6f2unGj7cwd8QZZf6ahXHpuGP
	sFbc/K+Bh8qNehgnVvyfs7UD8xAZ4VVrI56ui7EIt2dZq6K2uk7WhWoRwH3/2zml66JMPzIypl+
	iw+Uq0QlbEo36PtYNlME6XcmAH9ubzPPgUfR0tS1APhtdVc9mQstvQjHok8WhaOtx/m1zThLR9a
	mMQtdn4/OtTS2MIjeQYnnvzu9ad96Eh+VJ5f/Q55is5WkUoZcxu+84fbwwAh1fDarovxTY6OEgL
	HPJm3gHHDzaykI35rsAi2OGsCbWdKuZhWcDJZFtUfdUh0mP9DmxddwbXtk+1tuseQHCcA3TglYl
	oy/2b8Va0nnIe0C+4xR4f+Av1VG2mvqjraJj48ri08J04JJ5IbDU95mLxpkSZsM7j+Pxf0TrSvh
	T4qJ1U=
X-Received: by 2002:a05:6a20:a10e:b0:398:7df5:2dae with SMTP id adf61e73a8af0-3c0bcf49b71mr13545168637.9.1783689831988;
        Fri, 10 Jul 2026 06:23:51 -0700 (PDT)
Received: from research02.. ([2601:1c1:8700:f5b:fe34:97ff:fea3:c147])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ca5b3b251eesm4903776a12.31.2026.07.10.06.23.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 06:23:51 -0700 (PDT)
From: Hiroshi Nishida <nishidafmly@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hiroshi Nishida <nishidafmly@gmail.com>
Subject: [PATCH 4/6] md/raid5: make the stripe batch size a module parameter
Date: Fri, 10 Jul 2026 06:23:44 -0700
Message-ID: <20260710132346.7295-5-nishidafmly@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260710132346.7295-1-nishidafmly@gmail.com>
References: <20260710132346.7295-1-nishidafmly@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

handle_active_stripes() dequeues up to MAX_STRIPE_BATCH (8) stripes from a
worker group under a single device_lock acquisition, and
raid5_wakeup_stripe_thread() divides group->stripes_cnt by the same value
to decide how many additional workers to wake.  The two uses must move
together: the dequeue cap bounds how many stripes one worker drains, while
the spawn divisor sizes the worker fan-out to match.

Make the batch size a per-array value chosen by a new max_stripe_batch
module parameter (1-32, default 8, so behaviour is unchanged out of the
box).  Both the dequeue cap and the spawn divisor read the single
conf->max_stripe_batch, so they cannot drift apart.  The on-stack batch[]
array in handle_active_stripes() is sized to the STRIPE_BATCH_MAX (32)
upper bound; only conf->max_stripe_batch entries are ever used.

The value is resolved when an array is created.  On busy multi-threaded
arrays a larger batch amortises the device_lock over more stripes at some
latency cost; unlike the hash-lock count and the cache-size limit there is
no general hardware signal for the best batch size, so the default is left
at the historical 8 and the value is simply exposed for tuning.

Signed-off-by: Hiroshi Nishida <nishidafmly@gmail.com>
---
 drivers/md/raid5.c | 15 ++++++++++++---
 drivers/md/raid5.h | 12 +++++++++++-
 2 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index e41d3fc92dd0..5f0825c5effe 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -78,6 +78,11 @@ module_param(stripe_cache_size_max, uint, 0644);
 MODULE_PARM_DESC(stripe_cache_size_max,
 		 "Maximum the per-array stripe_cache_size may be raised to.  0 (the default) derives the limit from system memory (never below the historical 32768), so large-memory hosts can grow the stripe cache without a recompile while small ones are not offered a limit above what RAM can back.  A non-zero value sets a fixed limit");
 
+static unsigned int max_stripe_batch = STRIPE_BATCH_DEFAULT;
+module_param(max_stripe_batch, uint, 0644);
+MODULE_PARM_DESC(max_stripe_batch,
+		 "Number of stripes a worker thread handles per device_lock acquisition, 1-32 (default 8).  Larger values amortise the lock over more stripes on busy multi-threaded arrays at some latency cost.  Read when an array is created");
+
 static bool devices_handle_discard_safely = false;
 module_param(devices_handle_discard_safely, bool, 0644);
 MODULE_PARM_DESC(devices_handle_discard_safely,
@@ -221,7 +226,7 @@ static void raid5_wakeup_stripe_thread(struct stripe_head *sh)
 	/* at least one worker should run to avoid race */
 	queue_work_on(sh->cpu, raid5_wq, &group->workers[0].work);
 
-	thread_cnt = group->stripes_cnt / MAX_STRIPE_BATCH - 1;
+	thread_cnt = group->stripes_cnt / conf->max_stripe_batch - 1;
 	/* wakeup more workers */
 	for (i = 1; i < conf->worker_cnt_per_group && thread_cnt > 0; i++) {
 		if (group->workers[i].working == false) {
@@ -6734,11 +6739,11 @@ static int handle_active_stripes(struct r5conf *conf, int group,
 				 struct list_head *temp_inactive_list)
 		__must_hold(&conf->device_lock)
 {
-	struct stripe_head *batch[MAX_STRIPE_BATCH], *sh;
+	struct stripe_head *batch[STRIPE_BATCH_MAX], *sh;
 	int i, batch_size = 0, hash;
 	bool release_inactive = false;
 
-	while (batch_size < MAX_STRIPE_BATCH &&
+	while (batch_size < conf->max_stripe_batch &&
 			(sh = __get_priority_stripe(conf, group)) != NULL)
 		batch[batch_size++] = sh;
 
@@ -7640,6 +7645,10 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	    !conf->temp_inactive_list)
 		goto abort;
 
+	/* Resolve the stripe batch size (see STRIPE_BATCH_* in raid5.h). */
+	conf->max_stripe_batch = clamp_t(int, max_stripe_batch,
+					 1, STRIPE_BATCH_MAX);
+
 #if PAGE_SIZE != DEFAULT_STRIPE_SIZE
 	conf->stripe_size = DEFAULT_STRIPE_SIZE;
 	conf->stripe_shift = ilog2(DEFAULT_STRIPE_SIZE) - 9;
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 10c45fa22955..69a41c1310af 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -490,7 +490,16 @@ struct disk_info {
 #define BYPASS_THRESHOLD	1
 #define NR_HASH			(PAGE_SIZE / sizeof(struct hlist_head))
 #define HASH_MASK		(NR_HASH - 1)
-#define MAX_STRIPE_BATCH	8
+/*
+ * Stripe batch size: how many stripes a worker dequeues from its group per
+ * device_lock acquisition in handle_active_stripes(); the same value divides
+ * group->stripes_cnt in raid5_wakeup_stripe_thread() to choose how many extra
+ * workers to spawn, so the two stay coupled.  Selected per array by the
+ * max_stripe_batch module parameter: STRIPE_BATCH_DEFAULT is the historical
+ * value and STRIPE_BATCH_MAX bounds the on-stack batch[] array.
+ */
+#define STRIPE_BATCH_DEFAULT	8
+#define STRIPE_BATCH_MAX	32
 
 /*
  * The stripe cache hash is striped across a power-of-two number of spinlocks,
@@ -690,6 +699,7 @@ struct r5conf {
 	struct r5worker_group	*worker_groups;
 	int			group_cnt;
 	int			worker_cnt_per_group;
+	int			max_stripe_batch; /* stripes/dequeue, 1..STRIPE_BATCH_MAX */
 	struct r5l_log		*log;
 	void			*log_private;
 
-- 
2.43.0

