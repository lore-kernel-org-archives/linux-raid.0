Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA32364E85
	for <linux-raid@vger.kernel.org>; Mon, 16 Mar 2026 22:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773699175; cv=pass; b=IAR3/Wi1kLx6/tLX8J50tG7plJ3QhmMrnPwPl9tNCrXWmcyCZOR8g58dXhqwgTxep+wg+JzXy8Wyph1r6wKUbOXT2GLbSteuUFAaqsCeqacx4dQ/nZ8yQPXoCC3s7VlL4jagljONrxehCmNkenoYdOCK6UpqYqdGBUAuExNaYj0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773699175; c=relaxed/simple;
	bh=rsp7Ihi8TSAj7hc2vakkxGqqL2oEkNH6XMA5zjqI1qA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VjIQRX6zwnaaPjKPTGcMi0eiX984D4r104AXT5pZ+XC+AKdlWeCloGvHbSvedEvBE5SK/SwDX8lwwigxqO8euraPtnNpq6Xn2zKruaXBh2D6pwnbRa2TjQQ7o8yNHI9rHrxOIQf7wu4X+UDCMssFvTFCMXhPG7uKR0Sj66t26hs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nXFirVf+; arc=pass smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nXFirVf+"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6652452d94aso3127833a12.3
        for <linux-raid@vger.kernel.org>; Mon, 16 Mar 2026 15:12:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773699172; cv=none;
        d=google.com; s=arc-20240605;
        b=dMYPlHJuxWhK19f7RxejFXZ6y2EL1CAIcCqyle6wseQVgWC+6TvKlE9o29ZvdSKJ7a
         mynf5BC4hXW9OvBrdRGrYLdrc7GFvVi0AAdasZj9u0PTHOZrRvTle5Lezhj1heW9amfA
         9Ke8//h1w2dXkOzbWwpm3aczWvJn3BaBchAJApp0zlDPhwDipzRwpBXLyF1uZPq30Qnh
         wujliQWTrL5PJI5O6YM2vAS8tpDPr4SBDnHH/DD0vqQwosfnroVS3gK+qo53U10G8Vye
         hWEL2wixWxr+hGOLYChd0BIewC+MQ50kCY8Qru34oJIxuxvWSl6dRckaFloINJxiwHxc
         /K9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pAPcwDRyDaYRxv6m5ec0p6vencyIfyK+pU3obaup7wA=;
        fh=EMfolCPNIddGHGskAnguC9SN2yhhkV9Vtg8/bL9rr/4=;
        b=lSDzvI19EUCol58XciguEIpqxSPSP85yeSCj30RA9v8UXE4Sorj8Hsx104cphujyk1
         kbdlgcSxh9RlR9+A8ciPn4YMnmCG1cmn0mTzdpBSdtBdDlYg4KitN90oJoflbLk8bc1T
         qTjuC/RqgaL3331PuMqyOUy7+0rQSci9t6nrS4WXyQieBlEwJwBWbaSGrWM6WbE7wp6c
         LVM9l4Bbzc78D8wNHFp8ZtfFuL3yeaxlS6/KOjjHhjRp5x6iDw/LghoXsiEF4bRHOjJM
         n4ckoyjERyCAyMTKzYwbWvBpH6D9zMS+QMyxcdt+QFFKaquIpDgxCFRvIhwjFxz5Qrxm
         wG+A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773699172; x=1774303972; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pAPcwDRyDaYRxv6m5ec0p6vencyIfyK+pU3obaup7wA=;
        b=nXFirVf+3TZ7nayCWf+YAe8f5IxUtczrfP1EXNbBIrmwKiqwYyLnNpAauLND8FQtug
         qyiFy+esPMVr68OOOX82lIQLtv4g9BlFNZaBwo4KsXwCVqnfA/cnHzxN3Su9BCI72YRq
         auyRj61mHF94yEemJmjWC/U+E7H+3VcjkmPSPrWbYeT/sNINXe1KOC5DtsQxJjPZdVBP
         hNMRzTNBiyInnITmm9ONHtYXDRin1mMnPr1z331IK2KJiXXPmzS1yp1rdXfeMlAWA2Ci
         qg4RD1I8Hp+NegL76P7aa4Y8Cgz6Ykhx1YR2At11/HUaYDUKWkEbjQlI4WP+iffGCmKo
         wGjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773699172; x=1774303972;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pAPcwDRyDaYRxv6m5ec0p6vencyIfyK+pU3obaup7wA=;
        b=MEqU1rTViKbmlOtmrWlNwfV18pnBemKF+mA2gjMyOHRRoaBClJY1xmKkqT7jmDrn3L
         edsIa/ZWjtQojWgPyP6s0OqgqlzKLYc8OJprVI9TMteQ+b1W82owzFDk+56QEY+ZAlNK
         wXNxgV+/8eq4pjqCFaoG4OFvzWs7TyxFAKaZfBxjxSM59NYFG6iyG4xX2wjwDn29uYHd
         T9W0VwFbsxuahM55CLp7UR6XSCFtgNeLTXSV0JpKWrUcORUzYo5/3Q+WnyXukxZgtKGZ
         ZnLUUNqNTuPVSIgazwr3FfsXrZ3sY7dZGCfTyrk5iY6EsDVy/sKC21zI0tmZYyc1vWES
         MdNg==
