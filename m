Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9894D23E350;
	Fri, 23 Jan 2026 18:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769192788; cv=none; b=iKCFFTluSjnHvOSi/bgiGEH0I8RRBEgP/8Vt6Tz9kbOAREuEDH4qIXudA5eQiwfV+dVeKfUION+Ne9PHWabSbrLZDrW7b5zU9S6olpP/6TaU1R76CripJfEmk1jBrHSognZz930nzdi4z2uCu+x6WFA96wz51UJ9T8hKmMN+Jfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769192788; c=relaxed/simple;
	bh=cH2HU0qWvjlgMZsn1lIcHxc0KqhpFQM35Rjjw7eZlm4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=n59dkuQKZV4pvE1GBOBm1jxRqBLMx1Lk1AfEbk9aj0hO6ykqvbkIx4KdRHC2lxUqvoW7o+kEO3nr8tajQ4gmhVNyIpL1grEY3Tm0DQ6L7hnzsox0KrN6dEFfXZ8I9mj9a2iLgUR9cJP3bKRiw+152c766Dv1vFDeWF4HOiFbs2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BE06C4CEF1;
	Fri, 23 Jan 2026 18:26:26 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: axboe@kernel.dk,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	yukuai@fnnas.com,
	linan122@huawei.com,
	xni@redhat.com
Subject: [PATCH 0/2] md/md-llbimtap: fix two corner case problems
Date: Sat, 24 Jan 2026 02:26:21 +0800
Message-ID: <20260123182623.3718551-1-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Yu Kuai (2):
  md/raid5: fix IO hang with degraded array with llbitmap
  md/md-llbitmap: fix percpu_ref not resurrected on suspend timeout

 drivers/md/md-llbitmap.c | 4 +++-
 drivers/md/raid5.c       | 7 ++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

-- 
2.51.0

