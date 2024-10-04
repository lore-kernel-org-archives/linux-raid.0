Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E5B146589
	for <linux-raid@vger.kernel.org>; Fri,  4 Oct 2024 12:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728045753; cv=none; b=qA7wPWzVMHJQgig0NXUvO2CbBRE5/DqkiW4fXBkP2yuPnE33Xbo0b2uunrOz1b6YrXkE5Rbb8mFqw3aOs8ITrlJVPuVuYKFcL3/+JLJXDojiA/GXKp/L4p2JIR1p2y8/4CjqOQNNwz+f20wAE6KY1CSKJEYDAgDBU2I/UGh2F6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728045753; c=relaxed/simple;
	bh=zUNA9ysS6LaKqr/VYFwPkhg7VRGUXy/Si57WxUcxBZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WNq+1jYSjtlcpwXaFDOuAAacUct9yDZuuE1ruLnT3mzQjMiCLrQAgQxBAKSDvpiqKy3kyru9XpUvDaXF9sfA9QduqfNxBRHTdcFknc6V7KmCvUm9ZL5i/8AMGqyCiqEEySLiSpahukrru0YBiSUBJhEL9ImNV3t83Vc3ce/bbow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kyPFahWz; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kyPFahWz"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-20b58f2e1f4so13967045ad.2
        for <linux-raid@vger.kernel.org>; Fri, 04 Oct 2024 05:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728045751; x=1728650551; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jdiqItqtiluPkhT63sZpXGc/mwvnuMWz7dokcOVHUZU=;
        b=kyPFahWzMhSql7WvS7ju86w+4D81cozCqYRX3f9C+zgmd+9hWJ1LDN2hTuv4UYwYr8
         xkMvhuqUUkeHnbCrM27WfAQ5fXyz5Kt9RzoYQC+qjFE891uH1ZT4jnMruVvCt/CMJPkp
         DPfjT2067bnO1+YUD2qJI6DVAFQxaKAAI7oqXgh7ukZl80N/0WhvhvptqFfXhx1rlKLm
         dRJ9B3z5FTfjdN9IrQ8QUWrtpym3gRjtII3ejFODkeEIyStiqZBGbm9Cpl02Y0IcgJSs
         adwgOcP+u4LO97LPS6cSESbouG4exqMXiwn0jx5W4e0r+BQphBE9FY4Hy+87zIKRgsrx
         9SRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728045751; x=1728650551;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jdiqItqtiluPkhT63sZpXGc/mwvnuMWz7dokcOVHUZU=;
        b=BG0yXc/q1gOfEDjrlrj6RY0in19tw0BG1MGAO/p24Fa2TdQV+fhwwACp/RVe0c+hG6
         xwUl5ZUNMAK9R1NIcSqtODoq5T6xLttFsu6ch9cWtHf5JhcZlB4fcgmuekUUXxuXDihr
         4UYeF1FeqExA+XBk7AI4+z7rLI+D+zrUBUX6gdqgiyXvNpfVEAqeqhVqktAEBqfwa/zL
         QvCeQaRM6pZUmg7pKDHa+jIBpnhyEP5eo0VASToKHKsEA9MrGawtnxme64LudHgPi2sZ
         mcuNFejdzkC2JhyttDKgDMZb2QAvU2JyORqqdKPtd8+7OmkzSCLQ9gydKEXmx3j3KcAD
         BtDw==
X-Gm-Message-State: AOJu0YwzVhJC0iJOEd2QWFNQEyGFIpyj/Y7H/hWA62KAh3pbIQq4onLc
	Mf5U2Vh4JL7D4ETIWhPY7rg82eyScv8th9kup6k2ziVCEv+K86kIERha/g==
X-Google-Smtp-Source: AGHT+IG0GaLdW2CmFMEOJFF2NtVp245olMx4W9WkNya8TSwcZr1IFm7NpsG2sjroJJT5yjMO2IAOXw==
X-Received: by 2002:a17:903:1247:b0:20b:51b0:4b22 with SMTP id d9443c01a7336-20bff1a599fmr35934615ad.47.1728045751156;
        Fri, 04 Oct 2024 05:42:31 -0700 (PDT)
Received: from localhost.localdomain ([2600:8800:1600:140::5e])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20beeca00a5sm23493075ad.113.2024.10.04.05.42.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2024 05:42:30 -0700 (PDT)
From: Paul Luse <paulluselinux@gmail.com>
To: linux-raid@vger.kernel.org
Cc: paul.e.luse@intel.com,
	Paul Luse <paulluselinux@gmail.com>
Subject: [PATCH] md:  CI log retrival test - do not review
Date: Fri,  4 Oct 2024 05:42:27 -0700
Message-ID: <20241004124227.3540-1-paulluselinux@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reminder to myself, do not delete the PR as it can
be re-used for more testing.

Signed-off-by: Paul Luse <paulluselinux@gmail.com>
---
 drivers/md/raid1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index f55c8e67d059..e2e97a9e0b73 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -62,7 +62,7 @@ static int check_and_add_serial(struct md_rdev *rdev, struct r1bio *r1_bio,
 	sector_t lo = r1_bio->sector;
 	sector_t hi = lo + r1_bio->sectors;
 	struct serial_in_rdev *serial = &rdev->serial[idx];
-
+x
 	spin_lock_irqsave(&serial->serial_lock, flags);
 	/* collision happened */
 	if (raid1_rb_iter_first(&serial->serial_rb, lo, hi))
-- 
2.46.0

