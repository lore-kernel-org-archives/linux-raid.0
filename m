Received: from mail-lf2-f13.google.com (mail-lf2-f13.google.com [74.125.229.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE12754CF65
	for <linux-raid@vger.kernel.org>; Tue, 22 Sep 2026 12:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790081904; cv=none; b=Hg/vCEI/gZ5fyHcLGz/rRPDvDIhEJJYV1MVMNkZSfJMRz4d0++ZkC8jfCOQgGu+iHILC0Nrxnl1EIxCDzSBIDp7fkovEEcB9IKFFZWq1NMp4zdm1+0uMZn4N5RdjHk6Byi9TFkuHTOpINXgeM211TeOMojOUGchqULnFRNtoILA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790081904; c=relaxed/simple;
	bh=qwxY7Xchr2weO6MXwf7UPPLqsaoih4agFYYO7kP73Iw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SBc9wpqIdEdu5r41DR/F2XtKv5Cjpq3l008aktBZeNivDomqvLih6Y03Br8+JeQKuOw1ufSU5NTqOJDohQUrifWwuQ3R3sJ8Cp0H7GG2VYVfhy9uPqkDcyhHiH6ItZiDtZVscNmQs7akeV3eRy8os0bYRxWjLwAYe7eqD8Y2B7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jmCs24ww; arc=none smtp.client-ip=74.125.229.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jmCs24ww"
Received: by mail-lf2-f13.google.com with SMTP id 2adb3069b0e04-5b5e4f13d77so4645515e87.0
        for <linux-raid@vger.kernel.org>; Tue, 22 Sep 2026 05:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790081899; x=1790686699; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jRRmEx1q2mbxQzld4Wdzku5SEkqIbjlSMQKlnOePUlY=;
        b=jmCs24wwSNln/YG73fZm1DtWW1LNWj6r/PjJl6inoAgsE7SkEQxu03wjTKB32SpIsT
         OnPbyCNtfIWP/fU+U7eRYhjEJV0Uew3zyUeWt8uvqDkch0mfKAvHwQGRRin0VbsSeq+t
         uWTtnVEY817YGqQnIPhEmtbgkY3BMZXZc4LkD6FtINW8qOPZ09+qSPRu8aD/NDIs51cO
         RydkkyY2Cil5yFikNS4aj0Mjtfq3kjJpMOO3wH+3nkbM/FvoZkH4cBOF4ZZ0BR3/iHat
         im4B2/9etdnFxmQLkMvh1/VFQV01zyyeZvSw0t5WUuQaRT5dKt4HUSon/IXWs/urpoYu
         wnyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790081899; x=1790686699;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jRRmEx1q2mbxQzld4Wdzku5SEkqIbjlSMQKlnOePUlY=;
        b=lLtlEjkXZkclkqt68Mlvu3LkjHS92tfUynbAflw0Z5+W7q62d+TnaSuGLfM80XiU1s
         5DHkfwxm3+Lpgg2xH4Xfap5Q7t23O28FSF21ulhjepjwCmK+UhBtMBSaGbhGRDiDrmmR
         fhYQNf5bu+KbORxBNouSsgl8coLc+AJWA04HCMWVslwamQaZjIDjL+mEbUwbYwAkaF2w
         15T8Qdtniq22dS2Iiy7tQ7Bmm2C5HhakOjdPKIc7DVLCxedl3iqI6wHhUR579W438WUO
         HOt640iMiImOc3936BQMZ6dRGC7AOSaOlilrtcfxkdCKOv0FZNoCoimYiGzVj9GHobnQ
         nLug==
X-Forwarded-Encrypted: i=1; AKwUvBwUuWhCWdbRIfTjsfeOVb/Whzncs+2kP6EyWXSuBPnmPILhjgLAUMFhhXazqqTiyUP2dD9St6Dpkjkm@vger.kernel.org
X-Gm-Message-State: AFuF++kk7idz1x9c/zRWwFqmF/Pwf5rSo/VBin0xEZZNuv6hPNYndPry
	UeUkNWETGVRB/fAc8XyrZBFS15oxjcfkaAblF5UrvjlOxoE4ORraOP+V
X-Gm-Gg: AYBFou3yzUVZajcCR+fm297Bp4v86NSyakr0ARdgmSZDMQnVTBH+TbxIx04M03gKZ9C
	0zdKYd6iUu/yuSYp4q63pcV03NTR99Lg/wxNOdMeei1+8Bm9hum/UJJ5wpDGwmcsTN3CjBhE0PE
	YkfJFriQnDyHeDsKYiHq4ihU/ms42tOYFbS4L2tGTIXRFPN9jIcBLI9GKKjfYeuMFcIsV03HwN3
	ktbvn+MJ0W+4lcLWzClAw/jsDN5/9jXKiU7gjk64W+GEGkkFiFwkcMoufg2QbMyW+2AXi3HOGMn
	31iDUn8UwhhXsUHRUCbymkENwl2BeQGcSK/mylSC1fFPbwGx6UhXVDeGJvFrw0Pr0ga/ESeNl4B
	s2DqBaALQoKIhra4q7+M5z3eyL/a/b2/j8gKyBSgiU3ySdveLrhpJnUJpmQjxeRGqVZVi+BMZvo
	l9WSi3lhYOcZlIGGj0jyHMU9A++VSaGHVBa0YSAl9t3OEh1iY8MHYxRbzJO59veQP3O0Za4STnn
	CLvswzNJz7uelkt
X-Received: by 2002:a05:6512:3d1b:b0:5b5:fae5:b241 with SMTP id 2adb3069b0e04-5b8c17f5da4mr4001423e87.14.1790081899220;
        Tue, 22 Sep 2026 05:58:19 -0700 (PDT)
Received: from localhost.localdomain ([94.240.182.136])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b8d46ed384sm461753e87.75.2026.09.22.05.58.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 05:58:18 -0700 (PDT)
From: Svyatoslav Nikolenko <nsvatoslav515@gmail.com>
To: song@kernel.org,
	yukuai@fygo.io
Cc: magiclinan@didiglobal.com,
	xiao@kernel.org,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Svyatoslav Nikolenko <nsvatoslav515@gmail.com>,
	syzbot+270624bb31d478afe62e@syzkaller.appspotmail.com
Subject: [PATCH] md/raid5: fix NULL pointer dereference in raid5_has_ppl
Date: Tue, 22 Sep 2026 15:54:17 +0300
Message-ID: <20260922125418.2715-1-nsvatoslav515@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Check if conf->mddev is non-NULL in raid5_has_ppl() before testing flags to
prevent a KASAN null-ptr-deref during free_conf() cleanup paths.

Reported-by: syzbot+270624bb31d478afe62e@syzkaller.appspotmail.com
Tested-by: syzbot+270624bb31d478afe62e@syzkaller.appspotmail.com
Signed-off-by: Svyatoslav Nikolenko <nsvatoslav515@gmail.com>
---
 drivers/md/raid5-log.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid5-log.h b/drivers/md/raid5-log.h
index c8332502669e..5a144051b142 100644
--- a/drivers/md/raid5-log.h
+++ b/drivers/md/raid5-log.h
@@ -51,7 +51,7 @@ static inline bool raid5_has_log(struct r5conf *conf)
 
 static inline bool raid5_has_ppl(struct r5conf *conf)
 {
-	return test_bit(MD_HAS_PPL, &conf->mddev->flags);
+	return conf->mddev && test_bit(MD_HAS_PPL, &conf->mddev->flags);
 }
 
 static inline int log_stripe(struct stripe_head *sh, struct stripe_head_state *s)
-- 
2.47.3

