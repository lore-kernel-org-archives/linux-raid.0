Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33FB4343F0
	for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 13:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783689835; cv=none; b=FgCIadPnErqIzojTERS7YG+yRpiDU4rxH30OeR1Jp83uyuuXhDT2V3UYNvn+FRN4UtCZwYzTg0AiO9LH4Phjt8roeU1dcruebPMBEYTaJvuexh5WRhbxehtFi1GPu4dDnV5WoRbYj/l6Q5pzdTyqdgX0rQHUq/BUbgSS1qhY9O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783689835; c=relaxed/simple;
	bh=ZndRfsnRmqzSe7rhtoSSH2gGlcNsbG0KwjxVe27cd+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R4uWvVa3ZdR173CNqSN7SNvWiZSorph/Bo9w4R7J7ma868HYL02t5Qh68i03siGPp3AuxfUMjWEG4GARf6BAt7yVvBRA/SiEEzhIj/OVw/41EeYQgEbMBvDnO9OF32GCfMowSVqOfz1FHuLWpQzkbVGm65F69iXPBB3/u9WIbAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M8rAGRDj; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M8rAGRDj"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-c9b373d5af0so664884a12.2
        for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 06:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783689833; x=1784294633; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=D0ElksLpbjK0RSxLvl8ZmLvXbVJsULt6FVLqz+PRke4=;
        b=M8rAGRDjA8Jq+nn5eYJ4rOpVxI5IRmoZ9DZG0fm6DI8zOpLl+khKlAyMwKbDDq/tub
         uWx3g3K1Owfnb9hyYbBYVODClyxVkeRyfZAYmKfpPPsO6FCB+yU/eFETcaVhWzt0tACT
         bXyOsSstVPQNw1qboqfpwbbd3/+uPqlwgIlQIxahA2nxDX1tK+ExYrtLL8A4yJDeMl9S
         hQiAQIztoS3817K49m3QkevsgfZGOD88jf+RSAWcDZ/k9X8NVcELhiL/mGZ+sbjwD/qv
         QpAUvkwHB8J/xCwCeq2938laVeBVtjAN/kr40lnycNfHb9hvOqWYDPiOX80o4eWJ0+OB
         5J4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783689833; x=1784294633;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=D0ElksLpbjK0RSxLvl8ZmLvXbVJsULt6FVLqz+PRke4=;
        b=E/zvjxo5xOvwTb/EiKjojepr4FtUZVUWs9/v4acsoiXOkLkdbEaqv/dNRmVb3uqU+1
         e0XBc/HpxQnEnjHnB8JTmqFKcUfvRATlVas/HR8F7ouZWgrDrSbKDB5nlo/8V8a1sswT
         c/awcY87hAlD+RPEzLEe7imEhMRTy1Ah2ucqsDDdvYqVwKoNEK/KztlstbemfYsszajz
         9XGhwWMssKGkr4HPzeWOVO9Wutj4lAuAC4uBZK9CjRdvL6y1fKIAjmfaH9rbwS4ZNM70
         tjtpf7POVHbIYrHp08+0Ki7OVSCkD8tinHl8xpQspEL5SG8hG9ezFR/y25WvH2taISKr
         UUBg==
X-Forwarded-Encrypted: i=1; AHgh+RqRHSWduRFd8DB4MbsXhn+gOu3aycS3mGo5dIi0k5lhEujXeatlPUGIfPYNMzqWFSfWqiATyRPAbAIo@vger.kernel.org
X-Gm-Message-State: AOJu0YyYfSyllkQH51XZXU7ZyLlF6ztMt0jy7CurwOzy7d4S/9BFG/wJ
	GO011Twe+imaarOwya4IZ4zN8t6KW+zLWqZQHvlw8wV2LQRjXxuF0VoR
