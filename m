Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E596219CC3C
	for <linux-raid@vger.kernel.org>; Thu,  3 Oct 2024 13:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727963295; cv=none; b=Nj9OLWUNHFx0l+NbW4zRaeftt+Hq/4I8C06DC8o3kUM+YS63Sjyj3WowvZ9gq5e1/SkLkyNGyZXOft4I383fxhcgTq1TP3QbO81BdcHyxxXZyckk5dz1SXikbvU8A9u1Tw6sPnHeuLWpUcPHMCU9dZpI6eieOpIAr9Fl2fZrPc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727963295; c=relaxed/simple;
	bh=ZRPcWmBXk1lfr+psNOXkqGgJdLutKmOnbualS2AAh2w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FYVmsxVg9O7PbYpm87FXNRdNLgj5iVfyAinXRKQKzf+AAqGTvZ5TNgCaxp3ZoOASbyqXimfYFIxhj739MYorPEJZMkLnsdeZiJjubfRcDwCx2JhNlAU2CLvfS11Ya4lm344kSJHbXdvxik1VNYLVgKn5EOVMsxAfHYeu+BYMr1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Oz9SwSkU; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Oz9SwSkU"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-20b78ee6298so5742285ad.2
        for <linux-raid@vger.kernel.org>; Thu, 03 Oct 2024 06:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727963293; x=1728568093; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0yvYolk6h6/D9GxXnPWOj8Grd9F2JgQm4fI/bJT0P2I=;
        b=Oz9SwSkUXdNZ3I0z2gv1dLLYbYwvvDdnRuiALTGDPDDenwhspwJZ7mh7PhfY8PktWj
         HdvytP4lZx2rQkazN2QLtyWkofa+qwdoCS6NGdcWpOvMRPeqdm/Vu80IIB5yVFxtm+K0
         shJvMUfM+1rdwwykAMoUSjpftFIlPVeny1AquiOV1lswEyRNorQcDL8tyzVylxTlF8Jc
         M3WzgtzwzOl7YU8Rl67ATr7ChJluXGpQ/2mC+A/kCQkH42vJKqvuaSrbPwGWIoj4L6Qx
         mmIyEKJd7DMwU3ARVZA0ri9bZBp+AbNExDQMbOmcUWEkkA8TwkAEgjPTmFkd51hjERMz
         bqtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727963293; x=1728568093;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0yvYolk6h6/D9GxXnPWOj8Grd9F2JgQm4fI/bJT0P2I=;
        b=BcFmelVIMX4ZISxFefnv/1fEtnt2B0hoX712HTYvBAE9dh+pvCDL1kWn1Q7TPYxjyh
         qo9xqWu6AmDneISfEBjiCJ8B6As+JoCqsNVGgRs7XicxU9eYRqMtQ+bTBscRbAW1fNW3
         f33WpWDgByzZexyzXRMn2GdkYOCgRkF5WCeJTwv84E+nBLK2ZAFSQyTiPxTnsR1Ud6wq
         1lJrNgOntl4K7cPGaKR/AYpRsPngkBg71bMacPKcaagby9/aAFHW9llpKjjMuel60pIP
         aNrS9sXPak3Fx8s0BId7M6dQar5EXBcxEihOGMGvBcAGG44uJ9qyRQuZEr7UL2yzgcwq
         Lbvg==
X-Gm-Message-State: AOJu0YwOrlAVpEzwJ/faSJgAxNyY95xD+lwY9b4gJzEm4wWTostECig5
	0PSLDbhSImsa7wLYlWr+F83Yr/Rk1NNfmiLxbIGW2N2oPizedarNiSOaFQ==
X-Google-Smtp-Source: AGHT+IEzRSxzKw7O01qcWw6e4MK6jYqcMqXJFZ5noncHRIPtrk232VmQwZH7ozi8yJ5z8wE0T2Bucg==
X-Received: by 2002:a17:903:120a:b0:206:ae39:9f4 with SMTP id d9443c01a7336-20bc5a1c139mr105683105ad.20.1727963293001;
        Thu, 03 Oct 2024 06:48:13 -0700 (PDT)
Received: from localhost.localdomain ([2600:8800:1600:140::ec])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20beeca24a1sm9186685ad.68.2024.10.03.06.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2024 06:48:12 -0700 (PDT)
From: Paul Luse <paulluselinux@gmail.com>
To: linux-raid@vger.kernel.org
Cc: paul.e.luse@intel.com,
	Paul Luse <paulluselinux@gmail.com>
Subject: [PATCH] md: another CI test, do not review
Date: Thu,  3 Oct 2024 06:48:09 -0700
Message-ID: <20241003134809.10551-1-paulluselinux@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is just a test

Signed-off-by: Paul Luse <paulluselinux@gmail.com>
---
 Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Makefile b/Makefile
index 9fa18613566f..fb4622942dd9 100644
--- a/Makefile
+++ b/Makefile
@@ -5,6 +5,8 @@ SUBLEVEL = 0
 EXTRAVERSION = -rc5
 NAME = Bobtail Squid
 
+xxx
+
 # *DOCUMENTATION*
 # To see a list of typical targets execute "make help"
 # More info can be located in ./README
-- 
2.46.0

