Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AECA63DB33F
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 15:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782316514; cv=none; b=BSYqtF7gvEURO3wUvtUAEe3svuRzN2g/PZW7ylh+W7qjP2Ac5A2e/K3inbbYOXfICXrcuH1COXw9UZsaD2FOvkJ7NVqtd8AQm0INghxVLwoYM6FeWXYrKEBloVRv60NjgUKOsiHAz/U+SURRTanOkaAe6Vw43M00hQUY1Xv9ywU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782316514; c=relaxed/simple;
	bh=hfJn1ISxxkWed1Bhw5vwAzM8EpgX7J3WTRzBfqglt4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KlWqZb7u7QAPEe/eO18MlfEtugvWbLvlakMiseojRMJTQalHGuY/vH/jLT5/w0m2qdlHGMgwkQB71O7mmK9xDdEYmQLqIJlhjTJsb1xa9sDN3iBmN4saNARR999p/jKDCwZzWmrRwELqidCuvd62JCjl9B0R7CbyTBDdTTZaYBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lf3YRK0O; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lf3YRK0O"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-84540eb70b2so815914b3a.2
        for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 08:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782316513; x=1782921313; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NYrbDXhmHxewEsyT65dV8hLwUaKhxclM3ZQCq1ly56Q=;
        b=Lf3YRK0O9TH4BZMv4VPv0NNzC/pQmi+YsexK59k1Al67csM12BsRkW9zn2gM/Mk+i8
         CBaR+MmkxH4FjNL6v5lxPaFaAIc8vWBuli6rgXpHVR+PpSGq/7T+j3q49UOd8ikK60E1
         lK2OQwKzk0GCtrk1p1srlwU8lT/uqkorWiP2JtCiw9g21YrotKXcuLOrXZ81/McETotC
         BrkJ8xX7xebvzllARQFMg8EZY9v5hcIFBpq2Tgd9V1TO8EdSJCM0MgEOoE/tDzsZx33h
         TneV5VJBDm5e8JiARJ0tLh9/RsAiywuyYGLtP/bUDMcBNBE6sXVXgZpIoHqLoCUfDgsR
         eSOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782316513; x=1782921313;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NYrbDXhmHxewEsyT65dV8hLwUaKhxclM3ZQCq1ly56Q=;
        b=IcuyNrtWHT+BgZxnv/aUXHbflNwGzjBa+zzBNe1QKJ1ZEE00I9AvIKnKow3nAz/0SY
         ZrAnQZPLl86s5QMTyOitGxB8r2Eyu5rxjY7wV7CFDh7zKiIT3c4YaUx+ru9GMgCkXswm
         PdxdAuTA4pdwR03PDZZN1n8DI9QJPkAemq/T8XbspxrfxaUkCJMcBQC8ZiiZSMebFsqD
         phgNC8jytz5QghoAWlKtO0ZHkPI4wd90GXgAczqucCJXac7eEaus/yOMv+4XvhzJK3n+
         HrWapG5kcEhsKyq/lFqGyODEsnvH6aBcKwaXpNr1P8Lgn5a71AOgH1pLip1RImfCj8EY
         mvXw==
X-Forwarded-Encrypted: i=1; AFNElJ9UdEsXspol3nDjPxddDECyDw87BZCUzNyYnyNpL6w3q1Gu1zKkkfmICqqJmydK491fk5Pfui7uAzd+@vger.kernel.org
X-Gm-Message-State: AOJu0YxoEheEfgY0JmeZTXlDoBOD4Xte3ZagOYZb2GLrRPmGArT2GYHw
	mfGrSKBZZxj2MWaKTcIWB/XloXG8Bqo+EW4TNyLqX3gZrgu8EDS8HyaR
X-Gm-Gg: AfdE7ckOtUayu4TtdWC1H0udiUsEDND5zioTzfcsYd77WGH5jq5anyzos2+SVcZnwJi
	ZnrtznU89F+XroKACsU+hsHd5d34tGXtQM/1gjxMTkwXBRFJwvfC9kZUrSD09MexfSrYhyF7+V6
	geg1QKLKFm0GATc/MKGxTce/hOz5RSkVgdond059j+2vzG6R4OIu3W5cyTwu9irc8Trc/kAZaCO
	+aGtNjjdXbwhIOhd++O//UVFotOdROaC4AzkQQsInQQz+mnLz7e4buY2HjsmmyGMcCNZs8sdmuJ
	ZA0TuYztAsmzmyKvBB8svcJpQBgF0g7jzBn9Ubc7jq7njS5by3ODVuPmPc3hIuuCjaRsbxiWCy+
	e2Kuu2Ob7YaRe9mJ/tcnGH1oi6OKRwK8gt1pL/1kRElaxtXMOZx/bYkVVZdgJspPCGESG/bkgjM
	kmVJq+AF62JIsGZtvEx1Ftx1ZabSqYSWc3jn32As6dIhbQHUix1guVCbLed7dCLCEuG/uW61ZpU
	YVkDLM=
