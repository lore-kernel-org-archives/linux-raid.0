Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9653DB633
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 15:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782316485; cv=none; b=EeboUjkWcGXXGWJ0t2gew6o3F1WQUtWTUNksCMv5Eh5d8y2U7rIfXXb+7stKCLx1GhBJPq2wrYxBasIWPcxymq0XtmznCiXt04pkFXbgh0mJLMm/3YBExH0po5ATA8atopO8bsQqi/T9xdotFuYlsQdcBf/9O53EzbJELUwasLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782316485; c=relaxed/simple;
	bh=gsTcVSB1HVohq9ZUOprWEjKXmtwzCIkMDuK0NNq4+bg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ig9QU1uho49An/p572z/EDFMudlEZNZU5f/7DGsP9XNjbDu2C1bgCCGrIxhF8Wymf+5UI4rsQcCqZP+vNmIXNz5rA5TfjIuIW9fvQswyqHxN4eZLVPzhsj6kY25fPO45t2B/maVgEAR5VA8ShLf3fKW8HbcHQFAuC0euv2jIix0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jdqV00Ql; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jdqV00Ql"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-37d55e8d3e3so10258a91.0
        for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 08:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782316484; x=1782921284; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QIyJ/OEMyv6CfTN62fPbwl8g0Qx7uhKVuGgsdpUT7sQ=;
        b=jdqV00QlFSrhj6Tzvn4slD3/YpADnAZ0+JAEHCXpzoa8srVTg6FdX7cD3iNId9hUK9
         LpAWQAOgrJHwursOPV/aM0OrWtng/02CqCRJ0TC7rKziF7RcjSkedEAHrhEbNydzeWVM
         46JL/rplrLec6R9/+iw8sAyM4R8VvHJrlBi404its3kbL5mryZW8Eoi6Z7/R1FeGxHaV
         Ej2vmBCPMcsmoiFIX7Odw22kXxAUlf2HwRG/G6qXzREiMbUySHHkgSuAjXW/+NfpJDeV
         K2zbu09xETPRdLixu0A/w3Xz0hD9PSRF/oWaWSEN1nskC0b96vwX2qNCpoj9ROm1DWo1
         fv7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782316484; x=1782921284;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QIyJ/OEMyv6CfTN62fPbwl8g0Qx7uhKVuGgsdpUT7sQ=;
        b=ogj6xB2nRQ4/0J1PfjADeKI6Jd3FukVRj2EGIcXbbans0F4z/o235Z0VmSyarCBBZs
         KlfcSYh0QF9Wg4fsyBZbGlAwlPFpf8hQWGLKW0cz8d+HXS07FjtzgSb3RFCpPJ2BCb3M
         rH2Q9mKNVWMdK0NUo3aqrqYbUxoeuInSY9brPCw6mGwRq49Iz49K20cqxMOuDGAEhNMr
         d9TCgBPkU2cR8VjUIDOv3jn0CeQCMDIMC7ATRAWNFRvU5EssvVyl3zlM8n/g582X/zj+
         z7hdiYI4yVgU1Fu2Of/Jmrx2KPTOIxTSSNqw5L7737DT6ACPGxUjqZAYvHLdeMk57Bqg
         Vl1A==
X-Forwarded-Encrypted: i=1; AHgh+RqFm76G0KebpTjyiIndcCTK/bLgbgW+4mYj6vzE0sPRcP42cKpYntpondHSMzQ9M9YBSA8QwcJTfWWT@vger.kernel.org
X-Gm-Message-State: AOJu0YxKFJ0QcdOTHngUCb/pKF/DURHYZwK56Fconr8RgvL5OX++rPwM
	KxqWvLSPEkJVKgolsLpiaDmoqW65YKQhiWXNUdPhUqs9WsjSiMtZHkqW
X-Gm-Gg: AfdE7cmr6DNaZE/quwI0TuMTx0PqVbOwem1oEqeYgWQ8plbbD7uCXr6MXo1+oyTqAIh
	Q/Oh5T1W0fsRcSGwH/bQS9e8/HPxDsbqzbgUalflDKT/BRi9UYz2YrT6i5FNTxB6TTrZotOfc2B
	TU2ZP9ddVT75/iX+0Hi7Iyhur43/YvPyYgrBnw6k4KaKjtQtjqiBYDPJtDtDtd0CJhZEM6bg7oP
	0UBPpdXoeY3ws75X8GjpogjL8iSLJ2Ir3jbOUwoH/5tk8DvzmtRqCncluHHrPZ4C//Uypol7ZpX
	xDcDvUFhe9CxVeUbPYlL+P2U8yrkWCHMg1/d7Zeq7vJBGv7SIQ3jA8h7BT39RMFq0hbeANqoA8D
	uUGQoRqSpU59qeIxtjxsgZ2ZiRxumY6YOWh+d+clyNKKUkJcyo3mqZUo5HR5lzzLSr7+sYn6VU/
	OuPCqBL7QbMDDFOVYkazPBm3nW8rkiKGjkmeWo66VItejyWg0er37p54OmUm88Y1YjpwXUTFN2c
	FlRqGkljOI4Bao60Q==
X-Received: by 2002:a17:90b:1dc3:b0:36b:b903:994 with SMTP id 98e67ed59e1d1-37dcd66b178mr7736394a91.4.1782316483960;
        Wed, 24 Jun 2026 08:54:43 -0700 (PDT)
Received: from research02.. ([2601:1c1:8700:f5b:fe34:97ff:fea3:c147])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37df3af8563sm54939a91.5.2026.06.24.08.54.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 08:54:43 -0700 (PDT)
From: Hiroshi Nishida <nishidafmly@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hiroshi Nishida <nishidafmly@gmail.com>
Subject: [PATCH 4/5] md: use sector_t for recovery_active in status_resync()
Date: Wed, 24 Jun 2026 08:54:20 -0700
Message-ID: <20260624155421.211626-5-nishidafmly@gmail.com>
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

recovery_active holds a sector count read from the sector-typed atomic
mddev->recovery_active and is then combined with the sector_t values
curr_mark_cnt and resync_mark_cnt. Declaring it as a plain int needlessly
narrows it and mixes signedness into sector_t arithmetic; declare it
sector_t to match.

No functional change.

Assisted-by: Claude:claude-opus-4-8 [Claude Code]
Signed-off-by: Hiroshi Nishida <nishidafmly@gmail.com>
---
 drivers/md/md.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 829b4a3f545b..0cd85cc92ed3 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8816,8 +8816,8 @@ static int status_resync(struct seq_file *seq, struct mddev *mddev)
 {
 	sector_t max_sectors, resync, res;
 	unsigned long dt, db = 0;
-	sector_t rt, curr_mark_cnt, resync_mark_cnt;
-	int scale, recovery_active;
+	sector_t rt, curr_mark_cnt, resync_mark_cnt, recovery_active;
+	int scale;
 	unsigned int per_milli;
 
 	if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery) ||
-- 
2.43.0

