Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A271E570
	for <linux-raid@vger.kernel.org>; Tue,  7 May 2024 17:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715103149; cv=none; b=HNmTVp+J4JSzFWZLVLaJP1HamFb0Fp2GpwNigrgVe6+8OR/wGcOTFGPrpUDv9dDYc/jLw/LG1sccj0sSqf7muO5V8PNTcpNCSY2zb3AAxk/bihk6TN+Yv8WfLxFMK8/mpxoA8Q9fYEvWyEs0HXujsJ7vHgrcnAxof1V6qDIU2Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715103149; c=relaxed/simple;
	bh=LpMr2+YH3qOBaK9yUDr8tTAZ59QiKpk7W11WY3uKRnM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AFqLu0NWjJaGLP/ufl0R7pXJwZkvHc71nykQdmaAGsa13bYC0IHyyW9iR50KDcvzk3hvAy4pwdXwaebqdJa2CIMj6mP43vLOWJseiNlpwLmcYrphACfsEMzIHutAvg+17riGvz6ZyT8SpKBCGdk2B25UTxz2T4HjvkqnPMNfuw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gt3zroGX; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gt3zroGX"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-51f0f6b613dso4232797e87.1
        for <linux-raid@vger.kernel.org>; Tue, 07 May 2024 10:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715103146; x=1715707946; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=p5Z2YUzk3yicanS0pTLHEd79RxQTtRXondf0RogHLCI=;
        b=gt3zroGXtgBfoPmc8K6qzqA86MptAY6dapNPnPPZEuB4/0twWMvTDduYeGQC8Kp9OS
         tov5XpE/ooEFniqeYatjr5eGcN6Md2GqsP+vPopHldzizrkrGw8NEMDTH/C7ePphGEPb
         92oES/ButPjSS52BmWTWp2Qa2ac8qJ4ZU1GDGWqnMlL1KABSBPRS+7Qu8KyBGUZ7BkEZ
         IYxNmjzBxrZ+zYRVevLDIDmguoBUyi8Jz2iRhLxlDKTo1e4b4fjKOzuNzCk9XI9i3Wiq
         LHe8VpJa9Bzvo6243mZjgDQdrAEIvG03G0RtAZG28DxDG27UrV2Qn4jXKksiAXL8sk+m
         Va6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715103146; x=1715707946;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p5Z2YUzk3yicanS0pTLHEd79RxQTtRXondf0RogHLCI=;
        b=X46pRBnexU0nciv10dwqFAgRzMyJF7gVXslcsnXIJSW5XWxq1hSBVhm0ekRgbDf9ie
         b8Ov/cEzOMBLLLpFF6HVI6+k7dEZnr5UCEHv3bG1q9V8WazI+cG6Oav56qV2trohFpp+
         O94a9V3hqKWoFog2f4qmAiEbVX0oaFeJHwnGWahJw1ezRbDcydkj5fvkUbEBSXL3Tr4x
         7kaOE28f0V6X1V28Dh/n40nyAv80fgKzIjeWNj/QQIZ7b4+oInK/DnjVoJ02s2yO51sI
         g0hTv+18MHlTmNjSaIFjE3tmLYRQ+eBoa1RigLJAmXFLnBZcUGAnCKPpiVdp7m8OhAH8
         91EA==
X-Gm-Message-State: AOJu0YxTXZnGonA9Kl+Hh/LyYL8haAy7+0P8imsfL9BSCI/e2PAQzHcQ
	BTnc3G/z8utWke132QV4mGRGvagxivda/XCu7p3e6C7EltLx+QuXNNyYBA==
X-Google-Smtp-Source: AGHT+IGPu1KUyktAHKBiw7+kDrx0ByMfb7S8GjGIBZ7VuvdTD61pytuJyni/JFGKFo5FHLsWjmk9pg==
X-Received: by 2002:a19:ca4d:0:b0:521:6e82:888b with SMTP id 2adb3069b0e04-5217ce46a93mr97231e87.60.1715103145751;
        Tue, 07 May 2024 10:32:25 -0700 (PDT)
Received: from kali.home (lfbn-ren-1-785-215.w83-197.abo.wanadoo.fr. [83.197.112.215])
        by smtp.gmail.com with ESMTPSA id p9-20020a05600c1d8900b0041563096e15sm24327285wms.5.2024.05.07.10.32.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 May 2024 10:32:24 -0700 (PDT)
From: Fabrice Fontaine <fontaine.fabrice@gmail.com>
To: linux-raid@vger.kernel.org
Cc: Jes Sorensen <jes@trained-monkey.org>,
	Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
	Fabrice Fontaine <fontaine.fabrice@gmail.com>
Subject: [PATCH v2] Makefile: Move -pie to LDFLAGS
Date: Tue,  7 May 2024 19:32:16 +0200
Message-ID: <20240507173216.275378-1-fontaine.fabrice@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move -pie from LDLIBS to LDFLAGS and make LDFLAGS configurable to allow
the user to drop it by setting their own LDFLAGS (e.g. PIE could be
enabled or disabled by the buildsystem such as buildroot).

Suggested-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Signed-off-by: Fabrice Fontaine <fontaine.fabrice@gmail.com>
---
 Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 7c221a89..adac7905 100644
--- a/Makefile
+++ b/Makefile
@@ -132,12 +132,12 @@ CFLAGS += -DUSE_PTHREADS
 MON_LDFLAGS += -pthread
 endif
 
-LDFLAGS = -Wl,-z,now,-z,noexecstack
+LDFLAGS ?= -pie -Wl,-z,now,-z,noexecstack
 
 # If you want a static binary, you might uncomment these
 # LDFLAGS += -static
 # STRIP = -s
-LDLIBS = -ldl -pie
+LDLIBS = -ldl
 
 # To explicitly disable libudev, set -DNO_LIBUDEV in CXFLAGS
 ifeq (, $(findstring -DNO_LIBUDEV,  $(CXFLAGS)))
-- 
2.43.0

