Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19FAB81AB4
	for <linux-raid@vger.kernel.org>; Fri, 19 Jul 2024 09:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721382794; cv=none; b=imrqOMKbHolLDAEmZZbhO3d0agZtfvO5KpWaRo45Ph5WPFGSSCyzYwQ5qq+RMobU5cNRWu95c92sXxBRckEbz+/dZa39eYNeq7Wa9kChHw6ZlbdqwH0oTSHeNsKhpI0qBKOpi2nhVOwDUgMKCss1zAUqLhZ6KU3dYyHL2vkS+fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721382794; c=relaxed/simple;
	bh=+Gpbcoblu2LLOBZ7uPxh56hc3wjq37XPSQVTKpMohes=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CEnHdmOeleS9o0evtCoZDHMKt7tYq0u5yQHIBuYy9AVdjJe8skX8S34orNU/GxAFiAk4aZL5TiD2dbwvFe1NFXcMvrT5NxFJSm6dSI0hMungghWQMXvOe0EEYGDoQJ35EHh4luPBKKmQsePeos0b9gbz74yboPRED5VUEhxwx5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JG6T7m8i; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JG6T7m8i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721382792;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Nf5NChEWcNeYOC6BMAgvpWlkiDxDM3s9rHFFm4FX7WY=;
	b=JG6T7m8iyFEJoxoeHu2e7lRxql/a7qB4XS4GSIE1jZx8Ig+6+VuwfBeRJYmsOG3YD/KLJy
	kAhhObDg6ew2VbMlu8jVO4Oc4Kr04pqEHNvazub+2gMJ8tdls2/Rd2chNP81TfOrBnv9Zi
	u8nS39AZ2tNDsCdRFq634FGcLypUyHc=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-106-GuVSgv1xPLuC3qjWt6SWAQ-1; Fri,
 19 Jul 2024 05:53:08 -0400
X-MC-Unique: GuVSgv1xPLuC3qjWt6SWAQ-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E15391955D55;
	Fri, 19 Jul 2024 09:53:07 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.6])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5C10D19560B2;
	Fri, 19 Jul 2024 09:53:04 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 12/14] mdadm/super1: fix coverity issue DEADCODE
Date: Fri, 19 Jul 2024 17:52:17 +0800
Message-Id: <20240719095219.9705-13-xni@redhat.com>
In-Reply-To: <20240719095219.9705-1-xni@redhat.com>
References: <20240719095219.9705-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

optimal_space is at most 2046. So space can't be larger than UINT16_MAX.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 super1.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/super1.c b/super1.c
index 4e4c7bfd..24bc1026 100644
--- a/super1.c
+++ b/super1.c
@@ -1466,8 +1466,6 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
 						__le32_to_cpu(sb->chunksize));
 			if (space > optimal_space)
 				space = optimal_space;
-			if (space > UINT16_MAX)
-				space = UINT16_MAX;
 		}
 
 		sb->ppl.offset = __cpu_to_le16(offset);
-- 
2.41.0

