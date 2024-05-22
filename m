Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77D48004F
	for <linux-raid@vger.kernel.org>; Wed, 22 May 2024 08:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716367896; cv=none; b=oDux42Tyedd3+2j5zl2y1FAIWqUbUNI9b9Mcjq8Ew/V+xL+/q8i+NQZDbdt0fqmA8T8i+PPhPZpVElbWMjHcaJReg09IMsf1iFtsBGfSqvLPg+JR6IyXUY9HXNY1knriXy35t+xTJjHDu+n0yE2npcJJrv0Yo/l+33glQz9+6N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716367896; c=relaxed/simple;
	bh=/GuaZGMQJmEple0O+cjvYy6XNIECU1psG4eVCsKZhLc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=f0gTYMhLZiTmmC4Rn30O82P16uNiouTGbuJI9tzBIIZLK81geOCIpPODecY/uRmMphd1BA/t8Cjb6mcR7lNmAb+eTsPwyHzvFh5uMql7asxonA/6lbIzWQEOLkBhy4QGYC44SMjIe5zTL3NGSNjZk8xv2KPI+IUGxVBdwlrViDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OljxBQqs; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OljxBQqs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716367894;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8UIWk+2sy8Psc5T6UUGLVTcH29pzSIxTbNaWd3gDutU=;
	b=OljxBQqsiWVF99/JXhvX6Z3pGlU5npipp3mmsyaMUCLKFCLyyER/oF+f4tp4JLw/VYSATK
	/xI+L8hS7inY6KG5pXOtoi4EeNpjQXxUZM+I2FKyhaiNnxe+960qakCHyz2JlGSRh1zJSN
	BpfKEW7EdS8OdwAcnLx1AgbWe2c5aMk=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-244-VhrTH5avPkmeHDS_PAoYYA-1; Wed,
 22 May 2024 04:51:30 -0400
X-MC-Unique: VhrTH5avPkmeHDS_PAoYYA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E77D829AA3AD;
	Wed, 22 May 2024 08:51:29 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.11])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C50DFC15BB1;
	Wed, 22 May 2024 08:51:27 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: linux-raid@vger.kernel.org,
	heinzm@redhat.com,
	ncroxon@redhat.com
Subject: [PATCH 10/19] mdadm/tests: 03r5assemV1
Date: Wed, 22 May 2024 16:50:47 +0800
Message-Id: <20240522085056.54818-11-xni@redhat.com>
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

dcc22ae74a864 ('super1: remove support for name= in config') already
removes name= support. So remove related test codes in 03r5assemV1.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 tests/03r5assemV1 | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/tests/03r5assemV1 b/tests/03r5assemV1
index bca0c583724b..6026011eda93 100644
--- a/tests/03r5assemV1
+++ b/tests/03r5assemV1
@@ -31,14 +31,6 @@ conf=$targetdir/mdadm.conf
 mdadm -As -c $conf $md1
 eval $tst
 
-{
-  echo DEVICE $devlist
-  echo array $md1 name=one
-} > $conf
-
-mdadm -As -c $conf
-eval $tst
-
 {
   echo DEVICE $devlist
   echo array $md1 devices=$dev0,$dev1,$dev2,$dev3,$dev4
@@ -88,15 +80,6 @@ mdadm -As -c $conf $md1
 check state U_U
 eval $tst
 
-{
-  echo DEVICE $devlist
-  echo array $md1 name=one
-} > $conf
-
-mdadm -As -c $conf
-check state U_U
-eval $tst
-
 {
   echo DEVICE $devlist
   echo array $md1 devices=$dev0,$dev1,$dev2
-- 
2.32.0 (Apple Git-132)

