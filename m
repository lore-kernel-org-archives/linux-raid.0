Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B29F335C1AD
	for <linux-raid@vger.kernel.org>; Wed,  2 Sep 2026 16:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788368296; cv=none; b=QkJKj0a04cjlSq8C7xQB9xcAwJJfwAm7Voi7tcaiZgaImcH8poQq1b9pY72twpVAWEg9aI9RZsRRj/QcEQyuism8Yk4pHqNR4qrObltk/jJdwRDUmcJobWDx8jZgX6e3jkMaH8m2YzW31sk+6bsT3RG+OTp5WDU6K3xcI3pIIa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788368296; c=relaxed/simple;
	bh=zT4h0oWj9hfLxliIpf9slXTQzOoEMF14XMbCsNWo6E0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fRfpQg8CGsdrCfZD9d7G+p4O9hQZGpZghmRXfhkOhd+GhyzLmlUchlW4pVGK66FNvo7xw86U/wq53tomLevyRH3f7/IjoYiALWRjKZWRuwyaaNRlyzaPQVFvzd9iRy4M9JPM28ZBzfClzF079EgSzaHcXRy1/AC4t+E5sRV9+T0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=C/oRqbIe; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="C/oRqbIe"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-48441a2ba14so1236455f8f.1
        for <linux-raid@vger.kernel.org>; Wed, 02 Sep 2026 09:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788368293; x=1788973093; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=WLzopvdwYBADPPeGr/ICG7pbna2LTAcTqFMX3lkolWA=;
        b=C/oRqbIeS7M4NTmeHiWufAYJ6tniMCi0gYZYxPFypgiPyq1Ddu9rf7sFQZGw7EtTaP
         dwYl4OG7wtTATijEbDuwTj5vDH1XE81CWD6IgQcx0aiUDRWJqjehkCsXjQaEw66qSrTW
         bfnl9xDahvoGrseoQ5JSu6CArkH4PtQxRV5dHqwVdZmwHkutuQ0v+8B0YXIZjRbKvW+g
         uEZ3LEZQGwHoyTawHkE1LLA6oAlx8pJMNXyJKyj3YU1Qx7ulbPJDiGuR8vEHPEn7TAV/
         MYJcGetFZb5mc+7HMZd3Oqlsgx8x6T0IB/07yGT2PgyqBvQXEgMbxQcwoguRhJkybH94
         Hp3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788368293; x=1788973093;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WLzopvdwYBADPPeGr/ICG7pbna2LTAcTqFMX3lkolWA=;
        b=SZyEF2JR986ix6n4i0z/q37jBfJQpzOHXlMOP43YEmAMtjzvHAn0k+cXuJXqX+HyId
         nq+hhWaLWlmI6tJAOIWdf2oxLdfAZy/3JQnTj+T+I88JkdE78D5gLdqVnu+vXzQxOjfs
         7oeSU8w17001l/wlqAr1Ca4WvP0wOTMX1Wom/nI54y4FI+z6hJZUjmQYZP6qHxcT83Ii
         Gn7EKxd6YYbOV37i5Pk4cdwnZjFxKQNhYwdGqH5frDYd2MDdaBJ7Jdd7vqeIo/VQ6524
         ntnmHrR0rOm5q9JwE8TnUyJpSIiRdGBR9yFjJ1Bs/xxznixsmpRHQuqaiUhBVIWRxMxf
         M9/Q==
X-Forwarded-Encrypted: i=1; AKwUvBzi5qkG2imhrSbn+gN3xdwL5iLQkWMs5hdO/f83crOIXaK35FQs7l40Ti6VScxxoUt+wZ8lHyFT7Wjp@vger.kernel.org
X-Gm-Message-State: AFuF++lIG8N3g94jKWBjRiAUYUtcbL7V4uN5i07xJFAtw+L4eEU2u+A6
	k7u/cddpKA6pe6DKLG/rJnFQfLLPL+9/pWpr+043R8vi2k9UjYtdIeieQT2cKPWmXkM=
