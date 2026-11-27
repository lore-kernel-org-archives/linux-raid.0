Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.70.43.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795739574;
	b=M1BD0TWfuOjGZW1JWJNxEVxBEekiBsl5KjTgh0TkWNxeLMog/biXCEJZZOHBks7beurG
	 hXtWL91TBWRBDPh0XtMF80LXtnrcUuoDFyP/WjPv+elDBSnOUI8aQMeIMV9vTDTn2VjCc
	 B1kAHLOwh++WuLrUq8YGl51Dm+z3Qn3x0NdwSXmIlMXGMIAy7Q+aH8o7Ih4tTG7iNoae6
	 EEW9cJIhueY1xqhUOyAFHS3qz+fxLCDd8CFwZ7Iq9KCF0B6lgvxWOENpsPs9sKYi7zd/E
	 vShCQFSIlEEe9azDt6F78h7V1Y66GHXBSVayYkF9X1pYX+p6ip9390t8vYmvyrkqtjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795739574;
	h=DMARC-Filter:DKIM-Signature:X-Pm-Submission-Id:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=IACRLp6pV6bYBuqDo7+FTc27UH/bxNfLrdhVo/b7j4I=;
	b=Zh8DBg5hQ0d2U9anfTVOzHwQ7Gm1Tq2jKbesuJ3tI1Bixk7Hy9/2Qtf4QlnvS4yQJ8P+
	 huG5ZAJfwDh/BE4igjcDBdEkq8sHR7jtsiTIQCrjDfJzZt8pij2uqmhY/3GcJ9NLkdkwZ
	 yDcfHxj/J+CBTuqhFpUF/FR5MuqFYkyW+u27194k3fySMTAebAKHRt+U8xOeM5w3o8MPt
	 4GFM5KvP3nvH2ohSsATP7UmT1ltKeEtKdN2XA8BLbGTnjBpcgmQRA+oqN/8Y5T5fPacW0
	 xXB8jKSZfVQc95JiCR3M/dYK8ppiJtBIlOk8sUQEd4Kfs8wIwUuIrmBxqyfES6A7gxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=raidlab.org;
	spf=pass smtp.mailfrom=raidlab.org;
	dkim=pass header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=gURGT1q5;
	arc=none smtp.remote-ip=185.70.43.170
Received: from mail-43170.protonmail.ch (mail-43170.protonmail.ch [185.70.43.170])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF2E606A69C;
	Fri, 27 Nov 2026 00:32:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7CF2E606A69C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raidlab.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raidlab.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=gURGT1q5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raidlab.org;
	s=protonmail; t=1795739571; x=1795998771;
	bh=IACRLp6pV6bYBuqDo7+FTc27UH/bxNfLrdhVo/b7j4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:From:To:
	 Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=gURGT1q5YMVLf4gkMy56cs+Vozol4yTPPbwVf0qH2CgysljjaUnsuro5dI2muRc0g
	 AhM/gyOwo7/8bPpSsluuZ14A47ZjrpWLfYokciLjJdz5hFCGyW8ruU2Li/gDk5KAaI
	 264GqjX5R+Ip+uE20DPNxzWSVPblw+08YP5jUL9DnFEKG4/FoSgZnR/EOiKtD/un6r
	 WGp1uJ7OwPKM+e2bWMbDcGkC9YzRM3CKHZWIM6sX1KGbuWUZ0NS4VK6pGM5+Cm1L34
	 oRTsEgCiNWW4hMtDl3MGxunbVFQBp2HGnRzpwm5yU40jnB+vBlNZ6PMD+CrLGwzHj4
	 D7OFcBbYGXomw==
X-Pm-Submission-Id: 4jbDsG04x0z2ScQG
From: Miroslav Cimerman <mc@raidlab.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	NeilBrown <neil@brown.name>,
	Mariusz Tkaczyk <mtkaczyk@kernel.org>,
	Kenta Akagi <k@mgml.me>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] md/raid1: set MD_SB_CHANGE_PENDING under device_lock in raid1_error()
Date: Fri, 27 Nov 2026 00:32:29 +0000
Message-ID: <20261127003231.1180197-7-mc@raidlab.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261127003231.1180197-1-mc@raidlab.org>
References: <20261127003231.1180197-1-mc@raidlab.org>
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

raid1_error() drops device_lock after it sets Faulty and before it sets
MD_SB_CHANGE_PENDING. raid1d can release a held write in between,
before the superblock records the failure.

Set MD_SB_CHANGE_PENDING under the lock, as raid10_error() does.

Fixes: 55ce74d4bfe1 ("md/raid1: ensure device failure recorded before write request returns.")
Cc: stable@vger.kernel.org
Signed-off-by: Miroslav Cimerman <mc@raidlab.org>
---
 drivers/md/raid1.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 54ba3013150e..f596b36ec6e1 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1741,13 +1741,13 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
 	if (test_and_clear_bit(In_sync, &rdev->flags))
 		mddev->degraded++;
 	set_bit(Faulty, &rdev->flags);
+	set_mask_bits(&mddev->sb_flags, 0,
+		      BIT(MD_SB_CHANGE_DEVS) | BIT(MD_SB_CHANGE_PENDING));
 	spin_unlock_irqrestore(&conf->device_lock, flags);
 	/*
 	 * if recovery is running, make sure it aborts.
 	 */
 	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-	set_mask_bits(&mddev->sb_flags, 0,
-		      BIT(MD_SB_CHANGE_DEVS) | BIT(MD_SB_CHANGE_PENDING));
 	pr_crit("md/raid1:%s: Disk failure on %pg, disabling device.\n"
 		"md/raid1:%s: Operation continuing on %d devices.\n",
 		mdname(mddev), rdev->bdev,
-- 
2.53.0

