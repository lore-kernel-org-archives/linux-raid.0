Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20B82F362A;
	Wed,  4 Feb 2026 16:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770224362; cv=none; b=YbjN9wRNOxCCSv2wfiildASHGV8c8ExB1rvjh75KJBIlUXmVZ6tekLkCY5Ij3tuiRkQAW8uvfcOGjMvX9a0nckFSBTDhctFpqz/quU/YMed7H3OVNXE472fR7ure95gkN/MVM0TwJWYviWlo41WCLeOkfsebf+1A5vZyJDcIq7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770224362; c=relaxed/simple;
	bh=mYnKhlnU+d/RjfkmNUGkKcTsME/w1goLqTpjG6X5L2E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EQsznQqx2tmencIVEQVqvZW5tLSa+B3c6RNynpWg5Ee8DDGwVZB6vjV+C4l2x4hdwYUhr9zOWvB7IbS0PK686qeN4VlP9TbL18TRcqC5epmnk6VaU1kCi7OaCXdcdKvzi9Sf24agtHCacbZTWhW9WvwUWqr+0XGJbZ4fIDSdcxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wX0Zuhr3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wX0Zuhr3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mYnKhlnU+d/RjfkmNUGkKcTsME/w1goLqTpjG6X5L2E=; b=wX0Zuhr3XXImp+AxzRP9sVky38
	qVBTnsdeetEIYvvYaHnIozWTuRCgulXKl1WQv2BVEFsZDtLOnocfGVZpB1rH1ob5GfWzg4EGOJCRz
	Y+bBZlxGnhlzHkJNsWk1bogV5Dp7ImMTPzAoEIHz5I7eoIG0fuIwHXYwU8jBVGMGGFhWLF4hJo5l7
	XGYZpCpluy/qrfukhxEk1Laj443uN1XqVJu+cLmLVXb2tUteulL+7xQ9wLMyoDVYbfWcX5tYcMjlD
	vJkjrkpNMNFjjnSX9Th0FCx67R4IqkwTKpdZpT2wZAbuOU9uor2RYVdQ86HBJ6pWLhWUM5c+d2Ys9
	DvkWrasw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vngDX-00000008oVx-3USY;
	Wed, 04 Feb 2026 16:59:03 +0000
Date: Wed, 4 Feb 2026 08:59:03 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Pascal Hambourg <pascal@plouf.fr.eu.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Zheng Qixing <zhengqixing@huaweicloud.com>, song@kernel.org,
	yukuai@fnnas.com, linan122@huawei.com, xni@redhat.com,
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
	yi.zhang@huawei.com, yangerkun@huawei.com, houtao1@huawei.com,
	zhengqixing@huawei.com
Subject: Re: [RFC v2 0/5] md/raid1: introduce a new sync action to repair
 badblocks
Message-ID: <aYN61wSkiNr97Ra9@infradead.org>
References: <20260203061259.609206-1-zhengqixing@huaweicloud.com>
 <aYGkSwDZTLLbjm6p@infradead.org>
 <40f37494-cf9c-4bc3-aa38-75c76b5d988e@plouf.fr.eu.org>
 <aYIirWALBGrMxmbw@infradead.org>
 <9eba8de0-c3b5-47a8-8729-205e0000fc23@plouf.fr.eu.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9eba8de0-c3b5-47a8-8729-205e0000fc23@plouf.fr.eu.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Feb 03, 2026 at 09:36:38PM +0100, Pascal Hambourg wrote:
> I did not keep track of the models and do not remember them, it was a long
> time ago. They were mostly hard disk drives from Dell and HP professional
> desktop and laptop series, so consumer grade I guess, manufactured around
> 2010.

Ok, for 15ish year old consumer devices I would not be very surprised.
