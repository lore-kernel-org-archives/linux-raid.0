Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C7C8462;
	Sat, 25 Apr 2026 02:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777085187; cv=none; b=kk8NGoXRtEs42z7b92I0Pgs7ktxbHWpY+L6tMc0kK+Mipm4Kz54h1H+vmT6jMuGF2sQC/mnCST3oV/V6M1x/EO5ZDOCENoxBHZ5LJmY/vqjDiqo8K2JG+yJXA9dxikMHvg0TSEPddXNU3tC2qpJU1ifDS/jVEdRGwtymnHNFyKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777085187; c=relaxed/simple;
	bh=Bo5wKDZWcPUiUrGQmOATVB5c4/nfFezM8RuAMbh91+4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BeHP7mVaVh9EYACPZjH0aZatt+kmNzKG501UP5ZqsJTLluCczqCGOgU8Z4es2N12ww3zRDSEvIp2zx3mfljhwGzXtGJ3uFcbvE8pm0miD0SILbjgy8namT5u6sTKzio0H1Ah1iJ0vzp5K2Sgsi1b8GTQMx78BsWfZYYn5M5WzSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A371C19425;
	Sat, 25 Apr 2026 02:46:24 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: Song Liu <song@kernel.org>
Cc: glass.su@suse.com,
	Yu Kuai <yukuai@fnnas.com>,
	Li Nan <linan122@huawei.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v13 0/3] md/md-bitmap: restore bitmap grow through sysfs
Date: Sat, 25 Apr 2026 10:46:12 +0800
Message-ID: <20260425024615.1696892-1-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mdadm --grow adds an internal bitmap by writing bitmap/location for an
array that currently has no bitmap. That requires the bitmap directory
and location attribute to exist before the classic bitmap backend is
created.

This series separates bitmap backend lifetime from bitmap sysfs lifetime,
splits the sysfs layout into common and backend-specific groups, and adds
a small "none" bitmap backend. The none backend keeps bitmap/location
available while no real bitmap is active, and the location store path can
then switch between the none backend and the classic bitmap backend
without tearing down the common bitmap sysfs directory.

Patch 1 factors bitmap creation and destruction into helpers that do not
touch sysfs registration.

Patch 2 splits the classic bitmap sysfs files into a common group and an
internal-bitmap group, and converts bitmap backend operations to use a
sysfs group array.

Patch 3 adds the none backend and uses it to restore mdadm --grow bitmap
addition through bitmap/location.

Changes since v12:
- Keep the factoring patch focused on no-sysfs bitmap lifetime helpers.
- Make bitmap operation lookup depend only on the current bitmap id
  matching the installed backend.
- Trim the none backend to only the operations required by the active
  call paths.
- Rework bitmap/location error handling with explicit cleanup labels.
- Restore the none backend after bitmap removal and creation/load
  failures so bitmap/location stays available.

Validation:
  - create a RAID1 array with --bitmap=none
  - verify /sys/block/md0/md/bitmap/location exists and reports "none"
  - mdadm --grow /dev/md0 --bitmap=internal
  - verify location switches to "+8", mdadm reports "Intent Bitmap:
    Internal", and /proc/mdstat reports a bitmap
  - mdadm --grow /dev/md0 --bitmap=none
  - verify location switches back to "none" and only the common location
    attribute remains under md/bitmap
  - repeat the internal/none switch once more
- Checked the QEMU serial log for panic, Oops, BUG, WARNING, Call Trace,
  RCU stall, and hung-task patterns; none were found.

Yu Kuai (3):
  md: factor bitmap creation away from sysfs handling
  md/md-bitmap: split bitmap sysfs groups
  md/md-bitmap: add a none backend for bitmap grow

 drivers/md/md-bitmap.c   | 131 +++++++++++++++++++++++++++++++++++----
 drivers/md/md-bitmap.h   |   2 +-
 drivers/md/md-llbitmap.c |   7 ++-
 drivers/md/md.c          | 125 ++++++++++++++++++++++++++-----------
 drivers/md/md.h          |   3 +
 5 files changed, 218 insertions(+), 50 deletions(-)

base-commit: c85d314b135ff569c1031f2ef8e40368bcfe72ac
-- 
2.51.0
