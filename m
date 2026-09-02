Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6154A1DFF
	for <linux-raid@vger.kernel.org>; Wed,  2 Sep 2026 16:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788365218; cv=none; b=JzfhktHvns4x5vzybt+RLbGEs2r53rsbHPBFKVmn1/leHiqx8FW2iS6/PERYFQo7M/yexMRuC3FVf0wyH2e1rVZUeMjPzflABM8YkhHNRnQnIDcNrWV+pt/uAkEWUr4SAcjmlka2W+LczzIk7Ds9bUenKJHwsVTr2qpDWVZTFqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788365218; c=relaxed/simple;
	bh=tjcWcq1vsbmjnN1l4BNYazR6Ln+crXs0S/cszeTzk1E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HrVa1MRGmrJmazeobRBqHhnESsVCJCzELrK9+zJ7buytfna6G9g2AbxkkkJWo71VVzYIOc7SOCWLL46nQKxr04BxBXWQNAR/7GXym/4TeCpBxJ8AXdru2DczH0m7qXHLrN49zbVED7E9BGChjrq/vD4prn2h6XGx3jNNMVVLeg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=UGX/lM2n; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UGX/lM2n"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4954a9e8490so80095e9.1
        for <linux-raid@vger.kernel.org>; Wed, 02 Sep 2026 09:06:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788365215; x=1788970015; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/Bbo3ndqYQwPgRKA7QTntetVj75xMQY39h5W8p/1ZdI=;
        b=UGX/lM2nWcXSrh+oxSAzxieuhgb3i9l6ETejHb5vzDfuOjYTxMOaAkDUPOefNNv+4f
         nuLSNZMDF+6pAHwgURCv0HNngGmwGxN8kFPeUi6VFBFNQdGcmkdos6qQGSe6M9VBN9B1
         dWm79eH6sZ3lXbz3xxhdSaVTtT9JE0woia5pC5G1tbSjK+S1YaSAcE990F3Ro1EklqRP
         yWOF1YaoEJtpyul4GhpSca6bdA9iXFnx1GmbYjumcjAOx2+X2PNvOnrPW9SIYMnK9i5O
         7bIOPb6z/6HoslBJszDxkYMvv82AISS3Ucqselu7+95NJ7oQ4kKW76WtK6cW86gok/Q0
         Kxuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788365215; x=1788970015;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/Bbo3ndqYQwPgRKA7QTntetVj75xMQY39h5W8p/1ZdI=;
        b=ZTCK6rNorzHjhGokT6q7lz2UpFYmSNTPKYldD95P1LJ7gY1/nxY3Tord72uteno9uN
         dWD72PtMsLRBWH7jqK6F1UrJAa1K8NUnEM07mjMn+gps2mkjFIeXz9IYChVwArvy8wvZ
         zSrQJOMxRkfmWN1+VZxwKkM40NszvfWRV96HkUQ6laM20GVLixUT+rqN/HGrCcePyyOs
         nK2gpbHG6LZ2tZDU06wVUfeS9OTUV8YvoA7ury+xrg3w/W35+IhKwY4gIeV1XvXVpEx3
         IOeFz+S5bfx9XSSKFeZE62GzbXh2/3DOhVeBc1D8dBo+hAGVZ9GYn7SUoavKsa0c5W1I
         hAWw==
X-Forwarded-Encrypted: i=1; AHgh+RrZfRf9ers/N3s5/kNAACAwItBI3FzrqUQIqUymoljBl1Dne7UMhfBx77559tNgeS5c8XBath1C8pEk@vger.kernel.org
X-Gm-Message-State: AFuF++m3kzqfHPTUyeoXYrR40Iv+pQYPfGsDvUnmb1Qu9d8pjYbfiB3K
	a2dAro0W4Cg5bgPur75Lq2Q+8cQCKqMoLLM36SX72uzZmtqUqvBpQFyiFn2i0Lv3JWakLQ80gU5
	jAeCrGkI=
