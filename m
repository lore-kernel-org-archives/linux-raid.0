Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A77782C60
	for <linux-raid@vger.kernel.org>; Fri, 12 Apr 2024 16:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712940372; cv=none; b=Yjhgj4uumDHXHkGsp+f19g0Eot7KFNL/CWcyEzWqM/a9GltmlXhTKFPNMeYjGkwN+6SKScTRvbrG0Uw7l577UdnGIcrnfAsZs2NpzWIaSBQ3qoqCy/X0yo3sf0gm2lU51s6WETFuGVasuJBeCbHOZrH1bjDcAJ+BpHbgWkJ7yiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712940372; c=relaxed/simple;
	bh=NMmoCuiAwpdQ0x6yU5JkWAx0qtEyZ5W5qzwKgEeYKK8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ba8cKVREuJCILup4FTAvErKY6z2jsTV9fMS1yS0XIJYD1gq/Sk25ivmfKJYgqSbV8lvtn1D1l3OZ7KEwVOoYIdSOKyIG0OErDel2wtsd27JxeCpJuRPVw0HlAnJIA5u6uyKjpSYFwXaKUBgke50GhYLbJAOnV4Wd+HlNoIctiv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A0dNmr1F; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A0dNmr1F"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-417d02ab780so8208645e9.3
        for <linux-raid@vger.kernel.org>; Fri, 12 Apr 2024 09:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712940368; x=1713545168; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bs+QNsCRbAADtmXWSgadDPVWxN3u64kZzXJcHPH4tZE=;
        b=A0dNmr1FKKBPwGDTvswTWbuq1zG45j7cuJ2mvvhHH6GRmciIq7Xv9mj6syJNFGOFFg
         dOmAvbARp4QCt2y4QO4MC8gKhlLF/6o7fhg2JRUD9ffnQiGKLA0rKrKU4RXic6Bwu1J2
         9EXW3hg4SV4y+1Wyq35b8ldW3FUlPQbvml6WdUeEsNP7il+SrFsejT+u6N00QIbZ5WX8
         8pvdq/gzdrarjewg0xaJDkCd74V9wQ0z+hJ8DzVCMvKg32RNxYYRFjbdfJLdlH0fPNEK
         +mZ+ErTdSYdwmDPBcDgsL74O4a4+t6NlVpvespOxJ9wo2pPH2ar8aqGmf0mPVHvwGkuk
         FSaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712940368; x=1713545168;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bs+QNsCRbAADtmXWSgadDPVWxN3u64kZzXJcHPH4tZE=;
        b=BHLqOf2SGw/79veZV8KdNy7KLqhzpDuSckHb2V9UFhiXc2wnCkVAysKkeuYuXNIOxC
         JsgGVkD8LJXFtOAkp+zne7YAQEMfg0ilorTeTpDzTtIWRrVbce5vM1ua3ddh8jPyvGUd
         tmHcpLSUQ1w0x1NP3HRtCJmaRprOnzMCITkvgvtu83L6pCNgiRjgpLTf2pgpqqJSLc/H
         Z3Zw2UL9teyjL8egjgbV5eVubGm3IZdSj45lDINYXIzXFx4S88avo4Dz740nLKOsmB8h
         EKXkyKLiuBf6ZCTGwUPqkuPVOTol+xJYPkh7Bd48aWGt9Ak8d1A7bIy8oCr7is6ASFIJ
         vTRg==
X-Gm-Message-State: AOJu0YykFLNZkmlRcWIEVoHvhIr1V9IHgM1AV2GYU5d0NS99M2vQ1pKs
	8iNDRjRNblKgPVj2wLoTWNuGgR7yrhTgDY06bdkr8Q+xUh6anDPOqSBqNHF1
X-Google-Smtp-Source: AGHT+IEKr3JH0TVUQ5H82JjNt8TH9r7PT9SLWHasNhZYeEJq7XaoeejVmsMo8ur+MQiIquPhI9eNvg==
X-Received: by 2002:a05:600c:1c8f:b0:416:bed3:e537 with SMTP id k15-20020a05600c1c8f00b00416bed3e537mr2452620wms.38.1712940367920;
        Fri, 12 Apr 2024 09:46:07 -0700 (PDT)
Received: from kali.home (lfbn-ren-1-787-165.w83-197.abo.wanadoo.fr. [83.197.114.165])
        by smtp.gmail.com with ESMTPSA id gw7-20020a05600c850700b004146e58cc35sm9495372wmb.46.2024.04.12.09.46.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Apr 2024 09:46:07 -0700 (PDT)
From: Fabrice Fontaine <fontaine.fabrice@gmail.com>
To: linux-raid@vger.kernel.org
Cc: Jes Sorensen <jes@trained-monkey.org>,
	Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
	Fabrice Fontaine <fontaine.fabrice@gmail.com>
Subject: [PATCH] Create.c: fix uclibc build
Date: Fri, 12 Apr 2024 18:45:13 +0200
Message-ID: <20240412164513.6829-1-fontaine.fabrice@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Define FALLOC_FL_ZERO_RANGE if needed as FALLOC_FL_ZERO_RANGE is only
defined for aarch64 on uclibc-ng resulting in the following or1k build
failure since commit 577fd10486d8d1472a6b559066f344ac30a3a391:

Create.c: In function 'write_zeroes_fork':
Create.c:155:35: error: 'FALLOC_FL_ZERO_RANGE' undeclared (first use in this function)
  155 |                 if (fallocate(fd, FALLOC_FL_ZERO_RANGE | FALLOC_FL_KEEP_SIZE,
      |                                   ^~~~~~~~~~~~~~~~~~~~

Fixes:
 - http://autobuild.buildroot.org/results/0e04bcdb591ca5642053e1f7e31384f06581e989

Signed-off-by: Fabrice Fontaine <fontaine.fabrice@gmail.com>
---
 Create.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Create.c b/Create.c
index 4397ff49..d94253b1 100644
--- a/Create.c
+++ b/Create.c
@@ -32,6 +32,10 @@
 #include	<sys/signalfd.h>
 #include	<sys/wait.h>
 
+#ifndef FALLOC_FL_ZERO_RANGE
+#define FALLOC_FL_ZERO_RANGE 16
+#endif
+
 static int round_size_and_verify(unsigned long long *size, int chunk)
 {
 	if (*size == 0)
-- 
2.43.0

