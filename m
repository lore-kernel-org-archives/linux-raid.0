Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797C034DCC8
	for <linux-raid@vger.kernel.org>; Tue, 22 Sep 2026 04:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790052369; cv=none; b=ff/vh9EKGpUZZU4pE0eOZzao74TXoFTCEDaVAXR5sgM+gCdyBMk4aifI3IORvvMzOt3X6PqjQIX7zpekuA0UxHR/CxBd0G15Z+yNZELjizHDZh3E0pfe7vXvMAyWClKVJU/oQKsqiECbeV88y91UpGcfytIebLBEgGdl3ghJYJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790052369; c=relaxed/simple;
	bh=4oGFoAucb3tbHa8WwuUU9mOHcdoEIPXf4i9GftWnm6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CJuEka82VQZD7r2HjzJt7xEMwnH88pLtp+qQb3++TNHkAZOYQvZF50LaaZUs/fGCtlre5jgq0g6/6kkI9SwFNrZEiecSS14ToJ956tBznsyNJkwpyZRdgppRvYcR7KM5OkYSeQCLaOwaFyrQiYFLuV3F+jW8T5CwOvmC96WsPlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SHzVPJKW; arc=none smtp.client-ip=74.125.227.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SHzVPJKW"
Received: by mail-pj2-f43.google.com with SMTP id 98e67ed59e1d1-396ccd4f99dso3957294a91.2
        for <linux-raid@vger.kernel.org>; Mon, 21 Sep 2026 21:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790052366; x=1790657166; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yu4lnjkEeLhSQSw/zgoMmATHDwmlodTsiLJw7uhCZBw=;
        b=SHzVPJKWqjwc0jLYJ18n5wY9h512UWGP+cdiFuI/SLohhsFQXeucSGra8pSmfXZ1Rg
         FiJgC/Mlf2fMkuMRvNrW6/wSr0LI1Unzr9r34f8fU2TbneKJSLRm3Kc4QPcn3ErOAE9d
         951+z2ZP1fpYJoiEHyepmM7FyUsderF4hUWASi/ib35+mStKX6UOMgLEzHU29gpvWV94
         LrPqiUh8CtxjB08EUA5rXERQt59rO2ilcQQGDXQmo6HpLXRG+uV/w4jXKhljheM4JN5S
         r42jd3MpE0zxW9L8nAtKARI4BX0zifC/x6hfts1XCET424rYNPbDf5LK4Ciqa3ZUBbfh
         i74A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790052366; x=1790657166;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yu4lnjkEeLhSQSw/zgoMmATHDwmlodTsiLJw7uhCZBw=;
        b=tz+l3NV2Qw8VKcA0UeqQx91rpzbc0XW0+DcXgkSd4BPbjxwpJhkzMjOkK1FrwL9sff
         pTHuUmVgCGZ9zJFMIpL2GWMhGjaAtUeYoDmueKPmWZdYnVeFJW6dJDrM8xn3loDqcmFm
         tn/IVVUUIHCrUbgQ2HGdrbinYQYzFdjJBKoJ1YEmqgH4MTo/s494nfGDLr14YMWp87mn
         Z4VA5x8Qzpd5PG5cEFlsH7MJYucfFwSI5wLyFbqJDyWQzVtfDKx5TH1m4pAhImQhgbLs
         wqarnqUQsEYVlH6mPRYUJjF2eq+XJY3e71JvN9zbjc1LaXjdv+hwT/H9n2upI/wbv8Hc
         QF1g==
X-Forwarded-Encrypted: i=1; AKwUvBwGCaQ25J1Cb6V54In8KFyrS+VA97zuz1SCJEUMXX3SaQR6xJhQ3iAuWKK8xCVOj7Cvy6naKeVTDWYX@vger.kernel.org
X-Gm-Message-State: AFuF++kWDfZPdSdRxrfHEcIkE7Jl+Su0BMbJb6YXjTPlCPL0UWLE+fiR
	xYQTKELbVRS4LSVh9efNeBv7TizYOXWAJqLlgWDjKfeMNIJb5hVCqQw4
