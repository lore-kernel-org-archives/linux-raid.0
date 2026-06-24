Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB67738B13C;
	Wed, 24 Jun 2026 06:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782283379; cv=none; b=qem5MAAEtET/nqyBpoc8axl+W49fMLjxWf1NuWaBPk+bASIhGqRt8MrKOimRRGaavDG7wTWeOyYf+5F7d3pF8xMBZZr9IotkE7z8/nKnBk6MnEc+KrKDJLSy7mF5GFA2nvO+ozgHVJGnsyIOeZM1RqEhagtyDQVai+q+DBoNEs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782283379; c=relaxed/simple;
	bh=9C6q7S0E1ahrUuz++7upELMaFcosc9FD7lcWdA6zY9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t7QK1f5yoFl7m3k9vqx9dK6lFlkWsJW8L/Hw4Dlq94lICd2/l15lSzSGFHnNpDBWXUvKpFL78WBl9U7GrShJYgZHGh2yU8+6YN8MErRGk1GxroIEh2telyYyznYWFEjWj8hqWA53+mZIqRNiSFHIUXrNT9+RRlBolc/mCW+86ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g0P1bP6c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g0P1bP6c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3BE01F000E9;
	Wed, 24 Jun 2026 06:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782283378;
	bh=ABIG+s6muV9rWcz7rbS1gaHI9hWl4JHjo3sBY4cNOvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g0P1bP6cUVvEyzGJRi8MwhI8NrbTp5toenhfVWm6zeqCUmKERygcbSS/BulFtdG6Z
	 EO6+KobW0JBpaFNnOmTJa6bdoQL2gi50svPlDbLWzNHOlRSKt1rsxJ+dPl4zWtEnZx
	 EdMwhdUQp4s/9Y1/P9xyr3GyLXXjeQ5u96esYjbrnm74Cy48fOSVZx1Ng4n5mnrv7Q
	 60jxYWl6OPEDGa/UScv7vS8oboyeJDichxGBZRHMiXq0YWBmYiR9CAEzbCNK37wPiM
	 66HctZcqgkL+eGFUsblm/wYRg0PstKKIfC32eISFWG+oTUDJuKxIu0C7LHRhRIVimS
	 wKxzU0ZXB84kg==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Su Yue <glass.su@suse.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 14/20] md/raid10: reject llbitmap reshape when md chunk shrinks
Date: Wed, 24 Jun 2026 14:42:11 +0800
Message-ID: <4cb60cb672af658aab0bf231012dbe7f6f0eda15.1782282042.git.yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1782282042.git.yukuai@kernel.org>
References: <20260605091527.2463539-1-yukuai@kernel.org> <cover.1782282042.git.yukuai@kernel.org>
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

