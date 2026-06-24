Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78FA33DA7F5
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 15:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782316481; cv=none; b=aWDA5tVKLd/vR44JXRth4iOzRbC9WvphfWv4ZsgbNmP0U/fKp5JPEBlNMh+NbX6OsbE566PaydRGp+J7iH9fFzczDHnkggr8Vg4XHG3ctFWUlFKUAfY9164lpNeNZ+EPStCGrc6ufHnZ/ni2GsVMAwn6IAL5hzaLKhPONcWajaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782316481; c=relaxed/simple;
	bh=dTRBR4bClxSYNZsKNqUn2Mr/2BNUiFbzohcQCQR/4xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ip31CgUw2ere1vXw9kyIDSTOYjG7dsokGgEyhHmSJK3FAt2HgML8hOwvOSnkQ2C77Mys6Daj0V2SQr+3dYyY/dkdMHrvoLb0wb/tPEmDDijE4t4hgv7KomOaFM9BRJy2KZ6bnPExl80COk/AH4veGvb5pbhba8MZir20752yTzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NkRGbQH3; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NkRGbQH3"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-36d630c0e35so1495215a91.3
        for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 08:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782316480; x=1782921280; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SXUGFnFKwaTFY4kkghLqdPNss9yNarhXY1Mnk92B+w0=;
        b=NkRGbQH3qDzMvT++mdngel3YJl+lhR2ALInBfztz7wflWF2iSdCmUIqkmo7TB+Nm3/
         hybZoVwHxUP2PnaYRYzSBIbGZqtOzLAJVb+fsAW9np+rG2Yi1ID8GujoCQdPIdHCbmnP
         ImOzlFfw3r1gXNyJphtUcjzgIraG2ZwlJdeIFgG6YoHyoFD+9hZu+YQY6UUfxRgbtvTb
         fDqLl5wq6UQT6uXIHSYEAiysQI5rt4pvQLbuaoHOw6GEoN3xOPUnE5nXcjG0x/+KU2UZ
         05CRiiL9/RlntAJkcPqDfsqIbzgkRGxPOK6ef64zMN6JmsnLHu5XoDTvq+t0JoP+hJlF
         mi+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782316480; x=1782921280;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SXUGFnFKwaTFY4kkghLqdPNss9yNarhXY1Mnk92B+w0=;
        b=ohZI2V/W7pxT66B0V0DBex0oz4xeSP2T3T3561iuHAsSuGGS04YeeeN2XWdzM6/Brj
         AeyzIMeBiQLzILG1lx8NajQOEevjTLzDBdHkMnmEwcHrQw8Ho+QcvtMFK84aurv2ebAY
         SKZSYFdFYs9E3AtFZF022eW2TFrpJPVnrJJQAfRbvxVc2uMqiFkU5xJCTUCNz+NnhgML
         bjJ0wCeDv7mQ3qvjtGWT8aJWhen2JbP3dTt2aHFz9Ka6zZ2xYjP6yn4gT8+XE9/XBEYk
         pG8Pk22pwPFbfk6hwSP/721kMnGAYQXPwSmbnkx6tPVaR2keig1L4HHSVI+dM30SpBhR
         3fzQ==
X-Forwarded-Encrypted: i=1; AHgh+RrLolC3tJeccC1r8BhremCdtT3StvIzUeK1/2z/QBG/FZNdN0W6ImmI7AtkM294xNAWZF6v6G7ICfAg@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4WQyM9CW4iFjwxJeQMs/xpSQnuZ3/Fy5yfiJw/ZYauePg4d0I
	1eWiCOo1B1wTy/ZFKaFqmpTLVOICTOzwzGxo3TURZ8jkV6VuS8nPJV1HwsS44WWs3to=
X-Gm-Gg: AfdE7cnz5n/LebDWugN6PTrEiKfc6oQWt6rw/i4QDgPCEhcbdv57gTHMb9MuajOLwpj
	vm7DqMcn2t615Kb3uIA41q5TQdmeiIzRMz+t4kbf8SrjYcokoeT1yocr92lfY5kNI4/uaV8a1kl
	/uyW+dQG/PPysxSt83/EURjJ0grEpn1MzKSI7nspQB1VSWQo6jSkqs7kObZCCZF6xqVKzkBLQ3k
	s54IKx6z+sWX/iweldc6PGSBGT5/NDLct+hQV0TErWbW1BEbkX83ELmmEhKKKKHncqyCDRTJxbI
	Nxe0fL3IoRw+uJCi9cZLIrOi0SY7eUKbV+YS0qeXrsuadmmTYI9+X+Id3I/Raa+/FdjEHfJgBMJ
	8fETxnsQl1TM/8HCTY5h8XXzC7thoNjrwAWpU7zF4hMzDgYifP+/goj36iTmgFI24DeOPa4ICJM
	5qy+k6RtAdns5kOzUorWDp9EV7P5XkIbSkXBHRU7ha7W0YA4lWqwPE5AyexCDewrt7Dj4NLDEzp
	KlJha8=
X-Received: by 2002:a17:90b:3c11:b0:36b:a2cc:485b with SMTP id 98e67ed59e1d1-37de46c33f4mr4586786a91.21.1782316479722;
        Wed, 24 Jun 2026 08:54:39 -0700 (PDT)
Received: from research02.. ([2601:1c1:8700:f5b:fe34:97ff:fea3:c147])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37df3af8563sm54939a91.5.2026.06.24.08.54.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 08:54:39 -0700 (PDT)
From: Hiroshi Nishida <nishidafmly@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hiroshi Nishida <nishidafmly@gmail.com>
Subject: [PATCH 1/5] md/raid1,raid10: drop unused mddev arg from check_decay_read_errors()
Date: Wed, 24 Jun 2026 08:54:17 -0700
Message-ID: <20260624155421.211626-2-nishidafmly@gmail.com>
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

check_decay_read_errors() only ever touches the passed rdev; the mddev
parameter has been unused. Remove it and update the sole caller in
exceed_read_errors().

No functional change.

Assisted-by: Claude:claude-opus-4-8 [Claude Code]
Signed-off-by: Hiroshi Nishida <nishidafmly@gmail.com>
---
 drivers/md/raid1-10.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
index 56a56a4da4f8..edba52eb3116 100644
--- a/drivers/md/raid1-10.c
+++ b/drivers/md/raid1-10.c
@@ -171,7 +171,7 @@ static inline void raid1_prepare_flush_writes(struct mddev *mddev)
  * We halve the read error count for every hour that has elapsed
  * since the last recorded read error.
  */
-static inline void check_decay_read_errors(struct mddev *mddev, struct md_rdev *rdev)
+static inline void check_decay_read_errors(struct md_rdev *rdev)
 {
 	long cur_time_mon;
 	unsigned long hours_since_last;
@@ -206,7 +206,7 @@ static inline bool exceed_read_errors(struct mddev *mddev, struct md_rdev *rdev)
 	int max_read_errors = atomic_read(&mddev->max_corr_read_errors);
 	int read_errors;
 
-	check_decay_read_errors(mddev, rdev);
+	check_decay_read_errors(rdev);
 	read_errors =  atomic_inc_return(&rdev->read_errors);
 	if (read_errors > max_read_errors) {
 		pr_notice("md/"RAID_1_10_NAME":%s: %pg: Raid device exceeded read_error threshold [cur %d:max %d]\n",
-- 
2.43.0

