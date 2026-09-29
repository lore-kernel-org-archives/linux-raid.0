Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB0937AA9E
	for <linux-raid@vger.kernel.org>; Tue, 29 Sep 2026 17:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790703467; cv=none; b=tQra+pQn4kLfsgvK3Sn9n3rPJ7qTZi0gSQxUS5fB0jbbYdELfChlmTrPRUUcaeSKt6jlsWqlhr/kQWqd2n7Hj09k4zmqsUSXFNAhU+F3ZmzCOnFVkkQAtYtYB1MSHyACaQ5k6+S34VFp0ZvTcDqUZg4QolN9ou6uc83oOCwj+J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790703467; c=relaxed/simple;
	bh=Es9Wca+ZedB+v25stBceYW/frw4xKmP1t8d14gSpwsI=;
	h=From:To:Cc:Date:Message-ID:Subject:MIME-Version:Content-Type; b=FbglC+67zWhWwulz37hrmjWjUqqsfPAS3BPYp3J9Kpb58OSKNG9KjAR5w6qEnjHVLvW2fmadEvfEQIFqt94PFv49vHmhbV3Hq+9Dcg3J2cikrgeP6bHkbyMQTt0AeUjm6ORJkkmtiYowj6XhSyD6bAyrkpYNOrtVlzoIgingO28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QEUUQ+sm; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QEUUQ+sm"
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-39b2ad83dc6so3018028a91.0
        for <linux-raid@vger.kernel.org>; Tue, 29 Sep 2026 10:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790703465; x=1791308265; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:subject
         :message-id:date:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=FwqOy5VOz4fFRTTw3dDv1QbNi/x6bhVtKBvn3kfikfQ=;
        b=QEUUQ+sm7a+RodA4vCfLkcUiMZqGqDhhq5E7x67q9C6bVvTTlzngUvS5ZcJ/ffxo+R
         rB9ukRkMNBtIR2jGmYKc260zfUj3C3GF55Mj2hjbXLGB2BppA3QohYRHgt/5HydsKxyw
         0rPd0g5zZkgsXnPlMqWJ+Ub3062y9jM8flSJJf+qGphYUbanMVp7IhK6dyMhDGFeLu4d
         k1YK+XGKwmnwjnY4QZxJJK6W1lI8SKigSOssBLnqLrS2mgL4NlJlaC7MQp2KMyzYsvFv
         mMjJxf2qEVpFNxg0QzXSmdPj+CNlUvUHA1gN48KfIky+jS4ADtMcJ3ckPK/aktzEjZae
         GgoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790703465; x=1791308265;
        h=content-transfer-encoding:content-type:mime-version:subject
         :message-id:date:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=FwqOy5VOz4fFRTTw3dDv1QbNi/x6bhVtKBvn3kfikfQ=;
        b=gDB34z1/STTqPuZ681Iq6G84V1ZZ1c9Jb0Qb6fekrPWvKB0lxPcueLDRtyASb9KJDn
         xyUGQMuHUJC0mAo5xIPZnUkgGk/ocDjJ8FQZmMp12SKHE5VJb/hfoWomQaZNYKeGArgM
         QIC1bB/AuJ2gFuRzfPHGZGpFRMM3c0TLzPgao6EsFW4GXgZxRbSJQ018xLmiX5L5nSxV
         Y9xeSHjWBFkRAkkuAsVuZ1dNufMl3G2IuWNlWrwNSI7jIdWuYJQV7dMoQMyLoX/Bv7tX
         rC2dNfpV+chpo6NW93ASxTmid0KhAL5/s1Xz2GFgBBQrdl1vftBR4cHqGDOBXPoCvxl+
         FrkA==
X-Gm-Message-State: AFq9FYISWykuDM3M1QQkMLeeg6DUtVDBZOh7oHG6CR/SmXkw68oFdlsn
	5GwVhQmj/UhrZoGTFaLnG874a0vq9xGcelrf6WeAf72tWiugaj5hLsM4
X-Gm-Gg: AYBFou3jxlVVcDj29hvAYwd5xCGhcL0ap0TuAHEacxfF9SuMnN6cUKZhb1S6YN1V4aE
	vtGVcvq0V1Y5MPPuvWA/PeJ27Vq6aCQaX9zB6RpURjOx+Z7n4XGuSfsGe2HIgzDW25FgZ3VsgvJ
	+Zu0sI8ypO53MzWTfC7K5/xdhdz2O9PonDgfBm8oTEqxsQv7T4TNSSzpclGsAE4y11o8DW3koO4
	9LFmyCBQDdi1LOz1nAC/K+mnwu9ouhURP3GaVaXscpP9UZnSQZEdX01PTFpBcNxQ9Ag2e8rtkJp
	axIFPBI4CqPpQgK53CDakls9QjoUiYp6hFhKtXIGrpQX93LcDT2qtPn88ma4QpVOeH2Nnx6CIt0
	qdlge+O2i8rlJbKak957+3HBWmduIc3Fjro6a0YQBpF63fpvcsjtQE6f5yqtuJ5JGn+P6V4mhXP
	tDdXymzYVt1MnQYOXmFpryLeNmjXL9a3oA2ATfCc8DpW+ZhRGhsyfcZp4N1vATCxesoSz3dpZzM
	2AmGd+yaFqf5sUHqA7v2X4=
X-Received: by 2002:a17:90b:5306:b0:39e:6c68:c77d with SMTP id 98e67ed59e1d1-3a4bfea37a7mr95959a91.51.1790703465342;
        Tue, 29 Sep 2026 10:37:45 -0700 (PDT)
Received: from SANGHOON. ([1.220.132.212])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a4bf19bf4asm124187a91.2.2026.09.29.10.37.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 10:37:44 -0700 (PDT)
From: Sang-Hoon Choi <csh0052@gmail.com>
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fygo.io>
Cc: linux-raid@vger.kernel.org, Changyul Lee <lcy8047@gmail.com>
Date: Wed, 30 Sep 2026 02:37:38 +0900
Message-ID: <179070265341.12871.12495446593114993799.idr-bug-88@gmail.com>
Subject: [PATCH] md/raid5: protect big_stripe_tree lookup with RCU
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

big_stripe_tree is updated under tree_lock, and deleted radix-tree
nodes are freed after an RCU grace period.  r5c_big_stripe_cached()
used to run under an RCU read-side critical section, but that protection
was removed together with unrelated rdev lookup protection.

The lookup can now be preempted while walking the tree, allowing a
concurrent deletion and grace period to complete before the walk
resumes.  Protect the lookup locally with rcu_read_lock().  Only the
presence of the entry is used after unlocking.

Fixes: ad8606702f26 ("md/raid5: remove rcu protection to access rdev from conf")
Reported-by: Changyul Lee <lcy8047@gmail.com>
Assisted-by: LLM
Signed-off-by: Sang-Hoon Choi <csh0052@gmail.com>
---
Compile-tested with x86_64 allmodconfig and W=1.
I have not reproduced the race under RAID5 I/O.

 drivers/md/raid5-cache.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 7b7546bfa21fb0c4be62ac94ecf8c6da72b2edb3..ec819d56c612e2511738bf126e640511fff76050 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -2952,7 +2952,9 @@ bool r5c_big_stripe_cached(struct r5conf *conf, sector_t sect)
 		return false;
 
 	tree_index = r5c_tree_index(conf, sect);
+	rcu_read_lock();
 	slot = radix_tree_lookup(&log->big_stripe_tree, tree_index);
+	rcu_read_unlock();
 	return slot != NULL;
 }
 
-- 
2.43.0
