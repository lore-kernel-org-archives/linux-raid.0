Received: from mail-ed2-f34.google.com (mail-ed2-f34.google.com [74.125.228.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778F240F72B
	for <linux-raid@vger.kernel.org>; Thu, 24 Sep 2026 16:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790267204; cv=none; b=pwR6vCcs8czVJ2dEq8yU0Gjjo6Ri/f8/rVwOz8rGsjgynyBGsvlM131HwOPYHgaIqvC53DUNC6YDZdCEEvo0oNyOY+MtoAHIbMsZHrc6+u7Oa4wxJy0GvSdTtL6iDcWOqrtEixz8hXhIyLXvbdG9nvagRSRVF8sKY9Gr2qU6nLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790267204; c=relaxed/simple;
	bh=0hae1Dy1qPgAAn48he+OQyElqT4viRMRexAgzDHsvDg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YWsE759+6NMyaddhnqmb01JIbuG7TdtWFvCunSn+H9dd5he7cRJIs5QaTQvDFP5nuN6GM//l7HBUOEVlvkBgS8Mi+2iAciDr49geofauOtOO08PCgJKO/g4jO7VrW40nEFv5f6dwFWTXf/I7hGzzBwrpk01PW4osqsw04ygYw/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lUNpWuLt; arc=none smtp.client-ip=74.125.228.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lUNpWuLt"
Received: by mail-ed2-f34.google.com with SMTP id 4fb4d7f45d1cf-6aae359e2c0so41861a12.3
        for <linux-raid@vger.kernel.org>; Thu, 24 Sep 2026 09:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790267201; x=1790872001; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xceFEZdQPKnCO9ajfrPlU5eXhjLvd87vwHrqSGkOcL8=;
        b=lUNpWuLtg2h7Je+6HVFTFtJDgGMYRP1OtbqME9c28nBuJBOjzbIqWGwZsOmKkOO9iK
         ttwsNCu6L0lVC8IoNV95zPQyHZ9gZi+rT294W5TWQ2xcSho/eKfMb4tPMfwaTV4DY2D4
         QHAWrdOGIbjSEwA3Mq3hWKK2q/S+60iHk8ebInNqfhX1aaqgHOH1KOs8wISEz9tc8gel
         6u2m8NQdfNx/tpdNfN66plk0/RBCW0ltOpc2WTkEusbjLfPCvZg9tUysfemDO68dcrIJ
         cT69yydVc49z0DZwf8OSpEOjMiFpr3q8yWyyZ1c9c0zCQBGmj/DGpKoLTzAWpZwz4A99
         yYCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790267201; x=1790872001;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xceFEZdQPKnCO9ajfrPlU5eXhjLvd87vwHrqSGkOcL8=;
        b=hFy5F7rSL0JPprTRZIwYswXbTivw1ssjKXFPuQ48hymoD9Xk+hKWSkWfG4huxrbHMv
         mYqggcHMhENxFZuEadzrL8QGe4D6EW/IxGhaT7cL4PoDa6rok0yWdYJYQ2NbjKbLWEfZ
         Rd3R5m3IlDwRiZAERVuES8AKQYzpKOWiwF4jWfyAp1UDIqtkF8yyO8bExch/mSeMdu8C
         S4zIb+ZOOugIBuddF7rBeV6wnuwQG67sx1by2SkAL851y4xCfgX6E7LEwC8UHFAG00xP
         EEjflkI2omu9mxxC1I29jAY28XWbW9fqyEcULZJeyyHr5Efhvbtmoh21tfXkOSE34jn8
         fVcg==
X-Forwarded-Encrypted: i=1; AKwUvBzQ/3oKdlQYA4dMtE4gI/haK7fxAq8yi821/zj/FgKX3G2EJSzBccz6YjDUZy7hF8g1j19E4z9NYfeE@vger.kernel.org
X-Gm-Message-State: AFuF++kfvcH5oJBZ2RJ5U1krOXqiIiHuFSJJu1rkCU6jlAwpcnuHrhDk
	cEeifEBvnMK4sGxxzjNtpRhsiY9bhK+3o75uKaRltaxQFmmyTZ4zsZyO
X-Gm-Gg: AYBFou2NqyvdCAiWguYRNqzUwtbak877l1UvOnDSA2WC6cD8Ugmk2sQLwO3Gsyy1S1T
	utgbGQ3pr7mjDqpv/nT9V5TbUS+PwGThmNOaWsgN2YhE6b6K7tII3c2S6HdRSrlSlJ2TOjVPFXq
	v4juIs1E4bJmiiPvoYNvOee52U9JNTyIR5sbs/zSVqdUlbhi+3UKWXK2igW/3etSg2K93WVO0gM
	XaT+wXib2ycaGZ0xYYcgyFE6B55qx/xD20M9UNhgjSBrbdTwxdHI7P9orfUlTERnd5mgHb5DYWv
	1Ge1yfmWu85PqIJcxs0IKrIgdMVULew8SVbwA2kL1afZIe161DPGVuoZOb+rCxcEtdclA62S+v2
	dMVfsGKwctMPsX5DhUB581kEm0roYIjzjMI/L0gbgU5nUmp8Q42R1NtltNlNCqKqoTJYW4vx4Jb
	Y0TOOLZjKnLKKoyJxkKz9D0ExrLR6VCbBcvnBrtJwnGwYh8KD0BcT3GgyooXVphBE6e+jac1Zth
	NZNGa0fd6Ds8QtA
X-Received: by 2002:a05:6402:518d:b0:6aa:b226:e69a with SMTP id 4fb4d7f45d1cf-6aac9106dfbmr2938246a12.36.1790267200508;
        Thu, 24 Sep 2026 09:26:40 -0700 (PDT)
Received: from localhost.localdomain ([94.240.182.136])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6aab386e7c8sm3932223a12.5.2026.09.24.09.26.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 09:26:40 -0700 (PDT)
From: Svyatoslav Nikolenko <nsvatoslav515@gmail.com>
To: song@kernel.org,
	yukuai@fygo.io
Cc: magiclinan@didiglobal.com,
	xiao@kernel.org,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Svyatoslav Nikolenko <nsvatoslav515@gmail.com>,
	syzbot+75d7e96ad03ac2dbbd9f@syzkaller.appspotmail.com
Subject: [PATCH] md/raid5-ppl: check for NULL ppl_conf in ppl_write_stripe_run()
Date: Thu, 24 Sep 2026 19:26:10 +0300
Message-ID: <20260924162610.10056-1-nsvatoslav515@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Syzbot reported a general protection fault
due to a NULL pointer dereference in ppl_write_stripe_run().

When a RAID 5 array operates without Partial Parity Log (PPL) enabled or
before its initialization, conf->log_private remains NULL.
ppl_write_stripe_run() assigns ppl_conf = conf->log_private and
immediately attempts to access ppl_conf->count in the loop header.
This triggers a NULL pointer dereference.

Fix this by returning early
from ppl_write_stripe_run() if ppl_conf is NULL.

Tested-by: syzbot+75d7e96ad03ac2dbbd9f@syzkaller.appspotmail.com
Reported-by: syzbot+75d7e96ad03ac2dbbd9f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=75d7e96ad03ac2dbbd9f
Fixes: 3418d036c81d ("raid5-ppl: Partial Parity Log write logging implementation")
Signed-off-by: Svyatoslav Nikolenko <nsvatoslav515@gmail.com>
---
 drivers/md/raid5-ppl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
index 7f8a9d3fd578..e54ed4e44b0f 100644
--- a/drivers/md/raid5-ppl.c
+++ b/drivers/md/raid5-ppl.c
@@ -535,6 +535,9 @@ void ppl_write_stripe_run(struct r5conf *conf)
 	struct ppl_log *log;
 	int i;
 
+	if (!ppl_conf)
+		return;
+
 	for (i = 0; i < ppl_conf->count; i++) {
 		log = &ppl_conf->child_logs[i];
 
-- 
2.47.3

