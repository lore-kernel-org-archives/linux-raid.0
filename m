Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79122339868
	for <linux-raid@vger.kernel.org>; Fri, 16 Jan 2026 15:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768576129; cv=none; b=EFrpMiU7OMaXsr4jMj56CfG/c+2hgjHzRvSFMUZSRccZw6HOjTFOfW4l0ekKctwxDsnxsEEKpoxXUesnKawkZbYN1EDYnIQcnS5lWZhiAASra6D6mRJH5SECXigQtwlzEnmCNNsNO0n6NomUdSF08Kui0GYiWfFn0lp1MehRRtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768576129; c=relaxed/simple;
	bh=RopEeRjFHpMn8qiZI9rvhfMtw3zMN3DLlw30r4IZWCo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dgMjRboL8APti140fp4udq+yHB5BI/BUh5rPtHBWotDEsVDlUEi+leIQthEmDDIQg3eU242yK1C4F/V7G6DxR23euBNtkpZ/V+bx9rE1DWCtJdWfjHDVv/3x+uAvZurvCPuXe1hTRF1aUrqC1VUSWXTETb/YSFo29YyGYFUUlwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sStRUgcp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sStRUgcp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=RopEeRjFHpMn8qiZI9rvhfMtw3zMN3DLlw30r4IZWCo=; b=sStRUgcp8TSbZae6Vrm4TM7Ih8
	4j0lLQpQQaj5Q1L829IK/IuHPNAnFoJ7eYiNTAIe4GVvEIgonyzxkM84+nu22kdSdu3XhFBJtXi3V
	i89F3ITVzugD1OJo3uDoQkYjplmSPIKuXOp/TvXhhmjh2iSM8ufYKdeLIFoBOlRIGroQwn096SHos
	PzHQVAQl3DrGBLo5T8udB4OiwAVxq9HAB5BLE6vZ4OhUPNdu8UcUAgLrCTP5aqtb7LYkZ0MthExc0
	PQlRdxA290fbELkDc8mpjdw8LQhDRD4r1rSoMDatk9CxTe2W4mNkHhX3bcAtvK0FvYsbmU0YbFEsq
	ePsbFz0w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vglRQ-0000000EJvq-0Dsm;
	Fri, 16 Jan 2026 15:08:48 +0000
Date: Fri, 16 Jan 2026 07:08:48 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Yu Kuai <yukuai@fnnas.com>
Cc: linux-raid@vger.kernel.org, linan122@huawei.com, xni@redhat.com,
	dan.carpenter@linaro.org
Subject: Re: [PATCH v5 12/12] md: fix abnormal io_opt from member disks
Message-ID: <aWpUgGsZ7yvnnkgo@infradead.org>
References: <20260114171241.3043364-1-yukuai@fnnas.com>
 <20260114171241.3043364-13-yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260114171241.3043364-13-yukuai@fnnas.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jan 15, 2026 at 01:12:40AM +0800, Yu Kuai wrote:
> It's reported that mtp3sas can report abnormal io_opt, for consequence,
> md array will end up with abnormal io_opt as well, due to the

How do you define "abnormal"?

