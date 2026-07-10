Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02ECA42E8E9
	for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 13:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783689832; cv=none; b=Kmd/0DO3X4VAsHRxdwubcOpB9E2Iq3n3gfqGJDHvgTDEOpipgqNoTmc5pjpxNMCAqOKuFZhfuMfWQVfQGu10Ovte2vAr8A25aNK0EZLd/D7D5Pdl6FzEBscnKRSRqpNzEMJNWyTl49VPJpqiQgqKCD6YwfWLGvcGiC7K74juxy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783689832; c=relaxed/simple;
	bh=9jdOtd0+F2HnuqXRVnhc6kV1s/ixcwmEXsxUb82eCkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RagApMl63JWs+Oj7VzqKRPbpxsocWv4fBcASAGG3Yo7eAAKQFGrKGAYjwK9anGd071xxTy7otNc8xB5pKSpv8TYGB8rVGzVn26qYTsbLyHIeBse6N+HBdc/bCoIlVCoN4k76qZKnh046VhU4IjxYoShdRANdqDpAJ9RpqOxYjNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pz4c/Qei; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pz4c/Qei"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-ca957432c7fso685870a12.1
        for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 06:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783689830; x=1784294630; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=11naR69H888D+qtYxFBRHYHQt2DJDb8Xz+8TAT38yxY=;
        b=pz4c/QeikGZV0A+uJ5JfVCBWIth5QsHQ0VupW0NMXlzAyey44hog8lTZdUzxNNkdto
         DhrpQpzexkX6RqheMkA5VEzUIVrbLyC8oTT1XlsIANH39i5ZSdLXaqaam+Byd38QkXQc
         dy+ndFxgbYqzkLmdm8O60B2HcsnHsg0nbBo7ACkqEfe3FVaxyPrNXGBqTHwAGWLrBD+Q
         gb72JhQdKyK8s/cjpu1JywzZrPQDhFh8bcv9IiGBZLAosOxPMqAN6cfGXzWA6ktE2VeE
         kbqlNoAKqcYhfh3TL3WQKOSqjHH0KnnCCV/hc3MceaQGykUVBPo1i3RWrHxAInQR9PNZ
         SprA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783689830; x=1784294630;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=11naR69H888D+qtYxFBRHYHQt2DJDb8Xz+8TAT38yxY=;
        b=gwkSaQZ7vUiO4qvaly++JgkM8Et50zcaw4MFHbknTO1v/NJOSnz5FyWHze8L0xtCNi
         6Wm3dA80YzA9WivBOPPksQb1ourgb4CI4i1Ls5J+g3sk3Wr7d7pxXiquORw83/5oKeeu
         qKj7IWAonqi3LPi9sxfM0ax2voKSiDP1Ylsovr8Btzq1jrJ3ZAQTNoyh27dvOS7PvrTK
         5/dh5gMoKrM4PCWPmGEevCDY6XOhjqOfRuqFaUmXPEXfK9fbx+xzdwIwXb9wL5oCApDo
         /G6CMRqhMEiWNIRV/RD/t0dZBxKmwZe7UK9MuQFuuY2uux1K2ZLd6D4k3rJ54Z7LCjVp
         8qPw==
X-Forwarded-Encrypted: i=1; AHgh+RrFCBp/phgX376u+34mp2JbPjZdes+5N3DzwDk/zWCe75EVn2fAWxqQ+p7FB6m5IYwTswsnQdodRH12@vger.kernel.org
X-Gm-Message-State: AOJu0YyXB4WqDZBWC7LbxQ6RGXQapiNG5uuYBgo3GncZ2NmGUQcr4mwR
	F3/n/mKfu2CTdeiw8a43FPh36QY5M4nzvXXr/qPO1FUn25tbZ6xSS651
