Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0D437418D
	for <linux-raid@vger.kernel.org>; Tue,  3 Mar 2026 03:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772509073; cv=none; b=q+UjXo9+nYKqEVFi0JsSfirbT+I1vP2qIkdCiynPKj9slEjDY+G8RBfFyyTtuu2sbnVVzc63rvOz3YBf6tDSRyXgSwHBoQuUEQHNNKmke4khcWsd1ta9ob14qA1tcFRFtyrnVHgv159zDdBP2SYFvoMU/8ULl7TlczgPPbCiePg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772509073; c=relaxed/simple;
	bh=vWq1xKG6gBW84h4RsmQo+0yWfAfxHei+rUfejUl329Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ANMwlKY7SJKoAbe2E7uKhxpGk+1p8PkBraoV7swDDuasmwgBMTjyBjd8fYMtkLLoV7noY2M2WITEsnK0NOSr8i0KAFomwC9aO+931fw/Mxl32ushUqA3NTig2b5hydFRRH9dfSxE5ziSbnD+0SRxahQ2HufWLvuSOKp3hDG55S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Twk7tjCi; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Twk7tjCi"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4837907f535so44662295e9.3
        for <linux-raid@vger.kernel.org>; Mon, 02 Mar 2026 19:37:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772509070; x=1773113870; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tMTl9wzul0A3+0vUUmxQBSuqOvwuNMp3pJDcXDVOb/c=;
        b=Twk7tjCickuPfS7EeDBT3lpFuqXOLWbEhfeHHRiPpO5uGCHRv4yXNGjVcLHxgaScv7
         RQdLSNg7Lgj+S4muVok/br8KWix/0txtkQx0+59D/SjMMEJRb20vxP36PD6kEAnCPuK7
         ReysjVgTamU4B7RnzOSVusOiL93zddtLcHvXhGXl2GAVucl8iruXlOrMw/Ecf9fz+wRJ
         5UBa+8i8K0vUjm+sVee0X18PgLlj7kXo/3epfvwbuWuetmIXzm2I6ITpslKF1/W6O1oT
         Wnz7vIv5BmNUjgLOTutR64BjgHdxq1YlT8YAob7J2FkB+WbI6al6ebM3XsAyFPFbLu/p
         8+MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772509070; x=1773113870;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tMTl9wzul0A3+0vUUmxQBSuqOvwuNMp3pJDcXDVOb/c=;
        b=rrfFS9NGu6O6Vx/YDd1piQdYyfL3/8TXA0ieNvi7U1J4fCDj/o+VnvFeXYQPyj6hP6
         VCwY6U1h74Tvy0jUIdRGv8jY/Lzkz34qwlxT/1Vsp3MBotxOm+IZiw12Dz5fqRd9BjXo
         FozfS1+6+t2HXl9PpVEJkGBHVhB1mo/kLen2xZxoDpTvpsN5TJd12sj7N5JCuZeORJf9
         lOVgYNPsQbZqR1C1JZ9vkzne4oQq9N9dcekkTEU7mwRLWYALfT7Fg6fwB8CACs9rwaFB
         uJ6bhID+Vx7saTc8XbspgCTGurbT88SHIUphqsGM43S4vqfKQUUpS3vEfjLkdDdoe61J
         02Ag==
X-Gm-Message-State: AOJu0YzBOAlZU7tU8B7Pmabz1Z6ZuM0MKO7yaz/8phtilCFSpctO59+7
	6HntVuLnOZ77pH1Xn3kvht75YeUBp4dh2y1kcaVQOnNVbhRxegJBM7LeawD6KD49m94wGTa2Rbt
	aemouDuzq5Y1n
X-Gm-Gg: ATEYQzzhfcrKRYJ7Ubl51zqbYl83C2tocwN6MpW9vrJ+eR8SQgfJX46Ipehc4GsKmEp
	M5MXflKarKFKiRTDqIBWuh0lRKMfFsfSQ+BcLLUvGvNjslVSMmGwZUldSEb+4DheOG6z7/7qBkX
	nk0RwJyQL5E0TEcGgM1uMtwmUBVbntBG25Zs4UMNPnktbCqkxVPRL6TyNE4feMstTDqqmNHJOyE
	2D+uRgSJF0Qhd9SlALwzvGZHHobmZPW70gXqFT9R/ySYyKEdfBnwgRyWhb76gZ3QnSkDWsPhrFN
	rAyJW98S5AFTAHBFGJ7IXB7eNguydKJAe1eQQYUKwnht1o+b6aE0Wclrysc6hwlJ/u5B0kCCi+/
	H4QJwkC12T+iVzYeVpguklp4P56Z/Hru/sQE72USP95bhOQIZRC2RydqxNooPX/8q1XNZq4kF9b
	RZ5uFS5ZhJlRw/L8qPoEpflgN1eCb9KoAT2C/tTLo=
X-Received: by 2002:a05:600c:4ece:b0:480:69ae:f0e9 with SMTP id 5b1f17b1804b1-483c9bbbf04mr279357125e9.16.1772509070359;
        Mon, 02 Mar 2026 19:37:50 -0800 (PST)
Received: from MacBookPro.lan ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2be16992009sm3929104eec.3.2026.03.02.19.37.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 02 Mar 2026 19:37:49 -0800 (PST)
From: Su Yue <glass.su@suse.com>
To: linux-raid@vger.kernel.org
Cc: song@kernel.org,
	xni@redhat.com,
	linan122@huawei.com,
	yukuai@fnnas.com,
	heming.zhao@suse.com,
	l@damenly.org,
	Su Yue <glass.su@suse.com>
Subject: [PATCH 2/3] md: call md_bitmap_create,destroy in location_store
Date: Tue,  3 Mar 2026 11:37:30 +0800
Message-ID: <20260303033731.83885-3-glass.su@suse.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260303033731.83885-1-glass.su@suse.com>
References: <20260303033731.83885-1-glass.su@suse.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If commit
'md: restore bitmap/location to fix wrong bitmap offset while growing'
is applied, mdadm will call update_array_info() while growing bitmap from
none to internal via location_store(). md_bitmap_create() is needed to set
mddev->bitmap_ops otherwise mddev->bitmap_ops->get_stats() in
update_array_info() will trigger kernel NULL pointer dereference.

Fixes: fb8cc3b0d9db ("md/md-bitmap: delay registration of bitmap_ops until creating bitmap")
Signed-off-by: Su Yue <glass.su@suse.com>
---
 drivers/md/md-bitmap.c | 12 +++++++++---
 drivers/md/md.c        |  4 ++--
 drivers/md/md.h        |  2 ++
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 8ff1dc94ed78..8abec00496b4 100644
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
@@ -2653,15 +2653,21 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 				goto out;
 			}
 
+			/*
+			 * lockless bitmap shoudle have set bitmap_id
+			 * using bitmap_type, so always ID_BITMAP.
+			 */
+			if (mddev->bitmap_id == ID_BITMAP_NONE)
+				mddev->bitmap_id = ID_BITMAP;
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
index ab969e950ea8..80beaff5ad39 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6455,7 +6455,7 @@ static void md_safemode_timeout(struct timer_list *t)
 
 static int start_dirty_degraded;
 
-static int md_bitmap_create(struct mddev *mddev)
+int md_bitmap_create(struct mddev *mddev)
 {
 	if (mddev->bitmap_id == ID_BITMAP_NONE)
 		return -EINVAL;
@@ -6466,7 +6466,7 @@ static int md_bitmap_create(struct mddev *mddev)
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