X-Gm-Gg: AfdE7ckFBostMLblVetWBXjvqTjukEhCNkxoinjjfUWR8s95Pl8/nX8yKzbwTLYIe2u
	nY2t1M4s6NmvsiJhOrKoAevm/I6q+QYl7JQ3E2z0dCrhLMyjcHF+BMzkOQGHDD5oV+vWsfEtjUl
	zAliviS66qgGvomWlHyUXMtXBVRCUI39EY0Q44tDeDe0g3wLmqo9x8ahDRxQKXxtHQdQ69Ar9yE
	A5bftJq6Zjr9eBRsaI+9tyGfqVtbnU2QwOj9A796yXR6SyNwi04DUmy4S1uwiTUy3SphJbT310f
	mRNWF0RtRyWgk3ffXQAn55AN25OJiHNevozqtLXBGBqSpxgu79b7/Bm5eImdufdBRexqfv3IbCZ
	b8tHgcPBYYlm4nnEcq+hz53Xgmqk0XzcQKkj3hrISphmkG3jCFOcojigsWBDFisg8WvTcn74PZJ
	5K9XMyftAPePcUYu7yb6y5gMpk/cALD08dpN5Wz61ARnnCqyUp/CPNystR92R/C4qbuPuv0YGoy
	xV9yfWzLfqW5JIZeQ==
X-Received: by 2002:a05:6a21:8886:b0:3c1:85d:fa2f with SMTP id adf61e73a8af0-3c1085e033bmr588780637.36.1783689833149;
        Fri, 10 Jul 2026 06:23:53 -0700 (PDT)
Received: from research02.. ([2601:1c1:8700:f5b:fe34:97ff:fea3:c147])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ca5b3b251eesm4903776a12.31.2026.07.10.06.23.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 06:23:52 -0700 (PDT)
From: Hiroshi Nishida <nishidafmly@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hiroshi Nishida <nishidafmly@gmail.com>
Subject: [PATCH 6/6] md/raid5: derive the default group_thread_cnt from the hardware
Date: Fri, 10 Jul 2026 06:23:46 -0700
Message-ID: <20260710132346.7295-7-nishidafmly@gmail.com>
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

setup_conf() starts every array with worker_cnt_per_group = 0, i.e. a
single raid5d thread and no worker groups.  On a many-core host backing a
fast, wide array that single thread is the bottleneck; the multi-threading
that group_thread_cnt enables has to be turned on by hand, per array,
after every assembly.

Pick a starting value from the CPU count instead.  When the new
group_thread_cnt_default module parameter is left at -1 (the default),
raid5_default_group_thread_cnt() uses half the online CPU count spread
across the NUMA nodes, capped at 256:

	gtc = num_online_cpus() / (2 * nr_nodes)

The count is per NUMA node, matching alloc_thread_groups(), so dividing by
the node count keeps the total near half the CPUs regardless of socket
count.  It is only a ceiling: raid5_wakeup_stripe_thread() wakes workers
in proportion to the queued stripe count, so a lightly loaded array uses
far fewer than the maximum.  A lone worker is not worth its overhead over
raid5d, so a result of 1 collapses back to 0, which keeps boxes with two
or fewer CPUs single-threaded.

Measured on a 16-disk raid6 array of NVMe SSDs (a 32-vCPU host: 16 cores,
two NUMA nodes; steady state, interleaved runs): the derived count of 8
raises throughput 2.1-3.2x over the single-threaded default -- 4K random
write from ~39k to ~100k IOPS (2.6x), mixed database/OLTP/high-concurrency
2.1-2.5x, partial stripe write 3.2x.  There is no regression on smaller
machines: a 4-CPU box gets 2 workers and is faster or equal on every
workload, and a box with two or fewer CPUs gets 0 and is byte-for-byte
unchanged.

group_thread_cnt_default overrides the heuristic (0 forces the historical
single-threaded behaviour; a positive value pins a count, capped at 256),
and the existing per-array group_thread_cnt sysfs attribute continues to
override it at runtime and still accepts up to its own 8192 limit.

Signed-off-by: Hiroshi Nishida <nishidafmly@gmail.com>
---
 drivers/md/raid5.c | 45 ++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 42 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 8e1c2eba4241..6e91eb0ad575 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -88,6 +88,11 @@ module_param(stripe_cache_size_default, uint, 0644);
 MODULE_PARM_DESC(stripe_cache_size_default,
 		 "Initial stripe_cache_size for newly created arrays.  0 (the default) auto-sizes it from system memory: the historical 256 on small hosts, scaling up with RAM to a capped maximum on larger ones.  A non-zero value sets a fixed initial size.  Existing arrays are unaffected");
 
