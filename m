Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A5C7C47082
	for <linux-raid@archiver.kernel.org>; Sat, 29 May 2021 10:31:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5292E61108
	for <linux-raid@archiver.kernel.org>; Sat, 29 May 2021 10:31:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbhE2Kce (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 29 May 2021 06:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbhE2Kcc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 29 May 2021 06:32:32 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0A88C061574;
        Sat, 29 May 2021 03:30:53 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id e11so8363111ljn.13;
        Sat, 29 May 2021 03:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=50hwPVvRZ3142s7Xo8DfIlXJUFvV9AlvxnGrY96Cr2g=;
        b=owQMaGcxk2frHqPxfCvSG5bOWEfnar1ZD3zGDO7vdOyYW4J2SSyMI7KdYqtI4idK2N
         IM/aZJRrSmE4faYljK/hYiX52c/X+uqcX836B+ichUPyGKsbkEQPHlFpxQSsWOb1HV+s
         nNvQuO4gsXMEyt5/Txiz9YOHgOZagbXsTRR/CUMmtwNVJcJF18dVJCQZMLyR+ipErcM5
         cwK6wrwD+A7Fc3ZUdK9ryrYnr7Or8fFB0lnMLoMSzrs+LJ410y85rPR2wq4jo/UbHNTl
         6VweI/nMHYhkpTIWHwlPBLGd9+JBZpZvc0vVIuAn77SrEC6gXfCRA50rtg5jMsZDVcSX
         Adgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=50hwPVvRZ3142s7Xo8DfIlXJUFvV9AlvxnGrY96Cr2g=;
        b=o5KpWhkOu4uqTYAUXhL9cS5o5Fw6wfYohq9zDtNnhCkX6WqcbPWj44K9hMAodL1mUa
         TLDzCpA3pxm7dOVKjghCGlfiwNu1cPUVff+8nYu84XOqQ7tXOgxQX5aVKDCC8+tntAXr
         Oxc4+rGQNbkOf0eLH11a2GKObQcuoVlfyZ2LY03QKYVhZ/k4SjKLCszMEafGkV7seBeV
         ps0CP4sdUTzxryNYbbofyf480rE68PBAxUKEyGWEri/Eu03CVKN2Nws1aehRXX1PL3Jl
         KefIrZI4h5fGYALa3WpIqDVyTLo0Hg4yBSH1NyllJ0Owd2bhkrHwurjfUjC5ZiEy18kK
         KFlw==
X-Gm-Message-State: AOAM532u6Xop71AR92UCcNuEIx+ilM/q3kzj4ofterYJzWOoabScZpB5
        YYq+t0vrRC5DG9ECZOgLpzU=
X-Google-Smtp-Source: ABdhPJwyN9w7uEgX9RLKeGig3ruPxN2SztK+BS13skwiGkwj7WYdhcOh2BmL31BxHfD6slaovl7+hA==
X-Received: by 2002:a2e:9844:: with SMTP id e4mr9644371ljj.500.1622284252170;
        Sat, 29 May 2021 03:30:52 -0700 (PDT)
Received: from localhost.localdomain (h-98-128-228-193.NA.cust.bahnhof.se. [98.128.228.193])
        by smtp.gmail.com with ESMTPSA id q9sm702146lfo.269.2021.05.29.03.30.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 May 2021 03:30:51 -0700 (PDT)
From:   Rikard Falkeborn <rikard.falkeborn@gmail.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>
Subject: [PATCH] md: Constify attribute_group structs
Date:   Sat, 29 May 2021 12:30:49 +0200
Message-Id: <20210529103049.5022-1-rikard.falkeborn@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The attribute_group structs are never modified, they're only passed to
sysfs_create_group() and sysfs_remove_group(). Make them const to allow
the compiler to put them in read-only memory.

Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
---
 drivers/md/md-bitmap.c | 2 +-
 drivers/md/md.c        | 6 +++---
 drivers/md/md.h        | 4 ++--
 drivers/md/raid5.c     | 2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index ea3130e11680..e29c6298ef5c 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2616,7 +2616,7 @@ static struct attribute *md_bitmap_attrs[] = {
 	&max_backlog_used.attr,
 	NULL
 };
-struct attribute_group md_bitmap_group = {
+const struct attribute_group md_bitmap_group = {
 	.name = "bitmap",
 	.attrs = md_bitmap_attrs,
 };
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 49f897fbb89b..0e40bb5618a1 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -824,7 +824,7 @@ static struct mddev *mddev_alloc(dev_t unit)
 	return ERR_PTR(error);
 }
 
-static struct attribute_group md_redundancy_group;
+static const struct attribute_group md_redundancy_group;
 
 void mddev_unlock(struct mddev *mddev)
 {
@@ -841,7 +841,7 @@ void mddev_unlock(struct mddev *mddev)
 		 * test it under the same mutex to ensure its correct value
 		 * is seen.
 		 */
-		struct attribute_group *to_remove = mddev->to_remove;
+		const struct attribute_group *to_remove = mddev->to_remove;
 		mddev->to_remove = NULL;
 		mddev->sysfs_active = 1;
 		mutex_unlock(&mddev->reconfig_mutex);
@@ -5538,7 +5538,7 @@ static struct attribute *md_redundancy_attrs[] = {
 	&md_degraded.attr,
 	NULL,
 };
-static struct attribute_group md_redundancy_group = {
+static const struct attribute_group md_redundancy_group = {
 	.name = NULL,
 	.attrs = md_redundancy_attrs,
 };
diff --git a/drivers/md/md.h b/drivers/md/md.h
index fb7eab58cfd5..31e743e2ecae 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -481,7 +481,7 @@ struct mddev {
 	atomic_t			max_corr_read_errors; /* max read retries */
 	struct list_head		all_mddevs;
 
-	struct attribute_group		*to_remove;
+	const struct attribute_group	*to_remove;
 
 	struct bio_set			bio_set;
 	struct bio_set			sync_set; /* for sync operations like
@@ -613,7 +613,7 @@ struct md_sysfs_entry {
 	ssize_t (*show)(struct mddev *, char *);
 	ssize_t (*store)(struct mddev *, const char *, size_t);
 };
-extern struct attribute_group md_bitmap_group;
+extern const struct attribute_group md_bitmap_group;
 
 static inline struct kernfs_node *sysfs_get_dirent_safe(struct kernfs_node *sd, char *name)
 {
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 841e1c1aa5e6..b0a3050aa0a4 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6930,7 +6930,7 @@ static struct attribute *raid5_attrs[] =  {
 	&ppl_write_hint.attr,
 	NULL,
 };
-static struct attribute_group raid5_attrs_group = {
+static const struct attribute_group raid5_attrs_group = {
 	.name = NULL,
 	.attrs = raid5_attrs,
 };
-- 
2.31.1

