Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279957E792
	for <linux-raid@vger.kernel.org>; Fri, 29 May 2026 05:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780033396; cv=none; b=JNx80X1AZtRaI4wGnOMFilQzBcxXZKaYqj3P1N2Ku+KtbUgxWpctfgu+UOUJQmgPS3ALV91plZfTGUpKpOXj2lL0eEPXG+gUVHEidDRUZvOOkiLZj+bOoEOuztjr/MAVCcJDI0YZpmcNLuDJN1A0ftjdARzCxiiZtdvWT30uNoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780033396; c=relaxed/simple;
	bh=M7As+5XkWCQxv1sgQm0ZB4uLu2z9Bh9+CrWP7GnN6QM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=h0O062KU+G10iO+mkwN3MzQFUoRb+fjUJo3Tel/5FKpyskAHnNfossQsO5q7zPPTHbB/nXZer8a2v402XWxBczcFwXilm5N7qDU2DOzvGH+9Qa1Op8rZSP3QlNT6YGHwJuVe5oNZ9cw6bqLrhPMdYLeqd3CDpYNaWFNnw81L85g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2HmXYBD8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2HmXYBD8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=X1PBGpgYT/zv/xrPLRJsDwZK1zO0QS+sq707fcffIEc=; b=2HmXYBD8/tKftL7JWS1VuY1Rbe
	r7s/wcUOBSxmfX7XXZUs/YVXPJI8XWzTCRFm+ohB+YtLnjTSzXymGwPR8ndaJ9ZhSaNQWz7bdOpZi
	6mOiVMRLTMPHN6YHcawR5J5B+OPvmsK35DUoLhzzVoBsxuOfsNNJepRF7iW8c52Mthp64TkkAn6Cv
	toG6nSYngPIRKgXKAv7wk3TMqLI70ZuJd+GG6hsUEc3ntW2W2Eo0rASlU9qsvcpm1pi7iLzIUCjb2
	0ZGGpDIC3N2LBA0xluZ6KgCVWkoG1pNjznC0AVmW9f1V7xz8/dioBcr4/Y6sft9bcEDqpiyhbdxn9
	NTOinU8A==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSq00-00000006lu2-21Al;
	Fri, 29 May 2026 05:43:12 +0000
From: Christoph Hellwig <hch@lst.de>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fnnas.com>
Cc: Li Nan <linan122@huawei.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org
Subject: two small RAID1 cleanups
Date: Fri, 29 May 2026 07:42:58 +0200
Message-ID: <20260529054308.2720300-1-hch@lst.de>
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

this series has two little cleanups that helped me understand the
code when reading through it.

Diffstat:
 raid1.c |   44 ++++++++++++++++++++------------------------
 1 file changed, 20 insertions(+), 24 deletions(-)
