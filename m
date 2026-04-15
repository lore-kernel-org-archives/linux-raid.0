Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 635623D3338
	for <linux-raid@vger.kernel.org>; Wed, 15 Apr 2026 14:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776261811; cv=none; b=kgZiiIFof9u7Nuc/8mug0j8WfKLymyCQnBYSagiZU1suLt3GKNWO6CbBpbKGyViNLvIioZJzjUUTnqHlsZINXDQTWAbQ7JVCSl8RSFAyDUZlys1J3Z977jrwEdLwvpxJ1fOWHhyGNBePGuXz0/MkBq7Br9XWsGnjRC9gHJ3xvIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776261811; c=relaxed/simple;
	bh=g77/9JoUqcxGflj88/tpxIhl6VCDgQnq0I23R8fPy5A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Be//nl9Zi6E4ss1Px1vetxxWMouAbsYKqFcxI4UVQzS8Fe2VeFEkHpIvYGlyuQyRAcsUyxT01L5xgg28cTYyEWt1VKdaGuiRDxtPqJ+gUS9yMY17HIr1Fg6EQvKF1zf81OnTHwLhVrkIWBV7sq0c/2zdgQH1XCcOFhoaH+CYVsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rP/P5q8j; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rP/P5q8j"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-43cfd96354aso4207989f8f.1
        for <linux-raid@vger.kernel.org>; Wed, 15 Apr 2026 07:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776261809; x=1776866609; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TUfAEi138dE6GmHPgdalIIaQ1/0JNT+hRuGIBozeNAY=;
        b=rP/P5q8jZiW5J1PKkOGFt1FtYltahBcRKGKVbTYKQyCMoBElpZRKxhJl0C7bzQJ1Zz
         dUEQYLAuO5zEbjqnOOFXPhsRWLfSTjGxq+qaWhW8TW3eA/adpS9GmEdLepHzdiTn8P6O
         3O4zCU7g254O4QBYHw3jY5nFL/5Ah6yUpUouGjMAc1UwYmzHCkdHe6otN05l5jh6+uHs
         TsoFl3CTJYG5/68iApuKQnR1arW1k287tTMW+RpWa9SegelXnkIHX5qiEbNtC8rFIDLR
         W+l1GRASBHxhxfp3olzaIufN71ZADmOGYw/t1jXixILW1NxCyBcJ2oiHB2MJ1586nPd/
         ixQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776261809; x=1776866609;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TUfAEi138dE6GmHPgdalIIaQ1/0JNT+hRuGIBozeNAY=;
        b=q00wjws1XILlok2X1HVsAwx4aW45c98r8lAXFy3WiwR7aunMdTUVsl5ThO9a//Lfjz
         4jxVvJVvR27m20MMuovMAUb1fqkkCR7hA+XvaKGjcSA7E/0z5fxkyPrZQ6YZwjWgZcpm
         n2IhcBrO0X/p9utaASFE9zAvOw0hFWGnF3W/dD8MygWbgocR63S4wne1A+U9XHHEuAQ3
         j0EDnvDCtpy/4vkxzZLXPCDSyuDrTiNs/E432XkBe5pCXpVO/5g1sV7H9KCQnobVvOjX
         1jveuk181NpikVmL6DrCSRZ5V1KON+CWf9loy4YURbuu1155v1SeJ9ApXn4kyhj/pGa3
         cjIA==
X-Gm-Message-State: AOJu0Yw4VJ5WqYhbNUAwREpNEljmf8BnxtLSBHJ8HZ/z1jWb2+8y4M0A
	bSZxfPPYbcFW7PS9Bs0Rg5Auu6FZDCiBqmzBiOw2vWhTu0RUQ4ROoWDn
X-Gm-Gg: AeBDiesv/WQPLqKVWfVBsJhRiCKxYnYElY8PS3k029sTZ7tZXY/Ft/W3zMwyVVqP1f3
	n+SqyvYrEW0twoGPbMuc8bpU5NCc8whVgaS/23irPLvha1lhemdWCTxDxASPwytAERpuy7UCvLl
	zw5zUpxpKrllQD0eTT0JQexTy1+ZTDrOT5xHTjAYW+GZlGGRUtmOr2PGKQQRzr1y6Utf3b2UW7m
	DQxGbSXjzWRhWNGBfyY5C6ZP9FB5SaIB1th8AAxB+0Ncp1aogKl26wyNKnFJQkxDpS1jfhspYy2
	yy+R72W+ZkHzarEAOAf6hC+l9Kg2spllrOhxQkzAYBr3MTeUEQ3ifGvnBTJpXUTzh8a9xHOVYiv
	pK2WvNtUdqIC5gVCzs1zULMTKac/9cTRl3J2ZIalmFDShkZ6TMyybYX52RI0E+nrXKaPV5+Wap9
	fakAB5MG6ecgaOHnt24d5bXzs=
X-Received: by 2002:a05:6000:603:b0:43d:77ad:ebee with SMTP id ffacd0b85a97d-43d77adee92mr20205856f8f.9.1776261808536;
        Wed, 15 Apr 2026 07:03:28 -0700 (PDT)
Received: from yocto.. ([2a02:3037:600:3ec1:dc49:d3d2:7f37:6734])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43ead3d5f11sm5883236f8f.18.2026.04.15.07.03.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 07:03:27 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Subject: [PATCH 0/2] md: small cleanups in MD driver
Date: Wed, 15 Apr 2026 16:03:17 +0200
Message-ID: <20260415140319.376578-1-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This small series contains two cleanups in the MD driver.

Patch 1: replaces a wait loop in md_handle_request() with wait_event()
Patch 2: replaces a mutex_lock() with mddev_lock_nointr()

Thanks,
Abd-Alrhman

Abd-Alrhman Masalkhi (2):
  md: replace wait loop with wait_event() in md_handle_request()
  md: use mddev_lock_nointr() in mddev_suspend_and_lock_nointr()

 drivers/md/md.c | 10 +---------
 drivers/md/md.h |  2 +-
 2 files changed, 2 insertions(+), 10 deletions(-)

-- 
2.43.0

