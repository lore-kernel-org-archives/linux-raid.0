Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE5146BFC0;
	Mon, 30 Jun 2025 06:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751263866; cv=none; b=MhfkA+HGyCwqMvLDyX9TnimOLUeQCkmaEJAhcGY9IU3+b8cMrdqxHEgtmHTVkMhWy3uFRc6f5xhJ7sx8rwSxf2fTfZIhJZCLNxGrPgUV4mCAFNN457Vexik7/j2xr3ifXzy4lENJxukVZTT8zKoV8seN/IXX5lRFraCgHFH842c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751263866; c=relaxed/simple;
	bh=rDZ8/OV6CIdH/+mAHQoWhbh6c088TzcnR2EOEDBmF9A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PF6Ty/LWXglo3QOTyOMap4tHI4MamT9JTCUQ0YC2BXGxXm8mApbsIeyx862WdMcKH0CI4f4zbBoEVein/h0D7ZkIuR4yw87A/Pjm6p4kDmZNicRiUHuZvA9P2qYnMGMeg0lFep75FpCRSnJfbADK9frC4+DIjJ5llMvxJDOuuOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DcgBU9vs; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DcgBU9vs"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2363616a1a6so10450405ad.3;
        Sun, 29 Jun 2025 23:11:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751263864; x=1751868664; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OdMkteIOl77MH/lOc5NVyvjruFCrCW81baD7d+qfly0=;
        b=DcgBU9vsqLB4xRMbo3MvRZ9BYqOhaRASVnu06M1nZARUARPkp4wvE1netpco/i2hYW
         s5mDcVvvOetwOmLlF/ZUHH/yLQ1bAeDxORJU9XbHvLdgUzhkotmArdVy/lJKJOcTROjm
         5CPVQ18uGE8CHMGv7jF940UuIuo7De9tGTxzBQIhdzONsgEosCk0NVS2xfldT5RDoV+B
         ee9e4lqXDJiIu76FdfAyqDWU4fkF9l3O++H0N/0tcKkM6pWfx+pNBphYm4FKCdjsoCJ0
         Ct+stjOzILI2S1AuzTWa3Dn7BGErcpAI+mH+UrSKv0YJasePUd3Z9liq388xWxWK3mT1
         xYNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751263864; x=1751868664;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OdMkteIOl77MH/lOc5NVyvjruFCrCW81baD7d+qfly0=;
        b=XMP6fKywU5GeiOt8uyy/DjLO+2jpeyUiTH02HHIbp9GUOaPgd3RsagB+8wcUit63QW
         9Fi7aWHQywDVe/xgg2nmlIQfpnA7329gbjoiFkH9cuibKgqcMDZmH7IRN1/BDbztwc7B
         ZwamGpgCLXZvPBUvS5ge3XPkyT7aArBvy+hB3XzLomEvw1G9N+D9l9o0tOIxbbWQHLT8
         ySEy5c+7mrL3+sgAY85ko4YfwCa53k/VrKx3okFasOhffN1BGI4iC9oY0LdqAKU/XXLr
         fxqyGSy3UkTR6x7Dd5tcIjfBI4jOUttUjOZrybGvYO3bfHzZJ+5u3iaptkQzXwjT+4uS
         HWcQ==
X-Forwarded-Encrypted: i=1; AJvYcCW+qZzJL+C34Ebj/kpUFD7YHCDgoH+x9A4pEnCHjZcAY2Ou4ez5OFRX0g3nRQbQraMAZvnTcxXs6OeW3Yg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5ULsQmCX+RZGaK0rx9u0p41WT8vf+P7ZldB4byMY2ygK8waVv
	4ug1dAA+movz5io8c2XvGL41svNacFsbDG4AtF/QC9FHVtxLoclsNtmW3njoDfDIdhI=
X-Gm-Gg: ASbGncvZ7rMk7FjR6yk6zYAWhYvyqxwmUAoim7w7JLBm0fkvDeRYzKVglT4qyIKscbv
	PmvK3VdxeBQ4ZApSE2It/zR46adZ0/HMVlPdxcLmoVPfEMdA+D4NvyZG5QKPcGpLVCfmx+IMSIV
	jxz3c0hNElfMh0o04PyRxqSH7OXmEiCbahMNb5m4VXEPB0wwOnwsQBWBk9rjZYDCdIamsuDVGlk
	wYVYxFqLy2NU38S9JGUhiU763A5opBpMpTzUz1ehmrqfhySG31c/XB+TSZvV8q12PWGzpCArHb0
	kGrCrW9D6M8UtMEQV2tIC/rfm2NRVgcCSgswVYxA3pue37Xcuz9TFDswS7I8ywF1Qxwz4K+Rug3
	wjZn9u8Z3yfgSAF3SKcSBiSAvauLj
X-Google-Smtp-Source: AGHT+IFJkRP/cPIZw9YHYhDJV1LkOuydjs9RuY+M9wGZmg+HH+0S0zlEopndfp0P2Q7X22+O711yOQ==
X-Received: by 2002:a17:903:3bac:b0:236:7165:6ecf with SMTP id d9443c01a7336-23ac465cb20mr183245645ad.38.1751263863996;
        Sun, 29 Jun 2025 23:11:03 -0700 (PDT)
Received: from localhost.localdomain ([114.242.33.243])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-315f5382e87sm13343443a91.8.2025.06.29.23.11.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Jun 2025 23:11:03 -0700 (PDT)
From: Wang Jinchao <wangjinchao600@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wang Jinchao <wangjinchao600@gmail.com>
Subject: [PATCH v4 0/2] Optimize r1conf->r1bio_pool
Date: Mon, 30 Jun 2025 14:10:41 +0800
Message-ID: <20250630061051.741660-1-wangjinchao600@gmail.com>
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

 drivers/md/raid1.c | 82 ++++++++++++++++------------------------------
 drivers/md/raid1.h | 22 +------------
 2 files changed, 29 insertions(+), 75 deletions(-)
-- 
v1: Replace mempool_init() with mempool_create()
v2: Replace mempool_init() with mempool_create_kmalloc_pool()
v3: Fix checkpatch errors and a bug in calculating new_r1bio_size
v4: Remove unnecessary local variable used only once
-- 
2.43.0

