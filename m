Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77AA3976B8
	for <linux-raid@vger.kernel.org>; Tue,  7 Apr 2026 10:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775557604; cv=none; b=NymI6K6DaqPexxYbNBkp42VmVSEfandZfI/nhx0Y5MfBSKWSndnsqHAQRu4xrLSqWCncbUpRgo1oSahmtmc/479jfwwnqmZSLUJxESrPw77sdhSCPhSXRZ4Z6yBwKYgcAkq9dUqEaWNG5AesIJzyY/uKxSn35k3JVmih3iHwIdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775557604; c=relaxed/simple;
	bh=LIlyuYuwfq9/E2gSu4kQqewIgoZDcG8fHgZ/eSzA1zM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n9E8ai3RbEqL/u/225h3FuVslXrUlEKIz2nXsRuxMiAlg260SAgRSAPLauuORLh/jI5zxT1VKxgAOWglCAUEoJJ0EnP+YJsbpv6mJX1oYi4PpV6/CdCU+VlA9tXVgOTb7VCrA5Xi/zYotzFhQ/GdhjLaaX9D2HR1XSr1LZfcK8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=KF/wNVfN; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="KF/wNVfN"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-488a4bc360bso14811975e9.0
        for <linux-raid@vger.kernel.org>; Tue, 07 Apr 2026 03:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775557601; x=1776162401; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tLVwnYzy3JwahxnqO7WBBIhfRDsW2a8rkBIOQQFnjG4=;
        b=KF/wNVfNImB5kHu6KvN8hVOvDHLhSYi/mowJx6Iuh9kKyZstzzvgwAka7hTqTuU1iD
         r4Fa1bcKanLylTKJ6oPnzxsnrTD/JnLLjM0FZWwEwcD2S5qqnd1MFXvZfxHsPzRr2h5q
         bGAlysGLmiKhwg/lr0/ySibCesP+4zRyRGRD+eMjjANBOa5vIez0ckezwLm0G3Z+XYG7
         fW9eReHVhcrzw8DBbwFfyJRBVGHfsLgyR7VhKy+EZmbhQ9Y9LSnakI2TdZG1YCWkouaD
         aoFxunKdMUWoKfy9otRsLweS+Boncsl4OH/wsaDpwd8joe1AH2b1iyhdAMwBPvwCpwN0
         n6+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775557601; x=1776162401;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tLVwnYzy3JwahxnqO7WBBIhfRDsW2a8rkBIOQQFnjG4=;
        b=j9saEyPXNa2p7DKchdo4FLj98/pAxSLStKucYNRBnfs3+4+AKkUH4HNvaLo2Nd/WOE
         GXxsJvPc0J1cy/zaw1sVi2iKamOfo6Vjns6/Kcv9rnSyoavkh8h/OgZ8Cfv3sPV0dare
         b7BYhEevadvv+KCqw+WOuGinBWSqJirYjhltrEEkdVLXzkmqsxkR/wzO9qoEpte3rQSt
         W22hSRIGe6GYQqtXehBWyR79sljQDhqohIapxKifBl+wKER1p4090CgqTyfBuHVQ/mO8
         0yAQVlaO5bnwZCt2RqJEPbJT4EYTmk3AeXcPYn4puZ+mhqyE2tLVVFxGOc7DHl+4ZVZD
         CDow==
X-Gm-Message-State: AOJu0Yx4e6x40SfPgJYXPLsi1YC//Yca5jdBZQKIel5E/Mrs58/02HFc
	OLBiC2q/+88V4twRaWh9AajTIJqTtUY5QNrig0Fu6H4SyRqjZWzDBEYd627Ar9Nz0q/STQr7hKo
	3Qw7FQy/UtQ==
X-Gm-Gg: AeBDiesgSePOm+flp6mGWzcxlmMk7GlU+mYUJneSpDxy/iWxOi0qRIxshCpCKSBZlhX
	+eIVP2na/TW/dT+xjIikKWiaLa4h5KAhn3ILl5J21OJUaV0g8FWP7d1lCZuLUcyYqbNcQjtfNdn
	fCLpLX+EPKWmnoNCKf5YLU5lGpiA/G6omniykD0KQXg78iU6rZsjoRPyJyAJo7H+doBZp3C0rD9
	pyKtMlCfAr3y+4WMM3NqGXIs63Lt0uzr8hEg3ieE18DRqCMDxbv0+mSjBybJP2pHAUK/3uk8QTj
	yF9nl9ZEc0IRGPankv2yCHUq9bqcYRL6m82eIYCVhGrBilrJPJ2Z2fWtmP+sUkxouYDt4gaBM+0
	1cqmFKlOU2k+pvhlUJ9ov1VJPSOPNO2smsicYQBftw+SYpTGR2GEC2Uxe8yV2rS75Mi9m58kquG
	IuhIUZVhE/qoOAZdlrRbhbM7BSNZpRAg==
