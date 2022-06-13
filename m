Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2379C433EF
	for <linux-raid@archiver.kernel.org>; Mon, 13 Jun 2022 19:19:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245724AbiFMTTy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 13 Jun 2022 15:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348926AbiFMTSY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 13 Jun 2022 15:18:24 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07623313A0
        for <linux-raid@vger.kernel.org>; Mon, 13 Jun 2022 10:15:29 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id h192so6112663pgc.4
        for <linux-raid@vger.kernel.org>; Mon, 13 Jun 2022 10:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HplHX2Dj1z/sWHxSKlJW/gqEIj/eDK55kENWjykpP0s=;
        b=DqStzqcZt8eFT2eOiyFphW3284ou3VB/B0VSmaKnmfmYTUjrRf0X39Xd+f7wilrK8O
         gCuJ5mksskKjlT9sQZJ/0W6BLQhy+PDGjGJeeZy0lNpZtIAiCoThrATw8kB79tsD1NFM
         ocxPy/XOH6QkVlvvPavuovxKddyLa6ngaCtUs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HplHX2Dj1z/sWHxSKlJW/gqEIj/eDK55kENWjykpP0s=;
        b=Pr7lPCJ+9QwqsWcXzr3vCbW/faxEudXG/ikvRQJdATrh3OSXhIulqlC3RKFhMc2TZi
         RwOHO3A0g6eBbo6xBtpXd3rApFLLV8uUK7/mlLCXDY6ffb7wbWk9U3bmQi4edTShQBQv
         9vy9B+GH7wUBAiz40/N/CAPZRTlcCuR+EaON0gTS1Ovac7zbXtfisAnPv6Xwk/5Qn93G
         9nzUXCYA8dda0tyxkG4qIZn1cpc1ncXb1RVo5ORMGSLfu533UsyWz3v/aATHTmwQfol5
         9mw7Z/e1y55f0iLegBSWg9tQB/IMXifpYIA4uckyaMRQS3DV/2t9rbxd+cOmOy/phuR0
         HlSA==
X-Gm-Message-State: AOAM533ZenDzNM7aqKbkK7po1QHDrXmRM0Cxqfx4DtYV/pGrXTNQt5Wf
        XMi8BVnNyisVRUkRLy2Lr+LEd5eb3Ggo3A==
X-Google-Smtp-Source: ABdhPJxeMM7KYRXm0u0KsG75RyBBXv3/0OQRUh4WZMtUklEUzQc43TFu+c9tkQBt+JNomJsFdNFtlg==
X-Received: by 2002:a63:30f:0:b0:3fd:f9de:a35d with SMTP id 15-20020a63030f000000b003fdf9dea35dmr519789pgd.317.1655140528387;
        Mon, 13 Jun 2022 10:15:28 -0700 (PDT)
Received: from localhost ([2620:15c:11a:202:c4fb:a1d8:47ef:f10c])
        by smtp.gmail.com with UTF8SMTPSA id x12-20020a17090300cc00b00167705fd12asm5374876plc.135.2022.06.13.10.15.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jun 2022 10:15:27 -0700 (PDT)
Date:   Mon, 13 Jun 2022 10:15:25 -0700
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>
Cc:     Milan Broz <gmazyland@gmail.com>, dm-devel@redhat.com,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Song Liu <song@kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH v6 1/3] dm: Add verity helpers for LoadPin
Message-ID: <YqdwrWFXNtsKaTm7@google.com>
References: <20220523211400.290537-1-mka@chromium.org>
 <20220523141325.v6.1.I3e928575a23481121e73286874c4c2bdb403355d@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220523141325.v6.1.I3e928575a23481121e73286874c4c2bdb403355d@changeid>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Mike, does this look good to you or are any further changes needed
to get this landed?

Thanks

Matthias

