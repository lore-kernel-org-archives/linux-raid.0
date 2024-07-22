Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A8F5464A
	for <linux-raid@vger.kernel.org>; Mon, 22 Jul 2024 08:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721636300; cv=none; b=RPfvuLGw4BA28dLs5ibMRyRIKyZmBmPfMQZqg5ksj0L2OK+zixizwjGaD/VRlVKVP6feqSbbzwkXG/Rm4fz9w712slmruycMEOX1SRwWZEI2xHgpA7K191Ybq9pjaOKBmKta6qTfJZGy5EwaWdzP0rjgC1c1mkKcITHWLKPK9B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721636300; c=relaxed/simple;
	bh=feNmwDnOngEX9cIQZwHWNMuJvo7OjUwCqXnqTVgvEmM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Kg92z/i+Hi8ZahFjmTxgmYSejAOtjMPViKiVW2VR2nRFhQwEtSjsYMLb+mR8OzZZJJxXrAGC3G82ndlS0SuzUizOh0GPJMP9ceGuYfPzKOdwD4O5uN1tmVusXSJxhQdzlhcWn/hkTrLlFKX1gq3CnusGhJhzNRZoVSFKn/0QMkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DbjH9uuu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DbjH9uuu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721636297;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=37WkEh/FzLz86HdFGxI6+jRgekZCywNdxbzVtsFm8ig=;
	b=DbjH9uuuPQvL/wbcQUmZO/ax+AI++usfiRDoQaxhoUUqtNpRyyxjikwwb61wJnjttbz62H
	VAiCULXJE8dE9Y9kA/hNBf3WLWj/3+/I6LehM8OVa5cy6PkIotYOPg1rUN2Xrw+LayraDJ
	Fw7WcXNOnUID/13GPBpkRWlWgDZaMMA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-561-pNkBWzEcOaqFRmBOPNJo0Q-1; Mon,
 22 Jul 2024 04:18:13 -0400
X-MC-Unique: pNkBWzEcOaqFRmBOPNJo0Q-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 218B21955F06;
	Mon, 22 Jul 2024 08:18:13 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.7])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CC458195605A;
	Mon, 22 Jul 2024 08:18:09 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 08/14] mdadm/mdopen: fix coverity issue STRING_OVERFLOW
Date: Mon, 22 Jul 2024 16:17:30 +0800
Message-Id: <20240722081736.20439-9-xni@redhat.com>
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

Fix string overflow problems in mdopen.c

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

