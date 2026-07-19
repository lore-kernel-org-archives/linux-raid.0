Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD7639E178
	for <linux-raid@vger.kernel.org>; Sun, 19 Jul 2026 14:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784472259; cv=none; b=JMgE0tjE2DGOeMz016BHJsZPyHIPael4jpuHK1OJjUBeAFD2W1cKpK2o3g+C/jvfxBKFxRWpWr2BJnYckmOfNHzq7VRY5W6/++JaEQa2VGwLjd+3/2SzSk/co1YgTqrsqEivoRH8gZzd7Rz8RIuX5dcqe9qZo9X0WZWLa34He8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784472259; c=relaxed/simple;
	bh=OjK0P0grXIP5S3JmdPdX8ixBTc6NqX0sbpWjba393e8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RkWhmr0llK3VJymdy63m0UqZvDm7ifTor6tSKS15snC99+OJlDE/sd9A0BYkDBy7iAyIeqwRNQPWKGUjXfyUsTbIY3DB7DDk3NrpsBHJjgPzS/HJACHBAdbjH543g2XB7dsllZwYz6oQSXUe92xgO2JsUkCNa73+PTNOacJ+HIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=Ni9Q7ouR; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="Ni9Q7ouR"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4955158f26aso6821495e9.3
        for <linux-raid@vger.kernel.org>; Sun, 19 Jul 2026 07:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784472256; x=1785077056; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=p0G31B+Jj55yY0X17Nesehfar6IDfQLHZUQBZ4ogThM=;
        b=Ni9Q7ouR6IaLdJUVC+7Fllguok9DTIviRywykpvrVJhpKJ8mi1oHVPx4zGtIMyzASX
         bcpFhUijEBs4XKJ5XSzt6EAANBAoIeFxgJm+9sEh21KHJTCoER3XTLRUcckHXoXVacLW
         35eaNMN7Gwrg0jkj0XSJJLi7a1mBmOrgJEOM1bpLCBmudPgD97LO8SBbmHxq1MtrOoK9
         kazgU06n02Ev40A1SIt7b8V2XhkK5/7CoPkewVnWWwCFrIgzy5RAyTu53XPx3T6nZ5Ys
         M/oVu8eUSUo+wiRRRHthEkAKneLGZdhKMtXduRnM29oQPiVLKtTrbnGwBAPmEG+fr+fM
         GHAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784472256; x=1785077056;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=p0G31B+Jj55yY0X17Nesehfar6IDfQLHZUQBZ4ogThM=;
        b=h6ndVWdW8bx33Thhr0CFd8E7jrUwRLnUF0uljQ/Zs61eU+LTyNCEcYvNxKF9aTZvOC
         IoLp4pXW0IVDeJ3PGF/s+54X8uf1RZ6ATd9jtNn4qNZ4BQl7wzvTLEG+K7Pf7qqrYbmp
         IZVDStcvmolzaA8Fr7xWJS33zhjeWf7gUFzA7FIlEKmkkHiEb/RfwU1m7CEpH/OddU/h
         Ri+jxemLGmJTfFoutQMs7OoAQH4pK/1ELWfo90CUwCQd85ggu2BvTAA4jtOKeSCQYXKm
         h8bd8Eng7Lur5IKjVk8dwSbJKus3wiUMbmP/gxmfIApdMVtCYzUPKy9F90uwdAOeNHPz
         UQ9g==
X-Forwarded-Encrypted: i=1; AHgh+RoUskw+glNX0zVYBIcTWCzVK7AbEYTf8SshoCS32qEfahxmc/KWfaFzHLUWDpwvdN3JhzAWP0y6cr+w@vger.kernel.org
X-Gm-Message-State: AOJu0YzGKHATQj+Y5UozFaVevv9NSu5wuh6REpEgv8nf54e9I/6UIIim
	cc/kSos8/XztnxKSDZqNZHVou854k8zCJKhwdSJ7v/v45aZcpgEx939bawYwyhV0fA==
