Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62DB39526F;
	Wed, 15 Jul 2026 14:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784126915; cv=none; b=TNEAotAz4eChiIZ6kWsCVY/Qq/+bsKf1AtLtMEha7inr9cyoIqi5gsCObPgnlry0vaSLVe8KGXtE0jIx0NykRR93tNVAuJboFyz/4l4gU93/me5lFEd98EIFCTIDEjxTsNfHYe0o774rbMVS9YRTdlEnasgvOielcIF8i+Y6agg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784126915; c=relaxed/simple;
	bh=A8B2DB0KVdyPvdxMrvTIm5Nf9QT6+EU+IxRFnyzH6uw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nx3X6KXE+TDoLnmrz4m7IoFjVuH69PXLsgJkrZCiWeBrE/v7Wk2051k9Q5VAZP/AsiUfXAYItJM3GCjsXln4f8qSVH/whSOqEtZM0LeT74mRe/u+cG7GXDouvQXHdmN9hhhRfDtfM77ypaQdDmp+3LnqiXidBDYk8TF4gNwWIZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ngWeQjQP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ngWeQjQP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=Zsh5cOZLhiBTZgD4h/g9SYxsHjSlqjRiRUncMhY25Aw=; b=ngWeQjQP7p74bGdYzLIm25V5TR
	VvWknqIB00X5HlMYT66mS8JQkmlx7Hb3b0VpfuRW8CfENO37fbooDI+p/Ks9N/xSN+K+t4iSR4T4v
	EWUAfnZPrSpm7CpoHZOx4SHKMk92GvmL1aLF4wvWAEtnPn8Zgsk6rA+zvHMN8yZa5W3tWPy3widtT
	Vj6Ybov1Ox9Yog6F6KM8pF7FE/F67z5CM56ek45C78a2HoLjqkE+BXXQKEdMoVVN3qBEK4M4biVX4
	M2jcyigH15jLZYv4DUp/xvIk5FQx/mWrkpbinKOrpVDn2dCe0HWCyofxYePh7loRDghgpnHSMyzOb
	6hlfoV+w==;
Received: from 2a02-8389-2301-9f00-b29a-36e9-8c1c-0994.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b29a:36e9:8c1c:994] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wk0uT-0000000FD9U-2bRs;
	Wed, 15 Jul 2026 14:48:29 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Biggers <ebiggers@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: misc lib/raid/ improvements v2
Date: Wed, 15 Jul 2026 16:47:31 +0200
Message-ID: <20260715144825.95432-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series improves the benchmark-based algorithm selection and
adds kunit benchmarks for both the XOR and raid6 libraries, and tidies
up a few very minor other bits.

Note that Sashiko still complains about long preempt_disable regions.
While that is right in general, it is very much intentional for these
kunit boot / module load time benchmarks.

Changes since v1:
 - fix the deferred implementation backing
 - remove pointless variable shadowing
 - fix up a commit message
 - don't add a duplicate RAID6_PQ symbol
 - fix the calculated RAID6 "XOR" bandwidth
 - floor all timing delta to 1 to avoid entire hypothetical
   divide by zero errors

diffstat:
 Kconfig                   |   12 +++++
 raid6/Makefile            |    2 
 raid6/algos.c             |  102 +++++++++++++++++++++++++---------------------
 raid6/tests/raid6_kunit.c |   66 +++++++++++++++++++++++++++++
 xor/Makefile              |    2 
 xor/tests/Makefile        |    2 
 xor/tests/xor_kunit.c     |   64 ++++++++++++++++++++++++++++
 xor/xor-core.c            |   55 +++++++++++-------------
 8 files changed, 228 insertions(+), 77 deletions(-)
