Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28FB37D13A
	for <linux-raid@vger.kernel.org>; Wed,  8 Jul 2026 13:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783517756; cv=none; b=hjvc9tvZgjBYMSIMtJoGVSUZPkB3unz3WzyMhGW7mNaYeogmt0GGC3DmMeLBFp3p4OlkYkYIEAPrhSAt0BpAgp/PWyIA7rkPIJ4Y0upoGZcSvSgG4FG7RAuz1rwcc7lwj2WJp1KQiNtEwWUS1yrJDWSN0ZhvOWY1qzpaFsgCd94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783517756; c=relaxed/simple;
	bh=zEJ+4jAiaNq5aeK7X7y8QioWmAgpoUSpIH9N+SQ35mk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ebQAc6xcVDJ1rdyVy1SaDV6zTI0O2E4/GMPKyiGGLKqA4gwOiQNR/9e/Eb1/6c6nTaJU25CtEec2JImCIWr8QlCVp66UZlETHtlSw6EwC6VNLU+O6SI9bn4PXRZ9qsDEh53FUaqHRIBM7T5QYEAtmlvXmJEUM4APasg7rll8KRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WXlXrP19; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WXlXrP19"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-92e51d3d83cso33036185a.2
        for <linux-raid@vger.kernel.org>; Wed, 08 Jul 2026 06:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783517752; x=1784122552; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=UBjslNuGoGP7Ld9NiJrm6MjO0hs8ZPymb79f+MsISBI=;
        b=WXlXrP191hveTL3FBjYNtQRhpNC5J/6mdlCFAs7Mw1FNkViLL44D8VW63du1qO9FL4
         0ybjDZliovGHjKiS0qo8D/T5YoH2H5b85lGAeBQqzQYdE62B81fp12ISnkYd0/Oy1TYz
         jB6DJA+T0xP+rfgoIyzZXxFTu7CuOk9SaQQbSiD2cMAn+SNn7z3I/hijNuQtYBTZG3p/
         vNOVgrvLyhDN5l3PRx6E6c5cOo6e+ujC+68nmqbNPG3g7/xqe9p8VNOUv2qY1ANuXcym
         9A90UQei7fN0W96EyV4RCAjwrv1iyfE+jDm4/uVDHK4XpAw7Aks5JXCLPP0+4ACSUMHh
         T1ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783517752; x=1784122552;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UBjslNuGoGP7Ld9NiJrm6MjO0hs8ZPymb79f+MsISBI=;
        b=ZTYOa3koctdprJlUugL9/lyqKBjiM4GKFLjbLFMtYZ6BsQy9zyWnw+mp2n4K+8zmCf
         10dC4bscMBOGVtlfvfp2DvlMJUVDNHK+R1QJ2jHURKeUP5qgXDtM0t9UXocigYK7PLJd
         o/1SbN8uaBTmy3ilRySHL5TYYrFkUY4luFUwtpqohQ28nDK+Szz0t4RpDbXSt5L9BqR7
         KbWQJJknjEErHv0yGmA91URZ0D9eRG+Fwrkj+bmVR5BkcM+2AeRUvpC1mwJ81Zh1PuXl
         i80jrdBJWpZipvHXyDoYCn9xJ92wG7SP7BX3axFHdk9MaCWv9GIMAGjGvs5Y3ceihgVZ
         wFbw==
X-Forwarded-Encrypted: i=1; AHgh+RoZnLsmfJXVxK55LXqzJlQ2GU/BtON+mVH/QPGxL5AkMHhKRbaqyH8nNDUfKv45vGNFnKSO/Ap0wncx@vger.kernel.org
X-Gm-Message-State: AOJu0YybvskeRE4xx2WgC6UBsATtkq2eAzDvMPJjC2bPqO9D+12dn5b1
	8m6MxZD8RML8awb7NCJa3FcsSlwhYGzMn5fUqWA2MynaY9r8lMpBg1iozXRizaqfmG10pg==
