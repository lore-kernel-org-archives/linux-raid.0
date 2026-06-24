Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F1C43DBD74
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 15:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782316512; cv=none; b=UWpgHSlZq25fO1Sb40VR1s1NAw6t7jTF0M00hPH1FyAmuqUHOa4axffXkpHrvg9+ufaYu8IWTXEuO023vuL0TGlY7GxqJYj7Gnh6bA3FdR2ysJHcy5b7zqWsN5elbA7ZZikc8VsLNMK406B2Mk5HwKSbbmOLXxeqivLMRask2Ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782316512; c=relaxed/simple;
	bh=Dzy0IoQlIyGAFNK5afExtcTtJOLw+uEl9h4DwaR/O0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QOncsGy3MldxcOi1cCmu4JUwf1qIjZzlAA9C5QNQiXUEAtOp8LSfsuPMEWPPvdYMqBqNnEfTAWS/UJ2F/n/d750zEaZjfdF1lLnWAqtZiotwPtH0K0w8L7LQz+Id0Y87S2PFnHtNREkbioHi8lcV0uVVn3INTt6ZKDmadf8UK/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bTPxXeWN; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bTPxXeWN"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-845369f60faso1001225b3a.3
        for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 08:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782316511; x=1782921311; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T3Vs0T5e7mY2+mqGN7mTSC6YjD5wSRzVPb5tvSf7gxU=;
        b=bTPxXeWNZiJ+bcexWT6Sz3LqZMe2EQ44Mt+8dysLonmzRWAqkKWp4wViCnPwkEB/QP
         lZKMEKA5wFNEl0LzBsluGyM2n75kF+mqUkcSpoxYNs52snaO2vZ220M9GGXMnlJ2JHbJ
         Mz3gjBCf7CVyM96HkeaioisCPbBbIcgrDVT7GQ9PhNF85ZGfWRQi77zNYIxipjKIzelG
         +WCFrHucAK946bzqZ+Yi9Jfw4fpv0sGIZqZPXZHpL781GYuvkrI2JE17RIfIevJpPCHz
         Np0T+aSg01G7h4CY2bCCsZAvQ8UisMdI61mFT71Salvc3uushfYOxjErfce5sMHfNnfX
         RNiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782316511; x=1782921311;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=T3Vs0T5e7mY2+mqGN7mTSC6YjD5wSRzVPb5tvSf7gxU=;
        b=r2BxAZsH43kTVKTh9U8JUXQ4yHJppu8fSNonwr3vS/3ivrq2NdW8HWXvUvoImeAthb
         pvRmPqg2Hd7pi81dXrBdjNI2Uw4KblGYhkpgJgpOfVE/vboesL5/ihRbtfTMtu+30V2i
         xlXWWTv/EuPdZbBMYtu+CgCeAZJLsod/5uMWaZXbyMHkk7dsM0PsAO1Jib7+p0g77mmk
         Oyk0mCLmslrBLxzGU0qdn3Uv3yPX1U7Dktn679Nz3plgkZ5lt5rLJiWY67RprS3m0tDp
         YQ4XfH3OGGMH3WM99lFhoV0iserPEPtfPRasIc7HuOSQbs7x7WjrOKGcO3Q+g8ofWGw1
         Olbw==
X-Forwarded-Encrypted: i=1; AFNElJ/oTlliLZcOFYVaKOCqjIwAGZjKJsaybJHyZDM/Y24yufKoNxjPr8t5GY0BpKq6YdSIs91pO8mxFdHF@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9iHowHqSDWGpam9pvkVzAWwm0UR2e9vZh0r1+24ATQizLBn/d
	PhpC4aaKNi2Mo5UBJDzwR6qsAfCsBbbiL0iJN7GFSvBGuNaqbrTFbVl+
X-Gm-Gg: AfdE7clWTKe634zacqOO9iOQI51Ljyc+Q2FZE/uN6yA1z7dotZUj4EmmzBplNuPBK22
	bDzq/6HanFE6mmwcTYh7Z08Z79q/O13r+7SauY0U100mLNKSqdISbxZ9/sibe2oJGPdcWGYljYI
	e6AjGDTQq+qi+cslgSXoflR+pQXt2hQU2Lsp/75PGZChcr+/EsffcSPTjv0rABhI8BTiSNO2Af4
	q80NRWAGokYRsuJNXYD80d9sYWsRKAjixL5O/6pmJxIvLbytMH+scdrQ3Fvpfv+GKC2e1rQjx5W
	555OeQnAhTlo6er1ZKcbORgst1lqqziWM8gucPPIOSnbskTbBtgZObhK7GOcaWL5j52xjmTChTW
	+0cHzhmRbUu9vanFrICdWLYynIsbWnFl/EKqs34OoezYOQ/ibFSy/4PlGKlB9Yp+FXag08zhPqq
	pC6zw3qGrWWir921tO++IwYggyU5alO3OT3MBxZmE+Spx843Save7F33GgyYNy4ZTL1AwQC/AB5
	K/nxBk=
