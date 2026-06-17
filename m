Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF014396579;
	Wed, 17 Jun 2026 05:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781675066; cv=none; b=e4Y8BNmqIcEnw9X7hGTmH9viDCUqdNAM06gnl/GEoAHNv7MMESAEHt0Lie/LJI/UOPlA2veQGepKVpkcf8X4zZqtuEgSw8PVKd0DaPeuDa7q80bdfvqdr6wBIunzDjGoKPTUiq8/CHuDsvxarXxv0xq1Cul6k5uKuGhRWGsqFc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781675066; c=relaxed/simple;
	bh=/4MIfuSlzSv9WQiG22l/Ywn3uXnq/wTCKs/qbu20iF8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cTFxTeNN3+Yi+hOP3SwEK9BMPim6B5DEydnOHER55E2t+Aiz1+kKympe7aSMzjp2MPLaLlZTogOOpviHhUKt3DccyDDmE23FyisLCToZ9DlIQJL2P49DyQvttwabfYFZH9SUn/FZSTEbQpXe6S85nqtNnn9svqni7ZSIsW4lr5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=225yTQ2w; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="225yTQ2w"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=/4MIfuSlzSv9WQiG22l/Ywn3uXnq/wTCKs/qbu20iF8=; b=225yTQ2w7uFv9yd+fYo3kO8m7L
	nurOFpqJEGs7y49qwAcw6sW0VThwyyoPBQx2o2GrSSiDYVosLapVqXbCYJtlUW9xHcTvURFs0qWPq
	sivsZiV8bAoWEdePYmi9/MouAiKZ/nWqJuTmwPG4T9a2nWgP35wIfshnKRzbpseTISaT4rDxOv5hY
	LwOQsGAhPN6jze0ZqEZIXZjz6GU6LVVnGo8IAjIPnRBaKMYcSILCEe406bbYPQA3G7w+m2uXTKQxm
	lDRFS35sjTKeKaBaPiz1z518DepuyqODlKUn+1+w1d3Jc17RAi/YQes7MQbb+Ow/ZsxQGLTNtXEd8
	0mqV4rHA==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wZj4W-0000000GfLH-2rem;
	Wed, 17 Jun 2026 05:44:21 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Biggers <ebiggers@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: xor: add a kunit benchmark
Date: Wed, 17 Jun 2026 07:44:02 +0200
Message-ID: <20260617054416.3841334-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

From: Eric Biggers <ebiggers@kernel.org>

Hi all,

this series adds a benchmark modelled after the CRC benchmark for to the
xor kunit test.

This is based on current Linus' master so probably needs a minor rebase
for Kconfig conflicts once the raid6 series is merged.
