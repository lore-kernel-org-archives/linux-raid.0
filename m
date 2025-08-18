Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1CF30DD2A;
	Mon, 18 Aug 2025 09:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755508120; cv=none; b=a8NcxwmQXO/bRPu0MJiXjaP/Tg7s/0TFt0LzJDQC3pWaIXIqLflCKDY0Q06OyOUnZnLejWdD1a0GehfA3zU+pDSTckTc/HXcpR51+RL7nDE7T1NBrPkvmbezKLG+oI/ypvE8vJuuCoS0IZQYEVst5fyIcze6a0ErZeuvFBZfc64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755508120; c=relaxed/simple;
	bh=xdH66jWgpzzTFfGTToB5qVH9hBTVfljWsEB7eaJd07o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ui9xB6j4cMth2diTOiUfTiRNWuAbd+Bef0JNLBAVPgOSd9KHwdRBldgD+wSl37qiftOOvyzVKExmV0Md2bGhNqrzT1xB8d8aGzfDiINfm7Y7VtRsNQgLM7Cf7uYvdEDrQamyLqLmWC38I29iFNvZNYWOYAJckVd+wtFsX8eYN4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Su+5NzDC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Su+5NzDC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=yHL7eu5GUAZjY3FC7EVLvh5Bh6QegvU2AsH3mijGkys=; b=Su+5NzDCgNR88W1ifQhiFSAeCR
	28/W8l8unnJvRjND+oy/ZBeiui7ZfrDP8KbU6jvgAaSxBVuqmBNrmPdBakVoKRw5aeAgxuKB9WsRV
	2mwlzBQdpVDrUhKjVeAgM6pDp4tP4B356O48X58qxICg1YRSzFDxKlcT0N59JjCC77TXFWwX5vUR+
	d59aqQDT9m5GhTYfeHqkowG8tt2Bqb+oTdRm8fKKdIKh1rYMdbF2LD8zrOUHXk65y13vZptw7upQT
	yAko7GXDFJI3CwVzu7l8QHLLzpJpGQK05tlDEENV0vmAckaz0Si9TguT6G5zJjiSrYZce+h1J73Yb
	Rsw4i5OQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1unvr1-0000000718x-16Cz;
	Mon, 18 Aug 2025 09:08:35 +0000
Date: Mon, 18 Aug 2025 02:08:35 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Damien Le Moal <dlemoal@kernel.org>, colyli@kernel.org,
	linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
	"yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH 1/2] block: ignore underlying non-stack devices io_opt
Message-ID: <aKLtk7vdD8LpOyEy@infradead.org>
References: <fd5c1916-936b-4253-a7b8-ba53591653f3@kernel.org>
 <4aa48545-7398-c346-5968-5d08f29748c4@huaweicloud.com>
 <aKLAhOxV1KViVw7w@infradead.org>
 <de4fd44c-f8be-e787-27f4-9e9e09921e12@huaweicloud.com>
 <aKLFuQX8ndDxLTVs@infradead.org>
 <e00106ae-e373-9481-8377-5e69203f9de0@huaweicloud.com>
 <aKLdm4GPVfXOm0vO@infradead.org>
 <aa12bb2b-0767-a30d-f7a6-a13722711828@huaweicloud.com>
 <aKLg7HbvjVkqB8Uu@infradead.org>
 <917dc054-8423-4e49-7101-1667e64aae10@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <917dc054-8423-4e49-7101-1667e64aae10@huaweicloud.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Aug 18, 2025 at 04:57:30PM +0800, Yu Kuai wrote:
> Ok, let's ignore the case there are other drivers in the stack chains,
> just in this case: mdraid on the top of another mdraid, which we already
> have. And in order not to introduce regression, we can do this inside
> mdraid.

Whatever you want to do in that case you can do by looking at
BLK_FEAT_RAID_PARTIAL_STRIPES_EXPENSIVE.

But I'm not even sure what you want to do.  Assume you have to raid5
stacked on top of each other, using the same chunk size, but a different
non-multiple number of stripe units.  The only thing you could do is to
multiply the values, but I doubt anything above will take the resulting
number serious.  And depending on the stripe size of the lower raid5
the upper one might not even be capable of feeding it large enough I/O.

