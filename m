Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 290CAC433F5
	for <linux-raid@archiver.kernel.org>; Fri,  7 Oct 2022 20:10:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbiJGUKw (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 7 Oct 2022 16:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiJGUKv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 7 Oct 2022 16:10:51 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA08C84E71
        for <linux-raid@vger.kernel.org>; Fri,  7 Oct 2022 13:10:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Cc:To:From:content-disposition;
        bh=8+HdQMrUqSiwQ/bQ7WUV+XBrNiuINyBydc5O8rFIKBk=; b=PdTSKe7f49KBWsCyHG2MLg79XQ
        xjNHovChsBR22UBQ/j5Lt1+cm4BkrlLrCJ20463YrVfkVA2jh06P5sQCwYM3fdhVj7wTqt6hKl2jU
        I7uP5ixda76iqWPlUN2OpM6UJLiT69LDL6fPh1W1ZruaRH52QDdR6ydj2tjoVbbB8RjY9p6nDLy9A
        Bac1l6BFU9frdK9fuA7NqOUFyBvxQR7fTiQGW+XmIZ1Ou8+h9wPXOWN3bzbc9HlIxv1IAmEnRikOe
        7SAbZIAKX7bFaN5r6sgSB2l4/h6EIRGFTGxCmwF6IZY1ssCR0QvG3p6k8W1+sEUwQNs6kAosc8Lg5
        wTA5UrWw==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1ogtgA-002hCl-9n; Fri, 07 Oct 2022 14:10:43 -0600
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1ogtg7-0005Hu-Kv; Fri, 07 Oct 2022 14:10:39 -0600
From:   Logan Gunthorpe <logang@deltatee.com>
To:     linux-raid@vger.kernel.org, Jes Sorensen <jes@trained-monkey.org>
Cc:     Guoqing Jiang <guoqing.jiang@linux.dev>, Xiao Ni <xni@redhat.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Jonmichael Hands <jm@chia.net>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>,
        Logan Gunthorpe <logang@deltatee.com>
Date:   Fri,  7 Oct 2022 14:10:34 -0600
Message-Id: <20221007201037.20263-5-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221007201037.20263-1-logang@deltatee.com>
References: <20221007201037.20263-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: linux-raid@vger.kernel.org, jes@trained-monkey.org, guoqing.jiang@linux.dev, xni@redhat.com, mariusz.tkaczyk@linux.intel.com, colyli@suse.de, chaitanyak@nvidia.com, jm@chia.net, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com, logang@deltatee.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH mdadm v4 4/7] mdadm: Introduce pr_info()
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Feedback was given to avoid informational pr_err() calls that print
to stderr, even though that's done all through out the code.

Using printf() directly doesn't maintain the same format (an "mdadm"
prefix on every line.

So introduce pr_info() which prints to stdout with the same format
and use it for a couple informational pr_err() calls in Create().

Future work can make this call used in more cases.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 Create.c | 7 ++++---
 mdadm.h  | 2 ++
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/Create.c b/Create.c
index 6a0446644e04..4acda30c5256 100644
--- a/Create.c
+++ b/Create.c
@@ -984,11 +984,12 @@ int Create(struct supertype *st, char *mddev,
 
 			mdi = sysfs_read(-1, devnm, GET_VERSION);
 
-			pr_err("Creating array inside %s container %s\n",
+			pr_info("Creating array inside %s container %s\n",
 				mdi?mdi->text_version:"managed", devnm);
 			sysfs_free(mdi);
 		} else
-			pr_err("Defaulting to version %s metadata\n", info.text_version);
+			pr_info("Defaulting to version %s metadata\n",
+				info.text_version);
 	}
 
 	map_update(&map, fd2devnm(mdfd), info.text_version,
@@ -1145,7 +1146,7 @@ int Create(struct supertype *st, char *mddev,
 			ioctl(mdfd, RESTART_ARRAY_RW, NULL);
 		}
 		if (c->verbose >= 0)
-			pr_err("array %s started.\n", mddev);
+			pr_info("array %s started.\n", mddev);
 		if (st->ss->external && st->container_devnm[0]) {
 			if (need_mdmon)
 				start_mdmon(st->container_devnm);
diff --git a/mdadm.h b/mdadm.h
index 3673494e560b..18c24915e94c 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1798,6 +1798,8 @@ static inline int xasprintf(char **strp, const char *fmt, ...) {
 #endif
 #define cont_err(fmt ...) fprintf(stderr, "       " fmt)
 
+#define pr_info(fmt, args...) printf("%s: "fmt, Name, ##args)
+
 void *xmalloc(size_t len);
 void *xrealloc(void *ptr, size_t len);
 void *xcalloc(size_t num, size_t size);
-- 
2.30.2

