Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2034A02
	for <linux-raid@vger.kernel.org>; Sat, 10 Jan 2026 22:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768083170; cv=none; b=ox9GgAaF8tG1KKe2GfmTNJ9ZM1PLdljPfhrjJYpOVGAQEDy5a98zSoc1phtIM/T7rbh93lmJqtepF6pAyFSB3koO9CLH6PjDRENC2zV5uAoowK1tz7JlL8ZH/l1mO2F0VnUbtrR1c8SAx+0ALZBT7PcC8Qhs4C8a4yzq886dlI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768083170; c=relaxed/simple;
	bh=dwJdxyq8oeAGKjQVEP6kM/jQFJQmzKlwqP+fUDURMQ8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qmYJVO0gAnsE+qRsNW9uUUM1ASMU9jJ56HEFDeB3kXHu+8H/B6YwegykFaTwwMV6C6nxyE9B266tUFnNIYF3qEiEYBqNWjDUHCume9KB0S1GM+GrTWr0SOImbsi/jfK7ayiTfcmTGLByRhUBWnTJF2pFvmbWTCFAfQZFjeZBN6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RhJqYOhX; arc=none smtp.client-ip=209.85.128.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RhJqYOhX"
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-7927541abfaso5391297b3.3
        for <linux-raid@vger.kernel.org>; Sat, 10 Jan 2026 14:12:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768083168; x=1768687968; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2OCFznWCLfAVq8ZLMcw5LxHE5/B2uAWeaHhU3RwQ/zQ=;
        b=RhJqYOhXRXVIbJZ+ZCQru49EEkJgdWbudiBsb9iS0HMUUJomIzRhM7uiJeRAzxgXHz
         0poFMrTWfiYusX5vVGjvFahEXZTBAAJOCH8KbJrbA/qf88a6t4SLMSZbcNnZ75P+OFHj
         clKasFQwu73HmZlGEIIIxpZCM8G7Rww8UvHl4NxKbmnAK6vA9ctV97sov9DTDk0TuzED
         kdXTEb5tvd64fiyYcon0iHyiKD+fsxzVeURPc5Fy/0inbj66tTO8hno8VuhaK99GoYIl
         eaMFMB/NPH75oepKMTjFydMytrsO2X3vEidWAxhZTmlomDBOx1bOI4hi/TBB1VBEFwdr
         bvXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768083168; x=1768687968;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2OCFznWCLfAVq8ZLMcw5LxHE5/B2uAWeaHhU3RwQ/zQ=;
        b=EdTgpo3UYHihjeL4UekXdZ9I3q1rq70/MR7vciYFUox2IuSehGye2yKZ9SJ0K92Pcu
         6Kb7NFMq6slIC6ltv1KN+cc4qoQEgcKhG0vbdUvM9QtfXjsCuIQvgk1lKAaRbFWuqw8z
         LL/2Uge0RXPrp4VGGCvlFukUyl44BDJCttKcVdo7lyUdZxw+0KYHdjicjEaN/HGIvjte
         BmKCroi5pshhTBB+o3vTge5wE6l6vwoXmZI/4fCeMSijY0ZlV1Wva12AmyvN0ksxP5Oi
         QrYVBGKQK8vCsRwgOIIp6I2+n3c0NdHyio3NseMUYVeiW6hp4jM2nGwu9iRT26clRq8w
         MGKQ==
X-Gm-Message-State: AOJu0Yzy6BZGHEqJFFJUmdk4mB55LtD3Bqlc/2OpTzHyClTVok3P3XNz
	AVTKrH5YlgiK5hPoL4hFkzpM7PkPe1IXRIKc57+mdNe1HqAJo4ondQ7k
X-Gm-Gg: AY/fxX7IaOt5auyjvaJD4XpmI60dxPsDLl6NPirZrzhNjsvfLKpdr3WT1trUBM/yEzL
	/F/vdDK5AOn2kI2udQMk8DBoKDdTgMQYwClQvEIsJzS2d2MYBd+V38WZnO9adFYhAE3+V7FRA3V
	ADq9t4fohm0PJMfNSxtqssVom8A+u5yp3npaSV6vc/zO5BNVlaWbC83jnxKPOwF1YQkI0YpwJPx
	PP/AZ7tAR9VR6spkSElkuM+kO8HQDcKyOxtOQKMmTuTwwpfYyXyAMAYkXYYCDCyih88CFWK/zLa
	hnL2E3WbzRFxUY9Z1lN/okzFPwVlKoq8XHrXOQmRE0uyxHXJQoLm3mA3NSy1SZwwKBSlleyCALD
	6/yQa2vd8LUHCv94uJS8qCgkUEfg3oI1gqaHxcTk2j9b84uyly6crNF10LLAQP/ao/8HvuzKjEX
	I0ML5QyrL/X9WvTE7+st3CspxzR16YyC1z
X-Google-Smtp-Source: AGHT+IGrYPfTfk5q6h1WeyJ/RNky3XDk+2PTvAKMBPLxC/R4OZlgXYzj690DbAYP3bPT/KlxhYTsZA==
X-Received: by 2002:a05:690c:6993:b0:786:4ed4:24f0 with SMTP id 00721157ae682-790b56bed3cmr132105627b3.5.1768083168310;
        Sat, 10 Jan 2026 14:12:48 -0800 (PST)
Received: from newman.cs.purdue.edu ([128.10.127.250])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-790aa57ceb5sm54625467b3.17.2026.01.10.14.12.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jan 2026 14:12:47 -0800 (PST)
From: Jiasheng Jiang <jiashengjiangcool@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fnnas.com>
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>
Subject: [PATCH] md: fix hang in stop_sync_thread by setting THREAD_WAKEUP in md_wakeup_thread_directly
Date: Sat, 10 Jan 2026 22:12:44 +0000
Message-Id: <20260110221244.14304-1-jiashengjiangcool@gmail.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Analysis of md.c shows that the md_thread() loop relies on the
THREAD_WAKEUP bit being set to progress beyond wait_event(). However,
md_wakeup_thread_directly() currently only calls wake_up_process()
without setting this bit.

As a result, a thread woken by md_wakeup_thread_directly() will find the
wait condition remains False and immediately return to sleep without
executing its run() handler. In the case of stop_sync_thread(), this
causes the sync thread to ignore the interruption request, leading to
a permanent hang.

Fix this by ensuring the THREAD_WAKEUP bit is set before waking the
process in md_wakeup_thread_directly().

Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
---
 drivers/md/md.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 6d73f6e196a9..8709e9fd7f39 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8512,8 +8512,10 @@ static void md_wakeup_thread_directly(struct md_thread __rcu **thread)
 
 	rcu_read_lock();
 	t = rcu_dereference(*thread);
-	if (t)
+	if (t) {
+		set_bit(THREAD_WAKEUP, &t->flags);
 		wake_up_process(t->tsk);
+	}
 	rcu_read_unlock();
 }
 
-- 
2.25.1

