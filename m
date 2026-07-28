Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F07E41F5C8;
	Tue, 28 Jul 2026 08:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785228635; cv=none; b=qNmyDsackDA/K89/kvHiG11kxYChIvgfdFD4cnGnQkpfbtBPVZ+0CyynoA3P1kSEvpz2k9VLZQDeHHDLLJmF7mIqFeZj8vURCQTtmiT7VBbq4QF+SIGaeD3/t7O+VNKabJ3O3S/XfACMgM1TVuC3u5MFUXOe417IL34IQ75Uq9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785228635; c=relaxed/simple;
	bh=KPwTqKXuUcNYCo13hgfaNAh6TF1/ssU/x5daczGAjn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IbRciqVVDZ235/5JSRxxdSynaRJNuPmP/ElFheqU7L3SuTwDhx49YAjwD3qlPaWAGDvlzauE2tD0ms1cebMXQKw9HZBlHyqYRC2njk5NN8OptaeFdi+1/Q1lFHUMdk5mRfT9Ea/2w2x4U7QgZPzEF4TPdVAqIF1k9fiVYrX3K34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HtYaK7j/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HtYaK7j/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1BD91F000E9;
	Tue, 28 Jul 2026 08:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785228634;
	bh=axXEUJUmwzKYza3SnmyZXfo+m187c/xW6RvRM5Ud/xE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HtYaK7j/ThSWP3BQCmN8bd+ob+ZNnPuADiL+ykNzxm1K/TFft1EZ+lDCOk2eW0gKV
	 1th2SUwBp9Ruf+WBJniy0eXGbIhK7fYT8JUjebRGHjrgEtuy0qgnzI4CizEPqbnJPZ
	 5/duU9yAXrvGhaDsLPVf9XWPlOyApag1keyO7pBy94UbD91ncExv8FIIoKYhRAxRsA
	 If8VnkxIXCbBhhAZtywsbTndcfOCT0AH1p+xO8lDSIBKhR6gejh5u5arLjLaZTXoxO
	 URIP+I6pwiAA7FkF5dw5eUGgbKnvY2wSZ2BQg8rfcQotOu4uAHjjnR76NDppJT6ylA
	 XPrUyF/ggEUpA==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>,
	yukuai@fygo.io,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 14/21] md/md-llbitmap: clamp state-machine walks to tracked bits
Date: Tue, 28 Jul 2026 16:49:14 +0800
Message-ID: <0510090c2be122814404150096768b180d0301e9.1785206690.git.yukuai@fygo.io>
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

llbitmap_state_machine() can be called with an end bit beyond
llbitmap->chunks. In particular, llbitmap_cond_end_sync() passes
sector >> chunkshift, and sector can reach the tracked boundary
exactly.

Clamp the state-machine range to llbitmap->chunks so it cannot walk
past the tracked bitmap.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/md-llbitmap.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 794ac0eaf437..bb83d15247d2 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -1011,7 +1011,10 @@ static enum llbitmap_state llbitmap_state_machine(struct llbitmap *llbitmap,
 		llbitmap_init_state(llbitmap);
 		return BitNone;
 	}
-
+	if (start >= llbitmap->chunks)
+		return BitNone;
+	if (end >= llbitmap->chunks)
+		end = llbitmap->chunks - 1;
 	while (start <= end) {
 		enum llbitmap_state c = llbitmap_read(llbitmap, start);
 
-- 
2.51.0