X-Gm-Gg: AfdE7cn4VjyvGjdQtKAASXcYZ14BW8AEQzE15oG/NmCKirtoUt293T1mmTHt2NRbEiK
	i2xP+gtuv/ItnMLcLMhzZkoqLyQKbzv8iZd6s03QEBWl5Pn6ETFitfVFVyfkToUf+Kys5Q0yten
	cdxDP/bRWB97BgwC6VEvnUVVatoEkuFQSy5jqR0S38z6ld5mcahy/PR7TjXbWQRg7g+SXvWL2dO
	LwFrdqRsK8k9Q1YsG9twz/LY6KoNn4SXrXUp5pb2S+Pc57fmhOPT4UCmXnIDGrOP4JmfoQ14B8C
	DChiGyvP8AH4BiWVMEuEPxa9q03WJwNwvKZtsLRI1EA2q+DPXbaVfGfIfBs2quI5LXO7cVhMNV5
	dqbMfc8l7pA9nJGBmMocRZuwNx0v/o4Dp/O2DQVSXhW1R0qV01URPfZoxWlHZYmEzDE+Qha+Mjy
	KiFQ==
X-Received: by 2002:ad4:5743:0:b0:8f4:870f:72bc with SMTP id 6a1803df08f44-8fec3cf5d44mr20865746d6.51.1783517752089;
        Wed, 08 Jul 2026 06:35:52 -0700 (PDT)
Received: from lgs.. ([118.193.39.55])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8fca1c1356esm51565376d6.37.2026.07.08.06.35.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 06:35:51 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Junrui Luo <moonafterrain@outlook.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>
Subject: [PATCH] md/raid5: validate journal checksum slots during recovery
Date: Wed,  8 Jul 2026 21:35:34 +0800
Message-ID: <20260708133534.770770-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The change referenced by the Fixes tag added payload length validation
before accessing journal metadata during raid5-cache recovery.

However, the DATA and PARITY payload length is computed from the on-disk
size field without ensuring that the checksum slots read later are
actually present. struct r5l_payload_data_parity ends with a flexible
checksum array, so sizeof(struct r5l_payload_data_parity) does not cover
any checksum entries.

A corrupted journal can set a DATA payload size smaller than one page.
The computed checksum count then becomes zero and the payload length only
covers the fixed header, but recovery still reads checksum[0]. For RAID6
PARITY payloads, recovery also reads checksum[1], so the payload must
cover two checksum entries.

Make the validated DATA and PARITY payload length include the checksum
entries that recovery may read. Also make sure fixed payload headers are
present before reading their fields.

Fixes: b0cc3ae97e89 ("md/raid5: validate payload size before accessing journal metadata")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 drivers/md/raid5-cache.c | 108 +++++++++++++++++++++++++++++----------
 1 file changed, 82 insertions(+), 26 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 7b7546bfa21f..4aef692182b4 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -1980,6 +1980,29 @@ r5l_recovery_verify_data_checksum(struct r5l_log *log,
 	return (le32_to_cpu(log_checksum) == checksum) ? 0 : -EINVAL;
 }
 
