Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793026843;
	b=VdXg8q7Pj+g/ZvkyIMIM6dF5kEbwdMFg6dDvseM+PddZwQoOASqlRgoT3eCKpNwC8+97
	 SqID41j9or03X7LXkbzNdwHm3TPbNCB4KJvaxA3rqvoKYuzGpJmRz1W0psra2StuMJ9Y0
	 e6E311Er52OJM8N4lZA05dsuwLrV2EJ63xRmhGquTpukehF1uiHM7o8x1tnBInQBY51bz
	 ku0iGZo1qpaZB4RMEOlK9NCDKxQc5eRYy2YbJtGZqGrNJOtQV7vz7U4MrY3nvU3gAJFKh
	 uIlDu5HqNaT1bA398IRM0wIuTY8wSNeRO81IPa91b0uLQYKEhl23KmJrrK3xr9b3scw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793026843;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:In-Reply-To:References:X-Mailer:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=2fEUp+1KLX1g9pxymcQPGBgvQdM6meDnFJ6iLYfyBzk=;
	b=nP+A4S0seFZTrf4JXsOa/20Stt+Ft8xZSFUYVtaiALB/drsfx3gvBt5tOOyhOm8LgvWX
	 Wz01wA4QarfZdMAe7mmQD3+G1A3+DzYRnOhG6Cr1qA4RNo23jwacETPs8JmdZD4UIBoan
	 C0J3KAQ6Xgvq3/dxNH9xfrvC74IhIkSVfaWwKUjDje3e0aoZJCsedoWZMQEUK9xOcD485
	 qIIDCG9hnrY1dJcpfiQxs7ef9RsC6YgwbZ1T6LK/4w1XAY7INPwykB5ZLieUz2hBKHyI5
	 3AirW7RcP2YEy0wtByOj9ug0/2LLE8miGUdESxocoHAN5i4PqW0dzKxjLrFxmyoIz8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Lra6s915;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2EE606A31E
	for <linux-raid@vger.kernel.org>; Mon, 26 Oct 2026 15:00:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6D2EE606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Lra6s915
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a549cd7fd2so12494695e9.0
        for <linux-raid@vger.kernel.org>; Mon, 26 Oct 2026 08:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793026841; x=1793631641; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2fEUp+1KLX1g9pxymcQPGBgvQdM6meDnFJ6iLYfyBzk=;
        b=Lra6s915j8vZyMBLzKiUyF9yhNwktX1OzErVRKT/BPE+RAJfo5Llf4uPPZuAlrYz6b
         eeFUllvSvT/2MXKEr6n9XgjdQLi1t6K2eETXDEyNCAB0a5CHGAwoMlvmHZyTNKRvcchi
         CtnKpn4dR9H/ozlsReAL7ghF+31+8KZ0KmGJeMxWjk5/1NMR5ZmZ3+n89Iqj6naf+CUM
         wsAbxiw0VIujFV8WDECRIJbpa53lWo3Cd+qOJbhXtoyOQeWWVwmzTmZR5YP5rzrpSisF
         kSOHzF7RpnsfTQsuQ34tmfVSxzFTtOJM9rsiabq26H3iShsLuI1J14tRIIxtkOTFu9hu
         3hxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793026841; x=1793631641;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2fEUp+1KLX1g9pxymcQPGBgvQdM6meDnFJ6iLYfyBzk=;
        b=OBJezkPbQ+yMuM62nvtk0IwqM0aBfEM/eDUo+vBPOVcWfBnGqptL4SDNG+0jy5+tKm
         zNLdylBGy1QFco+qbX6iEWXq68F5aZpJA50PGKOl6H5jt0oyenHRaFrztfebB9NUAnmb
         n7YWNzd+pgUmcQcmZF3SjjSt8wBK3iVDhlc6e/wz0Z6y1mAUvqtU8z4qJdpQxmVfqjZI
         dU5cU5wAOAdb/40IFhwyP/jyA8XTDFPSwKknuxe3WX+2MSpN/fsqxcn4btwexQ0R008g
         Y/buAbQVw/m+kcPpzicd54koOEzdre8RkRCDr/3UkiQ8mkSBe0GahyMFkL7olhowZjnb
         ivZQ==
