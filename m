Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A972DCC13
	for <linux-raid@vger.kernel.org>; Tue, 14 Apr 2026 02:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776133803; cv=none; b=pJ6SYjbjq49sJeRwJhf/m/AT8IfWGUVcg6jcslbkV4WclutRmV0K0rJhAfJ09b+V/nrgdMeCmxmojhw53ZYyfih9Q/gjM4XZPaD9XOoRKmxNXbVlEaiLyGCuNbjoFEgGCXEXrpwL+bJTSLX+ozuXF0xRF6DLxyT8qL0lckSc1e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776133803; c=relaxed/simple;
	bh=mq3QU6WM9ITMnDGgKNmcnUTkZj4YrAh03fjWWzYvgU0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WoBhptKd27Auo6Mi7vDB87D+HVpq3MTYg5K/mro4dfSUCMlUDrCshVasYTnSoq8NBICC0HFA8P9BB9eg3H03pXK/myoRGRJn9rfL6imgdNkoWlPktRnUQiLMJMJB94SWCiSNQ/eb527BeiKPemIdl2fjRHroElbeLgUcvjbu0E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eyixFRCG; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eyixFRCG"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-35da9c0c007so4526349a91.2
        for <linux-raid@vger.kernel.org>; Mon, 13 Apr 2026 19:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776133801; x=1776738601; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EdMr7+vUo/T6hJFf+NODRnaNrg0j8pROrWUSTuZGg+U=;
        b=eyixFRCGAZHm+9SvyjC+oEVGLzqDOcrX25kkjm4sxUnOrEr45Jd4YsTsOPiTyGcuMh
         puAXQ3eL6JpepLRCOWBeQj8B1ZFVCUTXsdErMZwzkoi62PHp9bbNX+98R89BjeJqG99x
         uxaYNx8UUdimJyMf8e+nCg/Xh68kMZYVRiMx7YpoIiWkGhbTtd/+rdF+dCfGymo+ez05
         Xu2lZswLUCv/1BKvvHz20bEs1GkWr08OKBKYSz3HAfIwHa8EbYqtpAtBgzblY0ZWFZ0H
         ELPWQeZsgxa4bk49c4qjGYrXnIosl7tp1RzSKdCprS/6Oe2bUKumE9u8cSfvqjMKatxh
         SAMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776133801; x=1776738601;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EdMr7+vUo/T6hJFf+NODRnaNrg0j8pROrWUSTuZGg+U=;
        b=j4OIRH1v2o1SJjid23G1QWJ9OErdokyk6hBKjbHcHXieUSRA1xpwYJ62yojK2f6d8j
         Mdvl9yhhrWdOp8qBysV13PhkuYxWlc2F9qR99OdEGNVlTcSqFgJaexZdUYOuNwLMWnY/
         QUkt0vvV9ly38JDdU4KaqnoKc4AmPEOPZfx5ZHRIFMcF7FJtJnVi7dKYWL8zNBPWRvRM
         JnIuR19OWJ6pROltmXPvD4/e36AI5ehE9vNq9HEQYN2FNnSJ1nJ/uaqTbUDfV3nLJD4j
         nxMmENcX5pOhqIgw90OPyTNNyfzwfwDQNkXv03Zl1rJPus4mTfo0LZRTrEmTZy91hYL1
         N9gg==
X-Forwarded-Encrypted: i=1; AFNElJ872m7CRyCNU+GOz68XSzJODXcuMZeUgR/D24WAuK/plTDbZOKyplStySarMNM6viuaJemzUK6f9g7R@vger.kernel.org
X-Gm-Message-State: AOJu0YyzR99l8uJCjmtmZRDmAkAzROLd0m3kYttwsQ3X25zhMcvwEN69
	rrMZ+hBhdiC9CvswKvwMVnKlwses9quT9FuYQep7ELPa73d1Uslxq9Y=
X-Gm-Gg: AeBDietTHma6TE5tcdvyFAuaxsj3f0AMDPoxFw0zTXriQRJiTdBh3tRf9Ylz6D57oHX
	NQuwD8nCuZxhA/14AnpCBiRoucc+GXLTN4aI7zXs+lsz91h/StLjRFTW4w4YVxdYe/DTuoqqOfS
	KE7+Wtf1/qDPrYBagXVoSChhQpej4BQS7G8anmvw6YZkJGX5p+G7nUA4f1sohIVWwIm8Ldu+jv1
	C4CjHV9efJtYZLbDDv4b65+OeOT+vIBrjvfC/X2V0+jcfDOcKp1qmEpq/ND6t1BWztC+9JhkeZZ
	upV6OTcWtNiaCfkgGVHuPISbEqgNbT5cEvTUxec8PXjJ77DFQD7tLtN0l15zt2GdgGRkXCIb0Gf
	MGVlNg4n1Z1haKjo/qFMhYK07/ef2mIEM/hWh4eqEwjPD7phgevqTQUJYZPpNvGPkC4m2UkfYpO
	8j1aUy2Z5v+bVtAZErqgg1ne0oPBCdYXAR+BB+s2F0YA9dzXPDG55+pu99eg==
X-Received: by 2002:a05:6a20:4307:b0:398:8766:4d0a with SMTP id adf61e73a8af0-39fe3d53cb0mr18223154637.19.1776133801169;
        Mon, 13 Apr 2026 19:30:01 -0700 (PDT)
Received: from corpha2-int.rdu.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f0c506150sm12512823b3a.52.2026.04.13.19.29.58
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 13 Apr 2026 19:30:00 -0700 (PDT)
From: Xiao Ni <xiaoraid25@gmail.com>
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linan666@huaweicloud.com,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] MAINTAINERS: Add Xiao Ni as md/raid reviewer
Date: Tue, 14 Apr 2026 10:29:56 +0800
Message-ID: <20260414022956.48271-1-xiaoraid25@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xiao Ni <xiao@kernel.org>

I've been actively involved in the md subsystem, contributing bug
fixes, performance improvements, and participating in code reviews.
I will help improve patch review coverage and response time.

Signed-off-by: Xiao Ni <xiao@kernel.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3adc870d523b..dca564db7cfa 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -24562,6 +24562,7 @@ SOFTWARE RAID (Multiple Disks) SUPPORT
 M:	Song Liu <song@kernel.org>
 M:	Yu Kuai <yukuai@fnnas.com>
 R:	Li Nan <linan122@huawei.com>
+R:	Xiao Ni <xiao@kernel.org>
 L:	linux-raid@vger.kernel.org
 S:	Supported
 Q:	https://patchwork.kernel.org/project/linux-raid/list/
-- 
2.50.1 (Apple Git-155)