+static sector_t r5l_recovery_payload_data_parity_len(struct r5conf *conf,
+		const struct r5l_payload_data_parity *payload, bool parity)
+{
+	unsigned int nr_csum;
+	unsigned int min_csum = 1;
+
+	/*
+	 * The payload size determines how many checksum entries are stored,
+	 * but recovery always reads checksum[0].  For RAID6 parity payloads
+	 * it also reads checksum[1] for Q.  Make the validated payload length
+	 * cover every checksum entry that will be read below.
+	 */
+	nr_csum = le32_to_cpu(payload->size) >> (PAGE_SHIFT - 9);
+
+	if (parity && conf->max_degraded == 2)
+		min_csum = 2;
+	if (nr_csum < min_csum)
+		nr_csum = min_csum;
+
+	return sizeof(*payload) + (sector_t)sizeof(__le32) * nr_csum;
+}
+
+
 /*
  * before loading data to stripe cache, we need verify checksum for all data,
  * if there is mismatch for any data page, we drop all data in the mata block
@@ -1992,6 +2015,7 @@ r5l_recovery_verify_data_checksum_for_mb(struct r5l_log *log,
 	struct r5conf *conf = mddev->private;
 	struct r5l_meta_block *mb = page_address(ctx->meta_page);
 	sector_t mb_offset = sizeof(struct r5l_meta_block);
+	sector_t meta_size = le32_to_cpu(mb->meta_size);
 	sector_t log_offset = r5l_ring_add(log, ctx->pos, BLOCK_SECTORS);
 	struct page *page;
 	struct r5l_payload_data_parity *payload;
@@ -2001,28 +2025,42 @@ r5l_recovery_verify_data_checksum_for_mb(struct r5l_log *log,
 	if (!page)
 		return -ENOMEM;
 
-	while (mb_offset < le32_to_cpu(mb->meta_size)) {
+	while (mb_offset < meta_size) {
 		sector_t payload_len;
+		u16 type;
 
 		payload = (void *)mb + mb_offset;
 		payload_flush = (void *)mb + mb_offset;
 
-		if (le16_to_cpu(payload->header.type) == R5LOG_PAYLOAD_DATA) {
-			payload_len = sizeof(struct r5l_payload_data_parity) +
-				(sector_t)sizeof(__le32) *
-				(le32_to_cpu(payload->size) >> (PAGE_SHIFT - 9));
-			if (mb_offset + payload_len > le32_to_cpu(mb->meta_size))
+		if (mb_offset + sizeof(payload->header) > meta_size)
+			goto mismatch;
+
+		type = le16_to_cpu(payload->header.type);
+
+		if (type == R5LOG_PAYLOAD_DATA) {
+			if (mb_offset + sizeof(*payload) > meta_size)
 				goto mismatch;
+
+			payload_len = r5l_recovery_payload_data_parity_len(conf,
+									  payload,
+									  false);
+			if (payload_len > meta_size - mb_offset)
+				goto mismatch;
+
 			if (r5l_recovery_verify_data_checksum(
 				    log, ctx, page, log_offset,
 				    payload->checksum[0]) < 0)
 				goto mismatch;
-		} else if (le16_to_cpu(payload->header.type) == R5LOG_PAYLOAD_PARITY) {
-			payload_len = sizeof(struct r5l_payload_data_parity) +
-				(sector_t)sizeof(__le32) *
-				(le32_to_cpu(payload->size) >> (PAGE_SHIFT - 9));
-			if (mb_offset + payload_len > le32_to_cpu(mb->meta_size))
+		} else if (type == R5LOG_PAYLOAD_PARITY) {
+			if (mb_offset + sizeof(*payload) > meta_size)
 				goto mismatch;
+
+			payload_len = r5l_recovery_payload_data_parity_len(conf,
+									  payload,
+									  true);
+			if (payload_len > meta_size - mb_offset)
+				goto mismatch;
+
 			if (r5l_recovery_verify_data_checksum(
 				    log, ctx, page, log_offset,
 				    payload->checksum[0]) < 0)
@@ -2034,15 +2072,18 @@ r5l_recovery_verify_data_checksum_for_mb(struct r5l_log *log,
 						 BLOCK_SECTORS),
 				    payload->checksum[1]) < 0)
 				goto mismatch;
-		} else if (le16_to_cpu(payload->header.type) == R5LOG_PAYLOAD_FLUSH) {
+		} else if (type == R5LOG_PAYLOAD_FLUSH) {
+			if (mb_offset + sizeof(*payload_flush) > meta_size)
+				goto mismatch;
+
 			payload_len = sizeof(struct r5l_payload_flush) +
 				(sector_t)le32_to_cpu(payload_flush->size);
-			if (mb_offset + payload_len > le32_to_cpu(mb->meta_size))
+			if (payload_len > meta_size - mb_offset)
 				goto mismatch;
 		} else /* not R5LOG_PAYLOAD_DATA/PARITY/FLUSH */
 			goto mismatch;
 
