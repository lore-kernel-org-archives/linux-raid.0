Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EBB5288D0;
	Thu, 27 Aug 2026 07:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787815262; cv=none; b=IlfYExyC0Kgf+XkiQ6Qmy2731zpcTrIuzpSV0+7lI7IAzVfaoZdrHFcg1pvNNDgCw5WopZSio3UyIeLG2iqt+TVKbMMCp7epEOTHjqLQThXAHPL3sc8Ie4UfSpO2cziaubanFk2/ZHYUwtpZ60xs7QkQdkqiu/hzkE53/WWV1LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787815262; c=relaxed/simple;
	bh=/jV+oRiT/+IGhiRfbvugXtpCgqrAaiO4xT05uGP5Qr0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YjOzDTEoqpFp1eYxZVtzhBIoB9rH6hHAXZtob0bDLJpB5YGf2PonuxmS/cRyATlLHMAP38bI7Z+Q9aiK/kItIhbvrHQpxFoAWCPhJwDS5vK5LPgH3DiM+DPWK6nW6Ml4xecbUxV/CPyQ8/8RKxk1PUO9GBDLW6vvmE3/2qL/bH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E373C1F000E9;
	Thu, 27 Aug 2026 07:20:58 +0000 (UTC)
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] MAINTAINERS: Cover all of RAID
Date: Thu, 27 Aug 2026 09:20:56 +0200
Message-ID: <7a2e5de234cc0286e3fe9bc11b810433775f2280.1787815121.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

While commit 3626738bc7147d52 ("raid6: move to lib/raid/") handled the
move of RAID6, it didn't take into account there was already more RAID
code under lib/raid/, as XOR got moved over in commit 9e229025e2474115
("xor: move to lib/raid/") before.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Closes: https://lore.kernel.org/20260826205058.a6ff019d0584f75c7f50430b@linux-foundation.org
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index dfc2369bb7130b4f..a922e8e35ae35200 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -25320,7 +25320,7 @@ F:	drivers/md/md*
 F:	drivers/md/raid*
 F:	include/linux/raid/
 F:	include/uapi/linux/raid/
-F:	lib/raid/raid6/
+F:	lib/raid/
 
 SOLIDRUN CLEARFOG SUPPORT
 M:	Russell King <linux@armlinux.org.uk>
-- 
2.43.0

