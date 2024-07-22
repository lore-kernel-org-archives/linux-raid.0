Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5A25464A
	for <linux-raid@vger.kernel.org>; Mon, 22 Jul 2024 08:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721636280; cv=none; b=cxxKM3ap+/UFi7PXotPQSssEzHaI7jffos59eGB7a1HLlx4/jjUywR7gERdEpxMY8KZ+i02KYKbMBsqmUn6iHLeqLXWhlQRTZiOTpnDIIzy3zlKaN/XVjyYsL7UWFk7bxg4naZSgx5dahonyRs4zbR1M1qApFw1JaGaXZtpQFN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721636280; c=relaxed/simple;
	bh=c36vCTbwrF9rX4plDMGJn3X+5791M4h1noRCP4aecIs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cWjaPb73B3r9NDZP9BZanOAuVUbqLTVR9kTfWIqstXY32+TV7Pz+qMuw9Sh6FC0O7Vm2UtU01N8xX9EwFmMZV0ru8a2wrTF5rjnds5iGc+VFHf63WBEGqPiRtZb/bpe66IOHXAdTc01M5HlS6lyxWNuD1qeKZe4mTYT89sX4YKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PAI57SpT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PAI57SpT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721636277;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2cAOKzuiAcBzhJEfbkuSCYA+q7l23ZLHLZ0psMBndc0=;
	b=PAI57SpTC/FbJ6sI5XA77W8CjcDVheXHLMVSQebo+yXbTd0aqx8bPJuo+1R6JDWly6KkWT
	tzTK9+gLkJtdKT62OzfCoCT7Wdh7Pw3D4GVvD7N7ioz4DUjrfcUM5KKZZWyyd8m7IJTvPY
	uVCnDUqR+mzT6OtjAVdJbT5UBC46f70=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-519-PBNqvudZNraonCd7FI_mKg-1; Mon,
 22 Jul 2024 04:17:55 -0400
X-MC-Unique: PBNqvudZNraonCd7FI_mKg-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BC8DA1955BF1;
	Mon, 22 Jul 2024 08:17:54 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.7])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 62B00195605A;
	Mon, 22 Jul 2024 08:17:50 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 3/3] mdadm/Grow: fix coverity issue STRING_OVERFLOW
Date: Mon, 22 Jul 2024 16:17:25 +0800
Message-Id: <20240722081736.20439-4-xni@redhat.com>
In-Reply-To: <20240722081736.20439-1-xni@redhat.com>
References: <20240722081736.20439-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Fix string overflow problems in Grow.c

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 Grow.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Grow.c b/Grow.c
index e18f1db00a57..953251561cf8 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1694,6 +1694,8 @@ char *analyse_change(char *devname, struct mdinfo *info, struct reshape *re)
 					/* Current RAID6 layout has a RAID5
 					 * equivalent - good
 					 */
+					if (strlen(ls) > (40-1))
+						pr_err("%s length is bigger than destination", ls);
 					strcat(strcpy(layout, ls), "-6");
 					l = map_name(r6layout, layout);
 					if (l == UnSet)
-- 
2.32.0 (Apple Git-132)

