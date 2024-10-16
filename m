Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A6AF187874
	for <linux-raid@vger.kernel.org>; Wed, 16 Oct 2024 03:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729051187; cv=none; b=lC99r2d7DfvPKGIfNHNwZVSEz6TzdT1JP14C9oc4k3cgh1bTlX5LSPuzTNsgTL2IMzYhHH65qz19iYaGisbob9Ig2N96N9ksx9Zm2v+Eb5Q3y0+CnsFRg69QX3d7wyfL+AhJ3/0qEtBtcdFHxdcGFu4mvmgNwJbG/T4/s/gT+X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729051187; c=relaxed/simple;
	bh=+oV20xf5ZHvQkgS0iK+tQ6HJ/dHxw7WFIXGfOlo8U/4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D7po6fb4cubjvpqxcjNp08DQhT8Xa1pPTfFLa3+7v5JwxaoHlh6nyziZLN7TOH7Y0epcrVYQCst5O1me95++gDySEI95hjJQdve0SthI+pN++kxS2FpxPVvPW/PfxSnbh9biIkqVrycNN3NpMvl5kQFz2OFIB5uI1Q93F4Hyt3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZT5Hh370; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZT5Hh370"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+oV20xf5ZHvQkgS0iK+tQ6HJ/dHxw7WFIXGfOlo8U/4=; b=ZT5Hh370E4rIVsQn+3Ei3VdcV+
	sQUdH6VOjuTmla21pXJxbqTLNA0jfmdUxlZ79vZqxPtVl2L5TvH67c6aZ58j8n6hzhXDRF61HoAbP
	GK3t5gYdoRdrijpu57Aixu1ta7Dyp2tHtfPgJe4aVbrMjhNNTjRCcW1621qh3dPgofliFsSQ0P7T0
	cY5dKjcvbdqTM6alAs8E4PX3HSFBm1M50ex3kQuXt6z5P1ehzzkfxC/F5mOhfLCN4Q3dPGZG98x3q
	Q32KBTNDaJSujalq5EWz+I5eY/ASAt6kJ1VhwJTUpJMp4UoZQyoz31m/LH1T9bCvEviT85i1U6zXQ
	6QLfZ3nw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t0vCK-0000000AQJj-26uK;
	Wed, 16 Oct 2024 03:59:44 +0000
Date: Tue, 15 Oct 2024 20:59:44 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Laurence Oberman <loberman@redhat.com>
Cc: linux-raid@vger.kernel.org
Subject: Re: [PATCH] Add the ":" to the allowed_symbols list to work with the
 latest POSIX changes
Message-ID: <Zw86MBHnb5PsbH6c@infradead.org>
References: <20241015173553.276546-1-loberman@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241015173553.276546-1-loberman@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

What are "the latest POSIX changes"?

