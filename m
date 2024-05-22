Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF0146522
	for <linux-raid@vger.kernel.org>; Wed, 22 May 2024 08:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716367873; cv=none; b=i+U53IAbNokwoPCCN9HwJrPl5WUx577h1yFW6meFxT0XIpAo8k9alkltbcwrZPylB9MtDFrUvlQ8pImCNimENbD1X02BzH6RiE7Y6mrXmkH87Oh5Iq8beI4vPGzGpCFXKYdeAO25HdOM/VD+Cl3sQSHQ+uI2s2GzXqBvHLidXKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716367873; c=relaxed/simple;
	bh=UdmxJeD7p7Iz2pDyLe4hgVviElEn734ea31JcG22st8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KRtRyiaF7mOHF9nodnaqiuevvyc7i4bcycPfz8L0SusJZgDptYOktt2HjT6DdgNwYhppSTMDRQP7332lmsqfJ6/fNEqk10WHtks8f/cQbuDSaZMUJKgJazKlJXUIqF3DTnn3fsZpge3rgC+6gMVIcJQmI+mSYwKTHeVwz5tSUbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F6K3I/jL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F6K3I/jL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716367870;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wZwkwGf3fwN2OJAiGwy3qOAyN1yPeTZeQUdex8FfuL0=;
	b=F6K3I/jLQksdLUEyxR79Kbn5Gr/I/wxqu73rlAsEldqcabfZHREaL/qjQqBm6hyjd9aAeN
	15Fmoz1+kDFwB/q4e2lB+0l173np+aJxCm0CfcI6iGwf23GlYGOb8sdqYT4cXbr7oDjzDq
	MGNW2r5YQNaglhzyjkNksmtvWY9ldTI=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-149-a6e3G-mEPmCqMVZ4gjSGtw-1; Wed,
 22 May 2024 04:51:07 -0400
X-MC-Unique: a6e3G-mEPmCqMVZ4gjSGtw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C81513800089;
	Wed, 22 May 2024 08:51:06 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.11])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B26A7C15BB1;
	Wed, 22 May 2024 08:51:04 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: linux-raid@vger.kernel.org,
	heinzm@redhat.com,
	ncroxon@redhat.com
Subject: [PATCH 02/19] mdadm: Start update_opt from 0
Date: Wed, 22 May 2024 16:50:39 +0800
Message-Id: <20240522085056.54818-3-xni@redhat.com>
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

Before f2e8393bd722 ('Manage&Incremental: code refactor, string to enum'), it uses
NULL to represent it doesn't need to update. So init UOPT_UNDEFINED to 0. This
problem is found by test case 05r6tor0.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 mdadm.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mdadm.h b/mdadm.h
index b71d7b32ee07..40818941bb16 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -535,7 +535,8 @@ enum special_options {
 };
 
 enum update_opt {
-	UOPT_NAME = 1,
+	UOPT_UNDEFINED = 0,
+	UOPT_NAME,
 	UOPT_PPL,
 	UOPT_NO_PPL,
 	UOPT_BITMAP,
@@ -575,7 +576,6 @@ enum update_opt {
 	UOPT_SPEC_FAILFAST,
 	UOPT_SPEC_NOFAILFAST,
 	UOPT_SPEC_REVERT_RESHAPE_NOBACKUP,
-	UOPT_UNDEFINED
 };
 extern void fprint_update_options(FILE *outf, enum update_opt update_mode);
 
-- 
2.32.0 (Apple Git-132)

