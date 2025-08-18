Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C412C17B2;
	Mon, 18 Aug 2025 08:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755504029; cv=none; b=oLXCE1kqV3l8slcW9d6f1st0hZW7/r+XFkdHcvlE8u2dA7KSOeUm0VPxGZ60/qX1rgnKECPhMLYLBClShFPI+v7AIpM+0uw/tJzESp78raHjCbHSPSYwQfay74lZTTo6td6ZoPnR9NCD+xOp3LTDGkDCMNvbzY1N+wIWEa7X8lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755504029; c=relaxed/simple;
	bh=j5sIAyVPeo2KNIeJHfWDYFtCbhgxpH7HxMdt+aGprxw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jPBO8CY2XGR1Ox6C3t126Mz6kgIad2le1PTCuGAeEtnEWwUnU2/59wNWV8Lrcnyo2YErXJvCepz6MX1d+f9RsHru93X3QJCCkpr8V3HFJlj8LW+iGECgcVSpnugSIQ2G8mxtr/b7Kl42ripZh6dwEFBrQdtXxDM1gQ89NA3Uap8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Lnj2T4SY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Lnj2T4SY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=Gw1G3cuglJNR+ceN+k8akrParKxl3Eh0TNyKyEcntvU=; b=Lnj2T4SYlsv4ryeqMP7/va6yPs
	/JXCuXcOA6bC0yjZeA2iWeD/wNPonQHXebJYBJvsNzuFgxWicuKPTYDBuz/MvwQhTN3TxKZUisQD4
	JXSMc+EL8GpEIIadHtEXxgx/GuvU/fA/aT+9w4Rwbw8qvyvHzE6OeM0qp/NdE8keD7dB5S2C7p6AR
	kSBylWB7iQAGGAGdCwi7Ue5smu2K9ZWBLpx9a82eB9trXFotm8R/lut/w0xBvyNAW/vg72igTGkOM
	kb28Bbo82WLjp0TpUCDpEexahOGwlzq1uObQin8hX3YkfUSjBLlS7cqdeV+sqWnNwltBgMpDjlfNy
	0OaBjshQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1unun5-00000006tSh-2C5G;
	Mon, 18 Aug 2025 08:00:27 +0000
Date: Mon, 18 Aug 2025 01:00:27 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Damien Le Moal <dlemoal@kernel.org>, colyli@kernel.org,
	linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
	"yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH 1/2] block: ignore underlying non-stack devices io_opt
Message-ID: <aKLdm4GPVfXOm0vO@infradead.org>
References: <20250817152645.7115-1-colyli@kernel.org>
 <756b587d-2a5c-4749-a03b-cfc786740684@kernel.org>
 <ffa13f8c-5dfe-20d4-f67d-e3ccd0c70b86@huaweicloud.com>
 <fd5c1916-936b-4253-a7b8-ba53591653f3@kernel.org>
 <4aa48545-7398-c346-5968-5d08f29748c4@huaweicloud.com>
 <aKLAhOxV1KViVw7w@infradead.org>
 <de4fd44c-f8be-e787-27f4-9e9e09921e12@huaweicloud.com>
 <aKLFuQX8ndDxLTVs@infradead.org>
 <e00106ae-e373-9481-8377-5e69203f9de0@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e00106ae-e373-9481-8377-5e69203f9de0@huaweicloud.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Aug 18, 2025 at 02:31:20PM +0800, Yu Kuai wrote:
> Hi,
> 
> 在 2025/08/18 14:18, Christoph Hellwig 写道:
> > On Mon, Aug 18, 2025 at 02:14:06PM +0800, Yu Kuai wrote:
> > > Please take a look at the first patch, nothing special, the new flag
> > > will be passed to the top device.
> > 
> > But passing it on will be incorrect in many cases, e.g. for any
> > write caching solution.  And that is a much more common use case
> > than stacking different raid level using block layer stacking.
> 
> I don't quite understand why it's incorrect for write caching solution,
> can you please explain in details? AFAIK, the behaviour is only changed
> for the first mdraid device is the stacking chain.

The way I read the patch, the flag is inherited if any underlying
device sets it.

Now if you stack something that buffers most I/O the md raid limits
aren't really that relevant, and you'd rather expose the limits
for the writeback or read caching.

