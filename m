Received: from va-2-27.ptr.blmpb.com (va-2-27.ptr.blmpb.com [209.127.231.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244DD394797
	for <linux-raid@vger.kernel.org>; Sat, 11 Jul 2026 10:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.27
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783764267; cv=none; b=IqarFLt5w3vZE2kFbeIvCe/kEjY+wQOk2gSml/5Cv8CZPgvHY4OjDV7tFGiDHJS676r5NXxwIC4rlTcE5PcqLFElEZHUM2KGQ9s5oRvVi4glb3Xe69WbCGpALuy9G82YzwrM338Iww6DeOvqdNO6iHk0RLKQt8bWkVEUqRMwTJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783764267; c=relaxed/simple;
	bh=r8IfeEOcCJi5R2NC8d+Rfhj4t/E73A0H6FSdA/jiL+Q=;
	h=References:Message-Id:Content-Type:Subject:Cc:Date:In-Reply-To:To:
	 Mime-Version:From; b=Uuw+a9xfvNO67AlQ71P87xIxqtqCxOBhNH+hc6ktiBi8zL50eAuO5Th4Bh9MDgwN2a+nHpgB9AuoNyNOQXZ5s+pWoW+Y5PPOdiDHi24h6MGhDGBz1VEoilWp5BZLEx61Pla/o9FiADG39pmqthyWtXSV/EoXaiMWMiBRt0L/smA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=1+GEwDtV; arc=none smtp.client-ip=209.127.231.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="1+GEwDtV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1783764258;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=+sMde1uXQQmrIm1HfL2pHUPWF3xcv3sDpvWsOMPmOCo=;
 b=1+GEwDtVZH//4/0XwX4VyzYTij5kDPmRzIJqYvZBegrk/q0M90WGjtbihJR3yvLm/jbT1I
 bapFZXX2zMQd+VhaNbdhwBDaSotAXOdXj7OgToISPEEdnBxywYCBcK/i1/rKc3lslqT/43
 1AyzxFXroxnbjh8towYKgLWtBQXHckXITueKPFOPTQMvR738p1eNrlHpjN25jp0vl61ghJ
 YC/1UMLC/rdUzAXgKcQD0NI9IH76w9GISg9HOuK0sXJ6WtFhGSCHqapOsGXm0lMckCgXHb
 jmf3ksQPxXchdDnlO5MBSJuN0jVbXbSjdej/fK2EfFbUfRUv9ReFODv+zohLBQ==
References: <20260711100352.425177-1-chencheng@fnnas.com>
X-Original-From: chencheng@fnnas.com
Message-Id: <20260711100352.425177-4-chencheng@fnnas.com>
Content-Transfer-Encoding: 7bit
Received: from fedora ([183.34.162.102]) by smtp.feishu.cn with ESMTPS; Sat, 11 Jul 2026 18:04:11 +0800
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH v7 3/3] md/raid10: free r10bio before ending master_bio in raid_end_bio_io() and raid_end_discard_bio()
Cc: <chencheng@fnnas.com>, <linux-kernel@vger.kernel.org>
Date: Sat, 11 Jul 2026 18:03:52 +0800
In-Reply-To: <20260711100352.425177-1-chencheng@fnnas.com>
X-Lms-Return-Path: <lba+26a521520+6ccedf+vger.kernel.org+chencheng@fnnas.com>
To: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0
From: "Chen Cheng" <chencheng@fnnas.com>

From: Chen Cheng <chencheng@fnnas.com>

origin flow:

      bio_endio(master_bio);   /* may drop active_io to zero */
      allow_barrier(conf);
      free_r10bio(r10_bio);    /* reads conf->geo, returns to pool */

one scenario is:

  CPU A (softirq, raid_end_bio_io)         CPU B (action_store) --> reshape
  ================================         ===============================
  bio_endio(master_bio)
    md_end_clone_io
      percpu_ref_put -> 0
                                           wait_event wakeup, and,
                                           	mddev_suspend return
                                           raid10_start_reshape:
                                             setup_geo(&conf->geo, new)
                                             ...
                                             mempool_destroy(old_pool)
                                             conf->r10bio_pool = new_pool
  allow_barrier(conf)
  free_r10bio(r10_bio)
    put_all_bios:
      for (i=0; i<conf->geo.raid_disks; i++)
          ==> old obj, new geo, OOB
    mempool_free(r10_bio, conf->r10bio_pool)
          ==> old-geometry obj freed into new pool

so .. fix by reorder the flow:

	free_r10bio(r10_bio)
	allow_barrier(conf)
	bio_endio(master_bio)

raid_end_discard_bio() is exactly the same.

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/raid10.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index db68fcc9e9be..d77f60db7660 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -329,24 +329,27 @@ static void reschedule_retry(struct r10bio *r10_bio)
  */
 static void raid_end_bio_io(struct r10bio *r10_bio)
 {
 	struct bio *bio = r10_bio->master_bio;
 	struct r10conf *conf = r10_bio->mddev->private;
+	unsigned long state = r10_bio->state;
+	bool returned;
 
-	if (!test_and_set_bit(R10BIO_Returned, &r10_bio->state)) {
-		if (!test_bit(R10BIO_Uptodate, &r10_bio->state))
-			bio->bi_status = BLK_STS_IOERR;
+	returned = test_and_set_bit(R10BIO_Returned, &state);
+	if (!returned && !test_bit(R10BIO_Uptodate, &state))
+		bio->bi_status = BLK_STS_IOERR;
+
+	free_r10bio(r10_bio);
+
+	if (!returned)
 		bio_endio(bio);
-	}
 
 	/*
 	 * Wake up any possible resync thread that waits for the device
 	 * to go idle.
 	 */
 	allow_barrier(conf);
-
-	free_r10bio(r10_bio);
 }
 
 /*
  * Update disk head position estimator based on IRQ completion info.
  */
@@ -1579,13 +1582,15 @@ static void raid_end_discard_bio(struct r10bio *r10bio)
 		if (!test_bit(R10BIO_Discard, &r10bio->state)) {
 			first_r10bio = (struct r10bio *)r10bio->master_bio;
 			free_r10bio(r10bio);
 			r10bio = first_r10bio;
 		} else {
+			struct bio *master_bio = r10bio->master_bio;
+
 			md_write_end(r10bio->mddev);
-			bio_endio(r10bio->master_bio);
 			free_r10bio(r10bio);
+			bio_endio(master_bio);
 			break;
 		}
 	}
 }
 
-- 
2.54.0
