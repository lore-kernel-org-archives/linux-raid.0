Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA359C4338F
	for <linux-raid@archiver.kernel.org>; Wed, 18 Aug 2021 18:59:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D61D60EFE
	for <linux-raid@archiver.kernel.org>; Wed, 18 Aug 2021 18:59:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233038AbhHRS75 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 18 Aug 2021 14:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232453AbhHRS74 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 18 Aug 2021 14:59:56 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED671C0613CF
        for <linux-raid@vger.kernel.org>; Wed, 18 Aug 2021 11:59:20 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id qk33so7063903ejc.12
        for <linux-raid@vger.kernel.org>; Wed, 18 Aug 2021 11:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=U1zyi1q7r3FuL+wJh5Ih7H/8fdJI5IwoBKaDIus7E2s=;
        b=uhtyKsOOPmcbpIYQ/tuIUGQpbFG2dRI/UNRe0vUocT2cJmfJ1PDKxAdEqVbpyosFxw
         wSXtywoYBBusCCqZ/WDIaGhkNtGNcAaDprXBLa6scHS5C28HfKjlEKjUZTMKrp9uwaz2
         g8CqBr5hTdSx13/qYEbmlYSaJJXwEmb+akv0vqmRB7j82UB6EM8oyQ2ZbbthUyGJtqUt
         71aCb28ahPnhlyyiNdiPtb4FLIacGOomPXcATrSVW4Lip8C/OHIpnZ0Qb1SV8BbXsrnn
         NX/1JjYpxZcoDWCmP5rhTf8rHobd2y878ZEcJKMnsvTmualU987sgfYHWWShlIhw41kD
         eOSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=U1zyi1q7r3FuL+wJh5Ih7H/8fdJI5IwoBKaDIus7E2s=;
        b=YYzsU1NwB4tpIOBV28oADdLFRGxNarunhGOtUUrf316UKGqv4Ik6/KKc2sAKCItekH
         oyluAmm+hwiwn3xi7LDpuNb1Tq7rgnLYEkXPddMFsZ1mMb79rOpefM96WvFvHV0aMQ6t
         +IRUgu7MAcDs7dgpuzYO9SV8z55E1abNv26EmeYNUVW1yOoniWruU4mSCREvY2Nzps9U
         if7yvpdpwrcbAI8kCHpQ36hxTVdM1xw+uKvYmPEU32FkAWsyv+zL5SoUbkodNCTcug0x
         wLOg8eTT6wWz8AWUZpufioSBchYoWkAjb/l9IgeKy/YJXiDnv20zwAyHMl4dxyuFSQm1
         9GFw==
X-Gm-Message-State: AOAM531Yt2Tcj6NUYj/ck6x00SMp5iv/YnBK1QCzMNPwZqD0ynfW83E9
        oE6lCWgOqLV2G0prEIsLZClpLg7Puzs48RbQnTii
X-Google-Smtp-Source: ABdhPJw1AZje9L1Ml35RnyfG5pEKMOFRry97/jH8x8P45R8xQa7mBiF5FdtzzWX+UiP8gbrJtRQ0eTIKE4Hhkn77bD8=
X-Received: by 2002:a17:906:488a:: with SMTP id v10mr11058189ejq.91.1629313159447;
 Wed, 18 Aug 2021 11:59:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210814183359.4061-1-michael.weiss@aisec.fraunhofer.de> <20210814183359.4061-2-michael.weiss@aisec.fraunhofer.de>
In-Reply-To: <20210814183359.4061-2-michael.weiss@aisec.fraunhofer.de>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 18 Aug 2021 14:59:08 -0400
Message-ID: <CAHC9VhRB1iviuOyeqi3L4DC8LNfnkz1HXC3hdqNvqm2sZQYXMQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] dm: introduce audit event module for device mapper
To:     =?UTF-8?Q?Michael_Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>
Cc:     Casey Schaufler <casey@schaufler-ca.com>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Song Liu <song@kernel.org>, Eric Paris <eparis@redhat.com>,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-audit@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sat, Aug 14, 2021 at 2:34 PM Michael Wei=C3=9F
<michael.weiss@aisec.fraunhofer.de> wrote:
>
> To be able to send auditing events to user space, we introduce
> a generic dm-audit module. It provides helper functions to emit
> audit events through the kernel audit subsystem. We claim the
> AUDIT_DM type=3D1336 out of the audit event messages range in the
> corresponding userspace api in 'include/uapi/linux/audit.h' for
> those events.
>
> Following commits to device mapper targets actually will make
> use of this to emit those events in relevant cases.
>
> Signed-off-by: Michael Wei=C3=9F <michael.weiss@aisec.fraunhofer.de>

Hi Michael,

You went into more detail in your patchset cover letter, e.g. example
audit records, which I think would be helpful here in the commit
description so we have it as part of the git log.  I don't want to
discourage you from writing cover letters, but don't forget that the
cover letters can be lost to the ether after a couple of years whereas
the git log has a much longer lifetime (we hope!) and a tighter
binding to the related code.

