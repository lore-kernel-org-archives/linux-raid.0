Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A54220469E;
	Sun, 17 Aug 2025 11:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755430431; cv=none; b=rwV39tXbwnnzwhnotVORsu2PyUoWakAf51vKDRo49mc8DR19i/ubw1bt4FyGmmikYXe5eBnm1f6WTefkiCP7ob9RK05rK5/WKzXgrWUzfb92rNY/LhyX9E75Glk5nNpXQptMzasMqYwsPy8P+/hSys2EzGzOTFG8xuobHEwIgI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755430431; c=relaxed/simple;
	bh=VSL6PEg8MxL2uScEXM1b+TMiDEeE4SxgUT/grljA0sc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bgxQoxUGAsyg1kfI86CaxGqz6vRPN0lJ/kLbOnJOPc0mOE/LIn4DWmFUDjMRtQKsaXI5xHHMk+Oiz1lbsBerJbGoQnz4X2Vcrsdjiqc9abzMk54PAgfaF07piAzitMqRh3DtcgljAbgpoJtynP/3TNh8e3/jG3AXngJ9hhp/B9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kzalloc.com; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kzalloc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-b47173edabaso689417a12.1;
        Sun, 17 Aug 2025 04:33:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755430430; x=1756035230;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ak6zMtFbySLeOJ64BswfpOwYEwQ7oovCITgLDPUoaxE=;
        b=qceDRIfwcaQzPIAkeUfdFr/BK+ojWrtQb75EHgIlqT35WUVxyidnRi5850EM4WhW8O
         3AEn26e4t2NpIZ78J+kwxUnrQfooMNvcTIjycy3nOEpkxSyIuV2x3utBWvpKvHF3FB3b
         L1HivjsLItkQeMJYdgcQ1SXHpTpbH3eI00Z/TYz4fY9AKZtOksw1QKGZMdyVVtCScS7x
         KiBc4JyoUnXEKLmlbVt2Cec3TXqnn/Wmh8bRbA9GiF3dI+RiuQr61e4ovGDhHaucNCk9
         UgXyUylE6Nj8HQR42DHFv/ZYntrSoU6xWlpNNBl352J4nxYrnR2d1zV14J7hll5Cwt3y
         8EzA==
X-Forwarded-Encrypted: i=1; AJvYcCX3IpNXHlYoLswyF20OqyHASaEz++S+nnH6Tlc1KWxRclXKyme5AAOebKnVa3l+VF6aUR/EFjfwGFgstU0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyH/15FdxJWejpNmqpLxQFOq9gfG5/3KrcypG1ZupURu9K6cxWW
	HlY6/X83luCsprVbgmXIH1tm4a2AqsDh0DEJlDdDmIClkyh8chOcpNGt
X-Gm-Gg: ASbGncvlpuT4wAuEX8ChSbh1lUx6Cf2bwXggp5lz4ioZ9qqMY91cAaVwp9n2kdllgho
	m9UOaHjByDjUBjZGJDdmHSHTqzRf+agPW2mvBC4kVc/eFTpygHCnX++NKlkFOuW+IVzio65WOtG
	A/JUcKXIpYY7kDYJW2QrcTzr5W6Kya81ltOigIwOskR9Voof9JcOp3beXgMXSPTwb9IgifOTl3H
	g6bQ6K+lamS+NafBejLIcdUPBTGE2np2xh2f9J2SjOCgNo6BuN1RK7JugfIPvIeHdjdjNJPm0is
	+v0mp5IOLpgQv/53anpWNzYClTs+Vc4/L3a2hEMfFGPJ45i89H+WGMC5rZeRqkNYzC6JpFplP5W
	/4dCj0WL6b38V
X-Google-Smtp-Source: AGHT+IGZpxRPHFgkz6nMsx/vmZuGcU8C3T8gkrZOO2a+zfUrlfHCRWnkIiVJMn7vnKCuVpCCuNpSTw==
X-Received: by 2002:a17:902:e541:b0:240:9dcd:94c0 with SMTP id d9443c01a7336-2446d6f1c95mr53539515ad.2.1755430429491;
        Sun, 17 Aug 2025 04:33:49 -0700 (PDT)
Received: from localhost ([218.152.98.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2446cb0f329sm54102285ad.70.2025.08.17.04.33.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Aug 2025 04:33:49 -0700 (PDT)
From: Yunseong Kim <ysk@kzalloc.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: linux-raid@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Yunseong Kim <ysk@kzalloc.com>
Subject: [PATCH] md/raid5-ppl: Fix invalid context sleep in ppl_io_unit_finished() on PREEMPT_RT
Date: Sun, 17 Aug 2025 11:31:16 +0000
Message-ID: <20250817113114.1335810-3-ysk@kzalloc.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The function ppl_io_unit_finished() uses a local_irq_save()/spin_lock()
sequence. On a PREEMPT_RT enabled kernel, spin_lock() can sleep. Calling it
with interrupts disabled creates an atomic context where sleeping is
forbidden.

Ensuring that the interrupt state is managed atomically with the lock
itself. The change is applied to both the 'log->io_list_lock' and
'ppl_conf->no_mem_stripes_lock' critical sections within the function.

Signed-off-by: Yunseong Kim <ysk@kzalloc.com>
---
 drivers/md/raid5-ppl.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
index 56b234683ee6..650bd59ead72 100644
--- a/drivers/md/raid5-ppl.c
+++ b/drivers/md/raid5-ppl.c
@@ -553,15 +553,13 @@ static void ppl_io_unit_finished(struct ppl_io_unit *io)
 
 	pr_debug("%s: seq: %llu\n", __func__, io->seq);
 
-	local_irq_save(flags);
-
-	spin_lock(&log->io_list_lock);
+	spin_lock_irqsave(&log->io_list_lock, flags);
 	list_del(&io->log_sibling);
-	spin_unlock(&log->io_list_lock);
+	spin_unlock_irqrestore(&log->io_list_lock, flags);
 
 	mempool_free(io, &ppl_conf->io_pool);
 
-	spin_lock(&ppl_conf->no_mem_stripes_lock);
+	spin_lock_irqsave(&ppl_conf->no_mem_stripes_lock, flags);
 	if (!list_empty(&ppl_conf->no_mem_stripes)) {
 		struct stripe_head *sh;
 
@@ -571,9 +569,7 @@ static void ppl_io_unit_finished(struct ppl_io_unit *io)
 		set_bit(STRIPE_HANDLE, &sh->state);
 		raid5_release_stripe(sh);
 	}
-	spin_unlock(&ppl_conf->no_mem_stripes_lock);
-
-	local_irq_restore(flags);
+	spin_unlock_irqrestore(&ppl_conf->no_mem_stripes_lock, flags);
 
 	wake_up(&conf->wait_for_quiescent);
 }
-- 
2.50.0

