Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DCB3286415;
	Fri, 21 Nov 2025 05:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763702051; cv=none; b=tzMAlFeUQJsv6tUdyFGj0te3l11Zpa6H+yqKNsICuZC6NCG2YgKJ0DqhL4G7MeV98OqnWJArwPiQslusM5D76eM+Y1dRGpbc5Tr+nBgoXMA799zw0M0AitvRn38PCtaUO0ZZoOR6DnDdGesyGQmrvm96DSWJ6EF8q8C79xRCHNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763702051; c=relaxed/simple;
	bh=gaQng05uNz8a0j9DQ6UE1RpQFnJVXzsGPhiC5QunJKI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZjExGKnS9UsZNwHz8ZrbEoGcy1PkhDUepNv1z0RLhtnkzeVDqH4n6eTnSVYvTx2sqzhVvPLb994vbkJjt68DtwxbFtepRBbLZSrJJH1+0RCQwaYwYDdocumGfNirbr5dHkoM9i2h/xzhiJIyw5bTcZe40xGkHN7wndzWCsUIkrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48669C4CEFB;
	Fri, 21 Nov 2025 05:14:08 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: song@kernel.org,
	yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linan122@huawei.com,
	xni@redhat.com
Subject: [PATCH 0/7] md: raid5,raid0,raid10: align bio to io_opt
Date: Fri, 21 Nov 2025 13:13:58 +0800
Message-ID: <20251121051406.1316884-1-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Yu Kuai (7):
  md/raid5: use mempool to allocate stripe_request_ctx
  md/raid5: make sure max_sectors is not less than io_opt
  md: support to align bio to limits
  md: add a helper md_config_align_limits()
  md/raid5: align bio to io_opt
  md/raid10: align bio to io_opt
  md/raid0: align bio to io_opt

 drivers/md/md.c       | 46 ++++++++++++++++++++++++
 drivers/md/md.h       | 16 +++++++++
 drivers/md/raid0.c    |  2 ++
 drivers/md/raid1-10.c |  5 ---
 drivers/md/raid10.c   |  2 ++
 drivers/md/raid5.c    | 82 +++++++++++++++++++++++++++++--------------
 drivers/md/raid5.h    |  2 ++
 7 files changed, 124 insertions(+), 31 deletions(-)

-- 
2.51.0

