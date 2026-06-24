Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CEC43DB983
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 15:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782316487; cv=none; b=nM9UBAw5IMeGTWfQctB9x0WGjny9QLwNS2WKgtV4Ag6DSwtsuOIhFYjUeZrVteg39DJQKjQOdkXkqKi/10fsAJUP2GTonRDZUSVnJ1pQ1z8D0sKibIld6y+DJ9EyQ6cR643p6oXFCNcyNMytJDqsxepvrM+1mL5+ihIQabdJSZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782316487; c=relaxed/simple;
	bh=nX3gn8YviWsuTeYCATAL/Fr0JUnDD05I/EmYYo++YTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rdZmjX3bVpvBjBVxIbwwsIJfJv3RP7zy4aCf4IgG8NNz7q/Td7MZaq5FHo9ZO2dA9jDTEuIiph6XL7nxbHdG24LLEOHi+RwHkvYE0DPXiFcx6RvEmg5h1SwEdmZQxo84uRy6TedG4FdK8zwb09emRVbeq4VEBN1C7XZfB5ze4WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eHjYbDFm; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eHjYbDFm"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-36b95eb4bb4so923874a91.3
        for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 08:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782316486; x=1782921286; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P/SIaujBgC5aOUD/S8VBW5Bm93V0J++uefb7VggAtQI=;
        b=eHjYbDFmHLd3fW3koXtY52AHoNH2wrFVaASkZJxFvxe+11DJFZPERYTT6pICJgAYaK
         NKXxEUsm2afrLN6ll5s8UyvHe0sGQtp2P/1YNLQAEgN4qCTPcYfssCCEn008KBjaY2ZG
         nq6GHdvKk4CgunDEC6oR/tIdfCvfS35Wd5EnxM89+4RTS+FyYRG2b1D0IhASwyEdKRjp
         2ccKOdlW3DOUdvLz0fkTfhh4dkdyUH3yoXnbg0E7TVxqTAmyaCP+5RRXcsVf9ZV+xr2l
         maSRgnkh+M3cKF/IQimH8UQgUAKAIDR2scdjrW7dfUck55/knP22EyGdoniRC/EjrO1T
         JDFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782316486; x=1782921286;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=P/SIaujBgC5aOUD/S8VBW5Bm93V0J++uefb7VggAtQI=;
        b=BZd1NX8PXAxIQ0Qp1PRLJESAIXXP0fe+ptp8+KEoR2KuY/IODR3BMz+15hgAqITCKX
         oMLFVQfzrRi232qFlNOfZJ8gmx0Lw7APyp4nc7kPKihpa9nlu7KMzyG4ugtkxmDmqEnQ
         C8SOxIEiWf30ljfmwYgdInqWnUHPL13AZDm6WcrA//5OvUImkAjpA3tgry8uY8uoaSyn
         7qATpXxdWxjkt58Winca5xr1fXMTXAgtV3kOiWWpKFbeVU/v9aRaVMdxbbueLVqTz/zE
         TC3uV51y2reEXS4TRRT9eUXyMOoLlIOufmHZaG52mEv7AR0Og8se70DpIKrQmUJJZ2NZ
         a5Mg==
X-Forwarded-Encrypted: i=1; AHgh+Ro+HmMbSjtmudlZsFMXAaC+RM6rX8vWTmeynyj4DTsmFzbjrqAx9zl+/sSw9sj9AIeFbY9TeVjRaho1@vger.kernel.org
X-Gm-Message-State: AOJu0YwrRCG2I6waBjui5Fxha92O0xHPFrE+ruptW2tnV04Her/cTk+p
	VpGx6fHuurE7apAY6BUh/NebC1nwEUx2xrue/+BJOGCOh4giTZeVfYGr
X-Gm-Gg: AfdE7cmEXqBHfVcDJlTMfiqkYUWXj0diM26auSXVDec3/mplUIOkZ+5D+YxCh42nIVC
	PawLvhm27li9+irmcY6gsY8Bdgc24hltQUqAwezfzhWNaWmuTDp4MJ0g+/6d4Tz7PXkSYGT6YMe
	YCfCApWJQS9fd8p/onZTSKQZamnSBKtA2GV05ik0xXAxXsouJfudZemNBN74ZssQhnob5Ig9H2p
	MnkNHDMChG9wtdVy6kk7Bna4rZri37PyLfgYQ9QyfLTLj2w8nMpDsROTOFzCD7WzO13z7GjS29m
	EjtOCd77PJS+8XToRTd0U9Vsc20q1RpB/G22vrS3IQYJ6jcwqincry0gcsUOkcwHTFsrGDPNj5B
	1+x3bjbf48DQWU7IDCAHTWWaVhNv6KyXJN3hZwHoYnTiCXFyeA6Us29N8iFaJ4F3FN6MUPNi6EO
	QeF3WXpASyi4fqhut8EzKoeM6sqITvJIoxsd9XOJTnCN6VXCgherpOk5jNBUswSorZRM8Ci5LWg
	9B8Lx0=
X-Received: by 2002:a17:90a:fc4b:b0:36b:77b9:5c8c with SMTP id 98e67ed59e1d1-37de4275824mr4627688a91.17.1782316485727;
        Wed, 24 Jun 2026 08:54:45 -0700 (PDT)
Received: from research02.. ([2601:1c1:8700:f5b:fe34:97ff:fea3:c147])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37df3af8563sm54939a91.5.2026.06.24.08.54.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 08:54:45 -0700 (PDT)
From: Hiroshi Nishida <nishidafmly@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hiroshi Nishida <nishidafmly@gmail.com>
Subject: [PATCH 5/5] md: clarify the resync ETA comment in status_resync()
Date: Wed, 24 Jun 2026 08:54:21 -0700
Message-ID: <20260624155421.211626-6-nishidafmly@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260624155421.211626-1-nishidafmly@gmail.com>
References: <20260624155421.211626-1-nishidafmly@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The comment above the remaining-time computation was self-contradictory:
it said the original algorithm was being kept but "is not really
necessary", then described that algorithm under an "Original algorithm:"
heading as if it had been replaced. The code still uses it. Rewrite the
comment to simply describe what the code does.

Comment only; no functional change.

Assisted-by: Claude:claude-opus-4-8 [Claude Code]
Signed-off-by: Hiroshi Nishida <nishidafmly@gmail.com>
---
 drivers/md/md.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0cd85cc92ed3..a5c0da0d1133 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8916,17 +8916,11 @@ static int status_resync(struct seq_file *seq, struct mddev *mddev)
 	 * db: blocks written from mark until now
 	 * rt: remaining time
 	 *
-	 * rt is a sector_t, which is always 64bit now. We are keeping
-	 * the original algorithm, but it is not really necessary.
-	 *
-	 * Original algorithm:
-	 *   So we divide before multiply in case it is 32bit and close
-	 *   to the limit.
-	 *   We scale the divisor (db) by 32 to avoid losing precision
-	 *   near the end of resync when the number of remaining sectors
-	 *   is close to 'db'.
-	 *   We then divide rt by 32 after multiplying by db to compensate.
-	 *   The '+1' avoids division by zero if db is very small.
+	 * rt is computed as (remaining sectors) * dt / db.  To keep precision
+	 * near the end of resync, when the remaining count is close to db, the
+	 * divisor db is scaled up by 32 before the divide and rt is scaled back
+	 * down by 32 afterwards.  The '+1' avoids division by zero when db is
+	 * very small.
 	 */
 	dt = ((jiffies - mddev->resync_mark) / HZ);
 	if (!dt) dt++;
-- 
2.43.0

