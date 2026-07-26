Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C146385D9B
	for <linux-raid@vger.kernel.org>; Sun, 26 Jul 2026 12:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785068730; cv=none; b=XDpeCk/+Am7xbCyhxkUNSRGpT6Qmb//WDBcUc2NbYcF58gR2+8VEMVYUhghAt1i9GxYNWTwvU7GGxxqyYs8AxuHfDgYV7wsAGgfvOCMKV2ZoMj44uk1mLnolfRk+39yWL6RdqbJHX3Y+KkmS0Ls35JCXOCeeOKORqSqzUmOw5QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785068730; c=relaxed/simple;
	bh=Ipj6jreHBj+6u7GvvzVRJRGDuwHH9/D6tZj+tUPi2sk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DVoEbTNmi0jdZ7UL3u+/dHKOLtzIit9i9KRXBwgPnnyj0rc3RaAnS0IFJBsA3zeUEQPW4rsYzugsGWI2S9jiSC+rwmBgtwPWpuQWBTetsGR/Ym9LFAfJx6LSg6rQP2ZbXR6onT4eX74x7GG1MwBU6gHD50mWWqwI25zdmDctaxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=CZkt6m6Q; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="CZkt6m6Q"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-47f7872abb6so1013221f8f.3
        for <linux-raid@vger.kernel.org>; Sun, 26 Jul 2026 05:25:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1785068727; x=1785673527; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HEYskQaxFlKY75p8a39Quztp8Jwu9IuaZPo/kSJLv60=;
        b=CZkt6m6Q/yxMzB7CQeCsXW7R0kXNvdh0WF5tFT6H7jEOo+dEmNjqty7zZjIJ0oIVZi
         F5dsiH+6Cw+GK4fgbgsXdKZGdAVSSMJ0hU1xMtAYBRsF7uaHGV2aSUR/xBtXclw5ZE5A
         R+2KjkJzWeWuaZ2hYv4RlVImQXc2Eq+/h0GTZ/H6dTK4R+2YQL7bFOTDyOluVOrCww2n
         4LsuDvLNkY6KbOL/VdpkZgaepWu2cDUKgc19NeFZQf9ycoN0TBv/9H9gmB3CshnLggZZ
         P/Isln4ujLN4jWHKi81kxMJc4NKRrd30ekYQcNNaEx5u+KgEKFXtig8sNUeF1Elb9Lao
         ei7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785068727; x=1785673527;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HEYskQaxFlKY75p8a39Quztp8Jwu9IuaZPo/kSJLv60=;
        b=OA/VUcDcOjWp46YNVFZ8955IRBHwDBdI6Rqfxg6jaiesWSAHGcmJiv01V6cga8aSmg
         Y1JsJkHd6khJq3UKh2W5/W7SrWPlJ/wxPAgZfNepco+BXzdcrJDWd0ms8lKZG4SI1DOc
         52HbJqItvG6a4/TvxazOBfOGD12xWMjRns4kCqY4Og9sABjrv1ponf7C7E+WISNP2zUW
         4D/6pjGPp//d0micda25o0HFW5B3W4qIMHEA3g28Dr93fJXtdnk9wzICR9rGPbrlSaXr
         e+KwSIaO4Y24vhLbOe0FsZMxuiarGxXQeR+AMUtIfPJlbT9Ld9KpnNPrPoMufBMR+r12
         WlTA==
X-Forwarded-Encrypted: i=1; AHgh+RoVbGN0l8rRMUAUtG1xwrKLH5V13vHr0DBThgbtmr6j7N0efP004SUeyarbJOB9j6kdrBqqutmjU7am@vger.kernel.org
X-Gm-Message-State: AOJu0YwMnJxnXuZwl5KP3GggU//Hh3tnngFNCofOMNhp8JYkPB1OLWw6
	ah5ppu+x9mW2hvA+7Oa+kzi6LsrpIZKHImuxx+aE2y/4J2MjXsgVqtwHleUrAciuKg==