X-Gm-Message-State: AFq9FYJUw5wdqvFERPjETzXcf3b2YcpJIdPLs8Vcovy1Q0Vb2w187WWP
	peftd6EcW4UFSJrr7N/U+8UacMd6exRn15EE65UaNjuW8Gn7w0TRk+Lw
X-Gm-Gg: AYBFou1DLSf7biP2DQvvNwEJpyZNQCmSGMaKUHSzSw7gCKknUnp1le2ny6l41ciqK9u
	xZtOM93CVloyCcCdHUwG1BbRohCniaf439ZPz+Lc/J/e1Ldx3Y57TX4J9b4ZAoDGCFrvEITi1VF
	IkvzymKs/qW3EvQWhTslVJ57oxGDLI8Ztc6wKIvcNpUc34aZ4/wPoFTT7yrCBMY6FkGZR8C+69m
	4uxun9kK5G9IYHyOofhpORAcwYbeIJLj2MN+ww13J+nkzO9tU6B7f6EcZL+LkCwe0Fog3SIW1sS
	/aywB2fwQeCGaG2YRmR17f5znXffhKkKFeIJnkHFL6m9y4qojs5VIC50o3++7efuoNjAt2Cyc3w
	svMzAAqgdkSu+P361lpRMfAQyH/1eo7ou3N02WfIns6dYIGr/oC5TLnc4my4tEjw1NnIdL7Rn0c
	3n3caj+O9i7eZDf84TRLp8usz1/IZO4YNXMc/xR6VcHAXAjkNTV2s/ZMy9zmjiJFYZE6dYN2JLs
	qOEKNh3xYeKMNpjPUCavLF6rcxOu9+K/4hGFL/Bl0iGKP09UdR4l46n9hXIyCyMqmW20+1mOp6p
	2h41u70kS/XUUtBF
X-Received: by 2002:a05:600c:3b82:b0:4a2:18c4:61a5 with SMTP id 5b1f17b1804b1-4a35ae71a3emr134917565e9.6.1793026840517;
        Mon, 26 Oct 2026 08:00:40 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a35a0cc374sm207837235e9.9.2026.10.26.08.00.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 08:00:39 -0700 (PDT)
Date: Mon, 26 Oct 2026 15:00:38 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-raid@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 0/3] raid: remove obsolete MMX optimized code
Message-ID: <20261026150038.6d08478c@pumpkin>
In-Reply-To: <20261025191207.86590-1-ebiggers@kernel.org>
References: <20261025191207.86590-1-ebiggers@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 25 Oct 2026 12:12:04 -0700
Eric Biggers <ebiggers@kernel.org> wrote:

> This series retires 32-bit MMX optimizations for RAID.
> 
> Affected CPUs, such as the Pentium MMX and Pentium II, will just fall
> back to the existing well-tested scalar code instead.

Seems like a good idea.
I wonder if all that loop unrolling was needed :-)

David

> 
> This was the only remaining MMX optimized code in the kernel.  MMX
> optimizations for the much more commonly called functions memcpy(),
> copy_page(), and clear_page() were already removed years ago by commit
> c6dbd3e5e69c ("x86/mmx_32: Remove X86_USE_3DNOW").  There are zero MMX
> optimizations for anything else, like crypto or CRC, which left the RAID
> code as an outlier.
> 
> Patch 3 also cleans up the CPU feature checks in the RAID6 code.
> 
> Eric Biggers (3):
>   xor: remove MMX optimized code
>   raid6: remove MMX optimized code
>   raid6: simplify CPU feature checks
> 
>  lib/raid/raid6/Makefile      |   4 -
>  lib/raid/raid6/x86/mmx.c     | 118 --------
>  lib/raid/raid6/x86/pq_arch.h |  69 +----
>  lib/raid/raid6/x86/sse1.c    | 136 ---------
>  lib/raid/xor/Makefile        |   2 +-
>  lib/raid/xor/x86/xor-mmx.c   | 515 -----------------------------------
>  lib/raid/xor/x86/xor_arch.h  |   5 -
>  7 files changed, 12 insertions(+), 837 deletions(-)
>  delete mode 100644 lib/raid/raid6/x86/mmx.c
>  delete mode 100644 lib/raid/raid6/x86/sse1.c
>  delete mode 100644 lib/raid/xor/x86/xor-mmx.c
> 
> 
> base-commit: 21a7f44fd0765fcc5194130b28767786eba1d1e7

