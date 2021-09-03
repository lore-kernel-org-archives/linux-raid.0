Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5710CC433F5
	for <linux-raid@archiver.kernel.org>; Fri,  3 Sep 2021 17:27:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D841610A2
	for <linux-raid@archiver.kernel.org>; Fri,  3 Sep 2021 17:27:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350066AbhICR2O (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 3 Sep 2021 13:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235723AbhICR2N (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 3 Sep 2021 13:28:13 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C9C4C061575
        for <linux-raid@vger.kernel.org>; Fri,  3 Sep 2021 10:27:13 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id jg16so10350098ejc.1
        for <linux-raid@vger.kernel.org>; Fri, 03 Sep 2021 10:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bwENXuaqbcdQli6+7dsuRY9CBfbnku/pXemwHYmqk9M=;
        b=qUg+s7iuYlMYK4h8yIp73irZRQGOPnhXc7Qy17hIWsGx7T1JxZFpA0Zx00P35M1cWI
         xSnwWZuaQWxMXf/LHKNzDfA/ACAOY5ujZgWMbQ91LnzQ/p9aUcuEylqvNRU/Xhf8am5Q
         qJzBP6dG7eSPpAOi/WZHxa+I7ojl8OiUI0hhjptqxuLDQzZ4oaD7oiqNfr+lCp1UJWwT
         8n0cr2JmoBccw3GZtT7bWsNMIsrbnlzm8zr+8WZh6pAeylDzKmUnc95/ed3rq6MnlPDi
         JJ5xh0k95WNo2RDHZ01TEEgazkWdRlBup/SctOzugvP5cTlj9yqftMn+wQ1XZVyBwQjD
         KajA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bwENXuaqbcdQli6+7dsuRY9CBfbnku/pXemwHYmqk9M=;
        b=SGLMCWILr6DXptH64MS1rZroPTNIS1/I+MmGTiMybaVwcKj1UNIibF2K+docCoXEi9
         /NcIRvGKRGn419VWxiEzglGFsnDUBxhRIha8carMPfyYpz3Lwm97F/Lodppjyb7BZFHb
         y11Lipu7YGIU4IzHoXU6nMXxc6LnDiYKfg3v3eiHsLWS4TD1vt5TynBxrGURmh9TRb+l
         d/ePVF7GRCkia61oikLSR9FeUjnoJizUWJnvYX8qlxT+b/1mL/HQuliO0JFdXfwK+Cym
         GZW1EFFmqOL3BoEmRVBSpnM7w7sRg60SXMW+QuJeOad8QVX8CSnjuRfHLewVOUnxQ15z
         Zdzg==
X-Gm-Message-State: AOAM532ecbmhw6kbwzxrrxULpnIbmyVbRRAxksJuWnsXnoGsOkRXF+Sp
        BgI1bK5dY/QFx65aCw1WUPhiwdYwZsaWJNQL9IkC
X-Google-Smtp-Source: ABdhPJzUWGfT3TcAG0kDymkiG/yFfedV0cLPQ2pAPRl8q1JV8EyWgRLgVCmFOS9fs9h1imNJZUlL+YhQJu2bGatzEt4=
X-Received: by 2002:a17:906:8cd:: with SMTP id o13mr5458543eje.341.1630690031596;
 Fri, 03 Sep 2021 10:27:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210831191845.7928-1-michael.weiss@aisec.fraunhofer.de> <20210831191845.7928-2-michael.weiss@aisec.fraunhofer.de>
In-Reply-To: <20210831191845.7928-2-michael.weiss@aisec.fraunhofer.de>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 3 Sep 2021 13:27:00 -0400
Message-ID: <CAHC9VhSa6mMAPocicaMNsWJr6eMsM7G6Ap6Ywoy8m89cCf=txg@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] dm: introduce audit event module for device mapper
To:     =?UTF-8?Q?Michael_Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>
Cc:     Casey Schaufler <casey@schaufler-ca.com>,
        Song Liu <song@kernel.org>, Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-audit@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Aug 31, 2021 at 3:19 PM Michael Wei=C3=9F
<michael.weiss@aisec.fraunhofer.de> wrote:
>
> To be able to send auditing events to user space, we introduce a
> generic dm-audit module. It provides helper functions to emit audit
> events through the kernel audit subsystem. We claim the
> AUDIT_DM_CTRL type=3D1336 and AUDIT_DM_EVENT type=3D1337 out of the
> audit event messages range in the corresponding userspace api in
> 'include/uapi/linux/audit.h' for those events.
>
> AUDIT_DM_CTRL is used to provide information about creation and
> destruction of device mapper targets which are triggered by user space
> admin control actions.
> AUDIT_DM_EVENT is used to provide information about actual errors
> during operation of the mapped device, showing e.g. integrity
> violations in audit log.
>
> Following commits to device mapper targets actually will make use of
> this to emit those events in relevant cases.
>
> The audit logs look like this if executing the following simple test:
>
>  # dd if=3D/dev/zero of=3Dtest.img bs=3D1M count=3D1024
>  # losetup -f test.img
>  # integritysetup -vD format --integrity sha256 -t 32 /dev/loop0
>  # integritysetup open -D /dev/loop0 --integrity sha256 integritytest
>  # integritysetup status integritytest
>  # integritysetup close integritytest
>  # integritysetup open -D /dev/loop0 --integrity sha256 integritytest
>  # integritysetup status integritytest
>  # dd if=3D/dev/urandom of=3D/dev/loop0 bs=3D512 count=3D1 seek=3D100000
>  # dd if=3D/dev/mapper/integritytest of=3D/dev/null
>
> -------------------------
> audit.log from auditd
>
> type=3DUNKNOWN[1336] msg=3Daudit(1630425039.363:184): module=3Dintegrity
> op=3Dctr ppid=3D3807 pid=3D3819 auid=3D1000 uid=3D0 gid=3D0 euid=3D0 suid=
=3D0 fsuid=3D0
> egid=3D0 sgid=3D0 fsgid=3D0 tty=3Dpts2 ses=3D3 comm=3D"integritysetup"
> exe=3D"/sbin/integritysetup" subj=3D=3Dunconfined dev=3D254:3
> error_msg=3D'success' res=3D1
> type=3DUNKNOWN[1336] msg=3Daudit(1630425039.471:185): module=3Dintegrity
> op=3Ddtr ppid=3D3807 pid=3D3819 auid=3D1000 uid=3D0 gid=3D0 euid=3D0 suid=
=3D0 fsuid=3D0
> egid=3D0 sgid=3D0 fsgid=3D0 tty=3Dpts2 ses=3D3 comm=3D"integritysetup"
> exe=3D"/sbin/integritysetup" subj=3D=3Dunconfined dev=3D254:3
> error_msg=3D'success' res=3D1
> type=3DUNKNOWN[1336] msg=3Daudit(1630425039.611:186): module=3Dintegrity
> op=3Dctr ppid=3D3807 pid=3D3819 auid=3D1000 uid=3D0 gid=3D0 euid=3D0 suid=
=3D0 fsuid=3D0
> egid=3D0 sgid=3D0 fsgid=3D0 tty=3Dpts2 ses=3D3 comm=3D"integritysetup"
> exe=3D"/sbin/integritysetup" subj=3D=3Dunconfined dev=3D254:3
> error_msg=3D'success' res=3D1
> type=3DUNKNOWN[1336] msg=3Daudit(1630425054.475:187): module=3Dintegrity
> op=3Ddtr ppid=3D3807 pid=3D3819 auid=3D1000 uid=3D0 gid=3D0 euid=3D0 suid=
=3D0 fsuid=3D0
> egid=3D0 sgid=3D0 fsgid=3D0 tty=3Dpts2 ses=3D3 comm=3D"integritysetup"
> exe=3D"/sbin/integritysetup" subj=3D=3Dunconfined dev=3D254:3
> error_msg=3D'success' res=3D1
>
> type=3DUNKNOWN[1336] msg=3Daudit(1630425073.171:191): module=3Dintegrity
> op=3Dctr ppid=3D3807 pid=3D3883 auid=3D1000 uid=3D0 gid=3D0 euid=3D0 suid=
=3D0 fsuid=3D0
> egid=3D0 sgid=3D0 fsgid=3D0 tty=3Dpts2 ses=3D3 comm=3D"integritysetup"
> exe=3D"/sbin/integritysetup" subj=3D=3Dunconfined dev=3D254:3
> error_msg=3D'success' res=3D1
>
> type=3DUNKNOWN[1336] msg=3Daudit(1630425087.239:192): module=3Dintegrity
> op=3Ddtr ppid=3D3807 pid=3D3902 auid=3D1000 uid=3D0 gid=3D0 euid=3D0 suid=
=3D0 fsuid=3D0
> egid=3D0 sgid=3D0 fsgid=3D0 tty=3Dpts2 ses=3D3 comm=3D"integritysetup"
> exe=3D"/sbin/integritysetup" subj=3D=3Dunconfined dev=3D254:3
> error_msg=3D'success' res=3D1
>
> type=3DUNKNOWN[1336] msg=3Daudit(1630425093.755:193): module=3Dintegrity
> op=3Dctr ppid=3D3807 pid=3D3906 auid=3D1000 uid=3D0 gid=3D0 euid=3D0 suid=
=3D0 fsuid=3D0
> egid=3D0 sgid=3D0 fsgid=3D0 tty=3Dpts2 ses=3D3 comm=3D"integritysetup"
> exe=3D"/sbin/integritysetup" subj=3D=3Dunconfined dev=3D254:3
> error_msg=3D'success' res=3D1
>
> type=3DUNKNOWN[1337] msg=3Daudit(1630425112.119:194): module=3Dintegrity
> op=3Dintegrity-checksum dev=3D254:3 sector 77480 res=3D0
> type=3DUNKNOWN[1337] msg=3Daudit(1630425112.119:195): module=3Dintegrity
> op=3Dintegrity-checksum dev=3D254:3 sector 77480 res=3D0
> type=3DUNKNOWN[1337] msg=3Daudit(1630425112.119:196): module=3Dintegrity
> op=3Dintegrity-checksum dev=3D254:3 sector 77480 res=3D0
> type=3DUNKNOWN[1337] msg=3Daudit(1630425112.119:197): module=3Dintegrity
> op=3Dintegrity-checksum dev=3D254:3 sector 77480 res=3D0
> type=3DUNKNOWN[1337] msg=3Daudit(1630425112.119:198): module=3Dintegrity
> op=3Dintegrity-checksum dev=3D254:3 sector 77480 res=3D0
> type=3DUNKNOWN[1337] msg=3Daudit(1630425112.119:199): module=3Dintegrity
> op=3Dintegrity-checksum dev=3D254:3 sector 77480 res=3D0
> type=3DUNKNOWN[1337] msg=3Daudit(1630425112.119:200): module=3Dintegrity
> op=3Dintegrity-checksum dev=3D254:3 sector 77480 res=3D0
> type=3DUNKNOWN[1337] msg=3Daudit(1630425112.119:201): module=3Dintegrity
> op=3Dintegrity-checksum dev=3D254:3 sector 77480 res=3D0
> type=3DUNKNOWN[1337] msg=3Daudit(1630425112.119:202): module=3Dintegrity
> op=3Dintegrity-checksum dev=3D254:3 sector 77480 res=3D0
> type=3DUNKNOWN[1337] msg=3Daudit(1630425112.119:203): module=3Dintegrity
> op=3Dintegrity-checksum dev=3D254:3 sector 77480 res=3D0
>
> Signed-off-by: Michael Wei=C3=9F <michael.weiss@aisec.fraunhofer.de>
> ---
>  drivers/md/Kconfig         | 10 +++++
>  drivers/md/Makefile        |  4 ++
>  drivers/md/dm-audit.c      | 79 ++++++++++++++++++++++++++++++++++++++
>  drivers/md/dm-audit.h      | 62 ++++++++++++++++++++++++++++++
>  include/uapi/linux/audit.h |  2 +
>  5 files changed, 157 insertions(+)
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
> index a74aaf8b1445..2f83d649500d 100644
> --- a/drivers/md/Makefile
> +++ b/drivers/md/Makefile
> @@ -103,3 +103,7 @@ endif
>  ifeq ($(CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG),y)
>  dm-verity-objs                 +=3D dm-verity-verify-sig.o
>  endif
> +
> +ifeq ($(CONFIG_DM_AUDIT),y)
> +dm-mod-objs                    +=3D dm-audit.o
> +endif
> diff --git a/drivers/md/dm-audit.c b/drivers/md/dm-audit.c
> new file mode 100644
> index 000000000000..761ecfdcd49a
> --- /dev/null
> +++ b/drivers/md/dm-audit.c
> @@ -0,0 +1,79 @@
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
> +static struct audit_buffer *dm_audit_log_start(int audit_type,
> +                                              const char *dm_msg_prefix,
> +                                              const char *op)
> +{
> +       struct audit_buffer *ab;
> +
> +       if (audit_enabled =3D=3D AUDIT_OFF)
> +               return NULL;
> +
> +       ab =3D audit_log_start(audit_context(), GFP_KERNEL, audit_type);
> +       if (unlikely(!ab))
> +               return NULL;
> +
> +       audit_log_format(ab, "module=3D%s op=3D%s", dm_msg_prefix, op);
> +       return ab;
> +}
> +
> +void dm_audit_log_ti(int audit_type, const char *dm_msg_prefix, const ch=
ar *op,
> +                    struct dm_target *ti, int result)
> +{
> +       struct audit_buffer *ab;
> +       struct mapped_device *md =3D dm_table_get_md(ti->table);
> +       int dev_major =3D dm_disk(md)->major;
> +       int dev_minor =3D dm_disk(md)->first_minor;
> +
> +       ab =3D dm_audit_log_start(audit_type, dm_msg_prefix, op);
> +       if (unlikely(!ab))
> +               return;
> +
> +       switch (audit_type) {
> +       case AUDIT_DM_CTRL:
> +               audit_log_task_info(ab);
> +               audit_log_format(ab, " dev=3D%d:%d error_msg=3D'%s'", dev=
_major,
> +                                dev_minor, !result ? ti->error : "succes=
s");
> +               break;
> +       case AUDIT_DM_EVENT:
> +               audit_log_format(ab, " dev=3D%d:%d sector=3D?", dev_major=
,
> +                                dev_minor);
> +               break;
> +       }
> +       audit_log_format(ab, " res=3D%d", result);
> +       audit_log_end(ab);
> +}
> +EXPORT_SYMBOL_GPL(dm_audit_log_ti);

Just checking, but are you okay when the inevitable happens and
someone passes an @audit_type that is not either AUDIT_CM_CTRL or
AUDIT_DM_EVENT?  Right now that will succeed without error and give a
rather short audit record.

> +void dm_audit_log_bio(const char *dm_msg_prefix, const char *op,
> +                     struct bio *bio, sector_t sector, int result)
> +{
> +       struct audit_buffer *ab;
> +       int dev_major =3D MAJOR(bio->bi_bdev->bd_dev);
> +       int dev_minor =3D MINOR(bio->bi_bdev->bd_dev);
> +
> +       ab =3D dm_audit_log_start(AUDIT_DM_EVENT, dm_msg_prefix, op);
> +       if (unlikely(!ab))
> +               return;
> +
> +       audit_log_format(ab, " dev=3D%d:%d sector %llu res=3D%d",
> +                        dev_major, dev_minor, sector, result);

I think you forgot the "=3D" after "sector", e.g. "sector=3D%llu".

> +       audit_log_end(ab);
> +}
> +EXPORT_SYMBOL_GPL(dm_audit_log_bio);

--=20
paul moore
www.paul-moore.com