X-Received: by 2002:a05:6a00:2d07:b0:845:39dd:f773 with SMTP id d2e1a72fcca58-845624575famr26310124b3a.7.1782316513064;
        Wed, 24 Jun 2026 08:55:13 -0700 (PDT)
Received: from research02.. ([2601:1c1:8700:f5b:fe34:97ff:fea3:c147])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-845a40f55cesm2658387b3a.44.2026.06.24.08.55.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 08:55:12 -0700 (PDT)
From: Hiroshi Nishida <nishidafmly@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hiroshi Nishida <nishidafmly@gmail.com>
Subject: [PATCH 6/8] md/raid5: allocate worker groups per NUMA node
Date: Wed, 24 Jun 2026 08:54:50 -0700
Message-ID: <20260624155452.211646-7-nishidafmly@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260624155452.211646-1-nishidafmly@gmail.com>
References: <20260624155452.211646-1-nishidafmly@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

alloc_thread_groups() previously allocated all r5worker arrays in a
single kcalloc() block, assigning workers for NUMA node N from node 0
memory.  On multi-socket systems this causes remote memory traffic on
every worker->work and worker->temp_inactive_list access.

Replace the single allocation with kzalloc_node(size, GFP_NOIO, i) per
group so each node's workers live in local memory.  Because the workers
are now separate per-node allocations, both free sites --
free_thread_groups() and the reallocation path in
raid5_store_group_thread_cnt() -- are updated to free each group's
allocation individually instead of only group 0's.

Also fix a latent bug: the original kcalloc() had its nmemb and size
arguments swapped (harmless due to commutativity but semantically wrong).

Assisted-by: Claude:claude-opus-4-8 [Claude Code]
Signed-off-by: Hiroshi Nishida <nishidafmly@gmail.com>
---
 drivers/md/raid5.c | 39 ++++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 8e9edaaca667..c8787ab7b309 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7297,8 +7297,12 @@ raid5_store_group_thread_cnt(struct mddev *mddev, const char *page, size_t len)
 			conf->worker_groups = new_groups;
 			spin_unlock_irq(&conf->device_lock);
 
-			if (old_groups)
-				kfree(old_groups[0].workers);
+			if (old_groups) {
+				int node;
+
+				for (node = 0; node < num_possible_nodes(); node++)
+					kfree(old_groups[node].workers);
+			}
 			kfree(old_groups);
 		}
 	}
@@ -7336,7 +7340,6 @@ static int alloc_thread_groups(struct r5conf *conf, int cnt, int *group_cnt,
 {
 	int i, j, k;
 	ssize_t size;
-	struct r5worker *workers;
 
 	if (cnt == 0) {
 		*group_cnt = 0;
@@ -7344,24 +7347,24 @@ static int alloc_thread_groups(struct r5conf *conf, int cnt, int *group_cnt,
 		return 0;
 	}
 	*group_cnt = num_possible_nodes();
-	size = sizeof(struct r5worker) * cnt;
-	workers = kcalloc(size, *group_cnt, GFP_NOIO);
 	*worker_groups = kzalloc_objs(struct r5worker_group, *group_cnt,
 				      GFP_NOIO);
-	if (!*worker_groups || !workers) {
-		kfree(workers);
-		kfree(*worker_groups);
+	if (!*worker_groups)
 		return -ENOMEM;
-	}
 
+	size = sizeof(struct r5worker) * cnt;
 	for (i = 0; i < *group_cnt; i++) {
-		struct r5worker_group *group;
+		struct r5worker_group *group = &(*worker_groups)[i];
+		struct r5worker *workers;
+
+		workers = kzalloc_node(size, GFP_NOIO, i);
+		if (!workers)
+			goto out_free;
 
-		group = &(*worker_groups)[i];
 		INIT_LIST_HEAD(&group->handle_list);
 		INIT_LIST_HEAD(&group->loprio_list);
 		group->conf = conf;
-		group->workers = workers + i * cnt;
+		group->workers = workers;
 
 		for (j = 0; j < cnt; j++) {
 			struct r5worker *worker = group->workers + j;
@@ -7374,12 +7377,22 @@ static int alloc_thread_groups(struct r5conf *conf, int cnt, int *group_cnt,
 	}
 
 	return 0;
+
+out_free:
+	while (--i >= 0)
+		kfree((*worker_groups)[i].workers);
+	kfree(*worker_groups);
+	*worker_groups = NULL;
+	return -ENOMEM;
 }
 
 static void free_thread_groups(struct r5conf *conf)
 {
+	int i;
+
 	if (conf->worker_groups)
-		kfree(conf->worker_groups[0].workers);
+		for (i = 0; i < conf->group_cnt; i++)
+			kfree(conf->worker_groups[i].workers);
 	kfree(conf->worker_groups);
 	conf->worker_groups = NULL;
 }
-- 
2.43.0

