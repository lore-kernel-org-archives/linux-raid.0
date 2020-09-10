Return-Path: <SRS0=i/dv=CT=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47607C43461
	for <linux-raid@archiver.kernel.org>; Thu, 10 Sep 2020 20:59:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB8C82080A
	for <linux-raid@archiver.kernel.org>; Thu, 10 Sep 2020 20:59:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pqbq3hLU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbgIJU7i (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 10 Sep 2020 16:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731179AbgIJOsu (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 10 Sep 2020 10:48:50 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A12EC0617A0;
        Thu, 10 Sep 2020 07:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=bCMdefcbVNK1n/7kExQP4kHzaTJA1/jyiOiumdm05Vg=; b=pqbq3hLUr/RK0sVYON+22CBoDU
        7iSshg/1l8TWLuQVYMixMDbnZc1Hg5HnvmYUIcilUUJPk0Is/ohirNDQMPb3QGq2IhpRqrYumSJgM
        qZNRFRy7RKH0RISBXjgXQ/6kSMbPIbfvInVxWG5KMegLf+D07GbBvZSsvoHYoWCJBCkj5tS529ttl
        H4dhhGbPsRx08exHjwjKb+Y9W4tkJo0BuuEYRed+LbTrVG1rtVUhVxXBLXfOXI4qJO3c8HFdVJFWC
        TBzwWpycopMcJg+pMD1kfumXoKQ4oHaqbvTG0Ty3nCsN68OEsQx0cQrn9lfxrLzcI+1g0+pPzFHCl
        BsAO6FNA==;
Received: from [2001:4bb8:184:af1:3ecc:ac5b:136f:434a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kGNsJ-0006vW-8P; Thu, 10 Sep 2020 14:48:35 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Song Liu <song@kernel.org>, Hans de Goede <hdegoede@redhat.com>,
        Richard Weinberger <richard@nod.at>,
        Minchan Kim <minchan@kernel.org>,
        linux-mtd@lists.infradead.org, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        drbd-dev@lists.linbit.com, linux-raid@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 01/12] fs: remove the unused SB_I_MULTIROOT flag
Date:   Thu, 10 Sep 2020 16:48:21 +0200
Message-Id: <20200910144833.742260-2-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200910144833.742260-1-hch@lst.de>
References: <20200910144833.742260-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The last user of SB_I_MULTIROOT is disappeared with commit f2aedb713c28
("NFS: Add fs_context support.")

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/namei.c         | 4 ++--
 include/linux/fs.h | 1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index e99e2a9da0f7de..f1eb8ccd2be958 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -568,8 +568,8 @@ static bool path_connected(struct vfsmount *mnt, struct dentry *dentry)
 {
 	struct super_block *sb = mnt->mnt_sb;
 
-	/* Bind mounts and multi-root filesystems can have disconnected paths */
-	if (!(sb->s_iflags & SB_I_MULTIROOT) && (mnt->mnt_root == sb->s_root))
+	/* Bind mounts can have disconnected paths */
+	if (mnt->mnt_root == sb->s_root)
 		return true;
 
 	return is_subdir(dentry, mnt->mnt_root);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 7519ae003a082c..fbd74df5ce5f34 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1385,7 +1385,6 @@ extern int send_sigurg(struct fown_struct *fown);
 #define SB_I_CGROUPWB	0x00000001	/* cgroup-aware writeback enabled */
 #define SB_I_NOEXEC	0x00000002	/* Ignore executables on this fs */
 #define SB_I_NODEV	0x00000004	/* Ignore devices on this fs */
-#define SB_I_MULTIROOT	0x00000008	/* Multiple roots to the dentry tree */
 
 /* sb->s_iflags to limit user namespace mounts */
 #define SB_I_USERNS_VISIBLE		0x00000010 /* fstype already mounted */
-- 
2.28.0

