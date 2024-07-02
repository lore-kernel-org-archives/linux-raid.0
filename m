Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A02E1BA868
	for <linux-raid@vger.kernel.org>; Tue,  2 Jul 2024 15:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719933493; cv=none; b=MXdThL0Lny7NY5zymXjCwVyVJLLE88OA7gINwDpL2ydvI/0EhDalG/J3A65NRiK1ZRODPeLBanXLi2zIg8yD/HOL0gyqOZfeks/D2ZUOoByr+zAGbk47ixeRMHYim9HtW0CVPwvrrPifLI8DEk3eXQuYFfkM5xTTfc0C5EWqYME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719933493; c=relaxed/simple;
	bh=aesM+PUFYzdZBWj7sTS8BvhAcPmlNyfCL2YdytTAxMs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bkNrp+V/vQN1DXALzGh8Kf48xA4Asn48wCK6O0yhUEWH77TRCSQNV/2OX25nCIgN+/z2heoPvIgWPgbhxzm2aNoUGsX3Ims7liVt6WAebxhvTanUwJnYba6WHcdKGzszIdUPQOFrjfsG2K2PrfJRXGOzSySrsjhyAmGKhQfV0dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NBwhKliy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NBwhKliy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719933490;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=RpM2vQNkwU3U8d98bepdipfbdTm8vS8gP0zCrL0z9nM=;
	b=NBwhKliyTinwiB6j6e2aT5wpILDEBDUBPi9YlbkFa22Ess2dZC1caC3jG4+zBVrP+310nN
	KgGxzrOjbp3J2O924wNtSwFWAD3AtHalr+GdtmDwsf07LBBCKGZcBKLjIq3Lg4sfnw3yC8
	Wjhc0Y40Jji6lJbbjzQIVcymEvtmb7U=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-288-gIWr_M2JNl-Mfq-X-gwyTg-1; Tue,
 02 Jul 2024 11:18:07 -0400
X-MC-Unique: gIWr_M2JNl-Mfq-X-gwyTg-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B5EF71944D3C;
	Tue,  2 Jul 2024 15:18:05 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D99F63000229;
	Tue,  2 Jul 2024 15:18:04 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 462FI3KS1632019
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 2 Jul 2024 11:18:03 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 462FI2I31632018;
	Tue, 2 Jul 2024 11:18:02 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>
Cc: Heinz Mauelshagen <heinzm@redhat.com>, Xiao Ni <xni@redhat.com>,
        linux-raid@vger.kernel.org
Subject: [PATCH v2] md/raid5: recheck if reshape has finished with device_lock held
Date: Tue,  2 Jul 2024 11:18:02 -0400
Message-ID: <20240702151802.1632010-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

When handling an IO request, MD checks if a reshape is currently
happening, and if so, where the IO sector is in relation to the reshape
progress. MD uses conf->reshape_progress for both of these tasks.  When
the reshape finishes, conf->reshape_progress is set to MaxSector.  If
this occurs after MD checks if the reshape is currently happening but
before it calls ahead_of_reshape(), then ahead_of_reshape() will end up
comparing the IO sector against MaxSector. During a backwards reshape,
this will make MD think the IO sector is in the area not yet reshaped,
causing it to use the previous configuration, and map the IO to the
sector where that data was before the reshape.

This bug can be triggered by running the lvm2
lvconvert-raid-reshape-linear_to_raid6-single-type.sh test in a loop,
although it's very hard to reproduce.

Fix this by factoring the code that checks where the IO sector is in
relation to the reshape out to a helper called get_reshape_loc(),
which reads reshape_progress and reshape_safe while holding the
device_lock, and then rechecks if the reshape has finished before
calling ahead_of_reshape with the saved values.

Also use the helper during the REQ_NOWAIT check to see if the location
is inside of the reshape region.

Fixes: fef9c61fdfabf ("md/raid5: change reshape-progress measurement to cope with reshaping backwards.")
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
Changes in v2:
  - factor the code that checks where the IO sector is in
    relation to the reshape out to a helper function, and also call this
    for the REQ_NOWAIT check.

 drivers/md/raid5.c | 64 +++++++++++++++++++++++++++++-----------------
 1 file changed, 41 insertions(+), 23 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 547fd15115cd..232c489f8c86 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5899,6 +5899,39 @@ static int add_all_stripe_bios(struct r5conf *conf,
 	return ret;
 }
 
