Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0429F334692;
	Sun,  2 Aug 2026 19:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785700321; cv=none; b=PfYL5GhHqTz6WJ9wM7F2b5QAisg6814jrqzj1TQtLDUFl/NtaD8IrtaPO2AFrSJsiZq1cvhQSZgvKFdvB/2mpfZFl4ccXy34Mu8wm0rZrBNfi/Pbs2nGbg1DOHS7qsD3YyUCzFzDE4vu06GWx+84aFvLquVdfVv/4kNtoIf5tHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785700321; c=relaxed/simple;
	bh=kt9sa2AjJSIaZe0my3Fo6pjgkgfQlLdOSQMLLiEnGOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gw72a3UA4pFe4DhIlMKaAbeOiWOop0Xi0qvJRMfObCsziwiudnEVINak3OEhhsrKd0sKy65PvzTukJST90fKQaKhupSU7QQms1j4iJ7Pe1bys4mmlzvhOXbVBAEGNL/3kWlBHFAkZs4ZpspBzou9YnLmm7WhIqvXEXffI79kpb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X/bQkBsl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X/bQkBsl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3BBF1F000E9;
	Sun,  2 Aug 2026 19:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785700319;
	bh=5MBbMM4FsgaPEuiAk8SX43polaPfRJ6SfrrnLrmeXzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X/bQkBsl2JWRj6NMP5/THMwSUwElNap3fHizsWGyMZcB+punZjBgrcA/2cUFj+H55
	 CA7OZ1UL7BwulcmtMoytHzKGU12dELCcrltPdM0IZZnFM1GO02gwj0icFmmA3x74yT
	 CQCSInkZzyqymRQ/0m9cjxviDa9NiEU48OWwojSTrGvHSV9zI/xKIKI66dFFfe8uAv
	 p1KnPfwbikX/iEqxUuger5Zh79SNIHcZvqE6O+qjdlUYYRGfWzu+rJAq/ETcwU3P02
	 u6+dniyynNt6OijfbkxgmpVkRZB8bySf8t+VbFoAALi8EfJ2HerxStrVrnriHVuwWY
	 Z8u0QvMtfIsPg==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>
Cc: Yu Kuai <yukuai@fygo.io>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v5 20/29] md/md-llbitmap: don't skip reshape ranges from bitmap state
Date: Mon,  3 Aug 2026 03:50:29 +0800
Message-ID: <20260802195038.164272-21-yukuai@kernel.org>
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

Reshape progress is tracked by array metadata rather than llbitmap.
Do not let llbitmap skip_sync_blocks() suppress reshape ranges based on
stale bitmap state before the corresponding checkpoint is persisted.

Tested-by: Mykola Marzhan <mykola@meshstor.io>
Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/md-llbitmap.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index fa16a4224c45..a20e55fdf82b 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -1707,6 +1707,14 @@ static sector_t llbitmap_skip_sync_blocks(struct mddev *mddev, sector_t offset)
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

