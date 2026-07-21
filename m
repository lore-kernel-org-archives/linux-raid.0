Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D7D415F23
	for <linux-raid@vger.kernel.org>; Tue, 21 Jul 2026 17:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656268; cv=pass; b=FJgqDwLBC7Az7bDSBixO5GjDq+62qu+Y/AnM0BbXsybpIbsCLfE8XQ9sSDNoDxF7bZ4mQJgCnbl0QXPBAm++q6ixxrbZFIrrdUrgyZ6awj6V7qPDrgOJ/jTfh9iuthnr++xoCozFKgRdEkYARu/Y3J9y2FAyRjnsg5Q39nWQ1lo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656268; c=relaxed/simple;
	bh=fk82OUiWTbfj+Bj8rJw44IZWjsVv95l8951dHoMMtw4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FU8HGdxbHFipaR7DSz4+0I1OHl+LLL9h+b6crfLUsgb83iFMQDndu47RDUw1lEiZPSiDpIbCjbLiBORYD6OZx0t5MNANkPw1Yy9tUypKvNKUncO4GNS8zvh6+Y05zQlXmgGuY3ZM2YhHc7lTm5dg1wGKMYaWe1z2YIoujXCvZMY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=B2YpB9l1; arc=pass smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="B2YpB9l1"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-38e69bdb0fcso2315813a91.1
        for <linux-raid@vger.kernel.org>; Tue, 21 Jul 2026 10:51:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784656266; cv=none;
        d=google.com; s=arc-20260327;
        b=IA8Pty8oOwJoO2lQLAovhzhGJ3cB+u2a1jpYFLmoZbCqym9O7U+Mjh7uA//+TO6B56
         o+HnPRQlg4UI7k1CyCfKt/+BfKEsfz7X1R9sB7okMzG3ctRvk4Qm3sK+072PW/Ob/UVk
         lg1XAgnS6iC7agFBVgKbFz0CxGUqmZFlFzGAKwFRjIDO1ziYvQrzC47+/rLutxlog2Kf
         307fpYh8cPR6RrDtuKIgOs80bqANQzqLjqDe27B8s0L0Lxxw5jc/QTWHmuR6Q2DsO7/C
         vfagm+jRLd8483R2V3/dXtiJRMNCiuEIKnClBokL275IrO48cNeiHXcVEmyioXxIPgA1
         2Z3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=bqJhHZxbGEvXYhualzcQpDQcrx6Nf+L7xXv1g9Mul7I=;
        fh=RXELh+X3CAWPoaTc5ulYhbOTdsWi+XHJqjZh0CNXXaY=;
        b=W39HtYk+B38xMHb6jcThsXvjVs3JSSrxGi3js4DYVGpig7De6FN5wVFC6YLRsdPKye
         yr2UR7V7527C0EO5h33lQtNW62zto3OU1U1f2/GPOWmICnDEmzYfh5COWvhpKpxC4yxb
         OOYQnLq5/CJNXG7ut1NGFPjQTJfXyRN1lE8N7de/pNFIWIuOBVv481kHxwe4GQDW7J39
         mLGDjcGGLkfuUYq56YBCMq3XVp32ilY5n3eGjn3PAVCttEIsl+prVr/36MaP1vJqx1gn
         7H77F8yQI+IDMRSK0P5XoAFSMzgMpjoDwBFqZy41gyjEqPSmlewZmYhigmf7XZsI2CrM
         fT2Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784656266; x=1785261066; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bqJhHZxbGEvXYhualzcQpDQcrx6Nf+L7xXv1g9Mul7I=;
        b=B2YpB9l1/TObhAYO5TnNeLkPfQxNXrt4FLbJyfF4b6YsB+3mtpbrLC451fbUEPr63Q
         NGNBLAOy40rqXGxxjmU5vU/QmC+jmwpBDFL6ttXHav+6+8uSI1bxu2+SDcUQKocYcmeU
         76hn3dxT5HBpSSNFeebJZejdZ4Of6NVZvekz3E/0JEmzyUg1uVZOoqWE3ozRZIz7Yw/g
         aV4g00IZWHMy1bMsdWmPSGpXeuw4SbTJR+fwdbgnVoKtSm6mjyNQNMkQF2BdW73TrjIE
         HHlteqCJSX2KsaZYaghGCnm4F7hyNlV4rp1cwqBvLgVdBAGiQxXY+zV1e3E7rOuSt15t
         wBFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784656266; x=1785261066;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=bqJhHZxbGEvXYhualzcQpDQcrx6Nf+L7xXv1g9Mul7I=;
        b=F+bw2qPfb0Vs5MSLJDsnjuMm+uGGxXoFXpn4c572p1Xw/8p4dW7RxwoqlYAq5j6hR9
         8qUT4ns0L7BmEVa4aeN4UW08EVYbMcuS6NYThTc/jCvyMDORWXDrbJ4UlvqoPYw4Theg
         VNdTpp1FuBkqaCFHJIbAhZJ76W6PL3IYf+IhKbhkc5uG4VIvfTX+TppGjYrKN57Lnm4Q
         GT2X+74sTFRgo85WM3un3Q+sGdFQaKnJvh9ApfcntZsUzhhGY5c6PLzoYYonq0DWN6OA
         wlSWODPzRw9ZwfQRvKlDDECWMUxVYKWBwCe5hAPz0uGxLVbiXgI0aWTJjxUgICIUES88
         qUZQ==
