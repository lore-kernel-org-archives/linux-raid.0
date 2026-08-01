Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F8B35C1A0;
	Sat,  1 Aug 2026 17:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785605250; cv=none; b=oO0cQ7m/PLH43uXtRuBes7yEWJc31WK8pT9dXhfbC6K+WzF5qorM4Bp2PAGueA9QgroKOtOqVlR3qHKHojvkinDBbmGnIXHqTbXMgtvCPcCrlysR3RPc1VPnLyhXRZECvdlGjzwY98YgBzPoy+kiGZ6hxtrZICgVbtf3RN0nDeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785605250; c=relaxed/simple;
	bh=9C6q7S0E1ahrUuz++7upELMaFcosc9FD7lcWdA6zY9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bTxrTHVFrFdDUqL4SK89yYyLaPlhV3eOpEjT0JdApmYejDBPRrHQRgK32elkV9Q4LyvdOd4oSx6+NveVHdKYDdoXqx+B2qov0rD8iEoEJBwYVv6cMY+zIc4nSwwb9hfqUaE7Vx9v7ii7GR9E4lR0N4vNzU6AErTGRnWiDPyCojU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iw2q02zf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iw2q02zf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2749E1F00AC4;
	Sat,  1 Aug 2026 17:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785605249;
	bh=ABIG+s6muV9rWcz7rbS1gaHI9hWl4JHjo3sBY4cNOvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iw2q02zfc8xcDhpG3vRZm/7z4yMLY8eNzYRwhM2noQgmlGsdM49IJg3LjmX4lX19S
	 LGStLF/3yyj7zdWPnUuOU7iiRls3+clq77SPXh7t5SpBm9A34x9qEmCTRt1tzyhL+q
	 WqX965Od3kGv1OrSPq3OBcPNpjIo99FvuKFxNLYFjbAtxjNzUy67mqaqNzam76zQfA
	 i3reYYhPmxoX/msVNFAfFnS/V5xFaY93Jm1WlKaCDyPhAce6/JHuikawoGk76uLYIh
	 MMRKAnDWCCHNzsO3BBna1ECKlPVmcKZlhBJk0X9G4ZCuKEvujfZMbr69hmQvMwVj9a
	 W7A7/iY3xlntA==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 19/25] md/raid10: reject llbitmap reshape when md chunk shrinks
Date: Sun,  2 Aug 2026 01:25:13 +0800
Message-ID: <20260801172519.2982121-20-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260801172519.2982121-1-yukuai@kernel.org>
References: <20260801172519.2982121-1-yukuai@kernel.org>
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
stays the same or grows. However, shrinking mddev->chunk_sectors can
shrink the effective data range covered by each bit for the RAID10
reshape geometry. Reject that reshape while llbitmap is active.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/raid10.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 0a3cfdd3f5df..1242b8d3bb6b 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4284,6 +4284,10 @@ static int raid10_check_reshape(struct mddev *mddev)
 
 	if (conf->geo.far_copies != 1 && !conf->geo.far_offset)
 		return -EINVAL;
+	if (mddev->bitmap_id == ID_LLBITMAP &&
+	    mddev->new_chunk_sectors &&
+	    mddev->new_chunk_sectors < mddev->chunk_sectors)
+		return -EOPNOTSUPP;
 
 	if (setup_geo(&geo, mddev, geo_start) != conf->copies)
 		/* mustn't change number of copies */
-- 
2.51.0

