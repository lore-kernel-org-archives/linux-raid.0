Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015E038A736
	for <linux-raid@vger.kernel.org>; Wed,  2 Sep 2026 18:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788373201; cv=none; b=XFuhsXLHHpSXUA8iqbJ2xZmGOj+c6GDyIah0PWt4C0Nlaf2ioZbwQwS08OBInbL18bbFCEdyyZvq3BZo6CCqjYk4mi5I0VRf4rHX+MqflzTCMpUxCtsDN8HbkYzj2WoIEdMNa0oQ+6/1EDCCmtUc36GJFkofdaDBnUWpmA/qdxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788373201; c=relaxed/simple;
	bh=GtoQA9ZjPrcGOfipPb9IUUp6ZG9jXfqV0icQkIbgXTY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vGA6auLNPRH9cGSxurCxOEN1d0b9bdiCPmPEt4xI202qc4yYMQhBosf9nncTkkl/FttGr69Ev/fRsnkLa+iqUobMyrORhiaXH8BKpIOzArVHlGNxF9aqkKWH9/3MO50YomSXzm/f0Bhf80ndRE+RX7j+TE/LVkpjYncoyy9wg0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lJN3+M3S; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lJN3+M3S"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48441a2ba1bso976407f8f.1
        for <linux-raid@vger.kernel.org>; Wed, 02 Sep 2026 11:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788373198; x=1788977998; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=u7qs3hNn4LB9d6bKk0MOq7GzVE03yw7eE/Je5YMCtBo=;
        b=lJN3+M3SS3OzJ7tyPwIdhgmAg813hp7IVtB1KVPtZ1S2VYWOEh3pKWqReRQWwVzPWm
         gU57YhI7u8vWntvLgGP3MEHsqC0e3Z0n4PreTTuoqvEADpbaGTBy1ZhxbtL6w7V/LQNN
         zlszoUbhLgtMpp30tOm9AiTsNpQbIzP1TAuiXp4bQvUMft9/0I8yTW6kHLu/E58n6Vob
         HO+xI716sTlWGHO2kiCGAn6hhB0w5AZ+Pq4M80ThC4t/ntSRghq/EFXBF31x4BbowSWR
         zPLTrh7fA2h9bRzDGWfBdwGfMBO37i9lJDTiJoPo2n7DehVIscoXNu139rPa7MNez/OA
         T7OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788373198; x=1788977998;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=u7qs3hNn4LB9d6bKk0MOq7GzVE03yw7eE/Je5YMCtBo=;
        b=GheCkNC79821epFNAIPMIW3ycGHG8BBlYkPoqoMeQyJ7g+VqhmWEP5/cC/Tsbxv4cY
         MknUs+Pz5Xt5QgicQvjpvM9vqayoBe8px20N5RmbiKezRxYEIplynl5wZa0DlG+7kHRf
         EyfrnRGXdZL128VGcwry/d1TB9UEYtI8ppRf0iNR3uXNi0IpUvA3oQ5Wyo9C5z/gTXsA
         bQO/OJ2Nw088x7MBaVr++s42G1zkOGx6IPbsFI1WiSMeP1o3QT7n+IWIdGzBEBRbxZp/
         VqWJBdjSLaJMevKufOQL0uZvFs9y8EdygstvNPG3w6Ge6JhyI4iNyNnoKyvZu0IjszuI
         tcMg==
X-Forwarded-Encrypted: i=1; AKwUvBymI11VL36YkZsitnBt0BELXULqDdUxMu4j4Wd8N+d2AuY2EKGQoAC3od/QVD+DDddza++mJTeqLn4a@vger.kernel.org
X-Gm-Message-State: AFuF++mLVAwzy0KHfQG+TNIYaMgHAi7yAYYR2tz+DJdi0YCjrtKY17Fi
	hy5AZjK9b2SOVAO5f3YkkmsQsvxxsNhFBa3OLGAtU6WjDXYHubcF6q+2
