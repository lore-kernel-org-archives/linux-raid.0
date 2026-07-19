Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79E81305688
	for <linux-raid@vger.kernel.org>; Sun, 19 Jul 2026 14:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784472173; cv=none; b=WH1ilAmbR1Sxn5M1fh1T1jMXrHUogM1/x+9oIJsVKfq5hgyUja0SIzdrVdb+PrVUIYwfrhbnLOUvSvZZ98iKGny6l1AV9AcZRzQos9ILcM/Cex2uho6EK6wOrHZghezTCaskWFIGvHdk3x1XbxPC9pmPemhaf/VuAK0YLJgQmUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784472173; c=relaxed/simple;
	bh=Bk71AvQGQHwUw59EDZ3761+DgNEr6QYowbdMEYI9BA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KvszjvpLUKML188mX2pImRstKs3dBI4glHsiAfBC9c8VsvUECtD4UPwy7BSBUVA3gJIFBtLuIqVGFr8PBicaheAonU5nm8Vbry7Peqbh7VkW+Alp7AHDJuPbCPY8HHoVQidgfAmS2n2Vf7OkkBDGWz6Nymhu9R/jB3mFLnubRzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=JPxDAXCs; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="JPxDAXCs"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-47ddf7b09e5so5459426f8f.1
        for <linux-raid@vger.kernel.org>; Sun, 19 Jul 2026 07:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784472170; x=1785076970; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3K8n6jI6tFj+NJRJQMh98XTSOTl584f3VQxcTV8N3dk=;
        b=JPxDAXCsjVH1IEAw2GO/vPduyHzbzgKaqVizp5BQccG29VT0kFPm9yguSDj8KcvHdP
         Z2N2X2KWfbsTFpgZcwFiWOBdBG8lNIHGU02AU65wsDpkU+PbP4MflAEoJ7bDt19C4Wj1
         e0B6SeC6yMnbmFCLaNVYwUK2AvfhpalwaikBEQpdpw3PrRi27etI7LMsHI1hJx9cjwxD
         AyWvpLR1Nzf0bzjMyoBZbVHZ+y4n/GGkO3XxXbWIPLhODhzrmr7LfcPGkguNSdhG27oW
         uNHkw/mXYacb1mxlWRLSwfSGh5wsxzJ/4gghqExvxeoAYoUv0ivrZgvEpC38jayDpV9i
         onaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784472170; x=1785076970;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3K8n6jI6tFj+NJRJQMh98XTSOTl584f3VQxcTV8N3dk=;
        b=fuNsv12gOrWrsJeQ5ywl594lUJH1Egz1uqU8XXx14/QEOfaKVKF1BULyTxHif8vZJ3
         VSYx7uJGMFKnxYP4T+HRzF0LqPUWnEw4GkQhE2ruoH8Vpp/RUV3S7Mrubz3JUkKVs80s
         64eDkr0P3cGinPFyMTAUHS6hOoia3zec7xEfcOBMLvONI56R3SoR4dwKQASUb5nVOq3J
         D3HhTo0LoWCzs8bNtgvrSj8R0cy7YRH5kqqyDQrMMnHQWHE9f+CNeBLC0nVEgqocv5e4
         buNB1ehpyouptk06fj6WzUJfs8Jucu/pQJ1uXVyIdHgjNMAs8GSlUNPzySs3zrijMTH6
         /yTQ==
X-Forwarded-Encrypted: i=1; AHgh+RpUSQbgyCSD+r1Bdwx7UnjjciQ1TFxE7Q6CtLroB5MrTOBa+al/PBBYaqX0HfWljBijmFvDjsF5G+nW@vger.kernel.org
X-Gm-Message-State: AOJu0YzDC3MIqMCfQHFc0b/BQc/8DaGrUfuMp3Fd+YZy5QhsSlCwhw0c
	dtC/01T0adMB1gXyyT06lm+yisnt60EhdRdUk/+Nj9tT/u+hCMEFjuLS8/xlEbbe9g==