X-Received: by 2002:a05:600c:5292:b0:487:1826:d89b with SMTP id 5b1f17b1804b1-488996ecd1cmr251966375e9.9.1775557601041;
        Tue, 07 Apr 2026 03:26:41 -0700 (PDT)
Received: from mbp.lan ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ca760b0518sm16483880eec.0.2026.04.07.03.26.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 07 Apr 2026 03:26:40 -0700 (PDT)
From: Su Yue <glass.su@suse.com>
To: linux-raid@vger.kernel.org
Cc: song@kernel.org,
	xni@redhat.com,
	linan122@huawei.com,
	yukuai@fnnas.com,
	heming.zhao@suse.com,
	l@damenly.org,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v2 1/5] md/md-bitmap: call md_bitmap_create,destroy in location_store
Date: Tue,  7 Apr 2026 18:26:21 +0800
Message-ID: <20260407102625.5686-2-glass.su@suse.com>
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

If bitmap/location is present, mdadm will call update_array_info()
while growing bitmap from none to internal via location_store().
md_bitmap_create() is needed to set mddev->bitmap_ops otherwise
mddev->bitmap_ops->get_stats() in update_array_info() will trigger
kernel NULL pointer dereference.

Fixes: fb8cc3b0d9db ("md/md-bitmap: delay registration of bitmap_ops until creating bitmap")
Signed-off-by: Su Yue <glass.su@suse.com>
---
 drivers/md/md-bitmap.c | 11 ++++++++---
 drivers/md/md.c        |  4 ++--
 drivers/md/md.h        |  2 ++
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 83378c033c72..2f24aae05552 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2618,7 +2618,7 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 			goto out;
 		}
 
-		bitmap_destroy(mddev);
+		md_bitmap_destroy(mddev);
 		mddev->bitmap_info.offset = 0;
 		if (mddev->bitmap_info.file) {
 			struct file *f = mddev->bitmap_info.file;
@@ -2653,15 +2653,20 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 				goto out;
 			}
 
+			/*
+			 * lockless bitmap shoudle have set bitmap_id
+			 * using bitmap_type, so always ID_BITMAP.
+			 */
+			mddev->bitmap_id = ID_BITMAP;
 			mddev->bitmap_info.offset = offset;
-			rv = bitmap_create(mddev);
+			rv = md_bitmap_create(mddev);
 			if (rv)
 				goto out;
 
 			rv = bitmap_load(mddev);
 			if (rv) {
 				mddev->bitmap_info.offset = 0;
-				bitmap_destroy(mddev);
+				md_bitmap_destroy(mddev);
 				goto out;
 			}
 		}
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 3ce6f9e9d38e..8b1ecc370ad6 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6447,7 +6447,7 @@ static void md_safemode_timeout(struct timer_list *t)
 
 static int start_dirty_degraded;
 
-static int md_bitmap_create(struct mddev *mddev)
+int md_bitmap_create(struct mddev *mddev)
 {
 	if (mddev->bitmap_id == ID_BITMAP_NONE)
 		return -EINVAL;
@@ -6458,7 +6458,7 @@ static int md_bitmap_create(struct mddev *mddev)
 	return mddev->bitmap_ops->create(mddev);
 }
 
-static void md_bitmap_destroy(struct mddev *mddev)
+void md_bitmap_destroy(struct mddev *mddev)
 {
 	if (!md_bitmap_registered(mddev))
 		return;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index ac84289664cd..ed69244af00d 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -895,6 +895,8 @@ static inline void safe_put_page(struct page *p)
 
 int register_md_submodule(struct md_submodule_head *msh);
 void unregister_md_submodule(struct md_submodule_head *msh);
+int md_bitmap_create(struct mddev *mddev);
+void md_bitmap_destroy(struct mddev *mddev);
 
 extern struct md_thread *md_register_thread(
 	void (*run)(struct md_thread *thread),
-- 
2.53.0

