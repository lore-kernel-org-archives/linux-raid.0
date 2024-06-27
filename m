Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A71208D7
	for <linux-raid@vger.kernel.org>; Thu, 27 Jun 2024 05:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719466690; cv=none; b=iD5QWgmNQZVwar8hFLMKe/UKdsL4Ma6hfcE4Mgk5ZDONrTh+pTx4j+qEzxp6w1VeeaE6PkZpJ+jfoMobAgh+MlhRXbUPVr0phVU+hHPNpzI87Rf59c+U7SVvFSTsDLXXPlabtc5nnvAbmrUNGbcHPKFQMddFjT8XowyVrQYYMz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719466690; c=relaxed/simple;
	bh=GRwwIUv7iJ4RGfsC5B7yAmmFNjTilNGDhcyS8UU57ws=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tCUxTdwspLt+H39lR58nE17rjeAswnh9sU2YoFTSA3egfNtQ+KdoXJWchzssUZBzbQizbHOOTXyuCU2fOdbRi8Fnhxp3hjp2uMEh+HfeoTY/er3H2TRuf7fWqUjkjpATRhUbpQijM0kdQwDmcbe7My8dZoABKg5wkZuDHuPaUJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VJNgHR8o; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VJNgHR8o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719466687;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=IQXPRaEuCKaEc6wEFYfrhP1Ewc0GJ9CX9f19YAbzYvE=;
	b=VJNgHR8oZj5ByTCK3mfE9v+emyqZmrT71R0lWSsBIk6TNKzNgOdyuahfjbepKUVulRLuwk
	vUcTHKWhFmvYVqfHjCg3T2dgM3/naZEr6CUg86Ygc7rj96Li1Bo9VpHIx1CWhf50RPfXx+
	ygbu41kiYZq+HRsx2rIvKUxYmEjhC3U=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-628-nsi0vKbaMCiIRI5dBJWsLg-1; Thu,
 27 Jun 2024 01:38:04 -0400
X-MC-Unique: nsi0vKbaMCiIRI5dBJWsLg-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 37C7619560B8;
	Thu, 27 Jun 2024 05:38:02 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6EF2619560B2;
	Thu, 27 Jun 2024 05:38:01 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 45R5c05O1438653
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 27 Jun 2024 01:38:00 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 45R5bwcQ1438652;
	Thu, 27 Jun 2024 01:37:58 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>
Cc: Heinz Mauelshagen <heinzm@redhat.com>, Xiao Ni <xni@redhat.com>,
        linux-raid@vger.kernel.org
Subject: [PATCH] md/raid5: recheck if reshape has finished with device_lock held
Date: Thu, 27 Jun 2024 01:37:58 -0400
Message-ID: <20240627053758.1438644-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

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

Fix this by rechecking if the reshape has finished after grabbing the
device_lock.

Fixes: fef9c61fdfabf ("md/raid5: change reshape-progress measurement to cope with reshaping backwards.")
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/raid5.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 547fd15115cd..65d9b1ca815c 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5923,15 +5923,17 @@ static enum stripe_result make_stripe_request(struct mddev *mddev,
 		 * to check again.
 		 */
 		spin_lock_irq(&conf->device_lock);
-		if (ahead_of_reshape(mddev, logical_sector,
-				     conf->reshape_progress)) {
-			previous = 1;
-		} else {
+		if (conf->reshape_progress != MaxSector) {
 			if (ahead_of_reshape(mddev, logical_sector,
-					     conf->reshape_safe)) {
-				spin_unlock_irq(&conf->device_lock);
-				ret = STRIPE_SCHEDULE_AND_RETRY;
-				goto out;
+					     conf->reshape_progress)) {
+				previous = 1;
+			} else {
+				if (ahead_of_reshape(mddev, logical_sector,
+						     conf->reshape_safe)) {
+					spin_unlock_irq(&conf->device_lock);
+					ret = STRIPE_SCHEDULE_AND_RETRY;
+					goto out;
+				}
 			}
 		}
 		spin_unlock_irq(&conf->device_lock);
-- 
2.43.5

