Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C7BA3A450F
	for <linux-raid@vger.kernel.org>; Thu, 27 Aug 2026 07:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787817414; cv=none; b=RJN29NPLlVpoJTFJjOjCkwMw5Poqikkto3/MMFbMWlBXlo3EiHr7cKMtY5Uht9lYIKFRF7z/DC93G9Wds97nGcV6GK8E9G9jykdfkU41DRu66rcDJPWHDxvxNriSs2X1fzJuXz6/zUtRzj8gAfl8egKJ9uzNkRDObm7uLc18L80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787817414; c=relaxed/simple;
	bh=G7k/DRjoPQOWVD2fCaS/XGfQrbbno5VKFs5JKVlYmHw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=uR94xjC/7YosvgbzblxeZMt71VWPYh1IKD+VNkbNgbI6gucEPJSdDlBSIgInDc76f8pf6QB8Q2qq5ZwXsxzLtaeg/DhkKj18Cz78GcMVRoo3d4pN6bwgVHjGAYXwuQZQCyOQFQpsNNc16QdsDCJe7F6pGE9twQtmlsVGoy6Y5Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=TeO730RB; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="TeO730RB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=yY
	/OxrcYSF102pRMlkturFbGPlSyDPcUdNRp/OrGBoY=; b=TeO730RBn/rnmGAwKo
	80iSkMTioxMdAsdxsfzX1lfr6eKxHhFHf7e47zK33F9ZSgUAa6do3UCztpLib2r5
	JfkKfrmJIdc4VTER+1qiuulHfCuDtF3y9/bye4g0loC38g+JvjvBJE1QYxRRmmOa
	zGNIHX3s7TDABqzPN4pVeVDmo=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wDnY4im7Y9qjfSOSQ--.19943S2;
	Thu, 27 Aug 2026 15:56:23 +0800 (CST)
From: "Li Youhong" <dayou5941@163.com>
To: song@kernel.org,
	yukuai@fygo.io
Cc: magiclinan@didiglobal.com,
	xiao@kernel.org,
	linux-raid@vger.kernel.org,
	Li Youhong <liyouhong@kylinos.cn>
Subject: [PATCH 0/3] md: raid helper cleanups
Date: Thu, 27 Aug 2026 15:56:17 +0800
Message-Id: <20260827075620.3599227-1-dayou5941@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnY4im7Y9qjfSOSQ--.19943S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Ww45ur1ruF17Cr15Ww47twb_yoW8GF45p3
	W3CasxXw1UG347WFn3JFWUta45Aw1xX34UArsIqw1rXa47ZFW8G3W8JFW8KFWDWry3JF1j
	qr48GrWUu3W5tFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UBBTrUUUUU=
X-CM-SenderInfo: 5gd103ivzuiqqrwthudrp/xtbC+Qcj0WqP7adX0QAA3l

From: Li Youhong <liyouhong@kylinos.cn>

This series factors a few repeated md/raid patterns into small helpers.
There is no intentional behaviour change; each patch is a mechanical
extract of existing logic.

Patch 1 adds rdev_record_write_error() in md.h for the
WriteErrorSeen + WantReplacement + MD_RECOVERY_NEEDED sequence shared by
raid1, raid10 and raid5.

Patches 2 and 3 move raid1/raid10-only helpers into raid1-10.c, which is
#included by both drivers:

  - rdev_bb_block_sectors() for the badblocks-aligned block size used in
    narrow_write_error()
  - flush_bio_list() for the bitmap plug flush path previously duplicated
    in raid10's flush_pending_writes() and raid10_unplug()

The helpers in raid1-10.c follow the existing static inline convention
used by raid1_submit_write(), check_decay_read_errors(), and others in
that file.

Li Youhong (3):
      md: add rdev_record_write_error() helper
      md/raid1-10: add rdev_bb_block_sectors() helper
      md/raid1-10: share flush_bio_list between raid1 and raid10
---
 drivers/md/md.h       |  7 +++++++
 drivers/md/raid1-10.c | 27 +++++++++++++++++++++++++++
 drivers/md/raid1.c    | 42 +++++++-----------------------------------
 drivers/md/raid10.c   | 50 +++++++-------------------------------------------
 drivers/md/raid5.c    |  5 +----
 5 files changed, 48 insertions(+), 83 deletions(-)

