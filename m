Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5917E2E634
	for <linux-raid@vger.kernel.org>; Thu,  6 Mar 2025 15:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741273513; cv=none; b=pm5pB/eARv4yUoDKhsvTrUy5U2OXISD8AmD/Bsu44QSxxhzy8L392JsUKOIvp7S/m6ZbFDCzlmei4mynA8df43MYPXwM9kkb7XWOrsgZuA4hIvL8defi4TicJU77CvexKgNV8x9USpMc8fNjUaSMjyQvNOorGX7PzG3/8iD5Gsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741273513; c=relaxed/simple;
	bh=TK7VGJ9wAuiaUqk6rSlvDmS9VC/uE/WDIOEUN3K8tI0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=dz6aTuKf1CNpdRezYf7VIh0AiD8e7n08MnckY3CH3YGajzv37sRUxrogCk1FzCk8nnyQl8Iw1x2nDevUWmsLw5Urdy4JlKEDuuIxR0LHIuN8GhCWvCvLEk19q4BP4nt8fdXoGxKCC7wLfW+MYT7hP9Hny3mUGrI4+pT+qDWXfyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NvgHTTU2; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NvgHTTU2"
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-85ae65ba2f1so19974939f.3
        for <linux-raid@vger.kernel.org>; Thu, 06 Mar 2025 07:05:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1741273511; x=1741878311; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0mxhfe662mFKXoNMPrYea9QmFeK+eqDDltOasYkoZcA=;
        b=NvgHTTU2TllHBEQWB2pvDA/nfQKDVLudgEdr0YEBWbOa1T6vXQ7rR1iOv3mQfPrfJH
         B1aqThg3vk/KJp9QpV7acjALcfdhJ06C3hnXRMIlf5d6BueokYIQT4O0ce2hyMZm4UPi
         ua+dMMX8rMpepOyzjj5ccMSLPVcw7ZJdAHzpPXRZGzDUg3WLdJLQtYWuQZ2YQRqYfxs0
         g5vc2I3+UKMBsBwaaHUlf7mqC2dtTTQf1Y2Vqc6+ogJF4RJy2E+LmZ1u+sBpvh+FriTb
         Gz3C8qLsd7EPk2mWWF/VbHbH7c2hYy2vk7WSyJn3mg7ttzxchc8xxs/vr3yNhP4IqDeW
         0xag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741273511; x=1741878311;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0mxhfe662mFKXoNMPrYea9QmFeK+eqDDltOasYkoZcA=;
        b=c6w/1zWKuUT96sf5RTiPgRYYycv00u8alUK1vcZEhZBGhBwRpb32mQAHKdsy5lDiwS
         Sf5BdLMqCKVNmQnAcwZIu+VFBbczSbO1RwPxfAIxyglT2Cd2CaKU0nADPI1IIl1GBiZ4
         kAB4T8YCnNYYGRh6Iv0KATDd6pb2zWB+lppZ6vbdJZTPrpcx6OGtm6yKrpdTdvGe+6NE
         1+1cEDq0KsaXcvmjU4r7ls8XpLbXqjZ37G29e+qztqjJYtDZIr1gVqaKtQFDiHORQvI5
         1Bf1tHiNOhzIUHsi4pOO7N6rkt0sR245jj9c2Sw5SYXIxnMSd+tE81bE4tO54WxmETby
         uVjw==
X-Forwarded-Encrypted: i=1; AJvYcCWYa8/pVZmgTTAvPcnGBFSAoktlpfMP4z+OsO9CI5WgPUnFk89WatHc0upHjuKlof1hKdhf8cOnwfNZ@vger.kernel.org
X-Gm-Message-State: AOJu0YyNEuHy2KT7c8HFOqrPis1Bjq2Kanr3oj8oD07F3OJYrEE114uZ
	cJl64vhUx75f91bHiNURFP1FuwamxLKUNXYScpvU5tC1eVBNPDdjOfgVhOZKHeI=
X-Gm-Gg: ASbGncvAXuUXt5iyR7QLjckHpzo7j9hkDHDM+7WX/QgPyOcolydJXvINNuKfRAmf5rY
	UFmf9Jc93uR3iIOiOPrYttt7wYGVDMYC3yPJ7dFHzxxRHkcHQvNRhV1VmoDm1LgyCpNtGxxaCj9
	jFsWc1DNblCoujtgFv2t+kP//UhvQisqTDhacswTK1NfMCWlWa4LPvvKuVgVdPAOa0Dd3C9GuhY
	pbKGKStK86d1zUF/oozwIp2WnVjbq272XzHYecz4+WRDs965hggl0cjnY1No8gxQhsowulf/07j
	ZhLSJ1MPNRR+ts6UyOWI2+dXdPjJrZ9tFM4x
