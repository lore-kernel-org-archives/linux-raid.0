Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0593BFAF5
	for <linux-raid@vger.kernel.org>; Fri, 26 Jun 2026 21:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782509615; cv=none; b=cCbRWiBsMUn43GGDOcgjTLZJ44Dt4XORwo2xAjKSlC5C7vEFa/jD7p2XXKI8yTqIM2X1KLlqO1nDVONkb7dfJLvI00qpcQ+uXSIZHKyaYDIT/tdDfCmYOOmMHCHzk8ovUovzwdMI1KIW1RVeO9IDqnl1rLUJozdxw++a9dgyuwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782509615; c=relaxed/simple;
	bh=jFyrdE9S39jhHBJDzagMp+EO2K/uGVFzRqK05EyhCXk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mYn5Z06AP+ZiMxgKrX+b43GjOJHj+dZ7MC5ey6J4taXb61Pd2A2tHEI+WapVVKRKFZbJUUK9emFQyqxvuRN922MVe4Sh3yz24HLjkSbhv3tykZ5bSMHxX0e142hgxl4hxpHXE2IDpuVP5l05Xjn95V1dmabe7JZtuK9UeUpcA48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RS+c+dd1; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RS+c+dd1"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-490bc6a7958so18220225e9.1
        for <linux-raid@vger.kernel.org>; Fri, 26 Jun 2026 14:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782509613; x=1783114413; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CkLfNfssIEW0SW6igjjDLzI26xT1AWB7xGjnkz3o0pk=;
        b=RS+c+dd1pWDQ/BsmzjLT8DCtvOkDOwkxo3SzoRiG/YI7cfMp8UKtREriIXtaeTAgi+
         kXWpV9sfRv1rc2SQOAGLL0S0lC0/GGQzldeO//LgHlhLF1JIrekR+j4dM6yQFv7TqtsV
         HCgF9NYQXMT9aRdd/3gFc+QT9BuAYnV/hxnOJtWgnmU6LgcU1c67xE8o4qKku7YI4YGl
         1dURCsznUTJbhDhy708CPUigsffO6ysQWhOvYSTDnjPons3eQCwsvyqsE4E/Pbqz065D
         Yiu32Em9HmtXXxNdh0RWOwQj4+r08ZPYjcEpaAX1TUZcWP+/Uc6M88Akc0kY99KNnEt1
         v88w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782509613; x=1783114413;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CkLfNfssIEW0SW6igjjDLzI26xT1AWB7xGjnkz3o0pk=;
        b=V9fueIkHJzFe7TncPnngz2NWFui9q/IKOVn9bDOT2bCFo4C+iWktBPehBH2kbAwLrT
         d6LE/qGR6OkZdA0NlB1Xo/Ebjz8TidMRQhDsr100XUByCP+8nWeB19xOs1Tvczlt0rfp
         mNyGGB6U+qXaJq1nBHSFkt/e3uSM6/IoEiaeJCtunx45otpj7ZEGbAzHcgtvM2RYl9mU
         G37qrb0BC7pGe1HW/ktq1EVDpP4tjGCSkCeDo+UWBgYTNU5XReaIEFWCmh7+N9p4EeCg
         Cyu5kBmLcWShv+qoHr/f47SEhWdJlImGn9Lr+RkJ1i9BiBMyn7ghhT/y2dB7RBWsYwXB
         9P/g==
X-Forwarded-Encrypted: i=1; AFNElJ+X76FUvQLfuu/YaOO/e4mHOetfjZoKSHiTMgAq7Bpxn9Jn/W6K59b+aFCStgpJpkKAm3JJGRdUvwTI@vger.kernel.org
X-Gm-Message-State: AOJu0YxWZnHjgHxbaDOTRhfm51AXoy7Du8YbBitb0+uxcJmWSjO8PzQS
	WUoJWxDp5Zg0QMEpLQZqrK4aT7ivzSmmZuaxWKBDSsL4sV+KFh/bEeWr
X-Gm-Gg: AfdE7ckrRTC2FlapBJcnewNVFXRyl8w0Dob9MLM2aHX/ofrP4w2BXzVFKNI1xeB+7R8
	g2fLp9Pk8JGRBXZxQISmwjkGpG+ChVufTBrxFNoa+sbRWXaV8eToE8ycgsBRfRfqdRBiJqP7Nth
	FFMIPXCC9aWvPwUTvw/DDIEyU5hpouBRjdaAi/pY+RGYeAXz/pOrk+LdirRI109jIQljCebXbZV
	nbL+RNVdomfNBPQtIHfLo8z4KerCQiA+iXeb5gSxFifltWA0Oe0RSixUqf2FXY23yb58mgNcCDX
	SWKibWi8SWcG8G9tN3Q8fNAfEo+9bdPesa6LgtDu2JAYh329q4IDIbnQ9npbPbkd0NDCSs+Qg3F
	/iMoURA9KFPgfRnIl1Rri3xV4T0rkXI88J2ZePivzlouuQBW4DS6gCbW7jywR2wfL04jIJsFnnz
	ChHRuztm2xgBSzsOYD7LhX54Rg62qzdj++uEgJl1JlfOJuOduAmw==
X-Received: by 2002:a05:600c:3b25:b0:490:5000:917 with SMTP id 5b1f17b1804b1-492663d6d67mr113592695e9.1.1782509612976;
        Fri, 26 Jun 2026 14:33:32 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49269002511sm104108085e9.8.2026.06.26.14.33.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 14:33:32 -0700 (PDT)
Date: Fri, 26 Jun 2026 22:33:31 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>, x86@kernel.org,
 linux-um@lists.infradead.org, linux-raid@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph
 Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/8] um: Check for missing AVX and AVX-512 xstate bits
Message-ID: <20260626223331.3451c11b@pumpkin>
In-Reply-To: <20260626205544.GB2368695@google.com>
References: <20260626043731.319287-1-ebiggers@kernel.org>
	<20260626043731.319287-3-ebiggers@kernel.org>
	<20260626084113.42eae31c@pumpkin>
	<6a20b442-b97f-4cae-9168-30201d5ef82c@cambridgegreys.com>
	<20260626114957.1a2b7e5b@pumpkin>
	<20260626205544.GB2368695@google.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 26 Jun 2026 20:55:44 +0000
Eric Biggers <ebiggers@kernel.org> wrote:

> On Fri, Jun 26, 2026 at 11:49:57AM +0100, David Laight wrote:
> > > UML is just another userland application from this perspective, so
> > > there is no reason for it to behave any different from the rest of
> > > the userland.  
> 
> Which is why it should do the XCR0 check that the vast majority of
> userspace programs do, right?  It has always been part of the documented
> way to detect AVX and AVX-512 support.

That and looking at the other 'cpuid' registers rather than reading
/proc/cpuinfo.
If you want to run 'um' on (say) NetBSD you'd need to do it differently.

> (I think this helps explain why LLMs notice this too.  They've been
> trained on lots of code that does it correctly.)
> 
> That being said, it does seem likely that it's basically obsolete now.
> So maybe we could take a shortcut and omit it.

It would need the linux kernel to report a cpu feature that needed
kernel support, but that the kernel didn't support.

But for things like popcnt um should probably check the relevant cpuid bit
rather than scanning /proc/cpuinfo.

> 
> The important thing is really that we make a definitive decision *once*
> for each of UML and native x86.  The status quo is that the decision is
> instead punted to every individual AVX optimized function in the kernel,
> which isn't working well.

Indeed.

	David

> 
> - Eric

