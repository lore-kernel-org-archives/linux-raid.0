Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4AD41BA97;
	Tue, 28 Jul 2026 08:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785228627; cv=none; b=NfMn4RQtPIgt/xuMwZYtdkLFdRwQ5RwpjSmv+6uXmqEDvGC4Oo3EMO02tWA3hMfN+2oLSUiUrDMGSMjilUg8h/6OtlxlZOMQkLR5lOEtFL9tfIAA6/3Ggh0iIq/AiOeyCHNRFfB5qeknW4MONaic1Cq9SHwFmJcAn5266U37T3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785228627; c=relaxed/simple;
	bh=rPQKhw1pu0oJnuOwTxoQlzRrCFLr+CbW6G+57IHv+kM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pokO3GBB4V8Bj4iqWsoBwCFsyGErWN4UkxCQ059iZX6H2LCsEz2SGbP34J9yfBegzupc3RrQqa0oFb4gzrmlS1WGDxUTzOk5gRgca0P+bwXxrvH8EyG4J/yDdHDyiT2oNtEiHqABHqfC1QkLhWEZ1BBi7giAr9zCj+cpvI55NxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gyvusvZa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gyvusvZa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B948A1F000E9;
	Tue, 28 Jul 2026 08:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785228625;
	bh=Oox0noLOoxhkqFG/iaDIBHjlnnZXuEyXZ7QA/tasbsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gyvusvZa5rOXuu9ND1QtQEPa83swBNtuN54Xw4U+N1Ep6MnD833LSjPbPJvnv9ebJ
	 1+4a9pvRURVEyIf5fF1j9zj8p2Wlm9rkqcgJ7urcS8hGUM7PMVWyXdo1dAgV8Y3NtG
	 flgNAhPM30PA/geiqevUD5s+DXlRIog7cQU8kOImCvQmqwN3aCe0zJmQQhKGKY53al
	 t+CV0G0Ire+VcVexKjiWRraULArK/z7PZbNOCsDHjWG3pLn6Sj5U6tec+6gmQx1R0E
	 ujR7yPIGVFUsbceDg/noPwhAQNmR3OXlS2/rBTorf+LrGm+Ogpl6nDT28h76OCBWNX
	 ziHvFZJl3Qbug==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>,
	yukuai@fygo.io,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 12/21] md/md-llbitmap: don't skip reshape ranges from bitmap state
Date: Tue, 28 Jul 2026 16:49:12 +0800
Message-ID: <1d1f848f29c4159de2ae1bdcdf988c9d36a0ef70.1785206690.git.yukuai@fygo.io>
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

Reshape progress is tracked by array metadata rather than llbitmap.
Do not let llbitmap skip_sync_blocks() suppress reshape ranges based on
stale bitmap state before the corresponding checkpoint is persisted.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/md-llbitmap.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 929c1f40ddec..bdc6ec8972f0 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -1687,6 +1687,14 @@ static sector_t llbitmap_skip_sync_blocks(struct mddev *mddev, sector_t offset)
 		return 0;
 	c = llbitmap_read(llbitmap, p);
 
+	/*
+	 * Reshape progress is tracked by array metadata rather than llbitmap.
+	 * Skipping reshape ranges from stale bitmap state can lose data after a
+	 * restart before the corresponding bits are checkpointed to disk.
+	 */
+	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
+		return 0;
+
 	/* always skip unwritten blocks */
 	if (c == BitUnwritten)
 		return blocks;
-- 
2.51.0

