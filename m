Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3363368BF
	for <linux-raid@vger.kernel.org>; Mon, 22 Jun 2026 11:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782127755; cv=none; b=oEJzgM7OowjAdz2X95UMo1lK8xZ/KJjwu6Jt82fzl6mRyf+VSJ/yHLs6sg1RJlHNZGuDWN2uaJrsGcqHR4yuOYNNAiGxZ9V0UHgVCL+LwF3W7+pzr3ouVXiAwJ9PGzljPhg/4r1SPdMTodSCMdVwgwfkOlOhuLH1qD+on4PG8Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782127755; c=relaxed/simple;
	bh=CQ5iRuASP/6zaZHbr6pg/X1qLK2SKrbm3fI/MPK5v3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uv3T4x6RMxJmsgR8Oq5lB2MrPD/bFTHa5Tnrmv6whr2uZDk7FB2eSTHJ7WblqNakrTTHRiJoiJf6IYuW9S+mJys5ZONCs7vWJ3z29ZEo8UkDJWaNjCTKyrNjbQQO0ELgcJJbstg5mf2XH4z744M93nvUkFByeqv0MTkOQHEQvuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PcI3849s; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PcI3849s"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-36b9d265355so2249564a91.2
        for <linux-raid@vger.kernel.org>; Mon, 22 Jun 2026 04:29:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782127754; x=1782732554; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mbU20Bb7VsxF0bOTSg6979laICbrtwC64LAcDXqiOZI=;
        b=PcI3849sH/PxfqGtiPcl17rtGKSLRIvJ74Uo87YKsdGEL9AB9jHcFCvCGvE3xmGKsq
         Lg/p4wNDTlhrb62QIkfrG1pZRqK/4CXxP9FHrd57ofhg8dFdhuSOn+xBycR7GtzYDTuA
         HhDmBqhiXBt3oMstTvLHjbkNgx4Ihe5ju4L9ZOWYhYud4dqr0ZIFFQvCLgDt/GeUgo03
         u5CNObKSo8/7cgF6OKbHVWzdjTTWN7hkFirBiZ8iIkYD7BI0Am6nt8m+JQZROMf2kjBp
         A0duAcp+mhH5v7dhTb3zTWSvNuGBczNHqWlFxA/+gfpD5JgI5p4X8YA07kz5dKvrQGKq
         uXQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782127754; x=1782732554;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mbU20Bb7VsxF0bOTSg6979laICbrtwC64LAcDXqiOZI=;
        b=Na9YkFzG1AYjCUiU7C16WxR6SwQ4PuWfMtH36gz1OaYFmRGp0NePe1j5JeHoThaOm0
         Rfpx2NMW1tX1hsTKT0byubTRbWWUGugkRCtSOKPqTtk790GjCdy6vXujECavQrK5O0Ti
         AbNVmywVgLv1rKIvs0lsSCuajuQg6/20xlGXIYwv5I2+IzPj0a8C82Wq6gskPNI87JFU
         fP71OUWcOnY7++Y1FMsMoyNVYVZ9WqPhRNjP4yYppI5y1suTU2m/AMXiHUeOyETLdqvc
         WkwVxXApA/cafChLBhEG5n92ie1CgXCmmrkdVG56UjNk38RRi0wsv4AK7VVqeRYNTR7i
         UD+A==
X-Gm-Message-State: AOJu0YwR0g6VfSS4RvkqPcQJk3mP6HqxA2s1R/BuDDCxOuKS9c7CFa2t
	mAKYDKgiOyMbDgkQDTDeB0UJpFnz1lRijoPx/a+C8PB9aNi03ObiIVNd
X-Gm-Gg: AfdE7ckwaxa4cp5fU03Q2bqPlhghYgdMyhIWfYCl/exjxvFDfvq1yZEfHulxOqs3Ecu
	tFxv9en3nOUsZOadA6dMsKUAfJFHDOY6w+W0BMszrY1PlOrfWjPqQvHzQLYucTjWl/+aEGDNkZj
	L0nGkUkjY0PZUhZvlfLM3D2sa2UUhflnMCHltYzNALg3pc2As/OnVdtKed83EyRXoNS5LIeCMOZ
	pv7LXU1nx85kWTI5TMel0xNYBZjScqNQRbi0bvtcZCm+j3SLP3usUvwhZuc4pHlKPmUIeugPOL2
	iumIlkTaxYpKznbktVF9+m0zamoGSLaecfAdqpp4YsV3NxXsZ3oFOOSSmXSxcHZGIZYXf9LCHm8
	WjZvvwcIVNIafrT1mlXPDwzRMi/B8K2Mp70pD5QWttDyo1llx+KD6eFErbf034n+LgEW0EOtXcL
	KFb+hgKWHeFyJ9dA==
X-Received: by 2002:a17:90a:fc43:b0:36b:944b:fd81 with SMTP id 98e67ed59e1d1-37d160055ecmr13971819a91.4.1782127753871;
        Mon, 22 Jun 2026 04:29:13 -0700 (PDT)
Received: from fedora ([106.219.196.189])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37d135e2031sm9898801a91.0.2026.06.22.04.29.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2026 04:29:13 -0700 (PDT)
From: Sajal Gupta <sajal2005gupta@gmail.com>
To: error27@gmail.com
Cc: linux-raid@vger.kernel.org,
	song@kernel.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	me@brighamcampbell.com,
	linux-kernel-mentees@lists.linux.dev
Subject: Re: [PATCH] md/raid5-ppl: convert pending_flushes from atomic_t to refcount_t
Date: Mon, 22 Jun 2026 16:58:55 +0530
Message-ID: <20260622112855.42685-1-sajal2005gupta@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <ajkVDGAdveCH_urr@stanley.mountain>
References: <ajkVDGAdveCH_urr@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Heh.  Yeah...  There is not a chance I would merge a patch like this
> without testing.

> It also really feels like an AI patch and you're supposed to say when you
> use AI to generate patches.

I wrote the code myself. I did use Grammarly to help with my grammar and
phrasing.

I'll send a v2 with just the break fix.

Thanks,
Sajal
