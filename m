Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806A22F2E
	for <linux-raid@vger.kernel.org>; Sun,  5 Oct 2025 16:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759681339; cv=none; b=MDAx18wX2reQfWk/5KVF8yux4YXuif8eQhBdVdd2nYSbNuTi+9gHVTkhgzR9xPPMs2vc4e222Etry0hbH7Ztr1Z6VAGw4oc28hVznivDQMJMw79yw1bx2DLwp/jIgNLcmBKZUBWCc1nZr9hQf3dlhEX4ENfRaw7GxeZpkbh8BEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759681339; c=relaxed/simple;
	bh=IaVAtvMeaACk6t3ygtjpK1O/MJUOFW0baPuCMBNxhzU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eR4Sca0NLxd7Th+u2igEadFXU8dW1J4ZwVZ9rJ4xQ63UvDPx5lH2xCsdDoyEMK+rJq9MnaIt3AaaZ5qGPzpcfT/o5uGobkUhQDQhiu8G9/yj6Nfr+u9B92nPy0depGzpuOO4HyQ9QAjb+p4oybi0uZ+SmFOfy0OH8cuu1p+KKzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54E2EC4CEF4;
	Sun,  5 Oct 2025 16:22:18 +0000 (UTC)
From: colyli@fnnas.com
To: linux-raid@vger.kernel.org
Cc: Coly Li <colyli@fnnas.com>
Subject: [PATCH] md: don't add empty badblocks record table in super_1_load()
Date: Mon,  6 Oct 2025 00:21:59 +0800
Message-ID: <20251005162159.25864-1-colyli@fnnas.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Coly Li <colyli@fnnas.com>

In super_1_load() when badblocks table is loaded from component disk,
current code adds all records including empty ones into in-memory
badblocks table. Because empty record's sectors count is 0, calling
badblocks_set() with parameter sectors=0 will return -EINVAL. This isn't
expected behavior and adding a correct component disk into the array
will incorrectly fail.

This patch fixes the issue by checking the badblock record before call-
ing badblocks_set(). If this badblock record is empty (bb == 0), then
skip this one and continue to try next bad record.

Signed-off-by: Coly Li <colyli@fnnas.com>
---
 drivers/md/md.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 41c476b40c7a..b4b5799b4f9f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1873,9 +1873,14 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 		bbp = (__le64 *)page_address(rdev->bb_page);
 		rdev->badblocks.shift = sb->bblog_shift;
 		for (i = 0 ; i < (sectors << (9-3)) ; i++, bbp++) {
-			u64 bb = le64_to_cpu(*bbp);
-			int count = bb & (0x3ff);
-			u64 sector = bb >> 10;
+			u64 bb, sector;
+			int count;
+
+			bb = le64_to_cpu(*bbp);
+			if (bb == 0)
+				continue;
+			count = bb & (0x3ff);
+			sector = bb >> 10;
 			sector <<= sb->bblog_shift;
 			count <<= sb->bblog_shift;
 			if (bb + 1 == 0)
-- 
2.47.3

