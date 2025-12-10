Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E41FB314B6E
	for <linux-raid@vger.kernel.org>; Wed, 10 Dec 2025 07:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765352492; cv=none; b=IwGMPpSVfcV4FSibQwd890OarHNsR3SDhfakkXJAlBlpFv1pfHSYXAzZfYMGCWueupwL8IizGFmWg6Pa+WIJbk5wIIp2bYpzdWCZ1hOTGd8fvic9mb4hUTZGJCdkGgZKeFYMt90rN+DJJ11f5JF9kJ9MKUGY1icXPRHwl0KLSC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765352492; c=relaxed/simple;
	bh=gcYKGGaL3bQd/mTyqLrZBDoFVExL8l1spySWCuVvxt0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cv4/ZyrWtVouiNc6PBCR3+lyMU7G83ZWzzz1KDcUvDIdHg2I/SQHD+P9y4Qa547pT5sf70wx6E1FBrLcf9BczyvCVMttsiEwEbg7wQ0DF9lobzk6vuoJxBVy4ZI4DUj87syacxjalVAsv1KEoX5lhIir3hJb6SQ7FyZj3t3CuO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RkwGdG1z; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RkwGdG1z"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-29ba9249e9dso91560155ad.3
        for <linux-raid@vger.kernel.org>; Tue, 09 Dec 2025 23:41:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765352489; x=1765957289; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3TQmxsf9G+YMhuwv+FWTTjsL73y6Stiw6q0tecOgyXo=;
        b=RkwGdG1zzlT4hfJ40TmxNZ9TeYu4ja0nfQ+ZKm6mXsfdZa6zG8I2dmAqI4b3NB9xy3
         8KRSuB5G+hkXlOYc/3UnLe0+kzAoRvCX1QsJii+yktjEpN8B3xbTWUYQLP2KM0Q20ote
         hPp/o2O+wwo1wHI0nvipFw4rQoI22dZ3zJnfMvMXjZzjPOmroQg1AgQngCULPh4oUX0p
         h6vfnPpF24gIp6/Wl994K/aBIx9WrKAnIjFKqCA3h1pIehyCpOgaDE6zhl9POJF9CoV/
         AHOYTVPaKdkUTBZsR5mAi3R3E28DZKuUaCTtkJMuoQmpTzLW3D/aU91WPZX5HY2iW+BV
         Xyfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765352489; x=1765957289;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3TQmxsf9G+YMhuwv+FWTTjsL73y6Stiw6q0tecOgyXo=;
        b=tBorA5vEqB3j/kfszrz/VG1NU2BoxVIQe/ULEM01lm2gKPKeZ3cw9gx+bsv0TToSwT
         yF+4b6LvC+e1LECoXXInoEqeyBViH9G/JkdPCUNJMQFrvAOFaRemj2NvhJ9AKztLAlqj
         wGrv2cmlkF24JsBypyfbzucf2QvuZSzR55oQNKRFgezkS9VIPcIjgIUxykJMcBoR2lOV
         3qINtgX2tex6Gg660q5cbnUecxNCkVqFcw4TKXeBjwTw16eNrpNpIO9RoCNF1UW5LUoh
         PJTM76r4YZbSi5Xo/DKLN9AA8g3lGoEU8SQ5uLLF7p4Z+Q2vGPBqpm+tFDWmgP4sISF8
         DNZQ==
X-Gm-Message-State: AOJu0Yzn29nQhKLR2ZuzsUMw8wL3sY7BA2g5bFHnRH2TfGXXFPy7tz8B
	oJV55Zth82MHDMJBiBflLvZ/vOeThYyZZh6qw3cVstIU2T5MYS7ANdNa
X-Gm-Gg: AY/fxX59qBTDAOAFSzreajMQd2rzcKJxp/UmWjhc+dS6gO01xRF+uVBFA5tkw/A45sl
	ujtN5keZki/TsiRqYjLUmt4/qy0tAlPshPhMSSXw6ybkirqUCMILki6OUFZWf3AQ78cyjLVlFF8
	9WnmBzUorj5JFIchjgNMhWXPq+QZpn/NEPOWGzJAmlDh84QYF8pc52jDmULAtCcDQb9XwAWtgaE
	KI/fm2mnc7lkFdsp2VZKwAjTPTQjBnEeWfUclNB3LOXQXyafiEQiTNwIqNwbxfp31xAolkqp7tO
	jOKUxOQW8spHnTE29f13zdemcA5c7a1Jf5c5UOvAeXQHNvRerXfS+aZM0Rk0HxAP9MxLAnCTLk9
	pPjsD8U5YgnVbqayw8wgXt7xRGfGe6mOPWC7T8lgbuoZoDNpUC2Zdxz0i5HICh4ldJ9PCfl69iB
	Ce
X-Google-Smtp-Source: AGHT+IFxoNa/kbVgmQ8bIAJTFjLnWfetMeLDxdyF64r2nlzCxLtkPArhBm01tiXm3RFYygw5LhE6Hw==
X-Received: by 2002:a17:902:ccc9:b0:29e:3823:a70 with SMTP id d9443c01a7336-29ec27bae62mr15958785ad.42.1765352488718;
        Tue, 09 Dec 2025 23:41:28 -0800 (PST)
Received: from oslab.. ([2402:f000:4:1006:809:ffff:fffe:18ea])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29dae4a13d2sm173364705ad.9.2025.12.09.23.41.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 23:41:28 -0800 (PST)
From: Tuo Li <islituo@gmail.com>
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tuo Li <islituo@gmail.com>
Subject: [PATCH] md/raid5: fix possible null-pointer dereferences in raid5_store_group_thread_cnt()
Date: Wed, 10 Dec 2025 15:41:12 +0800
Message-ID: <20251210074112.3975053-1-islituo@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The variable mddev->private is first assigned to conf and then checked:

  conf = mddev->private;
  if (!conf) ...

If conf is NULL, then mddev->private is also NULL. However, the function
does not return at this point, and raid5_quiesce() is later called with
mddev as the argument. Inside raid5_quiesce(), mddev->private is again
assigned to conf, which is then dereferenced in multiple places, for
example:

  conf->quiesce = 0;
  wake_up(&conf->wait_for_quiescent);
  ...

This can lead to several null-pointer dereferences.

To fix these issues, the function should unlock mddev and return early when
conf is NULL, following the pattern in raid5_change_consistency_policy().

Signed-off-by: Tuo Li <islituo@gmail.com>
---
 drivers/md/raid5.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index e57ce3295292..be3f9a127212 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7190,9 +7190,10 @@ raid5_store_group_thread_cnt(struct mddev *mddev, const char *page, size_t len)
 	raid5_quiesce(mddev, true);
 
 	conf = mddev->private;
-	if (!conf)
-		err = -ENODEV;
-	else if (new != conf->worker_cnt_per_group) {
+	if (!conf) {
+		mddev_unlock_and_resume(mddev);
+		return -ENODEV;
+	} else if (new != conf->worker_cnt_per_group) {
 		old_groups = conf->worker_groups;
 		if (old_groups)
 			flush_workqueue(raid5_wq);
-- 
2.43.0

