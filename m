Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A716E7710B
	for <linux-raid@vger.kernel.org>; Wed, 22 May 2024 08:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716367891; cv=none; b=VnLMjDg2/IzcPwWGv46x4bKuXp/YGeqhH4vSqGt4yRBXUtHm+n/G0sOAD5VzQBjCvbMIwiTsOQaZSJOpKKFjnL8xzhdR8BQiF6CchPtbbY+3cX8JIKhEaAgW7K6w1SMkHHd3eSiD3W7EZlhjU9a6XuNJrSy9EJwFXx99WhecaOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716367891; c=relaxed/simple;
	bh=l1SrnFwW2KxS5mD6g+skSmicK6eIG9bR9r2+aSCCvMg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UkUST+ypjnUFXHaWcYyguTb4/6EkU3A05eopSgzO16xoHz0hExiJnM5uW0TD9m0oaAbnRkCPpihWB1xlsOT0VeR6CNcrcrOg/15Ep2qoycwUPpvJx4p+IBPf0LChrw6W8+Xz5muWWLyQGzCXqZbFnp/MC6u60n1sGrvuSSgEL5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FVpnwfYg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FVpnwfYg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716367888;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QOTPAR2efWEZLNazphRhIdUyjx0OPUZCG46N8d4Dje8=;
	b=FVpnwfYgarKmIWsi9eus4oLOqZinz4B0ghRr6qKCt4SF0kjoHIxeRXCv2Gb9s/jo2BelwZ
	JPOGYvz6md0ZsX8/h/MOeKq3YZziXjw+jYqL3s+3Z8s77ClyLVriMqkVIqqb06wMozcZ49
	b1NWp0L73QgPr4+lzd8GXatz6jLR2Qg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-591-0tt_Tic1PLCZ5WGYqD3YGg-1; Wed, 22 May 2024 04:51:24 -0400
X-MC-Unique: 0tt_Tic1PLCZ5WGYqD3YGg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6844C81227E;
	Wed, 22 May 2024 08:51:24 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.11])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3411EC15BB9;
	Wed, 22 May 2024 08:51:21 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: linux-raid@vger.kernel.org,
	heinzm@redhat.com,
	ncroxon@redhat.com
Subject: [PATCH 08/19] mdadm/tests 03r0assem enhance
Date: Wed, 22 May 2024 16:50:45 +0800
Message-Id: <20240522085056.54818-9-xni@redhat.com>
In-Reply-To: <20240522085056.54818-1-xni@redhat.com>
References: <20240522085056.54818-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

dcc22ae74a864 ('super1: remove support for name= in config') already
removes name= support. So remove related test codes in 03r0assem.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 tests/03r0assem | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/tests/03r0assem b/tests/03r0assem
index f7c29e8c1ab6..4bf8b9e83b0f 100644
--- a/tests/03r0assem
+++ b/tests/03r0assem
@@ -33,16 +33,6 @@ mdadm -As -c $conf $md2
 $tst
 mdadm -S $md2
 
-{
-  echo DEVICE $devlist
-  echo array $md2 name=2
-} > $conf
-
-mdadm -As -c $conf $md2
-$tst
-mdadm -S $md2
-
-
 {
   echo DEVICE $devlist
   echo array $md2 devices=$dev0,$dev1,$dev2
-- 
2.32.0 (Apple Git-132)

