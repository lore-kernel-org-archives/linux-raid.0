Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2BA5391501
	for <linux-raid@vger.kernel.org>; Mon, 22 Jun 2026 08:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782117729; cv=none; b=j9Kxm40oRJ7sL82okDM6lY3hC11I0bkV8qWfHnh0qIY4zXXAVk3x481kBbrlgIxyd28oBgH4ZcLfn4jJ9/stbaxezXBajFw4jiFOsFaiUaKz64oC6AhogvShUQZ6TGUewRYZ0kYWgOArK4LTcJkji7+q9VG7aPX8iYFuKvFFggQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782117729; c=relaxed/simple;
	bh=9x5gGNzm/CgGZAAOloa8x0P1VWHqZMFZ/VdZWA1YZ6w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=os+YjCjInkIwkxQ1gTPlkiTIFJQXDwe/BtONERzA4Kriz5g/5okDxuTU5nMp0DZVPpoH4F7tgYF7EpfM6h2tzetAUmj3oX2kQ6mrHPRwsQKniuBR63NG+l5m4Bi84hmfSAO9Y0Rq0vPjl3PUCDAHcr5jvBypqO05Rt5J+sFpLiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=opuuB+Hx; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="opuuB+Hx"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6977c0814d1so2705307a12.2
        for <linux-raid@vger.kernel.org>; Mon, 22 Jun 2026 01:42:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782117726; x=1782722526; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nXaROWcX8niDcdghF4hGnIFPotv9p/zfW7hZ5AJ/2K4=;
        b=opuuB+HxngSE3Do/YXmHDTC8bysWZY9NQ19bjbyLlC8UhNNhm+Zd+n4AtyZLjVwPb0
         98k8cp2E3LR6pJCQ1yqKLtEkyiKBQqeeMQSNBuaUp0oMJBg/4EASnswagg3eG2VWaN+F
         4zpTBEEWUsUrda/Gy41TMZfy7WW7GO73EJksQF4+DQrm9nb4kF3Zrv3PvBcAjH3BX5rJ
         wRuj4SH5VuodQLdT97SfVh/tFq7u05VWW3YMhewsL/HP/BfAf6fPeyPlryHzw2Yt/Ybx
         5J2YJ3sswelKyC7pSt5kDWq4X+Z+3Z7OLmaXQ9x1rDodi/hljTMl8RXa0q1NGTjAEFjt
         hgeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782117726; x=1782722526;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nXaROWcX8niDcdghF4hGnIFPotv9p/zfW7hZ5AJ/2K4=;
        b=iWgHxL8C8OumelszUCB2antJHrzIp4Bki4FTiNzmvDJm98DJ+SLT8elgYcZsUmsLPA
         8uPoYe9ZsmF4soWr8fcmAjGc+T3rn8vLCOOURUy+kB12rbgmcquIrc+edoDa/TeT3bQb
         cHeRx/JuSzBsG0HuJfmEZXGl4SUg6p3K0kwq+ys6S49wrlqO9620xtlFFxBU6Si12jzt
         JFTdJgMowf2zKS3YgKl4TX6N5MUOeZPOxyP36bCMuGwD5/Z+E1McB5FhrA21f4HYIXM7
         pVe9jp+60dh0RsWryYyX2/N86uOuOtHJGjsgDrRzIT8hld5oh5g8xshzUVBZ+vPUOz1Z
         cgeQ==
X-Gm-Message-State: AOJu0YzXZl9L79G46GkEqpRsIo75dnw7l6nE0V+wHftShmxidFrEpmG2
	zfG43y5AbQpqGZfRxOU7zXCRq2AQrSYfqocQdkClW+cRph3m1RPcCwgB
X-Gm-Gg: AfdE7ckZJKVOScM90aNnQbvUSH/fT9BWmLZizAMy5kM29cLzNklj5w6aOin9J52kYZm
	hO1ZAhXNOHTbVuLxBdD2k4RZR6eEA1EBgxEumKkbZAW2cFLKP1l+R/L1kHDs965H8E+ScwEqWxS
	6aYedfrPF2UWCfNUnPCCA1zxyZTit2pju/xmYQ071UHVJUlhuz/QoPayTWsn/WIL5soYcP2iPZU
	rMn3/de4wzjYbaWK3lLcKiiQITU9kb75tEL3UDb/QqFzKDA3y41c+vJEH+cmS1sbVhtFabO1NNc
	jHKYCBFe3t4D/+QE5gWQwHpHOl4X+Kh8+UUjUWJvqc4FbshSCHE0SN6rCGKEBcyr607b3BJIHaE
	yijZGcpP27w7UFvalyDd6Yu/caAtKBd6PCfiElQqUWN6/SGgTVCWjjMvX0BUhEGPks5+B2cCmyi
	K8IE2X+V0B
X-Received: by 2002:a17:907:c01c:b0:bec:687f:6603 with SMTP id a640c23a62f3a-c097c0af677mr640172966b.28.1782117726151;
        Mon, 22 Jun 2026 01:42:06 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6977be30b35sm2545215a12.16.2026.06.22.01.42.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2026 01:42:05 -0700 (PDT)
Date: Mon, 22 Jun 2026 11:42:01 +0300
From: Dan Carpenter <error27@gmail.com>
To: Sajal Gupta <sajal2005gupta@gmail.com>
Cc: linux-raid@vger.kernel.org, song@kernel.org, yukuai3@huawei.com,
	tomasz.majchrzak@intel.com, linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org, me@brighamcampbell.com,
	linux-kernel-mentees@lists.linux.dev
Subject: Re: [PATCH] md/raid5-ppl: convert pending_flushes from atomic_t to
 refcount_t
Message-ID: <ajj1WdhoW-Y3GE4Q@stanley.mountain>
References: <20260622080656.22786-1-sajal2005gupta@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260622080656.22786-1-sajal2005gupta@gmail.com>

On Mon, Jun 22, 2026 at 01:34:32PM +0530, Sajal Gupta wrote:
> The old atomic_t based counter allowed ppl_do_flush() to continue using io
> after it could already have been freed by ppl_io_unit_finished(), leading
> to a use-after-free.
> 
> Convert pending_flushes from atomic_t to refcount_t with a proper ownership
> model. The creator holds a reference for the duration of ppl_do_flush(),
> and each submitted flush bio holds a reference until its endio callback
> runs. This makes the io lifetime explicit and removes the need for the
> second loop in ppl_do_flush().
> 
> Fixes: 1532d9e87e8b ("raid5-ppl: PPL support for disks with write-back cache enabled")
> Reported-by: Dan Carpenter <error27@gmail.com>
> Closes: https://lore.kernel.org/all/ajJF2wKYWRk4GGCK@stanley.mountain/
> Signed-off-by: Sajal Gupta <sajal2005gupta@gmail.com>
> ---

Have you tested this at all because it doesn't seem at all correct to
me...

regards,
dan carpenter

