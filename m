Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60540339363;
	Sun,  2 Aug 2026 19:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785700348; cv=none; b=WTakxhwl+z7UmPp/ObJbpfHbpZcdVho8JOkel8PeeEa70d8rcq7kX58PXNo57KrOb99gIPJ/bVasKtGcM3R5/IpZ6yex7iPgz14e+QYUb8ll3JioOB4lp2VO0nQOxSHEKsiwQR8pZ5Ql3ARLSkWSJ8ndBMOtMr8a0mCulzugp4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785700348; c=relaxed/simple;
	bh=Rqgvn/E7BhWafURAISqtwi+YnqhKX7fLHXfIH5DzC3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p6gYXrHatMqEOwteB0bXHtSz1goUC31QnYd0r+3N1VWXI1E7F0nd4+lS5ScGvFL1fCMq4YJP/R65xXOPLkDIf2hNRvM3ssip/vrbJ8Vaqc3UB7NuRPPC/Rkvy1UxkB4ZbiDPqwgAyMs7OfoniRweJ0o9VGn3yU/Sl8PG7SVMvIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JbL08JSx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JbL08JSx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFBC01F000E9;
	Sun,  2 Aug 2026 19:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785700347;
	bh=4PXxOgVQSzPnexE6Ra77DyXCOwfRDzIjcDTA1bHcSRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JbL08JSxH8dIlxNWSV7R9Iac/PYrDzFTUZGfv+Q6SVe4KO1bJuZ+dtoVnWG9XDlsG
	 P28ZxkogpCkSy76bmU5dc23kGH/TrwP/Xi5y4HdSwMfkACfK+FNr77Aodw8nFOTLNp
	 EihXvqwcgzrhR3Sn7gOAEvtZRcgJ60L1h9ZnvLxc1AHb5iWhewhQoVBKlDWCdLkChy
	 xSFtD066tmEiaaY9Lp0iPXCindcCoT9Utn4Yre4x6hgQN0u7AtdeZyLgwLwirEpEUl
	 R7g9vOGOBoonbe9rWtJOd9l6jPoYIn15/4MIoNCSAmmF3jL+YQ/oGM/894Ke+mgms4
	 zutsy6vJa/p5A==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>
Cc: Yu Kuai <yukuai@fygo.io>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v5 27/29] md/raid5: reject llbitmap reshape when md chunk shrinks
Date: Mon,  3 Aug 2026 03:50:36 +0800
Message-ID: <20260802195038.164272-28-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260802195038.164272-1-yukuai@kernel.org>
References: <20260802195038.164272-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

llbitmap reshape keeps one live bitmap and cannot safely make an
existing bitmap bit cover a smaller data range.

The llbitmap chunksize itself will not shrink when mddev->chunk_sectors
stays the same or grows. However, shrinking mddev->chunk_sectors shrinks
sectors_per_chunk used by raid5_bitmap_sector_map(). That can shrink the
effective data range covered by each bit across the old and new RAID5
geometry. Reject that reshape while llbitmap is active.

Tested-by: Mykola Marzhan <mykola@meshstor.io>
Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/raid5.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 88bf5a9ce573..67d56c92c8a4 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8580,6 +8580,9 @@ static int check_reshape(struct mddev *mddev)
 	if (!check_stripe_cache(mddev))
 		return -ENOSPC;
 
+	if (mddev->bitmap_id == ID_LLBITMAP &&
+	    mddev->new_chunk_sectors < mddev->chunk_sectors)
+		return -EOPNOTSUPP;
 	if (mddev->new_chunk_sectors > mddev->chunk_sectors ||
 	    mddev->delta_disks > 0)
 		if (resize_chunks(conf,
-- 
2.51.0