> ---
>  drivers/md/Kconfig         | 10 +++++++
>  drivers/md/Makefile        |  4 +++
>  drivers/md/dm-audit.c      | 59 ++++++++++++++++++++++++++++++++++++++
>  drivers/md/dm-audit.h      | 33 +++++++++++++++++++++
>  include/uapi/linux/audit.h |  1 +
>  5 files changed, 107 insertions(+)
>  create mode 100644 drivers/md/dm-audit.c
>  create mode 100644 drivers/md/dm-audit.h
>
> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index 0602e82a9516..48adbec12148 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -608,6 +608,7 @@ config DM_INTEGRITY
>         select CRYPTO
>         select CRYPTO_SKCIPHER
>         select ASYNC_XOR
> +       select DM_AUDIT if AUDIT
>         help
>           This device-mapper target emulates a block device that has
>           additional per-sector tags that can be used for storing
> @@ -640,4 +641,13 @@ config DM_ZONED
>
>           If unsure, say N.
>
> +config DM_AUDIT
> +       bool "DM audit events"
> +       depends on AUDIT
> +       help
> +         Generate audit events for device-mapper.
> +
> +         Enables audit logging of several security relevant events in th=
e
> +         particular device-mapper targets, especially the integrity targ=
et.
> +
>  endif # MD
> diff --git a/drivers/md/Makefile b/drivers/md/Makefile
> index a74aaf8b1445..4cd47623c742 100644
> --- a/drivers/md/Makefile
> +++ b/drivers/md/Makefile
> @@ -103,3 +103,7 @@ endif
>  ifeq ($(CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG),y)
>  dm-verity-objs                 +=3D dm-verity-verify-sig.o
>  endif
> +
> +ifeq ($(CONFIG_DM_AUDIT),y)
> +dm-mod-objs                            +=3D dm-audit.o
> +endif
> diff --git a/drivers/md/dm-audit.c b/drivers/md/dm-audit.c
> new file mode 100644
> index 000000000000..c7e5824821bb
> --- /dev/null
> +++ b/drivers/md/dm-audit.c
> @@ -0,0 +1,59 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Creating audit records for mapped devices.
> + *
> + * Copyright (C) 2021 Fraunhofer AISEC. All rights reserved.
> + *
> + * Authors: Michael Wei=C3=9F <michael.weiss@aisec.fraunhofer.de>
> + */
> +
> +#include <linux/audit.h>
> +#include <linux/module.h>
> +#include <linux/device-mapper.h>
> +#include <linux/bio.h>
> +#include <linux/blkdev.h>
> +
> +#include "dm-audit.h"
> +#include "dm-core.h"
> +
> +void dm_audit_log_bio(const char *dm_msg_prefix, const char *op,
> +                     struct bio *bio, sector_t sector, int result)
> +{
> +       struct audit_buffer *ab;
> +
> +       if (audit_enabled =3D=3D AUDIT_OFF)
> +               return;
> +
> +       ab =3D audit_log_start(audit_context(), GFP_KERNEL, AUDIT_DM);
> +       if (unlikely(!ab))
> +               return;
> +
> +       audit_log_format(ab, "module=3D%s dev=3D%d:%d op=3D%s sector=3D%l=
lu res=3D%d",
> +                        dm_msg_prefix, MAJOR(bio->bi_bdev->bd_dev),
> +                        MINOR(bio->bi_bdev->bd_dev), op, sector, result)=
;
> +       audit_log_end(ab);
> +}
> +EXPORT_SYMBOL_GPL(dm_audit_log_bio);
> +
> +void dm_audit_log_target(const char *dm_msg_prefix, const char *op,
> +                        struct dm_target *ti, int result)
> +{
> +       struct audit_buffer *ab;
> +       struct mapped_device *md =3D dm_table_get_md(ti->table);
> +
> +       if (audit_enabled =3D=3D AUDIT_OFF)
> +               return;
> +
> +       ab =3D audit_log_start(audit_context(), GFP_KERNEL, AUDIT_DM);
> +       if (unlikely(!ab))
> +               return;
> +
> +       audit_log_format(ab, "module=3D%s dev=3D%s op=3D%s",
> +                        dm_msg_prefix, dm_device_name(md), op);
> +
> +       if (!result && !strcmp("ctr", op))
> +               audit_log_format(ab, " error_msg=3D'%s'", ti->error);
> +       audit_log_format(ab, " res=3D%d", result);
> +       audit_log_end(ab);
> +}

Generally speaking we try to keep a consistent format and ordering
within a given audit record type.  However you appear to have at least
three different formats for the AUDIT_DM record in this patch:

  "... module=3D%s dev=3D%d:%d op=3D%s sector=3D%llu res=3D%d"
  "... module=3D%s dev=3D%s op=3D%s error_msg=3D'%s' res=3D%d"
  "... module=3D%s dev=3D%s op=3D%s res=3D%d"

The first thing that jumps out is that some fields, e.g. "sector", are
not always present in the record; we typically handle this by using a
"?" for the field value in those cases where you would otherwise drop
the field from the record, for example the following record:

  "... module=3D%s dev=3D%s op=3D%s res=3D%d"

... would be rewritten like this:

  "... module=3D%s dev=3D%s op=3D%s sector=3D? res=3D%d"

The second thing that I noticed is that the "dev" field changes from a
"major:minor" number representation to an arbitrary string value, e.g.
"dev=3D%s".  This generally isn't something we do with audit records,
please stick to a single representation for a given audit
record-type/field combination.

--=20
paul moore
www.paul-moore.com