X-Gm-Gg: AfdE7cnczaieYu2GYoESJ3Hqn/vpYNg99Cq30RkGTzrjLLngcNM2H8QtqvZHc6vnGYx
	l8B6K4RfTzQHZ2katEhAoKFn08ONR496j9QXAxRPRJlWlLwcj3Gi2KlKIDkhNLm92hsgO8eNB4Z
	quYQZLW8u6byPG8SE1re6jGuJ3ubkif9jPyncWaHLHC/1vC8gfrtW3+4P/Jzq9fQAca71bePDlz
	zDUcsb/2TQTgtlhYM4INPfo46uC8dYgKAgmjlfPooP2TM8TNUJ8DOnQs8bHtOBPbk3d1D55lFDW
	djvv+EhlZTYGv+czTJ/wBi0zBU6bviqHdXAZ6pG1P7R0jltiAQbdGt6IR3PqeNo7m6zdaWZJXUJ
	tKaSfOhRLZpV2ZfiCkcwnW/vVw1n2R/LLrk9ka14NwE1y1T+y/2kdlZy26FRBjBNo3Yf2wKPgDN
	dt4YWG3P8v/qFoojKdwhgOJb88pqcvRA3zq1q3dLluZn2ptcADydtZaMIlEcJXt3muxgIilYE3R
	t/1mMk=
X-Received: by 2002:a05:6a21:1f88:b0:3bf:9bfd:ca95 with SMTP id adf61e73a8af0-3c0bcce7f31mr12749554637.34.1783689830035;
        Fri, 10 Jul 2026 06:23:50 -0700 (PDT)
Received: from research02.. ([2601:1c1:8700:f5b:fe34:97ff:fea3:c147])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ca5b3b251eesm4903776a12.31.2026.07.10.06.23.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 06:23:49 -0700 (PDT)
From: Hiroshi Nishida <nishidafmly@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hiroshi Nishida <nishidafmly@gmail.com>
Subject: [PATCH 1/6] md/raid5: size the worker group array by nr_node_ids
Date: Fri, 10 Jul 2026 06:23:41 -0700
Message-ID: <20260710132346.7295-2-nishidafmly@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260710132346.7295-1-nishidafmly@gmail.com>
References: <20260710132346.7295-1-nishidafmly@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

alloc_thread_groups() sizes conf->worker_groups[] by num_possible_nodes()
-- the number of possible NUMA nodes -- but raid5_wakeup_stripe_thread()
indexes it by cpu_to_group(cpu), i.e. cpu_to_node(cpu), which is a node
id.  When the node map is sparse (for example possible nodes 0 and 2) the
node count is 2 while the largest node id is 2, so the index reaches
worker_groups[2] on a two-element array -- an out-of-bounds access.

This has stayed latent because worker groups are only allocated when
group_thread_cnt is non-zero, and the historical default is 0.  Size the
array by nr_node_ids -- one past the largest possible node id -- so that
indexing by cpu_to_node() is always in bounds.  On a dense node map
nr_node_ids equals num_possible_nodes() and nothing changes; on a sparse
map the array just gains the unused id slots it needs.

Fixes: 851c30c9badf ("raid5: offload stripe handle to workqueue")
Signed-off-by: Hiroshi Nishida <nishidafmly@gmail.com>
---
 drivers/md/raid5.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 0c5c9fb0606e..d8807114a693 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7322,7 +7322,13 @@ static int alloc_thread_groups(struct r5conf *conf, int cnt, int *group_cnt,
 		*worker_groups = NULL;
 		return 0;
 	}
-	*group_cnt = num_possible_nodes();
+	/*
+	 * worker_groups is indexed by cpu_to_group() == cpu_to_node(), a node
+	 * id, so it must have room for the largest possible id.  Size it by
+	 * nr_node_ids (one past that id), not num_possible_nodes(), which is
+	 * only the node count and is smaller on a sparse node map.
+	 */
+	*group_cnt = nr_node_ids;
 	size = sizeof(struct r5worker) * cnt;
 	workers = kcalloc(size, *group_cnt, GFP_NOIO);
 	*worker_groups = kzalloc_objs(struct r5worker_group, *group_cnt,
-- 
2.43.0