X-Gm-Gg: AYBFou3ngrSkpS3jeos/j4LmF60EEiL1J5FyABZSHfrSrZVC8Fh6QaOk4xVpflHCKSJ
	uvS5b7hcWnqv3yL/g4poSsXO4VA8oD/adx0iAtB3nvF1P8CcujDHi9OeXVIhNFHUMLodC4oieSH
	THS4moKwNEB7MM3ygmfw/HOG44XoFPhJbgI7ZLTLGT8DULUtP7wD1wfKzFRU0nd3tumpMxgfAJy
	TPS8t/ZHwkVwh5H82yr5vgGpg9iFB23k+PFl0Yujj/qqAwVlzD0WxNu0c+sE4QQRGPV8FAcuqht
	srVkurHo57cA77Bos/F2Mp4fJAt7qxfMgjAU60q9UyWc18pw6b5pvrqnBjCbKttrQiE7OV/xAni
	WfmfSYbfeaYSxZ6WRsuXSnofg9E3nWxpU6FX7qgKLP85IaAdPlM4tUsnzNpfsv+xuH/kxUrKr0X
	QOJlzF9gLrJRleEBPhFGFVd67IKIcaohby1GZ8A04Fs909gilVVit2Zx9FUCs35+NVqaZytcM40
	pPq9FA28ydeAzl+lWdoPEycB8KSlUFgN4HiVZ2K4WPWxJY4Dup0vqTi6gQBSfw=
X-Received: by 2002:a05:6000:22c8:b0:484:4779:bcdb with SMTP id ffacd0b85a97d-48488deb822mr12155562f8f.6.1788368292712;
        Wed, 02 Sep 2026 09:58:12 -0700 (PDT)
Received: from localhost (p200300de37172700e7f885d729fa4be7.dip0.t-ipconnect.de. [2003:de:3717:2700:e7f8:85d7:29fa:4be7])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-48448ed2edfsm7335571f8f.23.2026.09.02.09.58.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2026 09:58:12 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Yu Kuai <yukuai@kernel.org>,
	Song Liu <song@kernel.org>
Cc: Xiao Ni <xiao@kernel.org>,
	Li Nan <magiclinan@didiglobal.com>,
	linux-raid@vger.kernel.org,
	Takashi Iwai <tiwai@suse.com>,
	Martin Wilck <mwilck@suse.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] md/raid5: validate payload size before calculating payload_len
