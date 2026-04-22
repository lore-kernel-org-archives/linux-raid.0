Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8443C4557
	for <linux-raid@vger.kernel.org>; Wed, 22 Apr 2026 18:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776881256; cv=none; b=BvfhRxmpmY9XmiEGzE5NQLDwU9Y9Bc9EEqtDfAf24QOMjvSsRGE/79AZufXy+igVyFpWbfVBxgQa3k5qPFCQI0Cbpv08HrXcCvZwLt+aebNfBoymjbhpQvmSC1GyRdVM5G1zbjnkEJudJaSqjMY+CyGgFiJdbhonnjp9AlhhiPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776881256; c=relaxed/simple;
	bh=68e2vkBr3OUqhrf81M0NoGbo9Z0zZ3BkkBAVPKwS+nU=;
	h=Date:From:To:CC:Subject:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=AgkzbosYzYxwmRGHOhr0A33NCs9jbtNqISH1+a07pSsb8Z70CjhhOguF7ZfgPN4inp0jLlYrj8h7eHpjwRn4z8isLYP58J6HEDoHwzOucDGMAqkQ9+NHVQGLnf4qEJ5Dcxs3/Cwy0B1ppME2wNAAnwBbyX8umz571nhFuRi2Hmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cyczf0e3; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cyczf0e3"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-48984d29fe3so50751585e9.0
        for <linux-raid@vger.kernel.org>; Wed, 22 Apr 2026 11:07:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776881252; x=1777486052; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3v4gati8jz+0eLCt+fkaA6QE0HrpYumOYS61o02yFpA=;
        b=cyczf0e3ByeaAAZFS5OtD02KqMwtPiJ5sdAH0doKrgxnWr8k3GqsYCYFsk0aA+bKjr
         2iJIGWEX2HbeBKfCL840kscvJzAkq12kymk5enin/NgxMOHE/REUOw+QwFdymzXlFpbx
         9+wqGE3i4jhLv+MH8PzewpiOgg0krrrj6icX+wfIIwxEI9bXs7FKQ9SUSuLRHFQ6qh3s
         Q8QgSPZisTwyp0WBgsU+76Ewn89RwyeVcZA5gU5R9kVXh1mmV6CBn6/bNvvBSKfkXmkV
         H5wOOrOPQaFXES9gFDsMiGkMKwTzcSOzq/tNBcLH6sp02P39Gw8535w4H8BwxqD4L5gl
         n82A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776881252; x=1777486052;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3v4gati8jz+0eLCt+fkaA6QE0HrpYumOYS61o02yFpA=;
        b=miEqHTNd+XSUDj5soMcxUuGi9FLnSsoH2zp3RdpnnT1LVUpLk5fu9XhKKN8dMWhNkn
         O0OORuKssDcfGfU7NbayVHL1Im/Je23r+ap7rmabG8p2TBXvS7WxS+WH2QDhMq8ANMsg
         aqrPqrfw53zGb9dmIS2UbnIqQ/lcOFv126ltGL1+ZY4qGaJba+sXowqVxKgv2OTHZM/6
         uaW7s1Mkwn182ZvPAOiwt9g2XoofSLYUIOaWv0xf236hVnCOOsV4fVEcY+tgjGSF93At
         FZ/8hRwxqAmwW+ajQ2PXuSweqZJ2f9v/+To0VAcr/iVA1kkfC9yeT+kx8YNeznQsIbz9
         3b7w==
X-Forwarded-Encrypted: i=1; AFNElJ8bTYLRj4Hg3JJANPJbVaPo0nQtfUObg3ul3oICzRVbALfoKUP+pb9f1jacqNmcX5Ft5figtDWGNDz6@vger.kernel.org
X-Gm-Message-State: AOJu0YyG4kd/DvGiOnKbm9NfPuI51WjhzbXtrorwom3SZ3j+HyK61mvQ
	ZFjcUyc5rjxp1Il8zUdHPpTtN/0aaxmtx1Q0pa3tvfdjH2P2xNB6ZPS/
