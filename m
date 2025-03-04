Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E60E1F4606
	for <linux-raid@vger.kernel.org>; Tue,  4 Mar 2025 09:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741079403; cv=none; b=BYOqQ8h15sLZ4t2DnnW6fCkPCypYphoZtXgw5Uc3X7BMFC7gafexanI62NyOqDV1MnXNqK78JM5OMWwZ8mla6xCX0w/4DLxsGlJFU+9gXwFXCaTNY5Pk7XKBlON3KilDhvlHis3+9ZH/mBa6ILEso1m79if9pgNZnC+JQQHYscw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741079403; c=relaxed/simple;
	bh=c4wndwfYUSYBao/qig/qOqAIJZClq6F3Q6qDHvPN8/A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=q4e/kur0JX3aLdZx8QSnIf0QjSsVpU4yUMj0k8XAMPLL8+2JyII+KIYW6TNVOQ8ySAN4QMdU81/AaUjDA0CJlY8byks8YnfKKtettqpe5jem584K1/lAhbaAVdnkWw9Uai54TVsK0d2Dyb/E9FkDmFzrWFMv4MNDvs/X/jOqeRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZBgxjsgU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZBgxjsgU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741079400;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=JmYhVAgk6O5Bd101jcAK3Nd3EniwSfHFkLrGemAy7QY=;
	b=ZBgxjsgUaAt/DhBuZy6HyqTG/w1Zj53iZPbbcBM2kdsaYDnh5jmkZXhIT9rnAokRqWlW/o
	1gz2qEaC218lNJ61xMCJzD72iV0WF5b7pSVWKt7TGHbG6Mj7gYRuhU324GFJjQnib9NnX7
	lif08V/8riDcBUr3VlXK3Gy82BmxAKA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-626-8r32FQDBN7KLFeiGcaz9Cw-1; Tue,
 04 Mar 2025 04:09:57 -0500
X-MC-Unique: 8r32FQDBN7KLFeiGcaz9Cw-1
X-Mimecast-MFC-AGG-ID: 8r32FQDBN7KLFeiGcaz9Cw_1741079396
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BD13F1954B21;
	Tue,  4 Mar 2025 09:09:55 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.5])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 28F5E1800367;
	Tue,  4 Mar 2025 09:09:52 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: yukuai1@huaweicloud.com,
	song@kernel.org
Subject: [PATCH 1/1] md/raid10: Don't print warn calltrace for discard with REQ_NOWAIT
Date: Tue,  4 Mar 2025 17:09:50 +0800
Message-Id: <20250304090950.18337-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

There is no need to print warn call trace. And it also can confuse
qe and mark test case failure.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/raid10.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 15b9ae5bf84d..0441691130c7 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1631,7 +1631,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
 		return -EAGAIN;
 
-	if (WARN_ON_ONCE(bio->bi_opf & REQ_NOWAIT)) {
+	if (bio->bi_opf & REQ_NOWAIT) {
 		bio_wouldblock_error(bio);
 		return 0;
 	}
-- 
2.32.0 (Apple Git-132)