X-Gm-Gg: AR+sD11VZMiPWVuy43bHqFfxZ0RJzu/qKHXdA0UJHchtCX7p3ovlb00QWDP5JZgSMEB
	xt3CJYxbuo2M3M+S620SJ/bGNjpJ0T2pL+zJ8uVrnVP33WzglRv9AiJI1Ajr5WKeqdbvze/5bzX
	sXnbrEI7c5AmRqLh5q6lHgrVsAnnzcEwvdxrBVtsDv5iWBZB9ypJzl/dg/8UlGU5WRfCshV1GGa
	/XGngD6vU058R6US25SrN2GUJjtURetnlabKonMsmpdfO5+oITDZYB8dgdjnBqqHVfQY6XEtrF7
	31qv+y/12prv9bXJhZ1mMD5c/5COGiLFn4oOGNpQ7bGXNjY3Ipj/AFZDU5SHluIO57FI14ZutSZ
	52qKLCJ29CmtCL+mpblo3h7HBPTAffLhDkhfunFxsguTWnYEKBXwtAbwo/1lVHPVMSkut+1m1Wq
	TtSxmtfKelSQRT6MiB6/Mzy0Jdxqh3koJ1q+ucaz3bbRKDLxSkftxt6fjNIqeKF+DluXyDqmm0O
	P6wIM/UYTHsvnwNahHZ7QlppwBLx0i+5sWTPPcG9DKd6QIEHrfl
X-Received: by 2002:a05:600c:19c8:b0:493:f783:c46a with SMTP id 5b1f17b1804b1-49cee5e8fe7mr4442745e9.6.1788365214792;
        Wed, 02 Sep 2026 09:06:54 -0700 (PDT)
Received: from localhost (p200300de37172700e7f885d729fa4be7.dip0.t-ipconnect.de. [2003:de:3717:2700:e7f8:85d7:29fa:4be7])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-49cee5f914bsm1738445e9.3.2026.09.02.09.06.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2026 09:06:54 -0700 (PDT)
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
Subject: [PATCH] md/raid5: validate payload size before calculating payload_len
Date: Wed,  2 Sep 2026 18:06:03 +0200
Message-ID: <20260902160603.218621-1-mwilck@suse.com>
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
entries have variable sizes.

Add another check to make sure that payload->size can be safely
accessed.

This issue has been found by AI (gemma4, Gemini) during a backport
review.

Cc: Junrui Luo <moonafterrain@outlook.com>
Cc: stable@vger.kernel.org
Fixes: b0cc3ae97e89 ("md/raid5: validate payload size before accessing journal metadata")
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 drivers/md/raid5-cache.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 7b7546bfa21f..accf8b472082 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -2008,6 +2008,9 @@ r5l_recovery_verify_data_checksum_for_mb(struct r5l_log *log,
 		payload_flush = (void *)mb + mb_offset;
 
 		if (le16_to_cpu(payload->header.type) == R5LOG_PAYLOAD_DATA) {
+			if (mb_offset + sizeof(struct r5l_payload_data_parity)
+			    > le32_to_cpu(mb->meta_size))
+				goto mismatch;
 			payload_len = sizeof(struct r5l_payload_data_parity) +
 				(sector_t)sizeof(__le32) *
 				(le32_to_cpu(payload->size) >> (PAGE_SHIFT - 9));
@@ -2018,6 +2021,9 @@ r5l_recovery_verify_data_checksum_for_mb(struct r5l_log *log,
 				    payload->checksum[0]) < 0)
 				goto mismatch;
 		} else if (le16_to_cpu(payload->header.type) == R5LOG_PAYLOAD_PARITY) {
+			if (mb_offset + sizeof(struct r5l_payload_data_parity)
+			    > le32_to_cpu(mb->meta_size))
+				goto mismatch;
 			payload_len = sizeof(struct r5l_payload_data_parity) +
 				(sector_t)sizeof(__le32) *
 				(le32_to_cpu(payload->size) >> (PAGE_SHIFT - 9));
@@ -2035,6 +2041,9 @@ r5l_recovery_verify_data_checksum_for_mb(struct r5l_log *log,
 				    payload->checksum[1]) < 0)
 				goto mismatch;
 		} else if (le16_to_cpu(payload->header.type) == R5LOG_PAYLOAD_FLUSH) {
+			if (mb_offset + sizeof(struct r5l_payload_flush)
+			    > le32_to_cpu(mb->meta_size))
+				goto mismatch;
 			payload_len = sizeof(struct r5l_payload_flush) +
 				(sector_t)le32_to_cpu(payload_flush->size);
 			if (mb_offset + payload_len > le32_to_cpu(mb->meta_size))
@@ -2106,6 +2115,9 @@ r5c_recovery_analyze_meta_block(struct r5l_log *log,
 		if (le16_to_cpu(payload->header.type) == R5LOG_PAYLOAD_FLUSH) {
 			int i, count;
 
+			if (payload_len + sizeof(struct r5l_payload_flush) >
+			    le32_to_cpu(mb->meta_size))
+				return -EINVAL;
 			payload_len = sizeof(struct r5l_payload_flush) +
 				(sector_t)le32_to_cpu(payload_flush->size);
 			if (mb_offset + payload_len >
@@ -2130,6 +2142,9 @@ r5c_recovery_analyze_meta_block(struct r5l_log *log,
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

