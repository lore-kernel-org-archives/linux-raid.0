Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603D61AAE0C
	for <linux-raid@vger.kernel.org>; Thu,  3 Oct 2024 17:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727977481; cv=none; b=kI4kz+z9DVbMYNzZ/Z3BJ7KPBexeS0Jl4fSHMkqTG74rv5feuYY4Z/b3kijYTuFH5z0M6UtDIKW8ckoBV+JJve3hSUzYBiWrYK6U7T+X6vzSSLyMLG8ZaET/CMX8uAH5Ew+WtFNnaVqbWKwR1KhM2vfYPcmNZQVT7lI71BW/7sI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727977481; c=relaxed/simple;
	bh=EaqRCs1dd7joch8FZ5Z52L4pbBVbuc/zBY271+1y/nY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dvl6NbKDlDXhrqcMxEpt7H9KLOkuFMIMfAogTTyweMrginjJQLqb8NFh4Wweu26zmT6bO4VSdCbEgDwxljqs3ihdms2NRELnuLCeSE85K4rBKa+PcpIc18Q14DFKMBWHTdA2iEyrsitPnZSq+WeG+y+TMOTvyFGanwoIkmmwJ5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FPUoOd+o; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FPUoOd+o"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-20b7463dd89so13767245ad.2
        for <linux-raid@vger.kernel.org>; Thu, 03 Oct 2024 10:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727977479; x=1728582279; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rlxYyPe+MuMy/ak513PQjZl4mwqkrYgkdfFTiuXqdDY=;
        b=FPUoOd+oPpuiX4uwb6sKVDlWCIz8bXMmymkF7V3JoVv+XYwN+QUsvt8AKHFhwiaKbR
         YWvhTAptW09IlqIZ73ED8T7yDlNCYW7uxscxtJf6rw/h4JT28KaQ04RQASSeGe6zJomx
         VMAjp602m4f9xv96ntb6zSA8XLHvSgoIYppAzybk0asP5YVD3qfQJsQzMIFxKzPBH2YY
         XFT9Fn2PkNslThQYw0H0uSNkOCSObmJCNItZfh6X94HOjJxIfbOyUGOTOxEKG5+d89nW
         +Pz6GYdxQf/NBm9yw5fuyUUgAnXKgrEbzncw7LGb0kf4m4ZbW5juLNxvsRBW02YAxHPW
         ALeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727977479; x=1728582279;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rlxYyPe+MuMy/ak513PQjZl4mwqkrYgkdfFTiuXqdDY=;
        b=fKGGUn8daBsWAYMdPi7md84UdlL5KZ9EUwfXu/4NfoHweiU3LCxLncTj8eERluVv9S
         LNKWAymszY/assi6TQ/gMJiaHl5qtaIS9pWzeitzU8omQ5OPTL8XzInCxqU3LEtVWTXR
         PHwwhMCiiHbPNzH9HtDhk3JZ8tmM0HaNAwaaa4QFtgrsXMvRwOXcnFRK4KmxZCTgiIZR
         TU15dk1z7oMW5FdWqFlDITixOIwinRTMKQJJ7OaAQiif9OHGcICzXlQrQOOC1v6Bw3tK
         bwLMbur8qbSzQTHTo7h/e9ks4wZPkrReLWFEuiZuHN0RytTYtpqT3IbrDUAW1Ym72SdQ
         31Vw==
X-Gm-Message-State: AOJu0Yz0vf5pHPsVYrpTVtampAVWp50ewmF9IVH287SSifRuQRhaika2
	RsswP7T6ZohG2zZcgcMB2FCBrKB32z8yg50sGJIwuOUFhYCHY3d7OpDjEw==
X-Google-Smtp-Source: AGHT+IExOXFztzQ5t/K8Cs0TONX41w5HTpX/NaXUfAMpFCAzdJKNIQsbe0Tvj35EN9PNuR1A+Y+Lhg==
X-Received: by 2002:a17:903:2291:b0:20b:b610:bd06 with SMTP id d9443c01a7336-20bfdfd323fmr68065ad.19.1727977479506;
        Thu, 03 Oct 2024 10:44:39 -0700 (PDT)
Received: from localhost.localdomain ([2600:8800:1600:140::ec])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20beefafbfesm11356595ad.216.2024.10.03.10.44.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2024 10:44:38 -0700 (PDT)
From: Paul Luse <paulluselinux@gmail.com>
To: linux-raid@vger.kernel.org
Cc: paul.e.luse@intel.com,
	Paul Luse <paulluselinux@gmail.com>
Subject: [PATCH] md: another CI test
Date: Thu,  3 Oct 2024 10:44:35 -0700
Message-ID: <20241003174435.6226-1-paulluselinux@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Testing auto email

Signed-off-by: Paul Luse <paulluselinux@gmail.com>
---
 drivers/md/raid1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 34e26834ad28..678d9f5c2fbb 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -56,7 +56,7 @@ static int check_and_add_wb(struct md_rdev *rdev, sector_t lo, sector_t hi)
 	unsigned long flags;
 	int ret = 0;
 	struct mddev *mddev = rdev->mddev;
-
+	XXX
 	wi = mempool_alloc(mddev->wb_info_pool, GFP_NOIO);
 
 	spin_lock_irqsave(&rdev->wb_list_lock, flags);
-- 
2.46.0

