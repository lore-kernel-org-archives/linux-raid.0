Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A167B3E7
	for <linux-raid@vger.kernel.org>; Tue,  5 Mar 2024 08:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709627087; cv=none; b=Ep+sK/iPucD0EH8er5MNo5OvngRT+/DPOJf9m7SKv2/ApIfRuT1UDFGILPpMJl1Zb03DKOfCYB25GjXXVZ2gMUA/EewbplqQVzcPo+6L2bRGKcamq5lvs95IAfHVePJOn84La9qx8kmSbfuMpLLbjwRRxGp5N/+Oj0AVodl1R0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709627087; c=relaxed/simple;
	bh=+9J/NYiUzdmj0rrm/pWPvbgPqKRNVgXDOjmvExErrFY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ULC/+sEVVzzn7nct8Ma4IrgoJLgQMlDdPKe2yuKePov95yhxY7ldOdVu5Nqr0Z0fBghhXIFtx3+DifVQMQ//8Hy06Ds6NQzOiXDjvs5c6SQR1DDsN1XTyW92j7iRsNGrzYfLR5LibgxCKHlfxwjKhpX/XL84vQ76ZKKFMbm9diU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=dU/Eoy8J; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="dU/Eoy8J"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-412e783c94fso10576925e9.1
        for <linux-raid@vger.kernel.org>; Tue, 05 Mar 2024 00:24:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1709627083; x=1710231883; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iQGqWZqXECkrA2jCW7qxJCTwHRJapbhF+G8KwS1aWZY=;
        b=dU/Eoy8JCGhcmmZvoDaDX809t7UO4WA7wkrAESGF1csnMjd8e0X0pOzfpIVqn21Km2
         4mSDYoc46CbaJxEYaDb/dIqN1dtghoo8ssoUxYhJIPt3ZQsxC5lKAz6V+Dgk/xyjWkMe
         Ermh/v45HE0bwizNvtl7OaJvzZnMhgH03ph2xwmjoQaw5LcZGPP5lknhwuGDVLHxF+K9
         5iVpIlrv90BCh6NlzhGG8oE7nXpBniPtOhCeOqseotZSV4HZ9qqprO3bj1Zwkmm1nLbn
         xIwcUc4qQT75OBOpajDI0atev+HYQE+Skl0nfqSVEjWk8sMLCpC7KxOccJYuowKH7Fbe
         cfUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709627083; x=1710231883;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iQGqWZqXECkrA2jCW7qxJCTwHRJapbhF+G8KwS1aWZY=;
        b=QQNEL2izhtTd42MhC8eKBYAMGIHqJD4L1Odcho0CI+zKfI1/KnBiKz3P6Le+yQNPf5
         nvVsT2h6sE5xTE3lEVaDQrOJ5GhQ+AaGbH0WpFbr2+KJz4KigTIiI63O8KukxTmzftbg
         mi3Rlhju2H8ga410PK2vsWO2jW7LSBDxd5O6+b8zB63djyB2BTINZ1J8a2Ue/K5I3Cjf
         cIALItwLBrgfx65MDfkr/qvFNW6xK8q1Q7usgMEwGWHPgxKHUgzzpGOn7uij/Hs6hAkx
         nLTTno1pK/ZSKwy3qGGgAHOxwNun1h1evfddJ4gJaqvJTMCemqEOG0PZs0TA29mq5Z50
         yAKQ==
X-Forwarded-Encrypted: i=1; AJvYcCUyzjiXSqvacXA5QOSj4E3rK6LElcxpQ/SiB66zfyREvpNDkxW+z8782+BWSipfsLdXOib/BIULlOrFBqaRbRoV1c8qmMbdMIYT9Q==
X-Gm-Message-State: AOJu0YytPiqJBA/XBYhx103DyktCmjfcZ1dRFSUjkOEkSy2w2rJJT9+Z
	UbbFpjuIUjqeMMBcdzrkSAnoszsqU9FiMfAwsB6/lBQxmAsJT3gnJSVzHvo+x70=
X-Google-Smtp-Source: AGHT+IEabFIZ2EYMAwNJ3quWn4uHbVXExfIBoSlROCriyERzPMOFfjODw14hIyq6FoPp4bj+sksU2g==
X-Received: by 2002:a05:600c:1e1b:b0:412:ee3b:336 with SMTP id ay27-20020a05600c1e1b00b00412ee3b0336mr464048wmb.30.1709627083388;
        Tue, 05 Mar 2024 00:24:43 -0800 (PST)
Received: from lb02065.fkb.profitbricks.net ([212.227.34.98])
        by smtp.gmail.com with ESMTPSA id t14-20020a1c770e000000b00411e1574f7fsm19792225wmi.44.2024.03.05.00.24.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Mar 2024 00:24:43 -0800 (PST)
From: Jack Wang <jinpu.wang@ionos.com>
To: song@kernel.org,
	yukuai3@huawei.com,
	linux-raid@vger.kernel.org
Cc: Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>
Subject: [PATCH] md: Replace md_thread's wait queue with the swait variant
Date: Tue,  5 Mar 2024 09:24:42 +0100
Message-Id: <20240305082442.13766-1-jinpu.wang@ionos.com>
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
 drivers/md/md.c | 23 +++++++----------------
 drivers/md/md.h |  2 +-
 2 files changed, 8 insertions(+), 17 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 48ae2b1cb57a..edc28767a9d7 100644
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
+		if (swq_has_sleeper(&thread->wqueue))
+			swake_up_one(&thread->wqueue);
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

