Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8124816DED2;
	Tue, 28 May 2024 13:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716902632; cv=none; b=I3wRUETDSh3htnHnLs9EJ6/6ej8B5dJWa84dqQfWPrU9r1OqqwARx5AP37dVYVFGzaevfNECa2Yxn2KcwdYu290XliaQZz5J2aSTgELEKqwyHOxxKxYH06I4CVWBfjHJ7A03HXXmKvIzJ/5rHD7mOjK2bWpsURVT1eI4q2bgFP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716902632; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DOHejOo9UkMfhTi79SyvF06CwEWJiV0DBd/Orbh4NQpNRARi7FaavpqG5J8uvEJ8vwFzW8NKP6IAaALGyQoM9dsr2BBR3vBKgVXOw99sKOlxhVEYr5anq3nnDacyzulNtn1mB4Wcy+jX6B9z0QJbNLWYswMrOr8qkrDyoc3SoeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=D0LxMqDL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="D0LxMqDL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=D0LxMqDLPlWRdYRnVXK3JjHb8D
	+eJNJuOJpUmqTsEbgSV5I4mQnke4res/wSfjANbIbTSE5+LCRFftLrWTVKe9WZFuBoBBHaK1MqJQL
	1y2MQqVsk2KQpOY9M8v1aoV2+ERgq665HNbiE+UQ/TFLnSIYZ6tSsYyPPZT86vb2essezO55l5A2s
	G/SjMDm8SMuTw/L1Mz9OKeGmx8wg1Xxht6uyGNxfmUH3OphVtHYL35zEe2Hau9Eqxnc1vpP3ysXay
	GxZNnjZimL4N5YcRYGGw6VpZiKO34GGoavEhIc7NNEb5G8FjR5ovZ7p+R9QFLMoesA5od7X3FW8jX
	rrLfWVFg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sBwnu-00000000mfM-0lQi;
	Tue, 28 May 2024 13:23:50 +0000
Date: Tue, 28 May 2024 06:23:50 -0700
From: Christoph Hellwig <hch@infradead.org>
To: linan666@huaweicloud.com
Cc: song@kernel.org, linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org, yukuai3@huawei.com,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH v2] md: make md_flush_request() more readable
Message-ID: <ZlXa5mFl9x4Lk4KQ@infradead.org>
References: <20240528203149.2383260-1-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240528203149.2383260-1-linan666@huaweicloud.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