X-Gm-Gg: AYBFou3fkpJYN4B1TQ9lO/knRCuBsxVQhdmvZF0/hIIP0u/KSwJuOg8hyiv5vNFw5eA
	1uMKTXcqBGi6+ucl5iN456PAnNepEIaPaiYv9ZuRg8kZXJUZ2PwT2cfF2VgziXDGXpDyCpspSJF
	YBp9e+CPBASPuhArV63pj+Pkaab7IqBFPU2F/a0TWzpxEoFw0syYKIuyVxjhFwOpNuD0FRbbLvr
	A3E/rHXxB1UDK/YiWu7hAF1ETXpdXt/5VBkWvOFqPf/AZ1pGmJRDRdhOMIQ5f30+sx5Lxv++eAp
	ccRyl3UM1xxhvbqk6rcW9GR0/hx1PB6C9fKz8AM2gPC1n7ukacJH6cmi6Mw0zCBzjKdAqXrcsoG
	3m0FIAci+lKBI9ZVXhjvS5w7uzA25gXYPkDZJPWAEYan9Yh9anUHqb0TJ7hjmSXyyY6JnOfUb35
	rRYsIfjDk7RsUgKIu/r39VuUQmdfvjfMBdfOp/3h4ckyaq4IFTJNrG4pzy35/uBG4Is8xHhKUNJ
	UuCYGQ0UigfS3YLtjs8dYSlIJgjYjaHcZGgTGE=
X-Received: by 2002:a17:90b:2f47:b0:39e:2f57:67c7 with SMTP id 98e67ed59e1d1-39e54cc6240mr18299564a91.3.1790052366112;
        Mon, 21 Sep 2026 21:46:06 -0700 (PDT)
Received: from localhost.localdomain ([2409:8a1e:2e81:7320:3443:b4ea:307f:cc4a])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a06e26e70asm1152325a91.1.2026.09.21.21.46.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 21 Sep 2026 21:46:04 -0700 (PDT)
From: Yuchao Zhang <ndaugoing@gmail.com>
To: Yu Kuai <yukuai@fygo.io>,
	Song Liu <song@kernel.org>
Cc: Xiao Ni <xni@redhat.com>,
	NeilBrown <neilb@suse.de>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Yuchao Zhang <ndaugoing@gmail.com>
Subject: Re: [PATCH 1/2] md: fix bblog_size-driven OOB read in super_1_load() and super_1_sync()
Date: Tue, 22 Sep 2026 12:45:56 +0800
Message-ID: <20260922044556.30746-1-ndaugoing@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <fad92649-e362-443a-93ea-205b11247e6d@fygo.io>
References: <fad92649-e362-443a-93ea-205b11247e6d@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Kuai,

Thanks for the review.

The 'else if (sb->bblog_offset != 0)' branch handles the valid on-disk
state where bblog space was reserved at array creation but no bad blocks
have been recorded yet (MD_FEATURE_BAD_BLOCKS clear).  A corrupted or
forged superblock - hardware fault, fuzzing, or a malicious shared disk -
can carry an oversized bblog_size (e.g. 0xFFFF) in that state, bypassing
the existing validation in the MD_FEATURE_BAD_BLOCKS branch.

When the first bad block is later recorded, super_1_sync() copies
sb->bblog_size into bb->size, and md_write_metadata() then builds a bio
larger than the backing rdev->bb_page, reading past it and leaking kernel
memory contents to disk.

You are right that fixing super_1_load() alone is sufficient: the kernel
never modifies sb->bblog_size between load and sync, and with the -EINVAL
check the device never enters the array, so super_1_sync() is never
reached with an oversized value.  v2 keeps only the super_1_load()
validation.

Thanks,
Yuchao
