Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C103D579
	for <linux-raid@vger.kernel.org>; Mon, 15 Jul 2024 07:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721029009; cv=none; b=WQvr9bVXF+p7B7QngMyAA2xY+ReOUNlWXcYvuLSRO5YJdW8ZSRAbxv2r24Jg5DMu9dR0Jer5+U6LftdCGwXazZcE05fWiCGQCw1ChBYo6HHjYhIXAadJsvouPbXJ1ZpYfK/fogoTIFzPdSNcJcR1sawzPZQmhpbEurjJc5QaQ2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721029009; c=relaxed/simple;
	bh=NY2gFccxGmDQBws6L00dq0z+vNXbfrO5fLSZRc+aG10=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tQEq8i5HPd+ae5MGc0E6MJ2cOlyHRULFwMblKY2YJ7psTID92odfL0a82khoxAHFLI9a2wAeuGZ4nycMlJWGLCE1N4atqmZRXA73oxINTyVGPJrBpKBaYYnn3ukHlMJItK9eFHPr6HhjnlVK8A/MuaKx8rrujkQXB9RkH6qi3/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=du38VCqb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="du38VCqb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721029007;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hNmptmNx4kIIIyoO8S7S6Urxm/nRoCT6si1wgmuNzQw=;
	b=du38VCqbFcETmHB3+T9ttyn5x09M7df5Vhh+nRm2HNpvnC0ZZcfMKwIAVTTz1Ec0uRU/Cv
	xAWaaGntphgcg5NiH3pBpIzf4wMS2k6BJQOoGI2aClGYHs46PNqa+AwCyLEBXrjqj6ExFJ
	rUt7ZOCUY2NqxoZbVMPDDHynPjk+0bQ=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-468-d5bh71foPgGeIUe58Q8oTg-1; Mon,
 15 Jul 2024 03:36:40 -0400
X-MC-Unique: d5bh71foPgGeIUe58Q8oTg-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B1FDD1955D57;
	Mon, 15 Jul 2024 07:36:39 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.27])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 423331955D42;
	Mon, 15 Jul 2024 07:36:36 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 09/15] mdadm/mdopen: fix coverity issue STRING_OVERFLOW
Date: Mon, 15 Jul 2024 15:35:58 +0800
Message-Id: <20240715073604.30307-10-xni@redhat.com>
In-Reply-To: <20240715073604.30307-1-xni@redhat.com>
References: <20240715073604.30307-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

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

