Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8CA94C6C
	for <linux-raid@vger.kernel.org>; Wed, 15 Jan 2025 06:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736924039; cv=none; b=Hd0XVKQUXOi4hFVQRTFJ3SzCViRYsSeI/ERYnT7LX7UdEPZFUvGF4KSUfgizqsPcLH0kBc2a3kY7BPIbetdeJ144Ch+H2yROzZAZSx2CyxHW9eHztQILTfWoBOUVIwle6pxKPjWgmc10TvNEI9yqsYIgDsIq7hIkDHdg6qvjVH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736924039; c=relaxed/simple;
	bh=KFp3jdXWgMaBUXdQHCLFP0wUMgB2SIATpb93CgoUtDY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=N/xUg+7ny7CP1mDFLPzm+CM25QyQjsRJ7HjE8EN7qWdAf4QjYSXWPGM/ZnJ+3ItXjsxDme20B/GKcE6hklMdP6e5iKXzgIFMRlATuI6jAAOB+I1NEGGKvTr/1MLwsjlKiUOgs/r43/C1xTnNZ2z8LI6w1NLXp3xOSvSYx3uhQuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mZxGvw48; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mZxGvw48"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5d3e6274015so10815208a12.0
        for <linux-raid@vger.kernel.org>; Tue, 14 Jan 2025 22:53:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736924036; x=1737528836; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eKPKC6VCuB1agu4M92Pt0Cj7EiQedFYv4oj19q1B6lE=;
        b=mZxGvw48X2M5Z3PBIxQtbFz741kjqRkxPiGypncHr/Q6S87yciiMbYw/YUis1rBrAq
         +h0WhcAlmwFyTxBtuv+WfdFk2W/+sdE2JcF649DWYq+3XDcDoh3959Etw68bgbTEX6fN
         hDCssWTqJrpFovWkzrqM585lhFb35zbfNene6cOwHcdJ/xTL3rqTYAgI8sC7U1I7xl68
         4blHojoLRQ8DfhYBGXLMIZc/poe0CUdYXT6XCehOmFXB+Q0I88X4a05fEhAL+2f/kiwA
         64sB3lOtWQKQ4Rf3NThNTZRzOn4gEBJOaomR/R7ouHJPspjhcobUJQm7ttm+KVAsdeb8
         LcSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736924036; x=1737528836;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eKPKC6VCuB1agu4M92Pt0Cj7EiQedFYv4oj19q1B6lE=;
        b=EHud3WPtI/iJZZL9Pp89EZ/42OV/7lffaA/4GsZUVjBjV3FdMvbENVijwwqxGcuQwH
         9G5kxcu1LokWoE/dq5jaSbL7QlVy0WbWeGvXuDoS36bcsG5UaHeDEQDX1UHaGGNWqKSS
         YMTixyIPWFWxi5+Om2ZFYtbaAYUl2hUJyGkdytvQo2G7O7363Nlbgl+Ub+mvq69xxl5W
         1Y0oRTIyNcUpYlhdrXB1G1E0sdS9bU8WWwSe2GoKtiSGr0JX/azVn5U145dKdbcQSTNi
         T9Zs/NDqRUT0kxngOClF8FmCKFQZQedzrc5UVOPKJrifP8+MTznkGiQGAVCshKGIbpgI
         +z7A==
X-Forwarded-Encrypted: i=1; AJvYcCVikNXHifXvG8FAng6hUa/QPREVRo1Wi0GfaIYc/4xf7H6O493BNNiEpwSbAyRjDy/bj5+wRv94zTMQ@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5mOooo1W7TER23dd0oEJ0fo/DzldnY+XtBVnNc7c/TD0BOf5t
	WUCQK6Cbv1d/yKA6Iej4FHQ+eYrUMk2IMWCbwFmxbrpYXFNVgzf3aPSRyRK1VqI=
X-Gm-Gg: ASbGncso5No5tmEIx2sql6SH59nX4axacHQ9jzQiuicdJPtmCHHPg/1Hg3E6fK7oUi7
	9yNEAESoqK/R5aFu3NuWNJKnaqYUGYgVoqiSeoY+UX3rlhS3SzA2Rr1HNbtc75cfUOl1ivo96aA
	H0JA7VK0bjOzriAefkrwjAJy0ZXrtOe9ugEwNybmbsuj5684EHrh6WwkuRSR8kTJT1ngLxA/8gq
	odbXWjbfJd0uPWaPyvaCCIDxruay2RtAyBpuv5cOVffBxrCCbNmyppfzN7UCA==
X-Google-Smtp-Source: AGHT+IGY+XCJvxMBIZ+HThERjNXncTtFcruCLfZ72BdFMv3vmRIgxjd7ygYKOJiD0ORhulrxl1l94w==
X-Received: by 2002:a05:6402:27cb:b0:5d9:f362:1686 with SMTP id 4fb4d7f45d1cf-5d9f3621959mr5507086a12.21.1736924036001;
        Tue, 14 Jan 2025 22:53:56 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d9900c440bsm6865481a12.26.2025.01.14.22.53.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2025 22:53:55 -0800 (PST)
Date: Wed, 15 Jan 2025 09:53:52 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Yu Kuai <yukuai3@huawei.com>
Cc: Song Liu <song@kernel.org>, Coly Li <colyli@kernel.org>,
	Mike Snitzer <snitzer@kernel.org>, linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH next] md/md-linear: Fix a NULL vs IS_ERR() bug in linear_add()
Message-ID: <add654be-759f-4b2d-93ba-a3726dae380c@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

The linear_conf() returns error pointers, it doesn't return NULL.  Update
the error checking to match.

Fixes: 127186cfb184 ("md: reintroduce md-linear")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 drivers/md/md-linear.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
index 53bc3fda9edb..a382929ce7ba 100644
--- a/drivers/md/md-linear.c
+++ b/drivers/md/md-linear.c
@@ -204,8 +204,8 @@ static int linear_add(struct mddev *mddev, struct md_rdev *rdev)
 	rdev->saved_raid_disk = -1;
 
 	newconf = linear_conf(mddev, mddev->raid_disks + 1);
-	if (!newconf)
-		return -ENOMEM;
+	if (IS_ERR(newconf))
+		return PTR_ERR(newconf);
 
 	/* newconf->raid_disks already keeps a copy of * the increased
 	 * value of mddev->raid_disks, WARN_ONCE() is just used to make
-- 
2.45.2

