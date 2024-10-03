Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6961F15E5D3
	for <linux-raid@vger.kernel.org>; Thu,  3 Oct 2024 14:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727965282; cv=none; b=jq0FBGrNsmFmdkdybOWPo7rx+TPm0mVXIZyq2W6g+CK3blLroJPcSyi9VeVzNxMora3yldR1WCFGfRoaNgmw5bgnEgJOf5orJl/bPyfhyI8YmTU9NdR7luuX3vDbuLIFSHs+fQH6n+4Dzq9JQ5tWcqXKVywTaWwbJYxb7nfl0ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727965282; c=relaxed/simple;
	bh=8fiJzDul9VHSDtHqdjOuk7aACe3BZJv0WFJqiDlw8J0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qnehfdX4eW46CUnFFJVMjGcGIwN3/FVl09lmQFS6sfkRa0hRA4kDez0kKa8tIgC24pBA9sXC8afyWXMqvgule5MKg4MNcSDpRmg23uWKyyXaRHBVRCVxw/lu/ouP9S6jNY0UPnF36WTTfuu56K6i61jHgWKpu/6IentUvEUE2sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IzL6sKvz; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IzL6sKvz"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-71ddfc61c78so96479b3a.2
        for <linux-raid@vger.kernel.org>; Thu, 03 Oct 2024 07:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727965280; x=1728570080; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6T7C0TJ9v+7lndOOuwbs8ZDDnjWIVK8zTlOgqUK1kiA=;
        b=IzL6sKvz4ONyMAg7/LpP8+WkPipcvgpC48695kvf+45omFIOcU3JIGxuxc/XaZZ/yL
         yVu5v+4TzL4xQVcJGMQ7oga8txUDiY/U2qJ1XR9xzlZUHlKfzA/cak2r+HActjX4dmjJ
         BcyXYAf01rQiUU3G7OFoxLwnyuUpdzHKg4t32LtbqWJou3acRCmm83l2zcSqcBanijp2
         Bm9X6Ym/V1xHx4gXcB5Wa/bTTdItmOqglS19+25lJx58C7Bgxn8Tex7MDnnoiHXhBJ+o
         S9SsQHIuBE88XhEYNoOwQHqRnuSjQID/qIKrq2KChZtu/itXsrBgiJY8gycWf+eraYYD
         bE6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727965280; x=1728570080;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6T7C0TJ9v+7lndOOuwbs8ZDDnjWIVK8zTlOgqUK1kiA=;
        b=NpkIopxneaFSWPMIMy/Qs9z21Ra8CK/hcKsxgNV5LqKaYEYCFm1Mlh6YOHLYxtUHeH
         b0NmpbM46Kr9hwWpruZSVLWshOKGNVdm7LNQIIqG5SJXciwTbwRzZpdj2yMJM5CEp636
         0iLxA0b+ZnUhVp9Hee1ktG2QDeEUt2Y4QvM2D4myj+F+hA5i21J3eHnxRSkyuZUOKlq0
         LyyT+AqNTrjQ8yIxPuWXpfyERsjY5aYrJwsii/P5zv5DqfHRRrAecVXbKH05Gd4IK3bU
         fyuxoeVhf227MRl96aQ6at+lwRlBFQowLhNkI5XdYIt2JkmZCcVax/siSz0h+qsICibs
         wH0g==
X-Gm-Message-State: AOJu0YzWLs3oWmbje/1yOfuFO2OtOtOsbquzsQ4HcLeKAxthraqvUjT1
	W3/U0VB5WE0/DOZe1T0EoRYVl9yQf9Hk13Q+uLG1wMD2PfZM3J72VF4+wQ==
X-Google-Smtp-Source: AGHT+IH/1pZ8Itvt9rAvnghegEqBLkHO0FFzCSR1FSX39p9YxOqs+eDc4Zh4Z4EREI1DxifqmOYVwg==
X-Received: by 2002:a05:6a20:43a8:b0:1d2:f00e:47bb with SMTP id adf61e73a8af0-1d5db175ffbmr10978837637.21.1727965280427;
        Thu, 03 Oct 2024 07:21:20 -0700 (PDT)
Received: from localhost.localdomain ([2600:8800:1600:140::ec])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71dd9d728f8sm1376493b3a.41.2024.10.03.07.21.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2024 07:21:19 -0700 (PDT)
From: Paul Luse <paulluselinux@gmail.com>
To: linux-raid@vger.kernel.org
Cc: paul.e.luse@intel.com,
	Paul Luse <paulluselinux@gmail.com>
Subject: [PATCH] md: CI email test - do not review
Date: Thu,  3 Oct 2024 07:21:14 -0700
Message-ID: <20241003142114.12925-1-paulluselinux@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Testing emal send

Signed-off-by: Paul Luse <paulluselinux@gmail.com>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 9fa18613566f..120f7ec2c67b 100644
--- a/Makefile
+++ b/Makefile
@@ -4,7 +4,7 @@ PATCHLEVEL = 3
 SUBLEVEL = 0
 EXTRAVERSION = -rc5
 NAME = Bobtail Squid
-
+zzzzz
 # *DOCUMENTATION*
 # To see a list of typical targets execute "make help"
 # More info can be located in ./README
-- 
2.46.0

