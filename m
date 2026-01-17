Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A592D135A53
	for <linux-raid@vger.kernel.org>; Sat, 17 Jan 2026 14:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768661949; cv=none; b=OP7TP16iVTXKdF0ppkC7ITYiPIgPYNYwU6EJJZfNSYstdpQdtgMpNfGbYdtnwkHldn1bk9oeAgLo3vHFTThM2cqcW3HcBQ75PVB2cEXRbIObOpT17MXF7jBJhhFCKTbL/zt2fXbLKdUQFpoiZUH74sKSYvf63ajhxWhtqTepAdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768661949; c=relaxed/simple;
	bh=459p210J4aQCYigFalX9YNTCl0j0NX+/OLg7/eWEJa8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=NpVPbsJXqDjvF5EvlEV0DyEzeZUm1ToOsDJaC3/954mrRjZRiZMRIqCaRp9Xrwsjs1IK9X5EpBtllv2zEBhQDkFF8jyJw4bBIIV+XnI1iiMXd6AQS65ZUpqrCPuP8ykZihY8PlxVVvHBX3mzOCJ8Zdqv7tFJnb4eMtYfFQxXD0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LyenK8MX; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LyenK8MX"
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7cfdd3146deso1027409a34.2
        for <linux-raid@vger.kernel.org>; Sat, 17 Jan 2026 06:59:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768661946; x=1769266746; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cF4yfTjPc+MtM3VwJFaxbAtKNPAKsPIGtwcLomm3o6M=;
        b=LyenK8MX8Ov0PIt+LdU8SOFW4q2kE0CazU+DflbInrL4fTCFFu8ABIK2U/sNaF/8AX
         lufnYOaC5AV9coa0vF/sVUyg/N33UNztNYxsX0SMab937I7tTJfh1cZqzb10yotlsYTR
         YbsxQeZSQYhIynnjib8k/d1i+zA7vJwDBgTfTI3whrCfBRvx1J3BiQ0AerQZGLsp1tK9
         JCVhfmdXls2XrYu0w+ronsSfDAvmIMFRWkCfE5Lb0xmzeorwa/wwmNqSbiwR2Q1xW7r9
         JNyx4iPbWJwcNEs0LtyBmD8lA1Ej2crrPgDBDT+utPz2GKa07G9o5wBSFMoaikbvw06b
         +xmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768661946; x=1769266746;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cF4yfTjPc+MtM3VwJFaxbAtKNPAKsPIGtwcLomm3o6M=;
        b=gDGIg5oE/O08FaOYvz55N2FhjBrN6ZdjEBWR1VpQxa1dMY4C3z5ALTmhDR6iDPXlLq
         WdRVU6dWlybLuimto0Ggaat0iokn8AQIusXdeb5xyEOVMasaR/ie2aRrvb7r5c+c0YEC
         TpQHicqzohD3JOESU0GHHXEX2fwOs2uaR8KQNy/Xst015etMhHhj0jOxmO8kfyHlbwBT
         B26JJ1zdTYq5CVQKRtTv7ccpm9JLFjDouttNcf7A3fIelhmyDQ5Ia2IG8+O6yHU10ill
         9D1YGQMWjyHSnzzuaVnaHQ2Gae5ejbbyhjUjFWXWfPlFuUeJZWgxZuKciWA27NGbQRKa
         iU3g==
X-Forwarded-Encrypted: i=1; AJvYcCXmeAxWzBZHkgwdF/mifd/EYwFCbJOKg4efHUIbA8v4kdVqnMKbpapB5enV377t6XqsMCvTo0iNnOT+@vger.kernel.org
X-Gm-Message-State: AOJu0Yzq/UuqpWZI2GuuyiiTiD4kCftYCPUellf/ONVutDYt4nA5Tydw
	82DT/YHl+Yn3nOexHUIJu0kfbmrkQkiIyOueAXfIAAYIC49t68g3nQHh
X-Gm-Gg: AY/fxX7kquHoNRy5g/8blmvmkAqBAJWNSFuWl/YUC8q3bVPKl7uHzrkfM4wEStoM0YT
	aHsdIdyUKf+DMyGJEqVmTOTi4mnEmBRMew+zVBOWyT1zvpe8uZH0H8jLXLOqPDdy0pXKd4tkD9r
	NVi8hL40RYtChcW8CHqwxPmbn3kEQ6pEUVHg6QohHWGYSWt9oIPwoKciNGbvv0aHqkWIENh5YeV
	wpj6aiA6cdDI3NEX5m4FpeN/BfZ6fxkWpqMZjDAodq1RHKFoK1tL9jK5mhbUzTSicprU42OlT6J
	dglXL+/R+vkEr6OZ3rBcsLQJ1TCLWo3knDPN/jmqVRZguaa4iR5BIx9+XIbqc8MvS3aQqQBGQNT
	Pq08uBN1NDU8rFGiCQqAPg/zxcmPCOTzEtclpHKkALxZ60u7CHlfmsluTfbN6JRm5c2mCha+Lu0
	1nDe1HepkYAkx9po+WXnpXwLnfiGUN4aXR
X-Received: by 2002:a05:6830:f85:b0:7cf:d191:2a50 with SMTP id 46e09a7af769-7cfded8025cmr2506518a34.13.1768661946516;
        Sat, 17 Jan 2026 06:59:06 -0800 (PST)
Received: from newman.cs.purdue.edu ([128.10.127.250])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cfdf0d915dsm3483630a34.4.2026.01.17.06.59.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jan 2026 06:59:06 -0800 (PST)
From: Jiasheng Jiang <jiashengjiangcool@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fnnas.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Subject: [PATCH] md-cluster: fix NULL pointer dereference in process_metadata_update
Date: Sat, 17 Jan 2026 14:59:03 +0000
Message-Id: <20260117145903.28921-1-jiashengjiangcool@gmail.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The function process_metadata_update() blindly dereferences the 'thread'
pointer (acquired via rcu_dereference_protected) within the wait_event()
macro.

While the code comment states "daemon thread must exist", there is a valid
race condition window during the MD array startup sequence (md_run):

1. bitmap_load() is called, which invokes md_cluster_ops->join().
2. join() starts the "cluster_recv" thread (recv_daemon).
3. At this point, recv_daemon is active and processing messages.
4. However, mddev->thread (the main MD thread) is not initialized until
   later in md_run().

If a METADATA_UPDATED message is received from a remote node during this
specific window, process_metadata_update() will be called while
mddev->thread is still NULL, leading to a kernel panic.

To fix this, we must validate the 'thread' pointer. If it is NULL, we
release the held lock (no_new_dev_lockres) and return early, safely
ignoring the update request as the array is not yet fully ready to
process it.

Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
---
 drivers/md/md-cluster.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 11f1e91d387d..896279988dfd 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -549,8 +549,13 @@ static void process_metadata_update(struct mddev *mddev, struct cluster_msg *msg
 
 	dlm_lock_sync(cinfo->no_new_dev_lockres, DLM_LOCK_CR);
 
-	/* daemaon thread must exist */
 	thread = rcu_dereference_protected(mddev->thread, true);
+	if (!thread) {
+		pr_warn("md-cluster: Received metadata update but MD thread is not ready\n");
+		dlm_unlock_sync(cinfo->no_new_dev_lockres);
+		return;
+	}
+
 	wait_event(thread->wqueue,
 		   (got_lock = mddev_trylock(mddev)) ||
 		    test_bit(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD, &cinfo->state));
-- 
2.25.1