X-Received: by 2002:a05:6a00:218f:b0:845:4970:df37 with SMTP id d2e1a72fcca58-845a27d6b2bmr4948474b3a.0.1782316510775;
        Wed, 24 Jun 2026 08:55:10 -0700 (PDT)
Received: from research02.. ([2601:1c1:8700:f5b:fe34:97ff:fea3:c147])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-845a40f55cesm2658387b3a.44.2026.06.24.08.55.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 08:55:10 -0700 (PDT)
From: Hiroshi Nishida <nishidafmly@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hiroshi Nishida <nishidafmly@gmail.com>
Subject: [PATCH 4/8] md/raid5: raise NR_STRIPE_HASH_LOCKS from 8 to 32
Date: Wed, 24 Jun 2026 08:54:48 -0700
Message-ID: <20260624155452.211646-5-nishidafmly@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260624155452.211646-1-nishidafmly@gmail.com>
References: <20260624155452.211646-1-nishidafmly@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The stripe cache hash is striped across NR_STRIPE_HASH_LOCKS spinlocks
(see stripe_hash_locks_hash()).  The value has been 8 since the per-hash
locking was introduced, which is small for modern many-core servers:
with only 8 buckets, stripe cache lookup and allocation contend on the
same few locks once the CPU count greatly exceeds the bucket count.

Raise it to 32.  Two constraints bound the choice:

  - STRIPE_HASH_LOCKS_MASK is (NR_STRIPE_HASH_LOCKS - 1) and is used as
    a bitmask in stripe_hash_locks_hash(), so the value must be a power
    of two.

  - raid5_quiesce() acquires every hash lock plus device_lock at once
    via lock_all_device_hash_locks_irq().  That holds
    NR_STRIPE_HASH_LOCKS + 1 locks simultaneously, which must stay below
    MAX_LOCK_DEPTH (48) so the held-lock array does not overflow when
    lockdep is enabled.

32 is the largest power of two that satisfies both: 32 + 1 leaves
headroom under 48, whereas 64 would exceed it.  (The pre-existing
"must remain below 64" comment understates this; MAX_LOCK_DEPTH is the
real ceiling.)  STRIPE_HASH_LOCKS_MASK and all NR_STRIPE_HASH_LOCKS-
sized arrays scale automatically.

This is purely a lock-striping change; it does not affect stripe cache
correctness.  The benefit appears on many-core systems, while on small
systems the extra buckets are harmless.

Tested: loop-device RAID-5 create, write/verify, fail a disk, rebuild
onto a spare and scrub all complete cleanly.

Assisted-by: Claude:claude-opus-4-8 [Claude Code]
Signed-off-by: Hiroshi Nishida <nishidafmly@gmail.com>
---
 drivers/md/raid5.h | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 57349737d393..3efab71ebef7 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -498,12 +498,14 @@ struct disk_info {
 #define HASH_MASK		(NR_HASH - 1)
 #define MAX_STRIPE_BATCH	8
 
-/* NOTE NR_STRIPE_HASH_LOCKS must remain below 64.
- * This is because we sometimes take all the spinlocks
- * and creating that much locking depth can cause
- * problems.
+/* NR_STRIPE_HASH_LOCKS must be a power of two, since
+ * STRIPE_HASH_LOCKS_MASK masks with (NR_STRIPE_HASH_LOCKS - 1).
+ * It must also be small enough that taking all of them at once in
+ * lock_all_device_hash_locks_irq(), plus device_lock, keeps the held
+ * lock count below MAX_LOCK_DEPTH (48) with lockdep enabled.  32 is the
+ * largest power of two that satisfies both constraints.
  */
-#define NR_STRIPE_HASH_LOCKS 8
+#define NR_STRIPE_HASH_LOCKS 32
 #define STRIPE_HASH_LOCKS_MASK (NR_STRIPE_HASH_LOCKS - 1)
 
 struct r5worker {
-- 
2.43.0

