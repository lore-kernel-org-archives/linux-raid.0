Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B3155C2C
	for <linux-raid@vger.kernel.org>; Tue,  5 Mar 2024 10:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709636064; cv=none; b=G1F4/xk5BXR4DvH2KHItJ5a5ApVoFML6EYoWrU5i5jQnHnQlvzm9joFc7Lw6hgtKPw0rIbvZE4SQoQGl2YrRN8xyT9cRmiomBNZcp8QIjnIPmttN4pHlO8qBapJCF70v20Pn0SPLcWEPrv5kB6YpA3z2yRXkwi80y5ouAAJZNic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709636064; c=relaxed/simple;
	bh=g4pLd+3L9u5cd6Pa8B23GqzFz3LOPXGffJGEe8ngzq0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=PbWZr1vswcbqVGH3GyajLY5oipTXu+UJadnRBCgpYc/8UdXeltYCXbrKaa30buaUdBF1gHobMShNRSq4ZggwxywdJrlA4F1wGbBEM+yn54JE9T+Fj7ac3r8xQ6tuiyYtSw4FXYOeApOPKYm+KGoQSapFmsfmx903fBvmNKf3K1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=hNyJc+Th; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="hNyJc+Th"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-33d146737e6so4241207f8f.0
        for <linux-raid@vger.kernel.org>; Tue, 05 Mar 2024 02:54:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1709636060; x=1710240860; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pkQVXYOXJhxA5I79t0kDskY3nQennzdZUErxQ2cH3ds=;
        b=hNyJc+Thc4iJD0i2Uj7H76WYzwOBMAkQN+RbBlYp80BKd6DsOl2pare6CPAAChagyA
         gOYQCweiOuoluDNh3CcUPYpMf8ioT1FdL35U8AwAoFAlxMUyNdy9DIBBD+aFek/Wssa7
         FWHwKS9EZVFYn+nQO6Z+RtxUIF9EVVDSjkPcGWQKyIoXdUracdI7wsw105i8sAXIEOyY
         fynOcwf2pbHEIYAHB6GesW4POhHYLtKvg9s1oIxVu5aK5R3fd4UQMvh3K2x6YTmB/NH+
         Ecjv4vKPZEbA8D8ERM0reRjMggNNwlNOE1oTZmsofk1dAqfHcGGYPOgFX2+BpkmESxkQ
         YiiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709636060; x=1710240860;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pkQVXYOXJhxA5I79t0kDskY3nQennzdZUErxQ2cH3ds=;
        b=tiEvwXaRq1jmA8ZaaXNou4TiW0ky1ptbHZZ2Vu3nQOGyhnzgx/lgDOxKxdadauwniC
         1LYWkQP9GR1xVF0aqtaLXrn3wN4/WUJ+7EE8TEM8zUuZOi44D+iN9LviaXEnG4qmq7bi
         IdH75mVXDEc/w9KVr1TxL8RllLW5dsLcJM3l1cl7cZJKXBW0hr/ir2bPhfr8eVbrtney
         lan5NJSPMMfQn0l60IDH2j75d8dWrb/sMRVv21tlKaapcN7fxSW+r30ZYPj6tA0uYtQm
         KqRJwyPotp/EXdAGAotAt2Xhv2NMfRDHIdMsAxSwp8V7wNDrIzNyOx84sSPAnyj4KFwX
         jnRQ==
X-Forwarded-Encrypted: i=1; AJvYcCUsa/qHUuH2V/zHVuoP442QOwa/cptnSQ/8y9OHkXLmApDkXpSolPuDziTgUie6arKiI5cJrRE6jWZmBCAFzpV7+xkJK1b6yBZ3pA==
X-Gm-Message-State: AOJu0YyG1T04hpMQgL8p8RCGXI69fwH2ydP8pdwdZIiZtpcPR6cLEYq2
	VDC7gIVR4aysK99Le5zpVDbL1c7EFZ23elWT1g3MVxFDaeUXSLmGswKqW/IGM9s=
