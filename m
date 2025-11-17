Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9BA30FC1C;
	Mon, 17 Nov 2025 08:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763369761; cv=none; b=iCG3bUkU5KLSmg5VUZuV/DqtUkko3CTsxuehTSHlVTskC8tiRysX4Y55tnRZqByq/dVBDeflaBIlbrznAso4osUyLbm1BcryRXxGZrh9sWNI7fr9ZF4miCM/Oyfe+Y6YNLTK/noXFrQ6YbGg9+LpLjBnsiXmcWwO1u3sgjVU7Zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763369761; c=relaxed/simple;
	bh=s8NaQ5iJHGfyfwQtgABVDeNsCSgSFBt2ev5260AMWE8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SDVFzL/V/qI2BTD/NKf0kpaeugB0pSoI4cyAsg5l5kB0HJ6nGO0jOYGElulgxIVeHiIRjDBzcUQWT8UdDjPLu46t1/fXrZ1LZSQGR97GvTGRdrivXG2JktxEzQ+fBtIu/76Qd2jijhazlpxg1t8+BzrZbjL0ua4l6Ax0jXwA4o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD210C4CEF1;
	Mon, 17 Nov 2025 08:55:59 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	yukuai@fnnas.com
Subject: [PATCH 0/2] md/raid5: fix IO hang when array is broken with IO inflight
Date: Mon, 17 Nov 2025 16:55:55 +0800
Message-ID: <20251117085557.770572-1-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Yu Kuai (2):
  md: warn about updating super block failure
  md/raid5: fix IO hang when array is broken with IO inflight

 drivers/md/md.c    | 1 +
 drivers/md/raid5.c | 6 ++++--
 2 files changed, 5 insertions(+), 2 deletions(-)

-- 
2.51.0

