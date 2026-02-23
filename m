Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A22637BE67
	for <linux-raid@vger.kernel.org>; Mon, 23 Feb 2026 22:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771884138; cv=none; b=bCW3BU/fVTyYxGGrEQ7kInkJx2uKqoNDOXm8v/lbTRIc+MuLOVtbn2X512Cxs34rkvL2A7v8iigZNa8P0lGnaKAfIZ0eCmbtXqWsfUFYici201/Xz1FyZeenBxBr+pCKYOo8KimOt7rvN0aXaM0lS33TI9ygGbtmBWLPVLEL/ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771884138; c=relaxed/simple;
	bh=kIe8qi82jMSjQXUsvf8G0gHkKCeOQw/bag3nVmiSqFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rg/OIYlpUdy4sMoy7+m+7FjN12Vl8ENYyphDje9XpTmRyPDiN5ium4h5OISf9R5OfDPGBOzBehR/CTZNuBMBqEJ3qY7C9sTgo6SjmKPEDiR1K5XwncxE9qpXlG1MHU0R42RRqu6EmZDQaW6p9gUE/eKMYM8NuA5RRDv7H8o+R00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=j4EuOEKJ; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="j4EuOEKJ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771884135;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yRVKh1PjOFORvD1T7LJppk1Rvgfg7sGCwkFuu3dQuv4=;
	b=j4EuOEKJ9bAadcvzcqXImCF+kcy3YL/UNCcvr8lUDuNBWWKsofOZyl1svxzAuGo0kVYaWR
	qRR4YhW+4e84PaJKz4jlwiwDeqzfX54R8AONUW5ToUSWpFAWtFfdRl6v4K0qU3dCs9XX9z
	rdzkAdHKRGTwqG2EM9BphQoF42LtWSE=
From: Bart Van Assche <bart.vanassche@linux.dev>
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
Date: Mon, 23 Feb 2026 14:00:16 -0800
Message-ID: <20260223220102.2158611-17-bart.vanassche@linux.dev>
In-Reply-To: <20260223220102.2158611-1-bart.vanassche@linux.dev>
References: <20260223220102.2158611-1-bart.vanassche@linux.dev>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Bart Van Assche <bvanassche@acm.org>

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
@@ -475,12 +475,13 @@ int mddev_suspend(struct mddev *mddev, bool interruptible)
 	 */
 	lockdep_assert_not_held(&mddev->reconfig_mutex);
 
-	if (interruptible)
+	if (interruptible) {
 		err = mutex_lock_interruptible(&mddev->suspend_mutex);
-	else
+		if (err)
+			return err;
+	} else {
 		mutex_lock(&mddev->suspend_mutex);
-	if (err)
-		return err;
+	}
 
 	if (mddev->suspended) {
 		WRITE_ONCE(mddev->suspended, mddev->suspended + 1);
