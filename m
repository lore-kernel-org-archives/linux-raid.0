Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F97433CB;
	Mon,  7 Oct 2024 08:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728290917; cv=none; b=Lq5conUG/cmz6Gy7ZdJs6USRbNQuzxtCLsGMCNoHIWEpQEWMG8GZRRd0zaepswfNtW41NoDMCPyWpLV6f6OKnRUnc8Tdw05upoDLO6vWtFcmBVJFolhXqMfqDdPGfNNB3IlQVlYDnghNrqHgHLNu9zUNttIxEO+k1nurOS8oeok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728290917; c=relaxed/simple;
	bh=XTjPCcxgpc67s08ZRgzSbVu+e5R7WN8CkxWYyLpGNXo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BwaDHa8KzvaboN4CYVd7l/UPFtl6E5OizkdBzPysTxHIN/i76UcI7Af8nnceijjDtvIMA01Yb2c1RO9bH6UmlNxZ6DzTH666S2UDchNZAcGVv2U8zpWL/2G/E+f+ElnLwJ3cxujTYmneogsGsaoQiYiUeCnQuI8DkI4h+sIl500=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GeQiyGLR; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GeQiyGLR"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-37cca239886so2492680f8f.2;
        Mon, 07 Oct 2024 01:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728290913; x=1728895713; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sw3uyAY13ehdme5WfQjVEpYa1xK552qbPUcgYHurxy8=;
        b=GeQiyGLR875IE07d+DX0tWybo2sNkA2hJnmgc5SBZgmPDP97Yukg2xpwNQ1q61YmBI
         jMZyqMjczP/TOs/V3fKpFx7mcLO4hQFXGOR+N2DciaMtda3wD4YjlApw8wYkxVrhuri2
         eAg5lwZPjqlOYtf3IkBowYkihq70Ui5W4bmkrDyrxpFCPFZ3SQBsv9cwq/9KqTHW4U0A
         hrqtSIxvNZJQjRX5GY0peDj9F099pC4SSxUa0PyS5kmz7kpyxAWiRaaYb/9EBH1NCjFo
         MLQbVrNHnRlvH1vZGN2YPp/sjb3T8E2XOoPdQOULo2OGom1AlZ3VaO/we6yjoIvzY5Kr
         lsnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728290913; x=1728895713;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sw3uyAY13ehdme5WfQjVEpYa1xK552qbPUcgYHurxy8=;
        b=dPAykghIsGugNv6VflPW5rkXgLuXeKSY6X9Vl/ozBwBhTlmKNA9C59JtUKm66n2dPc
         +HPsPkEt501neojB2ApZRVlEzMlAnrnKKhk2mqiqkJqdFwRFn++TsbdQLUsrtszdYnjz
         H9IyVCJ/dYisbKlYdaHLP86PCQSB8rBd0pVjhbbpRJU3eAeg7ohSytO0U9OTNWyY4BJT
         F2dLIWZn9H1UHPqG7NkMURqGcPuyB6XN3sT5WmyjvA0DXNnTH5nZrbrzYOdDYdalJM6H
         BOKYeWyD82Fmq+KRRDc3kq31OGx5TXg0hpcHT+T10GC5xYH8DDvmQAgYwicwzrk1BSIA
         jVGA==
X-Forwarded-Encrypted: i=1; AJvYcCUS1tBx12u6YyyI8BS3eVYmMFGVxTJCKdh4P5L/7NyGpcets53kxvXpKnLJCqUPPsxJBgT8W+6Rah4CrFo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwIPKDBFh8bXjTz+iwq8ZcbU2JA/Am4MJnPek0rKzpXSfFV18Kt
	7Zz3YPh9oHBMTlOF8yBXBr19hrUS9GB25IWLZSkfNHIVrreclXSWxlPf9/QbkZE=
X-Google-Smtp-Source: AGHT+IEegzbWgtgFULnrDNHJbTvSTTiC7KXTJtSYf5p/to9bXMzF5sJLj339zWnsytk/+SfshOU3Nw==
X-Received: by 2002:a5d:4c52:0:b0:374:ca43:cda5 with SMTP id ffacd0b85a97d-37d0e4dff9fmr5624801f8f.0.1728290913515;
        Mon, 07 Oct 2024 01:48:33 -0700 (PDT)
Received: from fedora.iskraemeco.si ([193.77.86.250])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37d1690f24fsm5218176f8f.1.2024.10.07.01.48.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2024 01:48:33 -0700 (PDT)
From: Uros Bizjak <ubizjak@gmail.com>
To: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Uros Bizjak <ubizjak@gmail.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH] md/raid5-ppl: Use atomic64_inc_return() in ppl_new_iounit()
Date: Mon,  7 Oct 2024 10:48:04 +0200
Message-ID: <20241007084831.48067-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.46.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use atomic64_inc_return(&ref) instead of atomic64_add_return(1, &ref)
to use optimized implementation and ease register pressure around
the primitive for targets that implement optimized variant.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Song Liu <song@kernel.org>
Cc: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/raid5-ppl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
index a70cbec12ed0..37c4da5311ca 100644
--- a/drivers/md/raid5-ppl.c
+++ b/drivers/md/raid5-ppl.c
@@ -258,7 +258,7 @@ static struct ppl_io_unit *ppl_new_iounit(struct ppl_log *log,
 	memset(pplhdr->reserved, 0xff, PPL_HDR_RESERVED);
 	pplhdr->signature = cpu_to_le32(ppl_conf->signature);
 
-	io->seq = atomic64_add_return(1, &ppl_conf->seq);
+	io->seq = atomic64_inc_return(&ppl_conf->seq);
 	pplhdr->generation = cpu_to_le64(io->seq);
 
 	return io;
-- 
2.46.2

