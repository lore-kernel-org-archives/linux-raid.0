Received: from va-2-29.ptr.blmpb.com (va-2-29.ptr.blmpb.com [209.127.231.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E55C37EFF1
	for <linux-raid@vger.kernel.org>; Wed, 22 Apr 2026 02:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776825236; cv=none; b=iQlgztzwCOlp0a7NGqgf4HH00Tptlhqx6kfrmXPvMjG0mb+OB7+mQtuSMWqhdltUFiY5CQ9fpOECe2Bq1ICZGaLWXgjBlrNW3MT2erTzobCDjU8db8/1MRvXrSYnHiBXSulyb7AQ1xZjAEj84jHcvKIZINfhRDznKOIjwgi2USg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776825236; c=relaxed/simple;
	bh=X7AYA+Wnjna0zNzfopfpW8NnYvvD+L3omH56Fz0WWuI=;
	h=Message-Id:References:In-Reply-To:Cc:From:Mime-Version:To:Subject:
	 Date:Content-Type; b=inb+5fhVJ9Z1ovXenxTcBkl0DWCwk1jjUF7iBv9tmcPSmzzG1vs9fcS61cs2piEt4ujAp1QrOISdTFpO1QV07BfbjkU8PyOzaNYUTpb/0VVDGFnUZgTLzDNUayA17fcJTUzvaLw8pyn/uTimeD2KxegNeTXRmj3tXWvJgLO6cE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=sFT4GNjC; arc=none smtp.client-ip=209.127.231.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="sFT4GNjC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1776825213;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=OybY2ptPpSgMjYkxuwLXjdmGFEZg+u5cDVfosbKEHm0=;
 b=sFT4GNjCakiZ9Ie4U/O361p9GxnCAWM7ML2yiXbNAH9ugzy728gnGryDi6Et6cCA1wz4ce
 LFW/GVQADJV+G+yjwjBaoP3zSbRk49OlfIw8v2vhjUdYOHCygPCdVQr9ohnFB5uZ4Ghgh/
 UgEAMO+8AkQ1ShBLwkpaukO4V2hnbm+Cu5ZZvN/MURIFdYdaT8aDkjeOj/zzO2ndV1e9Te
 PbpUj9SXecewPLWuzEMb0g1PxA3TRTLYkn8tOKSyOtujDsvNNJND5Orf+7blORiGrcWC/N
 0q9RoEO8XVqnJ/rmPRNbi60771Zi69Itn+HPOIJu/wujMDzS+PbXHzWgqvamsw==
Message-Id: <20260422023317.796326-2-chencheng@fnnas.com>
References: <20260422023317.796326-1-chencheng@fnnas.com>
In-Reply-To: <20260422023317.796326-1-chencheng@fnnas.com>
X-Original-From: chencheng@fnnas.com
Cc: <chencheng@fnnas.com>, <chenchneg33@gmail.com>
From: "Chen Cheng" <chencheng@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0
Content-Transfer-Encoding: 7bit
Received: from localhost.localdomain ([113.111.140.171]) by smtp.feishu.cn with ESMTPS; Wed, 22 Apr 2026 10:33:30 +0800
To: <linux-raid@vger.kernel.org>, <yukuai@fnnas.com>
Subject: [PATCH 2/4] md/raid10: prepare r10bio allocation width tracking
Date: Wed, 22 Apr 2026 10:33:15 +0800
X-Lms-Return-Path: <lba+269e8337b+d4cdc5+vger.kernel.org+chencheng@fnnas.com>
Content-Type: text/plain; charset=UTF-8

From: Chen Cheng <chencheng@fnnas.com>

Record how many devs[] slots each r10bio was allocated with.

Keep the active r10bio pool in a separate object that carries its width.
This keeps the allocation width separate from the per-request width stored
in used_nr_devs and prepares the pool for replacement during reshape.
---
 drivers/md/raid10.c | 40 +++++++++++++++++++++++++++-------------
 drivers/md/raid10.h |  8 +++++++-
 2 files changed, 34 insertions(+), 14 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index e93933632893..b447903fbdc6 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -103,14 +103,22 @@ static inline struct r10bio *get_resync_r10bio(struct bio *bio)
 	return get_resync_pages(bio)->raid_bio;
 }
 
-static void * r10bio_pool_alloc(gfp_t gfp_flags, void *data)
+static void *r10bio_pool_alloc(gfp_t gfp_flags, void *data)
 {
-	struct r10conf *conf = data;
-	int size = offsetof(struct r10bio, devs[conf->geo.raid_disks]);
+	struct r10bio_pool *pool = data;
+	int size = offsetof(struct r10bio, devs[pool->nr_devs]);
+	struct r10bio *r10_bio = kzalloc(size, gfp_flags);
+
+	if (r10_bio)
+		r10_bio->alloc_nr_devs = pool->nr_devs;
+	return r10_bio;
+}
 
-	/* allocate a r10bio with room for raid_disks entries in the
-	 * bios array */
-	return kzalloc(size, gfp_flags);
+static int init_r10bio_pool(struct r10bio_pool *pool, unsigned int nr_devs)
+{
+	pool->nr_devs = nr_devs;
+	return mempool_init(&pool->pool, NR_RAID_BIOS, r10bio_pool_alloc,
+			    rbio_pool_free, pool);
 }
 
 #define RESYNC_SECTORS (RESYNC_BLOCK_SIZE >> 9)
@@ -137,7 +145,7 @@ static void * r10buf_pool_alloc(gfp_t gfp_flags, void *data)
 	int nalloc, nalloc_rp;
 	struct resync_pages *rps;
 
-	r10_bio = r10bio_pool_alloc(gfp_flags, conf);
+	r10_bio = r10bio_pool_alloc(gfp_flags, conf->r10bio_pool);
 	if (!r10_bio)
 		return NULL;
 
@@ -277,7 +285,7 @@ static void free_r10bio(struct r10bio *r10_bio)
 	struct r10conf *conf = r10_bio->mddev->private;
 
 	put_all_bios(conf, r10_bio);
-	mempool_free(r10_bio, &conf->r10bio_pool);
+	mempool_free(r10_bio, &conf->r10bio_pool->pool);
 }
 
 static void put_buf(struct r10bio *r10_bio)