X-Gm-Gg: AfdE7ckG5N2aUIzpQKOFYEx3ADRkTY4ofPYVelKYjXgA3mCnyRKYancF+ogCeafTQQr
	aPskwPRcG99GT3F7OoFzfNvyjLV5msb5JinXI440WxRkPbUAVmtRebLh5pEnJ6VEmwOAwzVVPLy
	mc7gSV+BmPUxRSKJ6A1Yp3hoPsdfSQnfvg7jT/gSyC8zzr9ODJ5EDdaI9q0KdzGeGFGZuFQWKad
	a8wkqTsl8m74jHw8FqOxzIPP5tiphhop/vIR0YbYLkm3adyV8ieWFlKkP1D940DWwPYYEGr2JWZ
	aUn6OrE0W9WsXDzo2U2aOCuHrk3eY90Ha4fAG31WFWK1c6ZjQZnjDz/iNZUOdfsJP4Q0w8TZMqe
	RZYHNtEUshdkPZpFcOtkWBX1hlc3Vf0mxAf3lwbK8mYAgYisRX0icos2cTri+RQ==
X-Received: by 2002:a05:6000:4b0e:b0:473:6e8d:7f3 with SMTP id ffacd0b85a97d-47f622f1c09mr11670359f8f.1.1784472169232;
        Sun, 19 Jul 2026 07:42:49 -0700 (PDT)
Received: from mf-00-01.. ([194.220.239.180])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f63ec7c69sm22668895f8f.17.2026.07.19.07.42.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 07:42:48 -0700 (PDT)
From: Mykola Marzhan <mykola@meshstor.io>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] md/raid10: restore still_degraded detection in recovery
Date: Sun, 19 Jul 2026 14:42:25 +0000
Message-ID: <20260719144227.940444-2-mykola@meshstor.io>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260719144227.940444-1-mykola@meshstor.io>
References: <20260719144227.940444-1-mykola@meshstor.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

raid10_sync_request()'s recovery arm passes still_degraded -- "will
the array still be degraded after this recovery completes?" -- to
md_bitmap_start_sync(), whose !degraded branch consumes the chunk's
NEEDED marker, the write-intent record.  That is only safe when the
recovery restores full redundancy; otherwise the record still
describes writes an absent member missed.

Commit fe6a19d40ceb ("md/md-bitmap: merge md_bitmap_start_sync()
into bitmap_operations") turned the detection loop's only assignment
from "still_degraded = 1" into "still_degraded = false" in its
int-to-bool styling pass, so the flag has been constant false ever
since.  raid1 and raid5 were converted to "= true"; only raid10 was
inverted.

The result is silent data loss on a classic-bitmap raid10 that stays
degraded across a recovery.  With mirror pairs {A,B} and {C,D}: lose
D, keep writing, lose B, add a spare.  The rebuild into B's slot
strips NEEDED from every chunk -- including chunks whose only
unsatisfied intent belonged to D -- so a later --re-add of D sees an
empty intent record, completes instantly, and serves stale data.

Restore the pre-conversion assignment.  Only the classic-bitmap
recovery arm is affected: llbitmap ignores the degraded parameter,
and the resync arm passes mddev->degraded directly.

Fixes: fe6a19d40ceb ("md/md-bitmap: merge md_bitmap_start_sync() into bitmap_operations")
Cc: stable@vger.kernel.org # v6.12+
Assisted-by: Claude-Code:claude-opus-4-8
Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
---
 drivers/md/raid10.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 0a3cfdd3f5df..54cddb3a98cd 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3365,7 +3365,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 				struct md_rdev *rdev = conf->mirrors[j].rdev;
 
 				if (rdev == NULL || test_bit(Faulty, &rdev->flags)) {
-					still_degraded = false;
+					still_degraded = true;
 					break;
 				}
 			}
-- 
2.43.0

