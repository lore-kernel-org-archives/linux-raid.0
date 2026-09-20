Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9EA43CB2D7
	for <linux-raid@vger.kernel.org>; Sun, 20 Sep 2026 10:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789900631; cv=none; b=RFsgxfCJk9+fdLhLXFeZMTa2cJr6q1cCm8R/ihJoSUgpIHMTZAgOTJy4kE/7oTGTSbfbF8EpFvgG2iZ+1KGJ7ONHL1fH/z1OZlwRoD5DYsXwEDSaklYVSLCz3af5iSeWy4ZBp1hdwFRunkB6JI65XVFXQQNdPReISK63qhghwIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789900631; c=relaxed/simple;
	bh=Xr7L/LVpjL3GQFGR8E9vjXeRDSdu2y58YHZHJfhpoVI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dT0T0gA1jIpQc/tsnDN149VtL2mcWC4FE//9IYMBPY8cySy9QZo4WCLAwh17kYNLn1O1DDvTBwFeO21jvo+Y3UjY0S6w40c5VLGbc5YQuhTttSu4JzBtWp0DDp7BrHjIqceCSZvUar5w8gFLjfUM0dILTtS9GddokKd6qzE9DWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=UEr2JLQJ; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="UEr2JLQJ"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-48436686a40so199169f8f.3
        for <linux-raid@vger.kernel.org>; Sun, 20 Sep 2026 03:37:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1789900627; x=1790505427; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=kmMG7+knsRKVkSdz7OMe2deg70Qp3sxmdG8NVLuTxqk=;
        b=UEr2JLQJ4SCWS1JcDc9SdjX38mJxDYydJF8bfCMsh/XlUfLjfwYd7S8YAi6Yem9hxI
         5ER7SxbA3FEuhFRezPSl+VlDyh4YYjrn3yzzQPTskdq37P6IRh3VWdPpkrFLaD7huyOw
         L5/C0OZeFVlMtPS84n5wD9ynI4Bu9oOzNQM6zFwLMjQ/Hm1UXBNcMVeCrJoTINrAutYb
         al0aHztRWkS+SpWWITw+LQ3oydnqGJmO5JnIF9C52QEJjcT3Z+sJYXdFlZfje6b9spW5
         y1uyudaDZ4NyWrPQfbaUmyNqif8xeQrmpfXzI8DhxfhvDpgrpONeFeK0PImhhpX3KHL6
         dwQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789900627; x=1790505427;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kmMG7+knsRKVkSdz7OMe2deg70Qp3sxmdG8NVLuTxqk=;
        b=zb5iuthBthgLNRtpFfFTNQks9erwUaA6kbZf1vRJUorxEvIc8m5ryrSY1rJl2SSZn4
         xdhyh5TerTnC34noQERYkQk8BE1w5F/UQSeziFmmWNm1//57nZS9+QrOZDwWtRFLeMXI
         3uSCB4u3t30vrjoxFN7cTCIoBwSDmKxg+QGVPHN0WYeFlxLPz5TPlZEz/ZvC1KkWdLp7
         GQcJwubCppcKMUkC650PwFaf+3aqsQMqKkt/BcdhT5nQFCKvNLzFc0PXSUtXdr1IGPSz
         UpwFeyi5bZbV8VXu7WuItjZ+M1XadQHvdVQmFfb40YO2S0X5GUIng+WX7BEOwV4zMwA6
         /eAw==
X-Forwarded-Encrypted: i=1; AKwUvBwMDqNkhw2hFxRiXfDg9al9WZDRfT2i5wqDzd8iNz5K1o7lcMK65MRWzBQlQissmB2RxFd3AuIGSMRb@vger.kernel.org
X-Gm-Message-State: AFuF++k7WSqxgF175RpLUoPZ1WkH3/ZvD6DQ4gzKkyJbPh1bexVOUQ2t
	G83ZsYOP0ANHQ6/4eiOCp91eJNQWoFIK6eKVQ2mxYEJrynu4u3/JiYrqZYXQbvKTdwI=
X-Gm-Gg: AYBFou1+bBpJVgmhUkcENq7jla0nnY718YxSpwiCOt9M4gF20ylUfBtF/8o7YYSFmgN
	EsDh8rAvXvwNaC1fAwa+lIzB4XXSozTADSU+2Y7QUV3LBxEnDopbx43LlmRSd6WJFvKK+qCUtZd
	ZGvqy0gdeenkmWgG4kPfT12N59KYixe1Ii7mLR/ZprKTGbC0R88tmzxLDKpPQPzLGcdO0R1xsTt
	0VMth2j6I58FiXrClHkPabIbrK61p3fNOLcI+dPC4SJEO/q1zkaPDkXDF2OqbXLEcv0MbiogFOv
	kxnMVmrB8qYWYW6zHlXvE8NCX4f7k0Lh3D9AC6iCTP7MiRBjX+V7mreEOwVfA5htDaw1FoPhPfQ
	JIWOJjv+XBsBfd7ouCiOForjdoiyFSM6uuXrNFwRmCag6rWywok19uFmS3n9ix7wJmAJdkVKBFq
	z3JLb2cGSH7tRTXugoOQV7ofZl47sqdRBNY/qeON6omIvCnBSUeGj+JBcfcRrhVCkozQTi/VWLT
	1xgbtvssxz814ZAIOKFHlQiueACQ9Y=
X-Received: by 2002:a05:600c:609b:b0:49c:f9b8:bae0 with SMTP id 5b1f17b1804b1-49fc7f2bdc8mr115621765e9.2.1789900627044;
        Sun, 20 Sep 2026 03:37:07 -0700 (PDT)
Received: from jwang-ThinkPad-T14-Gen-6.fritz.box ([2001:9e8:144b:bd00:675a:38f6:9365:abd6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fcd103325sm164915215e9.9.2026.09.20.03.37.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 03:37:06 -0700 (PDT)
From: Jack Wang <jinpu.wang@ionos.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH] md: fix mddev_unlock() called without holding lock in lbs_store()
Date: Sun, 20 Sep 2026 12:37:05 +0200
Message-ID: <20260920103705.23191-1-jinpu.wang@ionos.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jack Wang <jinpu.wang@cloud.ionos.com>

lbs_store() jumped to the unlock label on mddev_lock() failure,
calling mddev_unlock() on a mutex that was never acquired. Return
directly instead.

Fixes: 62ed1b582246 ("md: allow configuring logical block size")
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 drivers/md/md.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 680b34a63cb3..41fbe5d9961a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6048,11 +6048,10 @@ lbs_store(struct mddev *mddev, const char *buf, size_t len)
 
 	err = mddev_lock(mddev);
 	if (err)
-		goto unlock;
+		return err;
 
 	err = mddev_set_logical_block_size(mddev, lbs);
 
-unlock:
 	mddev_unlock(mddev);
 	return err ?: len;
 }
-- 
2.43.0

