Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC4237DE9C
	for <linux-raid@vger.kernel.org>; Tue,  3 Mar 2026 03:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772509077; cv=none; b=kgUpA6fBlZ0dgV9tiT5jkkVTs/4t0O9juxScqEp9ECDq/rRk/gNSXxg+QFiHWQLmf1srpGJjwu4jJslU3kbGcvII01IZZ1UBjF5MyA5sg82i764b+q4qewg3fquPHLKn0MK0WfmiHRALb1APgIh+AEh2XMIol/h8wjq5j8Pzt6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772509077; c=relaxed/simple;
	bh=rJ16mTlIMn0UjaWtLM9SzAgzgiakON6KyyUSJqzijxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fmf0kYbpiKrQlNJOkrxAy9sdxmY8i+OgRVv/0ZKo5Sl0pXETktPRSyKmIGf1EBzKOoLaTl2ttd3iyEgPHAKRJA7TW09w40cWzXJc930GFfT5SpeDyJBmqvVjDvJBXQn3bnF6MUWfS+wVFYYTAZ1lDkg/IvN7QcCZ9/k/TIS4iO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=e+40Z1W/; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="e+40Z1W/"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4806bf39419so45186745e9.1
        for <linux-raid@vger.kernel.org>; Mon, 02 Mar 2026 19:37:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772509074; x=1773113874; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lin0LZ4thn4V0gPczywAaAZ78OsCteebRyGnbmFxiZI=;
        b=e+40Z1W/BSFyJ95B112T/ZixH3KTkg07yGJrog8+2jDoKheLsCC4MrV7wae/o/IkrB
         M3nI7u0xs1P4HKnuUULlHzz/zrkTn0uuEMmhWp/SeDk6F21Z67nDhXmt43VgUfxNCXMZ
         UFVbEekpj6j0Or64l4P0siaBrRKEyyWENwP9119ktz+AlNwXfaybKqQ4JLFSECCg0YxZ
         cUMsuiYAEnJJypQL0fR0BJwRW7uF+2UEKH1YFu06kC0CTPdZ1CPWk5xaZWxBqymuZtV5
         U6UmpbPKYEZopuMiLyxSokgKmdwaAwfh1NrivEr8haZfrCtqswUxKxYKUdAREJbTjBPH
         ZAhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772509074; x=1773113874;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Lin0LZ4thn4V0gPczywAaAZ78OsCteebRyGnbmFxiZI=;
        b=G4Sew+UYPq9CBXZO9LnRWOR4M6JTYXe/a1pi1Gd25fSvG7zns7x+u1aq79qN6mFcsS
         XT0Z6KdSpTo9YbWJeJ1pWs9K7ddaUn5zbYzfNbDEYU6UXlpH4JLbFrG+6OP5FImLoFDZ
         6bxcAvFQXcETj8HeMvI2Ig2FcQw5TG4DbKWkIcsjm8fixowhpuegdpaxQ+Ys9tpgUqc/
         T+vqvzlANzEpLf2K8Az++AhYLzs25oupuiQpIRbNwqVbh6Z2tFSVAPuuKq2svJngC2bz
         E5sqql44m9Yiaw9qq2HmTsAiEyiCtllDYA28cXfh1bTQkETzhjeTHG0ghV/VUEb9Wy/s
         5Dig==
X-Gm-Message-State: AOJu0Yw3g0QqQWXCUVkCS5mBnx9odtg4ATTGuDmNgIV7vHBRiTvFivrr
	RCI6cXjqxYLbDa7jwPeW0QhLiADWT1mKx39NDH6YSJdUOIDLmR6stQcmfk5uU0fGSSOGVRnRJ5A
	1nPAq8Htu1TCA
X-Gm-Gg: ATEYQzxpdCMcFjOR5Qtjs04ew8DzM7XwttQC3BO2LSQ2Dne6vnudli9jCWoKXTjGVFx
	lf5M2lNxeUNfuDwVDR7eP7mCj0IXTHYJZo8yNxwXiVU3UQ1X/Z/EExVrMWZmNq6CTjPJ9WZIlwm
	/XuYz4OHbUw0tjHRBM4v7HCzhZqcGTg3EEMmHyq2bYVzQkUc0dL9XWnrKCCweCbHSW/xtz/xkaD
	uwXEFjQOXiCZsTqWtz5vd/9PGz553MCKziwdIj2ZtD5sLG+jgfWHKWSLi3TiwBKIgzUF6gXai00
	hVCsCWxbTPGT+uHGLegsFsBRLLbIzhsNNZvyR3VRUpMC6tFi6o/HaoX5RTQ5jGWrJ/9uR8uwhkp
	bzBrhTkMgsGdDGZNGwZT5njzcptTQucNe0TW1hf7RsWmnM4vUQ236RpV3nQ+a+np3Iff9ygi+mQ
	FJkNoL/6qROBSWrsYiGZMqOIfLqg6jJBlec2/2v7w=
X-Received: by 2002:a05:600c:648a:b0:483:6fe3:bb49 with SMTP id 5b1f17b1804b1-4851370354dmr10855375e9.0.1772509073792;
        Mon, 02 Mar 2026 19:37:53 -0800 (PST)
Received: from MacBookPro.lan ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2be16992009sm3929104eec.3.2026.03.02.19.37.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 02 Mar 2026 19:37:53 -0800 (PST)
From: Su Yue <glass.su@suse.com>
To: linux-raid@vger.kernel.org
Cc: song@kernel.org,
	xni@redhat.com,
	linan122@huawei.com,
	yukuai@fnnas.com,
	heming.zhao@suse.com,
	l@damenly.org,
	Su Yue <glass.su@suse.com>
Subject: [PATCH 3/3] md: remove member group from bitmap_operations
Date: Tue,  3 Mar 2026 11:37:31 +0800
Message-ID: <20260303033731.83885-4-glass.su@suse.com>
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

The member is unused now so remove it.

Signed-off-by: Su Yue <glass.su@suse.com>
---
 drivers/md/md-bitmap.c   | 1 -
 drivers/md/md-bitmap.h   | 2 --
 drivers/md/md-llbitmap.c | 2 --
 3 files changed, 5 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 8abec00496b4..bb04e3c17043 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -3049,7 +3049,6 @@ static struct bitmap_operations bitmap_ops = {
 
 	.register_group		= bitmap_register_group,
 	.unregister_group	= bitmap_unregister_group,
-	.group			= &md_bitmap_group,
 };
 
 int md_bitmap_init(void)
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 371791e9011d..c81489aaa767 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -127,8 +127,6 @@ struct bitmap_operations {
 
 	int (*register_group)(struct mddev *mddev);
 	void (*unregister_group)(struct mddev *mddev);
-
-	struct attribute_group *group;
 };
 
 /* the bitmap API */
diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 24ff5f7f8751..78f5fafd59ba 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -1609,8 +1609,6 @@ static struct bitmap_operations llbitmap_ops = {
 
 	.register_group		= llbitmap_register_group,
 	.unregister_group	= llbitmap_unregister_group,
-
-	.group			= &md_llbitmap_group,
 };
 
 int md_llbitmap_init(void)
-- 
2.53.0

