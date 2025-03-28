Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE5034C6E
	for <linux-raid@vger.kernel.org>; Fri, 28 Mar 2025 11:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743160548; cv=none; b=NMebVTMTzawZ2ei9r2MuOMgDjGp50NUtZXbyH+Mj88hbNDr/tjjL5sXrtszj4t8ixiWZ3PqzES8P+dV4DrfI/JqGkZwXkRkxXg1UlOGFV6244xOTemO2bRlB5x/6SnvZ1e6ia1lQEPQTPomRz4fiTledThEpmSoUk94WcWxvsac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743160548; c=relaxed/simple;
	bh=vLHIj1+whtJTN5jUKphoyDIrbdPSTs+v/qQPjBoneKc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=O8gjlxHstB333BcplxkTXkCAjiSFPoDFgMY0tZj1p9vYVry/VrvyR2RmXLKVUrQssL14ed+E9/ySfP5GsmTobgB0EPfb/8DUpVbKag/29xptb31OS3JVA4aqyoDqccl5/WC3tY0wpvnCJT9r1MnwZShHf6RxzkClM4N2Am63r3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PbjH4NUs; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PbjH4NUs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743160544;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=mQC5KRslOmwog8sfa/B0eNz/WgWdkcYBIR77NF1BFpA=;
	b=PbjH4NUsVdW4qNBI2zAAOt4GE5FvWnMshJtxNL9PGZtO2cPVvdNi7JsUcAgPiqy9HgHC7m
	7kYeOCYWjErK+pOBcaUTsHawT6NhYmMQfvTyNasawSmRPGJKAxbPrq6Oc/cbU+oMHnRRQ7
	1l0Dg933lQJnUvIrXpa9kDq/Z7e4BDs=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-187-BCLx2xcePranVzYBMSi1Gw-1; Fri,
 28 Mar 2025 07:15:39 -0400
X-MC-Unique: BCLx2xcePranVzYBMSi1Gw-1
X-Mimecast-MFC-AGG-ID: BCLx2xcePranVzYBMSi1Gw_1743160536
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CFB0D180025C;
	Fri, 28 Mar 2025 11:15:35 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.17])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 157F9191F241;
	Fri, 28 Mar 2025 11:15:32 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: yukuai1@huaweicloud.com,
	song@kernel.org
Subject: [PATCH RFC 1/1] md/raid5: improve randread performance
Date: Fri, 28 Mar 2025 19:15:30 +0800
Message-Id: <20250328111530.19903-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

This problem is talked severl times[1][2]. And this can affect time of
mkfs too. The steps that are used to reproduce this problem are:

1. create a raid5 with 10 devices (each device is 5.5TB)
2. mkfs.ext4 -O 'meta_bg,uninit_bg,flex_bg,metadata_csum,^resize_inode'
3. run the same command in step2 again.

Step3 gives a message '/dev/md0 contains a ext4 file system' and starts
wait. Then it gives another message 'Proceed anyway? (y,N)' after a long
time (about 12 minutes). After adding some debug logs, there are many
small read ios with size 4KB and they are not sequential. At the same
time, the sync speed doesn't decrease.

is_mddev_idle is used to control sync speed if there are upper layer io.
It calculates a diff between the iostat sectors number and disk sync
number. Then it uses the diff as a basement. It calcuates the diff each
time. If newdiff-olddiff>64, it thinks upper layer submits bio to array
and it's time to slow down sync speed.

But it's hard to work for random ios in raid5. Those ios can't get stripe
because all stripes are used for sync request. So these random ios can't
be submitted to member disks and the iostat sectors can't be increased.
So is_mddev_idle can't work well in this situation.

This patch tries to resolve this issue by adding a personality method
which tells if normal io is starved. It needs to slow down the sync
speed if md can't handle ios from upper layer.

This patch introduces sync performance decline when there is competing
IO. Patch[1] improves the sync performance. But the decline is not
serious. Sure the io performance increases at the same time. These are
some fio test results:
libapi patch:

without patch:
libaio read bs=4k direct=1 numjobs=1 runtime=120:
bw=1845KiB/s
sync speed: about 180MB/s
libaio read bs=4k direct=1 iodepth=32 numjobs=1 runtime=120:
bw=9.78MiB/s
sync speed: about 170MB/S
libaio write bs=4k direct=1 iodepth=32 numjobs=1 runtime=120:
bw=1203KiB/s
sync speed: about 170MB/S
libaio randread bs=4k direct=1 numjobs=1 runtime=120:
bw=17.5KiB/s
sync speed: about 185MB/s
libaio randwrite bs=4k direct=1 numjobs=1 runtime=120:
bw=9312B/s
sync speed: about 150MB/s

withpatch:
libaio read bs=4k direct=1 numjobs=1 runtime=120:
bw=19.1MiB/s
sync speed: about 100MB/s
libaio read bs=4k direct=1 iodepth=32 numjobs=1 runtime=120:
bw=68.3MiB/s
sync speed: about 100MB/s
libaio write bs=4k direct=1 iodepth=32 numjobs=1 runtime=120:
bw=4994KiB/s
sync speed: about 100MB/s
libaio randread bs=4k direct=1 numjobs=1 runtime=120:
bw=63.5KiB/s
sync speed: about 150MB/s
libaio randwrite bs=4k direct=1 numjobs=1 runtime=120:
bw=23.0KiB/s
sync speed: about 120MB/s

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/md.c    | 10 ++++++++++
 drivers/md/md.h    |  1 +
 drivers/md/raid5.c | 17 +++++++++++++++++
 drivers/md/raid5.h |  2 ++
 4 files changed, 30 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 30b3dbbce2d2..15a7b008fdd0 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8588,6 +8588,14 @@ void md_cluster_stop(struct mddev *mddev)
 	module_put(md_cluster_mod);
 }
 
