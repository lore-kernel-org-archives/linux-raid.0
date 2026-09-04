Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8407D48B37B
	for <linux-raid@vger.kernel.org>; Fri,  4 Sep 2026 12:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788526117; cv=none; b=mt+YzPpPnzHMW20YJc9sbia9OqIiBvQPQgh+k3Gk8RdjBOfDq3/yLYx7W1pEIQ5rnkaaPhtqxYkyY3u/DJJfiDLPfCsbPjf6JSKCy01aKi5ivrZmTIyi2Kt62Z+Ix+jMY5MRjwafQWSangUE0APRgBGC1DCaRxAXSot61OoKfnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788526117; c=relaxed/simple;
	bh=zVE2F+Q1jzi+4s7GEnyAJlcwVF7Z8vYLbY2cCvFD2h0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xmi3td/t3DGpJFf8SW+Fh0I+BmDQa7kjat4R5JayfTLxF9h3Uf6rnfLx4GzsnLC0XOcE2hYU5XG6Fcjo48wCJlOcDEiNRuRy4LrLNQBkT9czCZM6pOyw3aUqp9kyD/92IpcMljSGyDE7lT+d11EDdOvzixp8pCNmRgvA4LdHRNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HqQz6Nld; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HqQz6Nld"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-398a5aad413so712208a91.3
        for <linux-raid@vger.kernel.org>; Fri, 04 Sep 2026 05:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788526115; x=1789130915; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jqQvXBnpuTjdY51Nwgka12FoQyHZLRsODERgLeADk1M=;
        b=HqQz6NldXuAz+4A/PzdijuhBCtvZoxnASR1uwDRc8sD2GDJqgnYmxKpm1fDweInbPH
         p1wtWJXImoidCRIw8uXFYWq/UNtd9KsGiMkShJ/SFNTEM5cyY91WbyXsVBHacnTCT20f
         NykST7te5beNkDdf7yqxoh7+NZYAkcfT3XsySWoUb+ko9xgwPukW9Wk3pjyZ0gH+G4uq
         O39vCqFg/7nbaRRinYe00Gs8eBiP7clFF41iCXISNGTFvcKwSGyO4/IdNI+OnMUFPODe
         smMp8NYCOFIJFndhiUoAzygb7e64knHumZalv6TPpiFr0ngdBuSpUHOW6p/sLaz9K4z0
         SbCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788526115; x=1789130915;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jqQvXBnpuTjdY51Nwgka12FoQyHZLRsODERgLeADk1M=;
        b=JE4Na0WqbHHQapvnSKQ8iCQfMi/gNWgbxHL/gAvW/Kl+InM4bs95pJ2eUsoEoh9IV9
         36qGwiCBQVspLDhtip2nY12vfg6AFiMsduNt+kjmLmWrULmOPwoJcYQl7an0J02VIvXD
         SG4KxJQ/tMwXW9POUTauIa5yNb7W2bUtkm+TL0FR97U/REfCLhygZamrXaDxXRjv/9JP
         Nv00hxtLSJ/hTr8Nk+Q99jF8iHTWGyYZIXQ2DXbillGegMDw4k7H21YDPNgVfHXtZeGC
         sYz44OMib4srg1htJdEXdOGPzlz0/0XP3IGZj9aQpIV8tsMRjnwQHpXys1SgME6tQXBE
         VKdg==
X-Forwarded-Encrypted: i=1; AKwUvBxe9PF8/kVkaibE4q0+bWtFw70H1TVAjY9E3JsPoxTOvQU4htsLXpVY1eGBEWY8V0XzyNAEuDcUv02F@vger.kernel.org
X-Gm-Message-State: AFuF++nUYG8EYP2d95Sk7zin0RuhuotzrGtdNpmG5IbXZl58TKiHXoGK
	Q35p8o3W3QVr5t2qqeoQ3rNl3uxUmVy1dauV9WeqTFPSdn+aXHBBM9o5aAj8rwYR0N0=
X-Gm-Gg: AYBFou1EizDUqMC6Em/GxchBW+/8yNQZYeoCAsnTKLjiM8isD5pIlTWQN5LiSoKZySh
	jZ15dLaNxnkmEwIjzp7pO9idt0H7zQOk3Lr/+db1i3k7cnKWf/BXOktqSQvv5Gz/OG5TvjNjRms
	z8ydVRSSSbR8ZvWR5UVgYKjIC4Um4bFPWoXY05jrH0zLXa0XJGdaZ/2eeTNuAWQHflZWCfGIEbG
	nch9HWNrLMA3EiJueD1Gq8iauM6BVDKs4eiz+1XQ9pAdPZ4z5XbsRzjKyDP2zoRz6H6NI9HD87I
	x0n24VTkGzRWjOVOmt2bAyCmrlI7FZshKg5G0jJMJGxrDlHUIYc547hrB3kOsjIVa97XNI8Ie87
	0JiQcHr6Ke+2UK1m7avk2g9aZPqz9KAIr65hBRCGGmtKLyT90Nnfvqtz4AqgSYuX438CDn7Dr72
	f9WQ495rUax7nU0Ne3bH5e2f2DFCPKY4+0uXLwwY7gDn+RW94vPqFHj3KIGKE0kg7gseXbEwcJ0
	4ntuy2zX9wv3PypNCG7I8bBMw==
X-Received: by 2002:a17:90b:314e:b0:38f:efed:5445 with SMTP id 98e67ed59e1d1-39b261500fdmr7594249a91.4.1788526114583;
        Fri, 04 Sep 2026 05:48:34 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339befe870sm7322412eec.30.2026.09.04.05.48.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 05:48:34 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH 2/2] lib: fix repeated word 'the' in comment
Date: Fri,  4 Sep 2026 18:18:22 +0530
Message-ID: <20260904124824.9585-3-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260904124824.9585-1-hemanth.selam@gmail.com>
References: <20260904124824.9585-1-hemanth.selam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Drop the second 'the', reported by checkpatch.pl as a possible repeated
word.  Only touches a comment, no code changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 lib/raid/raid6/algos.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/raid/raid6/algos.c b/lib/raid/raid6/algos.c
index 011aa9d0eb3c..182ab9844ba9 100644
--- a/lib/raid/raid6/algos.c
+++ b/lib/raid/raid6/algos.c
@@ -66,7 +66,7 @@ EXPORT_SYMBOL_GPL(raid6_gen_syndrome);
  * This is used to update parity in place using the following sequence:
  *
  * 1) call raid6_xor_syndrome(disk, start, stop, ...) for the existing data.
- * 2) update the the data in @ptrs[@start..@stop].
+ * 2) update the data in @ptrs[@start..@stop].
  * 3) call raid6_xor_syndrome(disk, start, stop, ...) for the new data.
  *
  * Data between @start and @stop that is not changed should be filled
-- 
2.48.1

