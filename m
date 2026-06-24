Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CECCA3DCD9C
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 15:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782316516; cv=none; b=Yg4EtjCGm3FeHsZ11s/lGmYf0hdQIjNf2diQPGSn1ItxTS0VCA/0TsfiMCcyGu/QZb8FCQjOTBcssZis/ydznWnZdbmjSv8hmh1HWqDg2p/JSEvhUxFTWFBqLnGXUi9MbHQ5BilSURq7QdBvdBr/OnY8brTcDmhG0Fjc4wuXwbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782316516; c=relaxed/simple;
	bh=fTbvAcdPu9oKGOuZl5GY4U7vpG19hlB1FxZiKAxrquY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uZmAbnh1eR7eTA8Y7mQ2MF85wmVx1S/toFS6MJqfeKd+8WAkmZiedzcP5BMHdqvNaknyCSbqBHLvXTTJZDNvYE2a9qJuk6VPojTX7NQyWGGqireSjchZBzFkn4HeoZHPAnWzdjPnrlnZn/9OjZg4UiZL3mG3D9A/V/DXbAEjxWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FmG+9Mrn; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FmG+9Mrn"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-845a3c05e40so734514b3a.1
        for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 08:55:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782316514; x=1782921314; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aQ4ervtZLhPJ+AcULEQ5AgjuAZ3gAYw4IKMltoPVIZA=;
        b=FmG+9Mrn9zqotwl22i7vWRekkH8/CYVN/4dtNMMAFaOpUUu8oJR8V42rj7cVAU3bjO
         RxnglkASTy0tp8084yI9b85ZbXoUoHtyNEakgv+UNUbtUWA3k+1kvEx/4VLCN3+j9QQ/
         c5acBZPxDLJj/40lSI9JcmidwdnRBMyzxBUcZVX3liAyzPLnkk9X9MFJuLyoG1cxQPF+
         pE4dw6RybLHN6jz8UG2T6q2EN4cBH+8r+SEpGCAREeJ6NS+178K0gKyQA5CtnX5yt0YQ
         JBF1tkIFlMvzY9rCLUF8O/RRAdORSV6KUMOm5uM1498jWN/fnYtAv3bhA+HnyiI5S2A2
         aKxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782316514; x=1782921314;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aQ4ervtZLhPJ+AcULEQ5AgjuAZ3gAYw4IKMltoPVIZA=;
        b=C61ipsclk2opCIsvDGVRrJjb9zIzQ51ZcwM0KSA6t7pCVJl+CtG7LlkVWtmB6Ki36T
         E35x0yKucRUS2V+DcqT9eNfsdEpoNv+3NV7hQlfdQ0w4IlBy4Kre5WluVW/yNEXI+KJX
         Cim78UhnYGoCB2d7o3MrXZ0Zyhh1/MjOqx7rgzN7xXbLK6AHRsVUX+gzBNlizJwDys8B
         YxjfLXJ1qHol5/G7NGdw9h1b15vYm+gy4YrF7FYceb4ClqiD6THDH88aal10Xfu1cD7L
         /1ZwB2XAYIHdp5/ikGPbnAVSQ4Pni9566FOQ49ZPHYTfw0S6GjbpjBTY/2YXe5GjC5Rz
         Yo8Q==
X-Forwarded-Encrypted: i=1; AHgh+RruXLpbi8ggYBZNbPxkEtRyXj1pIAxiUx1ioEVdwgguxvrZr0GCBVJKnPbcc16RerIwYpnQP3Mbjny3@vger.kernel.org
X-Gm-Message-State: AOJu0YwSEilLICenDT0sg3flGTEOk7UWDZHlFRb8qkGWuml475p01zS2
	t1r1pqyT1eEUavowAs1mU97q/vjKBjpeIHHUocX4SHoah8fRI55h1+ud
