Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9894037AA77;
	Mon, 23 Feb 2026 21:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771883574; cv=none; b=RfSRJAqkgvPSlr9HZcEDyNYPbk5CBblcE0nqCF3Wg+UpARGvKuOWcIxKca6/fgp9yN9jiaQqSvnliZytXDA6AX+S1DCsH+hEU4ROJumJFrCW4lgX/SakZ577DCpTiX54jiylRiphCeRtNjK/fh9istw2uGJbxec/Md86MBpTlhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771883574; c=relaxed/simple;
	bh=xVSQhcp/jNKCGLiyHmWNULXCCfG4LcoHNou3bnExkmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MeSEykCiNj4jZ17VTK0tVzZl5DDAxKu4cnLcbBiTNYEeNIkqAglVBdjIzkH10/fDdzRGesPtKmPUiCK1zAD3LUzzyD0GGrha+6Sma9Qnj/3DwCqnyDW4VMIfSbpVZWu2uS6doSBLqswrJKrn+e6omrhQZfPP1B8PaNd/3P2uQ60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=o1v09+Kk; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="o1v09+Kk"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fKZN52v7vzlh2fP;
	Mon, 23 Feb 2026 21:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1771883570; x=1774475571; bh=SNj1f
	yPC6Vb/XNFItw8mO7/GtvIrZII+4+umwcug1kU=; b=o1v09+KkUtvJ11+LK/kt5
	h/Rh5+/XzWJVhOXGbgLAp52tyEGx0bj8KKTKdFnU/qMXXHEwpRludX0fms1ASNBo
	LtFxmMsThnk78oKWR/IJRoMJyLeF8WudJYchnTFSgs18r/8VH3gL1/im8Qz4H30+
	kiHVlTEQfUtHG59jGpUrSf+UAY0SL+KUUyz7N8lD8YJNzpEFjBn21zgh5VeUaOai
	TltegTiDseiHEoNS5P5lLSNcyMNuV1W3I812y5euQcyN8ZM7dNhUQpWvGCx59psB
	ntEYaYgASGNGflgP+k9EZB0YudHDwqjzjtnDycOAXk4qr2iqu9QiW4C6jgSXg3WS
	g==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id M3jfSB2p20Nl; Mon, 23 Feb 2026 21:52:50 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fKZMy2Szczlh2fJ;
	Mon, 23 Feb 2026 21:52:46 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>,
	linux-kernel@vger.kernel.org,
	Marco Elver <elver@google.com>,
	Christoph Hellwig <hch@lst.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Jann Horn <jannh@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fnnas.com>,
	linux-raid@vger.kernel.org
Subject: [PATCH 16/62] md: Make mddev_suspend() easier to analyze
Date: Mon, 23 Feb 2026 13:50:31 -0800
Message-ID: <20260223215118.2154194-17-bvanassche@acm.org>
X-Mailer: git-send-email 2.53.0.371.g1d285c8824-goog
In-Reply-To: <20260223215118.2154194-1-bvanassche@acm.org>
References: <20260223215118.2154194-1-bvanassche@acm.org>
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
