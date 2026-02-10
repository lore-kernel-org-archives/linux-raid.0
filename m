Received: from sg-1-35.ptr.blmpb.com (sg-1-35.ptr.blmpb.com [118.26.132.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508DB1917ED
	for <linux-raid@vger.kernel.org>; Tue, 10 Feb 2026 08:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770711072; cv=none; b=IkaDb4SbN3OwurQBXn1GgcyslKgDl2R9yNd2uwNGRkDLoLfSMxEa3FwIy18LDnVN8ZwIsowKmbZ+JRdiPvhv+zDs85ohvJ8NZncV9yJEeGV4nPgFcol+gRAy6DPQfanTVXlUG+noAD+N7G7yUAbaaPeBRguqKTPq7/uEA5BaRhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770711072; c=relaxed/simple;
	bh=dr0LQccwdKM/7mrxOC5C1gfn3uIL7ftunj9E0d1x4Mg=;
	h=Cc:Mime-Version:To:Message-Id:Content-Type:From:Subject:Date; b=Q5MIfLdBK4DknZAtx26NAA9FlLbCN8XukR+2g8hUz5VNgmaC4f161RNC8Aprbcbz7E/5xyRQqzJm3RUmSNGWXJOVpxkqQkIJtTmufc5+amtyRxXe1LDmvf8styD4eJeH7GdUXx5Povv6DDEQPH1ZSospftapDNLwTkLbIa59J4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=M9IQWOoG; arc=none smtp.client-ip=118.26.132.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="M9IQWOoG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1770711052;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=aAqFJFdoBxBUxcrSfmKz3m91I+RbuK5iyyFRMk60CJM=;
 b=M9IQWOoGZArJ22HTsvOzvqU5DXf1z3E+8BVdBZpdipigseAxRrIDjkPm4sjj5N9veSG8Rd
 sB8s/TBXNNhtBnjC0hA4h0OnT3Zl5G5u2QDPsVieXQmK4X4v6UFRJXGSdiyCEJ+3WRYJPV
 lmG0RPwOQSP5csWvtyhPnV2+9GaCON3luadfMr8je7K7qLrNDpuzWCpoms5QbfS+Fx9k22
 YBVggAdyPOTN10iD1GqbHjC37CD6Y/Qiv4D0HXmyCe9I9tt4PrlsTTZpvBDikEoDBUzpDf
 qeoSfzRPSx3gBGlUJf+bbWe8HdV7O1RQKmoy9N1uhNUBDlbV/uh7XNlrDGpAhQ==
Cc: <linux-kernel@vger.kernel.org>, <pmenzel@molgen.mpg.de>, 
	<tj.iam.tj@proton.me>, "Chen Cheng" <chencheng@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
To: <linux-raid@vger.kernel.org>
Message-Id: <20260210133847.269986-1-chencheng@fnnas.com>
X-Mailer: git-send-email 2.51.0
X-Lms-Return-Path: <lba+2698ae80a+09cdfd+vger.kernel.org+chencheng@fnnas.com>
X-Original-From: Chen Cheng <chencheng@fnnas.com>
Content-Type: text/plain; charset=UTF-8
From: "Chen Cheng" <chencheng@fnnas.com>
Subject: [PATCH] md: suppress spurious superblock update error message for dm-raid
Date: Tue, 10 Feb 2026 21:38:47 +0800
Received: from c ([113.111.140.189]) by smtp.feishu.cn with ESMTPS; Tue, 10 Feb 2026 16:10:50 +0800
Content-Transfer-Encoding: 7bit

dm-raid has external metadata management (mddev->external = 1) and
no persistent superblock (mddev->persistent = 0). For these arrays,
there's no superblock to update, so the error message is spurious.

The error appears as:
[  123.456789] md_update_sb: can't update sb for read-only array md0

Link: https://lore.kernel.org/all/20260128082430.96788-1-tj.iam.tj@proton.me/
Fixes: 6a5cb53aaa1d ("md: don't ignore read-only array in md_update_sb()")
Signed-off-by: Chen Cheng <chencheng@fnnas.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
---
 drivers/md/md.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 6d73f6e196a..e30b658641e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2790,7 +2790,9 @@ void md_update_sb(struct mddev *mddev, int force_change)
 	if (!md_is_rdwr(mddev)) {
 		if (force_change)
 			set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
-		pr_err("%s: can't update sb for read-only array %s\n", __func__, mdname(mddev));
+		if (!mddev_is_dm(mddev))
+			pr_err_ratelimited("%s: can't update sb for read-only array %s\n",
+					   __func__, mdname(mddev));
 		return;
 	}
 
-- 
2.51.0
