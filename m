Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00378381BD
	for <linux-raid@vger.kernel.org>; Fri, 26 Jul 2024 07:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721978081; cv=none; b=HijU+aEcnR3H7xmP3FgP2dr0aTY3H7WpNkb12MKe95e++clPn3HbxgwFPSUHQ7UD1eglvNDWTnfEZohE1PP2PZ3UxUbBmk6l0f1J+Rc7/SAPT/hNIj5viLsFS3eFGmKsCBjeWSmdt7IEsrgcAMaHtJRMuXANv+CYxhS6LrqCM0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721978081; c=relaxed/simple;
	bh=FM3hmkluz3hdPOUu86a4VYrfiGTj3HgCSuSLAc2t2a4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QZkHOjR7Nx0QO8rWMF9Yfz5itG7jCFqQBoVkot85JEbZarkDqBX/bq45DPjuGRKIIHNg/+q0UPNGtB3ErIXaBnlkGgfmrui8PyVur0Y1D3kdIHmthSb9+rgupoEw1Cfg3NjBWn+bFl+wy5DVqsDBVxcyG0weUtBCrupueLrQTSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AoK3gK9B; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AoK3gK9B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721978079;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gNN1bEFABTG7pfP5oTfHubNICv4PVZVTAPfR2X9pdGc=;
	b=AoK3gK9BMNFde8XsbgerNOtQPCwdghHbMq8IHRzxD3ONud+mk3qBzvTOEltGRbCmZemuy2
	u54F1m/tByGGct8pXIQSeQc0g70bdPhJ4GKjKykZqT+KWQLr+3qTE6CkiLSEKjIOORhks0
	Us6i4nEzVZ+tQ+9M7Gf+pOw4Xe1ndDA=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-583-39gTjo8oMxOV4h5BxMg2Yg-1; Fri,
 26 Jul 2024 03:14:34 -0400
X-MC-Unique: 39gTjo8oMxOV4h5BxMg2Yg-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6F00E19560BF;
	Fri, 26 Jul 2024 07:14:33 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.28])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BDD2719560AE;
	Fri, 26 Jul 2024 07:14:29 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 03/14] mdadm/Grow: fix coverity issue STRING_OVERFLOW
Date: Fri, 26 Jul 2024 15:14:05 +0800
Message-Id: <20240726071416.36759-4-xni@redhat.com>
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

Fix string overflow problems in Grow.c

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 Grow.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Grow.c b/Grow.c
index 907a6e1b9e22..a5f9027d93d8 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1694,7 +1694,7 @@ char *analyse_change(char *devname, struct mdinfo *info, struct reshape *re)
 					/* Current RAID6 layout has a RAID5
 					 * equivalent - good
 					 */
-					strcat(strcpy(layout, ls), "-6");
+					snprintf(layout, 40, "%s-6", ls);
 					l = map_name(r6layout, layout);
 					if (l == UnSet)
 						return "Cannot find RAID6 layout to convert to";
-- 
2.32.0 (Apple Git-132)

