Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8A7176AAD
	for <linux-raid@vger.kernel.org>; Fri, 26 Jul 2024 07:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721978110; cv=none; b=Xb3c97XFhgggelueuxjNBZsvmZ66pJlVK4bDhpYemAaF5sGBvkC5Z2IgE6oSqNfcHsMrJlhH9jmgONRSz/FIVcdeAqxQwhlOINuIbqWEY8FWHMbUSaG7bR3ymZ04Xy3N6ryCl+Dy60oeZ/cJvXNdLjaxqI87aheopLPkIyUhUjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721978110; c=relaxed/simple;
	bh=Cvj3SZRkZWRMk2KNF6HndE2+4OaQ32KB0X0Y1vD/PkM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iBxdlGyw8sbZYaqyQKIvxnDTWI48aRVDgywREz81F5rI/1CLee4RKgwhpUrIcTW5kUQB2KZ9xnGSBBRHDtvYBCeYaoo5EvG/11ELLT4Hp1p28uE2XzvlWI6DT5uIheYTFHIdaVbSrGmcfkpFHtJ/GvEwJ2KICMGH5/plQ1t1Jqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SPrM53K2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SPrM53K2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721978107;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eZSXHtXZkTZMVa/stIcI/tq71/f1YuLWNTUXuCFojS8=;
	b=SPrM53K24wpIRTbrKPAT9JmUX1JPeto6moj8iZgnkYCjeXk79XoNgNYF+gbfpH2lAvGMQH
	jAscJ4ctCsPBcVDlmkq7uP6XqfuuVZKQQNN3otQvAdxeUPbJ/sLmnOfuLDT2MBZYzsDiZj
	C9i5Jy7qXQM68pxJrpp/DhRkgsRIXUI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-171-B3pUK2goN_WxdAZZGXZRrw-1; Fri,
 26 Jul 2024 03:15:04 -0400
X-MC-Unique: B3pUK2goN_WxdAZZGXZRrw-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3E2371955D4D;
	Fri, 26 Jul 2024 07:15:03 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.28])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8918519560AE;
	Fri, 26 Jul 2024 07:15:00 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 12/14] mdadm/super1: fix coverity issue DEADCODE
Date: Fri, 26 Jul 2024 15:14:14 +0800
Message-Id: <20240726071416.36759-13-xni@redhat.com>
In-Reply-To: <20240726071416.36759-1-xni@redhat.com>
References: <20240726071416.36759-1-xni@redhat.com>
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
index 4e4c7bfd15ae..24bc10269dbf 100644
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
2.32.0 (Apple Git-132)

