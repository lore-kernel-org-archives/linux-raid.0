Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E319B2D6E7E
	for <linux-raid@vger.kernel.org>; Fri, 16 Jan 2026 15:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768575963; cv=none; b=pRTUFJfTe5pyVyJ0HE6mW2GIuRChM5fdnQRu014k0VQbgjiCn7u1DDQIgA9ffT+bGcXYb9EDtoxTekeVGwvTP7OZqqNnlwJtik3+OVoDmObpzg4X+gS/pYVFyQJdZxZfRujHDOs0ezAEb8Mr6KNbqA1jjAkXeaM24b1S+0eQ6bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768575963; c=relaxed/simple;
	bh=L/Om+xdUvAtkzRTRW0TgGx+q1Vk4fj3g9JGdOkyozV8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L+vam0S8KZXuPzrbxgNRkyRVviE+6ycawoJsts+ZNWb01WsJ/BdyuBOsJQEUH4OI12b+0OVG32Bv1Ehwt138Isv+kSNYpV85uwVKo1EX5Otj5lMjhdWBXB3c1HgsI3BQrz6LFi/r73nMSsvOmBi5hcsgmSlYdeZ2YZPqqF7X4nE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=s06imNjr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="s06imNjr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4fctYnyIhmSaoil8eNs2ikSWnxbR7wA/DKs73IxVRFw=; b=s06imNjrYaLgjRD6HNBQ/4k+w7
	Lw7LKXRjZZeQYG/SObmUdqX9Y6q2wsUnDbiuQZ1YIgAa6oSoAfql4GlDdT4ZXgqnUtmZ6otcWW+5c
	iXUgGoUIJT/rjhsUNkccMn9H+Ld4a9k/aiVh6iUTGc6xom4CvK11B13gJEVBSomU8dw4fFipJmq/y
	Q04XHypO2QyPxS2fUszknpj3lQmSca4o4vPVS81wO2b4hUHb6Q153Ttk9VbCk/w8eOe0/sV6eAymh
	rG2Pf/eN5ThGfXI2FubXVU0Qh3nNfg179KJYrJITZcJlV/dvUDa3j2GyQec3fuzY0BDQN2dsB7E09
	1CnEMxZg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vglOi-0000000EJZt-3cV0;
	Fri, 16 Jan 2026 15:06:00 +0000
Date: Fri, 16 Jan 2026 07:06:00 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Yu Kuai <yukuai@fnnas.com>
Cc: linux-raid@vger.kernel.org, linan122@huawei.com, xni@redhat.com,
	dan.carpenter@linaro.org
Subject: Re: [PATCH v5 02/12] md: merge mddev has_superblock into mddev_flags
Message-ID: <aWpT2N7S8l560MIP@infradead.org>
References: <20260114171241.3043364-1-yukuai@fnnas.com>
 <20260114171241.3043364-3-yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260114171241.3043364-3-yukuai@fnnas.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jan 15, 2026 at 01:12:30AM +0800, Yu Kuai wrote:
> There is not need to use a separate field in struct mddev, there are no
> functional changes.

It seems to be that right now the bitfields are persistent "features"
while the bits are state.  This might not matter much, but it seems like
there is some rationale behind the current version.