-		if (le16_to_cpu(payload->header.type) != R5LOG_PAYLOAD_FLUSH) {
+		if (type != R5LOG_PAYLOAD_FLUSH) {
 			log_offset = r5l_ring_add(log, log_offset,
 						  le32_to_cpu(payload->size));
 		}
@@ -2075,7 +2116,8 @@ r5c_recovery_analyze_meta_block(struct r5l_log *log,
 	struct r5l_meta_block *mb;
 	struct r5l_payload_data_parity *payload;
 	struct r5l_payload_flush *payload_flush;
-	int mb_offset;
+	sector_t mb_offset;
+	sector_t meta_size;
 	sector_t log_offset;
 	sector_t stripe_sect;
 	struct stripe_head *sh;
@@ -2094,22 +2136,31 @@ r5c_recovery_analyze_meta_block(struct r5l_log *log,
 
 	mb = page_address(ctx->meta_page);
 	mb_offset = sizeof(struct r5l_meta_block);
+	meta_size = le32_to_cpu(mb->meta_size);
 	log_offset = r5l_ring_add(log, ctx->pos, BLOCK_SECTORS);
 
-	while (mb_offset < le32_to_cpu(mb->meta_size)) {
+	while (mb_offset < meta_size) {
 		sector_t payload_len;
+		u16 type;
 		int dd;
 
 		payload = (void *)mb + mb_offset;
 		payload_flush = (void *)mb + mb_offset;
 
-		if (le16_to_cpu(payload->header.type) == R5LOG_PAYLOAD_FLUSH) {
+		if (mb_offset + sizeof(payload->header) > meta_size)
+			return -EINVAL;
+
+		type = le16_to_cpu(payload->header.type);
+
+		if (type == R5LOG_PAYLOAD_FLUSH) {
 			int i, count;
 
+			if (mb_offset + sizeof(*payload_flush) > meta_size)
+				return -EINVAL;
+
 			payload_len = sizeof(struct r5l_payload_flush) +
 				(sector_t)le32_to_cpu(payload_flush->size);
-			if (mb_offset + payload_len >
-			    le32_to_cpu(mb->meta_size))
+			if (payload_len > meta_size - mb_offset)
 				return -EINVAL;
 
 			count = le32_to_cpu(payload_flush->size) / sizeof(__le64);
@@ -2130,13 +2181,18 @@ r5c_recovery_analyze_meta_block(struct r5l_log *log,
 		}
 
 		/* DATA or PARITY payload */
-		payload_len = sizeof(struct r5l_payload_data_parity) +
-			(sector_t)sizeof(__le32) *
-			(le32_to_cpu(payload->size) >> (PAGE_SHIFT - 9));
-		if (mb_offset + payload_len > le32_to_cpu(mb->meta_size))
+		if (type != R5LOG_PAYLOAD_DATA && type != R5LOG_PAYLOAD_PARITY)
+			return -EINVAL;
+
+		if (mb_offset + sizeof(*payload) > meta_size)
+			return -EINVAL;
+
+		payload_len = r5l_recovery_payload_data_parity_len(conf, payload,
+					type == R5LOG_PAYLOAD_PARITY);
+		if (payload_len > meta_size - mb_offset)
 			return -EINVAL;
 
-		stripe_sect = (le16_to_cpu(payload->header.type) == R5LOG_PAYLOAD_DATA) ?
+		stripe_sect = (type == R5LOG_PAYLOAD_DATA) ?
 			raid5_compute_sector(
 				conf, le64_to_cpu(payload->location), 0, &dd,
 				NULL)
@@ -2183,7 +2239,7 @@ r5c_recovery_analyze_meta_block(struct r5l_log *log,
 			list_add_tail(&sh->lru, cached_stripe_list);
 		}
 
-		if (le16_to_cpu(payload->header.type) == R5LOG_PAYLOAD_DATA) {
+		if (type == R5LOG_PAYLOAD_DATA) {
 			if (!test_bit(STRIPE_R5C_CACHING, &sh->state) &&
 			    test_bit(R5_Wantwrite, &sh->dev[sh->pd_idx].flags)) {
 				r5l_recovery_replay_one_stripe(conf, sh, ctx);
@@ -2191,7 +2247,7 @@ r5c_recovery_analyze_meta_block(struct r5l_log *log,
 			}
 			r5l_recovery_load_data(log, sh, ctx, payload,
 					       log_offset);
-		} else if (le16_to_cpu(payload->header.type) == R5LOG_PAYLOAD_PARITY)
+		} else if (type == R5LOG_PAYLOAD_PARITY)
 			r5l_recovery_load_parity(log, sh, ctx, payload,
 						 log_offset);
 		else
-- 
2.43.0

