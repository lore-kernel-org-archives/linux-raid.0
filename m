Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4590313C91C
	for <linux-raid@vger.kernel.org>; Mon, 25 Mar 2024 06:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711347343; cv=none; b=e59E13ErvYrZaUK/bB9s3OlshgqVZE4jfL6xDfZAC0TXyuDuoeJGRcHY9xRMc54d1O6oWEAe1jBDOooyeyBlxkfZI2m/ZBP8y6W715TH3qBuuHKzPw6vJLJ99bW2nfUwYlMs/4W5kHc0+Sa/jLn2NGG6vJOCX6s+zTRqUsuQXLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711347343; c=relaxed/simple;
	bh=3bJflTRn1LZxq7/CQ1Z1yivtoYXX0yiQ6hB515kVntk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=b9d6AvabA800WSIlNLqicI9Zgg8vdLuK9HNIILc6L3oy8Cg4MqASVwFCoq6y5u3l0dwtMCqoTTpcC3wLZE60dCWCdqzu1ohY8U83da/FVZjeCP3OtYEyWYfe4Pig9hbeQ5b2yvqCBstBiup4s08Dc3cuHTmwPoeX2JWCVs2r5Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fxdZ+2R0; arc=none smtp.client-ip=209.85.128.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fxdZ+2R0"
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-60a057b6601so40120157b3.2
        for <linux-raid@vger.kernel.org>; Sun, 24 Mar 2024 23:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711347341; x=1711952141; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=51a3Kpe2dM0z9N9M83bN9ND20XKZolP0Jc2wsTJT4Bw=;
        b=fxdZ+2R0KBJsZX3J69M4KT+0ckSVIoPWk/KxgmIzJYZRQiVVzwp+tgRMavna2gz/Xc
         ZawTVxrZMJsGnei9rJ1PsSuBVu4F41Oz/RnFrRWsxxEV28DbekyxNsYKMuQ3M1wnxe7D
         hP7zza7eq9IqCYpBhMR9eLan9imecgsiSvpniu7O+jMGhdE+0BpujbvbT8MhemcrbNiJ
         +uPPHtt/ZHpbQU5ybvMt+bnX00jz8aTSLoaguSSERR9YQMYtak98MHKcdwFNWUD0Wh1G
         dgHR/Pl1T4oYo6N2HwfUJ4qnWevwyagLleMykEZDoob6/7/mcV3i06tz5/QiEi28J1Jx
         8Khg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711347341; x=1711952141;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=51a3Kpe2dM0z9N9M83bN9ND20XKZolP0Jc2wsTJT4Bw=;
        b=mrihx4MXDjShwGWuhSIqvaFt/wkW/oIigB5d4/hxZUyR1HWTtDKWbKBU9T1HtaaXQP
         YC3wjW+najZRSWHWp6GaIooHlw0ZAGcFd7EMi/yK63i8UTybSJLnh3lHm7v31ADOaaoe
         Fu75EMXoolqG1KV3Rm4ozEqLrm8sWT/HtpNJRRQBDa9JrRfS4Hhp1sTU7A7PD/UIWdEw
         7lnQ4wcV9gRjtP55tEKSJKxOUwtfgAnByQVdxC6QRA1ye2eEr4uQeJNKhjvbsFus2S2W
         0u6VwHALygRTt8jV7oqDly4as6EdjTgi7diur0rbIha5tQfKEiF7BzSudu5HdHzspTSL
         Fwug==
X-Gm-Message-State: AOJu0YxjPpWm/AE1j2K5Cx/wc6524DBQ3/kKL7pd1TRFndG2q8TdSzEl
	Guctu5meM0KHoFXh+W1+a8EDMjJjo91pU8eDkTaRVOUIX0ydAxIyBoCirBzQ
X-Google-Smtp-Source: AGHT+IHqPwytuJhlY9oYB5VtpcCZuNxjklS2qjaZYhNX9CQ8WDXAJzWIyD0eFhpwsWoOTjhbcUV5PQ==
X-Received: by 2002:a81:9c42:0:b0:609:fd5f:bcf4 with SMTP id n2-20020a819c42000000b00609fd5fbcf4mr4601793ywa.24.1711347340839;
        Sun, 24 Mar 2024 23:15:40 -0700 (PDT)
Received: from apollo.hsd1.ca.comcast.net ([2601:646:9d80:4380::5eba])
        by smtp.gmail.com with ESMTPSA id f18-20020a056a001ad200b006eaacc1a3a3sm961928pfv.128.2024.03.24.23.15.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Mar 2024 23:15:40 -0700 (PDT)
From: Khem Raj <raj.khem@gmail.com>
To: linux-raid@vger.kernel.org
Cc: Khem Raj <raj.khem@gmail.com>
Subject: [PATCH] include libgen.h for basename API
Date: Sun, 24 Mar 2024 23:15:37 -0700
Message-ID: <20240325061537.275811-1-raj.khem@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Musl does no more provide it via string.h therefore builds with newer
compilers e.g. clang-18 fails due to missing prototype for basename
therefore add libgen.h to included headers list

Signed-off-by: Khem Raj <raj.khem@gmail.com>
---
 Monitor.c        | 1 +
 platform-intel.c | 1 +
 super-intel.c    | 1 +
 3 files changed, 3 insertions(+)

diff --git a/Monitor.c b/Monitor.c
index 824a69f..e3942e1 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -26,6 +26,7 @@
 #include	"udev.h"
 #include	"md_p.h"
 #include	"md_u.h"
+#include  <libgen.h>
 #include	<sys/wait.h>
 #include	<limits.h>
 #include	<syslog.h>
diff --git a/platform-intel.c b/platform-intel.c
index ac282bc..5d6687d 100644
--- a/platform-intel.c
+++ b/platform-intel.c
@@ -19,6 +19,7 @@
 #include "mdadm.h"
 #include "platform-intel.h"
 #include "probe_roms.h"
+#include <libgen.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
diff --git a/super-intel.c b/super-intel.c
index dbea235..881dbda 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -23,6 +23,7 @@
 #include "dlink.h"
 #include "sha1.h"
 #include "platform-intel.h"
+#include <libgen.h>
 #include <values.h>
 #include <scsi/sg.h>
 #include <ctype.h>
-- 
2.44.0

