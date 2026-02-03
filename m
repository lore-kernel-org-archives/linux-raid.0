Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCDDB21146C;
	Tue,  3 Feb 2026 07:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770103901; cv=none; b=h1eNDxFpIoL28bHpLVIZ9uYuGFAp/QN9M7M+1ueq8JD6+9gTD7ayeixXkBkhYotbvCspb60XoW+pVQsVF267VAA9rCgY//LAUTCNmwuyKicN3OGMvLjsi4UrAW53n8ljHaUHQA9E/IUg0EgWCwTnJ7X86mMw0m4qAUXg5kzMOPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770103901; c=relaxed/simple;
	bh=b+DuKA6EH2nRKKa/FX6vz0JwIA+3DCXu45CBzoD6Xks=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S+rdDnU7ZNdSM0w9u5YEWzSzuXoYGGHv8YOX9tKNOgX9MGv4/VFjr08E5j9mDLMkPOFKdr4zFaze5RHYpwudRp8lhXtntjW7tBoer8aPx62DU4XLOtSo5/a1I/yMIrwRRzRU4WrMqDSDKT7iMYVG86dAMPw5nth5HUu15ht2O+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=I9btoHPn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="I9btoHPn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=b+DuKA6EH2nRKKa/FX6vz0JwIA+3DCXu45CBzoD6Xks=; b=I9btoHPn/JlsQwjSGdn9xtrhtZ
	MmcOR6MQr2nsqVRCB63hXAfcdFCcvXCbFcAt4XOXh3864ES0vnI9JwhNWUn/z0S6WvMPNNyc2ujdw
	qJSBoq0dOue52W8PHdwRm2qyqhtWzkOm2mwbzheSPVXKBFFWVfw1qDsGHogLcVDBUYVCLt4fDYffA
	rtklUBAsLIHeFjXgT7Jfy2dLGDHoH6Mf8FkT5SVJm59ckXMMdiV/Bi50TDm3Rf6WpGqrBpWCOkXo2
	YF2BuJu6U3D1hG4yMh7ZcRNPU9c5Mp67eOlT9CSU50wP9V+71i3y1N1qiYYRAFngreQpVPygNZPkI
	FgNbLGjA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vnAsd-00000006F8X-06Bh;
	Tue, 03 Feb 2026 07:31:23 +0000
Date: Mon, 2 Feb 2026 23:31:23 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Zheng Qixing <zhengqixing@huaweicloud.com>
Cc: song@kernel.org, yukuai@fnnas.com, linan122@huawei.com, xni@redhat.com,
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
	yi.zhang@huawei.com, yangerkun@huawei.com, houtao1@huawei.com,
	zhengqixing@huawei.com
Subject: Re: [RFC v2 0/5] md/raid1: introduce a new sync action to repair
 badblocks
Message-ID: <aYGkSwDZTLLbjm6p@infradead.org>
References: <20260203061259.609206-1-zhengqixing@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260203061259.609206-1-zhengqixing@huaweicloud.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Just curious, but what kind of devices do you see that have
permanent bad blocks at a fixed location that are not fixed by
rewriting the sector?

