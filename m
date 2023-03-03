Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 974FFC7EE2D
	for <linux-raid@archiver.kernel.org>; Fri,  3 Mar 2023 16:21:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbjCCQVw (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 3 Mar 2023 11:21:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230304AbjCCQVu (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 3 Mar 2023 11:21:50 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 925A522A32
        for <linux-raid@vger.kernel.org>; Fri,  3 Mar 2023 08:21:49 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 4C20620531;
        Fri,  3 Mar 2023 16:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677860508; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nStWt9LyPd5i2JdOC1LgHiMs5zmzXfXoEFEz3VKzKSg=;
        b=0tTfT7TwtQ/eQQ3NO6BoxNOBKivw/kP9WX9b8TdG4ACVxEdHzVn+0LMZ+W95jmKv0HfgYj
        ZF7z1foosByohAEmpPJpSRUOPk2n0X4WfLMBH92/BORQKkaByj0BX8KjzNyFiN0Cuo8EEj
        aKCQaJS+cmQTVqp5dPobVWTfGmtrt4Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677860508;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nStWt9LyPd5i2JdOC1LgHiMs5zmzXfXoEFEz3VKzKSg=;
        b=O86a0ATD67hg6WJ0tYNRGEw88sOJoY236bDQ/YxdQVyzy1epHKksRPGHwwzid8N4Bhqbzt
        GdM5YgUAz7HwC7Dw==
Received: from localhost.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 69A4C2C141;
        Fri,  3 Mar 2023 16:21:46 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, mariusz.tkaczyk@linux.intel.com,
        pmenzel@molgen.mpg.de, Wu Guanghao <wuguanghao3@huawei.com>,
        Coly Li <colyli@suse.de>
Subject: [PATCH v2 4/6] isuper-intel.c: fix double free in load_imsm_mpb()
Date:   Sat,  4 Mar 2023 00:21:33 +0800
Message-Id: <20230303162135.45831-5-colyli@suse.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303162135.45831-1-colyli@suse.de>
References: <20230303162135.45831-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From: Wu Guanghao <wuguanghao3@huawei.com>

In load_imsm_mpb() there is potential double free issue on super->buf.

The first location to free super->buf is from get_super_block() <==
load_and_parse_mpb() <== load_imsm_mpb():
 4514         if (posix_memalign(&super->migr_rec_buf, MAX_SECTOR_SIZE,
 4515             MIGR_REC_BUF_SECTORS*MAX_SECTOR_SIZE) != 0) {
 4516                 pr_err("could not allocate migr_rec buffer\n");
 4517                 free(super->buf);
 4518                 return 2;
 4519         }

If the above error condition happens, super->buf is freed and value 2
is returned to get_super_block() eventually. Then in the following code
block inside load_imsm_mpb(),
 5289  error:
 5290         if (!err) {
 5291                 s->next = *super_list;
 5292                 *super_list = s;
 5293         } else {
 5294                 if (s)
 5295                         free_imsm(s);
 5296                 close_fd(&dfd);
 5297         }
at line 5295 when free_imsm() is called, super->buf is freed again from
the call chain free_imsm() <== __free_imsm(), in following code block,
 4651         if (super->buf) {
 4652                 free(super->buf);
 4653                 super->buf = NULL;
 4654         }

This patch sets super->buf as NULL after line 4517 in load_imsm_mpb()
to avoid the potential double free().

(Coly Li helps to re-compose the commit log)

Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
Reviewed-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Acked-by: Coly Li <colyli@suse.de>
---
 super-intel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/super-intel.c b/super-intel.c
index 89fac626..4a3da847 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -4515,6 +4515,7 @@ static int load_imsm_mpb(int fd, struct intel_super *super, char *devname)
 	    MIGR_REC_BUF_SECTORS*MAX_SECTOR_SIZE) != 0) {
 		pr_err("could not allocate migr_rec buffer\n");
 		free(super->buf);
+		super->buf = NULL;
 		return 2;
 	}
 	super->clean_migration_record_by_mdmon = 0;
-- 
2.39.2

