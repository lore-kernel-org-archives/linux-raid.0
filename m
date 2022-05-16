Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9BFCC433EF
	for <linux-raid@archiver.kernel.org>; Mon, 16 May 2022 18:52:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345152AbiEPSwE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 16 May 2022 14:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345149AbiEPSv5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 16 May 2022 14:51:57 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D3393EA93
        for <linux-raid@vger.kernel.org>; Mon, 16 May 2022 11:51:56 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id r71so14571157pgr.0
        for <linux-raid@vger.kernel.org>; Mon, 16 May 2022 11:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=w/vXrhHYz4hayxXTpvluCRqtSLwMXWsi89GFr9tS/YQ=;
        b=JRehcpW7+f4z4nnJVoYyyn8JTHfm9l7lwwg3/Zc+NghG/A9LUfElMU7tlAgI6zJnGo
         LKCQmvcigbZB1ml+BnZ81ev55Yy/YSw6DMFKbYvOep7hxWh/H/lxwexytzZbDoi5s68a
         gMMP2W5FrOB7qNl/5JgcTVgbYZxRV0HozsCvY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=w/vXrhHYz4hayxXTpvluCRqtSLwMXWsi89GFr9tS/YQ=;
        b=hSgXM/Zc09J6LQaDj86FNAeyxl6gc8hK/yXy0M1A4oe21Z2//dj0os4QLa3Xnah8H3
         E5Qi9P0TmrJsQDsA/A0gj8Uz8OZ0S1tY1Nj3vPKdsgTG9ZZHMvVwYNXW/7iedzRWApr+
         nAw5d73kcjzd5fm8RzylyyaTNf97tlRXjIEpK55aHNmjctLliznJISYuKlE0psUTRPcI
         M/2Dl8PMpHAhil+q4kYDsw9e2+bwvLdt9sE366ncvs1ZY2KD2Opeo7Q7ZiASBeMb0ch4
         P6dTWTtqFAmjZX/gNWO6n2bGujWfO0itiPBaZKeP1uHTPMtPsRBkSR7BWRoVG/Po/Jgv
         WR5w==
X-Gm-Message-State: AOAM532mnEeAK/l5s0II/fAfIp9ks55hjrOFeZfn3fcq+Ipd9djvCXql
        8yP2QCHd/A7heu/70+AZFdNFyQ==
X-Google-Smtp-Source: ABdhPJymcURqRMGcWWF5SnA9wwUQk3JoOR0K/mUC0Yv15khQOmO0SNCL+Q4Njsx+FkSULBV01/EO0w==
X-Received: by 2002:a63:4387:0:b0:3c6:9490:4e4b with SMTP id q129-20020a634387000000b003c694904e4bmr16157541pga.438.1652727116092;
        Mon, 16 May 2022 11:51:56 -0700 (PDT)
Received: from localhost ([2620:15c:11a:202:4ee0:ca4c:63fd:81d2])
        by smtp.gmail.com with UTF8SMTPSA id b2-20020a170902650200b0015e8d4eb264sm7480975plk.174.2022.05.16.11.51.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 May 2022 11:51:55 -0700 (PDT)
Date:   Mon, 16 May 2022 11:51:54 -0700
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Song Liu <song@kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH v3 1/3] dm: Add verity helpers for LoadPin
Message-ID: <YoKdSrjVf/tHGoa5@google.com>
References: <20220504195419.1143099-1-mka@chromium.org>
 <20220504125404.v3.1.I3e928575a23481121e73286874c4c2bdb403355d@changeid>
 <02028CEA-5704-4A51-8CAD-BEE53CEF7CCA@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <02028CEA-5704-4A51-8CAD-BEE53CEF7CCA@chromium.org>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, May 13, 2022 at 03:15:53PM -0700, Kees Cook wrote:
> 
> 
> On May 4, 2022 12:54:17 PM PDT, Matthias Kaehlcke <mka@chromium.org> wrote:
> >LoadPin limits loading of kernel modules, firmware and certain
> >other files to a 'pinned' file system (typically a read-only
> >rootfs). To provide more flexibility LoadPin is being extended
> >to also allow loading these files from trusted dm-verity
> >devices. For that purpose LoadPin can be provided with a list
> >of verity root digests that it should consider as trusted.
> >
> >Add a bunch of helpers to allow LoadPin to check whether a DM
> >device is a trusted verity device. The new functions broadly
> >fall in two categories: those that need access to verity
> >internals (like the root digest), and the 'glue' between
> >LoadPin and verity. The new file dm-verity-loadpin.c contains
> >the glue functions.
> >
> >Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> > [...]
> >diff --git a/drivers/md/dm-verity-loadpin.c b/drivers/md/dm-verity-loadpin.c
> >new file mode 100644
> >index 000000000000..972ca93a2231
> >--- /dev/null
> >+++ b/drivers/md/dm-verity-loadpin.c
> >@@ -0,0 +1,80 @@
> >+// SPDX-License-Identifier: GPL-2.0-only
> >+
> >+#include <linux/list.h>
> >+#include <linux/kernel.h>
> >+#include <linux/dm-verity-loadpin.h>
> >+
> >+#include "dm.h"
> >+#include "dm-verity.h"
> >+
> >+static struct list_head *trusted_root_digests;
> 
> Does this need to exist in two places? (i.e. why can't dm and loadpin share
> this instead of needing dm_verity_loadpin_set_trusted_digests()?)

