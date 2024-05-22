Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE0380046
	for <linux-raid@vger.kernel.org>; Wed, 22 May 2024 08:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716367898; cv=none; b=hcj5tWNuYq2sjoXxADeNnreCfEgnNVgvnz2XGsPMPliyKOQo8lgIkUXsWeO6klhDLke9Knqzke9nuRHQRSUadexCjOJzpmHbdiJ11WmsnlfOdPqMYJFaRQ9kW4+wwU5n0TCBmB5EfWJ21fQ0Sd6reVdf9AUbocLRvUQTEkBt2c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716367898; c=relaxed/simple;
	bh=OR0aFEN1IhjDI7YC5RyTQ8ANIcbPUIO/FISY2nzKG8s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=P1pBUD/UGxM/WNt5i2bigJLK1hciMOcSAYV2UBapQRTKMOyRW6Xb2pPNgE8pqiFdLeZ98I/QYBebD/kPhtrvg7JjxI2qx7wQMuGbCv1yU6zcTim14Vbgib2H2RXsC464QzwlX15BUUemBo1oocB8TbzXARiQeSfmhWbQVKMuxq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eCPeQ3F8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eCPeQ3F8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716367896;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ooQOAreuMbpouY101LYWlanPXoFQq72Qm9ZwGqkj/1I=;
	b=eCPeQ3F86FXKpM1f2jSJQjNslLKQj4aa/ix95XyF1tWkHLipqUJQgopqfWg4n/BDTK4ERN
	FpdQrLiorNGBHaZz+Ic30jnO03/IhmV8NN0utc3xjer9Pnp94z4qSiIhU6QA7jgWP9Myte
	172ClOdtF2L44YHizorRoX6Of+GrAXI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-314-PSFGRwqfPPKtK759j4zgRw-1; Wed, 22 May 2024 04:51:33 -0400
X-MC-Unique: PSFGRwqfPPKtK759j4zgRw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CA75D85A58C;
	Wed, 22 May 2024 08:51:32 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.11])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A9276C15BB1;
	Wed, 22 May 2024 08:51:30 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: linux-raid@vger.kernel.org,
	heinzm@redhat.com,
	ncroxon@redhat.com
Subject: [PATCH 11/19] mdadm/tests: remove 04r5swap.broken
Date: Wed, 22 May 2024 16:50:48 +0800
Message-Id: <20240522085056.54818-12-xni@redhat.com>
In-Reply-To: <20240522085056.54818-1-xni@redhat.com>
References: <20240522085056.54818-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

04r5swap can run successfully with kernel 6.9.0-rc4

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 tests/04r5swap.broken | 7 -------
 1 file changed, 7 deletions(-)
 delete mode 100644 tests/04r5swap.broken

diff --git a/tests/04r5swap.broken b/tests/04r5swap.broken
deleted file mode 100644
index e38987dbf01b..000000000000
--- a/tests/04r5swap.broken
+++ /dev/null
@@ -1,7 +0,0 @@
-always fails
-
-Fails with errors:
-
-  mdadm: /dev/loop0 has no superblock - assembly aborted
-
-   ERROR: no recovery happening
-- 
2.32.0 (Apple Git-132)

