Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF98E329F12
	for <linux-raid@vger.kernel.org>; Thu, 11 Sep 2025 00:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757550249; cv=none; b=Jl6phlYI1i3eE2LlSXzX8/UQthRxYbyJgFWnmnytkbrsc8EYHchmXIxrs6pvCONUmTg/voU3ZVrmH22tTvV1dcy+MRDXen0sAEUHG/rofOhryeN/99E1Fa7CUZQ1QxlR+/rILgCjSiHMw9sVVPBNaiezcbhfYrxLaYmwvdEEJPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757550249; c=relaxed/simple;
	bh=qUdeIgHd1H/gRzOkRxjDb083t96xp1CDvpLuyVz7iCE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=K9bcgfo723o2+lYWY+7xzgRNOWW+BQD82XrNsfqJxQyJ0uBjjjJVMBLo3jUEI39qttGdFCHdf9Lp3ALURpeebY3Ek9MF6yeqVLqh9f4Q680+LMBAFn/wtl+Gm+WypZVOE8vAXTQVNUoy54PjzfBq3mndK90p+vPJ3hVAmQoiyPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=HG3VRjGj; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="HG3VRjGj"
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-88428b19ea9so32763639f.0
        for <linux-raid@vger.kernel.org>; Wed, 10 Sep 2025 17:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1757550246; x=1758155046; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qqQF9ujtoYtNLZ3rwwE148hM4Ro9xnZ4FQwRMaFPQTI=;
        b=HG3VRjGjfTQ1pdJ8AC+iaDKdAHagZ5L++24d4JJlSePTBnTS/JlIwws0we3wKmiZJS
         0MTqgk1yc1DYpb9XShumTDBoQNKGzA62AjZn9NrK1QVWcTelsu4D2rbYv59YhJ1SKt9j
         +R7s7n7595uszBq0LyJG6BicKc8Wv46rGMijMUEDeEtLsxdPfDNQU57MJC/LvCXTBKIg
         TDcqxBIDjcxPj8zdTA9pKKYah301iX29qXo7z694af2yTtnNMTibjAFShoUXKvRkfySK
         3fc6MRbtB/hWBuk5sEXaVNz3XjaHxX1XktuJuhzaCJTWxjCHz0X9KTN95pckpLnNaFeB
         UHZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757550246; x=1758155046;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qqQF9ujtoYtNLZ3rwwE148hM4Ro9xnZ4FQwRMaFPQTI=;
        b=sB/LUEXlHXpl/9rYQWvxspMgrkq9qeaGUShRiUQ15fy1ey3/tfdTCLduQKVZqk5NpQ
         BVJM0QSHfIXK37HTrXQN0tqzLQRr9i1Oi0QTgp+qDQLw+Cj7mJaO0YKzamiNJBEoH/A4
         Ni91lZk/kmRD1EEHdmP5h5IJnVTaJoQRko3tZVcwrgRkQLWdsibpnQLR1HHfbclUWAMg
         zFi8rP/faJfphnDwmkub7ekvBfAbrXXVjcwS70qmZs7p6jjdUyLQKTvminmlH80uKObz
         2eFoi4Jo5Kp/nZ0EyXc13QelX3MQgeYeKoLtTt0dzRfJogFe5BT3xYDMTJ5WFeoD1jqM
         eBqQ==
X-Gm-Message-State: AOJu0YxulWnWDI6qVlLgoxSDEXmFOJRo/l/Ux5HjFyuAxoOkvdY2Kbka
	MldFsZh77oLl/ud0nlzDzr4qSsHLm6AGD/RYxcYF731tzq55EBLxLq3Vd/VMfBVLtaY=
X-Gm-Gg: ASbGncsnmdzuqPYhLBgymTWjCPC7vt5L5mSntNvN1HaRFD40FhCEVVTNsW5e6tD4tKf
	tMre8ZQCXCOdaMq8rufM85e7vzxW2ODjmYs1gtcKK92K2/ZXBfYXtejuyw5uDIqFVNgQaHA1/Y2
	YnkOUeE6lq5Vpfvjtb2DxZFLOHKTsmqFB1kIQtNU6Y5EFYWIDImAlDF/wIi/Klk61N4GGFX7Sy3
	WYUpwJwCORVQK4dSfI4M89dLEKCH6KuclEuZpP4uRELLs5Ihj40lUgPA3UIe7QbMemhELLJligb
	lxIyGeZB0Gm9Aewd2cRRV827U6xY+S4RhXBaVoshxZlQl33RNRNLEHQozUFl264WysO35h+c
X-Google-Smtp-Source: AGHT+IHOpts6PVtb95Al/bNQQ1qhB8ljPd6T6n47gEgj2bnO6EB5y7aCVxDcocz/y27CAZKkBJJjjA==
X-Received: by 2002:a5d:9496:0:b0:887:56c3:e6d8 with SMTP id ca18e2360f4ac-88ec3362a7emr225090439f.8.1757550246549;
        Wed, 10 Sep 2025 17:24:06 -0700 (PDT)
Received: from [127.0.0.1] ([99.196.129.100])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-88f2f0f9a03sm5557039f.17.2025.09.10.17.24.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Sep 2025 17:24:06 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>, 
 Li Nan <linan122@huawei.com>, Nathan Chancellor <nathan@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20250910-llbitmap-fix-64-div-for-32-bit-v1-1-453a5c8e3e00@kernel.org>
References: <20250910-llbitmap-fix-64-div-for-32-bit-v1-1-453a5c8e3e00@kernel.org>
Subject: Re: [PATCH] md/md-llbitmap: Use DIV_ROUND_UP_SECTOR_T
Message-Id: <175755023939.60476.3963353529532795428.b4-ty@kernel.dk>
Date: Wed, 10 Sep 2025 18:23:59 -0600
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-2ce6c


On Wed, 10 Sep 2025 13:47:26 -0700, Nathan Chancellor wrote:
> When building for 32-bit platforms, there are several link (if builtin)
> or modpost (if a module) errors due to dividends of type 'sector_t' in
> DIV_ROUND_UP:
> 
>   arm-linux-gnueabi-ld: drivers/md/md-llbitmap.o: in function `llbitmap_resize':
>   drivers/md/md-llbitmap.c:1017:(.text+0xae8): undefined reference to `__aeabi_uldivmod'
>   arm-linux-gnueabi-ld: drivers/md/md-llbitmap.c:1020:(.text+0xb10): undefined reference to `__aeabi_uldivmod'
>   arm-linux-gnueabi-ld: drivers/md/md-llbitmap.o: in function `llbitmap_end_discard':
>   drivers/md/md-llbitmap.c:1114:(.text+0xf14): undefined reference to `__aeabi_uldivmod'
>   arm-linux-gnueabi-ld: drivers/md/md-llbitmap.o: in function `llbitmap_start_discard':
>   drivers/md/md-llbitmap.c:1097:(.text+0x1808): undefined reference to `__aeabi_uldivmod'
>   arm-linux-gnueabi-ld: drivers/md/md-llbitmap.o: in function `llbitmap_read_sb':
>   drivers/md/md-llbitmap.c:867:(.text+0x2080): undefined reference to `__aeabi_uldivmod'
>   arm-linux-gnueabi-ld: drivers/md/md-llbitmap.o:drivers/md/md-llbitmap.c:895: more undefined references to `__aeabi_uldivmod' follow
> 
> [...]

Applied, thanks!

[1/1] md/md-llbitmap: Use DIV_ROUND_UP_SECTOR_T
      commit: 7935b843ce2184164f41c3b5c64e9f52994306f4

Best regards,
-- 
Jens Axboe