@@ -1531,7 +1539,7 @@ static void __make_request(struct mddev *mddev, struct bio *bio, int sectors)
 	struct r10conf *conf = mddev->private;
 	struct r10bio *r10_bio;
 
-	r10_bio = mempool_alloc(&conf->r10bio_pool, GFP_NOIO);
+	r10_bio = mempool_alloc(&conf->r10bio_pool->pool, GFP_NOIO);
 
 	r10_bio->master_bio = bio;
 	r10_bio->sectors = sectors;
@@ -1724,7 +1732,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 				(last_stripe_index << geo->chunk_shift);
 
 retry_discard:
-	r10_bio = mempool_alloc(&conf->r10bio_pool, GFP_NOIO);
+	r10_bio = mempool_alloc(&conf->r10bio_pool->pool, GFP_NOIO);
 	r10_bio->mddev = mddev;
 	r10_bio->state = 0;
 	r10_bio->sectors = 0;
@@ -3825,7 +3833,10 @@ static void raid10_free_conf(struct r10conf *conf)
 	if (!conf)
 		return;
 
-	mempool_exit(&conf->r10bio_pool);
+	if (conf->r10bio_pool) {
+		mempool_exit(&conf->r10bio_pool->pool);
+		kfree(conf->r10bio_pool);
+	}
 	kfree(conf->mirrors);
 	kfree(conf->mirrors_old);
 	kfree(conf->mirrors_new);
@@ -3870,10 +3881,13 @@ static struct r10conf *setup_conf(struct mddev *mddev)
 	if (!conf->tmppage)
 		goto out;
 
+	conf->r10bio_pool = kzalloc_obj(struct r10bio_pool);
+	if (!conf->r10bio_pool)
+		goto out;
+
 	conf->geo = geo;
 	conf->copies = copies;
-	err = mempool_init(&conf->r10bio_pool, NR_RAID_BIOS, r10bio_pool_alloc,
-			   rbio_pool_free, conf);
+	err = init_r10bio_pool(conf->r10bio_pool, conf->geo.raid_disks);
 	if (err)
 		goto out;
 
diff --git a/drivers/md/raid10.h b/drivers/md/raid10.h
index 92e8743023e6..8fa4e54c444c 100644
--- a/drivers/md/raid10.h
+++ b/drivers/md/raid10.h
@@ -20,6 +20,11 @@ struct raid10_info {
 	sector_t	head_position;
 };
 
+struct r10bio_pool {
+	mempool_t	pool;
+	unsigned int	nr_devs;
+};
+
 struct r10conf {
 	struct mddev		*mddev;
 	struct raid10_info	*mirrors;
@@ -87,7 +92,7 @@ struct r10conf {
 						   */
 	wait_queue_head_t	wait_barrier;
 
-	mempool_t		r10bio_pool;
+	struct r10bio_pool	*r10bio_pool;
 	mempool_t		r10buf_pool;
 	struct page		*tmppage;
 	struct bio_set		bio_split;
@@ -128,6 +133,7 @@ struct r10bio {
 	 */
 	int			read_slot;
 	unsigned int		used_nr_devs;
+	unsigned int		alloc_nr_devs;
 
 	struct list_head	retry_list;
 	/*
-- 
2.53.0
