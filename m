Received: from va-2-29.ptr.blmpb.com (va-2-29.ptr.blmpb.com [209.127.231.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE77B2773E5
	for <linux-raid@vger.kernel.org>; Mon, 25 May 2026 01:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779674153; cv=none; b=mG1xpUXOhpJFHzt8XydAIpbcGXOd4RsHBEf9f9InIptnEgYR1SQwZwvjLoDK91lNKaqCPUmA46md9wS/VCtHBEwKHjLwFJtAeLf8tsxj+FEG2/ISIQfkTpaWQnw60tL8fxSUIlFhykZdqu6az/bkbQt3rT2pXNhEIOXXwOvpAI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779674153; c=relaxed/simple;
	bh=eqOCP2Flce3RuZNEaRmrvZcZSnLJcbIq2CTmYiTpwMg=;
	h=From:Subject:Date:Mime-Version:To:Cc:Content-Type:Message-Id:
	 In-Reply-To:References; b=f2eamYWiwQAkGZhRlO7v2GQG/Dc3T+WP5EE7dWArubPOhHJAUtH2IdSaT4YVSmtirKGYFuNqPMGqYZ9fvOU5Ngj2Is4BgnV0UpQZEqcCTK/BnIMZ7qwFv0IMRndc2dORzGlPwJS16ZX2EjEMiXjpJQU+V2v72eWTyOCK9vUP+rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=Hf4OE270; arc=none smtp.client-ip=209.127.231.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="Hf4OE270"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1779674139;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=PxXAHw+BWXBTzkTHIP97NpyVqmc8V+5qTaihnCkJed8=;
 b=Hf4OE270gkI1QpbJjzPqkGdeiyYLMXZMFE2oqolSEYtQDJYymnmoiPz/lnQDjoRsJx9+nM
 CPaviIQACfbKWuRoS+mSLA0/tV3BPZnfnUHbHSrhbAlEwTBV1s5bWbdi70TZyuzZxmpJKw
 FSaqSTucGMnBWgY7BokNdY7WAca0Wg6hKnKlCEBJl97Sc//a1LeAR0dRiX/zk3J82R8gja
 RBdUJ5kGew+jeBIUbi6v2l9MGpSBECOgNprKqJzid9XhXoVSIjLhAmQFfIwZv8kIMhQ6Ej
 Tn4bv0rdHVDgap4yF8B7BmR/GkwEkINZaSjOyfO71gjin25kSU7bA7RXKgA72A==
From: "Chen Cheng" <chencheng@fnnas.com>
Subject: [PATCH v3 2/2] md/raid10: bound reused r10bio devs[] walks by used_nr_devs
Date: Mon, 25 May 2026 09:55:20 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: chencheng@fnnas.com
Received: from localhost.localdomain ([113.111.141.72]) by smtp.feishu.cn with ESMTPS; Mon, 25 May 2026 09:55:37 +0800
To: "Yu Kuai" <yukuai@fnnas.com>, <linux-raid@vger.kernel.org>
Cc: "Chen Cheng" <chencheng@fnnas.com>, <linux-kernel@vger.kernel.org>
X-Mailer: git-send-email 2.54.0
Content-Type: text/plain; charset=UTF-8
Message-Id: <20260525015520.2565423-3-chencheng@fnnas.com>
In-Reply-To: <20260525015520.2565423-1-chencheng@fnnas.com>
X-Lms-Return-Path: <lba+26a13ac1a+707fab+vger.kernel.org+chencheng@fnnas.com>
References: <20260525015520.2565423-1-chencheng@fnnas.com>
Content-Transfer-Encoding: 7bit

From: Chen Cheng <chencheng@fnnas.com>

After reshape changes raid_disks, an in-flight r10bio from the old geometry
can still be completed or freed later. In that case, using the current
geometry to walk r10_bio->devs[] is unsafe. A failure was reproduced with a
simple write workload while reshaping a raid10 array from 4 disks to 5 disks.
e.g.:

  mdadm -C /dev/md777 -l10 -n4 /dev/sda /dev/sdb /dev/sdc /dev/sdd
  mkfs.ext4 /dev/md777
  mount /dev/md777 /mnt/test
  fsstress -d /mnt/test -n 24000 -p 8 -l 24 &
  mdadm /dev/md777 --add /dev/sde
  mdadm --grow /dev/md777 --raid-devices=5 \
    --backup-file=/tmp/md-reshape-backup

the sequence above can trigger:

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
completed or freed as if it had 5 slots, and the walk overruns devs[4]. The
same stale-width mismatch can also surface during a 5-disk to 4-disk reshape.

Track the number of valid devs[] entries in each reused r10bio with
used_nr_devs. Initialize it whenever an r10bio is prepared for regular I/O,
discard, or resync/recovery/reshape work, and use it to bound devs[] walks
in put_all_bios() and find_bio_disk().

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/raid10.c | 8 ++++++--
 drivers/md/raid10.h | 2 ++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 64677dbe5152..d4695fa9c076 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -273,11 +273,11 @@ static void r10buf_pool_free(void *__r10_bio, void *data)
 
 static void put_all_bios(struct r10conf *conf, struct r10bio *r10_bio)
 {
 	int i;
 
-	for (i = 0; i < conf->geo.raid_disks; i++) {
+	for (i = 0; i < r10_bio->used_nr_devs; i++) {
 		struct bio **bio = & r10_bio->devs[i].bio;
 		if (!BIO_SPECIAL(*bio))
 			bio_put(*bio);
 		*bio = NULL;
 		bio = &r10_bio->devs[i].repl_bio;
@@ -370,11 +370,11 @@ static int find_bio_disk(struct r10conf *conf, struct r10bio *r10_bio,
 			 struct bio *bio, int *slotp, int *replp)
 {
 	int slot;
 	int repl = 0;
 
-	for (slot = 0; slot < conf->geo.raid_disks; slot++) {
+	for (slot = 0; slot < r10_bio->used_nr_devs; slot++) {
 		if (r10_bio->devs[slot].bio == bio)
 			break;
 		if (r10_bio->devs[slot].repl_bio == bio) {
 			repl = 1;
 			break;
@@ -1553,10 +1553,11 @@ static void __make_request(struct mddev *mddev, struct bio *bio, int sectors)
 
 	r10_bio->mddev = mddev;
 	r10_bio->sector = bio->bi_iter.bi_sector;
 	r10_bio->state = 0;
 	r10_bio->read_slot = -1;
+	r10_bio->used_nr_devs = conf->geo.raid_disks;
 	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) *
 			conf->geo.raid_disks);
 
 	if (bio_data_dir(bio) == READ)
 		raid10_read_request(mddev, bio, r10_bio, true);
@@ -1740,10 +1741,11 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 retry_discard:
 	r10_bio = mempool_alloc(conf->r10bio_pool, GFP_NOIO);
 	r10_bio->mddev = mddev;
 	r10_bio->state = 0;
 	r10_bio->sectors = 0;
+	r10_bio->used_nr_devs = geo->raid_disks;
 	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) * geo->raid_disks);
 	wait_blocked_dev(mddev, r10_bio);
 
 	/*
 	 * For far layout it needs more than one r10bio to cover all regions.
@@ -3074,10 +3076,12 @@ static struct r10bio *raid10_alloc_init_r10buf(struct r10conf *conf)
 	    test_bit(MD_RECOVERY_RESHAPE, &conf->mddev->recovery))
 		nalloc = conf->copies; /* resync */
 	else
 		nalloc = 2; /* recovery */
 
+	r10bio->used_nr_devs = nalloc;
+
 	for (i = 0; i < nalloc; i++) {
 		bio = r10bio->devs[i].bio;
 		rp = bio->bi_private;
 		bio_reset(bio, NULL, 0);
 		bio->bi_private = rp;
diff --git a/drivers/md/raid10.h b/drivers/md/raid10.h
index b711626a5db7..4751119f9770 100644
--- a/drivers/md/raid10.h
+++ b/drivers/md/raid10.h
@@ -125,10 +125,12 @@ struct r10bio {
 	struct bio		*master_bio;
 	/*
 	 * if the IO is in READ direction, then this is where we read
 	 */
 	int			read_slot;
+	/* Used to bound devs[] walks when the object is reused. */
+	unsigned int		used_nr_devs;
 
 	struct list_head	retry_list;
 	/*
 	 * if the IO is in WRITE direction, then multiple bios are used,
 	 * one for each copy.
-- 
2.54.0
