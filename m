Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C95039B96B
	for <linux-raid@vger.kernel.org>; Tue,  7 Apr 2026 10:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775557616; cv=none; b=mVZ9HPclUDdkcKU5U0+eegp/iyiF73MiqLgnu5gRki/pSppOSzHHyAMZrWrVomC2l6UK2aCmbIcN+hsH6/fUpBP+orouPNhA29OsWKlrg7ekNsDFTdI6xd9r6/29gQrhYGZtk+9wWVSAVyc6KWyn/Wmd3s1nObtv29HRL3YADsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775557616; c=relaxed/simple;
	bh=GC10qHcgmQXgpqOAHRRqGukha4dUVDFyYZZXf03n3Yg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cBBWDiRyzJFYgwI3w9L/FnFs+vOTQZtHjq6Gmzcr8t1JtbnmCv3oNSUiLtwnXptFxDnfzVmLmLYKjVsuaU0o1Lv0wT8m7oAD/LrrW4g/3cem/MBwQAb0RNHJTp51nkJYzrQwUsddqOVpQHsTOQtKKJCBYiNQtYl71rqSUKU74LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=NbC3ZRoN; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="NbC3ZRoN"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-488b00ed86fso19517205e9.3
        for <linux-raid@vger.kernel.org>; Tue, 07 Apr 2026 03:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775557614; x=1776162414; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H/OV9hLXf6xcmREIUbaExLk2gydQorDY5R4VLSEw6xs=;
        b=NbC3ZRoNdY1AMfbBMB5ZSlIAxNvaW6fubT9vRET3yUy4ljluAu/MVA60JHptNlMQvg
         4NPlGrIQa6Il3GYdlLbd93CYNDp7JqzaA7krZSK7wYDEVuyY2lAvgXr5PpTrd27zn6Am
         8Ea21tuJVt182WYnXe7my+0A0LoDFT8hh91QRDlrrcXLrOa3Nk6clnynRozxNmnRqL0h
         1up/fxperdjhVqpQ8Cx1yYadalxu9pGKKAIOXCqSOeegxnCQk3Sptm7SWyfEoWho/hWt
         e0kz28mbQ6cVYXnsWL8EBofIn75dz8JKAo3VJPRTEC2+T/vn3w977fl3Oufh44AG2NOw
         wtuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775557614; x=1776162414;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=H/OV9hLXf6xcmREIUbaExLk2gydQorDY5R4VLSEw6xs=;
        b=czQV6IoSs37mUQ8eOskxIMfQX9d+u+Ub3u8lgSYTmKa8XUOZoK2TBkBv43ipjZKqOo
         exs84To9nL7RJvAJ+mV+oCBryOIqGIjJwqTTLjTLZRH87s2Zhu1NXu2eoqVPxII4Cyjd
         lQviqkJ/YJg4QQr316D3TixTeVtafW6I0zoKty+JGUWr8VK38Nn4A0732jDpJaGV09sm
         RCKBNAWolT9G6kPrgL20jAIbqIDYABJMI7pry7EytbmofOrVaFbKRTd+jIOkfiqKJNxO
         /liDvHw8MnuPedfoZfDoraXOdWBsd+MnpGr9qSAML7HJyi0PLe+8XAXxUeUJ7YFikWpl
         11WA==
X-Gm-Message-State: AOJu0YzwQzZ27LijiXQvlBU4CqbmEd+Tn1DmAXShAzwqfOhWeh2G3DxR
	FKL7bctg/IIhU8dFUf9QJuwGUfcesv26q8cbbhNA9SWT6H1EVGtNqZH3PJOm4kTmfsfPl+dS+uw
	Y7tUFBjedLQ==
X-Gm-Gg: AeBDietoipkQerGjiD2T5+OPwdoUVt9yk/mimXt7i6ceo+hjTPpxSRywyII9S/mX1WF
	6ur1VD6nc1QSkqmQClUehJDcO2C/rpqN3FxrZAnzinDpZzm6Mpm4pN/+z+mLQuG6095FXGOi3TS
	lJ8J3E3xHZefFDtHhBj9BcLTYM8ltk551hPJN27JcOX+yDh0O34keb1M/TZ7sLkD/27iS5NSAwT
	FE8/eJO5MBSZs4lIS9hPp/fVnj7YZU5+o3UwWQma9ZI0PdNJ+Q3jQTyhkyAsVxBlreEshgKwz6v
	UXsr4nCnfP8DVX8liR50sOl1XdqxrqHX+kudi/lVrez+TVJ8mX9rPuFPPO1o+9U31YMTkwsL63q
	nhegp86ry1qADd+93s1BNFy9BSu2ouSladCHHiPses0pbpECEop+dzIuAkYkuyGECia6quFaav3
	jk7zvZkTBPoi3MFQAYTOrA0RWz9ZQ07g==
X-Received: by 2002:a05:600c:4593:b0:485:3423:727d with SMTP id 5b1f17b1804b1-488997dec19mr248007415e9.26.1775557613805;
        Tue, 07 Apr 2026 03:26:53 -0700 (PDT)
Received: from mbp.lan ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ca760b0518sm16483880eec.0.2026.04.07.03.26.49
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 07 Apr 2026 03:26:52 -0700 (PDT)
From: Su Yue <glass.su@suse.com>
To: linux-raid@vger.kernel.org
Cc: song@kernel.org,
	xni@redhat.com,
	linan122@huawei.com,
	yukuai@fnnas.com,
	heming.zhao@suse.com,
	l@damenly.org,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v2 4/5] md: skip ID_BITMAP_NONE when show available bitmap types
Date: Tue,  7 Apr 2026 18:26:24 +0800
Message-ID: <20260407102625.5686-5-glass.su@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260407102625.5686-1-glass.su@suse.com>
References: <20260407102625.5686-1-glass.su@suse.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As none_bitmap_ops is introduced, ID_BITMAP_NONE should be skipped while
iterating md submodules, otherwise:

$ cat /sys/block/md0/md/bitmap_type
[none] bitmap llbitmap [none]

Signed-off-by: Su Yue <glass.su@suse.com>
---
 drivers/md/md.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 55a95b227b83..20a953676319 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4269,6 +4269,8 @@ bitmap_type_show(struct mddev *mddev, char *page)
 	xa_for_each(&md_submodule, i, head) {
 		if (head->type != MD_BITMAP)
 			continue;
+		if (head->id == ID_BITMAP_NONE)
+			continue;
 
 		if (mddev->bitmap_id == head->id)
 			len += sprintf(page + len, "[%s] ", head->name);
-- 
2.53.0