On Mon, May 23, 2022 at 02:13:58PM -0700, Matthias Kaehlcke wrote:
> LoadPin limits loading of kernel modules, firmware and certain
> other files to a 'pinned' file system (typically a read-only
> rootfs). To provide more flexibility LoadPin is being extended
> to also allow loading these files from trusted dm-verity
> devices. For that purpose LoadPin can be provided with a list
> of verity root digests that it should consider as trusted.
> 
> Add a bunch of helpers to allow LoadPin to check whether a DM
> device is a trusted verity device. The new functions broadly
> fall in two categories: those that need access to verity
> internals (like the root digest), and the 'glue' between
> LoadPin and verity. The new file dm-verity-loadpin.c contains
> the glue functions.
> 
> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> Acked-by: Kees Cook <keescook@chromium.org>
> ---
> 
> Changes in v6:
> - s/loadpin_trusted_verity_root_digests/dm_verity_loadpin_trusted_root_digests/
> - s/trusted_root_digest/dm_verity_loadpin_trusted_root_digest/
> - removed unnecessary symbol exports
> 
> Changes in v5:
> - changed dm_verity_loadpin_is_sb_trusted() to
>   dm_verity_loadpin_is_bdev_trusted()
> - bumped version number to 1.8.1
> - deleted bad semicolon in declaration of stub for
>   dm_verity_loadpin_is_bdev_trusted()
> - added 'Acked-by' tag from Kees
> 
> Changes in v4:
> - a trusted verity device must have a single target of
>   type 'verity'
> - share list of verity digests with loadpin, deleted
>   dm_verity_loadpin_set_trusted_root_digests()
> - dm_verity_loadpin_is_md_trusted() is now dm_verity_loadpin_is_sb_trusted(),
>   it receives a super_block instead of mapped_device. Updated kernel doc.
> - changed struct trusted_root_digest to have an unsized
>   u8 array instead of a pointer
> - extend 'dm-verity-objs' instead of 'dm-mod-objs'
> 
> Changes in v3:
> - none
> 
> Changes in v2:
> - none
> 
>  drivers/md/Makefile               |  6 +++
>  drivers/md/dm-verity-loadpin.c    | 74 +++++++++++++++++++++++++++++++
>  drivers/md/dm-verity-target.c     | 33 +++++++++++++-
>  drivers/md/dm-verity.h            |  4 ++
>  include/linux/dm-verity-loadpin.h | 27 +++++++++++
>  5 files changed, 143 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/md/dm-verity-loadpin.c
>  create mode 100644 include/linux/dm-verity-loadpin.h
> 
> diff --git a/drivers/md/Makefile b/drivers/md/Makefile
> index 0454b0885b01..71771901c823 100644
> --- a/drivers/md/Makefile
> +++ b/drivers/md/Makefile
> @@ -108,6 +108,12 @@ ifeq ($(CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG),y)
>  dm-verity-objs			+= dm-verity-verify-sig.o
>  endif
>  
> +ifeq ($(CONFIG_DM_VERITY),y)
> +ifeq ($(CONFIG_SECURITY_LOADPIN),y)
> +dm-verity-objs			+= dm-verity-loadpin.o
> +endif
> +endif
> +
>  ifeq ($(CONFIG_DM_AUDIT),y)
>  dm-mod-objs			+= dm-audit.o
>  endif
> diff --git a/drivers/md/dm-verity-loadpin.c b/drivers/md/dm-verity-loadpin.c
> new file mode 100644
> index 000000000000..10c18bc1652c
> --- /dev/null
> +++ b/drivers/md/dm-verity-loadpin.c
> @@ -0,0 +1,74 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +#include <linux/list.h>
> +#include <linux/kernel.h>
> +#include <linux/dm-verity-loadpin.h>
> +
> +#include "dm.h"
> +#include "dm-verity.h"
> +
> +#define DM_MSG_PREFIX	"verity-loadpin"
> +
> +LIST_HEAD(dm_verity_loadpin_trusted_root_digests);
> +
> +static bool is_trusted_verity_target(struct dm_target *ti)
> +{
> +	u8 *root_digest;
> +	unsigned int digest_size;
> +	struct dm_verity_loadpin_trusted_root_digest *trd;
> +	bool trusted = false;
> +
> +	if (!dm_is_verity_target(ti))
> +		return false;
> +
> +	if (dm_verity_get_root_digest(ti, &root_digest, &digest_size))
> +		return false;
> +
> +	list_for_each_entry(trd, &dm_verity_loadpin_trusted_root_digests, node) {
> +		if ((trd->len == digest_size) &&
> +		    !memcmp(trd->data, root_digest, digest_size)) {
> +			trusted = true;
> +			break;
> +		}
> +	}
> +
> +	kfree(root_digest);
> +
> +	return trusted;
> +}
> +
> +/*
> + * Determines whether the file system of a superblock is located on
> + * a verity device that is trusted by LoadPin.
> + */
> +bool dm_verity_loadpin_is_bdev_trusted(struct block_device *bdev)
> +{
> +	struct mapped_device *md;
> +	struct dm_table *table;
> +	struct dm_target *ti;
> +	int srcu_idx;
> +	bool trusted = false;
> +
> +	if (list_empty(&dm_verity_loadpin_trusted_root_digests))
> +		return false;
> +
> +	md = dm_get_md(bdev->bd_dev);
> +	if (!md)
> +		return false;
> +
> +	table = dm_get_live_table(md, &srcu_idx);
> +
> +	if (dm_table_get_num_targets(table) != 1)
> +		goto out;
> +
> +	ti = dm_table_get_target(table, 0);
> +
> +	if (is_trusted_verity_target(ti))
> +		trusted = true;
> +
> +out:
> +	dm_put_live_table(md, srcu_idx);
> +	dm_put(md);
> +
> +	return trusted;
> +}
> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index 80133aae0db3..c5395e93525a 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -19,6 +19,7 @@
>  #include <linux/module.h>
>  #include <linux/reboot.h>
>  #include <linux/scatterlist.h>
> +#include <linux/string.h>
>  
>  #define DM_MSG_PREFIX			"verity"
>  
> @@ -1310,9 +1311,39 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
>  	return r;
>  }
>  
> +/*
> + * Check whether a DM target is a verity target.
> + */
> +bool dm_is_verity_target(struct dm_target *ti)
> +{
> +	return ti->type->module == THIS_MODULE;
> +}
> +
> +/*
> + * Get the root digest of a verity target.
> + *
> + * Returns a copy of the root digest, the caller is responsible for
> + * freeing the memory of the digest.
> + */
> +int dm_verity_get_root_digest(struct dm_target *ti, u8 **root_digest, unsigned int *digest_size)
> +{
> +	struct dm_verity *v = ti->private;
> +
> +	if (!dm_is_verity_target(ti))
> +		return -EINVAL;
> +
> +	*root_digest = kmemdup(v->root_digest, v->digest_size, GFP_KERNEL);
> +	if (*root_digest == NULL)
> +		return -ENOMEM;
> +
> +	*digest_size = v->digest_size;
> +
> +	return 0;
> +}
> +
>  static struct target_type verity_target = {
>  	.name		= "verity",
> -	.version	= {1, 8, 0},
> +	.version	= {1, 8, 1},
>  	.module		= THIS_MODULE,
>  	.ctr		= verity_ctr,
>  	.dtr		= verity_dtr,
> diff --git a/drivers/md/dm-verity.h b/drivers/md/dm-verity.h
> index 4e769d13473a..c832cc3e3d24 100644
> --- a/drivers/md/dm-verity.h
> +++ b/drivers/md/dm-verity.h
> @@ -129,4 +129,8 @@ extern int verity_hash(struct dm_verity *v, struct ahash_request *req,
>  extern int verity_hash_for_block(struct dm_verity *v, struct dm_verity_io *io,
>  				 sector_t block, u8 *digest, bool *is_zero);
>  
> +extern bool dm_is_verity_target(struct dm_target *ti);
> +extern int dm_verity_get_root_digest(struct dm_target *ti, u8 **root_digest,
> +				     unsigned int *digest_size);
> +
>  #endif /* DM_VERITY_H */
> diff --git a/include/linux/dm-verity-loadpin.h b/include/linux/dm-verity-loadpin.h
> new file mode 100644
> index 000000000000..fb695ecaa5d5
> --- /dev/null
> +++ b/include/linux/dm-verity-loadpin.h
> @@ -0,0 +1,27 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#ifndef __LINUX_DM_VERITY_LOADPIN_H
> +#define __LINUX_DM_VERITY_LOADPIN_H
> +
> +#include <linux/list.h>
> +
> +struct block_device;
> +
> +extern struct list_head dm_verity_loadpin_trusted_root_digests;
> +
> +struct dm_verity_loadpin_trusted_root_digest {
> +	struct list_head node;
> +	unsigned int len;
> +	u8 data[];
> +};
> +
> +#if IS_ENABLED(CONFIG_SECURITY_LOADPIN) && IS_BUILTIN(CONFIG_DM_VERITY)
> +bool dm_verity_loadpin_is_bdev_trusted(struct block_device *bdev);
> +#else
> +static inline bool dm_verity_loadpin_is_bdev_trusted(struct block_device *bdev)
> +{
> +	return false;
> +}
> +#endif
> +
> +#endif /* __LINUX_DM_VERITY_LOADPIN_H */
> -- 
> 2.36.1.124.g0e6072fb45-goog
> 