X-Forwarded-Encrypted: i=1; AHgh+RqecJL0Sfx7xSmd19pVWFjYuQt2xYM0E1Str1o25igmS76xaXrl7RhSOOhEwV+ExUfxh/9Kj4PQJs1r@vger.kernel.org
X-Gm-Message-State: AOJu0YyJOAT+H7J0R924SPnGP5O//5wgIEdAItzd7kHRvHSPy0V1oG3f
	gGrFrbSVw3IwSCB60IW1aFHslsaNEeqCkdKRkQT+/yDTwSTh/T3PdIBB7G/xccqn+htw6drrZPc
	gFAcy/JdfNwIKnqrfHbEqHX1ShG4yeJ/szgxVOYI+
X-Gm-Gg: AR+sD13DSgm2a2I0UjYeJOtVRvvD4a6PbbR2tqsRlXIohhvpq2TyzZGhMCbkSJ1cxtR
	RYMtWjQV1mG7JAJeyLJiuVZjffpW3YBskVirzwEYVE8col0gioDzQKhabV8gNGstHYtWv5Nh1rZ
	4rUjj5RtZ55bZp4cjqgny/iOzNvpMnnc1VJ7Y0PXaTaiiYadgGA+ACYBS95a0jJP5sYeIqZy7N7
	TO+B14yBo0HcEivxBVqgEkbIo+qxh0uuOb3DbjeMAuhkn32Gkmhk35oSfmW5EYj/Lc1AqUTozEo
	h4NZxmVVOZGH93VEuErmCwgF046V4O/RdQsXBBUgF/c=
X-Received: by 2002:a17:90b:2e90:b0:368:ed26:15b2 with SMTP id
 98e67ed59e1d1-38e4b43c408mr19724564a91.8.1784656266239; Tue, 21 Jul 2026
 10:51:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260719105327.864949-1-mykola@meshstor.io> <20260719105327.864949-7-mykola@meshstor.io>
 <ee312bcb-92f4-4884-91cd-3bd56180c8c7@deltatee.com>
In-Reply-To: <ee312bcb-92f4-4884-91cd-3bd56180c8c7@deltatee.com>
From: Mykola Marzhan <mykola@meshstor.io>
Date: Tue, 21 Jul 2026 19:50:54 +0200
X-Gm-Features: AUfX_mys0lIoq4Q-xmicA-5OIV7AmcAZv6tYBswRu-bPoovrkHLh5N1N3P5Onu0
Message-ID: <CAPzsNDsLr_BABgizujN0CgnLNfzS3S37vQ133fjbJzFMvRs7CQ@mail.gmail.com>
Subject: Re: [PATCH v2 6/7] md/raid1,raid10: skip futile retries on P2PDMA
 mapping failures
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>, Yu Kuai <yukuai@fygo.io>, 
	Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	linux-block@vger.kernel.org, linux-raid@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Li Nan <magiclinan@didiglobal.com>, 
	Xiao Ni <xiao@kernel.org>, Guoqing Jiang <guoqing.jiang@linux.dev>, 
	Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Kiran Kumar Modukuri <kmodukuri@nvidia.com>, Chaitanya Kulkarni <kch@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Shivaji Kant <shivajikant@google.com>, 
	Pranjal Shrivastava <praan@google.com>, Henrique Carvalho <henrique.carvalho@suse.com>, 
	linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, 
	linux-pci@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Thanks you!

On 2026-07-20 10:49, Logan Gunthorpe wrote:
> My eyes glazed over a bit. But one point is that maybe this could be
> split into multiple patches: one patch introduces R1BIO_P2PDMA, one
> patch for raid1 and another patch for raid10? That might make it a bit
> more manageable.

I have split it in v3 into a raid1 patch and a raid10 patch.
I am not sure about separate "introduce the bit" patches.
R1BIO_P2PDMA and R10BIO_P2PDMA are entries in the two personalities'
with own r*bio state enums.
The commit messages are shorter now.

> Also, I'm not sure if it's possible without digging deeper but, instead
> of adding a !p2pdma_unmappable check to every if() statement in the
> raid*_end_write_request() functions, might it be possible to factor out
> a helper function and return early from it?

An early return doesn't work here: on a mapping failure the
function must still fall through to set R1BIO_WriteError, so the
completion path runs the (single, whole-range) retry and records
the bad range -- only WantReplacement and the FailFast md_error()
are skipped.  v3 folds the two tests into one branch now,
which reads better and keeps the fall-through. Please check v3.

> Maybe the helper could be
> shared between raid10 and raid1 as they look very similar. The
> differences between the two are minimal -- there might be a bug fix that
> was applied to one that should be applied to both?

I compared the two sides after splitting: the P2PDMA handling is
symmetric, and the remaining differences are pre-existing
personality differences rather than missed fixes.
A shared helper would be heavier than the two open-coded branches,
so I kept it per-personality.

Mykola
