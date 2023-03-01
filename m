Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D24B1C7EE23
	for <linux-raid@archiver.kernel.org>; Wed,  1 Mar 2023 20:41:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbjCAUlv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Mar 2023 15:41:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbjCAUlo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Mar 2023 15:41:44 -0500
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF8574BEAF
        for <linux-raid@vger.kernel.org>; Wed,  1 Mar 2023 12:41:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Cc:To:From:content-disposition;
        bh=stGI78jIhqffCka1jx/cbQWc8n0frmK0hbho5OsNw8k=; b=MssYbUh69YgZEMcTKWVwnO953K
        /bOwKJax5Nd+8iKd9bdQ+DqDxagEjTuXCQhkKg+KSY2/cFYCIW7roJMCch69nGS1KmMXx1C2evH6V
        6WS8Z9XxUcJ+diPvsFo011OSQYBc3PRcGqNVQ2bswI39XRyzTWmWsZviZDmwuZwAszd/Ivl0gTvTP
        lE9CDVkeBr5TJElyeD5TsRMLslULSqkg4e0yQzUwLGzmhmhUvANEHR+uLaxngJsDWYPyxH0PPyygq
        MfwaqCzQMKazvmnH4THeLWIrYZw0F/6uf3WTc+rIkg8r6+KHnWFe35NbRa+DYHH3mf7zX4ltpREVT
        0kp5dUYQ==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1pXTGd-006cuA-HP; Wed, 01 Mar 2023 13:41:40 -0700
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1pXTGb-000ADj-6Q; Wed, 01 Mar 2023 13:41:37 -0700
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
        Logan Gunthorpe <logang@deltatee.com>,
        Kinga Tanska <kinga.tanska@linux.intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>
Date:   Wed,  1 Mar 2023 13:41:30 -0700
Message-Id: <20230301204135.39230-3-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230301204135.39230-1-logang@deltatee.com>
References: <20230301204135.39230-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: linux-raid@vger.kernel.org, jes@trained-monkey.org, guoqing.jiang@linux.dev, xni@redhat.com, colyli@suse.de, jm@chia.net, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com, logang@deltatee.com, mariusz.tkaczyk@linux.intel.com, kinga.tanska@linux.intel.com, chaitanyak@nvidia.com, kch@nvidia.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH mdadm v7 2/7] Create: remove safe_mode_delay local variable
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

All .getinfo_super() call sets the info.safe_mode_delay variables
to a constant value, so no matter what the current state is
that function will always set it to the same value.

Create() calls .getinfo_super() multiple times while creating the array.
The value is stored in a local variable for every disk in the loop
to add disks (so the last disc call takes precedence). The local
variable is then used in the call to sysfs_set_safemode().

This can be simplified by using info.safe_mode_delay directly. The info
variable had .getinfo_super() called on it early in the function so, by the
reasoning above, it will have the same value as the local variable which
can thus be removed.

Doing this allows for factoring out code from Create() in a subsequent
patch.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Acked-by: Kinga Tanska <kinga.tanska@linux.intel.com>
Reviewed-by: Xiao Ni <xni@redhat.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Acked-by: Coly Li <colyli@suse.de>
---
 Create.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/Create.c b/Create.c
index 2e8203ecdccd..8ded81dc265d 100644
--- a/Create.c
+++ b/Create.c
@@ -137,7 +137,6 @@ int Create(struct supertype *st, char *mddev,
 	int did_default = 0;
 	int do_default_layout = 0;
 	int do_default_chunk = 0;
-	unsigned long safe_mode_delay = 0;
 	char chosen_name[1024];
 	struct map_ent *map = NULL;
 	unsigned long long newsize;
@@ -952,7 +951,6 @@ int Create(struct supertype *st, char *mddev,
 					goto abort_locked;
 				}
 				st->ss->getinfo_super(st, inf, NULL);
-				safe_mode_delay = inf->safe_mode_delay;
 
 				if (have_container && c->verbose > 0)
 					pr_err("Using %s for device %d\n",
@@ -1065,7 +1063,7 @@ int Create(struct supertype *st, char *mddev,
 						    "readonly");
 				break;
 			}
-			sysfs_set_safemode(&info, safe_mode_delay);
+			sysfs_set_safemode(&info, info.safe_mode_delay);
 			if (err) {
 				pr_err("failed to activate array.\n");
 				ioctl(mdfd, STOP_ARRAY, NULL);
-- 
2.30.2

