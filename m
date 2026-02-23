Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E9D36CDF8
	for <linux-raid@vger.kernel.org>; Mon, 23 Feb 2026 21:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771883427; cv=none; b=rZxpXv/zmrEwQ9eKUVopJDNl0hNYUKLsNAWbERw9FPK8aYWvsvc+gA+Y2wFVziZ5S9lgZgRatQ/R9k90lf+acpvU+34WdjqebX0XCsdf8VK7tcfndHtjPCzUyCL97dXPIxDv/LN8M/yKr5Y/3vJAxuTyhC9sVgq/rr1pBObfko8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771883427; c=relaxed/simple;
	bh=xVSQhcp/jNKCGLiyHmWNULXCCfG4LcoHNou3bnExkmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E9FPOfET7/GL9vBWnAf+bhB/lus7RmBw/2YyUqEjR+n9FXvN7TBvGz/HS8H7Oxjdd7n6RDaMcWIzpH51J+9ZIzhFsGSlRAIBsyuuptfv4USIT66BYe0WAOpjXRvz7dkYQ4brwcxR3QLKJCcsni488FqgHb9UFxupOEO/ehdJQwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=VRwMDBfk; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="VRwMDBfk"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fKZKG0p0czlh1Wg;
	Mon, 23 Feb 2026 21:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1771883424; x=1774475425; bh=SNj1f
	yPC6Vb/XNFItw8mO7/GtvIrZII+4+umwcug1kU=; b=VRwMDBfkSxV746iT2MZwO
	0G2aAF4ZINyjIOjuZUYpjzcmd8b3nnhjzmuEzzYlgzmbyPC9RfEf+xz0zZeQlVuF
	cZvbg0u/UxxySg6wVvpfC4IoaQKAOA3xJvIJ8gPEWs2/kIymgqBnKHcKHPaF+bao
	rOFk4DGIeKh21eBzMlEpKx8CK4uhwZ5csWn4NceMKRgyoKKRVyoe1KER7JiLq2DB
	D/2zt+nIVp0J9RI0PPvqxE/k9fAL3BN/gG27eBh/iK9ihyrBpX3oyeyw9W0tUR/s
	etPadxL3p7ilWSLNe90BSk+d+k/GsOw69TA+DP0eW1hxjBhiMN+AO9vuACuvNgny
	Q==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id k0wZ7WZ-StEQ; Mon, 23 Feb 2026 21:50:24 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fKZKC5J26zlfddf;
	Mon, 23 Feb 2026 21:50:23 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Bart Van Assche <bvanassche@acm.org>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fnnas.com>,
	linux-raid@vger.kernel.org
Subject: [PATCH 16/62] md: Make mddev_suspend() easier to analyze
Date: Mon, 23 Feb 2026 13:49:04 -0800
Message-ID: <20260223214950.2153735-17-bvanassche@acm.org>
X-Mailer: git-send-email 2.53.0.371.g1d285c8824-goog
In-Reply-To: <20260223214950.2153735-1-bvanassche@acm.org>
References: <20260223214950.2153735-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Prepare for enabling Clang's thread-safety analysis by moving an
if-statement. No functionality has been changed.

Cc: Song Liu <song@kernel.org>
Cc: Yu Kuai <yukuai@fnnas.com>
Cc: linux-raid@vger.kernel.org
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/md/md.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 3ce6f9e9d38e..b0d260d03a7d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -475,12 +475,13 @@ int mddev_suspend(struct mddev *mddev, bool interru=
ptible)
 	 */
 	lockdep_assert_not_held(&mddev->reconfig_mutex);
=20
-	if (interruptible)
+	if (interruptible) {
 		err =3D mutex_lock_interruptible(&mddev->suspend_mutex);
-	else
+		if (err)
+			return err;
+	} else {
 		mutex_lock(&mddev->suspend_mutex);
-	if (err)
-		return err;
+	}
=20
 	if (mddev->suspended) {
 		WRITE_ONCE(mddev->suspended, mddev->suspended + 1);
