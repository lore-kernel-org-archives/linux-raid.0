Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09813D349D
	for <linux-raid@vger.kernel.org>; Wed, 15 Apr 2026 14:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776261819; cv=none; b=uxQHlK/n7xijouYO3NrGvPZfdy6Upvdj5hAHKb6RSBp1wUbq+g37slqWzw4bIoCRbieYOhu/XUkYPnwJSRjFSbesC30ZQjYuY/kxuKWrLlXmnZt5/ggr8ajSe6kNlG7E1+QHwpXGx/OTrzUHfOIztzqxMOnZ4nlhYk8kLflBQOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776261819; c=relaxed/simple;
	bh=nnqGXxfnnV6yNYjoTKzb6sLDEfx22RM+l60ckx5zKbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wg8k3y1tl5MMKkleEy8Ktz0UK/zNzFCghen1wj5LN0SxXyL1zWyAGDYBZnb96EdYaAk8neHLUYrWCVzLGkieZ7S2RGGNmqGMy+Ms67QqkNgWJB6th5xLq47iZya/yrHo15nUq2mBboSOdJy/rNVqN7MTAyvpgdUXc79dTLY5m3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d2Hc1EoW; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d2Hc1EoW"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-43cfd832155so4747427f8f.1
        for <linux-raid@vger.kernel.org>; Wed, 15 Apr 2026 07:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776261816; x=1776866616; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v5OxviYtQlzPzCVpCit04f/ikT/J79HQqEij8t457Xk=;
        b=d2Hc1EoWWUYxczH1hO+hFHE8888qA2Y6EeugT08/cB+zINTeFyDHiGwtdXNcFeLXWa
         UfIIeDGM8nQaxm/HQt+5lsKCzTRcwBxfhpykyu5OB9/mKnn1x0oghXn4Fxw4LxZ1KX5r
         tJhg1bXTXQpLbDasqjv3BrDAMNOKgn9WHM+Qcv9UAiFu6Hls0CnSd+MM9prSgqBAuvRE
         FYQ3kBTZn2fqTW5emgNzkxTZcvOV4mfaJ5+6Sm9BYLMzOe8GW6hNfmrb9RAGQPL05BaZ
         bvqKJJellLUR/mZc1v1KrSJk4I7hiu0RUZmSdWMshveynoUaWvcORiHwYyWE1tLVvZ2r
         KWaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776261816; x=1776866616;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=v5OxviYtQlzPzCVpCit04f/ikT/J79HQqEij8t457Xk=;
        b=gijGtY5FDA3Ih6SJE3prc3Qt7htulnK/hQseooGXINbZUtEOwtSx1502TaoVSJkBVD
         1kCpOqRS/X4+x7p2Z3kUiRJJXkeW3dMwN7vLvD233jSRx2e3+1fYuvGosnah4Tl7IMz2
         tJswx3ocJii+LO8Ak7azUQCO320Fo6hxE38BaPkwBNDVDN/AMwTH53uZ9sxNkVHg4hbb
         shLvPcWBG8/fLmWi+UDyu53vbIrtWnbxZ42VmHCKrG/FhZqQaKAVS7AMIzxFHS3VQbjg
         QyE6rAK8fMJmHTcepr6CNM+rE46eO0xdnpndx9ygdibwtn+ctfrcS2f5cGuS//Ikp/xU
         GFZg==
X-Gm-Message-State: AOJu0Yw4CSyulevZcjpHOUkJUefEglxEGc5XADBSpO6xoxAk6mVzr3UV
	1oFzDqHrO+ykw22H16mNx5q7VBXYlW43lldNDQwhbsvBhP20v3qeYrWp
X-Gm-Gg: AeBDiesQVXHxS1Uky0Y9HinMJXtFVH1ySZjvpjyD0qQD9PgqA3nSSMFjZK1Xd7R6com
	OM86wdYtSfwpBs3xFvLgoik0pfoqS0woq29ijpw3XNgTZpJDNoVp//pmzwqb00RzahXHJ3C6T0s
	5BhBbQxqXiiCd581+oHjEBai0UClLOWWZpbZdBTPi5pEHepRgmCN48K30S/xhfGg0UkRm03bnY5
	8o+4L0DSrKoYdDNYbBDhefUQ3SUumGhSLGvEtB3sBpqWjlaA24tR5yEmvmKv/6MdJha7sVakzOF
	iTBdWYLKqjjE1VMIbsOYY1mOENeH7JRnrSGQ2v7V5+Mvy2Ltnl9P70cgoRm6Oxhgq7sQ6d+pSs/
	ZSJRrCSiErAIuqBJaam1KqMowd4kL4WroFA92fbRRF5+KMUlxWfd5y9vCY5nsI+hiy8Nwxenr5i
	R5n1TaUf/YgSY3VvWSF8B3VS8=
X-Received: by 2002:a05:6000:2288:b0:43d:7508:c9b9 with SMTP id ffacd0b85a97d-43d7508cbaemr21744288f8f.49.1776261815853;
        Wed, 15 Apr 2026 07:03:35 -0700 (PDT)
Received: from yocto.. ([2a02:3037:600:3ec1:dc49:d3d2:7f37:6734])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43ead3d5f11sm5883236f8f.18.2026.04.15.07.03.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 07:03:35 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Subject: [PATCH 2/2] md: use mddev_lock_nointr() in mddev_suspend_and_lock_nointr()
Date: Wed, 15 Apr 2026 16:03:19 +0200
Message-ID: <20260415140319.376578-3-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260415140319.376578-1-abd.masalkhi@gmail.com>
References: <20260415140319.376578-1-abd.masalkhi@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This keeps mddev locking consistent and ensures that any future changes
to locking behavior are done through the wrapper.

Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
 drivers/md/md.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index 3bfbee595156..09ced132a917 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -1013,7 +1013,7 @@ static inline int mddev_suspend_and_lock(struct mddev *mddev)
 static inline void mddev_suspend_and_lock_nointr(struct mddev *mddev)
 {
 	mddev_suspend(mddev, false);
-	mutex_lock(&mddev->reconfig_mutex);
+	mddev_lock_nointr(mddev);
 }
 
 static inline void mddev_unlock_and_resume(struct mddev *mddev)
-- 
2.43.0

