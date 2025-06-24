Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7309217332C;
	Tue, 24 Jun 2025 01:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750730182; cv=none; b=YkSzpeUJLkt7YaFqBq5/6IWi6Zy2Md1GsIwed2MV18FEjMuKoNaT8Vcw3oRl0hX6KPXcOsSwOH6dZt/C9JaB4WJovE28SJZJLtrFaOYj91Ru3k8MEk9BN6CwJhyKnD/3+xLzoYv9oCsLbQvR1NJqaS0Sop7XRy0ALn+PZkOAZY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750730182; c=relaxed/simple;
	bh=QWc3pPSuQi9bLIgKfIf6Gs/fdQgo8PD1cAbJoDdQmcE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=u+0r4XIrb87CQBaeIUaqG8tH+oz9iTO8DdeRQ0+Ap10irJXmtSDdWERNDwiqRoHB5FjZxlCBi9c61jG3grTWoG6asbvTZewSfwrtL4n8r139/IT3uybLWwoypd+dWlVxuzUYVV75g0p8wF5ryzwk3pbPzzxiCad0IyM2UiZfcd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hgv5+WSY; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hgv5+WSY"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-748fe69a7baso4488894b3a.3;
        Mon, 23 Jun 2025 18:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750730181; x=1751334981; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DFTKA/J3N4zuA9kN6irxuppW+fhNRQUbPdKz5iIgmSg=;
        b=hgv5+WSYXq5ct7C+kKIrVmQ9t+HiZAMhr34YFV9Uvdh+7F6hwprPR8vCUq6kFN9lbE
         ADUCcMv+UjNrc81AS5vpo8NpsaEiYwDHSxr4gohLzGcQBA4Gj6jqSvA2SdhZvqfGiv+W
         s9imdfkUdFTlYuBJXSeJJpZwvotuvNsHu3nRz9QWytp70zfj9yKJuSMziH6rcp3JoujD
         BuWsRYPLALKy+0eZr5Tx5p6AlfB9GZHivpIbfZvtxPbnsUXQTMijonftgtg+LPRO3OU4
         sUqfYjj9TotzmVNEno0bGjnFpOOjwBhM5/KPHUHcBwzwPbjUANhvsop18VAONowzxuMa
         kdew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750730181; x=1751334981;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DFTKA/J3N4zuA9kN6irxuppW+fhNRQUbPdKz5iIgmSg=;
        b=Q+kssuNo5WfIl3VMyOjUHTKIyU1MqiqPKBrSuEOBEctF/4pAW0yudG8FCb5grXXltt
         EDUUqNHoM3LRG0POvvKSlJflb3E07ZIMOHfqMQN6amFf5UmnpUl4mc3MMbNn9H0CVhey
         y7AnXhW1D4ssIvl2tI8vsYq4/L4UwIBKreoLYsVAdRQfeTGPHGIZKbcDtY0HKe+bnZtu
         42KpWlxmcfI65BxCDe3T+sUWFQJBmKXCq9b9R5lQAcw5tB8YYG3wevQCDz4xJlJPEXzE
         Qg46qKiAgMNaMQVbRuMpQwsUkUEhixAUiybi+35nbgsLvzgDr6I2I0tRYxVHcjtSUuqw
         XvOA==
X-Forwarded-Encrypted: i=1; AJvYcCVTQSfI77QPRLoStSCdxk8zgPhMyMqM+tWNHLOoML9yAmTws5WbO26iLc0Nh5keZoSPhUek64e4r/tSR5A=@vger.kernel.org, AJvYcCXgCTNmGw2N/toz2kJSU6UgmPruyxLBQ2K6efS1JmZnW/frwu3/YIAnFjRMW75F6u+MtKU9B3Qu71xXig==@vger.kernel.org
X-Gm-Message-State: AOJu0YxWp4Lu2ynA/C1RiAc/ZFyfMB8ZdLuG7WrJ3bR4QH1CxdAeED5h
	uawl4iuPTPihr1KsDcrNUXwzNiHx34pu58kb//VQ7wh8hpJFfN7pxB25
X-Gm-Gg: ASbGncstgTtpAuIcueKLN2REPqO7Di4l9WJFBwymJlfBOGj8GjjEyFVXwcj/TJsxPnO
	VzK/uNN1/uvarA7+wVbie80EY8+FXQrzQOmhZn6VgppVUxw3GNQ/lmgg7cHZFhNG9/K1sFtsnnC
	9/dCi9mH6A2XpZVeOB0Hby1Au/M26/cSGtBV4c2mMBLXokJTJbHkDI9yRpKu/Yf+FzsQylX4YdG
	cJEkGBGmYB9+qn5XqXQbjM25hv9qRskDUF9mtFIhBvfluk2hclGR2ztGMsp5bD55CLrTmvFIhM/
	rNnCwv2nkX3vapUF68yRyAb+82w8ey5bIdJTewUtlHBgfI0sjZ0d68WbnjAT9j5e0oNvK6PO+Es
	YdUDR5Dbs4ZYjXjTd00HFtgF/IYSn
X-Google-Smtp-Source: AGHT+IGIOzokD3mmNbhbRTvnuHMtDXZq7ICEazwrGHSTUPZR78tkBKR4IAGXU12KxhS22Quy66jlZQ==
X-Received: by 2002:a05:6a00:2386:b0:748:e150:ac77 with SMTP id d2e1a72fcca58-7490d6c3b5fmr18728442b3a.22.1750730180570;
        Mon, 23 Jun 2025 18:56:20 -0700 (PDT)
Received: from localhost.localdomain ([114.242.33.243])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-749c8872629sm425424b3a.164.2025.06.23.18.56.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jun 2025 18:56:20 -0700 (PDT)
From: Wang Jinchao <wangjinchao600@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: Wang Jinchao <wangjinchao600@gmail.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/2] Optimize r1conf->r1bio_pool
Date: Tue, 24 Jun 2025 09:55:51 +0800
Message-ID: <20250624015604.70309-1-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The r1conf->r1bio_pool field was previously a struct, 
which caused a bug after raid1_reshape.
These patch changes it to a pointer type 
and removes struct pool_info and related code.

Wang Jinchao (2):
  md/raid1: change r1conf->r1bio_pool to a pointer type
  md/raid1: remove struct pool_info and related code

 drivers/md/raid1.c | 84 +++++++++++++++++-----------------------------
 drivers/md/raid1.h | 22 +-----------
 2 files changed, 31 insertions(+), 75 deletions(-)
-- 
v1: Replace mempool_init() with mempool_create()
v2: Replace mempool_init() with mempool_create_kmalloc_pool()
v3: Fix checkpatch errors and a bug in calculating new_r1bio_size

The idea was proposed by Kuai, and I implemented it.
Thanks for the guidance and review.

-- 
2.43.0

