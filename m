Return-Path: <SRS0=osZw=EC=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5FD0C83008
	for <linux-raid@archiver.kernel.org>; Tue, 27 Oct 2020 00:34:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C03E222C8
	for <linux-raid@archiver.kernel.org>; Tue, 27 Oct 2020 00:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603758871;
	bh=Iv6oWJLm2ZeV/TBAkasOqZMrTumMK7Ca24ww5LvigYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=xBFAd0Z0u6RPnolD4w9Wo3HMewBSbmukzS99Yof3mJJJsJq1w8+S+cBbzn4ZgYLFD
	 dO3trgr5IkDkUAQpgFxkVDzjsPLNM5qUBRLou4ug48Q2EFtL+0MixxXRsRoa0SoYLT
	 ErCWp7HuqXR+Obow2Ewzoo6+PDHaIZYODiNkf248=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409356AbgJZXvP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:51:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:51686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409344AbgJZXvO (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 26 Oct 2020 19:51:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF35121BE5;
        Mon, 26 Oct 2020 23:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756273;
        bh=Iv6oWJLm2ZeV/TBAkasOqZMrTumMK7Ca24ww5LvigYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IL7p3mWhez48DCins3LAInHKlV8JK36/+HkHSFVB5k+zSHp6Gmbg4xuX7ZXfnKJOn
         MVFGYvI2wBELq1fSKoIa+Cc8aE6zOB2AFMUwoNdnydtN9ZI+HO3d8jjbnD+u4LoYel
         uYEV4BUBA9AReWjwuHaxMdoaJDjjufrpqKThYhNE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhao Heming <heming.zhao@suse.com>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>, linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 105/147] md/bitmap: md_bitmap_get_counter returns wrong blocks
Date:   Mon, 26 Oct 2020 19:48:23 -0400
Message-Id: <20201026234905.1022767-105-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026234905.1022767-1-sashal@kernel.org>
References: <20201026234905.1022767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Zhao Heming <heming.zhao@suse.com>

[ Upstream commit d837f7277f56e70d82b3a4a037d744854e62f387 ]

md_bitmap_get_counter() has code:

```
    if (bitmap->bp[page].hijacked ||
        bitmap->bp[page].map == NULL)
        csize = ((sector_t)1) << (bitmap->chunkshift +
                      PAGE_COUNTER_SHIFT - 1);
```

The minus 1 is wrong, this branch should report 2048 bits of space.
With "-1" action, this only report 1024 bit of space.

This bug code returns wrong blocks, but it doesn't inflence bitmap logic:
1. Most callers focus this function return value (the counter of offset),
   not the parameter blocks.
2. The bug is only triggered when hijacked is true or map is NULL.
   the hijacked true condition is very rare.
   the "map == null" only true when array is creating or resizing.
3. Even the caller gets wrong blocks, current code makes caller just to
   call md_bitmap_get_counter() one more time.

Signed-off-by: Zhao Heming <heming.zhao@suse.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md-bitmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index b10c51988c8ee..4894c107f72ce 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1367,7 +1367,7 @@ __acquires(bitmap->lock)
 	if (bitmap->bp[page].hijacked ||
 	    bitmap->bp[page].map == NULL)
 		csize = ((sector_t)1) << (bitmap->chunkshift +
-					  PAGE_COUNTER_SHIFT - 1);
+					  PAGE_COUNTER_SHIFT);
 	else
 		csize = ((sector_t)1) << bitmap->chunkshift;
 	*blocks = csize - (offset & (csize - 1));
-- 
2.25.1

