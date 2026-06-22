Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3D3379EC8
	for <linux-raid@vger.kernel.org>; Mon, 22 Jun 2026 10:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782125844; cv=none; b=khp1+M0hoU9w2KhaWsGzjA47Q83cdNzoQbgTRkJuN6fJZyHN5aVeJ8jMBzRJmwVRlgewSxrJ5io7ZNELau+f0A9Ip9UyS5Pfq2TRVieojyNNc83/IUpunymw1wWJdJEy+Ao2zkWBpUJVQ1pAy8i3u5Gnf53ZeUQGO/0+R0Qk23c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782125844; c=relaxed/simple;
	bh=LWHVuMY1/ncBwfRP7JCD6/Wpmd4uhdg2Wme/B92jfYc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vxq0JFEvc2tVy601maAqQIk0ljyjXlKY0Y05fdvQyVRgWZ5uMJVk2wvpENPteTEEJNa27iC6Nnvgh/mkz9BBSucR34WxwZ+nKZNeb+jk60vgjT+EjuiyZe708EOiC/Lrd7kxbLyAUHG/AmMErY1j/XBuZ757EkQNnivYp/Z7W4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oSlfZut6; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oSlfZut6"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c0efc7ef797so101550466b.2
        for <linux-raid@vger.kernel.org>; Mon, 22 Jun 2026 03:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782125841; x=1782730641; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZWK0XbJl/m0yxPi2tihir84Vy/CVlnAxBTBF0YEc9Mg=;
        b=oSlfZut6cCJMuK/Ce36fHc3OpKYX31CvpkWow7px+VYRHk1I2BuU/+yPPpEHByEkM6
         dtkSvM/N4w/GweK6Pu+TTD/mJfjnaq/vOhTOhyowfE6NKu1ChbX3vZXtoUBt0YeLdrWs
         KV3mtI2NcwVnmYQ6TBn0t0dRhLLBNU7nu9SfAs/pvPUecwGI8VrmqOl4eqJiH/gVWimT
         oqOC96c+okwSJNjmmOM75cQ8HJZ6COhfbORHw2L5UndDBKLXuOjsVK+907q7t1P8co0/
         RRGWS7qKizbrTLNbjgfRzlRRVMT4L6KBqJSLmIj3kUB6xZ9P3oxnzJNouy/Sx03q14uI
         y9Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782125841; x=1782730641;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZWK0XbJl/m0yxPi2tihir84Vy/CVlnAxBTBF0YEc9Mg=;
        b=l4u1ktmzOMo6/thx1RSVktDfjodCYDXralNcw1ofqEcEDHVWteWhvsD7oySJ3bgw+w
         zUUK/qvmIy31R9ssqAAjzgYovC/nyByx8oqoqpTpHjhJsGHF/+qP71AsKkJ8zsTQJwnz
         KtOR2i4ayFV/Pb0hz4ZoQ5W8F4fZIocwl71qRHoZNBDDzgmGD1y7Lp/tPfbIT7fDU2TZ
         3r6EUk1gyaRlRN/EhEurc6ZPtrgksjoAGcQTGiDxGF1XvsAkVjQV1hg1pp7Dx4bwJyuD
         YbT3bMeZ927W5SuUlAbeNIp+iNmSwi9r0aKCyH8Mj/MI4YJVD+hVNWBOk2VbmLn/Q3CY
         pi3w==
X-Gm-Message-State: AOJu0YyVkgrnJ1m/4485dym3igRBrGsgsK2txFix+D/uOALDDn79zHEa
	YnHYsOYtOLvglSVxCxP74l/zD4dkZz4BBxs+N2XxDe0uz1MXzbYdXvs0
X-Gm-Gg: AfdE7cmKX9Nk4KrujQ9nZF/dRDXhqJ60sefn47CBtzAs+qDHA8rORvSPxbgNxF2Fjyt
	h3Jn/ZcI1gvpywfFI4pJK30yoFxp2KSpcSzQ17tG8waJ++oiqwk8FTvU/hiPIO4XvwsKe4lb8S4
	MWna/CrH7vadkvrnQ2/PfbHqiKiHTZ9y4sp4TwdkBJasaNG1NT93ZbI966KQPaF8mxh/1ubie0R
	PIJurchknfPm0PGuX0H2avoDOv2b5CKIHqomjmvg4xOeaSTmxg+JDvtZY1nLaty0Mk5lksuD+mC
	HiIq6FGGYC9E/fsicBWMflVFpHcIFeaKn1LkVtPPJzOFAVUY6yBJ6oJ+MZ0eXlPTsIvQ24iNk1I
	b2N+pPLtDjiadotUz/cFk5MHw3yqGTnGwbUy8KDXSGvQFC2z9sdcr3OyE0QjfISjNErHwQPfkzh
	l1Q7LAXLLB
X-Received: by 2002:a17:906:ee8d:b0:c0f:c475:6bd6 with SMTP id a640c23a62f3a-c0fc4756e1cmr42963466b.13.1782125841003;
        Mon, 22 Jun 2026 03:57:21 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c0c5e99b968sm335639766b.24.2026.06.22.03.57.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2026 03:57:20 -0700 (PDT)
Date: Mon, 22 Jun 2026 13:57:16 +0300
From: Dan Carpenter <error27@gmail.com>
To: Sajal Gupta <sajal2005gupta@gmail.com>
Cc: linux-raid@vger.kernel.org, song@kernel.org, yukuai3@huawei.com,
	tomasz.majchrzak@intel.com, linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org, me@brighamcampbell.com,
	linux-kernel-mentees@lists.linux.dev
Subject: Re: [PATCH] md/raid5-ppl: convert pending_flushes from atomic_t to
 refcount_t
Message-ID: <ajkVDGAdveCH_urr@stanley.mountain>
References: <ajj1yljwrUk0bZwp@stanley.mountain>
 <20260622102859.38034-1-sajal2005gupta@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260622102859.38034-1-sajal2005gupta@gmail.com>

On Mon, Jun 22, 2026 at 03:58:58PM +0530, Sajal Gupta wrote:
> Hi Dan,
> 
> > Have you tested this at all because it doesn't seem at all correct to
> > me...
> 
> I have only done compile test, sorry, I forgot to mention that.
> 
> > How I imagined this would work would be:
> > patch 1: add a break statement to fix the use after free
> > patch 2: s/atomic_t/recount_t/
> 
> > The difference between atomic_t and refcount_t is that refount_t warns
> > about overflows and underflows.
> 
> I did it like this because that is the pattern mostly used in the codebase.
> Simple s/atomic_t/recount_t/ would have
> refcount_set(&io->pending_flushes, 0) in init
> and then later refcount_set(&io->pending_flushes, raid_disks) in
> ppl_do_flush, which is not the usual way. I am treating it as a proper reference
> counter rather than a mechanical type swap.
> 
> If that is too invasive, I’ll rework it into the break fix first, and do
> s/atomic_t/recount_t cleanup separately.

Heh.  Yeah...  There is not a chance I would merge a patch like this
without testing.

It also really feels like an AI patch and you're supposed to say when you
use AI to generate patches.

regards,
dan carpenter

