Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089533ACEF1;
	Thu, 28 May 2026 09:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779961799; cv=none; b=RdL1AReiErRxhVlDq2xoQljmBY1zYibK5IH9VLF+t9f0aq5DwWkYVYCfijAGbLChz1VWDa9qBUub9/r6G5gyyE5yeWiFfMvV4quH/SvjQyUH4n5uSNqLh3bwomMu/9bHLmK3EywOGeTKnhhupU34KOD5vam4HV5snbouoX0MwX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779961799; c=relaxed/simple;
	bh=KzHIphpV5nnVuflWcHRnj+DJKt7XTdNAsfb94StXB08=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hv6hF8+O1k9/avm6p2lSGmIdBgZQj3dLt+hZd3DU4+i85GrJHQ/xMBVdf1OAmso3Jv4T4Pg+zxf+3l8uLTMsQhcLs3Co0Z+hZe40z+CFU01Jamztugl1NmUm+uEh2xHEiAWhhJOsSnLFxbJBo7RQkWpPgun6H7M3K6q7AyLsZL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hTggJ2xA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hTggJ2xA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95CBA1F000E9;
	Thu, 28 May 2026 09:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779961797;
	bh=NFfgee4KJN7CaFHQFyefaFVIdlWaWFayLfKlgnxXDKg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hTggJ2xA9vUCE88ZExAMAIk2r9IAq4H8LLgE0KyTsqkpBHLyQXgylvOniRKr9fnqW
	 bgGOCN5FByHNGnh4uJz9Apen59PIy0pKbhgZnfOuPJPd4j7SoF9k5Sj6K6Vo3WPptJ
	 LvUbVDUu5LclcAUrWxBppzcxqsweJKpPs7lr6hlqO39zMgRaX4twvQ22BiPl1YoFsN
	 82MAOrGfV4/LYZ2/IaRl9wrbRGawsKMj+lDUioHFc1hrQYU+Ru60wafkTGStT+0w+l
	 5dGjiKV9yeX0ECDGoPGifn8AObraKM5k2XqKj54e3r4d1uItE+U/4IKGQQj3wUQD6S
	 lE1iS6pk1XcEQ==
Date: Thu, 28 May 2026 12:49:51 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Laight <david.laight.linux@gmail.com>,
	Li Nan <linan122@huawei.com>, Song Liu <song@kernel.org>,
	Xiao Ni <xiao@kernel.org>, Yu Kuai <yukuai@fnnas.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-raid@vger.kernel.org
Subject: Re: [PATCH v3 1/2] xor: use kmalloc() in calibrate_xor_blocks()
Message-ID: <ahgPv4DoUlZOQQLD@kernel.org>
References: <20260528-lib-v3-0-feccddf1cb6d@kernel.org>
 <20260528-lib-v3-1-feccddf1cb6d@kernel.org>
 <ahgC1PDFtFrJrsKC@infradead.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahgC1PDFtFrJrsKC@infradead.org>

On Thu, May 28, 2026 at 01:54:44AM -0700, Christoph Hellwig wrote:
> On Thu, May 28, 2026 at 10:27:55AM +0300, Mike Rapoport (Microsoft) wrote:
> > -	b1 = (void *) __get_free_pages(GFP_KERNEL, 2);
> > +	b1 = kmalloc(PAGE_SIZE * 4, GFP_KERNEL);
> >  	if (!b1) {
> >  		pr_warn("xor: Yikes!  No memory available.\n");
> >  		return -ENOMEM;
> > @@ -132,7 +133,7 @@ static int __init calibrate_xor_blocks(void)
> >  	pr_info("xor: using function: %s (%d MB/sec)\n",
> >  	       fastest->name, fastest->speed);
> >  
> > -	free_pages((unsigned long)b1, 2);
> > +	kvfree(b1);
> 
> This should be kfree now.

kvfree still works, but I'll send v4 for pedantry sake ;-P

-- 
Sincerely yours,
Mike.
