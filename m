Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D126B320393;
	Sun,  2 Aug 2026 19:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785700327; cv=none; b=VdeONTZcx7D0xgvMZ4Bfky6Z4H5K9Sv1zF+NBoM1UzvLI4zWiczakaH2VQ3RUCyl0RFmhsKz4v3QEoPG1Z1nkKZp5Jskvj6vI/Q6Pi4+uPh3cIr7VflQPwX1Jsl5B94YqPKeD9JicwIDzMfAmsHqJ8cos6lGIQhFFkvA2OmBiJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785700327; c=relaxed/simple;
	bh=jG4tqnmF+fhDnanNJAu01qZZRqA7JEfETRe29Ejqdck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kAs+amfKBSLWFTCRl1mq1wyoKwbiT2tXUsO89D4TYDtRy8nU5YqoQg1HcUTsZBRHHh0SYA1PjMHp8pH+B4NaP8ZRBhKz5F1sQHcKoZNjepJkCyyq9SFvtd4fsz7aOHbSlZs/XQHUTvzPXn5GHmu3vPB/amOvLaJHBxwx7Hvw3j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bukuf0lw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bukuf0lw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F80C1F000E9;
	Sun,  2 Aug 2026 19:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785700326;
	bh=rqH4Xu/E74LiTszdv89UTWG+kpu8CAVJ+jzGMnMkj4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bukuf0lwPtf2Yto9s0JRutyGeam5kbdHsCg/npj/sLjuCSDsG03g16VAGPS88khqn
	 P+lfQNz4U1gcGwU/uwPNttxizNVSWviEuuYQe4qXuL5fs7l5h6AKqZuSTcqfJG/OU/
	 UbVsL/3jAmAmDtPc5yAbze+TAnPVRtEb9En0jE7ZuFzLAVePr1V8RHapDCRjNLuGvT
	 Impir9WTiM9+uwWnlZ9z2bZzq8QAfg1OyA17pRbBQ5r4xxc8za8QP8mIAjXil0jTmo
	 ydH2p8/d47HWBr2BogGYOVHXptOU3ntuQr2jxLZEKbc8I6JT3lKxE6+xYDi6+F/DbM
	 vj/kvnUv2kaVw==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>
Cc: Yu Kuai <yukuai@fygo.io>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v5 22/29] md/md-llbitmap: clamp state-machine walks to tracked bits
Date: Mon,  3 Aug 2026 03:50:31 +0800
Message-ID: <20260802195038.164272-23-yukuai@kernel.org>
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

llbitmap_state_machine() can be called with an end bit beyond
llbitmap->chunks. In particular, llbitmap_cond_end_sync() passes
sector >> chunkshift, and sector can reach the tracked boundary
exactly.

Clamp the state-machine range to llbitmap->chunks so it cannot walk
past the tracked bitmap.

Tested-by: Mykola Marzhan <mykola@meshstor.io>
Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/md-llbitmap.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 5d95627ff983..2830ce05d941 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -1012,7 +1012,10 @@ static enum llbitmap_state llbitmap_state_machine(struct llbitmap *llbitmap,
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

