Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E2322CBF9
	for <linux-raid@vger.kernel.org>; Thu,  8 May 2025 12:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746708535; cv=none; b=Pis7J3lpxfbbg4E4rG4lUWLF/RiOfZZzln/LbDnkrDIf/M7Kl5MnRnobxEbZT9CKCcweo05wivUPzrsg5fNvRE/hWvY2PoLocNYeaxya5bFy01sG3jL5LtOCX2MCx011IAohJtmAqm1pjsH+Yp58PlmSuK9i9L428/pBWb5c5kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746708535; c=relaxed/simple;
	bh=RHUoa6YTgNn00+L+qEtEtkq/fPJkrGcLKFBmlLHHX50=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I1GXZkS6xcqHS7Z1S/1zR4lW27mjgE1pbyJMikNqqH2ow/uIjVHP7cmGwoD5gHo1srGvxm7pQnNhpZowm2OwS1CCiyYUQNuHhdCIWB8ktproJW6ysL7CV/klGzaWjmQl4jopBNHJpDFDbZZ0KLSKSyOFpcYAjXJhZWvDGAOnbZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UIRGJFe1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UIRGJFe1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746708531;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3dKAWWdp6cp4qx4W7G5w4X/OdqjtG8fuTigep6J08Rs=;
	b=UIRGJFe1nmTnPqvNQudmBqaM4xBaNi2Gg5xbIP7aQBdvVyceWnbEBeJ/aw+TxxXEQ1DT9l
	hitzSNSe67wWGwONBGvaSRa1RFB+paT5HGKMw4Pk/FM/HqCaoYgcQzRNH1t32HzY3W1H7g
	iorpoOU61Fhs4pS1olBRKqQ7QCpdVew=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-647-fyZA5iKLPGe3xyo3ig-5vw-1; Thu,
 08 May 2025 08:48:48 -0400
X-MC-Unique: fyZA5iKLPGe3xyo3ig-5vw-1
X-Mimecast-MFC-AGG-ID: fyZA5iKLPGe3xyo3ig-5vw_1746708527
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4D7471800256;
	Thu,  8 May 2025 12:48:47 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.7])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id ED29219560B3;
	Thu,  8 May 2025 12:48:44 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: linux-raid@vger.kernel.org
Cc: mtkaczyk@kernel.org,
	ncroxon@redhat.com
Subject: [PATCH 3/7] mdadm: add attribute nonstring for signature
Date: Thu,  8 May 2025 20:48:27 +0800
Message-Id: <20250508124831.32742-4-xni@redhat.com>
In-Reply-To: <20250508124831.32742-1-xni@redhat.com>
References: <20250508124831.32742-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

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