+static bool is_mddev_io_starve(struct mddev *mddev)
+{
+	if (mddev->pers->io_starve)
+		return mddev->pers->io_starve(mddev);
+	else
+		return false;
+}
+
 static int is_mddev_idle(struct mddev *mddev, int init)
 {
 	struct md_rdev *rdev;
@@ -9219,6 +9227,8 @@ void md_do_sync(struct md_thread *thread)
 				wait_event(mddev->recovery_wait,
 					   !atomic_read(&mddev->recovery_active));
 			}
+			if (is_mddev_io_starve(mddev) == true)
+				msleep(500);
 		}
 	}
 	pr_info("md: %s: %s %s.\n",mdname(mddev), desc,
diff --git a/drivers/md/md.h b/drivers/md/md.h
index def808064ad8..139a50e3e9e8 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -704,6 +704,7 @@ struct md_personality
 	struct list_head list;
 	struct module *owner;
 	bool __must_check (*make_request)(struct mddev *mddev, struct bio *bio);
+	bool (*io_starve)(struct mddev *mddev);
 	/*
 	 * start up works that do NOT require md_thread. tasks that
 	 * requires md_thread should go into start()
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 5c79429acc64..b74d852a203d 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -852,6 +852,9 @@ struct stripe_head *raid5_get_active_stripe(struct r5conf *conf,
 		if (flags & R5_GAS_NOBLOCK)
 			break;
 
+		if (flags & R5_GAS_IO)
+			set_bit(R5_IO_STARVE, &conf->cache_state);
+
 		set_bit(R5_INACTIVE_BLOCKED, &conf->cache_state);
 		r5l_wake_reclaim(conf->log, 0);
 
@@ -5961,8 +5964,10 @@ static enum stripe_result make_stripe_request(struct mddev *mddev,
 		flags |= R5_GAS_PREVIOUS;
 	if (bi->bi_opf & REQ_RAHEAD)
 		flags |= R5_GAS_NOBLOCK;
+	flags |= R5_GAS_IO;
 	sh = raid5_get_active_stripe(conf, ctx, new_sector, flags);
 	if (unlikely(!sh)) {
+		set_bit(R5_IO_STARVE, &conf->cache_state);
 		/* cannot get stripe, just give-up */
 		bi->bi_status = BLK_STS_IOERR;
 		return STRIPE_FAIL;
@@ -6066,6 +6071,15 @@ static sector_t raid5_bio_lowest_chunk_sector(struct r5conf *conf,
 	return r_sector + sectors_per_chunk - chunk_offset;
 }
 
+static bool raid5_io_starve(struct mddev *mddev)
+{
+	struct r5conf *conf = mddev->private;
+
+	if (test_and_clear_bit(R5_IO_STARVE, &conf->cache_state))
+		return true;
+	else
+		return false;
+}
+
 static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 {
 	DEFINE_WAIT_FUNC(wait, woken_wake_function);
@@ -8958,6 +8972,7 @@ static struct md_personality raid6_personality =
 	.level		= 6,
 	.owner		= THIS_MODULE,
 	.make_request	= raid5_make_request,
+	.io_starve	= raid5_io_starve,
 	.run		= raid5_run,
 	.start		= raid5_start,
 	.free		= raid5_free,
@@ -8984,6 +8999,7 @@ static struct md_personality raid5_personality =
 	.level		= 5,
 	.owner		= THIS_MODULE,
 	.make_request	= raid5_make_request,
+	.io_starve	= raid5_io_starve,
 	.run		= raid5_run,
 	.start		= raid5_start,
 	.free		= raid5_free,
@@ -9011,6 +9027,7 @@ static struct md_personality raid4_personality =
 	.level		= 4,
 	.owner		= THIS_MODULE,
 	.make_request	= raid5_make_request,
+	.io_starve	= raid5_io_starve,
 	.run		= raid5_run,
 	.start		= raid5_start,
 	.free		= raid5_free,
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index eafc6e9ed6ee..fe898d8acdb6 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -537,6 +537,7 @@ enum r5_cache_state {
 				 * released.  This avoids flooding
 				 * the cache.
 				 */
+	R5_IO_STARVE,
 	R5C_LOG_TIGHT,		/* log device space tight, need to
 				 * prioritize stripes at last_checkpoint
 				 */
@@ -813,6 +814,7 @@ struct stripe_request_ctx;
 #define R5_GAS_NOBLOCK		(1 << 1)
 /* do not block waiting for quiesce to be released */
 #define R5_GAS_NOQUIESCE	(1 << 2)
+#define R5_GAS_IO		(1 << 3)
 struct stripe_head *raid5_get_active_stripe(struct r5conf *conf,
 		struct stripe_request_ctx *ctx, sector_t sector,
 		unsigned int flags);
-- 
2.47.1

