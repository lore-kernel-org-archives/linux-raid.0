Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D6E329C71;
	Wed, 25 Mar 2026 05:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774418072; cv=none; b=CokhLMhBPOZGmyIO0B/sHgbTWM9gGmndbI3RooHjVaF4XoFuMX29Q1aK7M2RSlJ1t8RBzDZ0Ym22IcDI8OprfZvf0IBLhf30M0pudjyTZPpmJLObtHfqQdTGXj5XpDRFeyVDRU6wya6SPbojTPdq2jpCI2g5D4UyY/YfM+IVowY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774418072; c=relaxed/simple;
	bh=eg1aGWqznCDcl/SwwojZGZH/o3LM4FnouO6efuz+I30=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WCDty9oqfPcwls+OgkODoV4zXERcz7sNJRZ3s4eLFYtnreSbBopsemPPXeYMB4EjcMBholEP5xafcfZ70YTymmSxDzV7O23r6Uoh+QA9MBjgwgPnyuhFVRU1RMSMFwtD3+jIKj9oJ6GN40qCFv7tpmDzEuAmd/gXprzbZgE3RAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FP93aw7V; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FP93aw7V"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=x0lrVEhkGcLtFsYbh35KA1us2x2NzhsZU+tLm4ISVPM=; b=FP93aw7VvhZ5gilShYJUfTl8pa
	CZc0F0EdzQCloh64KrbaQ9AXgeAZLADmYi8E9vj1ZW/etMasOL8R6vvxKawnXGqjaKacTgnTXg5Kb
	xXNIlSrOmKBX9r0OEdO2+7ujlrhcSA7cKfPWZS5k6CsHrOTtVp7ZdI+J+J3N/jUzQ0LF6fRlbsWEs
	jeBdBG1Ti23XDyOo0YpJO6M2JJvc63YEoPyeOss2zSIZHrD1Nb87ZUy8wCs3ZNrVH1ZVVr7fu2tvw
	OgrWXKerSRXrqwuv9PKVvgPzre9Fkai7+fRa4PJBNhiaWnYoA9Ufyvg1yEolP/ep5nf8ox11eOLLR
	N9TW6dnA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w5HCD-00000002krt-3DBv;
	Wed, 25 Mar 2026 05:54:25 +0000
Date: Tue, 24 Mar 2026 22:54:25 -0700
From: Christoph Hellwig <hch@infradead.org>
To: sunliming@linux.dev
Cc: Christoph Hellwig <hch@infradead.org>, song@kernel.org,
	yukuai@fnnas.com, akpm@linux-foundation.org,
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
	sunliming <sunliming@kylinos.cn>
Subject: Re: [PATCH RESEND v3 2/3] lib/raid6: Optimizing the
 raid6_select_algo time through asynchronous processing
Message-ID: <acN4kVWoqbqbgi0t@infradead.org>
References: <20260320060750.31334-1-sunliming@linux.dev>
 <20260320060750.31334-3-sunliming@linux.dev>
 <acJDlYgX-PW7foRv@infradead.org>
 <51f57b049c46e9d22d69d2cb1589526814b9bf65@linux.dev>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51f57b049c46e9d22d69d2cb1589526814b9bf65@linux.dev>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Mar 25, 2026 at 02:25:16AM +0000, sunliming@linux.dev wrote:
> > which could affect different test algorithms differently, so this is not
> > a good idea.
> > 
> Yes，but this code can be compiled as a module，Could the same problem exist when loading the module?

It could.  But at least it is under user control, while offloading
during normal boot almost guarantees a spiky load because that is
how the boot process works.

