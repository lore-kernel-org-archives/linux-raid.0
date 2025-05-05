Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D72C25C81A
	for <linux-raid@vger.kernel.org>; Mon,  5 May 2025 15:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746458939; cv=none; b=unFqi5/HvSQShVnkzFKW6Yo2Y/10UYgRvIMhYop84EfdZ3/wB5cS6fTwsmWmPLM5uwykP1yBWqjhQ7o5AVCFXc8PlvXS1IyJTQEo6roPJVF7tdr/U/cJdNlzjJ9XKBCLFcpKH9Lu9bTXGC5smEVyQo5qjb7icJgCGdAGaX/bg3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746458939; c=relaxed/simple;
	bh=wOIpyQtkhQpM2EEwcE2g4wnkYQ5WHPqWJJIZ8E3zVvs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=D8kZcZQlg6CMHZvPlKfaot1f+TJYRU8e2ZLTNJSXNQdO1Yyd3uoH3z5p5HgTih3VFeN3SXwiZbD2mJRc0SH+ax+ZkKXutE32iJ2WcL6ZFeFpf+UwwTO6bG9yT2laKoPhhVOOkFL9SbdTj7uvmy1TJWV/Q7Duny8tPvHDln+SpvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B3lClhjX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B3lClhjX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29BBEC4CEE4;
	Mon,  5 May 2025 15:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746458938;
	bh=wOIpyQtkhQpM2EEwcE2g4wnkYQ5WHPqWJJIZ8E3zVvs=;
	h=From:To:Cc:Subject:Date:From;
	b=B3lClhjX0H3rqhfV7LegYOhsDfktYTV31EV4dPaschNSCk5IBJngCQORLcAxtnAvN
	 rKLv0A4Kr55WXXr7hCXx9Y2Pr7upehbbaXhNU3OTzsPbz22TzM2apZMxpxBN33PHML
	 TAQnf1t2SX7JF6xAW/VAlpd1CKKEO9IQEPIWSJMtppKPyPStbOJXETUnLTMe+7heb3
	 1/FoDLWZbmgEWl8IsoaeQdPYr4dBr/Zn8Mgg1Z5N3/zOZtARmQaXEjeWhXO7ur4wX2
	 gqQTCgTL1LWaEUreLbThWuzEzjyd5FWk3fkbNdpvb/q9sjcdEosWTW/q3l8gUxSFQY
	 gRV+MxwaBZAlQ==
From: colyli@kernel.org
To: linux-raid@vger.kernel.org
Cc: Coly Li <colyli@kernel.org>,
	Logan Gunthorpe <logang@deltatee.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Xiao Ni <xni@redhat.com>,
	Song Liu <song@kernel.org>
Subject: [RFC PATCH] fix a reshape checking logic inside make_stripe_request()
Date: Mon,  5 May 2025 23:28:31 +0800
Message-Id: <20250505152831.5418-1-colyli@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Coly Li <colyli@kernel.org>

Commit f4aec6a09738 ("md/raid5: Factor out helper from
raid5_make_request() loop") added the following code block to check
whether the reshape range passed the stripe head range during thetime to
wait for a valid struct stripe_head object,

5971         if (unlikely(previous) &&
5972             stripe_ahead_of_reshape(mddev, conf, sh)) {
5973                 /*
5974                  * Expansion moved on while waiting for a stripe.
5975                  * Expansion could still move past after this
5976                  * test, but as we are holding a reference to
5977                  * 'sh', we know that if that happens,
5978                  *  STRIPE_EXPANDING will get set and the expansion
5979                  * won't proceed until we finish with the stripe.
5980                  */
5981                 ret = STRIPE_SCHEDULE_AND_RETRY;
5982                 goto out_release;
5983         }

But from the code comments and context, the if statement should check
whether stripe_ahead_of_reshape() returns false, then the code logic can
match the context that reshape range went accross the sh range during
raid5_get_active_stripe().

And unlikely(previous) seems useless inside the if statement, and the
unlikely() should include all checking statemetns.

This patch has both of the above changes, hope it can make the code be
more comfortable.

Fixes: f4aec6a09738 ("md/raid5: Factor out helper from raid5_make_request() loop")
Signed-off-by: Coly Li <colyli@kernel.org>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Yu Kuai <yukuai3@huawei.com>
Cc: Xiao Ni <xni@redhat.com>
Cc: Song Liu <song@kernel.org>
---
 drivers/md/raid5.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 39e7596e78c0..030e4672ab18 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5969,8 +5969,7 @@ static enum stripe_result make_stripe_request(struct mddev *mddev,
 		return STRIPE_FAIL;
 	}
 
-	if (unlikely(previous) &&
-	    stripe_ahead_of_reshape(mddev, conf, sh)) {
+	if (unlikely(previous && !stripe_ahead_of_reshape(mddev, conf, sh))) {
 		/*
 		 * Expansion moved on while waiting for a stripe.
 		 * Expansion could still move past after this
-- 
2.39.5

