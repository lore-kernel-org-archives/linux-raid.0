Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA3B146A97
	for <linux-raid@vger.kernel.org>; Tue,  4 Jun 2024 17:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717521974; cv=none; b=Eym6BzFjfamEw2lkaIuI2sTL2FtW7NfGbwKvb3Mz9aQiqUvu5a6Qs9PbuKz8PV5QgvBcKrLXTmjeQ5tJRS7dIWmjv5O1IxeQUb2NJQzVKjnen7K9SzsPd7MdnXaZJXgX9B4KgwvZ2Vxpi2RDctciHstGvbY4ng/qh4Ys99EM/N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717521974; c=relaxed/simple;
	bh=yESGb1ZO3WwE+MqB9fP2qY8fFpSq535g/oq+UuCOfJA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZZRKxGNM2WSnZxEzmOdQb8ZIGIncZY/2NoaaI0X8Jkl3YyO9JZNT22RnMwi63UruawOw3vPGYiBSG38suefks7lkx/z23VDwfHAJPj1gzv2ns3zWZJwNDfHUeekw4p9GOmjQ6UMKlGwEVJxONdGSQRpN3XoT2gnv6/YEKlBpA1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=psg8V5D1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="psg8V5D1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=WghDAZJjUiJZSDf9k7zrt+69qkdvjeo54wlDVgDCMeI=; b=psg8V5D1kqcdRCe4D0k0pGerlv
	wuMu9n8CLGZtE8mkrVKtbCHyjHRb+80dN2ikpSnhJ5wMAsXJMpF8I9fuVnMoPWnXiam3f5hTNO2/d
	AerD66MtpiWUWmcj0h5tZMRRqxLxSrtmNkswWZqxHQf2cX2lrJbkeSRVSDK+CpIlsfIu6KnnJapOb
	oNaj9jtJ5gHRt14vbrvTNdlxTTIdurB0ZleeFBgXwpo7ScPnuHh2KHWTFoa6MgEmbgiAvRauf41BC
	VqKDVZZVMNIs2ZDr/EWQjbL5OwOUy7x9MyaGeJYcr5J1ZqxARQ6Nkt33pRzYP0tr9+HqQO3WyKInG
	YPEHOgIQ==;
Received: from 2a02-8389-2341-5b80-cd42-c32a-c155-c812.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:cd42:c32a:c155:c812] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sEXvG-00000003Hqm-3c6p;
	Tue, 04 Jun 2024 17:26:11 +0000
From: Christoph Hellwig <hch@lst.de>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: linux-raid@vger.kernel.org
Subject: fix ->run failure handling
Date: Tue,  4 Jun 2024 19:25:27 +0200
Message-ID: <20240604172607.3185916-1-hch@lst.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi Song, hi Yu,

this series fixes problems I found when testing how md handles
trying to creat an array with disks that support incompatible
protection information or a mix of protection information and
not protection information.

Note that this only fixes the oops due to the double frees.  After the
attempt to at the incompatible device the /dev/md0 node is still around
with zero blocks and linked to the the previous devices in sysfs which
is a bit confusing, but unrelated to the resource cleanup touched
here.

raid10 and raid5 also free conf on failure in their ->run handle,
but set mddev->private to NULL which prevents the double free as well
(but requires more code)

Diffstat:
 raid0.c |   21 +++++----------------
 raid1.c |   14 +++-----------
 2 files changed, 8 insertions(+), 27 deletions(-)
