Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489A520B807
	for <linux-raid@vger.kernel.org>; Thu,  6 Mar 2025 09:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741254592; cv=none; b=nyi5rTQ5jVwR/75BZ4e+VYSQmxVcrW51TRdXNV2vvjhpn5n/MeWvqZmj3g1N8CNVypkLy+3jiGSCq7YspanhAb8cySCqx6gDscu/swUkLYXehoTPBcWMjvWyIAOStM/4W+MoV+B1GiPlo4Ek2AhUUaYatLv16VcmekPE4jw8TB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741254592; c=relaxed/simple;
	bh=DF9hJnV55sgA+C+wts/rF6A16f/69FOkWabQOPFLi5g=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=llObfGG+5c7DEwbIqSMMOCJ0Mwwr8JZEt3/CbiIQeHGVHF0BtPQNAJFChmUUz7oVPRJ0Sv2fLpmcwRTnOUpKNu6HHz3ZZd3Unv4Ohfk7y81ss9g3kEuaaQ3WYxdkpIDsFrOnbUOt+kbBufatgvSA3mP49EZyhlXqe2YFMzERYss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MMJKZPWR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MMJKZPWR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741254589;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=5HfmI44aAG5Icr4A/oDPQl3F80DUXEitMHbyXaa5f4A=;
	b=MMJKZPWRNEDkisD8nceK6bPz+VQbn2KOqYcXLKkI/NBSuPrpkmS7STF9lfMFKM/wsR4nq3
	fgBBkbZNwq48jHhJM69G5cCbo/58aV9YCJMlPMVPWKNrdqich516vdhYN9Zp4BwFL1FpGi
	eZ0YZjoy8JV41BlOKqojmWuSKnJ/aME=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-694-U6vDEdA5NQyTkJpQO_hGHQ-1; Thu,
 06 Mar 2025 04:49:47 -0500
X-MC-Unique: U6vDEdA5NQyTkJpQO_hGHQ-1
X-Mimecast-MFC-AGG-ID: U6vDEdA5NQyTkJpQO_hGHQ_1741254586
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 83554180035C;
	Thu,  6 Mar 2025 09:49:45 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.5])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B6D0B1955DCE;
	Thu,  6 Mar 2025 09:49:41 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: yukuai1@huaweicloud.com,
	song@kernel.org,
	pmenzel@molgen.mpg.de
Subject: [PATCH md-6.15 V2 1/1] md/raid10: wait barrier before returning discard request with REQ_NOWAIT
Date: Thu,  6 Mar 2025 17:49:38 +0800
Message-Id: <20250306094938.48952-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

raid10_handle_discard should wait barrier before returning a discard bio
which has REQ_NOWAIT. And there is no need to print warning calltrace
if a discard bio has REQ_NOWAIT flag. Quality engineer usually checks
dmesg and reports error if dmesg has warning/error calltrace.

Fixes: c9aa889b035f ("md: raid10 add nowait support")
Signed-off-by: Xiao Ni <xni@redhat.com>
---
v2: add target version in title and add Fixes tag
 drivers/md/raid10.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 15b9ae5bf84d..7bbc04522f26 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1631,11 +1631,10 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
 		return -EAGAIN;
 
-	if (WARN_ON_ONCE(bio->bi_opf & REQ_NOWAIT)) {
+	if (!wait_barrier(conf, bio->bi_opf & REQ_NOWAIT)) {
 		bio_wouldblock_error(bio);
 		return 0;
 	}
-	wait_barrier(conf, false);
 
 	/*
 	 * Check reshape again to avoid reshape happens after checking
-- 
2.32.0 (Apple Git-132)