X-Gm-Gg: AfdE7cmTEof4fYTBUMX2iPnCvbuGoEyDDIdoSD7XfFdbenF8y/+9htxKg1sXOtIoj9w
	JzW+saW6dv3ZXwS9QjjH3rnl99C3zUGUjOcED8nMyC6MWN8TX7HH5bnK6t5XUWd0oZtLy8cpgMV
	WnDSamn4P2fBBPpwPg1T0AUBiS7o8igq22MuKfoM9ac0evIgjX/5GfDcXLjGomLqpz3yRtXzVyi
	4FPOl8wNMsL9cMu2aAqIeLgjFkSYuY8WscHfmkPL8t5mxq+XpM0ArUu0qcPJfC1/lY4NmTXwinT
	86WDJEBAFg63ag/43s9TryorTO0cPEe98RYBFZ/l9x8wgmfjdn0lm3QSTmiWxh5RgCSIGj6Oqp8
	QoNrdg9BstRVgQLb5BmjEq1ztTIqNSa0DCzrwSIcbAos6qVbpYSWxypsClQFMr9vWw5C5AHzf
X-Received: by 2002:a05:600c:4e94:b0:495:571e:e5d3 with SMTP id 5b1f17b1804b1-495571ee75fmr38781525e9.36.1784472255879;
        Sun, 19 Jul 2026 07:44:15 -0700 (PDT)
Received: from mf-00-01.. ([194.220.239.180])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49549c9c940sm190238905e9.13.2026.07.19.07.44.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 07:44:15 -0700 (PDT)
From: Mykola Marzhan <mykola@meshstor.io>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] md/md-llbitmap: mask sb->state on load to drop runtime-only bits
Date: Sun, 19 Jul 2026 14:44:07 +0000
Message-ID: <20260719144409.940492-3-mykola@meshstor.io>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260719144409.940492-1-mykola@meshstor.io>
References: <20260719144409.940492-1-mykola@meshstor.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

llbitmap_read_sb() copies sb->state straight into llbitmap->flags
with no mask, so any bit set in the on-disk state field becomes a
runtime flag.  With BITMAP_WRITE_ERROR (bit 2) on disk,
llbitmap_enabled() returns false for the array's entire lifetime:
llbitmap_update_sb() early-returns, the state machine returns
BitNone, the bits attribute reports "bitmap io error", and on-disk
sb->events stops advancing.  The bitmap is silently disabled with no
log line attributing the cause, and the next clean reassemble forces
a full resync because sb->events is stale.

Runtime bits do reach disk: llbitmap_update_sb() writes the raw
flags word, so BITMAP_DAEMON_BUSY is persisted whenever a superblock
update coincides with a daemon-period overrun -- the condition that
logs "daemon_work not finished".  WRITE_ERROR itself has no
reachable write-side path today (its only setter is update_sb's own
read-failure branch, which returns before writing), but on-disk
corruption or an external write plants it all the same.

Mask the loaded state to the bits this loader consumes (STALE,
FIRST_USE and CLEAN), as the previous patch did for the classic
loader.  Masking at load neutralises whatever is on disk and is the
minimal backportable fix; masking the write side is left as a
follow-up cleanup.

Reproducer: write 0x04 into byte offset 48 (the state field) of the
llbitmap superblock on every member (a forge on a single member can
be masked by another member's clean copy), then assemble.  Without this
fix the bits attribute reports "bitmap io error" and sb->events is
frozen; with it the bitmap is alive and sb->events advances
normally.

Fixes: 5ab829f1971d ("md/md-llbitmap: introduce new lockless bitmap")
Cc: stable@vger.kernel.org # v6.18+
Assisted-by: Claude-Code:claude-opus-4-8
Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
---
 drivers/md/md-llbitmap.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index e8f853e8461d..0b591124dc63 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -981,7 +981,15 @@ static int llbitmap_read_sb(struct llbitmap *llbitmap)
 		else
 			mddev->bitmap_info.space = mddev->bitmap_info.default_space;
 	}
-	llbitmap->flags = le32_to_cpu(sb->state);
+	/*
+	 * Mask the loaded state to the bits this loader consumes.
+	 * WRITE_ERROR and DAEMON_BUSY are kernel-runtime signals; a stray
+	 * WRITE_ERROR trusted from disk silently disables the bitmap for
+	 * the array's entire lifetime.
+	 */
+	llbitmap->flags = le32_to_cpu(sb->state) &
+			  (BIT(BITMAP_STALE) | BIT(BITMAP_FIRST_USE) |
+			   BIT(BITMAP_CLEAN));
 	if (test_and_clear_bit(BITMAP_FIRST_USE, &llbitmap->flags)) {
 		ret = llbitmap_init(llbitmap);
 		goto out_put_page;
-- 
2.43.0