We could share it. Probably it should then be defined here, since this is
the first patch of the series, we could add an extern declaration to
dm-verity-loadpin.h.

> >+
> >+/*
> >+ * Sets the root digests of verity devices which LoadPin considers as trusted.
> >+ *
> >+ * This function must only be called once.
> >+ */
> >+void dm_verity_loadpin_set_trusted_root_digests(struct list_head *digests)
> >+{
> >+	if (!trusted_root_digests)
> >+		trusted_root_digests = digests;
> >+	else
> >+		pr_warn("verity root digests trusted by LoadPin are already set!!!\n");
> >+}
> >+
> >+static bool is_trusted_verity_target(struct dm_target *ti)
> >+{
> >+	u8 *root_digest;
> >+	unsigned int digest_size;
> >+	struct trusted_root_digest *trd;
> >+	bool trusted = false;
> >+
> >+	if (!dm_is_verity_target(ti))
> >+		return false;
> >+
> >+	if (dm_verity_get_root_digest(ti, &root_digest, &digest_size))
> >+		return false;
> >+
> >+	list_for_each_entry(trd, trusted_root_digests, node) {
> >+		if ((trd->len == digest_size) &&
> >+		    !memcmp(trd->data, root_digest, digest_size)) {
> >+			trusted = true;
> >+			break;
> >+		}
> >+	}
> >+
> >+	kfree(root_digest);
> >+
> >+	return trusted;
> >+}
> >+
> >+/*
> >+ * Determines whether a mapped device is a verity device that is trusted
> >+ * by LoadPin.
> >+ */
> >+bool dm_verity_loadpin_is_md_trusted(struct mapped_device *md)
> >+{
> >+	int srcu_idx;
> >+	struct dm_table *table;
> >+	unsigned int num_targets;
> >+	bool trusted = false;
> >+	int i;
> >+
> >+	if (!trusted_root_digests || list_empty(trusted_root_digests))
> >+		return false;
> >+
> >+	table = dm_get_live_table(md, &srcu_idx);
> >+	num_targets = dm_table_get_num_targets(table);
> >+	for (i = 0; i < num_targets; i++) {
> >+		struct dm_target *ti = dm_table_get_target(table, i);
> >+
> >+		if (is_trusted_verity_target(ti)) {
> >+			trusted = true;
> >+			break;
> >+		}
> >+	}
> 
> Pardon my lack of dm vocabulary, but what is "target" vs "table" here?
> I was only thinking of "whole device", so I must not understand what this is
> examining.

'targets' are different types of DM mappings like 'linear' or 'verity'. A
device mapper table contains has one or more targets that define the mapping
of the blocks of the mapped device.

Having spelled that out I realize that the above check is wrong. It would
consider a device like this trusted:

0 10000000 linear 8:1
10000000 10001000 verity <params>

In the above case only a small part of the DM device would be backed by verity.

I think we want a table with a single entry that is a verity target.

> > [...]
> >diff --git a/include/linux/dm-verity-loadpin.h b/include/linux/dm-verity-loadpin.h
> >new file mode 100644
> >index 000000000000..12a86911d05a
> >--- /dev/null
> >+++ b/include/linux/dm-verity-loadpin.h
> >@@ -0,0 +1,27 @@
> >+/* SPDX-License-Identifier: GPL-2.0 */
> >+
> >+#ifndef __LINUX_DM_VERITY_LOADPIN_H
> >+#define __LINUX_DM_VERITY_LOADPIN_H
> >+
> >+#include <linux/list.h>
> >+
> >+struct mapped_device;
> >+
> >+struct trusted_root_digest {
> >+	u8 *data;
> >+	unsigned int len;
> >+	struct list_head node;
> >+};
> 
> To avoid the double-alloc in patch 2 (and save 1 pointer size of memory), this could just be:
> 
> struct trusted_root_digest {
> 	struct list_head node;
> 	unsigned int len;
> 	u8 data[];
> };

Looks good to me, will change

> Otherwise, looks good to me!

Excellent, thanks for the review!