+static int group_thread_cnt_default = -1;
+module_param(group_thread_cnt_default, int, 0644);
+MODULE_PARM_DESC(group_thread_cnt_default,
+		 "Initial group_thread_cnt (raid5 worker threads per NUMA node) for newly created arrays.  A negative value (the default, -1) auto-sizes it from the CPU count; 0 forces the single-threaded raid5d; a positive value sets a fixed count (capped at 256).  The per-array group_thread_cnt sysfs attribute overrides this and allows larger values");
+
 static bool devices_handle_discard_safely = false;
 module_param(devices_handle_discard_safely, bool, 0644);
 MODULE_PARM_DESC(devices_handle_discard_safely,
@@ -7584,6 +7589,31 @@ static unsigned long raid5_cache_count(struct shrinker *shrink,
 #define RAID5_CACHE_DEFAULT_RAM_SHIFT	9	/* above it: ~1/512 of the extra RAM */
 #define RAID5_CACHE_DEFAULT_MAX		4096
 
+/*
+ * Default group_thread_cnt (worker_cnt_per_group) for a new array when the
+ * group_thread_cnt_default module parameter is left at -1.  The historical
+ * default is 0 -- a single raid5d thread -- which cannot keep a fast, wide
+ * array busy on a many-core host.  Derive a starting point from the CPU
+ * count: half the online CPUs divided across the NUMA nodes (this is a
+ * per-node count -- see alloc_thread_groups() -- so the total lands near
+ * half the online CPUs regardless of socket count), capped at
+ * RAID5_AUTO_GROUP_THREAD_MAX.  This is only a ceiling:
+ * raid5_wakeup_stripe_thread() wakes workers in proportion to the queued
+ * stripe count, so a lightly loaded array uses far fewer.  A lone worker is
+ * not worth its overhead, so 1 collapses back to 0.  The group_thread_cnt
+ * sysfs attribute overrides this per array.
+ */
+#define RAID5_AUTO_GROUP_THREAD_MAX	256
+
+static int raid5_default_group_thread_cnt(void)
+{
+	unsigned int gtc = num_online_cpus() / (2 * num_possible_nodes());
+
+	if (gtc > RAID5_AUTO_GROUP_THREAD_MAX)
+		gtc = RAID5_AUTO_GROUP_THREAD_MAX;
+	return gtc == 1 ? 0 : gtc;
+}
+
 static struct r5conf *setup_conf(struct mddev *mddev)
 {
 	struct r5conf *conf;
@@ -7594,6 +7624,7 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	int i;
 	int group_cnt;
 	struct r5worker_group *new_group;
+	int def_threads;
 	int ret = -ENOMEM;
 
 	if (mddev->new_level != 5
@@ -7677,10 +7708,18 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 		goto abort;
 	for (i = 0; i < PENDING_IO_MAX; i++)
 		list_add(&conf->pending_data[i].sibling, &conf->free_list);
-	/* Don't enable multi-threading by default*/
-	if (!alloc_thread_groups(conf, 0, &group_cnt, &new_group)) {
+	/*
+	 * Multi-threading defaults to a hardware-derived worker count (see
+	 * raid5_default_group_thread_cnt()); group_thread_cnt_default overrides
+	 * the choice, and the group_thread_cnt sysfs attribute overrides it per
+	 * array.
+	 */
+	def_threads = group_thread_cnt_default < 0 ?
+		raid5_default_group_thread_cnt() :
+		min(group_thread_cnt_default, RAID5_AUTO_GROUP_THREAD_MAX);
+	if (!alloc_thread_groups(conf, def_threads, &group_cnt, &new_group)) {
 		conf->group_cnt = group_cnt;
-		conf->worker_cnt_per_group = 0;
+		conf->worker_cnt_per_group = def_threads;
 		conf->worker_groups = new_group;
 	} else
 		goto abort;
-- 
2.43.0