X-Gm-Gg: AfdE7clNYL95qMVu7mpfpABUH5iL5ICrJTGIENMWytp/2LewyQl91enShT7a7KuGKcJ
	31yk02EZYl9CaoUrhOPdaJdpbcjI4Ta6v8wUwNNJJA1KWLe5xrEgzvaVMDS/q0L2e288qxWLLKQ
	KzlgPj/YXMUrYhH3om94Uxs1rv5ZCdVAXCxQWbwfFnUXDa3fRAz4+MeiDN2/9yHIh8ncaYkghvO
	z9fL6rDRCVzx6f4jAq0Ltyt1+PgAiUAIOl5zQHcysedckct6YjWv4QSxOIVos7Uq6zqdZkVOKSj
	9jBam82gE4WsNMDZujfdmqZ258B+SCUwSYiqHFMPCXzgtF+41NWFt3aO6HG5068yKVlAbVlRN3N
	XdJ7LZ+Lypmno1Rp0ptfJ4Xr+LLil/pwPqmE+NDol+sI84GI35vqA4myoM8UqA1hbHSon08dhws
	FJJ0YmO7fuwa9D3fUTfhN0lVMpV2G4fkqXPDJmpct+fCzk7cbE+mP/Yh2vUFAlbWpD4cuWOvjaS
	46qvuSvR3uML+YGTg==
X-Received: by 2002:a05:6a00:2e26:b0:845:2ff5:b66d with SMTP id d2e1a72fcca58-845a2c58858mr5208817b3a.35.1782316514156;
        Wed, 24 Jun 2026 08:55:14 -0700 (PDT)
Received: from research02.. ([2601:1c1:8700:f5b:fe34:97ff:fea3:c147])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-845a40f55cesm2658387b3a.44.2026.06.24.08.55.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 08:55:13 -0700 (PDT)
From: Hiroshi Nishida <nishidafmly@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hiroshi Nishida <nishidafmly@gmail.com>
Subject: [PATCH 7/8] md/raid5: raise MAX_STRIPE_BATCH from 8 to 32
Date: Wed, 24 Jun 2026 08:54:51 -0700
Message-ID: <20260624155452.211646-8-nishidafmly@gmail.com>
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

handle_active_stripes() dequeues up to MAX_STRIPE_BATCH stripes under
device_lock per pass, then processes them after dropping the lock.
Raising the batch from 8 to 32 amortizes each device_lock acquisition
over more stripes, reducing lock cycles per unit of stripe work.

The worker-spawn heuristic in raid5_wakeup_stripe_thread() also divided
by MAX_STRIPE_BATCH; split it into a separate STRIPE_BATCH_WORKERS=8 so
the spawn sensitivity is preserved unchanged while the batch size grows.

Assisted-by: Claude:claude-opus-4-8 [Claude Code]
Signed-off-by: Hiroshi Nishida <nishidafmly@gmail.com>
---
 drivers/md/raid5.c | 2 +-
 drivers/md/raid5.h | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index c8787ab7b309..ad6230415af3 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -210,7 +210,7 @@ static void raid5_wakeup_stripe_thread(struct stripe_head *sh)
 	/* at least one worker should run to avoid race */
 	queue_work_on(sh->cpu, raid5_wq, &group->workers[0].work);
 
-	thread_cnt = group->stripes_cnt / MAX_STRIPE_BATCH - 1;
+	thread_cnt = group->stripes_cnt / STRIPE_BATCH_WORKERS - 1;
 	/* wakeup more workers */
 	for (i = 1; i < conf->worker_cnt_per_group && thread_cnt > 0; i++) {
 		if (group->workers[i].working == false) {
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 7aeba1fc7f09..1f37dabd727b 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -496,7 +496,8 @@ struct disk_info {
 #define BYPASS_THRESHOLD	1
 #define NR_HASH			(PAGE_SIZE / sizeof(struct hlist_head))
 #define HASH_MASK		(NR_HASH - 1)
-#define MAX_STRIPE_BATCH	8
+#define MAX_STRIPE_BATCH	32	/* stripes per handle_active_stripes pass */
+#define STRIPE_BATCH_WORKERS	8	/* stripes-per-worker threshold for spawning */
 #define RAID5_SYNC_WINDOW	32	/* stripes to pre-submit per sync_request call */
 
 /* NR_STRIPE_HASH_LOCKS must be a power of two, since
-- 
2.43.0

