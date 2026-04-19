Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19EE1285CBC;
	Sun, 19 Apr 2026 03:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776568195; cv=none; b=VR+o+DHXddogJPF/Pn3M3+Ji6ICpoWud7yfcFBfjrWETp7t+0Rg2jkVXmyf1Ys7RdwGIeheZJ1JWLTPKopPoyvZcbmSZbcmW5pZM+JwVfvLDMiKQruiSKFz4TUXMSaRb0NuNPgtiD7yaeKydKol4Ug7lFW1blbic+EijRe5wleU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776568195; c=relaxed/simple;
	bh=OttTssuGoEv5p/02S3gu0oa2pvZunOqNo6USFUQ4rYk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=m2NCKBQBwdHbIk/CEZaw0+zZO40yXGP2dM4HYmB20Gu6nP978R7lrC0T+LgCtjuesOK12oS/obcPuFlJEees9jF4zRnQWbS/fGdNrG3Nmq0Rfwc8/Sqsesn7TdINUJg2YUcp4vVmPLbgzA7qRRwX59JH/2BmqqHys4Myh9KvnKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B8CC2BCB4;
	Sun, 19 Apr 2026 03:09:53 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Cheng Cheng <chencheng@fnnas.com>
Subject: [PATCH 00/19] md: support llbitmap reshape for raid10 and raid5
Date: Sun, 19 Apr 2026 11:09:23 +0800
Message-ID: <20260419030942.824195-1-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

llbitmap currently tracks one live bitmap geometry, but reshape needs old and
new mapping to coexist until reshape completion. That breaks normal bitmap
accounting in three places:

- bios that cross reshape_position cannot be accounted as one bitmap range
- checkpointed dirty state must move forward as reshape advances
- interrupted reshape must resume with the same llbitmap interpretation after
  reassembly

The main pieces are:

- add bitmap-side range preparation so md core uses one bitmap API
- split reshape-crossing bios in raid10/raid5 before bitmap accounting
- let llbitmap stage target geometry and remap checkpointed bits in one bitmap
- teach raid10/raid5 to provide exact old/new mapping and drive llbitmap
  reshape progress

Validation

Runtime:
- custom QEMU llbitmap reshape matrix passed for raid10 and raid5:
  - expanded/changed bit-state checks with query_bit
  - cross-boundary writes during reshape
  - heavier raid5 write path that previously warned/crashed
  - degraded stop/assemble data verification after reshape
  - interrupted reshape stop/assemble/continue for raid10 and raid5
- mdadm test 02r5grow passed in disk mode

The temporary query_bit validation hook is intentionally kept out of this
submission series.

Yu Kuai (19):
  md: add exact bitmap mapping and reshape hooks
  md: add helper to split bios at reshape offset
  md/md-llbitmap: track bitmap sync_size explicitly
  md/md-llbitmap: allocate page controls independently
  md/md-llbitmap: grow the page cache in place for reshape
  md/md-llbitmap: track target reshape geometry fields
  md/md-llbitmap: finish reshape geometry
  md/md-llbitmap: refuse reshape while llbitmap still needs sync
  md/md-llbitmap: add reshape range mapping helpers
  md/md-llbitmap: don't skip reshape ranges from bitmap state
  md/md-llbitmap: remap checkpointed bits as reshape progresses
  md/md-llbitmap: clamp state-machine walks to tracked bits
  md/raid10: reject llbitmap chunk shrink during reshape
  md/raid10: wire llbitmap reshape lifecycle
  md/raid10: split reshape bios before bitmap accounting
  md/raid5: add exact old and new llbitmap mapping helpers
  md/raid5: reject llbitmap chunk shrink during reshape
  md/raid5: wire llbitmap reshape lifecycle
  md/raid5: split reshape bios before bitmap accounting

 drivers/md/md-bitmap.c   |   8 +
 drivers/md/md-bitmap.h   |   7 +
 drivers/md/md-llbitmap.c | 602 +++++++++++++++++++++++++++++++++++---
 drivers/md/md.c          |  51 +++
 drivers/md/md.h          |   8 +
 drivers/md/raid10.c      |  44 ++-
 drivers/md/raid5.c       | 114 ++++++--
 7 files changed, 760 insertions(+), 74 deletions(-)

-- 
2.51.0