X-Forwarded-Encrypted: i=1; AJvYcCX4S0zP+oLBEOcCA2qLtutBWo3Ctnr0Uor7cBcoFHT4qs2GzRS6rQ+9y3hgv+n1oNFsJQ+LBx5sq0yF@vger.kernel.org
X-Gm-Message-State: AOJu0YwffXUb+I0QkcZYLBJyArVxsWNozzyudMofUA7yUsEA5oYG/3XD
	qFQc/J5WR6pPSJf3euJwGt7dVCIOnKAD91Ysgox7tNI23Ecfd7lxOQYskGcTGdkD8UewVh83k+3
	uqFm0p8HRYuj6KZCv/r/s7XLdyYmHGJY=
X-Gm-Gg: ATEYQzwKX/XSRvTGG4YfuM/gHKcVi2tDlY3N/Stc9K9+SJsQDAsc6VEiTW/YDK6ytsW
	XMb7t1zXaMkPrHOrV+xnaVBwEqMf9LRLhvvgnR61eXU7BI1A2JAfBrimI3ki5ByAmCR3hf12vrF
	iQWbXaOqM4UFqiWx3m/W5gNgA3pBH22yT6jwivvLvvkTfUURZqLxyJ2GPTMEtxRGtA1gPez0vc6
	sF6l2C0tFTpaVkfVqYkvspeOekbPMOLWRjjU2NhuLvM64LnFPER6ITTsguUThloWYOXWxs7Mada
	fRhyjSjDKQ4v95RjJKgCusMF9MD3ohdSMILSqCDN
X-Received: by 2002:a17:907:1c0b:b0:b97:b515:31e with SMTP id
 a640c23a62f3a-b97b51509acmr346111966b.50.1773699172087; Mon, 16 Mar 2026
 15:12:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260311070416.972667-1-hch@lst.de> <20260311070416.972667-11-hch@lst.de>
In-Reply-To: <20260311070416.972667-11-hch@lst.de>
From: Magnus Lindholm <linmag7@gmail.com>
Date: Mon, 16 Mar 2026 23:12:39 +0100
X-Gm-Features: AaiRm53MOL-S4iIRiZrnVZNNZCm-cfe6kMQGe2L4WL9TC_xpq_akeJ994p2lXMA
Message-ID: <CA+=Fv5QkJm8+ysx8W=ypr84oSR=rrikfk-iMMU6_xrtS1PsWvg@mail.gmail.com>
Subject: Re: [PATCH 10/27] alpha: move the XOR code to lib/raid/
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Richard Henderson <richard.henderson@linaro.org>, Matt Turner <mattst88@gmail.com>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, "David S. Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Dan Williams <dan.j.williams@intel.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Arnd Bergmann <arnd@arndb.de>, Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>, 
	Li Nan <linan122@huawei.com>, "Theodore Ts'o" <tytso@mit.edu>, 
	"Jason A. Donenfeld" <Jason@zx2c4.com>, linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, 
	linux-um@lists.infradead.org, linux-crypto@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 11, 2026 at 8:06=E2=80=AFAM Christoph Hellwig <hch@lst.de> wrot=
e:
>
> Move the optimized XOR code out of line into lib/raid.
>
> Note that the giant inline assembly block might be better off as a
> separate assembly source file now, but I'll leave that to the alpha
> maintainers.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  arch/alpha/include/asm/xor.h | 853 +----------------------------------
>  lib/raid/xor/Makefile        |   2 +
>  lib/raid/xor/alpha/xor.c     | 849 ++++++++++++++++++++++++++++++++++
>  3 files changed, 855 insertions(+), 849 deletions(-)
>  create mode 100644 lib/raid/xor/alpha/xor.c
>

Hi,

I applied this patch and ran it on my UP2000+

The kernel builds and boots, and I verified the new lib/raid/xor/alpha
implementation using the XOR KUnit test, the test passed, see below:

[   25.705064]     KTAP version 1
[   25.705064]     # Subtest: xor
[   25.705064]     # module: xor_kunit
[   25.705064]     1..1
[   28.957992]     # xor_test: Test should be marked slow (runtime:
3.253413330s)
[   28.958969]     ok 1 xor_test

Acked-by: Magnus Lindholm <linmag7@gmail.com>
Tested-by: Magnus Lindholm <linmag7@gmail.com>
