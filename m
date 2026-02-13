Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64CDE31B104;
	Fri, 13 Feb 2026 08:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770970510; cv=none; b=Mf47NtuVHzJvFzfwRoL82DSa3U+EW4t5sNO5iNkI3PdUbdCEZPTHaLWPd4OeSiW8SKcOzVw2toLk9Ikm4spXbU6L5R6Ltvi2Hdoj/9W/5lk1csDQVBdKhw8pUvtdxa+iOTyUBvVhaISlnl4jVwwlPGfDihpLerFDm82+7qJO++0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770970510; c=relaxed/simple;
	bh=jSBQSw6o9n8EJddhB1Tdikf8rBaLb2R/np+VQZXzgJQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vgl2K3wDaOd4/4E1idYR/6pzLUPqnr0Nt0D0Ov1vDQQaFjYu+J6xTOsGf5xgGf5x9rm2hceiFb45tc4IanUecYCicGssiuBYMwqbq3S7u8oqNJ6L/oILnZGq9o+D1m78aM4Qezv54OUkEAuXxS124C/WFU3H7yNFzD5b4tiJaQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wU5n/IFl; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wU5n/IFl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Ms/xXHoDE/ZA8bVzYIqPWFvuH5mKoeN8UwJVkuRrdTE=; b=wU5n/IFlMmKQiK63l6qCWKtZgz
	9Zu9ENz62DmT0Ee+mmIHewu0k26ziL0Fr0GLbXh0Pe/VQCflLQqyhvhi87P10krXi84mSiFVHrCVJ
	fCUBrXxfbPiyQZlFGWJY9HWxFfCSYOY0v0QS6ONHyXcRViKwiDEjrNs7pqegbQ3ipBEVmnC73qQEc
	N6cim9xScCZdgl9jrcopRZlaj31RXdMwusP/NcQN2JV4b2GsVJkrpeRvtLV6tiKb/oH827F7Braup
	2q/hNW4bTqLZiDDqn2ZOBjr3TfZSM+Obyb0pCcd9izHE09KpmCdbTOI92sG9pANQksFkZuBAmB1Qq
	WlwdOZoA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vqoKP-000000039Yn-3C72;
	Fri, 13 Feb 2026 08:15:05 +0000
Date: Fri, 13 Feb 2026 00:15:05 -0800
From: Christoph Hellwig <hch@infradead.org>
To: sunliming@linux.dev
Cc: song@kernel.org, yukuai@fnnas.com, linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org, linan666@huaweicloud.com,
	sunliming <sunliming@kylinos.cn>
Subject: Re: [PATCH v3 0/3] lib/raid6: Optimize raid6_select_algo to ensure
Message-ID: <aY7diX0apPxgxhjT@infradead.org>
References: <20260213031419.125069-1-sunliming@linux.dev>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260213031419.125069-1-sunliming@linux.dev>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This is actually a very bad idea.

The current indirect calls for the raid parity generation are very
expensive and need to be replaced by static calls.  Doing runtime
switching defeats this.

I had started on doing the static calls a while ago, let me try to
finish that off.

