Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6622018CBF5
	for <linux-raid@vger.kernel.org>; Fri, 18 Oct 2024 08:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729239740; cv=none; b=QUaT1AnA9ZVtPBRHlsp9KUsYBcVbwmgqorch6MoLke+ZaVoj5TkW5uDPXAlBGs6ImRTqCrfhr2JhaYCdsHr69CUbX1v4VG7OOpDjPhtUmcqRdGrq83h1AXCusR2HxXbzZCJwkQ9yUs+wLGVWK8FvcDAPEtMFDKQmyW5JBkohx9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729239740; c=relaxed/simple;
	bh=i9MvG6Yid8/6HcCrCIOgmyVZg+6wj/ODmFtDI4qhjZo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PVHYrdcvdyRLXoijEYEHOjpMkSw4IyAORV8d0/3GrX6Skx1ALMU+5Ixcz9VhapwReYz/x2xI4t2Hd4cdb3p+h8X5kQsCP6Ho8Ag05pJYn+4/rowIYsvH2NoHfe2xw/C72mQT8blobskVCrWObha8YY8hX19WTFHFsnfMOAenGNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T/p1poqR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T/p1poqR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729239738;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0FAhY7Ixj8tN3zYrJXVCMgqEULEDFL92LELnYSHdGY8=;
	b=T/p1poqR02NMNUDhpucXuxVFYf/NqJjfVrHv4WD/WGrME6qjjiwvduBOH/OUeL53a9Ixmp
	rmkU3plzUEKS7y19mH+YIvP2OMFJ6FKzugP43ijybvI7dLcY9pOy/NvX/Wja5YpJRZZuR1
	FqH8PqVzMUA4hOiyGbQWRLNhjVtwvb0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-277-ExYIE0KWPkytTD3l9NMtcw-1; Fri,
 18 Oct 2024 04:22:16 -0400
X-MC-Unique: ExYIE0KWPkytTD3l9NMtcw-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0D76D1955E92;
	Fri, 18 Oct 2024 08:22:16 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.5])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A091619560A3;
	Fri, 18 Oct 2024 08:22:13 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: linux-raid@vger.kernel.org,
	ncroxon@redhat.com
Subject: [PATCH 2/2] mdadm/Grow: Check new_level interface rather than kernel version
Date: Fri, 18 Oct 2024 16:22:03 +0800
Message-Id: <20241018082203.59963-3-xni@redhat.com>
In-Reply-To: <20241018082203.59963-1-xni@redhat.com>
References: <20241018082203.59963-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Different os distributions have different kernel version themselves.
Check new_level sysfs interface rather than kernel version.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 Grow.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Grow.c b/Grow.c
index ef1285ecebcf..9032c3e9c09f 100644
--- a/Grow.c
+++ b/Grow.c
@@ -2952,7 +2952,7 @@ static int impose_reshape(struct mdinfo *sra,
 			err = errno;
 
 		/* new_level is introduced in kernel 6.12 */
-		if (!err && get_linux_version() >= 6012000 &&
+		if (!err && sysfs_attribute_available(sra, NULL, "new_level") &&
 				sysfs_set_num(sra, NULL, "new_level", info->new_level) < 0)
 			err = errno;
 
-- 
2.32.0 (Apple Git-132)