Date: Wed,  2 Sep 2026 18:57:53 +0200
Message-ID: <20260902165753.255675-1-mwilck@suse.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit b0cc3ae97e89 ("md/raid5: validate payload size before accessing
journal metadata") introduced a bounds check to verify that a given payload
fits into the current metadata block. In order to calculate the payload
size, it has to access the member payload->size, the offset of which may
already be past the end of the metadata block, because the loop condition
only checks that the first byte of the payload is inside, and the payload
entries have variable sizes. Later on, payload->checksum[0] and
payload->checksum[1] are accessed without verifying that payload->size
is large enough.

Add another check to make sure that payload->size can be safely
accessed, and make sure that the checksum fields are accessible.

This issue has been found by AI (gemma4, Gemini) during a backport
review.

Cc: Junrui Luo <moonafterrain@outlook.com>
Cc: stable@vger.kernel.org
Fixes: b0cc3ae97e89 ("md/raid5: validate payload size before accessing journal metadata")
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
Changes v1 -> v2: Fixed issues reported by Sashiko

* fix use of wrong variable name payload_len instead of mb_offset
* add checks to ensure payload->size is large enough to hold the checksum values

---
 drivers/md/raid5-cache.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 7b7546bfa21f..4a97846e9030 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -2002,26 +2002,35 @@ r5l_recovery_verify_data_checksum_for_mb(struct r5l_log *log,
 		return -ENOMEM;
 
 	while (mb_offset < le32_to_cpu(mb->meta_size)) {
+		uint32_t payload_size;
 		sector_t payload_len;
 
 		payload = (void *)mb + mb_offset;
 		payload_flush = (void *)mb + mb_offset;
 
 		if (le16_to_cpu(payload->header.type) == R5LOG_PAYLOAD_DATA) {
+			if (mb_offset + sizeof(struct r5l_payload_data_parity)
+			    > le32_to_cpu(mb->meta_size))
+				goto mismatch;
+			payload_size = le32_to_cpu(payload->size) >> (PAGE_SHIFT - 9);
 			payload_len = sizeof(struct r5l_payload_data_parity) +
-				(sector_t)sizeof(__le32) *
-				(le32_to_cpu(payload->size) >> (PAGE_SHIFT - 9));
-			if (mb_offset + payload_len > le32_to_cpu(mb->meta_size))
+					(sector_t)sizeof(__le32) * payload_size;
+			if (mb_offset + payload_len > le32_to_cpu(mb->meta_size) ||
+			    payload_size < 1)
 				goto mismatch;
 			if (r5l_recovery_verify_data_checksum(
 				    log, ctx, page, log_offset,
 				    payload->checksum[0]) < 0)
 				goto mismatch;
 		} else if (le16_to_cpu(payload->header.type) == R5LOG_PAYLOAD_PARITY) {
+			if (mb_offset + sizeof(struct r5l_payload_data_parity)
+			    > le32_to_cpu(mb->meta_size))
+				goto mismatch;
+			payload_size = le32_to_cpu(payload->size) >> (PAGE_SHIFT - 9);
 			payload_len = sizeof(struct r5l_payload_data_parity) +
-				(sector_t)sizeof(__le32) *
-				(le32_to_cpu(payload->size) >> (PAGE_SHIFT - 9));
-			if (mb_offset + payload_len > le32_to_cpu(mb->meta_size))
+					(sector_t)sizeof(__le32) * payload_size;
+			if (mb_offset + payload_len > le32_to_cpu(mb->meta_size) ||
+			    payload_size < conf->max_degraded)
 				goto mismatch;
 			if (r5l_recovery_verify_data_checksum(
 				    log, ctx, page, log_offset,
@@ -2035,6 +2044,9 @@ r5l_recovery_verify_data_checksum_for_mb(struct r5l_log *log,
 				    payload->checksum[1]) < 0)
 				goto mismatch;
 		} else if (le16_to_cpu(payload->header.type) == R5LOG_PAYLOAD_FLUSH) {
+			if (mb_offset + sizeof(struct r5l_payload_flush)
+			    > le32_to_cpu(mb->meta_size))
+				goto mismatch;
 			payload_len = sizeof(struct r5l_payload_flush) +
 				(sector_t)le32_to_cpu(payload_flush->size);
 			if (mb_offset + payload_len > le32_to_cpu(mb->meta_size))
@@ -2106,6 +2118,9 @@ r5c_recovery_analyze_meta_block(struct r5l_log *log,
 		if (le16_to_cpu(payload->header.type) == R5LOG_PAYLOAD_FLUSH) {
 			int i, count;
 
+			if (mb_offset + sizeof(struct r5l_payload_flush) >
+			    le32_to_cpu(mb->meta_size))
+				return -EINVAL;
 			payload_len = sizeof(struct r5l_payload_flush) +
 				(sector_t)le32_to_cpu(payload_flush->size);
 			if (mb_offset + payload_len >
@@ -2130,6 +2145,9 @@ r5c_recovery_analyze_meta_block(struct r5l_log *log,
 		}
 
 		/* DATA or PARITY payload */
+		if (mb_offset + sizeof(struct r5l_payload_data_parity) >
+		    le32_to_cpu(mb->meta_size))
+			return -EINVAL;
 		payload_len = sizeof(struct r5l_payload_data_parity) +
 			(sector_t)sizeof(__le32) *
 			(le32_to_cpu(payload->size) >> (PAGE_SHIFT - 9));
-- 
2.51.0

