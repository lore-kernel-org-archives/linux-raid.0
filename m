Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01941142E77;
	Mon,  6 Jan 2025 15:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178324; cv=none; b=Xr3BIXBAbWXOmg0G9fmU7yrK8A6Bqwajsd7GFmI6zktl1b4myIhOFpw2pwqV3xfJRUyOCuzU1JYGLG5vw5oI/vTydwpIRfwoYrzfdMcLyasYEfCv8j8o5NiuGd3VNsC/k1C+hKBdGTtC6ngI6KScxfyuCcEGS6yQwtaVnqowA2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178324; c=relaxed/simple;
	bh=JWTVGR1fZ/v7+hPYuIjzEW2z/CvCz56GYMVT0fiwgXk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QTmf8QRoYznZtZtNLGfR4EgNr0hfm/IvNI/wPl3X0Gs1p4Ps9wQGgzuP3ZIWwDF1fTB3S+kKwd45aQspxXHLMyEWBiqvxRKoQconiPpL6SHlYB51nSjZBUaioE2lqZBouglXr5xbVA+nDVSlcLb41RkF3vH65VZouzFGypRZK38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=raq2BGzg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="raq2BGzg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=wpMz1V5sYwVy6SK+B7g+ZFAzEWQrNplm+FELNYuAOCI=; b=raq2BGzgM+IoH0eIA4iN0r/UHP
	oy2VrK3V0zTgzmDm8Ztj5xGxSuBwrqm3aAUjJLouCM9kMyGnNsN9LLYoixImOqvcCaan6nJ4z9JQ4
	Qwrc0Bi0+EJuQUsfnCl8F753n+AqddEtYkYJMzpt90MO5MSDgJXeTjh2uE7SEtK0BYHEDWd9x8vV1
	OlCjM0la6cb4QTevsOdTfkXBr0LMBD4q6ud9IwKMrDLG6bwhNjYgRD0LEsUaQVjwIu2AyKMU90xcg
	Y7ageQkGNW6yurHZH+nxBT0SEdk+m2GlgaKb+EyRv9VZUAtDsqvPMQCtOMxOVfQAa6XT3dt5YD12j
	eRMObgqQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tUpIA-00000001pWj-2Odm;
	Mon, 06 Jan 2025 15:45:22 +0000
Date: Mon, 6 Jan 2025 07:45:22 -0800
From: Christoph Hellwig <hch@infradead.org>
To: =?utf-8?B?VG9tw6HFoSBNdWRydcWIa2E=?= <tomas.mudrunka@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>, linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Export MDRAID bitmap on disk structure in UAPI header
 file
Message-ID: <Z3v6khutPZEXkK-j@infradead.org>
References: <20241231030929.246059-1-tomas.mudrunka@gmail.com>
 <Z3v17kZYZnvYPpsl@infradead.org>
 <CAH2-hcK-yF2SbxpXzB2c1Y73gjJxRfbPkmAOvmfM1Uh6QyT06g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2-hcK-yF2SbxpXzB2c1Y73gjJxRfbPkmAOvmfM1Uh6QyT06g@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jan 06, 2025 at 04:40:52PM +0100, Tomáš Mudruňka wrote:
> > the bitmap format is not a userspace ABI, it is an on-disk format.
> > As such it does not belong into the uapi.  It might make sense to
> > create a clean standalone header just for the on-disk format that
> > you could copy, though.
> 
> If you inspect the header in question, you'll find that this is the exact
> reason why this header exists. To describe "physical layout" of
> MD RAID devices. Which is just fancy way to say "on disk format".

Well, then MD already gets it wrong.  No reason to do more of the same.

