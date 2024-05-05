Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76731D54A
	for <linux-raid@vger.kernel.org>; Sun,  5 May 2024 13:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714916377; cv=none; b=LlHyeSdD4iNIDQIWppA42kQTBzsIabichVuDP7CnZ0V38T2qhKa7rrP0Lae8nQ85XXJLTygyobsMFzISDwyrwlQCPpFXsY/IUDtjWaJq1bmYJ33nxzGMG+Ff+0NoiopmlmD18EwAWKBwrjDCCdJjYmu3jlqdQqChbcQma/Zw3Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714916377; c=relaxed/simple;
	bh=V+TGqr8R8U9FsKmHc+kQHZB6zUtvAOY9y3oOTiulmsw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=srN8tnyT44n9ytCc2fNCevHlRXonSQgEhaza8gqPuL8TN+xYeafsKBPp8s3LRYlC28Mq7g75NLUIzRD/Lp2p5cPDcFlhEF5Vv5FsGx2JzLD3RAimy+D3b+K2Hbc0R6KBkLP4DWFjYcxMMJ0YF3940PiOLfBeGq35ArrrgHOHkQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VHI/uFbg; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VHI/uFbg"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-41ba1ba55ffso5573355e9.1
        for <linux-raid@vger.kernel.org>; Sun, 05 May 2024 06:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714916374; x=1715521174; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BtpR8thd/JOdt0jFUiUwnDk9Lms3YOUVgp8BaPVEazw=;
        b=VHI/uFbgXS36fOutb4OijeAuLssAkrF3fU8NwzEW5RajITHuMofg64/D3n7TysX7k6
         BgXorLyH8T3W7/7kTWjEJizDMAzW98HusaKGEKBprj2EEJWgLzXX0kDqo/If/DGDkJqe
         87+XwTPIOPFG6mKFc9w2O/fh90dR1g5J+akm9UVBIykYHGQaAe8uePJ9aa0DL9MohzOp
         8r5DJOkg3ssdPg9N4bAOCWvLEt0XnYf2fV+YLCURnbv9vf7gX69Sew2SFC/F5PDx0BuH
         chfhB7j8gE+q+cfQtJLQQftOZkLuaVOKC/952nJNguefVR3HIBlET6rArfVSc4fdVdsG
         +drA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714916374; x=1715521174;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BtpR8thd/JOdt0jFUiUwnDk9Lms3YOUVgp8BaPVEazw=;
        b=wJG4hT69v2bSe6pkODdkBYnb4GScEHygsqL6Ol6zI+G+PonMhJX76eH++6HBaV+b9t
         kbrMmVl4ggChEfk5pi0CqPYuLKqCjtK2DFXHfMaUdIwbra3AU3P62PG5ZliVs+f61mNw
         EejeWt/PbWKAN+ZW2Vr2zV5Etg9VTl1CbCJ4AY49AnXQDH3byy0nkkM8/ZQr/XGdBaSu
         Yz8SNx+kUAcZvLvxH8V8KSaJISb8VYMrNbiLq2th7O2gDlR6BGLieExTsgryRa0fE+pm
         GetJZikP9nKW5LAfUAXvb908n3j7E44GUvSqp83RK+r4uF9TVCHrbt3bmjd7I5VJQbhv
         nVLQ==
X-Gm-Message-State: AOJu0Yy/RXC26Qb977mCLMbrmORDe/7egbxsHiA2GVFL0caWP1GDrl69
	R563S90yw76+GpvbgMZFRKfrvBCJPTSOzRrM2gdnrZqjUPYeFVL6jf/29A==
X-Google-Smtp-Source: AGHT+IFGU/snIxf5grTSDgRanD98H66EKFdxNqzKb/MOD2xfT2HTUHHVd/YJp1uLeA29Y2WJ8ySiFA==
X-Received: by 2002:a05:600c:3551:b0:41b:fad8:45e0 with SMTP id i17-20020a05600c355100b0041bfad845e0mr9241507wmq.0.1714916373706;
        Sun, 05 May 2024 06:39:33 -0700 (PDT)
Received: from kali.home (lfbn-ren-1-785-215.w83-197.abo.wanadoo.fr. [83.197.112.215])
        by smtp.gmail.com with ESMTPSA id r13-20020a05600c35cd00b0041bf45c0665sm16262328wmq.15.2024.05.05.06.39.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 May 2024 06:39:33 -0700 (PDT)
From: Fabrice Fontaine <fontaine.fabrice@gmail.com>
To: linux-raid@vger.kernel.org
Cc: Jes Sorensen <jes@trained-monkey.org>,
	Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
	Fabrice Fontaine <fontaine.fabrice@gmail.com>
Subject: [PATCH] Makefile: add USE_PIE
Date: Sun,  5 May 2024 15:39:23 +0200
Message-ID: <20240505133923.267977-1-fontaine.fabrice@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Do not hardcode -pie and allow the user to drop it (e.g. PIE could be
enabled or disabled by the buildsystem such as buildroot)

Signed-off-by: Fabrice Fontaine <fontaine.fabrice@gmail.com>
---
 Makefile | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 7c221a89..a5269687 100644
--- a/Makefile
+++ b/Makefile
@@ -137,7 +137,11 @@ LDFLAGS = -Wl,-z,now,-z,noexecstack
 # If you want a static binary, you might uncomment these
 # LDFLAGS += -static
 # STRIP = -s
-LDLIBS = -ldl -pie
+LDLIBS = -ldl
+USE_PIE = 1
+ifdef USE_PIE
+LDLIBS += -pie
+endif
 
 # To explicitly disable libudev, set -DNO_LIBUDEV in CXFLAGS
 ifeq (, $(findstring -DNO_LIBUDEV,  $(CXFLAGS)))
-- 
2.43.0

