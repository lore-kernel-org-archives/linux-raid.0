Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF490413788;
	Tue, 28 Jul 2026 08:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785228650; cv=none; b=qfkrE+1h/1q5R6YTfjsoQ8LS8OAws+6XozOuEJKiBnZcxrgVIFe2PcHI0QNsyvAOqb52Vbv57GlPFcwkDE2IXaDTrc8Gz+R2I0pMJSX6xHpb8Eq4WCHV81E4j7XddQWUdCrtTSLrHe2LefsIu+EC09W6eGblT3WUGz+4TbVi/eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785228650; c=relaxed/simple;
	bh=Aw1gNRevTwqD+2er8RV/YU/327IH64O8LBFutTh4Ocs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dWPs02QC9WqaGpKCcRoGUJMR6VDt7+JyMxRgxGRxTQdEDi7mTOkyyvx2WmBH5QAAT0RIQImWBA+Q7Li0J4zkXN+6bqp6L01AeP7SjjZI0YZ1/liWViLYBvYTCAYnD4G/1cPEGc4dx5A9NquiDPaJUa3jTbO2k1n7REGmxEnZhRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A/XrWwX0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A/XrWwX0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EC3F1F000E9;
	Tue, 28 Jul 2026 08:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785228649;
	bh=FyXqR6M7679RX5rJ83DKHfiPQpxbwKXhyLNfX3Pe9Fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A/XrWwX0RLmPHWDIbgI1xXIRJzrXvJDsSd8RO4GJ24r+0cBboNsC1MMm+R9So99+O
	 srhoxItT3ip3he8alK0oHj8za59Aq+Qxoj1DUZyTRZTJGKuqqoq+W2M8NnFEQd4swQ
	 G/RvjLoaQPFGL31X+zFZqBNQykBGDOibDrjEYFkO4EdMpfAY4wmZjtU7lc9bqbQ2CB
	 2RwP7rkYwO4pViJ9eEKw2pxMQ+0wZbmOqDYmB8I00fDEYHMHWm9Ru/c4dEKi4SZclq
	 IHLtHd8e8RTmDcIp+NBQHCkDmoDnbxTj3TD6a3zmgMv/VP0xbXRWiGaaSeuovzZBPO
	 qma2fqfSbUAGw==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>,
	yukuai@fygo.io,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 17/21] md/raid10: split reshape bios before bitmap accounting
Date: Tue, 28 Jul 2026 16:49:17 +0800
Message-ID: <8abef42ad491fe452b82d672c2fdeb6c64c20c91.1785206690.git.yukuai@fygo.io>
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

Use the shared mddev_bio_split_at_reshape_offset() helper so RAID10
submits only one-side bios to llbitmap during reshape.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/raid10.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index e50e4adee389..fd364a2e2fd9 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1911,6 +1911,12 @@ static bool raid10_make_request(struct mddev *mddev, struct bio *bio)
 		sectors = chunk_sects -
 			(bio->bi_iter.bi_sector &
 			 (chunk_sects - 1));
+
+	bio = mddev_bio_split_at_reshape_offset(mddev, bio, &sectors,
+						&conf->bio_split);
+	if (!bio)
+		return true;
+
 	if (!__make_request(mddev, bio, sectors))
 		md_write_end(mddev);
 
-- 
2.51.0

