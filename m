Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D67B3CCFA8
	for <linux-raid@vger.kernel.org>; Wed, 27 May 2026 07:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779867948; cv=none; b=lp483l5LKKgY3LULOVlYVU1L1hFgUbvP6AcYJZdBcYtdsDeMk7284IcGV0PdAA0BaBf438qh1jAD4qkMX4ePetX+5GQToggiN9raKDcKalK1nzzNacodbk965WfQrtCX2iw4LqapHkCqrNEcM+Iu/plPpiuyubLeiXPerlGXjeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779867948; c=relaxed/simple;
	bh=eY5wIZahothmZtggu0Dz6m15xfQqODqo/yyURMIO1Zg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=q6YXBWNJmrYvOnkbOH9xesiHIw9bf8QzlF3MevHfcsVFkbugc75zua0Zt/dLAF+lzhKNJ0NvsWhhhcmwU9SA3QxRd/H9JO53IGXLxAnERAQ8qRANh2r3Pki6CQBesSKO2uGwGgO173RNuIUxFm2eg2dHNi9GlniITx0OjnRgDYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WIW7NOH3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WIW7NOH3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=rBR3ku19PFFpA6igZtvB2p4ArxVhWwndaHLK+KrGOYg=; b=WIW7NOH3Xlrp/mdzJLm7te4C3w
	TjSs3BGHj9F9hxL22OwwlVeO6LzhpjCMXxhdIGxuSueDRc5LOJk6cgRtRE8LRF8RFKHD9t7xd0yNU
	9Dlykd/JZcOxiDzPr+VUW0ofVdo+Ffuzijjdezw1a3P0nTRe1Tj3ljGa2HIRXr1BeMFWn5nmMQtC5
	5XCamJevFuAA8MVrJ1GJFxdW5ixxfYOmYkftKhYQQkU0gF0qZGoeg17nNZBj294t5Tpa8II91JQYx
	X4BS+JfW0v3MauNrD7lGkiLfqEr087s3kurQzNQX9UhXwToZg91OfapS0S/MmF9Wf9tteB7QqKaqR
	wvaLXlUA==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wS8xT-00000003ULN-1T7a;
	Wed, 27 May 2026 07:45:43 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fnnas.com>,
	Li Nan <linan122@huawei.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org
Subject: incremental fixes for "cleanup the RAID6 P/Q library v3"
Date: Wed, 27 May 2026 09:45:24 +0200
Message-ID: <20260527074539.2292913-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi Andrew,

here are two incremental fixes for above series.  They could be folded
into "raid6: hide internals" and "raid6: rework registration of optimized
algorithms" respectively if desired.

Diffstat:
 Makefile      |    2 --
 x86/pq_arch.h |    8 ++++----
 2 files changed, 4 insertions(+), 6 deletions(-)
