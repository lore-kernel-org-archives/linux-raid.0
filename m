Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A7A379EE5
	for <linux-raid@vger.kernel.org>; Thu, 23 Apr 2026 10:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776939203; cv=none; b=BUH81847EopiT/WuXkX+W8PyuBeRBHXxFo2caqd6l+HioC+Td25rSIWIvqHPC0kP5wG66FMV6e990ND667U+bFosSaUnORcJnGK8OBwOYiN52qNgXc7yMTj8TBiR+ETuk2M/pdEx+N+UQRY9MILw0UQoMicSxA7iqeMW3viTo78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776939203; c=relaxed/simple;
	bh=8vuJqA+wQY8gPAJFGpKU+DviQFeQdG3649uVMQidGFg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PwytbSIR9OnpsahFNnP9qRR0ei/fPe8rse/ESLnjpR6xxpPdPWN/vRMx953dEs0jVndiQItka1+Ld0X2tDDSRcvpq5r33pWN7USqkOKnw21KkXBqbVZOkZv51YMcV2y7FkyMg2i13n6irwELMafIYLXAgmYgqB1dmNyzZ+jIfeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ELyJMo3e; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ELyJMo3e"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-43d73352cf2so5296320f8f.1
        for <linux-raid@vger.kernel.org>; Thu, 23 Apr 2026 03:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776939201; x=1777544001; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BHMChXGL41Zs9J680EOZXTI6jrPVcLgk4r3n2pJfr0w=;
        b=ELyJMo3eChGJmZA2IeRx1a7d5LE1mLOOw7UVqJZAHWIALtNwA1BIVHbzSZBYCf6AL/
         VRhb3b3LpGDLrR8ElzPe9NlF/1yMXLTADdwMKGlXS652TUD7elDp+Sn2cw2hwQGdZ6rU
         JbDU5uVo/GsIbACMYNDsdjWR14bFBfw/Bxiw/X1yZUndKQEoDNLXQGLiz7iFySjw4MTe
         2RUPRow4IQy/yjvXInAxuzS3tY42L5uAVoGddUoFPyeltWPwQx9kSWnjqOfeaklKbnUN
         xG+gU6ess1bMDP/ZCKJGAEV59ArPE1fKsUH71Zv2HbFZsra94PyCFkXWQEa0f3cqEchy
         yRKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776939201; x=1777544001;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BHMChXGL41Zs9J680EOZXTI6jrPVcLgk4r3n2pJfr0w=;
        b=nR1OwMSu0ruIGVCHLYzbefFC4me16XX/ASGzWeNW60ANL88Q38zbwebFld9DF7+8xa
         mfGm18Fw8f88QWbYrfPTlFZ+rvVmSJbPS6v44TfPMmLwTEu6PjfVuO4l8XOacSs4D2oF
         DCoT7n2rT892TGl6iTOvUV9JTrhcBT4tIU59RNo0+76nxyhNJ1BiKrzhu1dTrhCCmcto
         rTB7XjAiZZp6ydHg635VadAb86H28PM9BC8ue5DlMVvOArh6yOo0xTG+fVAcMy79BN+u
         sbB1Sn3EUBncThpJbeenooKeV/HewHE0egQ60a5yFc2lDEyBMzkvBoXiLUvLymNh2b+Q
         zLeQ==
X-Gm-Message-State: AOJu0Ywsnjmbb/sq/6Kloc72rlwLRkeNtrFvaSxErCdh6j1XPCNkhGMh
	iLtUl8uWKkQ4Van5o4oYbJ3aza9Y3skwtOYYITSBeBDOIZK/GouX2taUDNbonA==
X-Gm-Gg: AeBDietF/hMJ7fnvcwtTQGkrZD4bdDVbW4YLrVZrSrKPNUB2CTD8WIVKm5ZAJq6IznF
	J0sb/yb1g60GiZbrhwemOlF8IMYWjZIYsKn6hmVMpfl1I6Xb+seteQNQxdlk3le3BDf6xD3YD4/
	rrxl4ykShErcjeIEl2eUjWNrIeqkj+OCQrWSTGkfYU+FpUSBfuKpSgH7EQa5fni1SBPs4wV3Q+D
	4MaCvL14JFeG7XFWPUMkqPghPo58kz62BWPcKkQQt4nFKpaN9BimN2pdCU1vJerW4y7ilc3fP8n
	5WzQ1vSQ+A+a+HPMRIVeQSViZrFlLfPKUNONB1FfZIZTY7BiPAQ/ZcXOzqCpBoCABsWPH8oYsdT
	c0zYwqV4s/8WmtL0qHaz72iHRuu4C8YV9IHRlLkHFCw8As2Jbg9TkpYWas4SV3BKLg6fftif8fq
	vVbGGhxXJkEhllW4zt92rVhth0ZBGtkmibuQ==
X-Received: by 2002:a05:6000:26ca:b0:43d:7883:87b9 with SMTP id ffacd0b85a97d-43fe3dc7b56mr40476966f8f.16.1776939200712;
        Thu, 23 Apr 2026 03:13:20 -0700 (PDT)
Received: from yocto.. ([2a02:3037:60e:ee7d:34af:34c4:890b:2c47])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4e4d525sm49741217f8f.31.2026.04.23.03.13.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 03:13:20 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Subject: [PATCH 0/3] md/raid1: small cleanups in MD and raid1 drivers
Date: Thu, 23 Apr 2026 12:13:00 +0200
Message-ID: <20260423101303.48196-1-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This small series contains three cleanups in the MD and raid1 drivers.

Thanks,
Abd-Alrhman

Abd-Alrhman Masalkhi (3):
  md/raid1: replace wait loop with wait_event_idle() in
    raid1_write_request()
  md: use mddev_is_dm() instead of open-coding gendisk checks
  md: use ATTRIBUTE_GROUPS() for md default sysfs attributes

 drivers/md/md.c    | 16 ++++------------
 drivers/md/raid1.c | 15 ++++-----------
 2 files changed, 8 insertions(+), 23 deletions(-)

-- 
2.43.0

