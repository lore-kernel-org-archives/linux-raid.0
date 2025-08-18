Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E578929B8C7;
	Mon, 18 Aug 2025 08:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755504881; cv=none; b=tQeMk1zBPDucNgaHobiX4zuKJJTow4gfMXbUIbuK34/Ka9xeBbFimQosYQsbFUR3qAz3DSSgexHp/gnhraI9zn4YYsEkTgDgT60wrYAFyRmO7rDMOpXyHW6fRXYbiYkkfi0wc33I4+SihFVjx/JeNLlfwe1tshUFhu1kpDKuuxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755504881; c=relaxed/simple;
	bh=mnrwWKjndoXYz/JYEQ1i/iP5PWiAUSTqSYeORxymW78=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sWevA1W2XhOvSwmyBZZux8N8Ep9LSPfH3DF4MC5BOYq48u6sBO+k9EGynJELWSMMF+KvMsX9HrDpCO2jYyrwwRH9qbrjUetdudHY49/3hvXN80yf0dECmIMqSdOslScPwyOlrrynNoedfN+GXW35/bzbELli9ckuEaO1LbJE1nI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=V6ZXNrvN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="V6ZXNrvN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=woia4pGhdfQCdmebfoJ8hoZTodcCOky+OFdjamql6a0=; b=V6ZXNrvNPWpVvymnUK1YEgZbDv
	qN4aOaMJ+CxjqP6/2VojS9tiaYtGW0sOssupmiXpK7RaHcmg4L0uccXATGu5SEi8J0TzrfX4qbb6e
	jEv5mHnHYhAR4hFirRA6bLqbV4q+rtApyoj5OOFQMoIAbVi2JovzO/XJDWPG0xKxCIY6BHQS23Att
	WXwx1E+o6EGZtly5zXRBFPS7m/Wa5rlMZPOuYaKDIpaaqNIIGng8fIcVBDKW2ATplzkkQ0JW706Da
	AfzYfVvbTwgQd/kCyaxdG2AaWk0kPk0nUvgUmsBh9HzNBUtru8yILDXgpzLvNYjSplKPkCKZlf6Rh
	uavb5bfg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1unv0m-00000006vBH-2jlX;
	Mon, 18 Aug 2025 08:14:36 +0000
Date: Mon, 18 Aug 2025 01:14:36 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Damien Le Moal <dlemoal@kernel.org>, colyli@kernel.org,
	linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
	"yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH 1/2] block: ignore underlying non-stack devices io_opt
Message-ID: <aKLg7HbvjVkqB8Uu@infradead.org>
References: <756b587d-2a5c-4749-a03b-cfc786740684@kernel.org>
 <ffa13f8c-5dfe-20d4-f67d-e3ccd0c70b86@huaweicloud.com>
 <fd5c1916-936b-4253-a7b8-ba53591653f3@kernel.org>
 <4aa48545-7398-c346-5968-5d08f29748c4@huaweicloud.com>
 <aKLAhOxV1KViVw7w@infradead.org>
 <de4fd44c-f8be-e787-27f4-9e9e09921e12@huaweicloud.com>
 <aKLFuQX8ndDxLTVs@infradead.org>
 <e00106ae-e373-9481-8377-5e69203f9de0@huaweicloud.com>
 <aKLdm4GPVfXOm0vO@infradead.org>
 <aa12bb2b-0767-a30d-f7a6-a13722711828@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa12bb2b-0767-a30d-f7a6-a13722711828@huaweicloud.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Aug 18, 2025 at 04:10:32PM +0800, Yu Kuai wrote:
> Why? We just set the flag for mdraid disks first, and then inherit to
> top devices that is stacked by mdraid, so md raid limits should always
> be relevant. I still don't understand the problem that you said :(

The point is the fact how mdraid calculates the opt_io is somewhere
between ireelevant and wrong for any layer above.  The layers above
just care about the value.  And to calculate the value you don't
need a special flag.  mdraid can simply override io_opt (or better
max_hw_sectors) after stacking the lower level devices with a few
lines of code (and hopefully a good comment).

