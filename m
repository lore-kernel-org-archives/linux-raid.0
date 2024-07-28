Received: from mx-out.tlen.pl (mx-out.tlen.pl [193.222.135.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B38728E0F
	for <linux-raid@vger.kernel.org>; Sun, 28 Jul 2024 10:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.222.135.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722163038; cv=none; b=lrrSuK9JX2/s94J/Otq+RR/O+uv94j8h49zw0gZ68Nj9+ULZcIBe1eQYK9hAtLr0ypdy4FVIAE7qGz9CJppco/4byW8T+ySVbquXf1kzh0g8BXzIPkx7MGZaO71xF7r4hNxg0GJcMbt1GbzyBXxr2UbZNb+zciyLG45X2Wa70mM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722163038; c=relaxed/simple;
	bh=VSQZUQRsh6tb++bgERR7+cIgD3X5k9ByH1RTlxLNfRA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BHqDN6+5XsUox2BWxHaPwRfA08+sPGzyVHLHvlWrRbeaMslzWUbu61Nmw2ZQn7NRxPhXjZ6qn22SgThplUIUtCXfx6PEv0k7sn+dEp1nnvtvn4/npBP1dkJ0i1BwMhoB5zGi1diGsRrmp1S/P3RYt8hIr9RhQPNQZkrpYg5HDog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=o2.pl; spf=pass smtp.mailfrom=o2.pl; dkim=pass (1024-bit key) header.d=o2.pl header.i=@o2.pl header.b=MrjuEAza; arc=none smtp.client-ip=193.222.135.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=o2.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=o2.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=o2.pl header.i=@o2.pl header.b="MrjuEAza"
Received: (wp-smtpd smtp.tlen.pl 42027 invoked from network); 28 Jul 2024 12:37:06 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=o2.pl; s=1024a;
          t=1722163027; bh=iktQfLVfo5uemDyHcZpaFp8tjax4KZZs1j7D2Ojd3uY=;
          h=From:To:Cc:Subject;
          b=MrjuEAzaLyvMJFAMd2XToE52gMrUFpD7wmwWZy9rYk8ZmZ7GTBwNryPZnCXUOsN+M
           1iKgAzNzugyODegvuQUXt0AnpkXxN1bxLrATXCxIci1msjj0TtXvxqZgq03zwuaVpB
           5UvMJznjutb/BFIrUSh61qzykQ381RGkaQu5oQfA=
Received: from aaen12.neoplus.adsl.tpnet.pl (HELO localhost.localdomain) (mat.jonczyk@o2.pl@[83.4.117.12])
          (envelope-sender <mat.jonczyk@o2.pl>)
          by smtp.tlen.pl (WP-SMTPD) with SMTP
          for <linux-raid@vger.kernel.org>; 28 Jul 2024 12:37:06 +0200
From: =?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>
To: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH] [DEBUG] md/raid1: check recovery_offset in raid1_check_read_range
Date: Sun, 28 Jul 2024 12:36:34 +0200
Message-Id: <20240728103634.208234-1-mat.jonczyk@o2.pl>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <9952f532-2554-44bf-b906-4880b2e88e3a@o2.pl>
References: <9952f532-2554-44bf-b906-4880b2e88e3a@o2.pl>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-WP-MailID: 2f2b5c119b9786ddc6624fe8163a95cc
X-WP-AV: skaner antywirusowy Poczty o2
X-WP-SPAM: NO 0000000 [sXPU]                               

This should fix the filesystem corruption during RAID resync.

Checking this condition in raid1_check_read_range is not ideal, but this
is only a debug patch.

Link: https://lore.kernel.org/lkml/20240724141906.10b4fc4e@peluse-desk5/T/#m671d6d3a7eda44d39d0882864a98824f52c52917
Signed-off-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
Cc: Yu Kuai <yukuai3@huawei.com>
Cc: Song Liu <song@kernel.org>
Cc: stable@vger.kernel.org
---
 drivers/md/raid1-10.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
index 2ea1710a3b70..4ab896e8cb12 100644
--- a/drivers/md/raid1-10.c
+++ b/drivers/md/raid1-10.c
@@ -252,6 +252,10 @@ static inline int raid1_check_read_range(struct md_rdev *rdev,
 	sector_t first_bad;
 	int bad_sectors;
 
+	if (!test_bit(In_sync, &rdev->flags) &&
+	    rdev->recovery_offset < this_sector + *len)
+		return 0;
+
 	/* no bad block overlap */
 	if (!is_badblock(rdev, this_sector, *len, &first_bad, &bad_sectors))
 		return *len;
-- 
2.25.1

