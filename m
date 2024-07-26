Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986B1548EE
	for <linux-raid@vger.kernel.org>; Fri, 26 Jul 2024 07:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721978096; cv=none; b=Pyx5/rEVG/BRyOVgu8pEPJV1zNYIn6THyKL4hykMwAftzhd0Ag2MeB3FMx1rWk4EiE1TUhxxSagK5eobngLVN+oxKzJWIlVp0gCVWmGDgigPGjbflWjekULNYGnuFpE+BvKe1U27LVoZ9svuylhQJ5VqCneI6aUsFeRjPs0SmYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721978096; c=relaxed/simple;
	bh=TdbG+L1XiNh+GOoSzPeMdbuNbtzPGVQ7WHrluIb9r+I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dOToo8f9bRCscTfHtJp7PCzpEszzIIZ6oc+1WUpItnZbfv2Ar8uxD3HcIus5vb89At6YDWQJROvrtg8Fax6F6no6UYADHQPge2w0iH0bF6inEedYUmyl3wifEOHiUTA4KuK4qdMmMc3fO8f2N38nA3NM+HrfmzdX/J1bsZVyVVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hnOiRfxt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hnOiRfxt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721978093;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f1W9IJ0w4FAx5MI8mp/ixc9GmNEYxi0jW72ezbvkVVs=;
	b=hnOiRfxtoOuzJu0h15aPVH1cO8ZCMpjxr4OyoQJjkRfHq6QGBYF+E2xJESuhCSKRUkxNlA
	6nJUK7Zzecso4pYHs5V3uh/LhmmYT2T6A5iGNGaiVEWtzKUB3WE3dJL2HOnbqUTvB4ZBQ3
	cQs1DXmH54RT0WD34fqElQe6vYC9+Wc=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-616-YEC7l775M6aiVxysUFaupA-1; Fri,
 26 Jul 2024 03:14:50 -0400
X-MC-Unique: YEC7l775M6aiVxysUFaupA-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 03AF91955F0D;
	Fri, 26 Jul 2024 07:14:50 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.28])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9B40E19560AE;
	Fri, 26 Jul 2024 07:14:47 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 08/14] mdadm/mdopen: fix coverity issue STRING_OVERFLOW
Date: Fri, 26 Jul 2024 15:14:10 +0800
Message-Id: <20240726071416.36759-9-xni@redhat.com>
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

Fix string overflow problems in mdopen.c

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 mdopen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mdopen.c b/mdopen.c
index c9fda131558b..e49defb6744d 100644
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
2.32.0 (Apple Git-132)