+enum reshape_loc {
+	LOC_NO_RESHAPE,
+	LOC_AHEAD_OF_RESHAPE,
+	LOC_INSIDE_RESHAPE,
+	LOC_BEHIND_RESHAPE,
+};
+
+static enum reshape_loc get_reshape_loc(struct mddev *mddev,
+		struct r5conf *conf, sector_t logical_sector)
+{
+	sector_t reshape_progress, reshape_safe;
+	/*
+	 * Spinlock is needed as reshape_progress may be
+	 * 64bit on a 32bit platform, and so it might be
+	 * possible to see a half-updated value
+	 * Of course reshape_progress could change after
+	 * the lock is dropped, so once we get a reference
+	 * to the stripe that we think it is, we will have
+	 * to check again.
+	 */
+	spin_lock_irq(&conf->device_lock);
+	reshape_progress = conf->reshape_progress;
+	reshape_safe = conf->reshape_safe;
+	spin_unlock_irq(&conf->device_lock);
+	if (reshape_progress == MaxSector)
+		return LOC_NO_RESHAPE;
+	if (ahead_of_reshape(mddev, logical_sector, reshape_progress))
+		return LOC_AHEAD_OF_RESHAPE;
+	if (ahead_of_reshape(mddev, logical_sector, reshape_safe))
+		return LOC_INSIDE_RESHAPE;
+	return LOC_BEHIND_RESHAPE;
+}
+
 static enum stripe_result make_stripe_request(struct mddev *mddev,
 		struct r5conf *conf, struct stripe_request_ctx *ctx,
 		sector_t logical_sector, struct bio *bi)
@@ -5913,28 +5946,14 @@ static enum stripe_result make_stripe_request(struct mddev *mddev,
 	seq = read_seqcount_begin(&conf->gen_lock);
 
 	if (unlikely(conf->reshape_progress != MaxSector)) {
-		/*
-		 * Spinlock is needed as reshape_progress may be
-		 * 64bit on a 32bit platform, and so it might be
-		 * possible to see a half-updated value
-		 * Of course reshape_progress could change after
-		 * the lock is dropped, so once we get a reference
-		 * to the stripe that we think it is, we will have
-		 * to check again.
-		 */
-		spin_lock_irq(&conf->device_lock);
-		if (ahead_of_reshape(mddev, logical_sector,
-				     conf->reshape_progress)) {
-			previous = 1;
-		} else {
-			if (ahead_of_reshape(mddev, logical_sector,
-					     conf->reshape_safe)) {
-				spin_unlock_irq(&conf->device_lock);
-				ret = STRIPE_SCHEDULE_AND_RETRY;
-				goto out;
-			}
+		enum reshape_loc loc = get_reshape_loc(mddev, conf,
+						       logical_sector);
+		if (loc == LOC_INSIDE_RESHAPE) {
+			ret = STRIPE_SCHEDULE_AND_RETRY;
+			goto out;
 		}
-		spin_unlock_irq(&conf->device_lock);
+		if (loc == LOC_AHEAD_OF_RESHAPE)
+			previous = 1;
 	}
 
 	new_sector = raid5_compute_sector(conf, logical_sector, previous,
@@ -6112,8 +6131,7 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
 	/* Bail out if conflicts with reshape and REQ_NOWAIT is set */
 	if ((bi->bi_opf & REQ_NOWAIT) &&
 	    (conf->reshape_progress != MaxSector) &&
-	    !ahead_of_reshape(mddev, logical_sector, conf->reshape_progress) &&
-	    ahead_of_reshape(mddev, logical_sector, conf->reshape_safe)) {
+	    get_reshape_loc(mddev, conf, logical_sector) == LOC_INSIDE_RESHAPE) {
 		bio_wouldblock_error(bi);
 		if (rw == WRITE)
 			md_write_end(mddev);
-- 
2.45.0

