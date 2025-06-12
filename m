Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEEC5226D00;
	Thu, 12 Jun 2025 11:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749727772; cv=none; b=G+RdUgiJea3XtXd8qUwSynFRD2JaMJbyfr79mLKmT68/dT+SPkmm34qA1FzNKcUeOOlicqI4jqfxRaUftOPjcAsr1nJ2MfhbVFJ3dChLoPS/IH4ynQFcllVnU9Ohkey1dwIQZ6UmTkMKof3+3G5A6UczczPTmBY4cMQMFrlhPwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749727772; c=relaxed/simple;
	bh=DwCLBrIsKP9OEb0idFj1yCLqoJAJkn13EofARofZqo0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TmTdSVyTCUjOBEjQ0I7nvhzZZJmU6h0kSEo7ZnsJCtJak/HMRXEZwJxv2Suwy8v0sCWt8b9RSV99DOC4vIK5cRYkfzyB/+7UxV/sTkMupu7YgsOzoqojGmcnNNAX02+8IyzXK8+jwPYEzcyioaFus8Y6HTzcZL9e6wJqp93FSo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BgCZmIGz; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BgCZmIGz"
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-72c16e658f4so541066a34.1;
        Thu, 12 Jun 2025 04:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749727770; x=1750332570; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ig9bONScV5PXuS02uwiDUUM7GRnk1Xz4zxJvHquRoAs=;
        b=BgCZmIGzGLt1TGwXV90WnVTp5byx3OOwXekH5qUJ5wEBKdRmyS9MmT+c6tGfrfk28v
         HbXGxkApWZBRAxF8DuA6aPta59wMAtFZ9LadKyW2vGS+cVxRHS8BwmTWnchSLb25CuwQ
         XiVtaSuFk3dwQVmFRRti7t/pkhtIoxVhnlVRWXavYse/ZjtnHkUZEb2Awmq1CO3zpPWT
         HA60p7h44cCcOptSdiih9qKEOs90qKBvrdCDZl30z8X+qvBNZqFdn8n0WSdOf73FL55R
         rP+7IbRvTcMQz57BoE7hEu9uD9JkDCXcuAuZpFBQmnt6BV06JyjWiJIvQkzjpJ/Qxvh5
         UVWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749727770; x=1750332570;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ig9bONScV5PXuS02uwiDUUM7GRnk1Xz4zxJvHquRoAs=;
        b=gxuxqzInbL3bLybWXn7SIOSU3M+Z0Hpe/nxuSrYae4htRSCcHdepv2uWIZoWyPxIf5
         HoAmbgzgsn1JXNSpDdbzbDUon4yT9IypzdNF071YnlFEFmVv88m0S+uCk4l5dvnUt1di
         /12JkXwqc3lKKpM1eJ+DAHMUCUY8Im0TeXkPAp0fO5y/GhAvWv4kJhiTXHPipIRJO/kq
         5fIzKpYldfDYZZqiql9AUc3zUrp/Bx9ZeZw8FvKx/RiYz9Xk5fG/oDYcaDTUqQXTETHb
         Oknlevr6oeCMZNorB2yYEQmnpF2zAKJwQ2Xe9z43WGTksRbQXwSZ5BldcWzJ7vgtzmjd
         oHQQ==
X-Forwarded-Encrypted: i=1; AJvYcCX/hacm8ZTcvz6gb4LJmtwhiQxlAkbGUaVR+yg4/W9sGPk+AvGNntdEopa0t/QizaaD8jGvWsIa7az7Ww==@vger.kernel.org, AJvYcCXtUTBoc9eZQysdndao5yoiVmaG6f4ZKaBA73uk2PeIZz4xh62GwZ5UOwN33ngewyD2T95REaEZii4ZSxo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzl5a2uDaN4ve8Iq7YS3f+JZfATdLm3P1i8C8LRfNBaH9ffU4oq
	8tu6eNiJ6+B8vgltL7f/Chzq/8O5AGHDxq/Js8mXzb0KsdhDXYSo0TimACD+UquPy0Up6w==
X-Gm-Gg: ASbGncsv9HnjdzrurHl7D55B3drpWkecDtn+106fqgMbjj7WLOUUduXgTe9PtCWJ25O
	t7gYb3+Id+a4N5fgLRrAOlp1kJHKA+928DEnO6DeshrMxCZk6I9iv5lfKPftYPqzAA6WCAWXoiP
	2+kA+Lh+ecGP6IZIDE0vqOLXZli5mYW71g7RjlZmj6G8r2Qo14u7Y/lxWpiGtqKgfkvr9QXMbHq
	HcsObbeW1XCDXli5x+gt/kdxz2zdvxYQzDZ7f93lnr77sffJKnojds8m2mj+yNzrNkWwovTQQy8
	LkeyYVR4fP1zWjXW3KA00kLNovv5muHUjsjMd+oe7M2XBaC0mS8+poyEN5lH2MIRSmwHvRH989Z
	+DPpd4A==
X-Google-Smtp-Source: AGHT+IEQWU1BCz0WF/JP+KwPoxVrJMJ9b3THNBIb2mp8Pp4pf0YgyLaLEDBcGECImDqtXUjRy8p/Kw==
X-Received: by 2002:a05:6a00:3d4d:b0:740:9d7c:8f5c with SMTP id d2e1a72fcca58-7487e2b554bmr4026987b3a.18.1749727759147;
        Thu, 12 Jun 2025 04:29:19 -0700 (PDT)
Received: from localhost.localdomain ([114.242.33.243])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7488087a80asm1217929b3a.27.2025.06.12.04.29.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jun 2025 04:29:18 -0700 (PDT)
From: Wang Jinchao <wangjinchao600@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: Wang Jinchao <wangjinchao600@gmail.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3] md/raid1: Fix stack memory use after return in raid1_reshape
Date: Thu, 12 Jun 2025 19:28:40 +0800
Message-ID: <20250612112901.3023950-1-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the raid1_reshape function, newpool is
allocated on the stack and assigned to conf->r1bio_pool.
This results in conf->r1bio_pool.wait.head pointing
to a stack address.
Accessing this address later can lead to a kernel panic.

Example access path:

raid1_reshape()
{
	// newpool is on the stack
	mempool_t newpool, oldpool;
	// initialize newpool.wait.head to stack address
	mempool_init(&newpool, ...);
	conf->r1bio_pool = newpool;
}

raid1_read_request() or raid1_write_request()
{
	alloc_r1bio()
	{
		mempool_alloc()
		{
			// if pool->alloc fails
			remove_element()
			{
				--pool->curr_nr;
			}
		}
	}
}

mempool_free()
{
	if (pool->curr_nr < pool->min_nr) {
		// pool->wait.head is a stack address
		// wake_up() will try to access this invalid address
		// which leads to a kernel panic
		return;
		wake_up(&pool->wait);
	}
}

Fix:
reinit conf->r1bio_pool.wait after assigning newpool.

Signed-off-by: Wang Jinchao <wangjinchao600@gmail.com>
---
 drivers/md/raid1.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 19c5a0ce5a40..fd4ce2a4136f 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3428,6 +3428,7 @@ static int raid1_reshape(struct mddev *mddev)
 	/* ok, everything is stopped */
 	oldpool = conf->r1bio_pool;
 	conf->r1bio_pool = newpool;
+	init_waitqueue_head(&conf->r1bio_pool.wait);
 
 	for (d = d2 = 0; d < conf->raid_disks; d++) {
 		struct md_rdev *rdev = conf->mirrors[d].rdev;
-- 
2.43.0