X-Gm-Gg: AR+sD104WOFJrFSWGLignhTrvOh7yMNUAZVlHE9PPx2cFVbhf+OTIJHLKzHlmFBZX+h
	dUg+dxRTl7HJdUWR2ei4OeX09vfCZkTmEXnpPdKRTR80T/ejHoGVCnwqkOm1AyhEEragPqX7Kh2
	rYu8Qrw2+MHxRGL1eZc2O3cxPAL0jRJcvMLDe013KSKwynHUSErRqgIYv75sXHmL11Beq04qpfh
	99h57/TYJpxL8wi3GLxC5Qw2uFMXqoO0hb51vZkxkkVEUsERnKbKbX3QKIcMbp+/1MuiSQ7M+so
	SSquayuXwo16/mMVakv+vGCl1jFjQzu49GaLvBe6JiMuJniw7yQQ7o4T0K/q+zLW7a8Tn9aNSaN
	CilOgvsHynZJSLcA9XCbvmaSI6n1Tq5OuMSnKO45ef+vymy5ah3gPRk5/bbfx+BgYbiHs3W6A7m
	rMLxOZv3GkGSa3uApcYd2+sgvHjO9TzVLkt1wGXMg+XntFGzbgMCbEekzneWWoaHgeeVbsNTuz/
	9BjDCxsiZW5r0KdzwS9YZL+SxZyZ5WelVnsUT4ghA==
X-Received: by 2002:a5d:5f45:0:b0:474:64bf:8fb6 with SMTP id ffacd0b85a97d-47f9fe940b3mr7250775f8f.39.1785068727480;
        Sun, 26 Jul 2026 05:25:27 -0700 (PDT)
Received: from meshstor-pc ([185.87.42.56])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85c6dc25sm39259619f8f.33.2026.07.26.05.25.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 05:25:26 -0700 (PDT)
From: Mykola Marzhan <mykola@meshstor.io>
To: Yunye Zhao <yunye.zhao@linux.alibaba.com>
Cc: Song Liu <song@kernel.org>,
	yukuai@fygo.io,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] md/raid10: fix still_degraded being inverted in raid10_sync_request()
Date: Sun, 26 Jul 2026 14:25:10 +0200
Message-ID: <20260726122512.2176105-1-mykola@meshstor.io>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260723135535.101995-2-yunye.zhao@linux.alibaba.com>
References: <20260717062743.128189-1-yunye.zhao@linux.alibaba.com> <20260723135535.101995-1-yunye.zhao@linux.alibaba.com> <20260723135535.101995-2-yunye.zhao@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> -					still_degraded = false;
> +					still_degraded = true;

I posted the same one-liner on 19 July -- flagging it only so it is not
applied twice:

  https://lore.kernel.org/linux-raid/20260719144227.940444-2-mykola@meshstor.io/

No objection to yours going in, and I will drop mine if it does:

Reviewed-by: Mykola Marzhan <mykola@meshstor.io>

Identical hunk and the same Fixes: tag.  Mine picked up Reviewed-by from
Yu Kuai and Paul Menzel on that posting.
Your changelog is the better of the two: it carries a measured
reproducer where mine only reasons through the failure.

Your patch 3 and patch 2 of my 19 July series hit the same unit mismatch
-- raid10's recovery cursor is in per-device space while its bitmap is
indexed by array sectors -- but at different sites, and they do not
overlap:

  https://lore.kernel.org/linux-raid/20260719144227.940444-3-mykola@meshstor.io/

Yours converts the bitmap-reported span into per-device sectors inside
raid10_sync_request(); mine stops md_do_sync() handing
bitmap_ops->skip_sync_blocks() an offset raid10 cannot interpret.  Both
are still needed.  Yu Kuai has asked me to re-check mine against his
llbitmap reshape series, so mine is still under discussion.

Mykola
