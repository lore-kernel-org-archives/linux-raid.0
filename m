Received: from sg-3-30.ptr.tlmpb.com (sg-3-30.ptr.tlmpb.com [101.45.255.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B75D438FED
	for <linux-raid@vger.kernel.org>; Fri, 15 May 2026 09:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.45.255.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778837297; cv=none; b=okVRCjqt70hOHU3u1LFVV3wXSAwQ6r0V0OqC/i95tB087KdU54A+mbfJIkIG0G7DEEBdC5S6VT6TFLu63Kczkd5QJghfzq38mjX8Jp9yYm4dZFJZyV2UlFGRPCMr2LZDFFm20sudU5npEvV8uDoWZ/qBRqd9BdrIOMImuIwqyBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778837297; c=relaxed/simple;
	bh=IFScY7YpC0U/kYgv/XrsH5CEwR8Rv7WRchD0hd5pjxo=;
	h=To:Subject:Cc:References:In-Reply-To:Content-Type:From:Date:
	 Message-Id:Mime-Version; b=dHzGesZOrI2doBhLd1TeyD+eJ6ytfeddJ23bMGjrfR1ew7mbmxooqxrK4pvlhGfb3121RRbAbCnVceyseQ5QuYjrP8kvLy2imx5Lewm0EjBKqgoqjn0Ff5uSRQyqyDhgKgD6VN5+mVZv6vJn3qEEKbp2RSX/OeSp6ZxE06ylo14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=bKBjFj6m; arc=none smtp.client-ip=101.45.255.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="bKBjFj6m"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1778837246;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=pfrTyTwT3TQtImo/uba2l2Roj3cvKEzaaMunpbS4ijY=;
 b=bKBjFj6mlJkr8ZReqFs+fspZcx8EVkF6O/yABUxysn+mdTyQyBjKTw1/VCZQgyecJ25nxn
 W/vD8RcyjGUG5KH2HrwQenyQVdAqRW0okDaBOsDIrV4ClrFZHZea26p1KhmFx3+IBI1U80
 QP9SrYhgOCha1WPbvs89GhpuXx9KiF1HJJlWuKAjVXDyLe/mS7YbrO+Fx83pt2fFCjJt8/
 tVcA9rD1zec4eJtmPnouM5opVKedml0tSajYeAi4yhsZssjP0XTZxxluPP6PJPg+wLPcnp
 PRvf64nDaff5mamwBiyMn+k9ifvWPM1IQ6x4sQAbrzc6BAcN0c+JJN4UE1DhnQ==
To: "Yu Kuai" <yukuai@fnnas.com>
Subject: [PATCH v2 2/2] md/raid10: bound reused r10bio devs[] walks by used_nr_devs
Cc: "Chen Cheng" <chencheng@fnnas.com>, <linux-raid@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>
X-Mailer: git-send-email 2.54.0
References: <20260515092707.3436464-1-chencheng@fnnas.com>
In-Reply-To: <20260515092707.3436464-1-chencheng@fnnas.com>
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+26a06e6fb+209516+vger.kernel.org+chencheng@fnnas.com>
X-Original-From: chencheng@fnnas.com
Content-Type: text/plain; charset=UTF-8
From: "Chen Cheng" <chencheng@fnnas.com>
Date: Fri, 15 May 2026 17:27:07 +0800
Message-Id: <20260515092707.3436464-3-chencheng@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from localhost.localdomain ([113.111.244.134]) by smtp.feishu.cn with ESMTPS; Fri, 15 May 2026 17:27:22 +0800

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
index 886bbe6b1ebc..42865d822d95 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -275,7 +275,7 @@ static void put_all_bios(struct r10conf *conf, struct r10bio *r10_bio)
 {
 	int i;
 
-	for (i = 0; i < conf->geo.raid_disks; i++) {
+	for (i = 0; i < r10_bio->used_nr_devs; i++) {
 		struct bio **bio = & r10_bio->devs[i].bio;
 		if (!BIO_SPECIAL(*bio))
 			bio_put(*bio);
@@ -372,7 +372,7 @@ static int find_bio_disk(struct r10conf *conf, struct r10bio *r10_bio,
 	int slot;
 	int repl = 0;
 
-	for (slot = 0; slot < conf->geo.raid_disks; slot++) {
+	for (slot = 0; slot < r10_bio->used_nr_devs; slot++) {
 		if (r10_bio->devs[slot].bio == bio)
 			break;
 		if (r10_bio->devs[slot].repl_bio == bio) {
@@ -1555,6 +1555,7 @@ static void __make_request(struct mddev *mddev, struct bio *bio, int sectors)
 	r10_bio->sector = bio->bi_iter.bi_sector;
 	r10_bio->state = 0;
 	r10_bio->read_slot = -1;
+	r10_bio->used_nr_devs = conf->geo.raid_disks;
 	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) *
 			conf->geo.raid_disks);
 
@@ -1742,6 +1743,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 	r10_bio->mddev = mddev;
 	r10_bio->state = 0;
 	r10_bio->sectors = 0;
+	r10_bio->used_nr_devs = geo->raid_disks;
 	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) * geo->raid_disks);
 	wait_blocked_dev(mddev, r10_bio);
 
@@ -3076,6 +3078,8 @@ static struct r10bio *raid10_alloc_init_r10buf(struct r10conf *conf)
 	else
 		nalloc = 2; /* recovery */
 
+	r10bio->used_nr_devs = nalloc;
+
 	for (i = 0; i < nalloc; i++) {
 		bio = r10bio->devs[i].bio;
 		rp = bio->bi_private;
diff --git a/drivers/md/raid10.h b/drivers/md/raid10.h
index b711626a5db7..4751119f9770 100644
--- a/drivers/md/raid10.h
+++ b/drivers/md/raid10.h
@@ -127,6 +127,8 @@ struct r10bio {
 	 * if the IO is in READ direction, then this is where we read
 	 */
 	int			read_slot;
+	/* Used to bound devs[] walks when the object is reused. */
+	unsigned int		used_nr_devs;
 
 	struct list_head	retry_list;
 	/*
-- 
2.54.0
