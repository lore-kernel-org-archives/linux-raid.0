Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B9638D3F1;
	Wed, 24 Jun 2026 06:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782283377; cv=none; b=LSL8hriwy1i1HYmaNpxI5BDVeD5WPzDBg6LNqHfSOms/Jm0+i6ZsvTdA9cr42DYgEi/CSHN6zVR8X3BlZONA/B8eU7jpaiwqDsBn9OKqATW7AK7yfs7SB+mmdPZU+N40Te8akyOv7/+XBjNO4nRSeBpSCJbv6c5B7jyAfIGwmDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782283377; c=relaxed/simple;
	bh=xkK34nsmS868WauB2uwh7F/WYaLcTv7elkEntxXzObw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S58xwRlfZDWDgjw8iRsSXqoRqivhYWkKRaECl7dd2yT/6x7L3gE1cgWr+vlRdWHDN4BENnm5FrtQcQN9DDZznk/SpKR4bh5GOCUNL6Bm+qfyQhhaAMI/SVpHV0qwJwMnI12tnY8BFacflaIovkHfqV+s2xY+YaajMfdFX+r7Hko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kfnCq1k9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kfnCq1k9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 574161F00A3A;
	Wed, 24 Jun 2026 06:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782283376;
	bh=8ywuQ+oEeeSu281ZNbtPZKsMN+LOvDBcTV9hBAfsDZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kfnCq1k91PeJaydWqnfKOsWNdRZS1PA6Mn4txJUzErb9y2XOjziW8l51D0wm3D0Vz
	 4jWFi2qHES6EIufGxn/xFJTN0j4nuW+RNgcpOZ8fWUlwbTJoO84rMgxXdOyk4wwylj
	 EuaKxGMck+yYkBliM1OFh8FJGSHLiVmnDIAxpNwW2c7kUIUWXTrajxCLWH6jndgXj3
	 JCDNKUYsT6MEOr60wHhAF8Ns7E6KuIjSGyO3dnAjUyaikZIGNJeJ0FgX2d55I/kBMq
	 OD9p5wV7SyEaTBcTvIBZX3E5zCz3XsrYy+PLhytNDzVsAFWLtTHnPhotzIm31PixO0
	 jT/FcswL/Ny/A==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Su Yue <glass.su@suse.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 13/20] md/md-llbitmap: clamp state-machine walks to tracked bits
Date: Wed, 24 Jun 2026 14:42:10 +0800
Message-ID: <2f58279987b8b8b3f5b2ed8e563512524c530297.1782282042.git.yukuai@kernel.org>
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
index 00b77ecd600b..581ee9e4a346 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c
@@ -983,7 +983,10 @@ static enum llbitmap_state llbitmap_state_machine(struct llbitmap *llbitmap,
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