X-Google-Smtp-Source: AGHT+IEqAuXd7afnd0Dt1HKumrunpDNZSQhc5PKX/Hjsq7JDKDGmQ5oF9rxSxlYeY9IOKZII3LXW2Q==
X-Received: by 2002:a05:6602:36c5:b0:85a:f63f:cf06 with SMTP id ca18e2360f4ac-85affb58d03mr901346839f.11.1741273510171;
        Thu, 06 Mar 2025 07:05:10 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-85b11986819sm29718039f.6.2025.03.06.07.05.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Mar 2025 07:05:09 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: song@kernel.org, yukuai3@huawei.com, dan.j.williams@intel.com, 
 vishal.l.verma@intel.com, dave.jiang@intel.com, ira.weiny@intel.com, 
 dlemoal@kernel.org, kch@nvidia.com, yanjun.zhu@linux.dev, hare@suse.de, 
 zhengqixing@huawei.com, colyli@kernel.org, geliang@kernel.org, 
 xni@redhat.com, Zheng Qixing <zhengqixing@huaweicloud.com>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-raid@vger.kernel.org, nvdimm@lists.linux.dev, yi.zhang@huawei.com, 
 yangerkun@huawei.com
In-Reply-To: <20250227075507.151331-1-zhengqixing@huaweicloud.com>
References: <20250227075507.151331-1-zhengqixing@huaweicloud.com>
Subject: Re: [PATCH V2 00/12] badblocks: bugfix and cleanup for badblocks
Message-Id: <174127350864.65950.963243812292712820.b4-ty@kernel.dk>
Date: Thu, 06 Mar 2025 08:05:08 -0700
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Thu, 27 Feb 2025 15:54:55 +0800, Zheng Qixing wrote:
> during RAID feature implementation testing, we found several bugs
> in badblocks.
> 
> This series contains bugfixes and cleanups for MD RAID badblocks
> handling code.
> 
> V2:
>         - patch 4: add a description of the issue
>         - patch 5: add comment of parital setting
>         - patch 6: add fix tag
>         - patch 10: two code style modifications
>         - patch 11: keep original functionality of rdev_clear_badblocks(),
>           functionality was incorrectly modified in V1.
> 	- patch 1-10 and patch 12 are reviewed by Yu Kuai
> 	  <yukuai3@huawei.com>
> 	- patch 1, 3, 5, 6, 8, 9, 10, 12 are acked by Coly Li
> 	  <colyli@kernel.org>
> 
> [...]

Applied, thanks!

[01/12] badblocks: Fix error shitf ops
        commit: 7d83c5d73c1a3c7b71ba70d0ad2ae66e7a0e7ace
[02/12] badblocks: factor out a helper try_adjacent_combine
        commit: 270b68fee9688428e0a98d4a2c3e6d4c434a84ba
[03/12] badblocks: attempt to merge adjacent badblocks during ack_all_badblocks
        commit: 32e9ad4d11f69949ff331e35a417871ee0d31d99
[04/12] badblocks: return error directly when setting badblocks exceeds 512
        commit: 28243dcd1f49cc8be398a1396d16a45527882ce5
[05/12] badblocks: return error if any badblock set fails
        commit: 7f500f0a59b1d7345a05ec4ae703babf34b7e470
[06/12] badblocks: fix the using of MAX_BADBLOCKS
        commit: 37446680dfbfbba7cbedd680047182f70a0b857b
[07/12] badblocks: try can_merge_front before overlap_front
        commit: 3a23d05f9c1abf8238fe48167ab5574062d1606e
[08/12] badblocks: fix merge issue when new badblocks align with pre+1
        commit: 9ec65dec634a752ab0a1203510ee190356e4cf1a
[09/12] badblocks: fix missing bad blocks on retry in _badblocks_check()
        commit: 5236f041fa6c81c71eabad44897e54a0d6d5bbf6
[10/12] badblocks: return boolean from badblocks_set() and badblocks_clear()
        commit: c8775aefba959cdfbaa25408a84d3dd15bbeb991
[11/12] md: improve return types of badblocks handling functions
        commit: 7e5102dd99f3ad1f981671ad5b4f24ac48c568ad
[12/12] badblocks: use sector_t instead of int to avoid truncation of badblocks length
        commit: d301f164c3fbff611bd71f57dfa553b9219f0f5e

Best regards,
-- 
Jens Axboe



