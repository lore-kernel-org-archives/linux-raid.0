Received: from va-2-37.ptr.blmpb.com (va-2-37.ptr.blmpb.com [209.127.231.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB50044BCB4
	for <linux-raid@vger.kernel.org>; Mon, 14 Sep 2026 12:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789388299; cv=none; b=eoIpVae3mLicNVfWWGjkHSVXYnukEGhPLbMIljWlNMGfs3DMXhJ9TWk2w5FusUVxsqQTLlh/TqOdkCq2bUk3v4GbbLOZJtBj7CjjYQreHTx0b/K8O9Awn23Ga+mzgfNUvM8ZW0I6quds7KV1nr/3FdD4b9Px6PyIFRxs+eQNNSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789388299; c=relaxed/simple;
	bh=IMqnZaCDorOhVr3hCfchqgqX+QykXKxWuWEWjNILNbo=;
	h=References:Content-Type:From:Mime-Version:In-Reply-To:Subject:
	 Message-Id:Date:To:Cc; b=TvrjHZ3DY9oJsqx/CMNOsKxPPzGHhBFogdq3kEePv4MBsS/BFJlu7cEy/nJp5A3YyWhOQYsIubNiA7tj2tSCt+OQWxoKYt7O8HsMe0ndwl1BcokYTRxmOkn5sUGRCcWUdOqX4CjNUX/gH4G68CZF0cHKOcHjkBYYtfWX1Ft4y7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=traF0Z1f; arc=none smtp.client-ip=209.127.231.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="traF0Z1f"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1789388283;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=z1AKODjXAVSZ/xl5ZikmxCkbwxBpoJ3mzCogn6F7u+c=;
 b=traF0Z1fflohrEhtzbTAznOu/5dGds3loWnc9lRwlqwA3abdP65FDQIwSdlAjkKG0qAwyz
 EFtxaSq6Y++8gciUmo851jwpRWzkgsa8Ggw+7DREu8neR8jMokKSugu5uaGq8q06oVwv3D
 MxZNy3x8CMJe5sFxfhV1evjitR1ewuh4Lj+oFNb36VTtp4d8nzqcwG9yNUI8K6lgCt9q/8
 EJA8xXYUadcQeA2a0mWSRKfx/VoBj5yJAeR9Vu3422UsREt2MRoF6yrhFU/F3/ePvBLLdk
 CTr3ImS3I3k6U0IsL7XyqdrjBkZJlvojl7dbQ4uTlHB78tvIDeHQdRCGV0yafQ==
References: <cover.1789387793.git.chencheng@fnnas.com>
Content-Type: text/plain; charset=UTF-8
From: "Chen Cheng" <chencheng@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
In-Reply-To: <cover.1789387793.git.chencheng@fnnas.com>
Received: from fedora ([183.34.164.60]) by smtp.feishu.cn with ESMTPS; Mon, 14 Sep 2026 20:18:01 +0800
X-Mailer: git-send-email 2.55.0
Subject: [PATCH v1 2/2] md/raid5: reject invalid reshape disks in raid5_run()
Message-Id: <9add7169910eb1358f45352e5f22506492890352.1789387793.git.chencheng@fnnas.com>
Date: Mon, 14 Sep 2026 20:17:47 +0800
X-Lms-Return-Path: <lba+26aa7e5fa+c6c1ea+vger.kernel.org+chencheng@fnnas.com>
To: <linux-raid@vger.kernel.org>, <yukuai@fygo.io>, <nixiao@fygo.io>
Cc: <chencheng@fnnas.com>, <linux-kernel@vger.kernel.org>, 
	"sashiko-bot" <sashiko-bot@kernel.org>
X-Original-From: chencheng@fnnas.com

From: Chen Cheng <chencheng@fnnas.com>

Check disk count before dividing by data disks while assembling a
reshape, otherwise too few disks can cause division by zero.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Signed-off-by: Chen Cheng <chencheng@fnnas.com>
---
 drivers/md/raid5.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 4ab31af34b9f..bb0dd9324811 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8051,10 +8051,11 @@ static int raid5_run(struct mddev *mddev)
 		 * the array in read-only mode, so we check for that.
 		 */
 		sector_t here_new, here_old;
 		int old_disks;
 		int max_degraded = (mddev->level == 6 ? 2 : 1);
+		int min_disks = min_raid_disks(mddev->level);
 		int chunk_sectors;
 		int new_data_disks;
 
 		if (journal_dev) {
 			pr_warn("md/raid:%s: don't support reshape with journal - aborting.\n",
@@ -8066,10 +8067,16 @@ static int raid5_run(struct mddev *mddev)
 			pr_warn("md/raid:%s: unsupported reshape required - aborting.\n",
 				mdname(mddev));
 			return -EINVAL;
 		}
 		old_disks = mddev->raid_disks - mddev->delta_disks;
+		if (mddev->raid_disks < min_disks || old_disks < min_disks) {
+			pr_warn("md/raid:%s: invalid reshape disks (%d -> %d, min %d)\n",
+				mdname(mddev), old_disks, mddev->raid_disks,
+				min_disks);
+			return -EINVAL;
+		}
 		/* reshape_position must be on a new-stripe boundary, and one
 		 * further up in new geometry must map after here in old
 		 * geometry.
 		 * If the chunk sizes are different, then as we perform reshape
 		 * in units of the largest of the two, reshape_position needs
-- 
2.55.0
