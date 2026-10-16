Received: from a27-42.smtp-out.us-west-2.amazonses.com (a27-42.smtp-out.us-west-2.amazonses.com [54.240.27.42])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E0837E5D1;
	Fri, 16 Oct 2026 04:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.27.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792124749; cv=none; b=GVzAWNO/h6J/2jxVf4ECaJDWGSZRIYaO/2Wtj/irAJQwVF8XurEgMPFtzGTPNlm8ShIr/Gl43/GPFjFoa+VRwyg0T1tXm0SkRK+yRnK6xySnjJ15/TZNLgYAw8cysiz4WafsbR0FiN4bdUVSbGohnSmB1Ec1tS0ToCW3MQnP/EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792124749; c=relaxed/simple;
	bh=TfXl7qua3H8MBhHzvOtoZrGIVVE95GiNPVO9OQzzi1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XhQuq0QfQ8lnQryp6s5ypanUJHQ5Pbl0Sc/HpPSwVo/Zt1v8oPyLL5f9WYKL9VNXJXtXsWY51ACacOK/bq7+YnOIDJHfQn+uIF5SNVHAJN+glSeP8zi2uZo41WP85XmbN5xvMn8ZQh5dxVXFbDDrN00NMaQq5yn6ATyql42ESao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dougvj.me; spf=pass smtp.mailfrom=bounce.dougvj.me; dkim=pass (2048-bit key) header.d=dougvj.me header.i=@dougvj.me header.b=IsAqO4/o; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=CZETkzfm; arc=none smtp.client-ip=54.240.27.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dougvj.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bounce.dougvj.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dougvj.me header.i=@dougvj.me header.b="IsAqO4/o";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="CZETkzfm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=75cpmoop2pyf56gdndy2e364ijbokrge; d=dougvj.me; t=1792124747;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=TfXl7qua3H8MBhHzvOtoZrGIVVE95GiNPVO9OQzzi1Q=;
	b=IsAqO4/oyaoCSiqeGau1EGCY2YFdxl9OOU9zT+rHdBvxL+yu2BZyDuZf5WyiQ/zn
	nhjSEaZRty6MPGbiaiglNQQ6j5ALYX9zCnDVS0MPuHNOB5FKZFaVCoR5yYMaqfv6ArS
	99mTcscMUgX9W9vU08YTwM2Zad5B4ghi0NnsjMetL3OVYJ7wRZPAEBT/y1e1aCHIg0/
	G/e1tI//dBYZ0D4oZMy+SPJJ17yaY/PO4ZGbDbb1z4DB9ECfLG5JEjGA01PUGZL+u0+
	UelE99+VULBP8KJFwVLv44c283mYt6PG9QzqY625HNUHKkbnC6F5Uogq283mnkVMoKV
	NkpS5Z9Zlg==
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=hsbnp7p3ensaochzwyq5wwmceodymuwv; d=amazonses.com; t=1792124747;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Feedback-ID;
	bh=TfXl7qua3H8MBhHzvOtoZrGIVVE95GiNPVO9OQzzi1Q=;
	b=CZETkzfmthOeFkxpR0kxPj4gE6LNI9Ug+bKtRWViFpp2w1T3Sx4kDookagU1Lo9O
	OL/4haMYI86p6P3wnI3lr3UEwXDD156eEi5FB2leMHVDgd8Stv839d5kjf99MuiRl8u
	hU/s37jVs8MeWi2YsQXjQt5l9IzaVH0G/8EmQoT8=
From: Doug V Johnson <me@dougvj.me>
Authentication-Results: mail.bonnevilleinformatics.com;
	auth=pass smtp.mailfrom=me@dougvj.me
To: linux-raid@vger.kernel.org
Cc: song@kernel.org, yukuai@fygo.io, magiclinan@didiglobal.com, 
	xiao@kernel.org, chencheng@fnnas.com, linux-kernel@vger.kernel.org, 
	Doug V Johnson <me@dougvj.me>
Subject: [PATCH v4 1/3] md/raid5: freeze and interrupt reshape when handling failed reshape
Date: Fri, 16 Oct 2026 04:25:47 +0000
Message-ID: <010101a142f57e37-cd14b78d-54cd-447b-9888-87f166a937ab-000000@us-west-2.amazonses.com>
In-Reply-To: <20261016042537.277516-1-me@dougvj.me>
References: <20261016042537.277516-1-me@dougvj.me>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: -----
Feedback-ID: ::1.us-west-2.yIAaOWcA3P0r3CWRzBxY2mlnWgm/DtEO6k5/iZ9ogRk=:AmazonSES
X-SES-Outgoing: 2026.10.16-54.240.27.42

Set the reshape freeze flag to prevent automatic reshape resumption
and interrupt the current reshape with md_sync_error() so that a
reshape always stops no matter how the failed reshape is triggered.

Previously, if there were no faulty or out of sync devices but there
was an unrecoverable read, the reshape continued and was not cancelled
after handle_failed_reshape(). This caused some data corruption as
block writes were cancelled but the reshape nonetheless continued.

Prior to Chen's fix, the kernel would deadlock with a failed stripe
read.  That case also caused some data corruption, so Chen's patch
did not introduce corruption in this case.

An example test case showing how this happened before this fix is
demonstrated by the following:

Simplified example (schematic logical sector numbers):

  1. Before reshape, destination D contains data for logical 20-27.
     The new geometry will use D for logical 100-107.

  2. Inject bad-block metadata on enough members that the old source
     stripe cannot be reconstructed. Logical sector 100 now returns
     a read error; sectors 101-107 are still readable.

  3. Reshape tries to read the source block for logical 100-107.
     The bad-block records prevent a successful read/reconstruction.
     Failure cleanup cancels the destination write:

       Source: logical 100-107 --X--> destination D
                                     still contains data for 20-27

  4. Without interruption, reshape continues and completes.
     The new mapping now sends reads of logical 100-107 to D.

  5. Reading logical 100-107 succeeds, but returns data for 20-27.
     Previously readable sectors 101-107 now return wrong data.

Code that injects bad blocks to demonstrate this problem before and
after Chen's fix as well as after this patch can be found here:

Link: https://github.com/dougvj/md-raid-reshape-badblock-corruption-test

Fixes: 788e4139463f ("md/raid5: fix reshape deadlock while failed devices more than max degraded")
Link: https://patch.msgid.link/20260624075824.2601110-1-chencheng@fnnas.com
Assisted-by: LLM
Signed-off-by: Doug V Johnson <me@dougvj.me>
---
 drivers/md/raid5.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b91545ce090d..86ea65559576 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3773,6 +3773,10 @@ static void handle_failed_reshape(struct r5conf *conf, struct stripe_head *sh,
 	bool was_expanding = test_and_clear_bit(STRIPE_EXPANDING, &sh->state);
 	bool was_ready = test_and_clear_bit(STRIPE_EXPAND_READY, &sh->state);
 
+	/* Freeze reshaping to prevent data loss */
+	set_bit(MD_RECOVERY_FROZEN, &conf->mddev->recovery);
+	md_sync_error(conf->mddev);
+
 	if (was_expanding || was_ready) {
 		atomic_dec(&conf->reshape_stripes);
 		wake_up(&conf->wait_for_reshape);
-- 
2.54.0

