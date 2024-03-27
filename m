Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 209B786AEA
	for <linux-raid@vger.kernel.org>; Wed, 27 Mar 2024 11:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711539628; cv=none; b=LNsM0DQQUMG6o32i6Tnmp0Qmv9F+tkBtnBN6XZ3e3G6Oy04KUrLWWijpD/zCkpBVb73jPEb4aQkSRBhEWHseMB5ipXjpi9fdqcX57i3YODbtq4ybh3Y/hTBGdK3dPdRH6BiFeAuGZApWSedXNoMUBZpWYpA7vJa7cTHLiJctLdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711539628; c=relaxed/simple;
	bh=2ng1iXq6IIy0pUNvtIRId/tg3OT7PB/1bUxGI6WXfXc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=W/T57+lVIg1kU0493+4gnCUL68S8nMzupf2t9iJx+9A725It4VuB8CnwXuSxehj1X+WUgcbnq1zUR9wuBNdcrvuVE1wtXyhb/bq2OWfmCIsGrQ2sYWxRRfaaqCAXXtNBa48CiG3PWiocB5P23du5rFP7w/VOqvhGFALPT7Yl+bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=Wlb7R7vv; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="Wlb7R7vv"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-56bf6591865so6370978a12.0
        for <linux-raid@vger.kernel.org>; Wed, 27 Mar 2024 04:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1711539624; x=1712144424; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TfODvxuCyT45uN8Zj6JihqzUtwI5jLmjo4zPKfHDW5g=;
        b=Wlb7R7vvd1VbzgccS5uV8l2MinGcf75DxDRzZtU3vOz01/NL3P9psDe45saxVxKOX7
         ZRiME2Tcko2IWZyA1pqdf/wqpjjbRuIt+kWOTn8B2c+085dkLx5/Rherc130HnjsGMDG
         unGOMq9POsZKaKuDmhUKRBlchdA2ymMne1sG9TN3IVSt2Uc5CU6HPM8lYOPPXIAGKeYC
         VW/QXn695EfZOhkIFtPn34rcYFmWYX7E4swWab7H716AeorXqVgOZEfw1IhO4rweial9
         xF3jzxD0JhxpJz3Z8LbamJrvW+X4r5mEmx15BFWcuP+7bOGRlrff/3yioxqMGN/IPjP2
         /4lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711539624; x=1712144424;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TfODvxuCyT45uN8Zj6JihqzUtwI5jLmjo4zPKfHDW5g=;
        b=dcmXcPj3voakZi+SL8inDXa02V21GK0udx/WIhB0Fi0rI7l3bxD9xOwJMJ7Fhekn4a
         RDAOKRNr2tZCF97s6IQO3q4TKe1RzKNmU1qPrL1VCnKvRrccqisquGWBCz5xkVpM9trO
         GmBJESBMXYDc+i9g78qFLolLWFJuPtI4kk7Mwdnh6gCDKrBAvyG438NmAb3C5tST7OA6
         X4nX83BGRAcNFsAEsCLCuVN92jND6iodxALGUR9rxsWASw5TGn59Qk9VRgiVeXM0wcU2
         U7XmfWqsxug8kNGU5uGr64ln3VaOOtshpQTxjtsPL3FIXLn2ggRsCOQbgAu/JtN1/V53
         szJw==
X-Gm-Message-State: AOJu0Yxa1qWPEdkTCIUvacYJ7VteNchvSZ6C+n+WmTqFkSfGgZdL8b48
	igtukyhnXekxBtap15NJgb9KE7yjhHopA9buzBRb70fhIV/sAypwzWFEfEKymMqFFtPLj8zz/iE
	7
X-Google-Smtp-Source: AGHT+IFb///FFUgjI+xFJwXKYn92s7vN2Qz0hd9Haz4hduYIyuHBQQQEI0gFuaO7vhFHcYM1yhiiig==
X-Received: by 2002:a50:ab42:0:b0:56b:d9b0:f1c3 with SMTP id t2-20020a50ab42000000b0056bd9b0f1c3mr3114627edc.39.1711539623702;
        Wed, 27 Mar 2024 04:40:23 -0700 (PDT)
Received: from lb02065.fkb.profitbricks.net ([2001:9e8:1403:3200:c01d:bbf5:2fca:edf5])
        by smtp.gmail.com with ESMTPSA id n6-20020a05640204c600b0056b8dcdaca5sm1342254edw.73.2024.03.27.04.40.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 04:40:23 -0700 (PDT)
From: Jack Wang <jinpu.wang@ionos.com>
To: linux-raid@vger.kernel.org,
	song@kernel.org
Cc: Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>,
	Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH] md: add check for sleepers in md_wakeup_thread()
Date: Wed, 27 Mar 2024 12:40:22 +0100
Message-Id: <20240327114022.74634-1-jinpu.wang@ionos.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>

Check for sleeping thread before attempting its wake_up in
md_wakeup_thread() to avoid unnecessary spinlock contention.

With a 6.1 kernel, fio random read/write tests on many (>= 100)
virtual volumes, of 100 GiB each, on 3 md-raid5s on 8 SSDs each
(building a raid50), show by 3 to 4 % improved IOPS performance.

Signed-off-by: Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/md/md.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7d7b982e369c..44253faa2633 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8083,7 +8083,8 @@ void md_wakeup_thread(struct md_thread __rcu *thread)
 	if (t) {
 		pr_debug("md: waking up MD thread %s.\n", t->tsk->comm);
 		set_bit(THREAD_WAKEUP, &t->flags);
-		wake_up(&t->wqueue);
+		if (wq_has_sleeper(&t->wqueue))
+			wake_up(&t->wqueue);
 	}
 	rcu_read_unlock();
 }
-- 
2.34.1

