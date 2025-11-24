Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE8E2D8792;
	Mon, 24 Nov 2025 06:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763965928; cv=none; b=uXEseZF2wQYIglwuXgXE7OiEPsI40Ir1ao1FOOayk8DBVQdzCC2S5xgVwOXzi+4/7QOADIAfhK2C0YHycQbL5ZoqfwmQPUKm4XNMTp9KCH3t+gu9NKibZMEGRVFVwkhC7FhikzjV3hq+BD+OzhjsC2v50VPtJo+2NUZtMTrT/94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763965928; c=relaxed/simple;
	bh=RxfdY+ZGHL4TYX7sOa5xrYf7VlMPVuaipk/GOU6Se3c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fqHigXryBzK8/EaADl7iHT87xxpXLBxrIWp8Vbu6H0GWFyaWcSEDw5MKFd+MtFwSX2Iq+1UBk3FdB12jITgMnn9sZ2FMiW05owfyMqrdf/CxdR0HoilErBBu6KdMXPbwrLRhXZ8mOo2vshEZI4MaKKZ3eyt81Shf15Q/ouFzy4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02365C4CEF1;
	Mon, 24 Nov 2025 06:32:05 +0000 (UTC)
From: Yu Kuai <yukuai@fnnas.com>
To: song@kernel.org,
	linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	filippo@debian.org,
	colyli@fnnas.com,
	yukuai@fnnas.com
Subject: [PATCH v2 00/11] md: align bio to io_opt and fix abnormal io_opt
Date: Mon, 24 Nov 2025 14:31:52 +0800
Message-ID: <20251124063203.1692144-1-yukuai@fnnas.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

changes in v2:
 - add prep cleanup patches, 1-3;
 - and patch 11 to fix abormal io_opt;

Yu Kuai (11):
  md: merge mddev has_superblock into mddev_flags
  md: merge mddev faillast_dev into mddev_flags
  md: merge mddev serialize_policy into mddev_flags
  md/raid5: use mempool to allocate stripe_request_ctx
  md/raid5: make sure max_sectors is not less than io_opt
  md: support to align bio to limits
  md: add a helper md_config_align_limits()
  md/raid5: align bio to io_opt
  md/raid10: align bio to io_opt
  md/raid0: align bio to io_opt
  md: fix abnormal io_opt from member disks

 drivers/md/md-bitmap.c |   4 +-
 drivers/md/md.c        | 117 +++++++++++++++++++++++++++++++++++------
 drivers/md/md.h        |  32 +++++++++--
 drivers/md/raid0.c     |   6 ++-
 drivers/md/raid1-10.c  |   5 --
 drivers/md/raid1.c     |  13 ++---
 drivers/md/raid10.c    |  10 ++--
 drivers/md/raid5.c     |  91 ++++++++++++++++++++++----------
 drivers/md/raid5.h     |   2 +
 9 files changed, 214 insertions(+), 66 deletions(-)

-- 
2.51.0

