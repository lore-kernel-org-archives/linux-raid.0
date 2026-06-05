Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A7B40B37A;
	Fri,  5 Jun 2026 09:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780650962; cv=none; b=JkjpOdxYAlVlGIDt/W8XTbrUlVTDq5hIP0ZYVp29TPB3pcAJFUGxmoYy5W/u63BAFnsJk2IswY2wZOibinDzWvBeBx9NmLnox8asxZyjZge1it5XmGNbmqukRnH3fEAdzHwRvw3efKDebUhvNLc2Q33vfzryRCrdWcRG4MkDjEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780650962; c=relaxed/simple;
	bh=NObFgcKziq04KZkITqs/JX/pdLy2MW6/VJnlIPK2Q78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kDmULJ46VMM6NzYtkYOVOExTedzp9JsCirvNTIIeC8i+wiB6d6YEi6/fMt00E8jNszqQfqMY9HwywdPYtjd/sKIQtcAnm5zJn9LwU5N2z573vnUXlq2DcvnZVIMUPnUxXgMMdKvT3nwbr2ogEioMslfb3S2isE0y+Do3YmLwfgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I5nkJg3v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I5nkJg3v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E035B1F00893;
	Fri,  5 Jun 2026 09:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780650961;
	bh=jj2bkCKbqZy8q/+y9uBjWHCDSlpn7vgFnPVzyztV20s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I5nkJg3voJHBQvuna7w3/DTg0lzI2UnGOE3OpaXp9mxCY7qzzFc4PxfNI48ExCS97
	 POyLdvAJBeQaJQUY8CdNl9N83vfc24QTZJhV9fvBpgDVrALEfezVtYa65rPRIr8Lh2
	 XYU7NmQ7FAr+JhZ0L91SbMneav9tCXg3rH1DtyAzSoxjbNE2ttRIYeySL/u+vGW1QT
	 OvM/Bu2l96+TMzYhner5Df0cEdKvsKK50cellXfqjV0YBOZ3TdS5twwUKfZ/6iO99f
	 MdINp+ASIPCeoFfAJ/KVH4eS4JUW+SEZ6jdA+7ZzVw0Ujlnd0oDzAJIrMWvOy3TplS
	 IGciYDPSE7GAQ==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] md/md-llbitmap: clamp state-machine walks to tracked bits
Date: Fri,  5 Jun 2026 17:15:20 +0800
Message-ID: <20260605091527.2463539-14-yukuai@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260605091527.2463539-1-yukuai@kernel.org>
References: <20260605091527.2463539-1-yukuai@kernel.org>
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
index 6783f1b3ddf0..65d2fd1979e5 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -980,11 +980,14 @@ static enum llbitmap_state llbitmap_state_machine(struct llbitmap *llbitmap,
 
 	if (action == BitmapActionInit) {
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
 
 		if (c < 0 || c >= BitStateCount) {
 			pr_err("%s: invalid bit %lu state %d action %d, forcing resync\n",
-- 
2.51.0

