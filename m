Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA09386C15;
	Wed,  8 Jul 2026 09:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783501594; cv=none; b=M4OPKalpZ2XAVQKUdXA8SZuqdqSwczIAmGDbNJin/JGAuEuEt1Rqx3sC4KZ9XbqiQx7aNuuPaK6zsbb0sMLHGJLJEvKZbEFiGE7ItbE6jNtHbeX3o14pZq90CJOaI2ql2jjgtL1au0khAfS+p9YEitp5CzT7qcoE5gJhrx0eBPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783501594; c=relaxed/simple;
	bh=O+x3ydxFq2hAmqU+iagKi0Nukr1xFJj2ZXlGFdaiS24=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fzhF6eWQdf4BT/H6hqxNGSPd7uVwQKgFHJWUr3W2aqNejAubVYJhaBIZYJqmiYapPDVlJJVo2u+EzThN8z56ldnBpV5sA4yjCJhC2GgD8jfIsIjMdybrDL7kPo9uHVT3cdZR/9k7Xd4KHRX/uNB3Z+7sUdEAXWQOCJdeBguYoK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sjx3cKDu; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sjx3cKDu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=nUbbyAoeKDaM1uwdZGkdR1DYW+A3XJcv57pNu4MIwZg=; b=sjx3cKDuTecwaue0+kSVcsLgnm
	zfEqeZtrJtM57ZrulAGC3ZVhi4c7obfCiZ0CyoDw4e3QM0ZzMy2/M1K5WaNH2CmgE3uFTWgVTjG6Z
	a+sbOmJ5TKgZIGxcZPV6lV5zoLCjz7cpdZ0E/vOat69nct+YfyzB6/XAvD5IHrt0fyHSC/h06F80z
	7xl9BbtEY8WCQKpaFKxlA49w3IFI+SdulRefhDhlYqKF10+C5C8s50BdTGbRC9/PGFfuQyavG1xXn
	+B19+sz6ncj5VmioMzbJ3hQ9krhriXAQvI6Q7hnvdTTt++NrzDBx+WQd29tF0Rfcagxmp1jIGB9f2
	ubRcQmVA==;
Received: from 213-147-165-125.nat.highway.webapn.at ([213.147.165.125] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1whOEd-0000000Ghlz-490v;
	Wed, 08 Jul 2026 09:06:28 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Biggers <ebiggers@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: misc lib/raid/ improvements
Date: Wed,  8 Jul 2026 11:05:14 +0200
Message-ID: <20260708090614.1431014-1-hch@lst.de>
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

diffstat:
 lib/raid/Kconfig                   |   15 ++++++
 lib/raid/raid6/Makefile            |    2 
 lib/raid/raid6/algos.c             |  112 +++++++++++++++++++++++++---------------------
 lib/raid/raid6/tests/raid6_kunit.c |   66 ++++++++++++++++++++++++++-
 lib/raid/xor/Makefile              |    2 
 lib/raid/xor/tests/Makefile        |    2 
 lib/raid/xor/tests/xor_kunit.c     |   64 +++++++++++++++++++++++++-
 lib/raid/xor/xor-core.c            |   55 ++++++++++------------
 8 files changed, 236 insertions(+), 82 deletions(-)
