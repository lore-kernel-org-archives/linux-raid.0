Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE6D3C433F5
	for <linux-raid@archiver.kernel.org>; Fri, 12 Nov 2021 14:28:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D65B861039
	for <linux-raid@archiver.kernel.org>; Fri, 12 Nov 2021 14:28:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235146AbhKLObg (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 12 Nov 2021 09:31:36 -0500
Received: from group.wh-serverpark.com ([159.69.170.92]:44971 "EHLO
        group.wh-serverpark.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235222AbhKLObf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 12 Nov 2021 09:31:35 -0500
Received: from localhost (localhost [127.0.0.1])
        by group.wh-serverpark.com (Postfix) with ESMTP id 5F728EEBA4A;
        Fri, 12 Nov 2021 15:28:43 +0100 (CET)
Received: from group.wh-serverpark.com ([127.0.0.1])
        by localhost (group.wh-serverpark.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id USVB5k62BfQZ; Fri, 12 Nov 2021 15:28:43 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by group.wh-serverpark.com (Postfix) with ESMTP id E9C7DEEBA4C;
        Fri, 12 Nov 2021 15:28:42 +0100 (CET)
X-Virus-Scanned: amavisd-new at valiant.wh-serverpark.com
Received: from group.wh-serverpark.com ([127.0.0.1])
        by localhost (group.wh-serverpark.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Y0K2naJL_dY6; Fri, 12 Nov 2021 15:28:42 +0100 (CET)
Received: from debu64bu.wh-serverpark.com (eps.wh-serverpark.com [159.69.170.94])
        by group.wh-serverpark.com (Postfix) with ESMTPS id D83C1EEBA4A;
        Fri, 12 Nov 2021 15:28:42 +0100 (CET)
From:   markus@hochholdinger.net
To:     song@kernel.org, linux-raid@vger.kernel.org, xni@redhat.com
Cc:     Markus Hochholdinger <markus@hochholdinger.net>
Subject: [PATCH] md: fix update super 1.0 on rdev size change
Date:   Fri, 12 Nov 2021 14:28:22 +0000
Message-Id: <20211112142822.813606-1-markus@hochholdinger.net>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Markus Hochholdinger <markus@hochholdinger.net>

The superblock of version 1.0 doesn't get moved to the new position on a
device size change. This leads to a rdev without a superblock on a known
position, the raid can't be re-assembled.

Fixes: commit d9c0fa509eaf ("md: fix max sectors calculation for super 1.=
0")
---
 drivers/md/md.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 6c0c3d0d905a..ad968cfc883d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2193,6 +2193,7 @@ super_1_rdev_size_change(struct md_rdev *rdev, sect=
or_t num_sectors)
=20
 		if (!num_sectors || num_sectors > max_sectors)
 			num_sectors =3D max_sectors;
+		rdev->sb_start =3D sb_start;
 	}
 	sb =3D page_address(rdev->sb_page);
 	sb->data_size =3D cpu_to_le64(num_sectors);
--=20
2.30.2

