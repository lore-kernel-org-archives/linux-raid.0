Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB07839EB
	for <linux-raid@vger.kernel.org>; Fri, 19 Jul 2024 09:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721382779; cv=none; b=RK0WwkJBl1joXJd6Q6RheeuQqgCTMTLj2+mkBRlqp3pikysek6TBy+0L1I8vxXv+slY1bRfhUbhlGpIzzPk4tKGEm+UhUruUNdNkOEF/2ITOTuSg9O3MZ23GsCv1dB119wWDhq59kwzPYCUbS6sqacP0EabepB85QwQF4mA4+jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721382779; c=relaxed/simple;
	bh=mj/hG55vEBwcYs01mRR4jqVx95Byiv3WI9XL9XdudXU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ax5+/y2++hyCtanUYe6H6+2ZToiP8al7pn3coXHsG9vhfoc2RQmx766gjxL6OwVdPyNTB8j8x6Px8aonWSc4sIlZ4rFE9SOGa/ymTxrPiYB1yZiKrYIqybQKHHoIqm1fFp5+Yk73Tjz5N+na7ZwdsI00zF1sgwFdCQ3GRdW5880=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A6eFDNpr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A6eFDNpr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721382777;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gIXj55dTuCrNogC1R/0EHFWhf6PbEP5I3np/C27l4yM=;
	b=A6eFDNprqhrazKDwG5wUxrpyfZ2cEqPqBwRrwuwclWvlOOB/77CFgdp59LzBh+XSkFco/R
	qsx29gNLd+X4lXsVu7j6ZXCqEivuARrSaKeMCwepcproSKKTwcmPkugsy2APcMdbSHehNz
	VT9G4DJJdlEavxpMU7dgaBlSMtkoljQ=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-244-wpsLGIZvOPWZoyrRz8cTjw-1; Fri,
 19 Jul 2024 05:52:55 -0400
X-MC-Unique: wpsLGIZvOPWZoyrRz8cTjw-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7FF871955D4E;
	Fri, 19 Jul 2024 09:52:54 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.6])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B70D51956046;
	Fri, 19 Jul 2024 09:52:51 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 08/14] mdadm/mdopen: fix coverity issue STRING_OVERFLOW
Date: Fri, 19 Jul 2024 17:52:13 +0800
Message-Id: <20240719095219.9705-9-xni@redhat.com>
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

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 mdopen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mdopen.c b/mdopen.c
index c9fda131..e49defb6 100644
--- a/mdopen.c
+++ b/mdopen.c
@@ -376,7 +376,7 @@ int create_mddev(char *dev, char *name, int autof, int trustworthy,
 
 	sprintf(devname, "/dev/%s", devnm);
 
-	if (dev && dev[0] == '/')
+	if (dev && dev[0] == '/' && strlen(dev) < 400)
 		strcpy(chosen, dev);
 	else if (cname[0] == 0)
 		strcpy(chosen, devname);
-- 
2.41.0

