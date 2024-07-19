Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678CB7F7DB
	for <linux-raid@vger.kernel.org>; Fri, 19 Jul 2024 09:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721382800; cv=none; b=sclGbInbn06oXVUZJd/9d1tBXtrlkQVMGTO6X4JITncLSGUBJn9J913Y8REI2mGX0T4xMtRFX3ZJGXGpXRpCILrP60R2fjEMvj60r3VWR6ad7v96vpjbmwk49HLiaNtTM9oQgPHEDB0g2Nnm0p4mlyyBuvh1NWByAcg8phWFZE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721382800; c=relaxed/simple;
	bh=ZBqw9dhTG73DmFth2k9E9FeE+6OAdIeYrtrkqOwRiYs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DSdxA8BRoYlDPZWRGl77VY9xx165QK5rtVrv4hym3a9Ppz9y8GubuJvx+bJcHjSuKHH7OcEmxrWL6ptWlqbFlKj0rr9WnB36ahqkqU5yl6BSUsgWfZXR8+9QBkXlgOTqgHtmkNWhnvrsYVrPT7Kc6iwZsLATX1ZyPIXzyp+8dU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Gp0GTnXB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gp0GTnXB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721382797;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=56rNVS4rVlRAMWczGcm70OrnpSXB4btVxY/NEeGEt7M=;
	b=Gp0GTnXBbG74SslaBkDhROejyGYm84csMQ1lOmzXy+c+6xQ0tWlxb76eJ1YD3Mxey7DIgJ
	ypkFdX9w7qIEdFPVNOsgcLRrcTjG/mmeQZtxTNtYapHnvnXXnjy0Y+oRnPQCqkBvobGlgk
	9nqDPLwUT40cjIMByEP2QAxB8POBDN4=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-49-t7wqm0RwMZmILZZYgTpXTg-1; Fri,
 19 Jul 2024 05:53:15 -0400
X-MC-Unique: t7wqm0RwMZmILZZYgTpXTg-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C59021955D45;
	Fri, 19 Jul 2024 09:53:14 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.6])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3D3AB19560B2;
	Fri, 19 Jul 2024 09:53:11 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: ncroxon@redhat.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 14/14] mdadm/super1: fix coverity issue RESOURCE_LEAK
Date: Fri, 19 Jul 2024 17:52:19 +0800
Message-Id: <20240719095219.9705-15-xni@redhat.com>
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
 super1.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/super1.c b/super1.c
index 243eeb1a..9c9c7dd1 100644
--- a/super1.c
+++ b/super1.c
@@ -923,10 +923,12 @@ static int examine_badblocks_super1(struct supertype *st, int fd, char *devname)
 	offset <<= 9;
 	if (lseek64(fd, offset, 0) < 0) {
 		pr_err("Cannot seek to bad-blocks list\n");
+		free(bbl);
 		return 1;
 	}
 	if (read(fd, bbl, size) != size) {
 		pr_err("Cannot read bad-blocks list\n");
+		free(bbl);
 		return 1;
 	}
 	/* 64bits per entry. 10 bits is block-count, 54 bits is block
@@ -947,6 +949,7 @@ static int examine_badblocks_super1(struct supertype *st, int fd, char *devname)
 
 		printf("%20llu for %d sectors\n", sector, count);
 	}
+	free(bbl);
 	return 0;
 }
 
-- 
2.41.0

