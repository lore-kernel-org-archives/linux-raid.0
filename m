Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C689358389;
	Wed,  8 Jul 2026 09:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783501666; cv=none; b=V1nhjxVmSqGLrG2MFYKrrn8sWcQgVZ2FOGW/4tEaT9YEYn/skG7tvbCL0HO2UsjXT48NSG5sz+G9oiu25Qw2c86TkLzokcMk/SW/bGSPvWg9CvI50xiqfqbhxO7BO/Y6Db9ROxXQWtp1qw/JRNFwWQ5BOsckEhObUHih+OVoi/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783501666; c=relaxed/simple;
	bh=O+x3ydxFq2hAmqU+iagKi0Nukr1xFJj2ZXlGFdaiS24=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dDB/MP3oFXpu7UiCXizCbBhTOPYsIO4EtauJ0Guo42ew5fE23oDbxXCWLCIgAgpVlshHyF2TEATvpdyPlFK4iU0lQngFLtP4gU/ZvF54zBkueYoHMdAsQNpJlemNQMxQOvy5EYn4qmWVc5rmy6V9DkWWb3+CJYFnN5wBqbPBzLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lt/G3qDf; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lt/G3qDf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=nUbbyAoeKDaM1uwdZGkdR1DYW+A3XJcv57pNu4MIwZg=; b=lt/G3qDf6turF8t5bLScEiDbMs
	JSmJFJ5IwU9rVovZZO8ViSAzwtF+rd3w0AswytP11jYgbewYqL42zID5O6NapBZToXt2BDRk4jN2D
	rVU1yPLJOknattI0ZcVTI5rZoLIvteIMabfF3eRx07vAaKjNZVhgPldTVDZN3/qeG0R21Mz6eOdtw
	XVK7a1Snk3vH1kXAJblklRzuZMDp0h8ZeeUG3ggLWtMCT6wJkMNEbWrPR+V398q1kQpkCrde25uw8
	ow/0VVVKubaSw3BV4dBPxJnRLSjnj1y8FCgv7aB0OyRZV3whtkCjiLyNW7akLaJ0E7AKdsXYWVt98
	B5S3xppQ==;
Received: from 213-147-165-125.nat.highway.webapn.at ([213.147.165.125] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1whOFs-0000000Gi6q-2y0W;
	Wed, 08 Jul 2026 09:07:45 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Biggers <ebiggers@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: misc lib/raid/ improvements
Date: Wed,  8 Jul 2026 11:07:29 +0200
Message-ID: <20260708090740.1433685-1-hch@lst.de>
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