X-Google-Smtp-Source: AGHT+IFdQMHFnDY9X/Iz27LxIjH8u2tchpSnahYs2RLZDcs3RxheGyyyXONHttNiOaoHuY5jBfpg9w==
X-Received: by 2002:adf:a38e:0:b0:33e:142f:7cb7 with SMTP id l14-20020adfa38e000000b0033e142f7cb7mr8253554wrb.40.1709636060271;
        Tue, 05 Mar 2024 02:54:20 -0800 (PST)
Received: from lb02065.fkb.profitbricks.net ([212.227.34.98])
        by smtp.gmail.com with ESMTPSA id ba27-20020a0560001c1b00b0033e284b2f1asm9457594wrb.38.2024.03.05.02.54.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Mar 2024 02:54:20 -0800 (PST)
From: Jack Wang <jinpu.wang@ionos.com>
To: song@kernel.org,
	yukuai3@huawei.com,
	linux-raid@vger.kernel.org
Cc: Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>
Subject: [PATCHv2] md: Replace md_thread's wait queue with the swait variant
Date: Tue,  5 Mar 2024 11:54:19 +0100
Message-Id: <20240305105419.21077-1-jinpu.wang@ionos.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>

Replace md_thread's wait_event()/wake_up() related calls with their
simple swait~ variants to improve performance as well as memory and
stack footprint.

Use the IDLE state for the worker thread put to sleep instead of
misusing the INTERRUPTIBLE state combined with flushing signals
just for not contributing to system's cpu load-average stats.

Also check for sleeping thread before attempting its wake_up in
md_wakeup_thread() for avoiding unnecessary spinlock contention.

With this patch (backported) on a kernel 6.1, the IOPS improved
by around 4% with raid1 and/or raid5, in high IO load scenarios.

Signed-off-by: Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
---
v2: fix a type error for thread
 drivers/md/md.c | 23 +++++++----------------
 drivers/md/md.h |  2 +-
 2 files changed, 8 insertions(+), 17 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 48ae2b1cb57a..14d12ee4b06b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7970,22 +7970,12 @@ static int md_thread(void *arg)
 	 * many dirty RAID5 blocks.
 	 */
 
-	allow_signal(SIGKILL);
 	while (!kthread_should_stop()) {
 
-		/* We need to wait INTERRUPTIBLE so that
-		 * we don't add to the load-average.
-		 * That means we need to be sure no signals are
-		 * pending
-		 */
-		if (signal_pending(current))
-			flush_signals(current);
-
-		wait_event_interruptible_timeout
-			(thread->wqueue,
-			 test_bit(THREAD_WAKEUP, &thread->flags)
-			 || kthread_should_stop() || kthread_should_park(),
-			 thread->timeout);
+		swait_event_idle_timeout_exclusive(thread->wqueue,
+			test_bit(THREAD_WAKEUP, &thread->flags) ||
+			kthread_should_stop() || kthread_should_park(),
+			thread->timeout);
 
 		clear_bit(THREAD_WAKEUP, &thread->flags);
 		if (kthread_should_park())
@@ -8017,7 +8007,8 @@ void md_wakeup_thread(struct md_thread __rcu *thread)
 	if (t) {
 		pr_debug("md: waking up MD thread %s.\n", t->tsk->comm);
 		set_bit(THREAD_WAKEUP, &t->flags);
-		wake_up(&t->wqueue);
+		if (swq_has_sleeper(&t->wqueue))
+			swake_up_one(&t->wqueue);
 	}
 	rcu_read_unlock();
 }
@@ -8032,7 +8023,7 @@ struct md_thread *md_register_thread(void (*run) (struct md_thread *),
 	if (!thread)
 		return NULL;
 
-	init_waitqueue_head(&thread->wqueue);
+	init_swait_queue_head(&thread->wqueue);
 
 	thread->run = run;
 	thread->mddev = mddev;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index b2076a165c10..1dc01bc5c038 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -716,7 +716,7 @@ static inline void sysfs_unlink_rdev(struct mddev *mddev, struct md_rdev *rdev)
 struct md_thread {
 	void			(*run) (struct md_thread *thread);
 	struct mddev		*mddev;
-	wait_queue_head_t	wqueue;
+	struct swait_queue_head	wqueue;
 	unsigned long		flags;
 	struct task_struct	*tsk;
 	unsigned long		timeout;
-- 
2.34.1

