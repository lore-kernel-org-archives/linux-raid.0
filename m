Received: from a27-24.smtp-out.us-west-2.amazonses.com (a27-24.smtp-out.us-west-2.amazonses.com [54.240.27.24])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5481A38423D;
	Fri, 16 Oct 2026 04:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.240.27.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792124751; cv=none; b=NQWkNeYeD2bnJ43WXEcXa7SkmnYza3aXVSFt2ixWA9FaOxmCsIAbxOcyMVdo0Im2I/A7h8GvDG2X7fVntcL2RyV/eXsubeKgz/PKnR8wiNP784GQIj/BS0Zq8ON6eNVvrt9VjYJgb0e9oNiDnoFzmm1y5opHWQPs2dUe7YCR7CY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792124751; c=relaxed/simple;
	bh=fhTPlTuxhWyAUi0BlB7l5x8jVd7gI8ACauyF8TedkAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p3a9PnQXSMl+3L3ogMvnAtM5ngQLRkP85aF/cLmCPMd6QrYam/FLLnDAKglDZObUntwBHONxXqs35QsJ7PzzaG5SpkRsUVROoV5H+Bqc+A/JQk+rdls9BwY6StQSr2ctpJKX9D1bzfiPzY3a1b3fwl9o2H2bjr1FIGBKBITBbyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dougvj.me; spf=pass smtp.mailfrom=bounce.dougvj.me; dkim=pass (2048-bit key) header.d=dougvj.me header.i=@dougvj.me header.b=tVjhaQj5; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=OqTr6I1V; arc=none smtp.client-ip=54.240.27.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dougvj.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bounce.dougvj.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dougvj.me header.i=@dougvj.me header.b="tVjhaQj5";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="OqTr6I1V"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=75cpmoop2pyf56gdndy2e364ijbokrge; d=dougvj.me; t=1792124748;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=fhTPlTuxhWyAUi0BlB7l5x8jVd7gI8ACauyF8TedkAY=;
	b=tVjhaQj5RWtkMVxoYLn579Ey1hDe31yXy7aPZxZZpVzXFstgs/lzuBDCv6AHFyHb
	kcVtNnoqAu6q0pGG1MrzMZEPVXUTcbiDRhZuje6b8EMgHbiSBNpT71nYimEW0h0T1+2
	DhLy3j5GeDaKum9RgTY/XmyKkCAfTfYXJgvRdOCVsZdQcItdJoY33+QwsxqQ3yoSIcO
	KnJsSAqeceOp1xS0bpzFy3mASubKvGbuhkWnpkyYqpNc70JTuEOZ1N3ePmDyGOurLXK
	tWcyEptf82D+GHFb6VKpN7uMFGUOPa1D8Xzy7kJ8yVl02E2JNfhHd2gbPCEV1hfZHzJ
	fpnxOQEWYQ==
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=hsbnp7p3ensaochzwyq5wwmceodymuwv; d=amazonses.com; t=1792124748;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Feedback-ID;
	bh=fhTPlTuxhWyAUi0BlB7l5x8jVd7gI8ACauyF8TedkAY=;
	b=OqTr6I1VaWXqCNIR83q4/p0cIPPe9iXUlAY8QNKnrmyM4oKmPyd/UpwTdYOpmhwY
	EabmnqmLPPxwcYwLfKyKBs1bhOgKCDrIcKipAHInnnci6mRPX6ymjTnhutwBy4FiGRQ
	ofPRWmEH31lB9aWqAYDSmXqF+dkTscU56Zot5CxI=
From: Doug V Johnson <me@dougvj.me>
Authentication-Results: mail.bonnevilleinformatics.com;
	auth=pass smtp.mailfrom=me@dougvj.me
To: linux-raid@vger.kernel.org
Cc: song@kernel.org, yukuai@fygo.io, magiclinan@didiglobal.com, 
	xiao@kernel.org, chencheng@fnnas.com, linux-kernel@vger.kernel.org, 
	Doug V Johnson <me@dougvj.me>
Subject: [PATCH v4 3/3] md/raid5: warn when a read fails due in some part to bad-block metadata
Date: Fri, 16 Oct 2026 04:25:48 +0000
Message-ID: <010101a142f583eb-3d8069c0-51c1-4db5-a301-d62f9c2937fa-000000@us-west-2.amazonses.com>
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
X-SES-Outgoing: 2026.10.16-54.240.27.24

Report that bad block metadata contributed to a read failure on the
array so that it's clear that the failure may not be directly due to
an immediate underlying device read failure.

There has been a documented case of bad block metadata being erroneously
copied around contributing to mystery read failures with no underlying
device failure.  This warning will help users understand why the
failure exists and may lead to the discovery of this condition sooner.

Link: https://lore.kernel.org/r/20250224090209.2077-2-dougvj@dougvj.net
Link: https://lkml.iu.edu/2501.3/01088.html
Assisted-by: LLM
Signed-off-by: Doug V Johnson <me@dougvj.me>
---
 drivers/md/raid5.c | 16 ++++++++++++++++
 drivers/md/raid5.h |  2 +-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 23ff549fa363..f721eb97f655 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3672,6 +3672,16 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 				wake_up_bit(&sh->dev[i].flags, R5_Overlap);
 			if (bi)
 				s->to_read--;
+			/*
+			 * If we recorded bad blocks from the metadata
+			 * on any of the devices then report this to
+			 * userspace in case anyone might suspect
+			 * something more fundamental instead
+			 */
+			if (bi && s->bad_blocks)
+				pr_warn_ratelimited("%s: read encountered block in device bad block list at %llu\n",
+						    mdname(conf->mddev),
+						    (unsigned long long)sh->sector);
 			while (bi && bi->bi_iter.bi_sector <
 			       sh->dev[i].sector + RAID5_STRIPE_SECTORS(conf)) {
 				struct bio *nextbi =
@@ -4764,6 +4774,12 @@ static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
 		if (rdev) {
 			is_bad = rdev_has_badblock(rdev, sh->sector,
 						   RAID5_STRIPE_SECTORS(conf));
+			if (is_bad) {
+				s->bad_blocks++;
+				pr_debug("bad blocks encountered dev %i sector %llu %lu\n",
+					 i, (unsigned long long)sh->sector,
+					 (unsigned long)RAID5_STRIPE_SECTORS(conf));
+			}
 			if (s->blocked_rdev == NULL) {
 				if (is_bad < 0)
 					set_bit(BlockedBadBlocks, &rdev->flags);
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index cb5feae04db2..6b90c9565ec0 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -282,7 +282,7 @@ struct stripe_head_state {
 	 * read all devices, just the replacement targets.
 	 */
 	int syncing, expanding, expanded, replacing;
-	int locked, uptodate, to_read, to_write, failed, written;
+	int locked, uptodate, to_read, to_write, failed, written, bad_blocks;
 	int to_fill, compute, req_compute, non_overwrite;
 	int injournal, just_cached;
 	int failed_num[2];
-- 
2.54.0

