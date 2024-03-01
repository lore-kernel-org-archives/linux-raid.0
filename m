Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617186BFDE
	for <linux-raid@vger.kernel.org>; Fri,  1 Mar 2024 15:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709306516; cv=none; b=RLZUegsqLSWhiBczmJfRRk0nN02Ae+7jqc6lDIb4136gUxQBVB2BB4Rt2BSLj7Lfd4d6Px+I/fw9Idj0MTD84lBeNX81ZAGuJ0TeZAR5B0PDkZfCubvoR7rTjtivHs6qWZObicHYwMJPr66zF1JiLghrDatxW+k7IhAw0YE1Etw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709306516; c=relaxed/simple;
	bh=6e+1jXXtCepzK8hrhCWjn2kM/sSuASqeVbE240TKykY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Rb5jTs+xLyWWbs3ODcnWkmAZRDG6c9zfWdWsjgQ2DV8nFfrhnVqSWP9IksEJ2GujpEG3SARZ/j0M8+HdJTfI7VFcduJfad8R7z4hyZUCUghtEkUU3vrHaS+iffRaU665Cq67oGamoiR1QBBryykSfEvt1PLxJa5XSlcX3DFMAMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AA+pijMB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AA+pijMB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709306514;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=69y1pCQHT5Ls9fEh8AKza2wRDYR+w4p2us5TEx1Nugk=;
	b=AA+pijMBL5JA+AR/NHXQUd1sb8TxJ8IGR7iP4NEVhlAdxYL05VRe3MnA6R2rmoZEx5g3Yl
	ZRj/GRaWDDCrHFijn4bKvUuNqkErFt+CTEGhi9GT8yyvFwPRx9MbPDnmGSfcg2LWBpnIrd
	ehmTN5Wj6DAY+k5SKCpsnYhZOtlVpbs=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-314-hYSBQMa6OL64K-R_5dIP5Q-1; Fri,
 01 Mar 2024 10:21:52 -0500
X-MC-Unique: hYSBQMa6OL64K-R_5dIP5Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 142BC1C05EB7;
	Fri,  1 Mar 2024 15:21:51 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.8])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5AB051121312;
	Fri,  1 Mar 2024 15:21:47 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: song@kernel.org
Cc: yukuai1@huaweicloud.com,
	bmarzins@redhat.com,
	heinzm@redhat.com,
	snitzer@kernel.org,
	ncroxon@redhat.com,
	linux-raid@vger.kernel.org,
	dm-devel@lists.linux.dev
Subject: [PATCH 4/4] md/raid5: Don't check crossing reshape when reshape hasn't started
Date: Fri,  1 Mar 2024 23:21:28 +0800
Message-Id: <20240301152128.13465-5-xni@redhat.com>
In-Reply-To: <20240301152128.13465-1-xni@redhat.com>
References: <20240301152128.13465-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

stripe_ahead_of_reshape is used to check if a stripe region cross the
reshape position. So first, change the function name to
stripe_across_reshape to describe the usage of this function.

For reshape backwards, it starts reshape from the end of array and conf->
reshape_progress is init to raid5_size. During reshape, if previous is true
(set in make_stripe_request) and max_sector >= conf->reshape_progress, ios
should wait until reshape window moves forward. But ios don't need to wait
if max_sector is raid5_size.

And put the conditions into the function directly to make understand the
codes easily.

This can be reproduced easily by lvm2 test shell/lvconvert-raid-reshape.sh
For dm raid reshape, before starting sync thread, it needs to reload table
some times. In one time dm raid uses MD_RECOVERY_WAIT to delay reshape and
it doesn't start sync thread this time. Then one io comes in and it waits
because stripe_ahead_of_reshape returns true because it's a backward
reshape and max_sectors > conf->reshape_progress. But the reshape hasn't
started. So skip this check when reshape_progress is raid5_size

Fixes: 486f60558607 ("md/raid5: Check all disks in a stripe_head for reshape progress")
Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/raid5.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 4c1f572cc00f..8d562c1344f4 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5832,17 +5832,12 @@ static bool ahead_of_reshape(struct mddev *mddev, sector_t sector,
 					  sector >= reshape_sector;
 }
 
-static bool range_ahead_of_reshape(struct mddev *mddev, sector_t min,
-				   sector_t max, sector_t reshape_sector)
-{
-	return mddev->reshape_backwards ? max < reshape_sector :
-					  min >= reshape_sector;
-}
-
-static bool stripe_ahead_of_reshape(struct mddev *mddev, struct r5conf *conf,
+static sector_t raid5_size(struct mddev *mddev, sector_t sectors, int raid_disks);
+static bool stripe_across_reshape(struct mddev *mddev, struct r5conf *conf,
 				    struct stripe_head *sh)
 {
 	sector_t max_sector = 0, min_sector = MaxSector;
+	sector_t reshape_pos = 0;
 	bool ret = false;
 	int dd_idx;
 
@@ -5856,9 +5851,12 @@ static bool stripe_ahead_of_reshape(struct mddev *mddev, struct r5conf *conf,
 
 	spin_lock_irq(&conf->device_lock);
 
-	if (!range_ahead_of_reshape(mddev, min_sector, max_sector,
-				     conf->reshape_progress))
-		/* mismatch, need to try again */
+	reshape_pos = conf->reshape_progress;
+	if (mddev->reshape_backwards) {
+		if (max_sector >= reshape_pos &&
+		    reshape_pos != raid5_size(mddev, 0, 0))
+			ret = true;
+	} else if (min_sector < reshape_pos)
 		ret = true;
 
 	spin_unlock_irq(&conf->device_lock);
@@ -5969,7 +5967,7 @@ static enum stripe_result make_stripe_request(struct mddev *mddev,
 	}
 
 	if (unlikely(previous) &&
-	    stripe_ahead_of_reshape(mddev, conf, sh)) {
+	    stripe_across_reshape(mddev, conf, sh)) {
 		/*
 		 * Expansion moved on while waiting for a stripe.
 		 * Expansion could still move past after this
-- 
2.32.0 (Apple Git-132)

