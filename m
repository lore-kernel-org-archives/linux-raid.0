Received: from va-2-40.ptr.blmpb.com (va-2-40.ptr.blmpb.com [209.127.231.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E4C397321
	for <linux-raid@vger.kernel.org>; Sat, 27 Jun 2026 10:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782557750; cv=none; b=X92GB+YNPXB2X6k1A3HFYlseLgJ5Jif4OnHu2jy5lId/xa9JB65W3SjfILnqIN1NC8QZ4KqesYy6oOnp/oGDEpdjywoBA4YCatX8kYcRurYWoLYe+S1nXePBsfdg5ZwqFMY9H8tdmwd9a+3se4vKciBj342fjZmqp+2+gJBhECc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782557750; c=relaxed/simple;
	bh=vtGATUPt86WF7+/0EE9gcOnC9h9VC94AN2kCl56wzEY=;
	h=From:Date:Cc:Subject:Mime-Version:Content-Type:To:Message-Id; b=QjqfApbA2dG68YtFvkfvWUdolFucOhHyqcW3Pm/Doznem9LS6fxIBFnqsdGlMguUVg3/tz5DHnNmsWBILsip6XuIRps06UDIf429Ej1nKJEd418UQftb0QgHpaOfHDZvD9ammqAP4HM6kU4jMqEYW88L74U/1vKNzwQmPFfNmtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=hpiqlpyO; arc=none smtp.client-ip=209.127.231.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="hpiqlpyO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1782557736;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=09NI9h8pXOVJePy8ekMkP/0ApeXcwji/+//+YNUsm50=;
 b=hpiqlpyOCUXjO9Y6CVr9iVeGgUlZyvETHTUA2gsbFHKL7zuGvHW7y5gN9Q20j5HJdCRkCS
 +E7fRMlSHYeDZf8Nh3hrzH9CuThugIK6xkG1hD/H7oPj1CAWWQtdjqDRLt32slftgULZEn
 PMnQb8DJx4TXHTuv1bRdfsiqYx6hh3+BFk9m9mBI3ukkf0V8nffZkeJK0SJ0M5LCxhcRjw
 1sxwjDzvlh8e1FILEbIXnsGn1Y8uYJddP5grT3/8N+QBIxTeEUCH20IKaTP+SZBPPx/rJI
 e8jM5I2ptZP8d3UqbybigSwbiYKnYtiPmyp4j0bSNkj+XK6yssvo4CQdtsmIGg==
X-Original-From: chencheng@fnnas.com
Received: from fedora ([27.47.238.101]) by smtp.feishu.cn with ESMTPS; Sat, 27 Jun 2026 18:55:34 +0800
X-Mailer: git-send-email 2.54.0
From: "Chen Cheng" <chencheng@fnnas.com>
Date: Sat, 27 Jun 2026 18:55:23 +0800
Content-Transfer-Encoding: 7bit
Cc: <chencheng@fnnas.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] md/raid5: protect lockless reshape_progress accesses
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>
Message-Id: <20260627105524.144022-1-chencheng@fnnas.com>
X-Lms-Return-Path: <lba+26a3fac26+e5ef36+vger.kernel.org+chencheng@fnnas.com>

From: Chen Cheng <chencheng@fnnas.com>

During reshape:
- reshape_request() advances conf->reshape_progress.
- reshape_request() itself also reads conf->reshape_progress several times
  while calculating sector_nr, writepos, and readpos for the current
  reshape step.
- use_new_offset() reads conf->reshape_progress locklessly to decide
  whether the current stripe should use data_offset or new_data_offset.

one possible scenario is:

CPU1                            CPU2
reshape_request()
-> conf->reshape_progress += delta
                                ops_run_io()
                                -> use_new_offset(conf, sh)
                                -> progress = conf->reshape_progress
                                -> decide old layout or new layout
                                -> use data_offset or new_data_offset

reshape_progress is the boundary between old and new layout mapping.

If CPU2 observes an unprotected reshape_progress value, it can choose
the wrong layout offset for the current stripe.

if reshape_request() reads reshape_progress multiple times without
a stable snapshot, one iteration of reshape can calculate its range from
inconsistent progress values.

Fixes: 7a6613810785 ("md/raid5: reshape using largest of old and new chunk size")

The race report:
==================================================================
BUG: KCSAN: data-race in ops_run_io / reshape_request

write to 0xffff89a8d3ef2270 of 8 bytes by task 1299 on cpu 7:
 reshape_request+0x1292/0x17b0
 raid5_sync_request+0x815/0xa00
 md_do_sync.cold+0xf8d/0x1516
 md_thread+0x15a/0x2d0
 [....]

read to 0xffff89a8d3ef2270 of 8 bytes by task 1292 on cpu 9:
 ops_run_io+0xc25/0x1960
 handle_stripe+0x2273/0x4570
 handle_active_stripes.isra.0+0x6e0/0xa50
 raid5d+0x7d5/0xb90
 [....]

value changed: 0x0000000000173700 -> 0x0000000000173800
==================================================================

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/raid5.c | 34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index eaee7f206ab8..b6809f1a3ab4 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1011,11 +1011,11 @@ static void stripe_add_to_batch_list(struct r5conf *conf,
 /* Determine if 'data_offset' or 'new_data_offset' should be used
  * in this stripe_head.
  */
 static int use_new_offset(struct r5conf *conf, struct stripe_head *sh)
 {
-	sector_t progress = conf->reshape_progress;
+	sector_t progress = READ_ONCE(conf->reshape_progress);
 	/* Need a memory barrier to make sure we see the value
 	 * of conf->generation, or ->data_offset that was set before
 	 * reshape_progress was updated.
 	 */
 	smp_rmb();
@@ -6340,24 +6340,25 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
 	sector_t writepos, readpos, safepos;
 	sector_t stripe_addr;
 	int reshape_sectors;
 	struct list_head stripes;
 	sector_t retn;
+	sector_t reshape_progress = READ_ONCE(conf->reshape_progress);
 
 	if (sector_nr == 0) {
 		/* If restarting in the middle, skip the initial sectors */
 		if (mddev->reshape_backwards &&
-		    conf->reshape_progress < raid5_size(mddev, 0, 0)) {
+		    reshape_progress < raid5_size(mddev, 0, 0)) {
 			sector_nr = raid5_size(mddev, 0, 0)
-				- conf->reshape_progress;
+				- reshape_progress;
 		} else if (mddev->reshape_backwards &&
-			   conf->reshape_progress == MaxSector) {
+			   reshape_progress == MaxSector) {
 			/* shouldn't happen, but just in case, finish up.*/
 			sector_nr = MaxSector;
 		} else if (!mddev->reshape_backwards &&
-			   conf->reshape_progress > 0)
-			sector_nr = conf->reshape_progress;
+			   reshape_progress > 0)
+			sector_nr = reshape_progress;
 		sector_div(sector_nr, new_data_disks);
 		if (sector_nr) {
 			mddev->curr_resync_completed = sector_nr;
 			sysfs_notify_dirent_safe(mddev->sysfs_completed);
 			*skipped = 1;
@@ -6377,13 +6378,13 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
 	 * the data about to be copied would over-write the source of
 	 * the data at the front of the range.  i.e. one new_stripe
 	 * along from reshape_progress new_maps to after where
 	 * reshape_safe old_maps to
 	 */
-	writepos = conf->reshape_progress;
+	writepos = reshape_progress;
 	sector_div(writepos, new_data_disks);
-	readpos = conf->reshape_progress;
+	readpos = reshape_progress;
 	sector_div(readpos, data_disks);
 	safepos = conf->reshape_safe;
 	sector_div(safepos, data_disks);
 	if (mddev->reshape_backwards) {
 		if (WARN_ON(writepos < reshape_sectors))
@@ -6404,11 +6405,11 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
 
 	/* Having calculated the 'writepos' possibly use it
 	 * to set 'stripe_addr' which is where we will write to.
 	 */
 	if (mddev->reshape_backwards) {
-		if (WARN_ON(conf->reshape_progress == 0))
+		if (WARN_ON(reshape_progress == 0))
 			return MaxSector;
 
 		stripe_addr = writepos;
 		if (WARN_ON((mddev->dev_sectors &
 		    ~((sector_t)reshape_sectors - 1)) -
@@ -6514,14 +6515,21 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
 			set_bit(STRIPE_HANDLE, &sh->state);
 		}
 		list_add(&sh->lru, &stripes);
 	}
 	spin_lock_irq(&conf->device_lock);
-	if (mddev->reshape_backwards)
-		conf->reshape_progress -= reshape_sectors * new_data_disks;
-	else
-		conf->reshape_progress += reshape_sectors * new_data_disks;
+	if (mddev->reshape_backwards) {
+		sector_t progress = conf->reshape_progress;
+
+		progress -= reshape_sectors * new_data_disks;
+		WRITE_ONCE(conf->reshape_progress, progress);
+	} else {
+		sector_t progress = conf->reshape_progress;
+
+		progress += reshape_sectors * new_data_disks;
+		WRITE_ONCE(conf->reshape_progress, progress);
+	}
 	spin_unlock_irq(&conf->device_lock);
 	/* Ok, those stripe are ready. We can start scheduling
 	 * reads on the source stripes.
 	 * The source stripes are determined by mapping the first and last
 	 * block on the destination stripes.
-- 
2.54.0
