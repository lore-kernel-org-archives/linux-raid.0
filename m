Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6413F8C0B;
	Wed, 19 Feb 2025 06:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739945477; cv=none; b=DmJ4d//L5pygoqy/Fzu/nCF1gSS9KFqWWT4iGxRqt8VqmsIP0Hvy1Glt7msfYsUd+PseLs4daeFAdYBQwhNNOjcXauOUKaOmK5H9cS1tTaYHQ6B9EJaQ5FDUUqtDPxvUjsKo538eK8XjSCUCo/uZFzIPUUi1mNnWy3wMEZKS4KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739945477; c=relaxed/simple;
	bh=EC7aRhWxEdFgnj9wDiew/+iEhJbj9rkcA+nuvj+3liM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ABaZ9aJP8BCPhCFp3n/w9nIHVCA3t+fxKj1vMbO1jx9cB6FRc1GFzzoNBRCTEtmCO05utkMy+hTmmEEH5/aDu2eAXPi136zgG6FktYuFtM0vuv5+rGDilzbOMDwMSMvxb2awVAI7Plx/hZYIjlkQvhb3/Du5sSZTL7TsSnBuu6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1FqYmu6z; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1FqYmu6z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=oXouTXzjUnrhTVETNlXojPpLysEcZeYgvoq76tXJNj4=; b=1FqYmu6zMH/B7XG2sTb94l33jh
	kEbjksSuAMR3HhjZyiv4QctPeoPbC7PyKhA9q0erNljDXELeObc1DW082YhP06gvt3p9wvPsZRUMo
	SIQM933V/bXKnY0m5B2uA16W0vh4K78JlJDbehTqwnvg0lSjfbUMUAXrbON1UdOgM3btM+c4yGi5t
	X1RxNhBfPmxVcfcOpMEGp7hfBgoRM2uf22xAaHf7XeW8fffh0w8G4NEE/GOsXHn5GqCLJn2d+sJjl
	UwrDnlPEpNRLFHnAs6/H9HMmX7BB0pK9zKgMjE6Wcnd7G+uqz7w9nHstk9beVB2CsJI2kArspVrfq
	6K8WEUtA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkdIi-0000000B0Ua-0FRg;
	Wed, 19 Feb 2025 06:11:16 +0000
Date: Tue, 18 Feb 2025 22:11:16 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Tomas Mudrunka <tomas.mudrunka@gmail.com>
Cc: yukuai3@huawei.com, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org, mtkaczyk@kernel.org, song@kernel.org
Subject: Re: [PATCH v4] Export MDRAID bitmap on disk structure in UAPI header
 file
Message-ID: <Z7V2BOHbY5oslIeO@infradead.org>
References: <bead708f-b901-18df-f461-c5324fbe2555@huawei.com>
 <20250218113849.561007-1-tomas.mudrunka@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250218113849.561007-1-tomas.mudrunka@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Feb 18, 2025 at 12:38:49PM +0100, Tomas Mudrunka wrote:
> When working on software that manages MD RAID disks from
> userspace. Currently provided headers only contain MD superblock.
> That is not enough to fully populate MD RAID metadata.
> Therefore this patch adds bitmap superblock as well.

And despite multiple resends this still is not a userspace ABI in any
sense of the word.  Just copy the header defining the stable on-disk
format.