X-Gm-Gg: AYBFou1cU/KQxZX1iJci5JLmcJKgTDwJwhEQ4ecpcuE5Vv7/X/A4083cR+FvckhFjXr
	n8ZFSPYLKj7scVHyIs5nP/BimeirVV31IaZchIwRmgWfsi7NevnHbKjFhyr6E7CBHJoGKsA2q3f
	mcIQeN0cL4VLPsooBLofrHz9seBkTMhD0KasmC4u4Vn2fBUgriUXov/XGH1EHn4Sn6MqvDyLn8O
	Dxzb8eCtPiafO8wtzAkbPV1FWLxS20+tAXYb3U1DCCHDrKhUC84TPQXBNkwU6txJrYkq2SknGKw
	ak3Mnj+dHIpYGD0zOF2lho4WeqGQ8jL6lKXeG1z2MbkSbOxv/avvG75rrdlTn1mi9Y0aOAvltx6
	carswQR3rddaIeBg+zGaNE4sshd6HHtJCWc0YlhZaSlapNX0LbtYMnpeWLWQJlng+sAwbCtd/41
	zGp4FLqTvCAmsOppsD00meCZfKoRb5dTOtpkG/nPpt5+7VgW8KV1j6VZWQDL9U5xJ6FRFk00aPL
	fWNFuIlTHxdyJCixvTd0h+qmw==
X-Received: by 2002:a05:600c:4f88:b0:499:d366:f572 with SMTP id 5b1f17b1804b1-49ce58388demr100657795e9.10.1788373197777;
        Wed, 02 Sep 2026 11:19:57 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee3b0af8sm10644075e9.0.2026.09.02.11.19.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 11:19:57 -0700 (PDT)
Date: Wed, 2 Sep 2026 19:19:56 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Andrew Morton
 <akpm@linux-foundation.org>, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, x86@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH RESEND] xor: add missing vzeroupper to AVX code
Message-ID: <20260902191956.0834eaa3@pumpkin>
In-Reply-To: <20260902162359.GA2497@quark>
References: <20260831212248.213805-1-ebiggers@kernel.org>
	<20260902133706.GA21538@lst.de>
	<20260902162359.GA2497@quark>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 2 Sep 2026 09:23:59 -0700
Eric Biggers <ebiggers@kernel.org> wrote:

> On Wed, Sep 02, 2026 at 03:37:06PM +0200, Christoph Hellwig wrote:
> > On Mon, Aug 31, 2026 at 02:22:48PM -0700, Eric Biggers wrote:  
> > > Since the AVX optimized XOR code uses YMM registers, execute vzeroupper
> > > before returning from it.  This is needed to avoid degrading the
> > > performance of any later SSE code that may happen to be executed.
> > > 
> > > Fixes: ea4d26ae24e5 ("raid5: add AVX optimized RAID5 checksumming")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> > > ---
> > > 
> > > This didn't get taken through the x86 tree.  Andrew, it seems you're
> > > taking patches to lib/raid/.  Can you apply this one?  
> > 
> > Can we do kernel_avx_{begin,end} instead of having to open code
> > and document this everywhere, please?  
> 
> Again, there are cases in the kernel where both AVX and SSE are used
> within a single kernel-mode FPU section, or where a CPU feature check
> occurs within the section and one or the other is used.  So that
> abstraction will not work as-is, and it would be different from all
> userspace code as well.  If you'd like to try to refactor everything you
> can try to do so, but let's not block fixing these bugs first.
> 
> Also, AVX != "vzeroupper is needed".  The relevant thing is the width of
> the registers used.  There is 128-bit AVX code.

It also depends on the instruction encoding used for 128-bit AVX code.
If the VEX encoding is used the high bits of the ymm registers get cleared
(rather than preserved) and you get different delays.
Flipping to/from VEX encoded 128bit instructions adds delays on some cpu.

Yes, it is all a mess....

David

> 
> - Eric
> 

