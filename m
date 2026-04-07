Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD7C30EF7B
	for <linux-raid@vger.kernel.org>; Tue,  7 Apr 2026 10:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775557621; cv=none; b=ocmik5F1JLApp5KTq7yQZAXSgHyMaLv7OIXU4F5HgqbKnDCY0fWSveJMqD7Y7pkjWii96TX9ErW4vHIajpsHZYNG5t9tTRJfirxwmlDanQ33ch7pSAhgd4KvWBgsnmIpgSjl7ovFACzQ/WcIgPCVd1SxRzYU/KIs84vNs4VWW5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775557621; c=relaxed/simple;
	bh=aPXlTDxpIbBoZHaSPlJklmvyrpRY3pXGb+hIicBjSyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p0kCAiwKoJ25YQFS4StL8PBgx4ZexCfCYLsCOeZh4GVjeNo6mQyC/nha6SGRFr42sySw5MVSUXaS7JyMLAFEiyNW0IE6A4vfPJtqn56ui8u0kyNOYE2MkJw/8TvZfc/TwrIJS/BgG7xp0/BoVBGhnka8/tJfgm9n99ZAsY5BYcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=D/BpJQJv; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="D/BpJQJv"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-488b8efed61so11976685e9.1
        for <linux-raid@vger.kernel.org>; Tue, 07 Apr 2026 03:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775557618; x=1776162418; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PgkoR1uxRjECAYD3zH0OV9YeFdfp4HRnrqkuUIi3an0=;
        b=D/BpJQJvAvlIP7rCYfiqiBphVP5PHTfYUsHHkpo8MTbR6v7PHxOc6cCkNMrLVnuWwI
         e3YFczV2iIrEwiXA1tRzFYFgrboOmFORSTgiIdxkDl58tdZy7HRsZBpBnnXZfX5Advi4
         bRg03rNZx6AuB5M0E33RElMrrxIwmKDI8uQzvQhTYuUWgPsmVCDQxw6bNOQU0L3yfCuS
         ddpcZCYMacDVD1bjUa7IPDMDF8VzGKguKdG3VEMHdIsDkxSwe4Moj91nl0yFFvStmQEH
         /oFLdbgsiTqWtDUpZqcJaWFwbNW9OL1OLZS3QhXqInYKPl5DYwtw+wW6a4kHsy4EiJw2
         L4QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775557618; x=1776162418;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PgkoR1uxRjECAYD3zH0OV9YeFdfp4HRnrqkuUIi3an0=;
        b=f6pFUPsY9eDCNEETTXDPaNjehc6yJ4h0WZsdhSlNUQwudEHteUS8aHNq7IXVKk7hBI
         8udY8APIeVzFvZ13Wj2Hph+6o0ebpxFBQJWE3ThFW93IRtCExE0tvNPo5j0kKTJj85zP
         leYbXudI5aLPQRA5OxiFM49dF4FMt/C2+HuZOUTUugKFLCRoRPz0KMkgshDtFGBekq+I
         p1hH62Mf311stiWxnrlLM3B+uGPUy95mZ4SL8vFqLggcvv7apkQBZw8yQ49ndJCP+gSB
         7ddV6oUs2QKTToes4TA8ZsE0MIpPF7mAbInMihOZkPPm9AA00UbLzDKktrA3GgalyQlE
         M4gw==
X-Gm-Message-State: AOJu0YyOP1L76hKf17R3wCAHQuXOH5ab64rLXvreN3DeLmvMIwdJX575
	DXUimhiygDs2L7XBKV51wwSgf4NpfZf8LJvyvdfaD9FpQ75DdsdZyIMyb3xlufFCsi8s58GsmUY
	r9xr0qlLziQ==
X-Gm-Gg: AeBDieuAUmuVkXmfymn+Pq6modyY2Uz66C1Wc059Niusblje5keR3c1DM3h8OjdFebw
	98VpDCbgnnc4k/h5lC5DSYTcTlhByxAdUNBFI8bB2LBrFOOMwdfi1SlOlBih6FfxIp1EeXhO1zU
	XBBVcHSOnct9s1vv0K1z7SEbkIGRGNjFRUl5dHw6wsc681Qw61Qi+K9jvkl3I/HJ9K8dOZbc6cb
	INxIA0snqgUjqN/52zibi1Vn+va+4QLHdkKc5ZIT8l2ta784oGuRQ5W/7ShjZBtbQIz274ExUv1
	AUIFnMu/pJTu5BbWl+sRv5ZxPoGI5PZMogRHBADNT0Z6JaZSZU8YjI4vZgODuOwgrWT2wf/wH20
	2Lqnq743YxVUHCGyaTZWYfJVOjyPHKalAjzjTJtixkAlXNrvWVl0ztyt+JNsOanYXL8bh9RH+ca
	1Vi/RQtnvMvLn9surzXFmBiEr46X9ABIrMRPAImk/J
X-Received: by 2002:a05:600c:4590:b0:488:a502:8955 with SMTP id 5b1f17b1804b1-488a5028b2emr163504355e9.4.1775557617876;
        Tue, 07 Apr 2026 03:26:57 -0700 (PDT)
Received: from mbp.lan ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ca760b0518sm16483880eec.0.2026.04.07.03.26.54
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 07 Apr 2026 03:26:57 -0700 (PDT)
From: Su Yue <glass.su@suse.com>
To: linux-raid@vger.kernel.org
Cc: song@kernel.org,
	xni@redhat.com,
	linan122@huawei.com,
	yukuai@fnnas.com,
	heming.zhao@suse.com,
	l@damenly.org,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v2 5/5] md/md-bitmap: remove member group from bitmap_operations
Date: Tue,  7 Apr 2026 18:26:25 +0800
Message-ID: <20260407102625.5686-6-glass.su@suse.com>
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

The member is unused now so remove it.

Signed-off-by: Su Yue <glass.su@suse.com>
---
 drivers/md/md-bitmap.h   | 2 --
 drivers/md/md-llbitmap.c | 1 -
 2 files changed, 3 deletions(-)

diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 10bc6854798c..7fba97a09b66 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -127,8 +127,6 @@ struct bitmap_operations {
 
 	int (*register_groups)(struct mddev *mddev);
 	void (*unregister_groups)(struct mddev *mddev);
-
-	struct attribute_group *group;
 };
 
 /* the bitmap API */
diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 9b3ea4f1d268..4fb9003cdc49 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -1609,7 +1609,6 @@ static struct bitmap_operations llbitmap_ops = {
 
 	.register_groups	= llbitmap_register_groups,
 	.unregister_groups	= llbitmap_unregister_groups,
-	.group			= &md_llbitmap_group,
 };
 
 int md_llbitmap_init(void)
-- 
2.53.0

