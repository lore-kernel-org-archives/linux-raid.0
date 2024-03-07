Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D513233
	for <linux-raid@vger.kernel.org>; Thu,  7 Mar 2024 12:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709813320; cv=none; b=n7VRxVPNE9D6DPMPD1eAtlGpWKydnvMMxvWn1BHWICahsPS/t9oo46+aKtS2fltwdIbF5RxVCjSgeojxTUisJMDF6juYfZKmCTEzT1xKO9GO8jGMAA1bE2UIUhzbIDLvkf3n9KnB/zwcuQiiSuHQ1Mo/231IlPhdLsd2kYT7nJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709813320; c=relaxed/simple;
	bh=m+mfU+8wXD3+/dnsGCzJ86xLQbakfbKXP93vmavhBTs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gRQZo79kZValYPEonO+gaQWfnZ+XbLm2khg9kDaiRRHm2lys/g9aEoWi9gsuC6zExAaHHdFtFgVbslRR2VY7YyBKmRfWAOjAV+DxJZ6Dau74YxG1jrhZnGBS/VtnflXfKeoSgHKrcwlSmNWl5l+R0Uct/YAXMHjmUGvIogHcHLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=dXU5J/dB; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="dXU5J/dB"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a45bb2a9c20so110104366b.0
        for <linux-raid@vger.kernel.org>; Thu, 07 Mar 2024 04:08:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1709813316; x=1710418116; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3utVI0s/M6nUL8jfQ9glZgov94y7iAabnWU07FxdczY=;
        b=dXU5J/dB88QrPnN/yGU9L/irSEBT9uoFJ3ipBrONHocZtzkAUMoeM3rnjt7CU7QT1J
         qS/UceiOh3vUSsARoYzg4rc9zT7S3bis9Llw5QziY5w7Ufgf5ML9Lnuylsp5PIvIprCZ
         yFzeSUkt+9bl5LAkTVswu/sBUJ0hvVJ1Dbguv1X2Q8C8jmNa7E1OVI7PHOeTR9LlBkY9
         eDEia0pIjsli6VktqKL/Ac9DA3kgzg3J5GtUD+t+4ndl9l+XnoF5eiOSNX0gfmzyOKr+
         rBt2a8OSfOU4lNDy0cWRmqLQz2bcaMJ/GRAZFPUsjswqCFFBirSFoE7QJPi+LaTP52nE
         7igg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709813316; x=1710418116;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3utVI0s/M6nUL8jfQ9glZgov94y7iAabnWU07FxdczY=;
        b=E2hLvyDQqd+9qyQffGisldBwSVAjfUe3I5omp/CrxZwm9aSX4Ued0uR1zrcFS5IcVZ
         qikwHstPkoxkczCxwPUZaMX9zCJqNga9SesMrMGXOvXzbe3LKuSUPfONxrY3RJtDlYgM
         vqO40pfpNo7Zwo9OcxFDhTbV82tXPCGc965sQpA/ah5C0vozhA2YN3fzdEyXf/YxiS3X
         X6xy2tMJnoOg4l2XD1+mLjkkTd+VAwZGlHYCntpLkNLzIspxf7UhJ18CG77doX8bk72k
         4LSBio1+8LFHXFaiaE9qP1EmMrrcO2gw46o2Z59R2Zocu1uDMgIfgZ78JBRF8Np8FB+V
         /6iA==
X-Forwarded-Encrypted: i=1; AJvYcCXil7or+0WuyfyYc4MNTFnxj/VBYxApQffXmlrxWNstYorI4WrMJTHQzbl92jd5+CiK1MlW3Cr3L2ZOC2jBi4NquGuxKySmIYJM8g==
X-Gm-Message-State: AOJu0YybppYvrNL14HLXK5gx+jnMHByXc1u/WehvxoaMiVLn1+cIWONU
	l8+1bwvMkuN+HvpnF3uQWQ9AkXCzwkFTWfbogutWQKhvt9jty/2eKDAPpa77KNw=
X-Google-Smtp-Source: AGHT+IEiAtopeT2pkgplITzq4WgFCILbxzeYEit9l3alz8UqE4ojKUsdMi8iAnQhG8bwapP3nEn/oA==
X-Received: by 2002:a17:906:1b45:b0:a45:c4ca:57aa with SMTP id p5-20020a1709061b4500b00a45c4ca57aamr2570302ejg.24.1709813316233;
        Thu, 07 Mar 2024 04:08:36 -0800 (PST)
Received: from lb02065.fritz.box ([2001:9e8:142b:9200:2226:fb4b:6683:33b1])
        by smtp.gmail.com with ESMTPSA id fw11-20020a170906c94b00b00a45a8c4edb4sm2744043ejb.48.2024.03.07.04.08.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Mar 2024 04:08:36 -0800 (PST)
From: Jack Wang <jinpu.wang@ionos.com>
To: song@kernel.org,
	yukuai3@huawei.com,
	linux-raid@vger.kernel.org
Cc: Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>
Subject: [PATCHv3] md: Replace md_thread's wait queue with the swait variant
Date: Thu,  7 Mar 2024 13:08:35 +0100
Message-Id: <20240307120835.87390-1-jinpu.wang@ionos.com>
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

Fixes: 93588e2284b6 ("[PATCH] md: make md threads interruptible again")
Signed-off-by: Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>

---
v3: add reviewed by from Paul, add fixes tag.
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