X-Gm-Gg: AeBDietxgfBfBapO9FnvHpiBhflarVc1Du+yW/Pq9pQDoGv+soluK40IplDnJeh8L1d
	FgDI6+Itkx5/pXheG8Vng1KJdEpiGOxlBGKuilvv812bUkRW9/OxQYgzAmnHde6XxkvkxOhJCWE
	RCC0m23Fs1sl3JjGmYvF2zRgJph/9Hpe4Uz4eQxnwF1AVmjPd9wkw+v8tTTi00/9w9AFqdrvKMU
	rwf/j87oc00dFGIztUDRtci/W8WTZajsJlhdz9wZvfl9zbupA863dl7bDJ6pvIdRZ5Ozv6LtLng
	iPCJZMi8oWqn3/HDyPNIQ1S/OLAzDk01t0vSYzTiHKkhvX8mguhHxZDYxcxVh8ZfYIlS5lZyxux
	NBfN27SMh4xvi8Hb5hTRxbC+LWTUWCBSdLC8ORjTI82QO8DIO3PYAlcYzMDQ0ufziX86bZU1H31
	Ma4JUbVLmKuvjsOQvPw+p2TWqcmQdgWWUxikOa
X-Received: by 2002:a05:600c:859a:b0:48a:53ea:13df with SMTP id 5b1f17b1804b1-48a53ea1500mr120994365e9.2.1776881252234;
        Wed, 22 Apr 2026 11:07:32 -0700 (PDT)
Received: from ehlo.thunderbird.net ([86.1.69.5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fc1393f5sm432764375e9.9.2026.04.22.11.07.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2026 11:07:31 -0700 (PDT)
Date: Wed, 22 Apr 2026 19:07:32 +0100
From: Josh Law <joshlaw48@gmail.com>
To: ardb+git@google.com
CC: ardb@kernel.org, arnd@arndb.de, ebiggers@kernel.org, hch@lst.de,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-raid@vger.kernel.org, linux@armlinux.org.uk
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_2/8=5D_xor/arm=3A_Replace_vectoriz?=
 =?US-ASCII?Q?ed_implementation_with_arm64=27s_intrinsics?=
In-Reply-To: <20260422171655.3437334-12-ardb+git@google.com>
Message-ID: <3341B2B2-9B57-4273-AD5B-EDDE00CC4119@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit

Hi ard.

I like this patch.

So, I'd be crazy not to say what I love here.

+		/* p1 ^= p2 */
+		v0 = veorq_u64(vld1q_u64(dp1 +  0), vld1q_u64(dp2 +  0));
+		v1 = veorq_u64(vld1q_u64(dp1 +  2), vld1q_u64(dp2 +  2));
+		v2 = veorq_u64(vld1q_u64(dp1 +  4), vld1q_u64(dp2 +  4));
+		v3 = veorq_u64(vld1q_u64(dp1 +  6), vld1q_u64(dp2 +  6));
+
+		/* p1 ^= p3 */
+		v0 = veorq_u64(v0, vld1q_u64(dp3 +  0));
+		v1 = veorq_u64(v1, vld1q_u64(dp3 +  2));
+		v2 = veorq_u64(v2, vld1q_u64(dp3 +  4));
+		v3 = veorq_u64(v3, vld1q_u64(dp3 +  6));
+
+		/* store */
+		vst1q_u64(dp1 +  0, v0);
+		vst1q_u64(dp1 +  2, v1);
+		vst1q_u64(dp1 +  4, v2);
+		vst1q_u64(dp1 +  6, v3);
+
+		dp1 += 8;
+		dp2 += 8;
+		dp3 += 8;
+	} while (--lines > 0);
+}

I really like how clean this is, I'm personally nodding my head here

Taking the "bad" guesswork of the compiler here is also amazing, it also
guarantees we won't get stupid regressions in the future.

Also, that performance boost is even better ;) 

I'm not the biggest expert of this subdirectory, but I understand it well.

So well,

Reviewed-by: Josh Law <joshlaw48@gmail.com>


Thanks! (I will review your lib patches) :)
