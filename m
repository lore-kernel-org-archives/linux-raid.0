Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3CC20012D
	for <linux-raid@vger.kernel.org>; Tue,  4 Mar 2025 10:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741084934; cv=none; b=NN+PjU5P9E+xL4Pw/kBOdZWobekt5VzyLAkxkQl0wbESLgvGS07wkd9kSkeoQfBsoYXNX9D8EpT+vsrMwxxNow9M2kQYUu14Vl18z5EZXGyGppjDyx8kfDRjwk6i2MgHry6HcWL5gr8oheX5rBXgAWQHKfz9dDMKQR270Rhl+fM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741084934; c=relaxed/simple;
	bh=AHIdZgwP57EFIOkFHCaA1spAQ7mzjEdTYg14sw2GCm4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=a45xtLsSKy+Q3e3FLh6aqBg5y2RfX5iANOffjJ868B+UAVYWpaiojTtahtKSowSojYxoqyCyH1A22P4aUsZ6YiBqzVjG0+KA6H2pBWiMLo/GanQBgxrs9Cl7Nwq2Tw6xalrSEnXDQnBU65HQUQV944BF+48R1uAeBIcyaGwiP38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Cno4RNr/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cno4RNr/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741084931;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=rjgAQQAq7IFcFk3yFzCQOhI4D/mTw6O0ABSzniSQAAA=;
	b=Cno4RNr/+cWfBKGq9VQvEoO6aoCjpEz8um3FIB9zjQ3P//UZ2JZa5hKYLBzWzIlTQkHgru
	h+/00W3v2Lnk/IBGS2VRlzpsqP9HJP9Q38atr2EbphDxTQ+MUepL2ZaPbk2mL06SlaEgKg
	meF4Eon15mTQZLX1pAOKdGnCvQD1T1s=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-537-0eSN7a5fO3akrXKf_WpsNw-1; Tue,
 04 Mar 2025 05:42:08 -0500
X-MC-Unique: 0eSN7a5fO3akrXKf_WpsNw-1
X-Mimecast-MFC-AGG-ID: 0eSN7a5fO3akrXKf_WpsNw_1741084927
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 569DD180087F;
	Tue,  4 Mar 2025 10:42:06 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.5])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A913E1800368;
	Tue,  4 Mar 2025 10:42:02 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: yukuai1@huaweicloud.com,
	song@kernel.org,
	pmenzel@molgen.mpg.de
Subject: [PATCH 1/1] md/raid10: wait barrier before returning discard request with REQ_NOWAIT
Date: Tue,  4 Mar 2025 18:41:59 +0800
Message-Id: <20250304104159.19102-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

raid10_handle_discard should wait barrier before returning a discard bio
which has REQ_NOWAIT. And there is no need to print warning calltrace
if a discard bio has REQ_NOWAIT flag. Quality engineer usually checks
dmesg and reports error if dmesg has warning/error calltrace.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
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

