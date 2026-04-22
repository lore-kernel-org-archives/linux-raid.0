Received: from va-2-36.ptr.blmpb.com (va-2-36.ptr.blmpb.com [209.127.231.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A36F637F72C
	for <linux-raid@vger.kernel.org>; Wed, 22 Apr 2026 02:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776825237; cv=none; b=KIPS9td0kLCflwWOP/oWBjo80YAyixONiciTX3gAz3gU6yCZ6X+7mV8qbs6OxE4394XHhGhTLx+r76Vj7TvGA6aHp3SLo/W49ofn2B7ngJx86w26gH1cLWjZ9xNfwh2tmJkS8JT2hLqMqXmi+cXk+qqIBqwLCSg6kbJHv5t9Gdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776825237; c=relaxed/simple;
	bh=frGf6y+RMqGevpOobR/Kk9dKrAl9pXxo3fhMo9O+nzg=;
	h=Date:Message-Id:To:References:Cc:From:In-Reply-To:Subject:
	 Mime-Version:Content-Type; b=e9OqB6QmOz6ypHSNZ4oqOjo4TMwZ+Ojd/+TIY7VaW6b21GaQC/IBZ9ccyxNxIaJncYbYMVNaU1IIZv65teJsbLovDpJ+uCyyL06XpbkOfwu4ldzPAk286Yl/g1uEj1PR6YvqYQLlvigAKZym7yaKc7QecLYOIdDHIucficrITko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=JL7+Oc00; arc=none smtp.client-ip=209.127.231.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="JL7+Oc00"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1776825215;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=2f9y+UXK1Lu/tSGCicWquuODS+m028Vnz53xVRFUn8A=;
 b=JL7+Oc00XS+MWsT32l79IoXKpLbKFNfDJFxng30x76lQf/WdwflO5JzluJdDlpYhY7Y6Qb
 dio7tNFcRYhdoJqSe27z+3fRLqRw5ZGSRjwN688Q2GNQ6iyGM0uRvQNND48PWAuSchFJlj
 MhqZS4ZkPS3AtriEzn3GapYFZQER3umnE1dcgnKwlHaeXmgTmolTA2ZJCSZvnaU+lForTq
 SX0KWAha15oR/EWlIdjMCg4ZE7cf5MMb4vwh5JL9VemvQ2FUeMkkky6HgRpaA/HAeTHZRM
 oFwvip3HD/soMSh4JGzkD7YRvYBM4WN4OKVVBk6DD/dbE9xeq9Q08I3kZOdJ7A==
Date: Wed, 22 Apr 2026 10:33:16 +0800
Message-Id: <20260422023317.796326-3-chencheng@fnnas.com>
To: <linux-raid@vger.kernel.org>, <yukuai@fnnas.com>
References: <20260422023317.796326-1-chencheng@fnnas.com>
X-Original-From: chencheng@fnnas.com
Received: from localhost.localdomain ([113.111.140.171]) by smtp.feishu.cn with ESMTPS; Wed, 22 Apr 2026 10:33:32 +0800
X-Lms-Return-Path: <lba+269e8337d+59053c+vger.kernel.org+chencheng@fnnas.com>
Cc: <chencheng@fnnas.com>, <chenchneg33@gmail.com>
From: "Chen Cheng" <chencheng@fnnas.com>
In-Reply-To: <20260422023317.796326-1-chencheng@fnnas.com>
Content-Transfer-Encoding: 7bit
X-Mailer: git-send-email 2.53.0
Subject: [PATCH 3/4] md/raid10: fix r10bio devs overflow across reshape
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8

From: Chen Cheng <chencheng@fnnas.com>

A 4-disk to 5-disk raid10 reshape can complete or free an r10bio that was
allocated before the geometry switch.

The failure was reproduced with a simple write workload while reshaping a
raid10 array from 4 disks to 5 disks, e.g.:

  mdadm -C /dev/md777 -l10 -n4 /dev/sda /dev/sdb /dev/sdc /dev/sdd
  mkfs.ext4 /dev/md777
  mount /dev/md777 /mnt/test
  fsstress -d /mnt/test -n 24000 -p 8 -l 24 &
  mdadm /dev/md777 --add /dev/sde
  mdadm --grow /dev/md777 --raid-devices=5 \
    --backup-file=/tmp/md-reshape-backup

Without this patch, the sequence above can trigger:

  BUG: KASAN: slab-out-of-bounds in free_r10bio+0x1c4/0x260 [raid10]
  Read of size 8 at addr ffff00008c2dfac8 by task ksoftirqd/0/15
  free_r10bio
  raid_end_bio_io
  one_write_done
  raid10_end_write_request

The buggy object was 200 bytes long, which matches an r10bio with space for
only four devs[] entries. However, put_all_bios() and find_bio_disk() walk
r10_bio->devs[] using the current conf->geo.raid_disks value. Once reshape
switches conf->geo.raid_disks from 4 to 5, an old 4-slot r10bio can be
completed or freed as if it had 5 slots, and the walk overruns devs[4].

The same stale-width mismatch can also surface during a 5-disk to 4-disk
reshape.

The same transition also leaves stale-width objects in the active r10bio
pool, so new requests can reuse a 4-slot object after reshape starts unless
the pool is replaced for the new geometry.

Fix this by recording the actual devs[] slot count in each r10bio and using
that count when scanning or freeing the object. Also replace the active
r10bio pool with one sized for the new geometry before reshape switches
layouts. Old-width r10bio objects are freed directly instead of being
returned to a pool that now expects a different width.

A/B validation:

- Without this patch, the 4-disk to 5-disk reshape test triggered the
  KASAN report.
- With this patch, neither the 4-disk to 5-disk nor the 5-disk to 4-disk
  reshape test triggers KASAN.
---
 drivers/md/raid10.c | 43 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 41 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index b447903fbdc6..3edde440623a 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -234,6 +234,30 @@ static void * r10buf_pool_alloc(gfp_t gfp_flags, void *data)
 	return NULL;
 }
 
+static int reinit_r10bio_pool(struct r10conf *conf, unsigned int nr_devs)
+{
+	struct r10bio_pool *new_pool, *old_pool = conf->r10bio_pool;
+	int ret;
+
+	if (old_pool->nr_devs == nr_devs)
+		return 0;
+
+	new_pool = kzalloc_obj(struct r10bio_pool);
+	if (!new_pool)
+		return -ENOMEM;
+
+	ret = init_r10bio_pool(new_pool, nr_devs);
+	if (ret) {
+		kfree(new_pool);
+		return ret;
+	}
+
+	conf->r10bio_pool = new_pool;
+	mempool_exit(&old_pool->pool);
+	kfree(old_pool);
+	return 0;
+}
+
 static void r10buf_pool_free(void *__r10_bio, void *data)
 {
 	struct r10conf *conf = data;
@@ -268,7 +292,7 @@ static void put_all_bios(struct r10conf *conf, struct r10bio *r10_bio)
 {
 	int i;
 
-	for (i = 0; i < conf->geo.raid_disks; i++) {
+	for (i = 0; i < r10_bio->used_nr_devs; i++) {
 		struct bio **bio = & r10_bio->devs[i].bio;
 		if (!BIO_SPECIAL(*bio))
 			bio_put(*bio);
@@ -285,6 +309,10 @@ static void free_r10bio(struct r10bio *r10_bio)
 	struct r10conf *conf = r10_bio->mddev->private;
 
 	put_all_bios(conf, r10_bio);
+	if (r10_bio->alloc_nr_devs != conf->r10bio_pool->nr_devs) {
+		rbio_pool_free(r10_bio, conf);
+		return;
+	}
 	mempool_free(r10_bio, &conf->r10bio_pool->pool);
 }
 
@@ -365,7 +393,7 @@ static int find_bio_disk(struct r10conf *conf, struct r10bio *r10_bio,
 	int slot;
 	int repl = 0;
 
-	for (slot = 0; slot < conf->geo.raid_disks; slot++) {
+	for (slot = 0; slot < r10_bio->used_nr_devs; slot++) {
 		if (r10_bio->devs[slot].bio == bio)
 			break;
 		if (r10_bio->devs[slot].repl_bio == bio) {
@@ -4416,6 +4444,11 @@ static int raid10_start_reshape(struct mddev *mddev)
 	if (spares < mddev->delta_disks)
 		return -EINVAL;
 
+	raise_barrier(conf, 0);
+	ret = reinit_r10bio_pool(conf, new.raid_disks);
+	if (ret)
+		goto out_lower_barrier;
+
 	conf->offset_diff = min_offset_diff;
 	spin_lock_irq(&conf->device_lock);
 	if (conf->mirrors_new) {
@@ -4433,6 +4466,7 @@ static int raid10_start_reshape(struct mddev *mddev)
 		sector_t size = raid10_size(mddev, 0, 0);
 		if (size < mddev->array_sectors) {
 			spin_unlock_irq(&conf->device_lock);
+			lower_barrier(conf);
 			pr_warn("md/raid10:%s: array size must be reduce before number of disks\n",
 				mdname(mddev));
 			return -EINVAL;
@@ -4443,6 +4477,7 @@ static int raid10_start_reshape(struct mddev *mddev)
 		conf->reshape_progress = 0;
 	conf->reshape_safe = conf->reshape_progress;
 	spin_unlock_irq(&conf->device_lock);
+	lower_barrier(conf);
 
 	if (mddev->delta_disks && mddev->bitmap) {
 		struct mdp_superblock_1 *sb = NULL;
@@ -4527,6 +4562,10 @@ static int raid10_start_reshape(struct mddev *mddev)
 	md_new_event();
 	return 0;
 
+out_lower_barrier:
+	lower_barrier(conf);
+	return ret;
+
 abort:
 	mddev->recovery = 0;
 	spin_lock_irq(&conf->device_lock);
-- 
2.53.0
