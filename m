Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 065EE25F79B
	for <linux-raid@vger.kernel.org>; Wed,  7 May 2025 12:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746620424; cv=none; b=gsKJVRU4FIdGcPO5zrrt1xZAqOiDmaM/L7D2YlMta+gZeQN7R5gVr7OMsUCSbgIbcrHkpLapJioAfozIDHGT1OGFWh/KgK0zbKNQpRO/F2UpnCIlTkqHzpE0Z3L4JE3EJDepzRebia+lJgPt5v9gSVyp/o+zoJl/1KLc+7Y9Tno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746620424; c=relaxed/simple;
	bh=RHUoa6YTgNn00+L+qEtEtkq/fPJkrGcLKFBmlLHHX50=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T9ozE5YQIO6zHY1khqQaJY1VI7VZc3HEftHTG5OmLsBITqYhyQiTg7Vlh3akljjQ+g7jI7XKb75Fq/eKlPTqj8IQev98oravlbe8sub3gSuZ3luk92kHedEslJimainP5C+Htf/Fib+A9naBkl3VsRTE/tQlz8JOT3vNzyarruw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V60Ei2qG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V60Ei2qG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746620421;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3dKAWWdp6cp4qx4W7G5w4X/OdqjtG8fuTigep6J08Rs=;
	b=V60Ei2qGX3QPLzvmAct8pwk1J0y0X1QoDd+S1aAq7mNP+OV46at9Bn1VD8mBh6rea/7q2v
	rc5CD9SMyca3OKiHmpcVVaJXMgKLoN5W35sYOzRnvKmaDi74oUgxQDLE281DeXkeRFyMwW
	5dL+or6o6s7TltNvU+N8CF2nXG+ovQc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-588-fxRyRAjwMBW3AVWvu5sy2g-1; Wed,
 07 May 2025 08:20:18 -0400
X-MC-Unique: fxRyRAjwMBW3AVWvu5sy2g-1
X-Mimecast-MFC-AGG-ID: fxRyRAjwMBW3AVWvu5sy2g_1746620417
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B09531800447;
	Wed,  7 May 2025 12:20:17 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.7])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5813A1956058;
	Wed,  7 May 2025 12:20:14 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: mtkaczyk@kernel.org,
	ncroxon@redhat.com
Subject: [PATCH 3/3] mdadm: add attribute nonstring for signature
Date: Wed,  7 May 2025 20:20:02 +0800
Message-Id: <20250507122002.20826-4-xni@redhat.com>
In-Reply-To: <20250507122002.20826-1-xni@redhat.com>
References: <20250507122002.20826-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

It reports building error in f42:
error: initializer-string for array of ‘unsigned char’ truncates NULL
terminator but destination lacks ‘nonstring’ attribute (5 chars into 4
available) [-Werror=unterminated-string-initialization]

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 platform-intel.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/platform-intel.h b/platform-intel.h
index 63d416826118..f92a9a11c3a0 100644
--- a/platform-intel.h
+++ b/platform-intel.h
@@ -24,7 +24,7 @@
 
 /* The IMSM Capability (IMSM AHCI and ISCU OROM/EFI variable) Version Table definition */
 struct imsm_orom {
-	__u8 signature[4];
+	__u8 signature[4] __attribute__((nonstring));
 	#define IMSM_OROM_SIGNATURE "$VER"
 	#define IMSM_NVME_OROM_COMPAT_SIGNATURE "$NVM"
 	#define IMSM_VMD_OROM_COMPAT_SIGNATURE "$VMD"
-- 
2.32.0 (Apple Git-132)

