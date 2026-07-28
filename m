Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E48A41930C;
	Tue, 28 Jul 2026 08:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785228639; cv=none; b=crwEGo6dp/3Hq+WkcYustXNFLT8Cbl/oM+qpQOgAvOSrvPLNMFWi3p/q1a1+6rK+BmbpLH1YzDg+TPlTK82XmPZMiQBEHO8KlNKm+86pvzPFFBWp6/GI/eVDewPtkZuEzmeRDUuA/d24cSDvKmdvs5Zu+9NYtwbYwUUyWwc+b/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785228639; c=relaxed/simple;
	bh=9C6q7S0E1ahrUuz++7upELMaFcosc9FD7lcWdA6zY9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u7/RkBv+HuUpNERg8Cl9B2m9/+BuWp3OsMRq0XtUtxelk0Lq7HZ/mhBxgX0P8UA95tkMbVEqINIUNmBX71Nhrd4bqISWE9uht212Akz4EB9Q1ia61n9emhngqdOMTjuwimvgYzfOHRrjA8G88IHoZ+jPLjTyqRh5ZemWg3d2JoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ApWZdQv5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ApWZdQv5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21BF71F00A3A;
	Tue, 28 Jul 2026 08:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785228638;
	bh=ABIG+s6muV9rWcz7rbS1gaHI9hWl4JHjo3sBY4cNOvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ApWZdQv5KPpA2aWhrFffGBWJCDB9bjQeeFKCKeQwGCy5DKr+d15yyCK3ZyYBeCvmr
	 Q/cbscChXf4yM7v78uU9Mre0w+ZJVp5YG9Ma35Jtwzog7GWfZ9j+v+6J4l0Wne3yj0
	 0vwhonzpiXZzT9yh7qJhgCgNKL3CYhRYqiz0jAj053W+L1lePIt7o/P/7uJPHNAYu1
	 EwR4aUUHDBMIYPDMXlgbYBa2AGxbqagtdI70vdjT8piii4P0uwU7MvqKaaGpCRCjbz
	 83eZKHKg9nTBP26TJlsxpz4MthRkrzo1j4YUa4WpBZCgsyYgoAp6QzBjABhgPKyZlR
	 M5cEWp49wn50Q==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>,
	yukuai@fygo.io,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 15/21] md/raid10: reject llbitmap reshape when md chunk shrinks
Date: Tue, 28 Jul 2026 16:49:15 +0800
Message-ID: <afa30cd1979fd4ea579c7db9c684a12cdea1a895.1785206690.git.yukuai@fygo.io>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1785206690.git.yukuai@fygo.io>
References: <cover.1785206690.git.yukuai@fygo.io>
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

