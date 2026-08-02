Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD89D327C00;
	Sun,  2 Aug 2026 19:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785700268; cv=none; b=IQ/bQh3sMmyqKrwbTmEha4QMxZimD1xD06jr+XvximzokNYckFurMsdj9DToinbmt1YBzs3mlH4zHDm22vW/9SoaLRAUvapp7mYOMPIV3WyRXpTSzLA5cnRSLShYbpRbUiqKzmaBHDD6T/1Ikf52KYoFI1XGNMB7Dudy7HdUsyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785700268; c=relaxed/simple;
	bh=rwOzmpg3vR0LnvYLs1uZZ+L8hN8RCJEJ3vJ4wEd9gOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O2rcevluc5hm3jxd7py9Tz5k3xyAwkwaKz1vpmB6deNBCzOWzm9HDYZKP+yYUi+Yg4dNNOt31FoxxXUJu0eFW5dyMgy1yprnJoeOSHsFEofQNN3d+1rwHqf4P/CK5SG3hUqAVIN80TXGfpEXxFgICVRL0S/zXvPiZlAVyhRKIJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dmXUgvWp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dmXUgvWp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09A8E1F00A3A;
	Sun,  2 Aug 2026 19:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785700267;
	bh=wMFvuuW59mwlS5gcr6gtDyHiuNgmW16AAKd9HbpA/jA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dmXUgvWp+rvJS+T42wN6meep5EDS71Cw7rZGKGNTrKIIuXCTIrbC2lUJU1jANQ2us
	 5sWAV7q6yX4p4abVvzkOQEFqVeo6bx8yZ4dKNDv+7G1cs6MmrJV++1i1+PO4fqT5bw
	 LPjbtc5CYGyxywfb3v7dfO3RCvNKAA/A2IdGMDVta/AtRseJ4GDUPzQGpa5qykBAe/
	 Gp2QYvWxzpF/oyudRiP+/hGO3Lr5uHvQTtZTxLNoxU7OSH00gbVVpBI7i/t644pDgE
	 5SDFRt1Ju453wK9/VJdY6odIpczmZwOuAf9aXMdBVbJ+EqExZpeC2ym+tXb6IDIeWi
	 5Rp1tzom/f7Ng==
From: Yu Kuai <yukuai@kernel.org>
To: Song Liu <song@kernel.org>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>
Cc: Yu Kuai <yukuai@fygo.io>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mykola Marzhan <mykola@meshstor.io>,
	Su Yue <glass.su@suse.com>
Subject: [PATCH v5 06/29] md: wait for behind writes before destroying bitmap
Date: Mon,  3 Aug 2026 03:50:15 +0800
Message-ID: <20260802195038.164272-7-yukuai@kernel.org>
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

__md_stop() destroyed the bitmap before calling mddev_detach(). That made
mddev_detach() skip bitmap_ops->wait_behind_writes(), because the bitmap
was already disconnected from mddev.

This was still safe for the legacy bitmap because bitmap_destroy() waits
for behind writes itself. llbitmap keeps that wait in its
->wait_behind_writes() operation instead, while ->destroy() tears down the
llbitmap storage. With the old ordering, RAID1 behind-write completions
could still run after llbitmap storage had been freed.

Call mddev_detach() before md_bitmap_destroy() so the common detach path
can wait for behind writes while the bitmap is still alive. Only destroy
the bitmap after those users are gone.

Fixes: 5ab829f1971d ("md/md-llbitmap: introduce new lockless bitmap")
Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 drivers/md/md.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 51b620edbef7..b61040315aef 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7085,8 +7085,8 @@ static void __md_stop(struct mddev *mddev)
 {
 	struct md_personality *pers = mddev->pers;
 
-	md_bitmap_destroy(mddev);
 	mddev_detach(mddev);
+	md_bitmap_destroy(mddev);
 	spin_lock(&mddev->lock);
 	mddev->pers = NULL;
 	spin_unlock(&mddev->lock);
-- 
2.51.0

